package br.com.hermes.service;

import br.com.hermes.dao.VeiculoDAO;
import br.com.hermes.model.Veiculo;
import java.util.List;

public class VeiculoService {
    private VeiculoDAO veiculoDAO;

    public VeiculoService() {
        this.veiculoDAO = new VeiculoDAO();
    }

    public boolean cadastrarVeiculo(Veiculo veiculo) {
        // Validações
        if (veiculo.getPlaca() == null || veiculo.getPlaca().trim().isEmpty()) {
            throw new IllegalArgumentException("Placa é obrigatória");
        }
        
        if (veiculoDAO.placaExiste(veiculo.getPlaca())) {
            throw new IllegalArgumentException("Placa já cadastrada no sistema");
        }
        
        if (veiculo.getCapacidade() <= 0) {
            throw new IllegalArgumentException("Capacidade deve ser maior que zero");
        }
        
        if (veiculo.getAno() < 1900 || veiculo.getAno() > java.time.Year.now().getValue() + 1) {
            throw new IllegalArgumentException("Ano do veículo inválido");
        }
        
        return veiculoDAO.cadastrarVeiculo(veiculo);
    }

    public List<Veiculo> listarVeiculosPorUsuario(Integer idUsuario) {
        return veiculoDAO.listarVeiculosPorUsuario(idUsuario);
    }

    public boolean excluirVeiculo(Integer idVeiculo, Integer idUsuario) {
        return veiculoDAO.excluirVeiculo(idVeiculo, idUsuario);
    }
}