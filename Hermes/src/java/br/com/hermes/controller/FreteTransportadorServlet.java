package br.com.hermes.controller;

import br.com.hermes.dao.FreteDAO;
import br.com.hermes.model.Frete;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "FreteTransportadorServlet", urlPatterns = {"/dashboardTransportador"})
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

            // Últimos 3 fretes aceitos
            List<Frete> recentes = dao.listarFretesTransportador(idTransportador);

            // Fretes disponíveis (pendentes)
            List<Frete> fretesDisponiveis = dao.listarPendentesTodos();

            // Em andamento
            List<Frete> fretesEmAndamento = dao.listarFretesEmAndamento(idTransportador);

            // Concluídos
            List<Frete> fretesConcluidos = dao.listarFretesConcluidos(idTransportador);

                        // No FreteTransportadorServlet.doGet(), adicione:
            List<Frete> fretesAceitos = dao.listarFretesAceitos(idTransportador);
            request.setAttribute("fretesAceitos", fretesAceitos);
            
            request.setAttribute("fretesRecentes", recentes);
            request.setAttribute("fretesDisponiveis", fretesDisponiveis);
            request.setAttribute("fretesEmAndamento", fretesEmAndamento);
            request.setAttribute("fretesConcluidos", fretesConcluidos);

            request.getRequestDispatcher("/dashboard/transportador/transportador.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            tratarErro(request, response, "Erro ao carregar dashboard do transportador: " + e.getMessage());
        }
    }

    private void tratarErro(HttpServletRequest request, HttpServletResponse response, String msg)
            throws ServletException, IOException {

        request.setAttribute("mensagem", msg);
        request.setAttribute("tipoMensagem", "error");
        request.getRequestDispatcher("/erro.jsp").forward(request, response);
    }
}
