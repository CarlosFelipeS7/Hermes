package br.com.hermes.service;

import br.com.hermes.dao.AvaliacaoDAO;
import br.com.hermes.dao.FreteDAO;
import br.com.hermes.dao.NotificacaoDAO;
import br.com.hermes.dao.UsuarioDAO;
import br.com.hermes.model.Avaliacao;
import br.com.hermes.model.Frete;
import br.com.hermes.model.Notificacao;
import br.com.hermes.model.Usuario;

public class AvaliacaoService {

    private final AvaliacaoDAO avaliacaoDAO = new AvaliacaoDAO();
    private final FreteDAO freteDAO = new FreteDAO();
    private final NotificacaoDAO notificacaoDAO = new NotificacaoDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    public void avaliar(Avaliacao av) throws Exception {
        System.out.println("=== DEBUG AvaliacaoService.avaliar ===");
        System.out.println("ID Frete: " + av.getIdFrete());
        System.out.println("Nota: " + av.getNota());
        System.out.println("Comentário: " + av.getComentario());

        if (av == null)
            throw new Exception("Avaliação inválida.");

        if (av.getIdFrete() <= 0)
            throw new Exception("ID do frete inválido.");

        if (av.getNota() < 1 || av.getNota() > 5)
            throw new Exception("A nota precisa estar entre 1 e 5.");

        // ✅ CORREÇÃO: Comentário NÃO é mais obrigatório
        if (av.getComentario() == null) {
            av.setComentario(""); // Define como string vazia se for null
        }

        // ==========================================================
        // VALIDAR SE O FRETE PODE SER AVALIADO
        // ==========================================================
        Frete frete = freteDAO.buscarPorId(av.getIdFrete());
        if (frete == null)
            throw new Exception("Frete não encontrado.");

        if (!"concluido".equalsIgnoreCase(frete.getStatus()))
            throw new Exception("Só é possível avaliar fretes concluídos.");

        // ==========================================================
        // VERIFICAR SE JÁ EXISTE AVALIAÇÃO PARA ESTE FRETE
        // ==========================================================
        Avaliacao avaliacaoExistente = avaliacaoDAO.buscarPorFrete(av.getIdFrete());
        if (avaliacaoExistente != null)
            throw new Exception("Este frete já foi avaliado.");

        // ==========================================================
        // BUSCAR DADOS PARA NOTIFICAÇÃO
        // ==========================================================
        Usuario transportador = usuarioDAO.buscarPorId(frete.getIdTransportador());
        Usuario cliente = usuarioDAO.buscarPorId(frete.getIdCliente());

        if (transportador == null)
            throw new Exception("Transportador não encontrado.");

        // ==========================================================
        // SALVAR AVALIAÇÃO NO BANCO
        // ==========================================================
        System.out.println("💾 Salvando avaliação no banco...");
        boolean sucesso = avaliacaoDAO.inserir(av);
        System.out.println("✅ Resultado do insert: " + sucesso);
        
        if (!sucesso) {
            throw new Exception("Erro ao salvar avaliação no banco de dados");
        }

        // ==========================================================
        // NOTIFICAR O TRANSPORTADOR SOBRE A NOVA AVALIAÇÃO
        // ==========================================================
        try {
            Notificacao notificacaoTransportador = new Notificacao();
            notificacaoTransportador.setIdUsuario(transportador.getId());
            notificacaoTransportador.setTitulo("Nova Avaliação Recebida! ⭐");
            
            String mensagemTransportador = "Você recebeu " + av.getNota() + " estrela(s) de " + 
                (cliente != null ? cliente.getNome() : "um cliente") + 
                " pelo frete de " + frete.getOrigem() + " para " + frete.getDestino();
            
            // Adicionar comentário apenas se não estiver vazio
            if (av.getComentario() != null && !av.getComentario().trim().isEmpty()) {
                mensagemTransportador += ". Comentário: \"" + av.getComentario() + "\"";
            }
            
            notificacaoTransportador.setMensagem(mensagemTransportador);
            notificacaoTransportador.setTipo("avaliacao_recebida");
            notificacaoTransportador.setIdFrete(av.getIdFrete());
            
            notificacaoDAO.inserir(notificacaoTransportador);
            System.out.println("✅ Notificação enviada para transportador");
        } catch (Exception e) {
            System.err.println("⚠️ Erro ao enviar notificação para transportador: " + e.getMessage());
            // Não lançar exceção para não interromper o fluxo principal
        }

        // ==========================================================
        // NOTIFICAR O CLIENTE CONFIRMANDO A AVALIAÇÃO
        // ==========================================================
        try {
            if (cliente != null) {
                Notificacao notificacaoCliente = new Notificacao();
                notificacaoCliente.setIdUsuario(cliente.getId());
                notificacaoCliente.setTitulo("Avaliação Enviada! ✅");
                notificacaoCliente.setMensagem(
                    "Sua avaliação de " + av.getNota() + " estrela(s) para o transportador " + 
                    transportador.getNome() + " foi registrada com sucesso."
                );
                notificacaoCliente.setTipo("avaliacao_enviada");
                notificacaoCliente.setIdFrete(av.getIdFrete());
                
                notificacaoDAO.inserir(notificacaoCliente);
                System.out.println("✅ Notificação enviada para cliente");
            }
        } catch (Exception e) {
            System.err.println("⚠️ Erro ao enviar notificação para cliente: " + e.getMessage());
            // Não lançar exceção para não interromper o fluxo principal
        }
        
        System.out.println("🎉 Avaliação processada com sucesso!");
    }

    // ==========================================================
    // BUSCAR AVALIAÇÃO POR FRETE
    // ==========================================================
    public Avaliacao buscarAvaliacaoPorFrete(int idFrete) throws Exception {
        if (idFrete <= 0)
            throw new Exception("ID do frete inválido.");

        return avaliacaoDAO.buscarPorFrete(idFrete);
    }

    // ==========================================================
    // LISTAR AVALIAÇÕES DO TRANSPORTADOR (PARA PERFIL)
    // ==========================================================
    public java.util.List<Avaliacao> listarAvaliacoesTransportador(int idTransportador) throws Exception {
        if (idTransportador <= 0)
            throw new Exception("ID do transportador inválido.");

        return avaliacaoDAO.listarPorTransportador(idTransportador);
    }

    // ==========================================================
    // LISTAR AVALIAÇÕES FEITAS PELO CLIENTE (PARA PERFIL)
    // ==========================================================
    public java.util.List<Avaliacao> listarAvaliacoesCliente(int idCliente) throws Exception {
        if (idCliente <= 0)
            throw new Exception("ID do cliente inválido.");

        return avaliacaoDAO.listarPorCliente(idCliente);
    }

    // ==========================================================
    // CALCULAR MÉDIA DAS AVALIAÇÕES DO TRANSPORTADOR
    // ==========================================================
    public double calcularMediaTransportador(int idTransportador) throws Exception {
        if (idTransportador <= 0)
            throw new Exception("ID do transportador inválido.");

        double media = avaliacaoDAO.calcularMediaTransportador(idTransportador);
        
        // Arredondar para 1 casa decimal
        return Math.round(media * 10.0) / 10.0;
    }

    // ==========================================================
    // CONTAR TOTAL DE AVALIAÇÕES DO TRANSPORTADOR
    // ==========================================================
    public int contarAvaliacoesTransportador(int idTransportador) throws Exception {
        if (idTransportador <= 0)
            throw new Exception("ID do transportador inválido.");

        java.util.List<Avaliacao> avaliacoes = avaliacaoDAO.listarPorTransportador(idTransportador);
        return avaliacoes.size();
    }

    // ==========================================================
    // OBTER DISTRIBUIÇÃO DAS NOTAS (PARA GRÁFICOS FUTUROS)
    // ==========================================================
    public java.util.Map<Integer, Integer> obterDistribuicaoNotas(int idTransportador) throws Exception {
        if (idTransportador <= 0)
            throw new Exception("ID do transportador inválido.");

        java.util.List<Avaliacao> avaliacoes = avaliacaoDAO.listarPorTransportador(idTransportador);
        java.util.Map<Integer, Integer> distribuicao = new java.util.HashMap<>();
        
        // Inicializar contadores
        for (int i = 1; i <= 5; i++) {
            distribuicao.put(i, 0);
        }
        
        // Contar notas
        for (Avaliacao av : avaliacoes) {
            int nota = av.getNota();
            distribuicao.put(nota, distribuicao.get(nota) + 1);
        }
        
        return distribuicao;
    }

    // ==========================================================
    // VERIFICAR SE CLIENTE PODE AVALIAR FRETE
    // ==========================================================
    public boolean clientePodeAvaliarFrete(int idFrete, int idCliente) throws Exception {
        if (idFrete <= 0 || idCliente <= 0)
            return false;

        // Buscar frete
        Frete frete = freteDAO.buscarPorId(idFrete);
        if (frete == null)
            return false;

        // Verificar se o frete pertence ao cliente
        if (frete.getIdCliente() != idCliente)
            return false;

        // Verificar se o frete está concluído
        if (!"concluido".equalsIgnoreCase(frete.getStatus()))
            return false;

        // Verificar se já existe avaliação
        Avaliacao avaliacaoExistente = avaliacaoDAO.buscarPorFrete(idFrete);
        return avaliacaoExistente == null;
    }

    // ==========================================================
    // OBTER DETALHES COMPLETOS DA AVALIAÇÃO (COM INFO DO FRETE)
    // ==========================================================
    public java.util.Map<String, Object> obterDetalhesAvaliacao(int idAvaliacao) throws Exception {
        if (idAvaliacao <= 0)
            throw new Exception("ID da avaliação inválido.");

        java.util.Map<String, Object> detalhes = new java.util.HashMap<>();
        
        // Buscar avaliação
        // Nota: Você precisará adicionar um método buscarPorId no AvaliacaoDAO
        // Avaliacao avaliacao = avaliacaoDAO.buscarPorId(idAvaliacao);
        // if (avaliacao == null)
        //     throw new Exception("Avaliação não encontrada.");
        //
        // Buscar frete relacionado
        // Frete frete = freteDAO.buscarPorId(avaliacao.getIdFrete());
        //
        // detalhes.put("avaliacao", avaliacao);
        // detalhes.put("frete", frete);
        
        return detalhes;
    }

    private boolean isVazio(String valor) {
        return valor == null || valor.trim().isEmpty();
    }
}