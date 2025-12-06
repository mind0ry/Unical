<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>내 캘린더 - UniCal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<style>
/* 전체 사이드바 섹션 카드 */
.app-sidebar .sidebar-section {
  background: #e5edff;           /* 확실히 다른 색 */
  border-radius: 12px;
  padding: 12px 14px;
  margin-bottom: 16px;
  border: 1px solid #c7d2fe;
}

/* 섹션 제목 (오늘 일정 / 다가오는 3일) */
.app-sidebar .sidebar-section-title {
  font-size: 12px;
  font-weight: 700;
  color: #4b5563;
  margin-bottom: 8px;
}

.app-sidebar .sidebar-empty {
  font-size: 11px;
  color: #6b7280;
}

/* 각 일정 카드 하나 */
.app-sidebar .sidebar-event {
  padding: 8px 10px;
  border-radius: 8px;
  background: #ffffff;
  border: 1px solid #e5e7eb;
  margin-bottom: 8px;
}

/* 날짜 라인 (예: 2025-12-06, 오늘) */
.app-sidebar .sidebar-event-date-line {
  font-size: 11px;
  color: #6b7280;
  margin-bottom: 3px;
}

/* 점 + 제목 한 줄 */
.app-sidebar .sidebar-event-main {
  display: flex;
  align-items: center;
  gap: 6px;
  margin-bottom: 2px;
}

/* 카테고리 색 점 */
.app-sidebar .sidebar-event-dot {
  width: 8px;
  height: 8px;
  border-radius: 999px;
  display: inline-block;
}

/* 카테고리별 색상 */
.app-sidebar .sidebar-event-dot.event-pill--lecture {
  background-color: #3b82f6; /* 강의 (파랑) */
}
.app-sidebar .sidebar-event-dot.event-pill--assign {
  background-color: #f97316; /* 과제 (주황) */
}
.app-sidebar .sidebar-event-dot.event-pill--exam {
  background-color: #ef4444; /* 시험 (빨강) */
}
.app-sidebar .sidebar-event-dot.event-pill--team {
  background-color: #22c55e; /* 팀플 (초록) */
}
.app-sidebar .sidebar-event-dot.event-pill--personal {
  background-color: #6b7280; /* 개인 (회색) */
}

/* 제목 텍스트 */
.app-sidebar .sidebar-event-title-text {
  font-size: 12px;
  font-weight: 500;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* 시간 표시 */
.app-sidebar .sidebar-event-meta {
  font-size: 11px;
  color: #6b7280;
  margin-left: 14px; /* 점+제목 정렬 맞추려고 들여쓰기 */
}
</style>
</head>
<body>
<div class="app-shell">

    <!-- 상단바 -->
    <header class="app-topbar">
        <div class="app-logo">
            <div class="app-logo-pill"></div>
            <span>UniCal · Calendar</span>
        </div>
        <div class="app-topbar-right">
            <span>${loginUser.name}</span>
            <a href="${pageContext.request.contextPath}/auth/profile"
               class="link-profile">
                내 정보
            </a>
            <form action="${pageContext.request.contextPath}/auth/logout" method="get" style="margin:0;">
                <button class="calendar-btn" type="submit">로그아웃</button>
            </form>
        </div>
    </header>

    <div class="app-main">
        <!-- 좌측 사이드 -->
        <aside class="app-sidebar">
            <div class="app-sidebar-title" style="margin-bottom:14px;">${calendar.name}</div>


            <!-- 오늘 / 다가오는 일정 요약 -->
            <section class="sidebar-section">
                <div class="sidebar-section-title">오늘 일정</div>
                <c:choose>
                    <c:when test="${empty todayEvents}">
                        <div class="sidebar-empty">오늘 일정이 없습니다.</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="e" items="${todayEvents}">
                            <c:set var="categoryClass" value="event-pill--personal" />
                            <c:choose>
                                <c:when test="${e.category == 'LECTURE'}">
                                    <c:set var="categoryClass" value="event-pill--lecture" />
                                </c:when>
                                <c:when test="${e.category == 'ASSIGNMENT'}">
                                    <c:set var="categoryClass" value="event-pill--assign" />
                                </c:when>
                                <c:when test="${e.category == 'EXAM'}">
                                    <c:set var="categoryClass" value="event-pill--exam" />
                                </c:when>
                                <c:when test="${e.category == 'TEAM'}">
                                    <c:set var="categoryClass" value="event-pill--team" />
                                </c:when>
                            </c:choose>

                            <div class="sidebar-event">
                                <div class="sidebar-event-date-line">
                                    오늘
                                </div>
                                <div class="sidebar-event-main">
                                    <span class="sidebar-event-dot ${categoryClass}"></span>
                                    <span class="sidebar-event-title-text">${e.title}</span>
                                </div>
                                <div class="sidebar-event-meta">
                                    ${e.startDatetime.toLocalTime()} ~ ${e.endDatetime.toLocalTime()}
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </section>

            <section class="sidebar-section">
                <div class="sidebar-section-title">다가오는 일정</div>
                <c:choose>
                    <c:when test="${empty upcomingEvents}">
                        <div class="sidebar-empty">다가오는 3일 일정이 없습니다.</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="e" items="${upcomingEvents}">
                            <c:set var="categoryClass" value="event-pill--personal" />
                            <c:choose>
                                <c:when test="${e.category == 'LECTURE'}">
                                    <c:set var="categoryClass" value="event-pill--lecture" />
                                </c:when>
                                <c:when test="${e.category == 'ASSIGNMENT'}">
                                    <c:set var="categoryClass" value="event-pill--assign" />
                                </c:when>
                                <c:when test="${e.category == 'EXAM'}">
                                    <c:set var="categoryClass" value="event-pill--exam" />
                                </c:when>
                                <c:when test="${e.category == 'TEAM'}">
                                    <c:set var="categoryClass" value="event-pill--team" />
                                </c:when>
                            </c:choose>

                            <div class="sidebar-event">
                                <div class="sidebar-event-date-line">
                                    ${e.startDatetime.toLocalDate()}
                                </div>
                                <div class="sidebar-event-main">
                                    <span class="sidebar-event-dot ${categoryClass}"></span>
                                    <span class="sidebar-event-title-text">${e.title}</span>
                                </div>
                                <div class="sidebar-event-meta">
                                    ${e.startDatetime.toLocalTime()} ~ ${e.endDatetime.toLocalTime()}
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </section>

            <!-- 기존 카테고리 영역 -->
            <div class="app-sidebar-title">카테고리</div>

            <!-- 전체 -->
            <div class="app-sidebar-item app-sidebar-item--active" data-filter="ALL">
                <span class="app-sidebar-item-dot" style="background:#9ca3af;"></span>
                <span>전체</span>
            </div>

            <div class="app-sidebar-item" data-filter="LECTURE">
                <span class="app-sidebar-item-dot dot-lecture"></span>
                <span>강의</span>
            </div>
            <div class="app-sidebar-item" data-filter="ASSIGNMENT">
                <span class="app-sidebar-item-dot dot-assign"></span>
                <span>과제</span>
            </div>
            <div class="app-sidebar-item" data-filter="EXAM">
                <span class="app-sidebar-item-dot dot-exam"></span>
                <span>시험</span>
            </div>
            <div class="app-sidebar-item" data-filter="TEAM">
                <span class="app-sidebar-item-dot dot-team"></span>
                <span>팀플</span>
            </div>
            <div class="app-sidebar-item" data-filter="PERSONAL">
                <span class="app-sidebar-item-dot dot-personal"></span>
                <span>개인</span>
            </div>
        </aside>

        <!-- 메인 캘린더 컨텐츠 -->
        <main class="app-content">
            <!-- 상단 캘린더 헤더 -->
            <div class="calendar-header">
                <div class="calendar-title-group">
                    <div class="calendar-month">
                        ${currentYm.year}년 ${currentYm.monthValue}월
                    </div>
                    <div class="calendar-date-text">
                        오늘: ${today}
                    </div>
                </div>
                <div class="calendar-nav">
                    <a class="calendar-btn"
                       href="${pageContext.request.contextPath}/calendar?year=${prevYear}&month=${prevMonth}">◀ 이전</a>
                    <a class="calendar-btn"
                       href="${pageContext.request.contextPath}/calendar?year=${nextYear}&month=${nextMonth}">다음 ▶</a>
                    <a class="calendar-btn calendar-btn-primary"
                       href="${pageContext.request.contextPath}/calendar" style="color:#ffffff;">오늘</a>
                </div>
            </div>

            <!-- 캘린더 그리드 -->
            <section class="calendar-grid">
                <div class="calendar-grid-header">
                    <!-- ★ 일요일/토요일에 전용 클래스 추가 -->
                    <div class="calendar-grid-header-cell calendar-grid-header-cell--sun">일</div>
                    <div class="calendar-grid-header-cell">월</div>
                    <div class="calendar-grid-header-cell">화</div>
                    <div class="calendar-grid-header-cell">수</div>
                    <div class="calendar-grid-header-cell">목</div>
                    <div class="calendar-grid-header-cell">금</div>
                    <div class="calendar-grid-header-cell calendar-grid-header-cell--sat">토</div>
                </div>
                <div class="calendar-grid-body">
                    <!-- ★ varStatus 추가해서 index로 요일 판단 -->
                    <c:forEach var="day" items="${days}" varStatus="st">
                        <c:set var="isOtherMonth"
                               value="${day.monthValue != currentYm.monthValue}" />
                        <c:set var="dayEvents" value="${eventsByDate[day]}"/>

                        <div class="calendar-cell
                             <c:if test='${isOtherMonth}'> calendar-cell--outside</c:if>
                             <c:if test='${day eq today}'> calendar-cell--today</c:if>"
                             data-date="${day}">
                            <div class="
                                calendar-cell-date
                                <c:if test='${day eq today}'> calendar-cell-date--current</c:if>
                                <c:if test='${st.index % 7 == 0}'> calendar-cell-date--sun</c:if>
                                <c:if test='${st.index % 7 == 6}'> calendar-cell-date--sat</c:if>
                            ">
                                ${day.dayOfMonth}
                            </div>

                            <!-- 해당 날짜의 이벤트들 -->
                            <c:if test="${not empty dayEvents}">
                                <c:forEach var="e" items="${dayEvents}">
                                    <c:set var="categoryClass" value="event-pill--personal" />
                                    <c:choose>
                                        <c:when test="${e.category == 'LECTURE'}">
                                            <c:set var="categoryClass" value="event-pill--lecture" />
                                        </c:when>
                                        <c:when test="${e.category == 'ASSIGNMENT'}">
                                            <c:set var="categoryClass" value="event-pill--assign" />
                                        </c:when>
                                        <c:when test="${e.category == 'EXAM'}">
                                            <c:set var="categoryClass" value="event-pill--exam" />
                                        </c:when>
                                        <c:when test="${e.category == 'TEAM'}">
                                            <c:set var="categoryClass" value="event-pill--team" />
                                        </c:when>
                                    </c:choose>

                                    <div class="calendar-event-pill ${categoryClass}"
                                         data-event-id="${e.id}"
                                         data-date="${day}"
                                         data-title="${e.title}"
                                         data-start="${e.startDatetime.toLocalTime()}"
                                         data-end="${e.endDatetime.toLocalTime()}"
                                         data-category="${e.category}"
                                         title="${e.title}">
                                        ${e.title}
                                    </div>
                                </c:forEach>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
            </section>

            <!-- 이 달의 일정 리스트 -->
            <section class="event-list-section">
                <div class="event-list-title">이 달의 일정</div>
                <c:forEach var="entry" items="${eventsByDate}">
                    <c:set var="dateKey" value="${entry.key}" />
                    <c:forEach var="e" items="${entry.value}">
                        <c:set var="categoryClass" value="event-pill--personal" />
                        <c:set var="categoryLabel" value="개인" />
                        <c:choose>
                            <c:when test="${e.category == 'LECTURE'}">
                                <c:set var="categoryClass" value="event-pill--lecture" />
                                <c:set var="categoryLabel" value="강의" />
                            </c:when>
                            <c:when test="${e.category == 'ASSIGNMENT'}">
                                <c:set var="categoryClass" value="event-pill--assign" />
                                <c:set var="categoryLabel" value="과제" />
                            </c:when>
                            <c:when test="${e.category == 'EXAM'}">
                                <c:set var="categoryClass" value="event-pill--exam" />
                                <c:set var="categoryLabel" value="시험" />
                            </c:when>
                            <c:when test="${e.category == 'TEAM'}">
                                <c:set var="categoryClass" value="event-pill--team" />
                                <c:set var="categoryLabel" value="팀플" />
                            </c:when>
                        </c:choose>

                        <div class="event-item" data-category="${e.category}">
                            <div style="font-weight:500; margin-bottom:2px;" class="${categoryClass}">
                                ${e.title}
                            </div>
                            <div style="font-size:11px; color:#6b7280;">
                                날짜: ${dateKey}
                                · 시작: ${e.startDatetime.toLocalTime()}
                                · 종료: ${e.endDatetime.toLocalTime()}
                                · 카테고리: ${categoryLabel}
                            </div>
                        </div>
                    </c:forEach>
                </c:forEach>
            </section>
        </main>
    </div>
</div>

<!-- 일정 생성/수정 모달 -->
<div id="eventModal" class="modal-backdrop hidden">
    <div class="modal">
        <div class="modal-header">
            <div class="modal-title" id="modalTitle">새 일정 추가</div>
            <button type="button" id="modalClose" class="modal-close">&times;</button>
        </div>
        <div class="modal-body">
            <form id="modalEventForm"
                  action="${pageContext.request.contextPath}/calendar/event"
                  method="post">

                <!-- 수정 모드에서 사용할 id -->
                <input type="hidden" id="modalEventId" name="id"/>
                <input type="hidden" id="modalDateInput" name="date" value="${today}"/>

                <div style="font-size:12px; color:#6b7280; margin-bottom:6px;">
                    선택된 날짜: <span id="modalSelectedDate">${today}</span>
                </div>

                <div class="modal-row">
                    <label class="modal-label">제목</label>
                    <input class="modal-input" type="text" name="title" id="modalTitleInput" required>
                </div>

                <div class="modal-row" style="flex-direction:row; gap:8px;">
                    <div style="flex:1;">
                        <label class="modal-label">시작 시간</label>
                        <input class="modal-input" type="time" name="startTime" id="modalStartInput">
                    </div>
                    <div style="flex:1;">
                        <label class="modal-label">종료 시간</label>
                        <input class="modal-input" type="time" name="endTime" id="modalEndInput">
                    </div>
                </div>

                <div class="modal-row">
                    <label class="modal-label">카테고리</label>
                    <select class="modal-input" name="category" id="modalCategorySelect">
                        <option value="LECTURE">강의</option>
                        <option value="ASSIGNMENT">과제</option>
                        <option value="EXAM">시험</option>
                        <option value="TEAM">팀플</option>
                        <option value="PERSONAL">개인</option>
                    </select>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn-secondary hidden" id="modalDelete">삭제</button>
                    <button type="button" class="btn-secondary" id="modalCancel">취소</button>
                    <button type="submit" class="btn-sm" id="modalSubmit">등록</button>
                </div>
            </form>

            <!-- 삭제 전송용 폼 -->
            <form id="modalDeleteForm"
                  action="${pageContext.request.contextPath}/calendar/event/delete"
                  method="post" style="display:none;">
                <input type="hidden" name="id" id="modalDeleteId"/>
            </form>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const baseUrl = '${pageContext.request.contextPath}';

        const cells = document.querySelectorAll('.calendar-cell');
        const pills = document.querySelectorAll('.calendar-event-pill');
        const filterItems = document.querySelectorAll('.app-sidebar-item');
        const eventItems = document.querySelectorAll('.event-item');

        const modal = document.getElementById('eventModal');
        const modalForm = document.getElementById('modalEventForm');
        const modalDeleteForm = document.getElementById('modalDeleteForm');

        const modalTitle = document.getElementById('modalTitle');
        const modalClose = document.getElementById('modalClose');
        const modalCancel = document.getElementById('modalCancel');
        const modalDelete = document.getElementById('modalDelete');
        const modalSubmit = document.getElementById('modalSubmit');

        const modalEventId = document.getElementById('modalEventId');
        const modalDeleteId = document.getElementById('modalDeleteId');
        const modalDateInput = document.getElementById('modalDateInput');
        const modalSelectedDate = document.getElementById('modalSelectedDate');
        const modalTitleInput = document.getElementById('modalTitleInput');
        const modalStartInput = document.getElementById('modalStartInput');
        const modalEndInput = document.getElementById('modalEndInput');
        const modalCategorySelect = document.getElementById('modalCategorySelect');

        function normalizeTime(t) {
            if (!t) return '';
            const parts = t.split(':');
            return parts[0] + ':' + parts[1];
        }

        function openModalBase(date) {
            if (modalDateInput) modalDateInput.value = date;
            if (modalSelectedDate) modalSelectedDate.textContent = date;
            modal.classList.remove('hidden');
        }

        function setCreateMode(date) {
            modalForm.action = baseUrl + '/calendar/event';
            modalTitle.textContent = '새 일정 추가';
            modalSubmit.textContent = '등록';
            modalDelete.classList.add('hidden');

            modalEventId.value = '';
            modalTitleInput.value = '';
            modalStartInput.value = '';
            modalEndInput.value = '';
            modalCategorySelect.value = 'LECTURE';

            openModalBase(date);
        }

        function setEditMode(data) {
            modalForm.action = baseUrl + '/calendar/event/update';
            modalTitle.textContent = '일정 수정';
            modalSubmit.textContent = '수정';
            modalDelete.classList.remove('hidden');

            modalEventId.value = data.id;
            modalTitleInput.value = data.title || '';

            modalStartInput.value = normalizeTime(data.start);
            modalEndInput.value = normalizeTime(data.end);
            modalCategorySelect.value = data.category || 'PERSONAL';

            openModalBase(data.date);
        }

        function closeModal() {
            modal.classList.add('hidden');
        }

        // 날짜 셀 클릭 → 새 일정 모달
        cells.forEach(function (cell) {
            cell.addEventListener('click', function () {
                const date = cell.getAttribute('data-date');

                // 선택 표시
                cells.forEach(c => c.classList.remove('calendar-cell--selected'));
                cell.classList.add('calendar-cell--selected');

                setCreateMode(date);
            });
        });

        // 이벤트 pill 클릭 → 수정 모달
        pills.forEach(function (pill) {
            pill.addEventListener('click', function (e) {
                e.stopPropagation(); // 셀 클릭 이벤트 막기

                const data = {
                    id: pill.getAttribute('data-event-id'),
                    date: pill.getAttribute('data-date'),
                    title: pill.getAttribute('data-title'),
                    start: pill.getAttribute('data-start'),
                    end: pill.getAttribute('data-end'),
                    category: pill.getAttribute('data-category')
                };

                // 해당 날짜 셀 선택 표시
                const date = data.date;
                cells.forEach(c => {
                    if (c.getAttribute('data-date') === date) {
                        c.classList.add('calendar-cell--selected');
                    } else {
                        c.classList.remove('calendar-cell--selected');
                    }
                });

                setEditMode(data);
            });
        });

        // 모달 닫기
        if (modalClose) modalClose.addEventListener('click', closeModal);
        if (modalCancel) modalCancel.addEventListener('click', closeModal);
        modal.addEventListener('click', function (e) {
            if (e.target === modal) closeModal();
        });

        // 삭제 버튼
        if (modalDelete) {
            modalDelete.addEventListener('click', function () {
                if (!modalEventId.value) return;
                if (!confirm('이 일정을 삭제할까요?')) return;
                modalDeleteId.value = modalEventId.value;
                modalDeleteForm.submit();
            });
        }

        // 카테고리 필터
        function applyFilter(category) {
            const all = !category || category === 'ALL';

            // 캘린더 안의 pill
            document.querySelectorAll('.calendar-event-pill').forEach(p => {
                const cat = p.getAttribute('data-category');
                if (all || cat === category) {
                    p.classList.remove('hidden');
                } else {
                    p.classList.add('hidden');
                }
            });

            // 아래 리스트
            eventItems.forEach(item => {
                const cat = item.getAttribute('data-category');
                if (all || cat === category) {
                    item.classList.remove('hidden');
                } else {
                    item.classList.add('hidden');
                }
            });
        }

        filterItems.forEach(item => {
            item.addEventListener('click', function () {
                const currentActive = document.querySelector('.app-sidebar-item--active');
                const filter = item.getAttribute('data-filter');

                // 이미 선택된 필터 클릭 → 전체보기로 토글
                if (currentActive === item && filter !== 'ALL') {
                    item.classList.remove('app-sidebar-item--active');
                    const allItem = document.querySelector('.app-sidebar-item[data-filter="ALL"]');
                    if (allItem) allItem.classList.add('app-sidebar-item--active');
                    applyFilter('ALL');
                    return;
                }

                if (currentActive) currentActive.classList.remove('app-sidebar-item--active');
                item.classList.add('app-sidebar-item--active');
                applyFilter(filter);
            });
        });
    });
</script>

</body>
</html>
