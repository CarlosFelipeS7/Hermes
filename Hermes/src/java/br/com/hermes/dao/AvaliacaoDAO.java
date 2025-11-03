package br.com.hermes.dao;

import br.com.hermes.model.Avaliacao;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AvaliacaoDAO {
    
    public boolean inserir(Avaliacao avaliacao) {
        String sql = "INSERT INTO avaliacao (nota, comentario, data_avaliacao, id_frete, id_avaliador, id_avaliado, tipo) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, avaliacao.getNota());
            stmt.setString(2, avaliacao.getComentario());
            stmt.setTimestamp(3, new Timestamp(avaliacao.getDataAvaliacao().getTime()));
            stmt.setInt(4, avaliacao.getIdFrete());
            stmt.setInt(5, avaliacao.getIdAvaliador());
            stmt.setInt(6, avaliacao.getIdAvaliado());
            stmt.setString(7, avaliacao.getTipo());
            
            int linhasAfetadas = stmt.executeUpdate();
            
            
            if (linhasAfetadas > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    avaliacao.setId(rs.getInt(1));
                }
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao inserir avaliação: " + e.getMessage());
        }
        return false;
    }
    
    
    public Avaliacao buscarPorId(int id) {
        String sql = "SELECT * FROM avaliacao WHERE id = ?";
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return resultSetParaAvaliacao(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao buscar avaliação por ID: " + e.getMessage());
        }
        return null;
    }
    
    
    public List<Avaliacao> listarTodas() {
        String sql = "SELECT * FROM avaliacao ORDER BY data_avaliacao DESC";
        List<Avaliacao> avaliacoes = new ArrayList<>();
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Avaliacao avaliacao = resultSetParaAvaliacao(rs);
                avaliacoes.add(avaliacao);
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar avaliações: " + e.getMessage());
        }
        return avaliacoes;
    }
    
    public List<Avaliacao> listarPorFrete(int idFrete) {
        String sql = "SELECT * FROM avaliacao WHERE id_frete = ? ORDER BY data_avaliacao DESC";
        List<Avaliacao> avaliacoes = new ArrayList<>();
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idFrete);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Avaliacao avaliacao = resultSetParaAvaliacao(rs);
                avaliacoes.add(avaliacao);
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar avaliações do frete: " + e.getMessage());
        }
        return avaliacoes;
    }
    
    
    public List<Avaliacao> listarRecebidasPorUsuario(int idUsuario) {
        String sql = "SELECT * FROM avaliacao WHERE id_avaliado = ? ORDER BY data_avaliacao DESC";
        List<Avaliacao> avaliacoes = new ArrayList<>();
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Avaliacao avaliacao = resultSetParaAvaliacao(rs);
                avaliacoes.add(avaliacao);
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar avaliações recebidas: " + e.getMessage());
        }
        return avaliacoes;
    }
    
    
    public List<Avaliacao> listarFeitasPorUsuario(int idUsuario) {
        String sql = "SELECT * FROM avaliacao WHERE id_avaliador = ? ORDER BY data_avaliacao DESC";
        List<Avaliacao> avaliacoes = new ArrayList<>();
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Avaliacao avaliacao = resultSetParaAvaliacao(rs);
                avaliacoes.add(avaliacao);
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar avaliações feitas: " + e.getMessage());
        }
        return avaliacoes;
    }
    
    
    public double calcularMediaAvaliacoes(int idUsuario) {
        String sql = "SELECT AVG(nota) as media FROM avaliacao WHERE id_avaliado = ?";
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("media");
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao calcular média de avaliações: " + e.getMessage());
        }
        return 0.0;
    }
    
    
    public int contarAvaliacoesRecebidas(int idUsuario) {
        String sql = "SELECT COUNT(*) as total FROM avaliacao WHERE id_avaliado = ?";
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao contar avaliações: " + e.getMessage());
        }
        return 0;
    }
    
    public boolean existeAvaliacao(int idFrete, String tipo, int idAvaliador) {
        String sql = "SELECT COUNT(*) as total FROM avaliacao WHERE id_frete = ? AND tipo = ? AND id_avaliador = ?";
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idFrete);
            stmt.setString(2, tipo);
            stmt.setInt(3, idAvaliador);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total") > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao verificar existência de avaliação: " + e.getMessage());
        }
        return false;
    }
    
    public boolean atualizar(Avaliacao avaliacao) {
        String sql = "UPDATE avaliacao SET nota = ?, comentario = ?, data_avaliacao = ? WHERE id = ?";
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, avaliacao.getNota());
            stmt.setString(2, avaliacao.getComentario());
            stmt.setTimestamp(3, new Timestamp(avaliacao.getDataAvaliacao().getTime()));
            stmt.setInt(4, avaliacao.getId());
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao atualizar avaliação: " + e.getMessage());
        }
        return false;
    }
    
    public boolean excluir(int id) {
        String sql = "DELETE FROM avaliacao WHERE id = ?";
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao excluir avaliação: " + e.getMessage());
        }
        return false;
    }
    
    
    private Avaliacao resultSetParaAvaliacao(ResultSet rs) throws SQLException {
        Avaliacao avaliacao = new Avaliacao();
        avaliacao.setId(rs.getInt("id"));
        avaliacao.setNota(rs.getInt("nota"));
        avaliacao.setComentario(rs.getString("comentario"));
        avaliacao.setDataAvaliacao(rs.getTimestamp("data_avaliacao"));
        avaliacao.setIdFrete(rs.getInt("id_frete"));
        avaliacao.setIdAvaliador(rs.getInt("id_avaliador"));
        avaliacao.setIdAvaliado(rs.getInt("id_avaliado"));
        avaliacao.setTipo(rs.getString("tipo"));
        return avaliacao;
    }
}