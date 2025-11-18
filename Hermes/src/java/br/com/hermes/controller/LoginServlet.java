package br.com.hermes.controller;

import br.com.hermes.model.Usuario;
import br.com.hermes.service.UsuarioService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    private final UsuarioService usuarioService = new UsuarioService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        try {
            // ============================================
            // AUTENTICAÇÃO VIA SERVICE (NÃO MAIS DAO)
            // ============================================
            Usuario usuario = usuarioService.autenticar(email, senha);

            // Criar sessão do usuário
            HttpSession session = request.getSession();
            session.setAttribute("usuarioId", usuario.getId());
            session.setAttribute("usuarioNome", usuario.getNome());
            session.setAttribute("usuarioTipo", usuario.getTipoUsuario());

            // Redireciona conforme o tipo
            redirecionarUsuario(usuario, request, response);

        } catch (Exception e) {
            e.printStackTrace();
            enviarErro(e.getMessage(), email, request, response);
        }
    }

    // =====================================================
    // Redirecionamento por tipo de usuário
    // =====================================================
    private void redirecionarUsuario(Usuario usuario,
                                     HttpServletRequest request,
                                     HttpServletResponse response)
            throws IOException {

        String tipo = usuario.getTipoUsuario().toLowerCase();

        switch (tipo) {
            case "cliente":
                response.sendRedirect(request.getContextPath() +
                        "/index.jsp");
                break;

            case "transportador":
                response.sendRedirect(request.getContextPath() +
                        "/index.jsp");
                break;

            case "admin":
            case "administrador":
                response.sendRedirect(request.getContextPath() +
                        "/dashboard/admin/admin.jsp");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }

    // =====================================================
    // Método para enviar erros para o login
    // =====================================================
    private void enviarErro(String mensagem, String email,
                            HttpServletRequest request,
                            HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("mensagem", mensagem);
        request.setAttribute("tipoMensagem", "error");
        request.setAttribute("email", email);

        request.getRequestDispatcher("/auth/login/login.jsp")
                .forward(request, response);
    }
}
