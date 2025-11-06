package br.com.hermes.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/LogoutServlet"})
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false); // não cria nova sessão
        if (session != null) {
            session.invalidate(); // limpa tudo
        }
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}
