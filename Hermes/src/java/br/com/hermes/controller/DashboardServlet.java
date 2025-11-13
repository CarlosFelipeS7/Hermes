package br.com.hermes.controller;

import br.com.hermes.dao.FreteDAO;
import br.com.hermes.model.Frete;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/DashboardServlet"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String tipoUsuario = (String) session.getAttribute("usuarioTipo");
        Integer idUsuario = (Integer) session.getAttribute("usuarioId");

        if (idUsuario == null || tipoUsuario == null) {
            response.sendRedirect("auth/login/login.jsp");
            return;
        }

        try {
            FreteDAO dao = new FreteDAO();

            if ("cliente".equalsIgnoreCase(tipoUsuario)) {
                List<Frete> fretes = dao.listarFretesCliente(idUsuario, 5);
                request.setAttribute("fretesCliente", fretes);
                request.getRequestDispatcher("dashboard/cliente/cliente.jsp")
                       .forward(request, response);

            } else if ("transportador".equalsIgnoreCase(tipoUsuario)) {
                List<Frete> fretes = dao.listarTresRecentes(); // 3 últimos
                request.setAttribute("fretesRecentes", fretes);
                request.getRequestDispatcher("dashboard/transportador/transportador.jsp")
                       .forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensagem", "Erro ao carregar dashboard: " + e.getMessage());
            request.getRequestDispatcher("erro.jsp").forward(request, response);
        }
    }
}
