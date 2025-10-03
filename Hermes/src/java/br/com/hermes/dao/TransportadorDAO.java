package br.com.hermes.dao;

import br.com.hermes.model.Transportador;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TransportadorDAO {

   
    public boolean inserir(Transportador t) {
        String sql = "INSERT INTO transportador (nome, email, senha, veiculo, documento) VALUES (?, ?, ?, ?, ?)";

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {

            stmt.setString(1, t.getNome());
            stmt.setString(2, t.getEmail());
            stmt.setString(3, t.getSenha());
            stmt.setString(4, t.getTipoVeiculo()); 
            stmt.setString(5, t.getCpf());        

            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;

        } catch (SQLException e) {
            System.err.println("Erro ao inserir transportador: " + e.getMessage());
            return false;
        }
    }
    
  
    public List<Transportador> listarTodos() {
        String sql = "SELECT id, nome, email, veiculo, documento FROM transportador ORDER BY nome";
        List<Transportador> lista = new ArrayList<>();

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Transportador t = new Transportador();
                
               
                t.setId(rs.getInt("id"));
                t.setNome(rs.getString("nome"));
                t.setEmail(rs.getString("email"));
                t.setTipoVeiculo(rs.getString("veiculo"));
                t.setCpf(rs.getString("documento"));
                
              
                
                lista.add(t);
            }
        } catch (SQLException e) {
            System.err.println("Erro ao listar transportadores: " + e.getMessage());
        }
        return lista;
    }
    
  
    public Transportador buscarPorId(int id) {
      
        String sql = "SELECT id, nome, email, senha, veiculo, documento FROM transportador WHERE id = ?";
        Transportador t = null;

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {

            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    t = new Transportador();
                    t.setId(rs.getInt("id"));
                    t.setNome(rs.getString("nome"));
                    t.setEmail(rs.getString("email"));
                    t.setSenha(rs.getString("senha")); 
                    t.setTipoVeiculo(rs.getString("veiculo"));
                    t.setCpf(rs.getString("documento"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Erro ao buscar transportador por ID: " + e.getMessage());
        }
        return t;
    }

    public boolean atualizar(Transportador t) {
        String sql = "UPDATE transportador SET nome = ?, email = ?, senha = ?, veiculo = ?, documento = ? WHERE id = ?";

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {

            stmt.setString(1, t.getNome());
            stmt.setString(2, t.getEmail());
            stmt.setString(3, t.getSenha());
            stmt.setString(4, t.getTipoVeiculo());
            stmt.setString(5, t.getCpf());
            stmt.setInt(6, t.getId());

            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;

        } catch (SQLException e) {
            System.err.println("Erro ao atualizar transportador: " + e.getMessage());
            return false;
        }
    }
    
    
    public boolean deletar(int id) {
        String sql = "DELETE FROM transportador WHERE id = ?";

        try (Connection conexao = Conexao.getConnection(); 
                
             PreparedStatement stmt = conexao.prepareStatement(sql)) {

            stmt.setInt(1, id);

            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;

        } catch (SQLException e) {
           
            System.err.println("Erro ao deletar transportador. Verifique se ele possui fretes pendentes: " + e.getMessage());
            return false;
        }
    }
}