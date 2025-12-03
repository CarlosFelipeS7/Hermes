package br.com.hermes.service;

import br.com.hermes.dao.VeiculoDAO;
import br.com.hermes.model.Veiculo;

import java.util.List;

public class VeiculoService {

    private final VeiculoDAO veiculoDAO = new VeiculoDAO();

    public List<Veiculo> listarPorUsuario(int idUsuario, String tipoUsuario) throws Exception {

        if (idUsuario <= 0) {
            throw new Exception("Usuário inválido para listar veículos.");
        }

        if (tipoUsuario == null) {
            throw new Exception("Tipo de usuário não encontrado.");
        }

        tipoUsuario = tipoUsuario.trim().toLowerCase();

        if (!tipoUsuario.equals("transportador")) {
            throw new Exception("Somente transportadores podem gerenciar veículos.");
        }

        return veiculoDAO.listarPorUsuario(idUsuario);
    }

    public void cadastrar(Veiculo v, int idUsuario, String tipoUsuario) throws Exception {

        if (v == null) {
            throw new Exception("Veículo inválido.");
        }

        if (idUsuario <= 0) {
            throw new Exception("Usuário inválido.");
        }

        if (!"transportador".equals(tipoUsuario)) {
            throw new Exception("Somente transportadores podem cadastrar veículos.");
        }

        if (isVazio(v.getTipoVeiculo())) throw new Exception("Tipo de veículo é obrigatório.");
        if (isVazio(v.getMarca())) throw new Exception("Marca é obrigatória.");
        if (isVazio(v.getModelo())) throw new Exception("Modelo é obrigatório.");
        if (v.getAno() <= 0) throw new Exception("Ano inválido.");
        if (isVazio(v.getPlaca())) throw new Exception("Placa é obrigatória.");
        if (v.getCapacidade() <= 0) throw new Exception("Capacidade deve ser maior que zero.");

        veiculoDAO.inserir(v, idUsuario);
    }

    public void atualizar(Veiculo v, int idUsuario, String tipoUsuario) throws Exception {

        if (v == null || v.getId() <= 0) {
            throw new Exception("Veículo inválido para atualização.");
        }

        if (idUsuario <= 0) {
            throw new Exception("Usuário inválido.");
        }

        if (tipoUsuario == null || !tipoUsuario.equalsIgnoreCase("transportador")) {
            throw new Exception("Somente transportadores podem atualizar veículos.");
        }

        if (isVazio(v.getTipoVeiculo())) throw new Exception("Tipo de veículo é obrigatório.");
        if (isVazio(v.getMarca())) throw new Exception("Marca é obrigatória.");
        if (isVazio(v.getModelo())) throw new Exception("Modelo é obrigatório.");
        if (v.getAno() <= 0) throw new Exception("Ano inválido.");
        if (isVazio(v.getPlaca())) throw new Exception("Placa é obrigatória.");
        if (v.getCapacidade() <= 0) throw new Exception("Capacidade deve ser maior que zero.");

        veiculoDAO.atualizar(v, idUsuario);
    }

    public void excluir(int idVeiculo, int idUsuario, String tipoUsuario) throws Exception {

        if (idVeiculo <= 0) throw new Exception("Veículo inválido para exclusão.");
        if (idUsuario <= 0) throw new Exception("Usuário inválido.");

        if (tipoUsuario == null || !tipoUsuario.equalsIgnoreCase("transportador")) {
            throw new Exception("Somente transportadores podem excluir veículos.");
        }

        veiculoDAO.excluir(idVeiculo, idUsuario);
    }
    
    public Veiculo buscarPorId(int id) throws Exception {
        if (id <= 0) {
            throw new Exception("ID inválido para busca.");
        }
        return veiculoDAO.buscarPorId(id);
    }


    private boolean isVazio(String v) {
        return v == null || v.trim().isEmpty();
    }
}
