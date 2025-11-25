package br.com.hermes.dao;

import br.com.hermes.model.Notificacao;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificacaoDAO {

    private Notificacao map(ResultSet rs) throws SQLException {
        Notificacao n = new Notificacao();
        n.setId(rs.getInt("id"));
        n.setIdUsuario(rs.getInt("id_usuario"));
        n.setTitulo(rs.getString("titulo"));
        n.setMensagem(rs.getString("mensagem"));
        n.setTipo(rs.getString("tipo"));
        n.setLida(rs.getBoolean("lida"));
        n.setDataCriacao(rs.getTimestamp("data_criacao"));
        n.setIdFrete(rs.getInt("id_frete"));
        return n;
    }
    
    // Marcar todas as notificações do usuário como lidas
public void marcarTodasComoLidas(int idUsuario) throws Exception {
    String sql = "UPDATE notificacao SET lida = true WHERE id_usuario = ?";
    
    try (Connection conn = Conexao.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, idUsuario);
        stmt.executeUpdate();
    }
}

    public int contarNaoLidas(int idUsuario) throws Exception {
    String sql = "SELECT COUNT(*) as total FROM notificacao WHERE id_usuario = ? AND lida = false";
    
    try (Connection conn = Conexao.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, idUsuario);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            return rs.getInt("total");
        }
    }
    return 0;
}
    
    
    public void inserir(Notificacao notificacao) throws Exception {
        String sql = """
            INSERT INTO notificacao (id_usuario, titulo, mensagem, tipo, id_frete)
            VALUES (?, ?, ?, ?, ?)
        """;

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, notificacao.getIdUsuario());
            stmt.setString(2, notificacao.getTitulo());
            stmt.setString(3, notificacao.getMensagem());
            stmt.setString(4, notificacao.getTipo());
            stmt.setInt(5, notificacao.getIdFrete());
            
            stmt.executeUpdate();
        }
    }

    public List<Notificacao> listarPorUsuario(int idUsuario) throws Exception {
        String sql = """
            SELECT * FROM notificacao 
            WHERE id_usuario = ? 
            ORDER BY data_criacao DESC
            LIMIT 20
        """;

        List<Notificacao> lista = new ArrayList<>();
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idUsuario);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                lista.add(map(rs));
            }
        }
        return lista;
    }

    public void marcarComoLida(int idNotificacao) throws Exception {
        String sql = "UPDATE notificacao SET lida = true WHERE id = ?";
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idNotificacao);
            stmt.executeUpdate();
        }
    }

   
}