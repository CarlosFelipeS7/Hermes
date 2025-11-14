package br.com.hermes.controller;

import br.com.hermes.model.Usuario;
import br.com.hermes.service.UsuarioService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "UsuarioServlet", urlPatterns = {"/UsuarioServlet"})
public class UsuarioServlet extends HttpServlet {

    private final UsuarioService usuarioService = new UsuarioService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String tipoUsuario = request.getParameter("tipoUsuario");
        String telefone = request.getParameter("telefone");

        try {
            // Criar objeto usuário
            Usuario u = new Usuario();
            u.setNome(nome);
            u.setEmail(email);
            u.setSenha(senha);
            u.setTipoUsuario(tipoUsuario);
            u.setTelefone(telefone);

            // Chamando SERVICE (não mais o DAO direto)
            usuarioService.cadastrar(u);

            // Mensagem pós-sucesso via sessão
            HttpSession session = request.getSession();
            session.setAttribute("mensagemCadastro", "Cadastro realizado com sucesso!");
            session.setAttribute("tipoMensagemCadastro", "success");

            // Redirect para login (evita reenviar formulário)
            response.sendRedirect(request.getContextPath() + "/auth/login/login.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            enviarErro(request, response, e.getMessage());
        }
    }

    // ==========================================================
    // MÉTODOS AUXILIARES
    // ==========================================================
    private void enviarErro(HttpServletRequest request, HttpServletResponse response, String mensagem)
            throws ServletException, IOException {

        request.setAttribute("mensagem", mensagem);
        request.setAttribute("tipoMensagem", "error");

        request.getRequestDispatcher("/auth/cadastro/cadastro.jsp")
                .forward(request, response);
    }
}
