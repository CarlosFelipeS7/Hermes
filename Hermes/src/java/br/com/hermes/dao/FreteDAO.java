package br.com.hermes.dao;

import br.com.hermes.model.Frete;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FreteDAO {

    // --------------------------------------------------------------
    // MAPEAR RESULTSET → OBJETO FRETE (evita repetição)
    // --------------------------------------------------------------
    private Frete map(ResultSet rs) throws Exception {
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
        f.setIdCliente(rs.getInt("id_cliente"));

        int idT = rs.getInt("id_transportador");
        if (!rs.wasNull()) {
            f.setIdTransportador(idT);
        }

        return f;
    }

    // --------------------------------------------------------------
    // INSERIR
    // --------------------------------------------------------------
    public void inserir(Frete f) throws Exception {
        String sql = """
            INSERT INTO frete 
            (origem, destino, descricao_carga, peso, valor, status, data_solicitacao, id_cliente)
            VALUES (?, ?, ?, ?, ?, 'pendente', CURRENT_TIMESTAMP, ?)
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

    // --------------------------------------------------------------
    // BUSCAR POR ID
    // --------------------------------------------------------------
    public Frete buscarPorId(int id) throws Exception {
        String sql = "SELECT * FROM frete WHERE id = ?";
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return map(rs);
            }
        }
        return null;
    }

    // --------------------------------------------------------------
    // LISTAR FRETES DE UM CLIENTE (com limite)
    // --------------------------------------------------------------
    public List<Frete> listarFretesCliente(int idCliente, int limit) throws Exception {
        String sql = """
            SELECT * FROM frete 
            WHERE id_cliente = ? 
            ORDER BY data_solicitacao DESC 
            LIMIT ?
        """;

        List<Frete> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idCliente);
            stmt.setInt(2, limit);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) lista.add(map(rs));
        }

        return lista;
    }

    // --------------------------------------------------------------
    // LISTAR PENDENTES (com limite)
    // --------------------------------------------------------------
    public List<Frete> listarPendentes(int limit) throws Exception {
        String sql = """
            SELECT * FROM frete 
            WHERE LOWER(status) = 'pendente'
            ORDER BY data_solicitacao DESC
            LIMIT ?
        """;

        List<Frete> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) lista.add(map(rs));
        }

        return lista;
    }

    // 3 pendentes recentes
    public List<Frete> listarTresPendentes() throws Exception {
        return listarPendentes(3);
    }

    // --------------------------------------------------------------
    // LISTAR TODOS PENDENTES (sem limite)
    // --------------------------------------------------------------
    public List<Frete> listarPendentesTodos() throws Exception {
        String sql = """
            SELECT * FROM frete 
            WHERE LOWER(status) = 'pendente'
            ORDER BY data_solicitacao DESC
        """;

        List<Frete> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) lista.add(map(rs));
        }

        return lista;
    }

    // --------------------------------------------------------------
    // ACEITAR FRETE
    // --------------------------------------------------------------
    public void aceitarFrete(int idFrete, int idTransportador) throws Exception {
        String sql = """
            UPDATE frete 
            SET status = 'aceito', id_transportador = ?
            WHERE id = ?
        """;

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTransportador);
            stmt.setInt(2, idFrete);
            stmt.executeUpdate();
        }
    }

    // --------------------------------------------------------------
    // CONCLUIR FRETE
    // --------------------------------------------------------------
    public void concluirFrete(int idFrete) throws Exception {
        String sql = """
            UPDATE frete 
            SET status = 'concluido', data_conclusao = CURRENT_TIMESTAMP
            WHERE id = ?
        """;

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idFrete);
            stmt.executeUpdate();
        }
    }

    // --------------------------------------------------------------
    // LISTAR FRETES ACEITOS POR TRANSPORTADOR
    // --------------------------------------------------------------
    public List<Frete> listarFretesTransportador(int idTransportador) throws Exception {
        String sql = """
            SELECT * FROM frete 
            WHERE id_transportador = ?
            ORDER BY data_solicitacao DESC
        """;

        List<Frete> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTransportador);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) lista.add(map(rs));
        }

        return lista;
    }
}
