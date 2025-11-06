package br.com.hermes.service;

import br.com.hermes.dao.FreteDAO;
import br.com.hermes.model.Frete;
import java.util.List;

public class FreteService {
    private final FreteDAO dao = new FreteDAO();

    public void cadastrarFrete(Frete f) throws Exception {
        dao.inserir(f);
    }

    public List<Frete> listarPorCliente(int idCliente) throws Exception {
        return dao.listarPorCliente(idCliente);
    }

    public List<Frete> listarDisponiveis() throws Exception {
        return dao.listarDisponiveis();
    }

    public void aceitarFrete(int idFrete, int idTransportador) throws Exception {
        dao.aceitarFrete(idFrete, idTransportador);
    }
}
