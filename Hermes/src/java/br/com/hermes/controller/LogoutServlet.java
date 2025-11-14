package br.com.hermes.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/LogoutServlet"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        encerrarSessao(request);
        response.sendRedirect(request.getContextPath() + "/auth/login/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        encerrarSessao(request);
        response.sendRedirect(request.getContextPath() + "/auth/login/login.jsp");
    }

    // ==========================================================
    // MÉTODO CENTRALIZADO PARA INVALIDAR A SESSÃO
    // ==========================================================
    private void encerrarSessao(HttpServletRequest request) {
        HttpSession session = request.getSession(false); // não cria nova sessão
        if (session != null) {
            session.invalidate();
        }
    }
}
