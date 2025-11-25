package br.com.hermes.dao;

import br.com.hermes.model.Avaliacao;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AvaliacaoDAO {

 private Avaliacao map(ResultSet rs) throws SQLException {
    Avaliacao a = new Avaliacao();
    a.setId(rs.getInt("id"));
    a.setIdFrete(rs.getInt("id_frete"));
    a.setNota(rs.getInt("nota"));
    a.setComentario(rs.getString("comentario"));
    a.setDataAvaliacao(rs.getTimestamp("data_avaliacao"));
    
    // ✅ CORREÇÃO: Remover referências a colunas que não existem mais
    // a.setFoto(rs.getString("foto")); // Removido se a coluna não existir
    
    System.out.println("✅ Avaliação mapeada: ID=" + a.getId() + ", Frete=" + a.getIdFrete() + ", Nota=" + a.getNota());
    return a;
}

    // No AvaliacaoDAO.java, adicione este método:
public Avaliacao buscarPorFrete(int idFrete) {
    String sql = "SELECT * FROM avaliacao WHERE id_frete = ?";
    
    try (Connection conn = Conexao.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, idFrete);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            return map(rs);
        }
    } catch (SQLException e) {
        System.err.println("Erro ao buscar avaliação por frete " + idFrete + ": " + e.getMessage());
        e.printStackTrace();
    }
    return null;
}
    
    
public boolean inserir(Avaliacao a) {
    // ✅ CORREÇÃO: Query SIMPLES e compatível com o banco
    String sql = "INSERT INTO avaliacao (id_frete, nota, comentario, data_avaliacao) VALUES (?, ?, ?, NOW())";
    
    System.out.println("=== DEBUG AvaliacaoDAO.inserir ===");
    System.out.println("SQL: " + sql);
    System.out.println("ID Frete: " + a.getIdFrete());
    System.out.println("Nota: " + a.getNota());
    System.out.println("Comentário: " + a.getComentario());
    
    try (Connection conn = Conexao.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, a.getIdFrete());
        stmt.setInt(2, a.getNota());
        stmt.setString(3, a.getComentario());
        
        int rows = stmt.executeUpdate();
        
        System.out.println("✅ LINHAS AFETADAS: " + rows);
        System.out.println("✅ Avaliação inserida com sucesso para frete: " + a.getIdFrete());
        return rows > 0;
        
    } catch (SQLException e) {
        System.err.println("❌ Erro ao inserir avaliação: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

  public List<Avaliacao> listarPorTransportador(int idTransportador) {
    List<Avaliacao> lista = new ArrayList<>();
    String sql = "SELECT a.* FROM avaliacao a INNER JOIN frete f ON a.id_frete = f.id WHERE f.id_transportador = ? ORDER BY a.data_avaliacao DESC";

    System.out.println("=== DEBUG DETALHADO listarPorTransportador ===");
    System.out.println("SQL: " + sql);
    System.out.println("ID Transportador: " + idTransportador);

    try (Connection conn = Conexao.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, idTransportador);
        ResultSet rs = stmt.executeQuery();

        int count = 0;
        while (rs.next()) {
            Avaliacao avaliacao = map(rs);
            lista.add(avaliacao);
            count++;
            System.out.println("✅ Avaliação " + count + ":");
            System.out.println("   - ID: " + avaliacao.getId());
            System.out.println("   - Frete ID: " + avaliacao.getIdFrete());
            System.out.println("   - Nota: " + avaliacao.getNota());
            System.out.println("   - Comentário: " + avaliacao.getComentario());
            System.out.println("   - Data: " + avaliacao.getDataAvaliacao());
        }
        
        if (count == 0) {
            System.out.println("❌ NENHUMA avaliação encontrada para transportador: " + idTransportador);
            System.out.println("🔍 Vamos verificar os fretes deste transportador...");
            
            // Verificar se existem fretes para este transportador
            String sqlFretes = "SELECT id, id_cliente, id_transportador, status FROM frete WHERE id_transportador = ?";
            try (PreparedStatement stmtFretes = conn.prepareStatement(sqlFretes)) {
                stmtFretes.setInt(1, idTransportador);
                ResultSet rsFretes = stmtFretes.executeQuery();
                
                int fretesCount = 0;
                while (rsFretes.next()) {
                    fretesCount++;
                    System.out.println("   Frete " + fretesCount + ": ID=" + rsFretes.getInt("id") + 
                                     ", Cliente=" + rsFretes.getInt("id_cliente") + 
                                     ", Status=" + rsFretes.getString("status"));
                }
                System.out.println("📊 Total de fretes do transportador: " + fretesCount);
            }
            
            // Verificar se existem avaliações no banco (independente do transportador)
            String sqlTodasAvaliacoes = "SELECT a.*, f.id_transportador FROM avaliacao a INNER JOIN frete f ON a.id_frete = f.id LIMIT 5";
            try (PreparedStatement stmtTodas = conn.prepareStatement(sqlTodasAvaliacoes)) {
                ResultSet rsTodas = stmtTodas.executeQuery();
                
                int avaliacoesCount = 0;
                while (rsTodas.next()) {
                    avaliacoesCount++;
                    System.out.println("   Avaliação geral " + avaliacoesCount + ":");
                    System.out.println("     - ID: " + rsTodas.getInt("id"));
                    System.out.println("     - Frete ID: " + rsTodas.getInt("id_frete"));
                    System.out.println("     - Transportador: " + rsTodas.getInt("id_transportador"));
                    System.out.println("     - Nota: " + rsTodas.getInt("nota"));
                }
                System.out.println("📊 Total de avaliações no banco: " + avaliacoesCount);
            }
        } else {
            System.out.println("📊 Total de avaliações encontradas: " + count);
        }

    } catch (SQLException e) {
        System.err.println("❌ Erro ao listar avaliações do transportador " + idTransportador + ": " + e.getMessage());
        e.printStackTrace();
    }
    return lista;
}

    public List<Avaliacao> listarPorCliente(int idCliente) {
        List<Avaliacao> lista = new ArrayList<>();
        String sql = "SELECT a.* FROM avaliacao a INNER JOIN frete f ON a.id_frete = f.id WHERE f.id_cliente = ? ORDER BY a.data_avaliacao DESC";

        System.out.println("=== DEBUG listarPorCliente ===");
        System.out.println("SQL: " + sql);
        System.out.println("ID Cliente: " + idCliente);

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idCliente);
            ResultSet rs = stmt.executeQuery();

            int count = 0;
            while (rs.next()) {
                lista.add(map(rs));
                count++;
                System.out.println("Avaliação " + count + ": Frete ID " + rs.getInt("id_frete") + ", Nota: " + rs.getInt("nota"));
            }
            System.out.println("Total de avaliações encontradas: " + count);

        } catch (SQLException e) {
            System.err.println("Erro ao listar avaliações do cliente " + idCliente + ": " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    public double calcularMediaTransportador(int idTransportador) {
        String sql = "SELECT AVG(a.nota) AS media FROM avaliacao a INNER JOIN frete f ON f.id = a.id_frete WHERE f.id_transportador = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTransportador);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                double media = rs.getDouble("media");
                System.out.println("Média calculada para transportador " + idTransportador + ": " + media);
                return media;
            }
        } catch (SQLException e) {
            System.err.println("Erro ao calcular média do transportador " + idTransportador + ": " + e.getMessage());
            e.printStackTrace();
        }
        return 0.0;
    }
}