package com.unical.controller;

import com.unical.domain.CalendarEntity;
import com.unical.domain.EventEntity;
import com.unical.domain.User;
import com.unical.repository.CalendarRepository;
import com.unical.repository.EventRepository;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.*;
import java.time.temporal.TemporalAdjusters;
import java.util.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("/calendar")
public class CalendarController {

    private final CalendarRepository calendarRepository;
    private final EventRepository eventRepository;

    @GetMapping
    public String viewCalendar(@RequestParam(required = false) Integer year,
                               @RequestParam(required = false) Integer month,
                               HttpSession session,
                               Model model) {

        User user = (User) session.getAttribute("loginUser");
        if (user == null) {
            return "redirect:/auth/login";
        }

        // 오늘 기준
        LocalDate today = LocalDate.now();

        // 파라미터 없으면 오늘 기준 연/월
        if (year == null || month == null) {
            year = today.getYear();
            month = today.getMonthValue();
        }

        YearMonth ym = YearMonth.of(year, month);

        // 달력 범위: 해당 월이 포함된 주의 일요일~토요일
        LocalDate firstOfMonth = ym.atDay(1);
        LocalDate lastOfMonth = ym.atEndOfMonth();

        LocalDate calendarStart =
                firstOfMonth.with(TemporalAdjusters.previousOrSame(DayOfWeek.SUNDAY));
        LocalDate calendarEnd =
                lastOfMonth.with(TemporalAdjusters.nextOrSame(DayOfWeek.SATURDAY));

        // 화면용 날짜 리스트
        List<LocalDate> days = new ArrayList<>();
        LocalDate cursor = calendarStart;
        while (!cursor.isAfter(calendarEnd)) {
            days.add(cursor);
            cursor = cursor.plusDays(1);
        }

        // 유저 기본 캘린더
        CalendarEntity calendar = calendarRepository.findByUser(user).stream()
                .findFirst()
                .orElseGet(() -> {
                    CalendarEntity c = new CalendarEntity();
                    c.setUser(user);
                    c.setName(user.getName() + "의 캘린더");
                    c.setDefault(true);
                    return calendarRepository.save(c);
                });

        // 이 달력 범위 안의 이벤트 조회 (그리드용)
        LocalDateTime rangeStart = calendarStart.atStartOfDay();
        LocalDateTime rangeEnd = calendarEnd.atTime(LocalTime.MAX);

        List<EventEntity> events =
                eventRepository.findByCalendarAndStartDatetimeBetween(calendar, rangeStart, rangeEnd);

        // 날짜별로 이벤트 묶기 (Map<LocalDate, List<EventEntity>>)
        Map<LocalDate, List<EventEntity>> eventsByDate = new HashMap<>();
        for (EventEntity e : events) {
            LocalDate d = e.getStartDatetime().toLocalDate();
            eventsByDate.computeIfAbsent(d, k -> new ArrayList<>()).add(e);
        }

        // =========================
        //  오늘 일정 / 다가오는 3일
        // =========================

        // 오늘 일정: 오늘 00:00 ~ 23:59:59.999
        LocalDateTime todayStart = today.atStartOfDay();
        LocalDateTime todayEnd = today.atTime(LocalTime.MAX);

        List<EventEntity> todayEvents =
                eventRepository.findByCalendarAndStartDatetimeBetween(calendar, todayStart, todayEnd);

        // 다가오는 3일: 내일부터 3일 뒤까지
        LocalDate upcomingStartDate = today.plusDays(1);
        LocalDate upcomingEndDate = today.plusDays(3);

        LocalDateTime upcomingStart = upcomingStartDate.atStartOfDay();
        LocalDateTime upcomingEnd = upcomingEndDate.atTime(LocalTime.MAX);

        List<EventEntity> upcomingEvents =
                eventRepository.findByCalendarAndStartDatetimeBetween(calendar, upcomingStart, upcomingEnd);

        // 이전/다음 달
        YearMonth prevYm = ym.minusMonths(1);
        YearMonth nextYm = ym.plusMonths(1);

        model.addAttribute("calendar", calendar);
        model.addAttribute("loginUser", user);

        model.addAttribute("currentYm", ym);
        model.addAttribute("days", days);
        model.addAttribute("eventsByDate", eventsByDate);
        model.addAttribute("today", today);

        // 사이드바용 데이터
        model.addAttribute("todayEvents", todayEvents);
        model.addAttribute("upcomingEvents", upcomingEvents);

        model.addAttribute("prevYear", prevYm.getYear());
        model.addAttribute("prevMonth", prevYm.getMonthValue());
        model.addAttribute("nextYear", nextYm.getYear());
        model.addAttribute("nextMonth", nextYm.getMonthValue());

        return "calendar/index";
    }

    /** 새 일정 등록 */
    @PostMapping("/event")
    public String createEvent(@RequestParam String title,
                              @RequestParam
                              @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
                              LocalDate date,
                              @RequestParam String startTime,
                              @RequestParam String endTime,
                              @RequestParam String category,
                              HttpSession session) {

        User user = (User) session.getAttribute("loginUser");
        if (user == null) return "redirect:/auth/login";

        CalendarEntity calendar = calendarRepository.findByUser(user).get(0);

        LocalTime st = (startTime == null || startTime.isBlank())
                ? LocalTime.of(9, 0)
                : LocalTime.parse(startTime);

        LocalTime et = (endTime == null || endTime.isBlank())
                ? LocalTime.of(10, 0)
                : LocalTime.parse(endTime);

        EventEntity event = new EventEntity();
        event.setCalendar(calendar);
        event.setTitle(title);
        event.setStartDatetime(LocalDateTime.of(date, st));
        event.setEndDatetime(LocalDateTime.of(date, et));
        event.setCategory(category);

        eventRepository.save(event);

        return "redirect:/calendar?year=" + date.getYear() + "&month=" + date.getMonthValue();
    }

    /** 일정 수정 */
    @PostMapping("/event/update")
    public String updateEvent(@RequestParam Long id,
                              @RequestParam String title,
                              @RequestParam
                              @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
                              LocalDate date,
                              @RequestParam String startTime,
                              @RequestParam String endTime,
                              @RequestParam String category) {

        Optional<EventEntity> opt = eventRepository.findById(id);
        if (opt.isEmpty()) {
            return "redirect:/calendar";
        }

        EventEntity event = opt.get();

        LocalTime st = (startTime == null || startTime.isBlank())
                ? event.getStartDatetime().toLocalTime()
                : LocalTime.parse(startTime);

        LocalTime et = (endTime == null || endTime.isBlank())
                ? event.getEndDatetime().toLocalTime()
                : LocalTime.parse(endTime);

        event.setTitle(title);
        event.setStartDatetime(LocalDateTime.of(date, st));
        event.setEndDatetime(LocalDateTime.of(date, et));
        event.setCategory(category);

        eventRepository.save(event);

        return "redirect:/calendar?year=" + date.getYear() + "&month=" + date.getMonthValue();
    }

    /** 일정 삭제 */
    @PostMapping("/event/delete")
    public String deleteEvent(@RequestParam Long id) {
        Optional<EventEntity> opt = eventRepository.findById(id);
        if (opt.isPresent()) {
            EventEntity e = opt.get();
            LocalDate date = e.getStartDatetime().toLocalDate();
            eventRepository.delete(e);
            return "redirect:/calendar?year=" + date.getYear() + "&month=" + date.getMonthValue();
        }
        return "redirect:/calendar";
    }
}
