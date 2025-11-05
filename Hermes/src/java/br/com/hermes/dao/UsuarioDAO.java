package br.com.hermes.dao;

import br.com.hermes.model.Usuario;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.security.MessageDigest;

public class UsuarioDAO {

    private String hashSenha(String senha) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(senha.getBytes("UTF-8"));
        StringBuilder hex = new StringBuilder();
        for (byte b : hash) {
            String h = Integer.toHexString(0xff & b);
            if (h.length() == 1) hex.append('0');
            hex.append(h);
        }
        return hex.toString();
    }

    public void inserir(Usuario u) throws Exception {
        String sql = """
            INSERT INTO usuario 
            (nome, email, senha, tipo_usuario, telefone, endereco, veiculo, documento) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, u.getNome());
            stmt.setString(2, u.getEmail());
            stmt.setString(3, hashSenha(u.getSenha()));
            stmt.setString(4, u.getTipoUsuario());
            stmt.setString(5, u.getTelefone());
            stmt.setString(6, u.getEndereco());
            stmt.setString(7, u.getVeiculo());
            stmt.setString(8, u.getDocumento());
            stmt.executeUpdate();
        }
    }

    public List<Usuario> listarTodos() throws Exception {
        List<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT * FROM usuario ORDER BY nome";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt("id"));
                u.setNome(rs.getString("nome"));
                u.setEmail(rs.getString("email"));
                u.setTipoUsuario(rs.getString("tipo_usuario"));
                u.setTelefone(rs.getString("telefone"));
                u.setEndereco(rs.getString("endereco"));
                u.setVeiculo(rs.getString("veiculo"));
                u.setDocumento(rs.getString("documento"));
                usuarios.add(u);
            }
        }
        return usuarios;
    }

    public Usuario autenticar(String email, String senha) throws Exception {
        String sql = "SELECT * FROM usuario WHERE email = ? AND senha = ?";
        Usuario u = null;

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, hashSenha(senha));

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    u = new Usuario();
                    u.setId(rs.getInt("id"));
                    u.setNome(rs.getString("nome"));
                    u.setEmail(rs.getString("email"));
                    u.setTipoUsuario(rs.getString("tipo_usuario"));
                    u.setTelefone(rs.getString("telefone"));
                    u.setEndereco(rs.getString("endereco"));
                    u.setVeiculo(rs.getString("veiculo"));
                    u.setDocumento(rs.getString("documento"));
                }
            }
        }
        return u;
    }

    public void atualizar(Usuario u) throws Exception {
        String sql = """
            UPDATE usuario 
            SET nome=?, email=?, senha=?, telefone=?, endereco=?, veiculo=?, documento=? 
            WHERE id=?
        """;
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, u.getNome());
            stmt.setString(2, u.getEmail());
            stmt.setString(3, hashSenha(u.getSenha()));
            stmt.setString(4, u.getTelefone());
            stmt.setString(5, u.getEndereco());
            stmt.setString(6, u.getVeiculo());
            stmt.setString(7, u.getDocumento());
            stmt.setInt(8, u.getId());
            stmt.executeUpdate();
        }
    }

    public void deletar(int id) throws Exception {
        String sql = "DELETE FROM usuario WHERE id=?";
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }
}
