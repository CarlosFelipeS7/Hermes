package br.com.hermes.dao;

import br.com.hermes.model.Veiculo;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VeiculoDAO {

    public boolean cadastrarVeiculo(Veiculo veiculo) {
        String sql = "INSERT INTO veiculo (id_usuario, tipo_veiculo, marca, modelo, ano, placa, capacidade, cor) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, veiculo.getIdUsuario());
            stmt.setString(2, veiculo.getTipoVeiculo());
            stmt.setString(3, veiculo.getMarca());
            stmt.setString(4, veiculo.getModelo());
            stmt.setInt(5, veiculo.getAno());
            stmt.setString(6, veiculo.getPlaca());
            stmt.setDouble(7, veiculo.getCapacidade());
            stmt.setString(8, veiculo.getCor());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao cadastrar veículo: " + e.getMessage());
            return false;
        }
    }

    public List<Veiculo> listarVeiculosPorUsuario(Integer idUsuario) {
        List<Veiculo> veiculos = new ArrayList<>();
        String sql = "SELECT * FROM veiculo WHERE id_usuario = ? AND ativo = true ORDER BY data_cadastro DESC";
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Veiculo veiculo = new Veiculo();
                veiculo.setId(rs.getInt("id"));
                veiculo.setIdUsuario(rs.getInt("id_usuario"));
                veiculo.setTipoVeiculo(rs.getString("tipo_veiculo"));
                veiculo.setMarca(rs.getString("marca"));
                veiculo.setModelo(rs.getString("modelo"));
                veiculo.setAno(rs.getInt("ano"));
                veiculo.setPlaca(rs.getString("placa"));
                veiculo.setCapacidade(rs.getDouble("capacidade"));
                veiculo.setCor(rs.getString("cor"));
                veiculo.setAtivo(rs.getBoolean("ativo"));
                veiculo.setDataCadastro(rs.getTimestamp("data_cadastro").toLocalDateTime());
                
                veiculos.add(veiculo);
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar veículos: " + e.getMessage());
        }
        
        return veiculos;
    }

    public boolean excluirVeiculo(Integer idVeiculo, Integer idUsuario) {
        String sql = "UPDATE veiculo SET ativo = false WHERE id = ? AND id_usuario = ?";
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idVeiculo);
            stmt.setInt(2, idUsuario);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao excluir veículo: " + e.getMessage());
            return false;
        }
    }

    public boolean placaExiste(String placa) {
        String sql = "SELECT COUNT(*) FROM veiculo WHERE placa = ? AND ativo = true";
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, placa);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao verificar placa: " + e.getMessage());
        }
        
        return false;
    }
}