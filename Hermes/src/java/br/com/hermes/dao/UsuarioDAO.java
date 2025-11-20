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
            (nome, email, senha, tipo_usuario, telefone, ddd)
            VALUES (?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, u.getNome());
            stmt.setString(2, u.getEmail());
            stmt.setString(3, hashSenha(u.getSenha()));
            stmt.setString(4, u.getTipoUsuario());
            stmt.setString(5, u.getTelefone());
            stmt.setString(6, u.getDdd());
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
                Usuario u = mapUsuario(rs);
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
                    u = mapUsuario(rs);
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
            SET nome=?, email=?, telefone=?, tipo_usuario=?, ddd=?
            WHERE id=?
        """;

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, u.getNome());
            stmt.setString(2, u.getEmail());
            stmt.setString(3, u.getTelefone());
            stmt.setString(4, u.getTipoUsuario());
            stmt.setString(5, u.getDdd());
            stmt.setInt(6, u.getId());
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

    // -----------------------------------------------------
    // LISTAR TRANSPORTADORES POR DDD
    // -----------------------------------------------------
    public List<Usuario> listarTransportadoresPorDDD(String ddd) throws Exception {
        String sql = """
            SELECT id, nome, email, telefone, ddd, veiculo, cidade, estado, tipo_usuario
            FROM usuario 
            WHERE tipo_usuario = 'transportador' 
            AND ddd = ?
            ORDER BY nome
        """;

        List<Usuario> transportadores = new ArrayList<>();
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, ddd);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Usuario u = mapUsuario(rs);
                transportadores.add(u);
            }
        }
        return transportadores;
    }

    // -----------------------------------------------------
    // LISTAR TODOS OS TRANSPORTADORES
    // -----------------------------------------------------
    public List<Usuario> listarTodosTransportadores() throws Exception {
        String sql = """
            SELECT id, nome, email, telefone, ddd, veiculo, cidade, estado, tipo_usuario
            FROM usuario 
            WHERE tipo_usuario = 'transportador'
            ORDER BY nome
        """;

        List<Usuario> transportadores = new ArrayList<>();
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Usuario u = mapUsuario(rs);
                transportadores.add(u);
            }
        }
        return transportadores;
    }

    // -----------------------------------------------------
    // BUSCAR USUÁRIO POR ID
    // -----------------------------------------------------
    public Usuario buscarPorId(int id) throws Exception {
        String sql = "SELECT * FROM usuario WHERE id = ?";
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapUsuario(rs);
            }
        }
        return null;
    }

    // -----------------------------------------------------
    // MÉTODO AUXILIAR PARA MAPEAR RESULTSET → USUARIO
    // -----------------------------------------------------
   private Usuario mapUsuario(ResultSet rs) throws Exception {
    Usuario u = new Usuario();
    
    // Colunas OBRIGATÓRIAS (que sempre existem)
    u.setId(rs.getInt("id"));
    u.setNome(rs.getString("nome"));
    u.setEmail(rs.getString("email"));
    u.setTelefone(rs.getString("telefone"));
    u.setTipoUsuario(rs.getString("tipo_usuario"));
    
    // Colunas OPCIONAIS (com try-catch)
    try { u.setDdd(rs.getString("ddd")); } catch (SQLException e) { u.setDdd(null); }
    try { u.setVeiculo(rs.getString("veiculo")); } catch (SQLException e) { u.setVeiculo(null); }
    try { u.setDocumento(rs.getString("documento")); } catch (SQLException e) { u.setDocumento(null); }
    try { u.setEndereco(rs.getString("endereco")); } catch (SQLException e) { u.setEndereco(null); }
    try { u.setCidade(rs.getString("cidade")); } catch (SQLException e) { u.setCidade(null); }
    try { u.setEstado(rs.getString("estado")); } catch (SQLException e) { u.setEstado(null); }
    
    // Data de cadastro (com fallback)
    try {
        u.setDataCadastro(rs.getTimestamp("data_cadastro"));
    } catch (SQLException e) {
        u.setDataCadastro(new Timestamp(System.currentTimeMillis()));
    }
    
    return u;
}

    // -----------------------------------------------------
    // VERIFICAR SE DDD EXISTE PARA TRANSPORTADORES
    // -----------------------------------------------------
    public boolean existeTransportadorComDDD(String ddd) throws Exception {
        String sql = """
            SELECT COUNT(*) as total 
            FROM usuario 
            WHERE tipo_usuario = 'transportador' AND ddd = ?
        """;

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, ddd);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("total") > 0;
            }
        }
        return false;
    }

    // -----------------------------------------------------
    // LISTAR DDDS DISPONÍVEIS PARA TRANSPORTADORES
    // -----------------------------------------------------
    public List<String> listarDDDsDisponiveis() throws Exception {
        String sql = """
            SELECT DISTINCT ddd 
            FROM usuario 
            WHERE tipo_usuario = 'transportador' 
            AND ddd IS NOT NULL 
            AND ddd != ''
            ORDER BY ddd
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
}