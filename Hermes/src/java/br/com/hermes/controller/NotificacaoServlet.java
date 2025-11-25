package br.com.hermes.controller;

import br.com.hermes.dao.NotificacaoDAO;
import br.com.hermes.model.Notificacao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "NotificacaoServlet", urlPatterns = {"/NotificacaoServlet"})
public class NotificacaoServlet extends HttpServlet {

    private final NotificacaoDAO notificacaoDAO = new NotificacaoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login/login.jsp");
            return;
        }

        int idUsuario = (Integer) session.getAttribute("usuarioId");

        try {
            String action = request.getParameter("action");
            
            if ("marcarLida".equals(action)) {
                // Marcar notificação específica como lida
                int idNotificacao = Integer.parseInt(request.getParameter("id"));
                notificacaoDAO.marcarComoLida(idNotificacao);
                response.sendRedirect(request.getContextPath() + "/notificacoes.jsp");
                return;
            }
            
            if ("marcarTodasLidas".equals(action)) {
                // Marcar TODAS as notificações do usuário como lidas
                notificacaoDAO.marcarTodasComoLidas(idUsuario);
                response.sendRedirect(request.getContextPath() + "/notificacoes.jsp");
                return;
            }

            // Listar notificações do usuário
            List<Notificacao> notificacoes = notificacaoDAO.listarPorUsuario(idUsuario);
            
            // Contar notificações não lidas
            int naoLidas = notificacaoDAO.contarNaoLidas(idUsuario);

            request.setAttribute("notificacoes", notificacoes);
            request.setAttribute("naoLidas", naoLidas);
            
            // Encaminhar para a página de notificações
            request.getRequestDispatcher("/notificacoes.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensagem", "Erro ao carregar notificações: " + e.getMessage());
            request.getRequestDispatcher("/erro.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}