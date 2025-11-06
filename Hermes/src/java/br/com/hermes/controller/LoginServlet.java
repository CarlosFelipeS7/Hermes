package br.com.hermes.controller;

import br.com.hermes.dao.UsuarioDAO;
import br.com.hermes.model.Usuario;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        try {
            UsuarioDAO dao = new UsuarioDAO();
            Usuario usuario = dao.autenticar(email, senha);

            if (usuario != null) {
                HttpSession session = request.getSession();
                session.setAttribute("usuarioId", usuario.getId());
                session.setAttribute("usuarioNome", usuario.getNome());
                session.setAttribute("usuarioTipo", usuario.getTipoUsuario());

                // Redirecionamento automático conforme o tipo
                String tipo = usuario.getTipoUsuario();
                if ("cliente".equalsIgnoreCase(tipo)) {
                    response.sendRedirect(request.getContextPath() + "/dashboard/clientes/clientes.jsp");
                } else if ("transportador".equalsIgnoreCase(tipo)) {
                    response.sendRedirect(request.getContextPath() + "/dashboard/transportador/transportador.jsp");
                } else {
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
                }

            } else {
                request.setAttribute("mensagem", "E-mail ou senha incorretos.");
                request.setAttribute("tipoMensagem", "error");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/auth/login/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensagem", "Erro no sistema. Tente novamente.");
            request.setAttribute("tipoMensagem", "error");
            request.getRequestDispatcher("/auth/login/login.jsp").forward(request, response);
        }
    }
}
