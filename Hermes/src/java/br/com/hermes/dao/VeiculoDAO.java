package br.com.hermes.dao;

import br.com.hermes.model.Veiculo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VeiculoDAO {

    // INSERIR
    public void inserir(Veiculo v, int idUsuario) throws Exception {
        String sql = """
            INSERT INTO veiculo
            (id_usuario, tipo_veiculo, marca, modelo, ano, placa, capacidade, cor, ativo)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idUsuario);
            stmt.setString(2, v.getTipoVeiculo());
            stmt.setString(3, v.getMarca());
            stmt.setString(4, v.getModelo());
            stmt.setInt(5, v.getAno());
            stmt.setString(6, v.getPlaca());
            stmt.setDouble(7, v.getCapacidade());
            stmt.setString(8, v.getCor());
            stmt.setBoolean(9, v.isAtivo());

            stmt.executeUpdate();
        }
    }

    // ATUALIZAR
    public void atualizar(Veiculo v, int idUsuario) throws Exception {
        String sql = """
            UPDATE veiculo
               SET tipo_veiculo = ?,
                   marca        = ?,
                   modelo       = ?,
                   ano          = ?,
                   placa        = ?,
                   capacidade   = ?,
                   cor          = ?,
                   ativo        = ?
             WHERE id = ?
               AND id_usuario = ?
        """;

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, v.getTipoVeiculo());
            stmt.setString(2, v.getMarca());
            stmt.setString(3, v.getModelo());
            stmt.setInt(4, v.getAno());
            stmt.setString(5, v.getPlaca());
            stmt.setDouble(6, v.getCapacidade());
            stmt.setString(7, v.getCor());
            stmt.setBoolean(8, v.isAtivo());
            stmt.setInt(9, v.getId());
            stmt.setInt(10, idUsuario);

            stmt.executeUpdate();
        }
    }

    // EXCLUIR
    public void excluir(int idVeiculo, int idUsuario) throws Exception {
        String sql = "DELETE FROM veiculo WHERE id = ? AND id_usuario = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idVeiculo);
            stmt.setInt(2, idUsuario);

            stmt.executeUpdate();
        }
    }
    
    public Veiculo buscarPorId(int id) throws Exception {
        String sql = "SELECT * FROM veiculo WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Veiculo v = new Veiculo();
                v.setId(rs.getInt("id"));
                v.setTipoVeiculo(rs.getString("tipo_veiculo"));
                v.setMarca(rs.getString("marca"));
                v.setModelo(rs.getString("modelo"));
                v.setAno(rs.getInt("ano"));
                v.setPlaca(rs.getString("placa"));
                v.setCapacidade(rs.getDouble("capacidade"));
                v.setCor(rs.getString("cor"));
                v.setAtivo(rs.getBoolean("ativo"));
                v.setIdUsuario(rs.getInt("id_usuario"));
                v.setDataCadastro(rs.getTimestamp("data_cadastro"));

                return v;
            }
        } catch (Exception e) {
            throw new Exception("Erro ao buscar veículo por ID: " + e.getMessage());
        }
        return null;
    }


    // LISTAR POR USUÁRIO
    public List<Veiculo> listarPorUsuario(int idUsuario) throws Exception {
        String sql = "SELECT * FROM veiculo WHERE id_usuario = ? ORDER BY marca, modelo";

        List<Veiculo> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idUsuario);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Veiculo v = new Veiculo();
                v.setId(rs.getInt("id"));
                v.setTipoVeiculo(rs.getString("tipo_veiculo"));
                v.setMarca(rs.getString("marca"));
                v.setModelo(rs.getString("modelo"));
                v.setAno(rs.getInt("ano"));
                v.setPlaca(rs.getString("placa"));
                v.setCapacidade(rs.getDouble("capacidade"));
                v.setCor(rs.getString("cor"));
                v.setAtivo(rs.getBoolean("ativo"));
                v.setDataCadastro(rs.getTimestamp("data_cadastro"));

                lista.add(v);
            }
        }

        return lista;
    }
    
    
}
