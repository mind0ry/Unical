<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>내 정보 - UniCal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const viewBox = document.getElementById('profileView');
            const formBox = document.getElementById('profileFormBox');
            const editBtn = document.getElementById('editBtn');
            const cancelBtn = document.getElementById('cancelEditBtn');

            function showView() {
                viewBox.classList.remove('hidden');
                formBox.classList.add('hidden');
            }

            function showForm() {
                viewBox.classList.add('hidden');
                formBox.classList.remove('hidden');
            }

            if (editBtn) {
                editBtn.addEventListener('click', function () {
                    showForm();
                });
            }

            if (cancelBtn) {
                cancelBtn.addEventListener('click', function (e) {
                    e.preventDefault();
                    showView();
                });
            }

            // 페이지 진입 시는 보기 모드
            showView();
        });
    </script>
</head>
<body>
<div class="auth-page">
    <div class="auth-card">
        <div style="display:flex; align-items:center; gap:8px; margin-bottom:16px;">
            <div class="app-logo-pill"></div>
            <span style="font-size:14px; font-weight:600; color:#111827;">UniCal</span>
        </div>

        <div class="auth-title">내 정보</div>
        <div class="auth-subtitle">프로필 정보를 확인하고 수정할 수 있습니다.</div>

        <c:if test="${updated}">
            <div class="auth-error" style="color:#166534; background:#ecfdf3; border-color:#bbf7d0;">
                정보가 성공적으로 수정되었습니다.
            </div>
        </c:if>

        <!-- 보기 모드 -->
        <div id="profileView">
            <div style="font-size:13px; margin-bottom:20px;">
                <strong>이메일</strong><br>
                <span>${user.email}</span>
            </div>
            <div style="font-size:13px; margin-bottom:20px;">
                <strong>이름</strong><br>
                <span>${user.name}</span>
            </div>
            <div style="font-size:13px; margin-bottom:20px;">
                <strong>대학교</strong><br>
                <span><c:out value="${empty user.university ? '- 없음 -' : user.university}"/></span>
            </div>
            <div style="font-size:13px; margin-bottom:20px;">
                <strong>전화번호</strong><br>
                <span><c:out value="${empty user.phone ? '- 없음 -' : user.phone}"/></span>
            </div>

            <button id="editBtn" class="auth-button" type="button" style="margin-top:12px;">
                정보 수정
            </button>
        </div>

        <!-- 수정 모드 -->
        <div id="profileFormBox" class="hidden" style="margin-top:8px;">
            <form action="${pageContext.request.contextPath}/auth/profile" method="post">
                <label class="auth-label">이메일 (수정 불가)</label>
                <input class="auth-input" type="email" value="${user.email}" disabled>

                <label class="auth-label">이름</label>
                <input class="auth-input" type="text" name="name" value="${user.name}" required>

                <label class="auth-label">대학교</label>
                <input class="auth-input" type="text" name="university" value="${user.university}">

                <label class="auth-label">전화번호</label>
                <input class="auth-input" type="text" name="phone" value="${user.phone}">

                <div style="display:flex; gap:8px; margin-top:12px;">
                    <button class="auth-button" type="submit" style="flex:1;">
                        저장
                    </button>
                    <button id="cancelEditBtn" class="auth-button" type="button"
                            style="flex:1; background:#6b7280;">
                        취소
                    </button>
                </div>
            </form>
        </div>

        <!-- 탈퇴 -->
        <div class="auth-link" style="margin-top:20px;">
            <form action="${pageContext.request.contextPath}/auth/delete" method="post"
                  onsubmit="return confirm('정말 탈퇴하시겠습니까? 이 작업은 되돌릴 수 없습니다.');">
                <button type="submit" class="auth-button"
                        style="background-color:#ef4444; margin-top:4px;">
                    계정 탈퇴
                </button>
            </form>
        </div>

        <div class="auth-link">
            <a href="${pageContext.request.contextPath}/calendar">캘린더로 돌아가기</a>
        </div>
    </div>
</div>
</body>
</html>
