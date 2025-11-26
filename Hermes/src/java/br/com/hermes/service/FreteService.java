package br.com.hermes.service;

import br.com.hermes.dao.FreteDAO;
import br.com.hermes.dao.AvaliacaoDAO;
import br.com.hermes.dao.NotificacaoDAO;
import br.com.hermes.dao.UsuarioDAO;
import br.com.hermes.model.Frete;
import br.com.hermes.model.Notificacao;
import br.com.hermes.model.Usuario;
import java.util.List;

public class FreteService {

    private final FreteDAO freteDAO = new FreteDAO();
    private final AvaliacaoDAO avaliacaoDAO = new AvaliacaoDAO();
    private final NotificacaoDAO notificacaoDAO = new NotificacaoDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    // ==========================================================
    // EXCLUIR FRETE - MÉTODO CORRIGIDO
    // ==========================================================
    public boolean excluirFrete(int idFrete, int idUsuario, String tipoUsuario) throws Exception {
        System.out.println("=== DEBUG FreteService.excluirFrete ===");
        System.out.println("ID Frete: " + idFrete);
        System.out.println("ID Usuário: " + idUsuario);
        System.out.println("Tipo Usuário: " + tipoUsuario);

        // Validar parâmetros
        if (idFrete <= 0) {
            throw new Exception("ID do frete inválido.");
        }

        // Buscar frete
        Frete frete = freteDAO.buscarPorId(idFrete);
        if (frete == null) {
            throw new Exception("Frete não encontrado.");
        }

        System.out.println("Frete encontrado:");
        System.out.println(" - Status: " + frete.getStatus());
        System.out.println(" - Cliente ID: " + frete.getIdCliente());
        System.out.println(" - Transportador ID: " + frete.getIdTransportador());

        // Verificar permissão
        if (!temPermissaoParaExcluir(frete, idUsuario, tipoUsuario)) {
            throw new Exception("Você não tem permissão para excluir este frete.");
        }

        // Verificar se pode excluir baseado no status
        if (!podeExcluirPorStatus(frete.getStatus())) {
            throw new Exception("Este frete não pode ser excluído. " +
                              "Status atual: " + frete.getStatus() + ". " +
                              "Apenas fretes com status 'disponível', 'pendente' ou 'concluído' podem ser excluídos.");
        }

        // ✅ VERIFICAR E EXCLUIR AVALIAÇÕES RELACIONADAS (se houver)
        try {
            System.out.println("Verificando avaliações relacionadas...");
            // Se você tiver um método para excluir avaliação por frete, adicione aqui
            // avaliacaoDAO.excluirPorFrete(idFrete);
        } catch (Exception e) {
            System.err.println("⚠️ Aviso: Não foi possível verificar avaliações: " + e.getMessage());
        }

        // ✅ EXCLUIR O FRETE
        System.out.println("Tentando excluir frete do banco...");
        boolean sucesso = freteDAO.excluir(idFrete);
        
        if (sucesso) {
            System.out.println("✅ Frete excluído com sucesso do banco!");
            
            // ✅ ENVIAR NOTIFICAÇÃO DE EXCLUSÃO (se aplicável)
            enviarNotificacaoExclusao(frete, idUsuario, tipoUsuario);
            
            return true;
        } else {
            System.err.println("❌ Falha ao excluir frete do banco.");
            throw new Exception("Erro ao excluir frete do banco de dados.");
        }
    }

    // ==========================================================
    // VERIFICAR PERMISSÕES PARA EXCLUIR
    // ==========================================================
    private boolean temPermissaoParaExcluir(Frete frete, int idUsuario, String tipoUsuario) {
        System.out.println("Verificando permissões...");
        System.out.println(" - Tipo usuário: " + tipoUsuario);
        System.out.println(" - ID usuário: " + idUsuario);
        System.out.println(" - ID cliente frete: " + frete.getIdCliente());
        System.out.println(" - ID transportador frete: " + frete.getIdTransportador());

        // Admin pode excluir qualquer frete
        if ("admin".equalsIgnoreCase(tipoUsuario)) {
            System.out.println("✅ Permissão concedida: ADMIN");
            return true;
        }
        
        // Cliente pode excluir seus próprios fretes (se for o criador)
        if ("cliente".equalsIgnoreCase(tipoUsuario)) {
            boolean permitido = frete.getIdCliente() == idUsuario;
            System.out.println("✅ Permissão CLIENTE: " + permitido);
            return permitido;
        }
        
        // Transportador pode excluir fretes que ele aceitou
        if ("transportador".equalsIgnoreCase(tipoUsuario)) {
            boolean permitido = frete.getIdTransportador() == idUsuario;
            System.out.println("✅ Permissão TRANSPORTADOR: " + permitido);
            return permitido;
        }
        
        System.out.println("❌ Tipo de usuário não reconhecido: " + tipoUsuario);
        return false;
    }

    // ==========================================================
    // VERIFICAR SE PODE EXCLUIR BASEADO NO STATUS
    // ==========================================================
    private boolean podeExcluirPorStatus(String status) {
        System.out.println("Verificando status para exclusão: " + status);
        
        boolean permitido = "disponivel".equalsIgnoreCase(status) || 
               "concluido".equalsIgnoreCase(status) ||
               "pendente".equalsIgnoreCase(status) ||
               "aceito".equalsIgnoreCase(status); // Adicionei aceito também
        
        System.out.println("✅ Status permitido para exclusão: " + permitido);
        return permitido;
    }

    // ==========================================================
    // ENVIAR NOTIFICAÇÃO DE EXCLUSÃO
    // ==========================================================
    private void enviarNotificacaoExclusao(Frete frete, int idUsuario, String tipoUsuario) {
        try {
            Notificacao notificacao = new Notificacao();
            notificacao.setIdUsuario(idUsuario);
            notificacao.setTitulo("Frete Excluído 🗑️");
            
            String mensagem = "O frete de " + frete.getOrigem() + " para " + frete.getDestino();
            
            if ("cliente".equalsIgnoreCase(tipoUsuario)) {
                mensagem += " foi excluído por você.";
            } else if ("transportador".equalsIgnoreCase(tipoUsuario)) {
                mensagem += " foi excluído pelo transportador.";
            } else {
                mensagem += " foi excluído pelo administrador.";
            }
            
            notificacao.setMensagem(mensagem);
            notificacao.setTipo("frete_excluido");
            notificacao.setIdFrete(frete.getId());
            
            notificacaoDAO.inserir(notificacao);
            System.out.println("✅ Notificação de exclusão enviada.");
            
        } catch (Exception e) {
            System.err.println("⚠️ Erro ao enviar notificação de exclusão: " + e.getMessage());
        }
    }

    // ==========================================================
    // VERIFICAR SE USUÁRIO PODE EXCLUIR FRETE (para UI)
    // ==========================================================
    public boolean usuarioPodeExcluirFrete(int idFrete, int idUsuario, String tipoUsuario) {
        try {
            System.out.println("=== Verificando permissão UI para frete " + idFrete + " ===");
            Frete frete = freteDAO.buscarPorId(idFrete);
            if (frete == null) {
                System.out.println("❌ Frete não encontrado");
                return false;
            }
            
            boolean temPermissao = temPermissaoParaExcluir(frete, idUsuario, tipoUsuario);
            boolean statusPermitido = podeExcluirPorStatus(frete.getStatus());
            
            System.out.println("✅ Permissão UI: " + temPermissao);
            System.out.println("✅ Status permitido UI: " + statusPermitido);
            
            return temPermissao && statusPermitido;
            
        } catch (Exception e) {
            System.err.println("❌ Erro ao verificar permissão de exclusão: " + e.getMessage());
            return false;
        }
    }

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