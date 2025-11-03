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
        String tipoUsuario = request.getParameter("tipoUsuario");

        try {
            UsuarioDAO dao = new UsuarioDAO();
            Usuario usuario = dao.autenticar(email, senha, tipoUsuario);

            if (usuario != null) {
                HttpSession session = request.getSession();
                session.setAttribute("usuarioId", usuario.getId());
                session.setAttribute("usuarioNome", usuario.getNome());
                session.setAttribute("usuarioTipo", usuario.getTipoUsuario());

                if ("cliente".equals(usuario.getTipoUsuario())) {
                    response.sendRedirect("cliente/dashboard.jsp");
                } else if ("transportador".equals(usuario.getTipoUsuario())) {
                    response.sendRedirect("transportador/dashboard.jsp");
                } else {
                    response.sendRedirect("index.jsp");
                }
            } else {
                request.setAttribute("mensagem", "E-mail, senha ou tipo incorretos.");
                request.getRequestDispatcher("auth/login/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensagem", "Erro no sistema. Tente novamente.");
            request.getRequestDispatcher("auth/login/login.jsp").forward(request, response);
        }
    }
}
