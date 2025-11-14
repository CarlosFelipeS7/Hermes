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

        // ===========================
        // 1) Validar login
        // ===========================
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login/login.jsp");
            return;
        }

        try {
            // ===========================
            // 2) Campos do formulário
            // ===========================
            String idFreteStr = request.getParameter("idFrete");
            String notaStr = request.getParameter("nota");
            String comentario = request.getParameter("comentario");

            int idFrete = Integer.parseInt(idFreteStr);
            int nota = Integer.parseInt(notaStr);

            // ===========================
            // 3) Upload da foto
            // ===========================
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

            // ===========================
            // 4) Criar objeeto Avaliacao
            // ===========================
            Avaliacao av = new Avaliacao();
            av.setIdFrete(idFrete);
            av.setNota(nota);
            av.setComentario(comentario);
            av.setFoto(nomeFoto);

            // ===========================
            // 5) Salvar via SERVICE
            // ===========================
            avaliacaoService.avaliar(av);

            // ===========================
            // 6) Redirecionar para sucesso
            // ===========================
            response.sendRedirect(request.getContextPath() + "/pages/avaliacao/enviado.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            redirecionarErro(request, response, e.getMessage());
        }
    }

    // ===========================
    // ERRO PADRONIZADO
    // ===========================
    private void redirecionarErro(HttpServletRequest request, HttpServletResponse response, String msg)
            throws IOException {

        request.getSession().setAttribute("mensagemErroAvaliacao", msg);
        response.sendRedirect(request.getContextPath() + "/pages/avaliacao/erro.jsp");
    }
}
