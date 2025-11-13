package br.com.hermes.service;

import br.com.hermes.dao.FreteDAO;
import br.com.hermes.model.Frete;
import java.util.List;

public class FreteService {

    private final FreteDAO dao = new FreteDAO();

    public void cadastrarFrete(Frete f) throws Exception {
        dao.inserir(f);
    }

    public List<Frete> listarPorCliente(int idCliente, int limit) throws Exception {
        return dao.listarFretesCliente(idCliente, limit);
    }

    public List<Frete> listarDisponiveis(int limit) throws Exception {
        return dao.listarFretesRecentesDisponiveis(limit);
    }

    public void aceitarFrete(int idFrete, int idTransportador) throws Exception {
        dao.aceitarFrete(idFrete, idTransportador);
    }
}
