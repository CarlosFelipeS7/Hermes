package br.com.hermes.controller;

import br.com.hermes.model.Usuario;
import br.com.hermes.service.UsuarioService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "FiltroDDDServlet", urlPatterns = {"/FiltroDDDServlet"})
public class FiltroDDDServlet extends HttpServlet {

    private final UsuarioService usuarioService = new UsuarioService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ddd = request.getParameter("ddd");

        try {
            if (ddd != null && !ddd.trim().isEmpty()) {
                List<Usuario> transportadores = usuarioService.buscarTransportadoresPorDDD(ddd.trim());
                request.setAttribute("transportadores", transportadores);
                request.setAttribute("dddFiltrado", ddd.trim());
            }

            request.getRequestDispatcher("/transportadores/listaTransportadores.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensagem", "Erro ao filtrar transportadores: " + e.getMessage());
            request.setAttribute("tipoMensagem", "error");
            request.getRequestDispatcher("/erro.jsp").forward(request, response);
        }
    }
}