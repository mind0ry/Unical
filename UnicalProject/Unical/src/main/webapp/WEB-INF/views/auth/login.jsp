<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인 - UniCal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-page">
    <div class="auth-card">
        <div style="display:flex; align-items:center; gap:8px; margin-bottom:16px;">
            <div class="app-logo-pill"></div>
            <span style="font-size:14px; font-weight:600; color:#111827;">UniCal</span>
        </div>

        <div class="auth-title">로그인</div>
        <div class="auth-subtitle">대학생을 위한 일정 관리 캘린더</div>

        <c:if test="${not empty error}">
            <div class="auth-error">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/auth/login" method="post">
            <label class="auth-label">이메일</label>
            <input class="auth-input" type="email" name="email" required>

            <label class="auth-label">비밀번호</label>
            <input class="auth-input" type="password" name="password" required>

            <button class="auth-button" type="submit">로그인</button>
        </form>

        <div class="auth-link">
            아직 계정이 없나요?
            <a href="${pageContext.request.contextPath}/auth/signup">회원가입 하기</a>
        </div>
    </div>
</div>
</body>
</html>
