package br.com.hermes.controller;

import br.com.hermes.dao.FreteDAO;
import br.com.hermes.model.Frete;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "FreteTransportadorServlet", urlPatterns = {"/FreteTransportadorServlet"})
public class FreteTransportadorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("usuarioId") == null ||
            !"transportador".equalsIgnoreCase((String) session.getAttribute("usuarioTipo"))) {

            response.sendRedirect(request.getContextPath() + "/auth/login/login.jsp");
            return;
        }

        try {
            int idTransportador = (Integer) session.getAttribute("usuarioId");

            FreteDAO dao = new FreteDAO();

            // 3 fretes pendentes mais recentes do sistema (fretes disponíveis)
            List<Frete> fretesRecentes = dao.listarPendentes(3);

            request.setAttribute("fretesRecentes", fretesRecentes);

            request.getRequestDispatcher("/dashboard/transportador/transportador.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            tratarErro(request, response, "Erro ao carregar dashboard do transportador: " + e.getMessage());
        }
    }

    // ==========================================================
    // ERRO PADRONIZADO
    // ==========================================================
    private void tratarErro(HttpServletRequest request, HttpServletResponse response, String msg)
            throws ServletException, IOException {

        request.setAttribute("mensagem", msg);
        request.setAttribute("tipoMensagem", "error");
        request.getRequestDispatcher("/erro.jsp").forward(request, response);
    }
}
