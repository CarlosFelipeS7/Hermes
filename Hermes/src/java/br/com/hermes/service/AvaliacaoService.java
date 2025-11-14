package br.com.hermes.service;

import br.com.hermes.dao.AvaliacaoDAO;
import br.com.hermes.model.Avaliacao;

public class AvaliacaoService {

    private final AvaliacaoDAO avaliacaoDAO = new AvaliacaoDAO();

    public void avaliar(Avaliacao av) throws Exception {

        if (av == null)
            throw new Exception("Avaliação inválida.");

        if (av.getIdFrete() <= 0)
            throw new Exception("ID do frete inválido.");

        if (av.getNota() < 1 || av.getNota() > 5)
            throw new Exception("A nota precisa estar entre 1 e 5.");

        if (isVazio(av.getComentario()))
            throw new Exception("Comentário é obrigatório.");

        // salvar no banco
        avaliacaoDAO.inserir(av);
    }

    private boolean isVazio(String valor) {
        return valor == null || valor.trim().isEmpty();
    }

}
