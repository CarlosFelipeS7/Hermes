package br.com.hermes.dao;

import br.com.hermes.model.Frete;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FreteDAO {

    // ==========================================================
    // EXCLUIR FRETE
    // ==========================================================
    public boolean excluir(int idFrete) {
        String sql = "DELETE FROM frete WHERE id = ?";
        
        System.out.println("=== DEBUG FreteDAO.excluir ===");
        System.out.println("ID Frete a excluir: " + idFrete);
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idFrete);
            int rowsAffected = stmt.executeUpdate();
            
            System.out.println("✅ Linhas afetadas na exclusão: " + rowsAffected);
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("❌ Erro ao excluir frete " + idFrete + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ==========================================================
    // VERIFICAR SE FRETE PODE SER EXCLUÍDO
    // ==========================================================
    public boolean podeExcluir(int idFrete) {
        String sql = "SELECT status FROM frete WHERE id = ?";
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idFrete);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                String status = rs.getString("status");
                // Permite excluir apenas fretes com status "disponivel" ou "concluido"
                boolean podeExcluir = "disponivel".equalsIgnoreCase(status) || 
                                     "concluido".equalsIgnoreCase(status);
                
                System.out.println("🔍 Status do frete " + idFrete + ": " + status + " - Pode excluir: " + podeExcluir);
                return podeExcluir;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Erro ao verificar se frete pode ser excluído: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }

    // ==========================================================
    // VERIFICAR SE USUÁRIO É DONO DO FRETE
    // ==========================================================
    public boolean isDonoFrete(int idFrete, int idUsuario, String tipoUsuario) {
        String sql = "SELECT id_cliente, id_transportador FROM frete WHERE id = ?";
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idFrete);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                int idCliente = rs.getInt("id_cliente");
                int idTransportador = rs.getInt("id_transportador");
                
                if ("cliente".equalsIgnoreCase(tipoUsuario)) {
                    return idCliente == idUsuario;
                } else if ("transportador".equalsIgnoreCase(tipoUsuario)) {
                    return idTransportador == idUsuario;
                }
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Erro ao verificar dono do frete: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }

    // ==========================================================
    // OBTER DETALHES DO FRETE PARA VALIDAÇÃO
    // ==========================================================
    public Frete obterFreteParaValidacao(int idFrete) {
        String sql = "SELECT id, status, id_cliente, id_transportador FROM frete WHERE id = ?";
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idFrete);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Frete frete = new Frete();
                frete.setId(rs.getInt("id"));
                frete.setStatus(rs.getString("status"));
                frete.setIdCliente(rs.getInt("id_cliente"));
                frete.setIdTransportador(rs.getInt("id_transportador"));
                return frete;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Erro ao obter frete para validação: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }

    // ==========================================================
    // MAPEAR RESULTSET → OBJETO FRETE
    // ==========================================================
    private Frete map(ResultSet rs) throws Exception {
        Frete f = new Frete();
        f.setId(rs.getInt("id"));
        f.setOrigem(rs.getString("origem"));
        f.setDestino(rs.getString("destino"));
        f.setDescricaoCarga(rs.getString("descricao_carga"));
        f.setPeso(rs.getDouble("peso"));
        f.setValor(rs.getDouble("valor"));
        f.setStatus(rs.getString("status"));
        f.setDataSolicitacao(rs.getTimestamp("data_solicitacao"));
        f.setDataConclusao(rs.getTimestamp("data_conclusao"));
        
        // NOVO CAMPO: DDD de origem
        try {
            f.setDddOrigem(rs.getString("ddd_origem"));
        } catch (SQLException e) {
            f.setDddOrigem(null); // Caso a coluna não exista ainda
        }

        int idCliente = rs.getInt("id_cliente");
        if (!rs.wasNull())
            f.setIdCliente(idCliente);

        int idTransportador = rs.getInt("id_transportador");
        if (!rs.wasNull())
            f.setIdTransportador(idTransportador);

        return f;
    }

    // ==========================================================
    // INSERIR FRETE (CLIENTE) - COM DDD
    // ==========================================================
    public void inserir(Frete f) throws Exception {
        String sql = """
            INSERT INTO frete 
            (origem, destino, descricao_carga, peso, valor, status, 
             data_solicitacao, id_cliente, ddd_origem)
            VALUES (?, ?, ?, ?, ?, 'pendente', CURRENT_TIMESTAMP, ?, ?)
        """;

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, f.getOrigem());
            stmt.setString(2, f.getDestino());
            stmt.setString(3, f.getDescricaoCarga());
            stmt.setDouble(4, f.getPeso());
            stmt.setDouble(5, f.getValor());
            stmt.setInt(6, f.getIdCliente());
            stmt.setString(7, f.getDddOrigem());
            stmt.executeUpdate();
        }
    }

    // ==========================================================
    // LISTAR FRETES PENDENTES POR DDD (para transportador)
    // ==========================================================
    public List<Frete> listarPendentesPorDDD(String ddd) throws Exception {
        String sql = """
            SELECT * FROM frete
            WHERE LOWER(status) = 'pendente' AND ddd_origem = ?
            ORDER BY data_solicitacao DESC
        """;

        List<Frete> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, ddd);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) lista.add(map(rs));
        }

        return lista;
    }

    // ==========================================================
    // LISTAR FRETES PENDENTES (para transportador) - TODOS
    // ==========================================================
    public List<Frete> listarPendentesTodos() throws Exception {
        String sql = """
            SELECT * FROM frete
            WHERE LOWER(status) = 'pendente'
            ORDER BY data_solicitacao DESC
        """;

        List<Frete> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) lista.add(map(rs));
        }

        return lista;
    }

    // ==========================================================
    // LISTAR APENAS 3 FRETES PENDENTES
    // ==========================================================
    public List<Frete> listarPendentes(int limit) throws Exception {
        String sql = """
            SELECT * FROM frete
            WHERE LOWER(status) = 'pendente'
            ORDER BY data_solicitacao DESC
            LIMIT ?
        """;

        List<Frete> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) lista.add(map(rs));
        }

        return lista;
    }

    // ==========================================================
    // LISTAR FRETES DO CLIENTE (limit configurável)
    // ==========================================================
    public List<Frete> listarFretesCliente(int idCliente, int limit) throws Exception {
        String sql = """
            SELECT * FROM frete
            WHERE id_cliente = ?
            ORDER BY data_solicitacao DESC
            LIMIT ?
        """;

        List<Frete> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idCliente);
            stmt.setInt(2, limit);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) lista.add(map(rs));
        }

        return lista;
    }

    // ==========================================================
    // LISTAR ÚLTIMOS 3 FRETES DO CLIENTE
    // ==========================================================
    public List<Frete> listarFretesRecentesCliente(int idCliente) throws Exception {
        return listarFretesCliente(idCliente, 3);
    }

    // ==========================================================
    // ACEITAR FRETE (status → ACEITO)
    // ==========================================================
    public void aceitarFrete(int idFrete, int idTransportador) throws Exception {
        String sql = """
            UPDATE frete
            SET status = 'aceito', id_transportador = ?
            WHERE id = ?
        """;

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTransportador);
            stmt.setInt(2, idFrete);
            stmt.executeUpdate();
        }
    }

    // ==========================================================
    // INICIAR FRETE (status → EM_ANDAMENTO)
    // ==========================================================
    public void iniciarFrete(int idFrete) throws Exception {
        String sql = """
            UPDATE frete
            SET status = 'em_andamento'
            WHERE id = ?
        """;

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idFrete);
            stmt.executeUpdate();
        }
    }

    // ==========================================================
    // CONCLUIR FRETE (status → CONCLUIDO)
    // ==========================================================
    public void concluirFrete(int idFrete) throws Exception {
        String sql = """
            UPDATE frete
            SET status = 'concluido', data_conclusao = CURRENT_TIMESTAMP
            WHERE id = ?
        """;

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idFrete);
            stmt.executeUpdate();
        }
    }

    // ==========================================================
    // LISTAR ÚLTIMOS 3 FRETES ACEITOS PELO TRANSPORTADOR
    // ==========================================================
    public List<Frete> listarFretesTransportador(int idTransportador) throws Exception {
        String sql = """
            SELECT * FROM frete
            WHERE id_transportador = ?
            ORDER BY data_solicitacao DESC
            LIMIT 3
        """;

        List<Frete> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTransportador);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                lista.add(map(rs));
            }
        }

        return lista;
    }

    // ==========================================================
    // LISTAR FRETES EM ANDAMENTO DO TRANSPORTADOR
    // ==========================================================
    public List<Frete> listarFretesEmAndamento(int idTransportador) throws Exception {
        String sql = """
            SELECT * FROM frete
            WHERE id_transportador = ? AND status = 'em_andamento'
            ORDER BY data_solicitacao DESC
        """;

        List<Frete> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTransportador);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) lista.add(map(rs));
        }

        return lista;
    }

    // ==========================================================
    // LISTAR FRETES CONCLUÍDOS DO TRANSPORTADOR
    // ==========================================================
    public List<Frete> listarFretesConcluidos(int idTransportador) throws Exception {
        String sql = """
            SELECT * FROM frete
            WHERE id_transportador = ? AND status = 'concluido'
            ORDER BY data_conclusao DESC NULLS LAST
        """;

        List<Frete> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTransportador);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) lista.add(map(rs));
        }

        return lista;
    }

    // ==========================================================
    // LISTAR FRETES ACEITOS DO TRANSPORTADOR (não iniciados)
    // ==========================================================
    public List<Frete> listarFretesAceitos(int idTransportador) throws Exception {
        String sql = """
            SELECT * FROM frete
            WHERE id_transportador = ? AND status = 'aceito'
            ORDER BY data_solicitacao DESC
        """;

        List<Frete> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTransportador);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) lista.add(map(rs));
        }

        return lista;
    }

    // ==========================================================
    // BUSCAR FRETE POR ID
    // ==========================================================
    public Frete buscarPorId(int id) throws Exception {
        String sql = "SELECT * FROM frete WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return map(rs);
        }

        return null;
    }

    // ==========================================================
    // VERIFICAR SE EXISTEM FRETES PARA UM DDD
    // ==========================================================
    public boolean existeFreteComDDD(String ddd) throws Exception {
        String sql = """
            SELECT COUNT(*) as total 
            FROM frete 
            WHERE status = 'pendente' AND ddd_origem = ?
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

    // ==========================================================
    // LISTAR DDDS DISPONÍVEIS COM FRETES PENDENTES
    // ==========================================================
    public List<String> listarDDDsComFretes() throws Exception {
        String sql = """
            SELECT DISTINCT ddd_origem 
            FROM frete 
            WHERE status = 'pendente' 
            AND ddd_origem IS NOT NULL 
            AND ddd_origem != ''
            ORDER BY ddd_origem
        """;

        List<String> ddds = new ArrayList<>();
        
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ddds.add(rs.getString("ddd_origem"));
            }
        }
        return ddds;
    }
}