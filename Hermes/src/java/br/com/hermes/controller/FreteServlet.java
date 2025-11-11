package br.com.hermes.controller;

import br.com.hermes.dao.FreteDAO;
import br.com.hermes.model.Frete;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "FreteServlet", urlPatterns = {"/FreteServlet"})
public class FreteServlet extends HttpServlet {

    // 🔹 LISTAR FRETES (CLIENTE OU TRANSPORTADOR)
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
                // 🔧 Corrigido: usar método que busca os fretes do cliente
                List<Frete> fretes = dao.listarFretesCliente(idUsuario, 50);
                request.setAttribute("fretes", fretes);

                // 🔧 Caminho correto do JSP
                request.getRequestDispatcher("/fretes/listaFretes.jsp").forward(request, response);

            } else if ("transportador".equalsIgnoreCase(tipoUsuario)) {
                // 🔧 Lista fretes pendentes
                List<Frete> fretes = dao.listarFretesRecentesDisponiveis(50);
                request.setAttribute("fretes", fretes);

                // 🔧 Caminho correto do JSP
                request.getRequestDispatcher("fretes/listaFretesTransportador.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensagem", "Erro ao carregar fretes: " + e.getMessage());
            request.setAttribute("tipoMensagem", "error");
            request.getRequestDispatcher("erro.jsp").forward(request, response);
        }
    }

    // 🔹 ACEITAR FRETE (TRANSPORTADOR)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer idTransportador = (Integer) session.getAttribute("usuarioId");
        String action = request.getParameter("action");

        if (idTransportador == null) {
            response.sendRedirect("auth/login/login.jsp");
            return;
        }

        try {
            if ("aceitar".equals(action)) {
                int idFrete = Integer.parseInt(request.getParameter("idFrete"));
                FreteDAO dao = new FreteDAO();
                dao.aceitarFrete(idFrete, idTransportador);

                // ✅ Feedback
                request.setAttribute("mensagem", "✅ Frete aceito com sucesso!");
                request.setAttribute("tipoMensagem", "success");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensagem", "❌ Erro ao aceitar frete: " + e.getMessage());
            request.setAttribute("tipoMensagem", "error");
        }

        // 🔄 Recarrega lista atualizada
        try {
            FreteDAO dao = new FreteDAO();
            List<Frete> fretes = dao.listarFretesRecentesDisponiveis(50);
            request.setAttribute("fretes", fretes);

            // 🔧 Caminho correto do JSP
            request.getRequestDispatcher("fretes/listaFretesTransportador.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("erro.jsp");
        }
    }
}
