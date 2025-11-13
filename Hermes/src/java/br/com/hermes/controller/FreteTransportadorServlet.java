package br.com.hermes.controller;

import br.com.hermes.dao.FreteDAO;
import br.com.hermes.model.Frete;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name="TransportadorDashboardServlet", urlPatterns={"/dashboardTransportador"})
public class FreteTransportadorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String tipo = (String) session.getAttribute("usuarioTipo");
        Integer idUser = (Integer) session.getAttribute("usuarioId");

        if (idUser == null || !"transportador".equalsIgnoreCase(tipo)) {
            response.sendRedirect("auth/login/login.jsp");
            return;
        }

        try {
            FreteDAO dao = new FreteDAO();

            List<Frete> fretes = dao.listarTresRecentes(); // 3 recentes
            System.out.println("📦 Fretes carregados para o transportador: " + fretes.size());

            request.setAttribute("fretesRecentes", fretes);

            request.getRequestDispatcher("/dashboard/transportador/transportador.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensagem", "Erro ao carregar fretes: " + e.getMessage());
            request.getRequestDispatcher("/erro.jsp").forward(request, response);
        }
    }
}
