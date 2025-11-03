/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.hermes.dao;

import br.com.hermes.model.Frete;
import java.sql.Connection; 
import java.sql.PreparedStatement; 
import java.sql.ResultSet;   
import java.sql.SQLException;
import java.sql.Statement; 
import java.sql.Timestamp;
import java.util.ArrayList; 
import java.util.List;

/**
 *
 * @author ccfel
 */
public class FreteDAO {
    
    public boolean inserir(Frete frete) {
        String sql = "INSERT INTO frete (origem, destino, descricao_carga, peso, valor, status, data_solicitacao, id_cliente) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, frete.getOrigem());
            stmt.setString(2, frete.getDestino());
            stmt.setString(3, frete.getDescricaoCarga());
            stmt.setDouble(4, frete.getPeso());
            stmt.setDouble(5, frete.getValor());
            stmt.setString(6, frete.getStatus());
            stmt.setTimestamp(7, new Timestamp(frete.getDataSolicitacao().getTime()));
            stmt.setInt(8, frete.getIdCliente());
            
            int linhasAfetadas = stmt.executeUpdate();
            
            
            if (linhasAfetadas > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    frete.setId(rs.getInt(1));
                }
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao inserir frete: " + e.getMessage());
        }
        return false;
    }
    
  
    public List<Frete> listarTodos() {
        String sql = "SELECT * FROM frete ORDER BY data_solicitacao DESC";
        List<Frete> fretes = new ArrayList<>();
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Frete frete = resultSetParaFrete(rs);
                fretes.add(frete);
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar fretes: " + e.getMessage());
        }
        return fretes;
    }
    

    public Frete buscarPorId(int id) {
        String sql = "SELECT * FROM frete WHERE id = ?";
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return resultSetParaFrete(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao buscar frete por ID: " + e.getMessage());
        }
        return null;
    }
    

    public List<Frete> listarPorCliente(int idCliente) {
        String sql = "SELECT * FROM frete WHERE id_cliente = ? ORDER BY data_solicitacao DESC";
        List<Frete> fretes = new ArrayList<>();
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idCliente);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Frete frete = resultSetParaFrete(rs);
                fretes.add(frete);
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar fretes do cliente: " + e.getMessage());
        }
        return fretes;
    }
    
    public List<Frete> listarFretesDisponiveis() {
        String sql = "SELECT * FROM frete WHERE status = 'PENDENTE' ORDER BY data_solicitacao DESC";
        List<Frete> fretes = new ArrayList<>();
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Frete frete = resultSetParaFrete(rs);
                fretes.add(frete);
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar fretes disponíveis: " + e.getMessage());
        }
        return fretes;
    }
    
    public List<Frete> listarPorTransportador(int idTransportador) {
        String sql = "SELECT * FROM frete WHERE id_transportador = ? ORDER BY data_solicitacao DESC";
        List<Frete> fretes = new ArrayList<>();
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idTransportador);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Frete frete = resultSetParaFrete(rs);
                fretes.add(frete);
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar fretes do transportador: " + e.getMessage());
        }
        return fretes;
    }
    
    public boolean aceitarFrete(int idFrete, int idTransportador) {
        String sql = "UPDATE frete SET status = 'ACEITO', id_transportador = ? WHERE id = ? AND status = 'PENDENTE'";
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idTransportador);
            stmt.setInt(2, idFrete);
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao aceitar frete: " + e.getMessage());
        }
        return false;
    }
    
    public boolean atualizarStatus(int idFrete, String novoStatus) {
        String sql = "UPDATE frete SET status = ? WHERE id = ?";
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, novoStatus);
            stmt.setInt(2, idFrete);
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao atualizar status do frete: " + e.getMessage());
        }
        return false;
    }
    
    public boolean concluirFrete(int idFrete) {
        String sql = "UPDATE frete SET status = 'CONCLUIDO', data_conclusao = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idFrete);
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao concluir frete: " + e.getMessage());
        }
        return false;
    }
    
    public boolean cancelarFrete(int idFrete) {
        String sql = "DELETE FROM frete WHERE id = ? AND status = 'PENDENTE'";
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idFrete);
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao cancelar frete: " + e.getMessage());
        }
        return false;
    }
    
    private Frete resultSetParaFrete(ResultSet rs) throws SQLException {
        Frete frete = new Frete();
        frete.setId(rs.getInt("id"));
        frete.setOrigem(rs.getString("origem"));
        frete.setDestino(rs.getString("destino"));
        frete.setDescricaoCarga(rs.getString("descricao_carga"));
        frete.setPeso(rs.getDouble("peso"));
        frete.setValor(rs.getDouble("valor"));
        frete.setStatus(rs.getString("status"));
        frete.setDataSolicitacao(rs.getTimestamp("data_solicitacao"));
        frete.setDataConclusao(rs.getTimestamp("data_conclusao"));
        frete.setIdCliente(rs.getInt("id_cliente"));
        frete.setIdTransportador(rs.getInt("id_transportador"));
        return frete;
    }
}