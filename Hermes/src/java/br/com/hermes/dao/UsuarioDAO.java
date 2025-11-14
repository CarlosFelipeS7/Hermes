package br.com.hermes.dao;

import br.com.hermes.model.Usuario;
import java.sql.*;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    // -----------------------------------------------------
    // HASH da senha usando SHA-256
    // -----------------------------------------------------
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

    // -----------------------------------------------------
    // VERIFICAR SE EMAIL JÁ EXISTE
    // -----------------------------------------------------
    public boolean existeEmail(String email) throws Exception {
        String sql = "SELECT id FROM usuario WHERE email = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            return rs.next(); // se achou, o email já existe
        }
    }

    // -----------------------------------------------------
    // INSERIR USUÁRIO
    // -----------------------------------------------------
    public void inserir(Usuario u) throws Exception {
        String sql = """
            INSERT INTO usuario 
            (nome, email, senha, tipo_usuario, telefone)
            VALUES (?, ?, ?, ?, ?)
        """;

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, u.getNome());
            stmt.setString(2, u.getEmail());
            stmt.setString(3, hashSenha(u.getSenha()));
            stmt.setString(4, u.getTipoUsuario());
            stmt.setString(5, u.getTelefone());
            stmt.executeUpdate();
        }
    }

    // -----------------------------------------------------
    // LISTAR TODOS
    // -----------------------------------------------------
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
                u.setTelefone(rs.getString("telefone"));
                u.setTipoUsuario(rs.getString("tipo_usuario"));
                usuarios.add(u);
            }
        }
        return usuarios;
    }

    // -----------------------------------------------------
    // AUTENTICAR LOGIN
    // -----------------------------------------------------
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
                    u.setTelefone(rs.getString("telefone"));
                    u.setTipoUsuario(rs.getString("tipo_usuario"));
                }
            }
        }
        return u;
    }

    // -----------------------------------------------------
    // ATUALIZAR
    // -----------------------------------------------------
    public void atualizar(Usuario u) throws Exception {
        String sql = """
            UPDATE usuario 
            SET nome=?, email=?, telefone=?, tipo_usuario=?
            WHERE id=?
        """;

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, u.getNome());
            stmt.setString(2, u.getEmail());
            stmt.setString(3, u.getTelefone());
            stmt.setString(4, u.getTipoUsuario());
            stmt.setInt(5, u.getId());
            stmt.executeUpdate();
        }
    }

    // -----------------------------------------------------
    // ATUALIZAR SOMENTE A SENHA
    // -----------------------------------------------------
    public void atualizarSenha(int id, String novaSenha) throws Exception {
        String sql = "UPDATE usuario SET senha=? WHERE id=?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, hashSenha(novaSenha));
            stmt.setInt(2, id);
            stmt.executeUpdate();
        }
    }

    // -----------------------------------------------------
    // EXCLUIR
    // -----------------------------------------------------
    public void deletar(int id) throws Exception {
        String sql = "DELETE FROM usuario WHERE id=?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }
}
