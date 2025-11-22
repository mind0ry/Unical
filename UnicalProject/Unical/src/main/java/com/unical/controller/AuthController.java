package com.unical.controller;

import com.unical.domain.User;
import com.unical.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.Optional;

@Controller
@RequiredArgsConstructor
@RequestMapping("/auth")
public class AuthController {

    private final UserRepository userRepository;

    @GetMapping("/signup")
    public String signupForm() {
        return "auth/signup";
    }

    /** 회원가입 (이메일 중복 검사 포함) */
    @PostMapping("/signup")
    public String signup(@RequestParam String email,
                         @RequestParam String password,
                         @RequestParam String name,
                         @RequestParam(required = false) String university,
                         @RequestParam(required = false) String phone,
                         Model model) {

        // 이메일 중복 체크
        if (userRepository.existsByEmail(email)) {
            model.addAttribute("error", "이미 사용 중인 이메일입니다.");
            // 사용자가 입력했던 값 유지
            model.addAttribute("email", email);
            model.addAttribute("name", name);
            model.addAttribute("university", university);
            model.addAttribute("phone", phone);
            return "auth/signup";
        }

        User user = new User();
        user.setEmail(email);
        // TODO: 실제 서비스에서는 비밀번호 암호화 필요
        user.setPassword(password);
        user.setName(name);
        user.setUniversity(university);
        user.setPhone(phone);
        user.setStatus("ACTIVE");
        user.setCreatedAt(LocalDateTime.now());

        userRepository.save(user);

        return "redirect:/auth/login";
    }

    @GetMapping("/login")
    public String loginForm() {
        return "auth/login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email,
                        @RequestParam String password,
                        HttpSession session,
                        Model model) {

        Optional<User> opt = userRepository.findByEmail(email);
        if (opt.isPresent()) {
            User user = opt.get();
            if (user.getPassword().equals(password) && "ACTIVE".equals(user.getStatus())) {
                session.setAttribute("loginUser", user);
                return "redirect:/calendar";
            }
        }
        model.addAttribute("error", "이메일 또는 비밀번호가 올바르지 않습니다.");
        model.addAttribute("email", email);
        return "auth/login";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/auth/login";
    }

    /** 이메일 중복 AJAX 체크용 */
    @GetMapping("/check-email")
    @ResponseBody
    public String checkEmail(@RequestParam String email) {
        boolean exists = userRepository.existsByEmail(email);
        return exists ? "DUPLICATE" : "OK";
    }

    /** 프로필 보기/수정 폼 */
    @GetMapping("/profile")
    public String profileForm(HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/auth/login";
        }

        Optional<User> opt = userRepository.findById(loginUser.getId());
        if (opt.isEmpty()) {
            session.invalidate();
            return "redirect:/auth/login";
        }

        model.addAttribute("user", opt.get());
        return "auth/profile";
    }

    /** 프로필 수정 처리 */
    @PostMapping("/profile")
    public String updateProfile(@RequestParam String name,
                                @RequestParam(required = false) String university,
                                @RequestParam(required = false) String phone,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/auth/login";
        }

        Optional<User> opt = userRepository.findById(loginUser.getId());
        if (opt.isEmpty()) {
            session.invalidate();
            return "redirect:/auth/login";
        }

        User user = opt.get();
        user.setName(name);
        user.setUniversity(university);
        user.setPhone(phone);

        userRepository.save(user);

        // 세션 갱신
        session.setAttribute("loginUser", user);

        // 수정 완료 표시용
        redirectAttributes.addFlashAttribute("updated", true);

        return "redirect:/auth/profile";
    }

    /** 계정 탈퇴 (soft delete) */
    @PostMapping("/delete")
    public String deleteAccount(HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser != null) {
            Optional<User> opt = userRepository.findById(loginUser.getId());
            if (opt.isPresent()) {
                User user = opt.get();
                user.setStatus("DELETED");
                user.setDeletedAt(LocalDateTime.now());
                userRepository.save(user);
            }
            session.invalidate();
        }
        return "redirect:/auth/login";
    }
}
