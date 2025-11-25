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
    // INSERIR - CORRIGIDO: usando avaliacoes (plural)
    // ---------------------------------------------------------
    public void inserir(Avaliacao a) throws Exception {
        String sql = """
            INSERT INTO avaliacoes (id_frete, nota, comentario, foto, data_avaliacao)
            VALUES (?, ?, ?, ?, NOW())
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
    // LISTAR AVALIAÇÕES PÚBLICAS POR DDD - CORRIGIDO
    // ---------------------------------------------------------
    public List<Avaliacao> listarAvaliacoesPublicasPorDDD(String ddd) throws Exception {
        String sql = """
            SELECT a.* 
            FROM avaliacoes a
            INNER JOIN fretes f ON a.id_frete = f.id
            INNER JOIN usuarios u ON f.id_transportador = u.id
            WHERE u.ddd = ? AND u.tipo_usuario = 'transportador'
            ORDER BY a.data_avaliacao DESC
            LIMIT 20
        """;

        List<Avaliacao> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, ddd);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Avaliacao a = map(rs);
                lista.add(a);
            }
        }
        return lista;
    }

    // ---------------------------------------------------------
    // LISTAR DDDS COM AVALIAÇÕES - CORRIGIDO
    // ---------------------------------------------------------
    public List<String> listarDDDsComAvaliacoes() throws Exception {
        String sql = """
            SELECT DISTINCT u.ddd 
            FROM avaliacoes a
            INNER JOIN fretes f ON a.id_frete = f.id
            INNER JOIN usuarios u ON f.id_transportador = u.id
            WHERE u.ddd IS NOT NULL AND u.ddd != ''
            ORDER BY u.ddd
        """;

        List<String> ddds = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ddds.add(rs.getString("ddd"));
            }
        }
        return ddds;
    }

    // ---------------------------------------------------------
    // BUSCAR AVALIAÇÃO DE UM FRETE - CORRIGIDO
    // ---------------------------------------------------------
    public Avaliacao buscarPorFrete(int idFrete) throws Exception {
        String sql = "SELECT * FROM avaliacoes WHERE id_frete = ?";
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
    // LISTAR AVALIAÇÕES DE UM TRANSPORTADOR - CORRIGIDO
    // ---------------------------------------------------------
    public List<Avaliacao> listarPorTransportador(int idTransportador) throws Exception {
        String sql = """
            SELECT a.* FROM avaliacoes a
            INNER JOIN fretes f ON a.id_frete = f.id
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
    // LISTAR AVALIAÇÕES DE UM CLIENTE - CORRIGIDO
    // ---------------------------------------------------------
    public List<Avaliacao> listarPorCliente(int idCliente) throws Exception {
        String sql = """
            SELECT a.* FROM avaliacoes a
            INNER JOIN fretes f ON a.id_frete = f.id
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
    // LISTAR AVALIAÇÕES RECENTES - CORRIGIDO
    // ---------------------------------------------------------
    public List<Avaliacao> listarRecentes(int limit) throws Exception {
        String sql = """
            SELECT * FROM avaliacoes
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
    // CALCULAR MÉDIA DO TRANSPORTADOR - CORRIGIDO
    // ---------------------------------------------------------
    public double calcularMediaTransportador(int idTransportador) throws Exception {
        String sql = """
            SELECT AVG(a.nota) AS media
            FROM avaliacoes a
            INNER JOIN fretes f ON f.id = a.id_frete
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