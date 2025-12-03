package br.com.hermes.controller;

import br.com.hermes.service.UsuarioService;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ExcluirUsuarioServlet", urlPatterns = {"/ExcluirUsuarioServlet"})
public class ExcluirUsuarioServlet extends HttpServlet {

    private final UsuarioService usuarioService = new UsuarioService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false);
        
        try {
            // Verificar sessão
            if (session == null || session.getAttribute("usuarioId") == null) {
                out.print("{\"success\": false, \"message\": \"Sessão expirada. Faça login novamente.\"}");
                return;
            }
            
            int idUsuario = (Integer) session.getAttribute("usuarioId");
            System.out.println("🗑️ Excluindo usuário ID: " + idUsuario);
            
            // Excluir o usuário
            usuarioService.excluir(idUsuario);
            
            System.out.println("✅ Usuário excluído com sucesso!");
            
            // Invalidar sessão
            session.invalidate();
            
            // Retornar sucesso
            out.print("{\"success\": true, \"message\": \"Conta excluída com sucesso!\"}");
            
        } catch (Exception e) {
            System.err.println("❌ Erro ao excluir usuário: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Erro ao excluir conta: " + e.getMessage().replace("\"", "'") + "\"}");
        }
    }
}