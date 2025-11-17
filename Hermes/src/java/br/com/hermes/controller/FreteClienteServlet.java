package br.com.hermes.controller;

import br.com.hermes.dao.FreteDAO;
import br.com.hermes.model.Frete;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "FreteClienteServlet", urlPatterns = {"/dashboardCliente"})
public class FreteClienteServlet extends HttpServlet {

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

            FreteDAO dao = new FreteDAO();

            // Últimos 3 fretes do cliente
            List<Frete> recentes = dao.listarFretesCliente(idCliente, 3);

            request.setAttribute("fretesRecentes", recentes);

            request.getRequestDispatcher("/dashboard/cliente/cliente.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensagem", "Erro ao carregar dashboard do cliente: " + e.getMessage());
            request.setAttribute("tipoMensagem", "error");
            request.getRequestDispatcher("/erro.jsp").forward(request, response);
        }
    }
}
