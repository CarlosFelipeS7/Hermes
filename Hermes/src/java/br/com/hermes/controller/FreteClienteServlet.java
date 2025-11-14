package br.com.hermes.controller;

import br.com.hermes.dao.FreteDAO;
import br.com.hermes.model.Frete;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "FreteClienteDashboardServlet", urlPatterns = {"/dashboardCliente"})
public class FreteClienteServlet extends HttpServlet {

    private final FreteDAO dao = new FreteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("usuarioId") == null ||
            !"cliente".equalsIgnoreCase((String) session.getAttribute("usuarioTipo"))) {

            response.sendRedirect(request.getContextPath() + "/auth/login/login.jsp");
            return;
        }

        try {
            int idCliente = (Integer) session.getAttribute("usuarioId");

            // PEGAR SOMENTE 3 FRETES RECENTES DO CLIENTE
            List<Frete> recentes = dao.listarFretesCliente(idCliente, 3);

            // ENVIAR PARA O JSP
            request.setAttribute("fretesRecentes", recentes);

            // ENVIAR PARA O PAINEL
            request.getRequestDispatcher("/dashboard/cliente/cliente.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensagem", "Erro ao carregar painel: " + e.getMessage());
            request.setAttribute("tipoMensagem", "error");
            request.getRequestDispatcher("/erro.jsp")
                   .forward(request, response);
        }
    }
}
