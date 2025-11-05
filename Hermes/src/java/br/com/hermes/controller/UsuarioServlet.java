package br.com.hermes.controller;

import br.com.hermes.dao.UsuarioDAO;
import br.com.hermes.model.Usuario;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "UsuarioServlet", urlPatterns = {"/UsuarioServlet"})
public class UsuarioServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String tipoUsuario = request.getParameter("tipoUsuario");
        String telefone = request.getParameter("telefone");
        String endereco = request.getParameter("endereco");
        String veiculo = request.getParameter("veiculo");
        String documento = request.getParameter("documento");

        // 🔹 Validação básica
        if (nome == null || email == null || senha == null || tipoUsuario == null ||
            nome.isEmpty() || email.isEmpty() || senha.isEmpty() || tipoUsuario.isEmpty()) {

            request.setAttribute("mensagem", "⚠️ Preencha todos os campos obrigatórios!");
            request.setAttribute("tipoMensagem", "error");
            request.getRequestDispatcher("auth/cadastro/cadastro.jsp").forward(request, response);
            return;
        }

        Usuario u = new Usuario();
        u.setNome(nome);
        u.setEmail(email);
        u.setSenha(senha);
        u.setTipoUsuario(tipoUsuario);
        u.setTelefone(telefone);
        u.setEndereco(endereco);
        u.setVeiculo(veiculo);
        u.setDocumento(documento);

        try {
            UsuarioDAO dao = new UsuarioDAO();
            dao.inserir(u);

            // 🔹 Mensagem de sucesso no próprio JSP
            request.setAttribute("mensagem", "✅ Cadastro realizado com sucesso!");
            request.setAttribute("tipoMensagem", "success");
            request.getRequestDispatcher("auth/cadastro/cadastro.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensagem", "❌ Erro ao cadastrar: " + e.getMessage());
            request.setAttribute("tipoMensagem", "error");
            request.getRequestDispatcher("auth/cadastro/cadastro.jsp").forward(request, response);
        }
    }
}
