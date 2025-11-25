package br.com.hermes.service;

import br.com.hermes.dao.FreteDAO;
import br.com.hermes.dao.NotificacaoDAO;
import br.com.hermes.dao.UsuarioDAO;
import br.com.hermes.model.Frete;
import br.com.hermes.model.Notificacao;
import br.com.hermes.model.Usuario;
import java.util.List;

public class FreteService {

    private final FreteDAO freteDAO = new FreteDAO();
    private final NotificacaoDAO notificacaoDAO = new NotificacaoDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    // ==========================================================
    // CRIAR FRETE
    // ==========================================================
    public void criarFrete(Frete frete) throws Exception {
        if (frete == null)
            throw new Exception("Frete inválido.");

        if (isVazio(frete.getOrigem()))
            throw new Exception("Origem não pode ser vazia.");

        if (isVazio(frete.getDestino()))
            throw new Exception("Destino não pode ser vazio.");

        if (frete.getPeso() <= 0)
            throw new Exception("Peso inválido.");

        if (frete.getPeso() > 5000)
            throw new Exception("Peso muito alto. Limite de 5000 Kg.");

        if (isVazio(frete.getDescricaoCarga()))
            throw new Exception("Descrição da carga não pode ser vazia.");

        if (frete.getIdCliente() <= 0)
            throw new Exception("ID do cliente inválido.");

        // Inserir frete
        freteDAO.inserir(frete);
    }

    // ==========================================================
    // ACEITAR FRETE COM NOTIFICAÇÃO
    // ==========================================================
    public void aceitarFrete(int idFrete, int idTransportador) throws Exception {
        if (idFrete <= 0)
            throw new Exception("ID do frete inválido.");

        if (idTransportador <= 0)
            throw new Exception("ID do transportador inválido.");

        // Buscar dados do frete e usuários para notificação
        Frete frete = freteDAO.buscarPorId(idFrete);
        Usuario transportador = usuarioDAO.buscarPorId(idTransportador);
        Usuario cliente = usuarioDAO.buscarPorId(frete.getIdCliente());
        
        if (frete == null)
            throw new Exception("Frete não encontrado.");
            
        if (cliente == null)
            throw new Exception("Cliente não encontrado.");

        // Aceitar frete
        freteDAO.aceitarFrete(idFrete, idTransportador);
        
        // Notificar o cliente que o frete foi aceito
        Notificacao notificacaoCliente = new Notificacao();
        notificacaoCliente.setIdUsuario(cliente.getId());
        notificacaoCliente.setTitulo("Frete Aceito! 🚚");
        notificacaoCliente.setMensagem(
            "Seu frete de " + frete.getOrigem() + " para " + frete.getDestino() + 
            " foi aceito pelo transportador " + transportador.getNome() + ". " +
            "Agora você pode acompanhar o rastreamento."
        );
        notificacaoCliente.setTipo("frete_aceito");
        notificacaoCliente.setIdFrete(idFrete);
        
        notificacaoDAO.inserir(notificacaoCliente);
    }

    // ==========================================================
    // INICIAR FRETE (status → EM_ANDAMENTO) COM NOTIFICAÇÃO
    // ==========================================================
    public void iniciarFrete(int idFrete) throws Exception {
        if (idFrete <= 0)
            throw new Exception("ID do frete inválido.");

        // Buscar dados do frete para notificação
        Frete frete = freteDAO.buscarPorId(idFrete);
        Usuario cliente = usuarioDAO.buscarPorId(frete.getIdCliente());
        
        if (frete == null)
            throw new Exception("Frete não encontrado.");

        // Iniciar frete
        freteDAO.iniciarFrete(idFrete);
        
        // Notificar o cliente que o frete iniciou
        Notificacao notificacao = new Notificacao();
        notificacao.setIdUsuario(cliente.getId());
        notificacao.setTitulo("Frete em Andamento! 🚛");
        notificacao.setMensagem(
            "Seu frete de " + frete.getOrigem() + " para " + frete.getDestino() + 
            " está em andamento. Acompanhe o rastreamento para ver a localização atual."
        );
        notificacao.setTipo("frete_em_andamento");
        notificacao.setIdFrete(idFrete);
        
        notificacaoDAO.inserir(notificacao);
    }

    // ==========================================================
    // CONCLUIR FRETE COM NOTIFICAÇÃO
    // ==========================================================
    public void concluirFrete(int idFrete) throws Exception {
        if (idFrete <= 0)
            throw new Exception("ID do frete inválido.");

        // Buscar dados do frete
        Frete frete = freteDAO.buscarPorId(idFrete);
        Usuario cliente = usuarioDAO.buscarPorId(frete.getIdCliente());
        Usuario transportador = usuarioDAO.buscarPorId(frete.getIdTransportador());
        
        if (frete == null)
            throw new Exception("Frete não encontrado.");
        
        // Concluir frete
        freteDAO.concluirFrete(idFrete);
        
        // Notificar o cliente
        Notificacao notificacaoCliente = new Notificacao();
        notificacaoCliente.setIdUsuario(cliente.getId());
        notificacaoCliente.setTitulo("Frete Concluído! ✅");
        notificacaoCliente.setMensagem(
            "Seu frete de " + frete.getOrigem() + " para " + frete.getDestino() + 
            " foi concluído com sucesso pelo transportador " + transportador.getNome() + 
            ". Agora você pode avaliar o serviço."
        );
        notificacaoCliente.setTipo("frete_concluido");
        notificacaoCliente.setIdFrete(idFrete);
        
        notificacaoDAO.inserir(notificacaoCliente);
    }

    // ==========================================================
    // LISTAR FRETES DO CLIENTE (limit customizado)
    // ==========================================================
    public List<Frete> listarFretesCliente(int idCliente, int limit) throws Exception {
        if (idCliente <= 0)
            throw new Exception("ID do cliente inválido.");

        return freteDAO.listarFretesCliente(idCliente, limit);
    }

    // ==========================================================
    // LISTAR FRETES DISPONÍVEIS (pendentes)
    // ==========================================================
    public List<Frete> listarFretesDisponiveis() throws Exception {
        return freteDAO.listarPendentesTodos();
    }

    // ==========================================================
    // LISTAR FRETES EM ANDAMENTO DO TRANSPORTADOR
    // ==========================================================
    public List<Frete> listarFretesEmAndamento(int idTransportador) throws Exception {
        if (idTransportador <= 0)
            throw new Exception("ID do transportador inválido.");

        return freteDAO.listarFretesEmAndamento(idTransportador);
    }

    // ==========================================================
    // LISTAR FRETES CONCLUÍDOS DO TRANSPORTADOR
    // ==========================================================
    public List<Frete> listarFretesConcluidos(int idTransportador) throws Exception {
        if (idTransportador <= 0)
            throw new Exception("ID do transportador inválido.");

        return freteDAO.listarFretesConcluidos(idTransportador);
    }

    // ==========================================================
    // LISTAR ÚLTIMOS 3 FRETES ACEITOS PELO TRANSPORTADOR
    // ==========================================================
    public List<Frete> listarFretesRecentesTransportador(int idTransportador) throws Exception {
        if (idTransportador <= 0)
            throw new Exception("ID do transportador inválido.");

        return freteDAO.listarFretesTransportador(idTransportador);
    }

    // ==========================================================
    // LISTAR TODOS OS FRETES
    // ==========================================================
    public List<Frete> listarTodos() throws Exception {
        return freteDAO.listarPendentesTodos();
    }

    // ==========================================================
    // BUSCAR FRETE POR ID
    // ==========================================================
    public Frete buscarFretePorId(int idFrete) throws Exception {
        if (idFrete <= 0)
            throw new Exception("ID do frete inválido.");

        Frete frete = freteDAO.buscarPorId(idFrete);
        if (frete == null)
            throw new Exception("Frete não encontrado.");

        return frete;
    }

    // ==========================================================
    // VERIFICAR SE CLIENTE PODE AVALIAR FRETE
    // ==========================================================
    public boolean clientePodeAvaliarFrete(int idFrete, int idCliente) throws Exception {
        if (idFrete <= 0 || idCliente <= 0)
            return false;

        Frete frete = freteDAO.buscarPorId(idFrete);
        if (frete == null)
            return false;

        // Verificar se o frete pertence ao cliente e está concluído
        return frete.getIdCliente() == idCliente && 
               "concluido".equalsIgnoreCase(frete.getStatus());
    }

    // ==========================================================
    // MÉTODO AUXILIAR PARA VALIDAÇÃO
    // ==========================================================
    private boolean isVazio(String valor) {
        return valor == null || valor.trim().isEmpty();
    }
}