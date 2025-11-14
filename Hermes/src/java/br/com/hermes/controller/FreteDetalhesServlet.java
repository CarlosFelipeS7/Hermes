package br.com.hermes.controller;

import br.com.hermes.dao.FreteDAO;
import br.com.hermes.model.Frete;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "FreteDetalhesServlet", urlPatterns = {"/FreteDetalhesServlet"})
public class FreteDetalhesServlet extends HttpServlet {

    private final FreteDAO dao = new FreteDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int idFrete = Integer.parseInt(req.getParameter("idFrete"));
            Frete f = dao.buscarPorId(idFrete);

            req.setAttribute("freteDetalhes", f);
            req.getRequestDispatcher("/fretes/modalFrete.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            resp.getWriter().println("Erro ao carregar detalhes: " + e.getMessage());
        }
    }
}
