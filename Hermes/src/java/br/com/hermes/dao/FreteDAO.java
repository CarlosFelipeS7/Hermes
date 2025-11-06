package br.com.hermes.dao;

import br.com.hermes.model.Frete;
import java.sql.*;
import java.util.*;

public class FreteDAO {

    // Inserir novo frete
    public void inserir(Frete f) throws Exception {
        String sql = """
            INSERT INTO frete (origem, destino, descricao_carga, peso, valor, status, data_solicitacao, id_cliente)
            VALUES (?, ?, ?, ?, ?, 'PENDENTE', CURRENT_TIMESTAMP, ?)
        """;

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, f.getOrigem());
            stmt.setString(2, f.getDestino());
            stmt.setString(3, f.getDescricaoCarga());
            stmt.setDouble(4, f.getPeso());
            stmt.setDouble(5, f.getValor());
            stmt.setInt(6, f.getIdCliente());
            stmt.executeUpdate();
        }
    }

    // Listar fretes de um cliente
    public List<Frete> listarPorCliente(int idCliente) throws Exception {
        List<Frete> fretes = new ArrayList<>();
        String sql = "SELECT * FROM frete WHERE id_cliente = ? ORDER BY data_solicitacao DESC";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idCliente);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Frete f = new Frete();
                f.setId(rs.getInt("id"));
                f.setOrigem(rs.getString("origem"));
                f.setDestino(rs.getString("destino"));
                f.setDescricaoCarga(rs.getString("descricao_carga"));
                f.setPeso(rs.getDouble("peso"));
                f.setValor(rs.getDouble("valor"));
                f.setStatus(rs.getString("status"));
                f.setDataSolicitacao(rs.getTimestamp("data_solicitacao"));
                f.setDataConclusao(rs.getTimestamp("data_conclusao"));
                fretes.add(f);
            }
        }
        return fretes;
    }

    // Listar fretes disponíveis (para transportadores)
    public List<Frete> listarDisponiveis() throws Exception {
        List<Frete> fretes = new ArrayList<>();
        String sql = "SELECT * FROM frete WHERE status = 'PENDENTE' ORDER BY data_solicitacao DESC";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Frete f = new Frete();
                f.setId(rs.getInt("id"));
                f.setOrigem(rs.getString("origem"));
                f.setDestino(rs.getString("destino"));
                f.setDescricaoCarga(rs.getString("descricao_carga"));
                f.setPeso(rs.getDouble("peso"));
                f.setValor(rs.getDouble("valor"));
                f.setStatus(rs.getString("status"));
                fretes.add(f);
            }
        }
        return fretes;
    }

    // Atualizar status e transportador
    public void aceitarFrete(int idFrete, int idTransportador) throws Exception {
        String sql = "UPDATE frete SET status='EM ANDAMENTO', id_transportador=? WHERE id=?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTransportador);
            stmt.setInt(2, idFrete);
            stmt.executeUpdate();
        }
    }
}
