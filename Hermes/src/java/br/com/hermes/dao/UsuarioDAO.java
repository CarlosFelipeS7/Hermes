package br.com.hermes.dao;

import br.com.hermes.model.Usuario;
import java.sql.*;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    // HASH da senha com SHA-256
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

    // Verificar e-mail
    public boolean existeEmail(String email) throws Exception {
        String sql = "SELECT id FROM usuario WHERE email = ?";
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        }
    }

    // Inserir
    public void inserir(Usuario u) throws Exception {
        String sql = """
            INSERT INTO usuario 
            (nome, email, senha, tipo_usuario, telefone, estado, cidade, endereco, documento, veiculo, ddd)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1,  u.getNome());
            stmt.setString(2,  u.getEmail());
            stmt.setString(3,  hashSenha(u.getSenha()));
            stmt.setString(4,  u.getTipoUsuario());
            stmt.setString(5,  u.getTelefone());
            stmt.setString(6,  u.getEstado());
            stmt.setString(7,  u.getCidade());
            stmt.setString(8,  u.getEndereco());
            stmt.setString(9,  u.getDocumento());
            stmt.setString(10, u.getVeiculo());
            stmt.setString(11, u.getDdd());
            stmt.executeUpdate();
        }
    }


    // Listar todos
    public List<Usuario> listarTodos() throws Exception {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuario ORDER BY nome";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) lista.add(mapUsuario(rs));
        }

        return lista;
    }

   // AUTENTICAR
    public Usuario autenticar(String email, String senha) throws Exception {
        String sql = "SELECT * FROM usuario WHERE email = ? AND senha = ?";
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, hashSenha(senha));
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapUsuario(rs);
        }
        return null;
    }


    // Atualizar COMPLETO (corrigido)
    public void atualizar(Usuario u) throws Exception {
        String sql = """
            UPDATE usuario
            SET nome=?, email=?, telefone=?, tipo_usuario=?, ddd=?,
                cidade=?, estado=?, endereco=?, documento=?, veiculo=?
            WHERE id=?
        """;

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, u.getNome());
            stmt.setString(2, u.getEmail());
            stmt.setString(3, u.getTelefone());
            stmt.setString(4, u.getTipoUsuario());
            stmt.setString(5, u.getDdd());

            stmt.setString(6, u.getCidade());
            stmt.setString(7, u.getEstado());
            stmt.setString(8, u.getEndereco());
            stmt.setString(9, u.getDocumento());
            stmt.setString(10, u.getVeiculo());

            stmt.setInt(11, u.getId());
            stmt.executeUpdate();
        }
    }

    // Atualizar senha
    public void atualizarSenha(int id, String novaSenha) throws Exception {
        String sql = "UPDATE usuario SET senha=? WHERE id=?";
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, hashSenha(novaSenha));
            stmt.setInt(2, id);
            stmt.executeUpdate();
        }
    }

    public void deletar(int id) throws Exception {

    String sqlNotificacoes = """
        DELETE FROM notificacao 
        WHERE id_usuario = ?
    """;

    String sqlAvaliacoes = """
        DELETE FROM avaliacao 
        WHERE id_frete IN (
            SELECT id FROM frete 
            WHERE id_cliente = ? OR id_transportador = ?
        )
    """;

    String sqlFretes = """
        DELETE FROM frete 
        WHERE id_cliente = ? OR id_transportador = ?
    """;

    String sqlUsuario = "DELETE FROM usuario WHERE id = ?";

    try (Connection conn = Conexao.getConnection()) {

        conn.setAutoCommit(false); // ✅ TRANSAÇÃO

        try (
            PreparedStatement stmt0 = conn.prepareStatement(sqlNotificacoes);
            PreparedStatement stmt1 = conn.prepareStatement(sqlAvaliacoes);
            PreparedStatement stmt2 = conn.prepareStatement(sqlFretes);
            PreparedStatement stmt3 = conn.prepareStatement(sqlUsuario);
        ) {

            // 1️⃣ APAGA NOTIFICAÇÕES DO USUÁRIO
            stmt0.setInt(1, id);
            stmt0.executeUpdate();

            // 2️⃣ APAGA AVALIAÇÕES DOS FRETES DO USUÁRIO
            stmt1.setInt(1, id);
            stmt1.setInt(2, id);
            stmt1.executeUpdate();

            // 3️⃣ APAGA FRETES DO USUÁRIO
            stmt2.setInt(1, id);
            stmt2.setInt(2, id);
            stmt2.executeUpdate();

            // 4️⃣ APAGA O USUÁRIO
            stmt3.setInt(1, id);
            int rows = stmt3.executeUpdate();

            if (rows == 0) {
                throw new Exception("Usuário não encontrado.");
            }

            conn.commit(); // ✅ CONFIRMA TUDO

            System.out.println("✅ Usuário, notificações, fretes e avaliações apagados com sucesso.");

        } catch (Exception e) {
            conn.rollback(); // ❌ DESFAZ TUDO
            throw e;
        }
    }
}






    // Transportadores por DDD
    public List<Usuario> listarTransportadoresPorDDD(String ddd) throws Exception {
        String sql = """
            SELECT * FROM usuario
            WHERE tipo_usuario = 'transportador' AND ddd = ?
            ORDER BY nome
        """;

        List<Usuario> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, ddd);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) lista.add(mapUsuario(rs));
        }

        return lista;
    }

    // Todos transportadores
    public List<Usuario> listarTodosTransportadores() throws Exception {
        String sql = """
            SELECT * FROM usuario WHERE tipo_usuario='transportador'
            ORDER BY nome
        """;

        List<Usuario> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) lista.add(mapUsuario(rs));
        }

        return lista;
    }

    // Buscar por ID
    public Usuario buscarPorId(int id) throws Exception {
        String sql = "SELECT * FROM usuario WHERE id = ?";
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapUsuario(rs);
        }
        return null;
    }


    // Mapear resultset → objeto
    private Usuario mapUsuario(ResultSet rs) throws Exception {
        Usuario u = new Usuario();

        u.setId(rs.getInt("id"));
        u.setNome(rs.getString("nome"));
        u.setEmail(rs.getString("email"));
        u.setTelefone(rs.getString("telefone"));
        u.setTipoUsuario(rs.getString("tipo_usuario"));

        try { u.setDdd(rs.getString("ddd")); } catch (Exception ignored) {}
        try { u.setCidade(rs.getString("cidade")); } catch (Exception ignored) {}
        try { u.setEstado(rs.getString("estado")); } catch (Exception ignored) {}
        try { u.setEndereco(rs.getString("endereco")); } catch (Exception ignored) {}
        try { u.setDocumento(rs.getString("documento")); } catch (Exception ignored) {}
        try { u.setVeiculo(rs.getString("veiculo")); } catch (Exception ignored) {}
        try { u.setDataCadastro(rs.getTimestamp("data_cadastro")); } catch (Exception ignored) {}

        return u;
    }

    public boolean existeTransportadorComDDD(String ddd) throws Exception {
        String sql = "SELECT COUNT(*) AS total FROM usuario WHERE tipo_usuario='transportador' AND ddd=?";
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, ddd);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt("total") > 0;
        }
        return false;
    }

    public List<String> listarDDDsDisponiveis() throws Exception {
        String sql = """
            SELECT DISTINCT ddd FROM usuario
            WHERE tipo_usuario='transportador' AND ddd IS NOT NULL AND ddd != ''
            ORDER BY ddd
        """;

        List<String> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) lista.add(rs.getString("ddd"));
        }

        return lista;
    }
}
