package br.com.hermes.dao;

import br.com.hermes.model.Avaliacao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AvaliacaoDAO {

    // ---------------------------------------------------------
    // MÉTODO PRIVADO PARA MAPEAR RESULTSET → OBJETO AVALIAÇÃO
    // ---------------------------------------------------------
    private Avaliacao map(ResultSet rs) throws Exception {
        Avaliacao a = new Avaliacao();
        a.setId(rs.getInt("id"));
        a.setIdFrete(rs.getInt("id_frete"));
        a.setNota(rs.getInt("nota"));
        a.setComentario(rs.getString("comentario"));
        a.setFoto(rs.getString("foto"));
        a.setDataAvaliacao(rs.getTimestamp("data_avaliacao"));
        return a;
    }

    // ---------------------------------------------------------
    // INSERIR
    // ---------------------------------------------------------
    public void inserir(Avaliacao a) throws Exception {
        String sql = """
            INSERT INTO avaliacao (id_frete, nota, comentario, foto)
            VALUES (?, ?, ?, ?)
        """;

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, a.getIdFrete());
            stmt.setInt(2, a.getNota());
            stmt.setString(3, a.getComentario());
            stmt.setString(4, a.getFoto());

            stmt.executeUpdate();
        }
    }

    // ---------------------------------------------------------
    // BUSCAR AVALIAÇÃO DE UM FRETE
    // ---------------------------------------------------------
    public Avaliacao buscarPorFrete(int idFrete) throws Exception {
        String sql = "SELECT * FROM avaliacao WHERE id_frete = ?";
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idFrete);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return map(rs);
            }
        }
        return null;
    }

    // ---------------------------------------------------------
    // LISTAR AVALIAÇÕES DE UM TRANSPORTADOR
    // (precisa do JOIN com frete)
    // ---------------------------------------------------------
    public List<Avaliacao> listarPorTransportador(int idTransportador) throws Exception {
        String sql = """
            SELECT a.* FROM avaliacao a
            INNER JOIN frete f ON a.id_frete = f.id
            WHERE f.id_transportador = ?
            ORDER BY a.data_avaliacao DESC
        """;

        List<Avaliacao> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTransportador);
            ResultSet rs = stmt.executeQuery();

            while (rs.next())
                lista.add(map(rs));
        }
        return lista;
    }

    // ---------------------------------------------------------
    // LISTAR TODAS AVALIAÇÕES DE UM CLIENTE
    // ---------------------------------------------------------
    public List<Avaliacao> listarPorCliente(int idCliente) throws Exception {
        String sql = """
            SELECT a.* FROM avaliacao a
            INNER JOIN frete f ON a.id_frete = f.id
            WHERE f.id_cliente = ?
            ORDER BY a.data_avaliacao DESC
        """;

        List<Avaliacao> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idCliente);
            ResultSet rs = stmt.executeQuery();

            while (rs.next())
                lista.add(map(rs));
        }
        return lista;
    }

    // ---------------------------------------------------------
    // LISTAR AS ÚLTIMAS AVALIAÇÕES (para dashboard futuramente)
    // ---------------------------------------------------------
    public List<Avaliacao> listarRecentes(int limit) throws Exception {
        String sql = """
            SELECT * FROM avaliacao
            ORDER BY data_avaliacao DESC
            LIMIT ?
        """;

        List<Avaliacao> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next())
                lista.add(map(rs));
        }
        return lista;
    }

    // ---------------------------------------------------------
    // CALCULAR MÉDIA DAS AVALIAÇÕES DE UM TRANSPORTADOR
    // ---------------------------------------------------------
    public double calcularMediaTransportador(int idTransportador) throws Exception {
        String sql = """
            SELECT AVG(a.nota) AS media
            FROM avaliacao a
            INNER JOIN frete f ON f.id = a.id_frete
            WHERE f.id_transportador = ?
        """;

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTransportador);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getDouble("media");
            }
        }
        return 0.0;
    }

}
