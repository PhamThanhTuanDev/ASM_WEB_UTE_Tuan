package ute.edu.controller;

import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.NoHandlerFoundException;
import org.springframework.web.servlet.resource.NoResourceFoundException;
import jakarta.servlet.http.HttpServletResponse;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler({ NoHandlerFoundException.class, NoResourceFoundException.class })
    public String handle404(Exception ex, Model model, HttpServletResponse response) {
        response.setStatus(HttpStatus.NOT_FOUND.value());
        model.addAttribute("errorCode", "404");
        model.addAttribute("errorTitle", "Trang khong tim thay");
        model.addAttribute("errorMessage", "Trang ban dang tim kiem khong ton tai hoac da bi di chuyen.");
        return "error/error";
    }

    @ExceptionHandler(Exception.class)
    public String handle500(Exception ex, Model model, HttpServletResponse response) {
        response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
        model.addAttribute("errorCode", "500");
        model.addAttribute("errorTitle", "Loi he thong");
        model.addAttribute("errorMessage", "Da xay ra loi khong mong muon. Vui long thu lai sau.");
        return "error/error";
    }
}
