package br.com.hermes.service;

import br.com.hermes.dao.FreteDAO;
import br.com.hermes.model.Frete;

import java.util.List;

public class FreteService {

    private final FreteDAO freteDAO = new FreteDAO();

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

        freteDAO.inserir(frete);
    }

    // ==========================================================
    // ACEITAR FRETE
    // ==========================================================
    public void aceitarFrete(int idFrete, int idTransportador) throws Exception {

        if (idFrete <= 0)
            throw new Exception("ID do frete inválido.");

        if (idTransportador <= 0)
            throw new Exception("ID do transportador inválido.");

        freteDAO.aceitarFrete(idFrete, idTransportador);
    }

    // ==========================================================
    // LISTAR FRETES DO CLIENTE
    // ==========================================================
    public List<Frete> listarFretesCliente(int idCliente, int limit) throws Exception {

        if (idCliente <= 0)
            throw new Exception("ID do cliente inválido.");

        return freteDAO.listarFretesCliente(idCliente, limit);
    }

    // ==========================================================
    // LISTAR FRETES DISPONÍVEIS (pendentes para transportador)
    // ==========================================================
    public List<Frete> listarFretesDisponiveis() throws Exception {
        return freteDAO.listarPendentesTodos(); // ← aqui corrigimos
    }

    // ==========================================================
    // AUXILIAR
    // ==========================================================
    private boolean isVazio(String valor) {
        return valor == null || valor.trim().isEmpty();
    }
}
