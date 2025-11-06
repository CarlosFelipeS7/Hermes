package br.com.hermes.controller;

import br.com.hermes.model.Frete;
import br.com.hermes.service.FreteService;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "FreteServlet", urlPatterns = {"/FreteServlet"})
public class FreteServlet extends HttpServlet {

    private final FreteService service = new FreteService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String origem = request.getParameter("origem");
        String destino = request.getParameter("destino");
        String descricao = request.getParameter("observacoes");
        String pesoStr = request.getParameter("peso");
        double peso = 0;
        double valor = 0;

        try {
            if (pesoStr != null && !pesoStr.isEmpty()) {
                peso = Double.parseDouble(pesoStr);
            }

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("usuarioId") == null) {
                request.setAttribute("mensagem", "⚠️ É necessário estar logado para solicitar um frete.");
                request.setAttribute("tipoMensagem", "error");
                request.getRequestDispatcher("fretes/solicitarFretes.jsp").forward(request, response);
                return;
            }

            int idCliente = (int) session.getAttribute("usuarioId");

            Frete f = new Frete();
            f.setOrigem(origem);
            f.setDestino(destino);
            f.setDescricaoCarga(descricao);
            f.setPeso(peso);
            f.setValor(valor);
            f.setIdCliente(idCliente);

            service.cadastrarFrete(f);

            // 🔹 Sucesso
            request.setAttribute("mensagem", "✅ Frete solicitado com sucesso!");
            request.setAttribute("tipoMensagem", "success");
            request.getRequestDispatcher("fretes/solicitarFretes.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("mensagem", "❌ O campo peso deve ser numérico.");
            request.setAttribute("tipoMensagem", "error");
            request.getRequestDispatcher("fretes/solicitarFretes.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensagem", "❌ Erro ao cadastrar frete: " + e.getMessage());
            request.setAttribute("tipoMensagem", "error");
            request.getRequestDispatcher("fretes/solicitarFretes.jsp").forward(request, response);
        }
    }
}
