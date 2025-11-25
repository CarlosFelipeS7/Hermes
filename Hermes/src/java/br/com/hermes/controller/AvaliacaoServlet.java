package br.com.hermes.controller;

import br.com.hermes.model.Avaliacao;
import br.com.hermes.service.AvaliacaoService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet(name = "AvaliacaoServlet", urlPatterns = {"/AvaliacaoServlet"})
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5MB
public class AvaliacaoServlet extends HttpServlet {

    private final AvaliacaoService avaliacaoService = new AvaliacaoService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Validar login
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login/login.jsp");
            return;
        }

        try {
            // Campos do formulário
            String idFreteStr = request.getParameter("idFrete");
            String notaStr = request.getParameter("nota");
            String comentario = request.getParameter("comentario");

            int idFrete = Integer.parseInt(idFreteStr);
            int nota = Integer.parseInt(notaStr);

            // Upload da foto
            Part fotoPart = request.getPart("foto");
            String nomeFoto = null;

            if (fotoPart != null && fotoPart.getSize() > 0) {
                String uploadPath = request.getServletContext().getRealPath("/uploads");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();

                String originalName = fotoPart.getSubmittedFileName();
                nomeFoto = System.currentTimeMillis() + "_" + originalName;
                fotoPart.write(uploadPath + File.separator + nomeFoto);
            }

            // Criar objeto Avaliacao
            Avaliacao av = new Avaliacao();
            av.setIdFrete(idFrete);
            av.setNota(nota);
            av.setComentario(comentario);
            av.setFoto(nomeFoto);

            // Salvar via SERVICE (que já inclui as notificações)
            avaliacaoService.avaliar(av);

            // Redirecionar para sucesso
            request.setAttribute("mensagem", "Avaliação enviada com sucesso! O transportador foi notificado.");
            request.setAttribute("tipoMensagem", "success");
            request.getRequestDispatcher("/fretes/avaliacaoSucesso.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensagem", "Erro ao enviar avaliação: " + e.getMessage());
            request.setAttribute("tipoMensagem", "error");
            request.getRequestDispatcher("/fretes/avaliacaoFretes.jsp").forward(request, response);
        }
    }
}