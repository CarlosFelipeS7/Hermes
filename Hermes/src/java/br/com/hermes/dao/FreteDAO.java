package br.com.hermes.dao;

import br.com.hermes.model.Frete;
import java.sql.*;
import java.util.*;

public class FreteDAO {

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

    // Lista fretes de um cliente
    public List<Frete> listarFretesCliente(int idCliente, int limit) throws Exception {
        String sql = "SELECT * FROM frete WHERE id_cliente = ? ORDER BY data_solicitacao DESC LIMIT ?";
        List<Frete> fretes = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idCliente);
            stmt.setInt(2, limit);
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
                f.setIdCliente(rs.getInt("id_cliente"));
                fretes.add(f);
            }
        }
        return fretes;
    }

    // Lista fretes disponíveis para transportador
    public List<Frete> listarFretesRecentesDisponiveis(int limit) throws Exception {
        String sql = "SELECT * FROM frete WHERE status = 'PENDENTE' ORDER BY data_solicitacao DESC LIMIT ?";
        List<Frete> fretes = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
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
                f.setIdCliente(rs.getInt("id_cliente"));
                fretes.add(f);
            }
        }
        return fretes;
    }

    // Aceitar frete
    public void aceitarFrete(int idFrete, int idTransportador) throws Exception {
        String sql = "UPDATE frete SET status='ACEITO', id_transportador=? WHERE id=?";
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idTransportador);
            stmt.setInt(2, idFrete);
            stmt.executeUpdate();
        }
    }
}
