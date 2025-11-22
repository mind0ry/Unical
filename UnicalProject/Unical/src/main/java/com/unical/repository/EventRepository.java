package com.unical.repository;

import com.unical.domain.CalendarEntity;
import com.unical.domain.EventEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;

public interface EventRepository extends JpaRepository<EventEntity, Long> {

    List<EventEntity> findByCalendarAndStartDatetimeBetween(
            CalendarEntity calendar,
            LocalDateTime start,
            LocalDateTime end
    );
}
