<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입 - UniCal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script>
        // 이메일 중복 검사 (AJAX)
        function checkEmail() {
            const emailInput = document.getElementById('email');
            const msgSpan = document.getElementById('emailCheckMsg');
            const email = emailInput.value.trim();

            if (!email) {
                msgSpan.textContent = '이메일을 먼저 입력하세요.';
                msgSpan.style.color = '#b91c1c';
                return;
            }

            fetch('${pageContext.request.contextPath}/auth/check-email?email=' + encodeURIComponent(email))
                .then(res => res.text())
                .then(text => {
                    if (text === 'DUPLICATE') {
                        msgSpan.textContent = '이미 사용 중인 이메일입니다.';
                        msgSpan.style.color = '#b91c1c';
                    } else {
                        msgSpan.textContent = '사용 가능한 이메일입니다.';
                        msgSpan.style.color = '#16a34a';
                    }
                })
                .catch(err => {
                    msgSpan.textContent = '이메일 확인 중 오류가 발생했습니다.';
                    msgSpan.style.color = '#b91c1c';
                });
        }
    </script>
</head>
<body>
<div class="auth-page">
    <div class="auth-card">
        <div style="display:flex; align-items:center; gap:8px; margin-bottom:16px;">
            <div class="app-logo-pill"></div>
            <span style="font-size:14px; font-weight:600; color:#111827;">UniCal</span>
        </div>

        <div class="auth-title">회원가입</div>
        <div class="auth-subtitle">UniCal 계정을 만들어 학사 일정을 정리해보세요.</div>

        <c:if test="${not empty error}">
            <div class="auth-error">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/auth/signup" method="post">
            <label class="auth-label">이메일</label>
            <div style="display:flex; gap:6px; align-items:center; margin-bottom:4px;">
                <input class="auth-input" style="flex:1;"
                       type="email" id="email" name="email"
                       value="${email}" required>
                <button type="button" class="calendar-btn" style="font-size:12px; padding:6px 8px; margin-bottom: 30px;"
                        onclick="checkEmail()">
                    중복검사
                </button>
            </div>
            <span id="emailCheckMsg" style="font-size:11px; color:#6b7280;"></span>

            <label class="auth-label" style="margin-top:12px;">비밀번호</label>
            <input class="auth-input" type="password" name="password" required>

            <label class="auth-label">이름</label>
            <input class="auth-input" type="text" name="name" value="${name}" required>

            <label class="auth-label">대학교</label>
            <input class="auth-input" type="text" name="university"
                   value="${university}" placeholder="예: OO대학교">

            <label class="auth-label">전화번호</label>
            <input class="auth-input" type="text" name="phone"
                   value="${phone}" placeholder="예: 010-1234-5678">

            <button class="auth-button" type="submit" style="margin-top:16px;">가입하기</button>
        </form>

        <div class="auth-link">
            이미 계정이 있나요?
            <a href="${pageContext.request.contextPath}/auth/login">로그인 하기</a>
        </div>
    </div>
</div>
</body>
</html>
