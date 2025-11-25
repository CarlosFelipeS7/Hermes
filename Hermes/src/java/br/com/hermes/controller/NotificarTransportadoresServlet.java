package br.com.hermes.controller;

import br.com.hermes.dao.FreteDAO;
import br.com.hermes.dao.NotificacaoDAO;
import br.com.hermes.dao.UsuarioDAO;
import br.com.hermes.model.Frete;
import br.com.hermes.model.Notificacao;
import br.com.hermes.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "NotificarTransportadoresServlet", urlPatterns = {"/NotificarTransportadoresServlet"})
public class NotificarTransportadoresServlet extends HttpServlet {

    private final FreteDAO freteDAO = new FreteDAO();
    private final NotificacaoDAO notificacaoDAO = new NotificacaoDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Buscar todos os fretes pendentes
            List<Frete> fretesPendentes = freteDAO.listarPendentesTodos();
            
            for (Frete frete : fretesPendentes) {
                // Buscar transportadores do mesmo DDD
                List<Usuario> transportadores = usuarioDAO.listarTransportadoresPorDDD(frete.getDddOrigem());
                
                for (Usuario transportador : transportadores) {
                    // Verificar se já existe notificação para este frete e transportador
                    boolean notificacaoExistente = verificarNotificacaoExistente(frete.getId(), transportador.getId());
                    
                    if (!notificacaoExistente) {
                        // Criar notificação
                        Notificacao notificacao = new Notificacao();
                        notificacao.setIdUsuario(transportador.getId());
                        notificacao.setTitulo("Novo Frete Disponível! 📦");
                        notificacao.setMensagem(
                            "Há um novo frete disponível na sua região (DDD " + frete.getDddOrigem() + "): " +
                            frete.getOrigem() + " → " + frete.getDestino() + " - " + 
                            String.format("R$ %.2f", frete.getValor())
                        );
                        notificacao.setTipo("novo_frete_disponivel");
                        notificacao.setIdFrete(frete.getId());
                        
                        notificacaoDAO.inserir(notificacao);
                    }
                }
            }
            
            response.getWriter().println("Transportadores notificados com sucesso!");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Erro ao notificar transportadores: " + e.getMessage());
        }
    }
    
    private boolean verificarNotificacaoExistente(int idFrete, int idTransportador) throws Exception {
        // Implementar lógica para verificar se já existe notificação
        // Por enquanto, retornar false (sempre criar nova notificação)
        return false;
    }
}