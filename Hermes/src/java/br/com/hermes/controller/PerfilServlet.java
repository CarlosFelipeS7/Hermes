package br.com.hermes.controller;

import br.com.hermes.dao.UsuarioDAO;
import br.com.hermes.dao.FreteDAO;
import br.com.hermes.model.Usuario;
import br.com.hermes.model.Frete;
import br.com.hermes.model.Avaliacao;
import br.com.hermes.service.AvaliacaoService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "PerfilServlet", urlPatterns = {"/PerfilServlet"})
public class PerfilServlet extends HttpServlet {

   @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession(false);

    if (session == null || session.getAttribute("usuarioId") == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login/login.jsp");
        return;
    }

    int idUsuario = (Integer) session.getAttribute("usuarioId");
    String tipoUsuario = (String) session.getAttribute("usuarioTipo");

    System.out.println("=== DEBUG PerfilServlet ===");
    System.out.println("ID Usuario: " + idUsuario);
    System.out.println("Tipo Usuario: " + tipoUsuario);

    try {
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        Usuario usuario = usuarioDAO.buscarPorId(idUsuario);
        System.out.println("Usuario encontrado: " + (usuario != null ? usuario.getNome() : "null"));

        FreteDAO freteDAO = new FreteDAO();
        List<Frete> historico;

        if ("transportador".equalsIgnoreCase(tipoUsuario)) {
            historico = freteDAO.listarFretesTransportador(idUsuario);
        } else {
            historico = freteDAO.listarFretesCliente(idUsuario, 99999);
        }
        System.out.println("Histórico de fretes: " + (historico != null ? historico.size() : "null"));

        // ✅ Carregar dados de avaliações usando o Service
        AvaliacaoService avaliacaoService = new AvaliacaoService();
        
        if ("transportador".equalsIgnoreCase(tipoUsuario)) {
            // Para transportador: carregar avaliações recebidas
            List<Avaliacao> avaliacoes = avaliacaoService.listarAvaliacoesTransportador(idUsuario);
            double mediaAvaliacoes = avaliacaoService.calcularMediaTransportador(idUsuario);
            
            System.out.println("Avaliações recebidas: " + (avaliacoes != null ? avaliacoes.size() : "null"));
            System.out.println("Média: " + mediaAvaliacoes);
            
            request.setAttribute("avaliacoes", avaliacoes);
            request.setAttribute("mediaAvaliacoes", mediaAvaliacoes);
        } else {
            // Para cliente: carregar avaliações feitas
            List<Avaliacao> avaliacoesFeitas = avaliacaoService.listarAvaliacoesCliente(idUsuario);
            System.out.println("Avaliações feitas: " + (avaliacoesFeitas != null ? avaliacoesFeitas.size() : "null"));
            
            request.setAttribute("avaliacoesFeitas", avaliacoesFeitas);
        }

        request.setAttribute("usuario", usuario);
        request.setAttribute("historicoFretes", historico);
        request.setAttribute("tipoUsuario", tipoUsuario);

        request.getRequestDispatcher("/perfil/perfil.jsp").forward(request, response);

    } catch (Exception e) {
        System.err.println("ERRO no PerfilServlet: " + e.getMessage());
        e.printStackTrace();
        request.setAttribute("mensagem", "Erro ao carregar perfil: " + e.getMessage());
        request.getRequestDispatcher("/erro.jsp").forward(request, response);
    }
}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login/login.jsp");
            return;
        }

        int idUsuario = (Integer) session.getAttribute("usuarioId");

        try {
            UsuarioDAO dao = new UsuarioDAO();
            Usuario u = dao.buscarPorId(idUsuario);

            u.setNome(request.getParameter("nome"));
            u.setEmail(request.getParameter("email"));
            u.setTelefone(request.getParameter("telefone"));
            u.setCidade(request.getParameter("cidade"));
            u.setEstado(request.getParameter("estado"));
            u.setEndereco(request.getParameter("endereco"));
            u.setDocumento(request.getParameter("documento"));
            u.setVeiculo(request.getParameter("veiculo"));
            u.setDdd(request.getParameter("ddd"));

            dao.atualizar(u);

            // atualizar nome na sessão
            session.setAttribute("usuarioNome", u.getNome());

            response.sendRedirect(request.getContextPath() + "/PerfilServlet?ok=1");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensagem", "Erro ao atualizar perfil: " + e.getMessage());
            request.getRequestDispatcher("/erro.jsp").forward(request, response);
        }   
    }
}