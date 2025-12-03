package br.com.hermes.controller;

import br.com.hermes.dao.UsuarioDAO;
import br.com.hermes.service.UsuarioService;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ExcluirUsuarioServlet")
public class ExcluirUsuarioServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        PrintWriter out = response.getWriter();

        try {
            if (session == null || session.getAttribute("usuarioId") == null) {
                out.print("{\"success\":false,\"message\":\"Sessão expirada.\"}");
                return;
            }

            int idUsuario = (int) session.getAttribute("usuarioId");

            UsuarioService service = new UsuarioService();
            service.excluir(idUsuario);

            session.invalidate();

            // ✅ RESPOSTA JSON 100% VÁLIDA
            out.print("{\"success\":true}");

        } catch (Exception e) {
            e.printStackTrace();

            // ✅ SANITIZA A MENSAGEM PRA NÃO QUEBRAR O JSON
            String msg = e.getMessage();
            if (msg != null) {
                msg = msg.replace("\"", "'")
                         .replace("\n", " ")
                         .replace("\r", " ");
            } else {
                msg = "Erro interno.";
            }

            out.print("{\"success\":false,\"message\":\"" + msg + "\"}");
        }
    }
}
