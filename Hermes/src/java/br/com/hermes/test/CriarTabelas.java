package br.com.hermes.test;

import br.com.hermes.dao.Conexao;
import java.sql.Connection;
import java.sql.Statement;

public class CriarTabelas {
    public static void main(String[] args) {
        System.out.println("=== 🗃️ CRIANDO TABELAS DO BANCO HERMES ===\n");
        
        String[] sqls = {
            // Tabela Cliente
            "CREATE TABLE IF NOT EXISTS cliente (" +
            "id SERIAL PRIMARY KEY, " +
            "nome VARCHAR(100) NOT NULL, " +
            "email VARCHAR(100) UNIQUE NOT NULL, " +
            "senha VARCHAR(100) NOT NULL, " +
            "endereco TEXT, " +
            "data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP)",

            // Tabela Transportador
            "CREATE TABLE IF NOT EXISTS transportador (" +
            "id SERIAL PRIMARY KEY, " +
            "nome VARCHAR(100) NOT NULL, " +
            "email VARCHAR(100) UNIQUE NOT NULL, " +
            "senha VARCHAR(100) NOT NULL, " +
            "veiculo VARCHAR(50), " +
            "documento VARCHAR(20), " +
            "data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP)",

            // Tabela Frete
            "CREATE TABLE IF NOT EXISTS frete (" +
            "id SERIAL PRIMARY KEY, " +
            "origem VARCHAR(200) NOT NULL, " +
            "destino VARCHAR(200) NOT NULL, " +
            "descricao_carga TEXT, " +
            "peso DECIMAL(10,2), " +
            "valor DECIMAL(10,2), " +
            "status VARCHAR(20) DEFAULT 'PENDENTE', " +
            "data_solicitacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
            "data_conclusao TIMESTAMP NULL, " +
            "id_cliente INTEGER REFERENCES cliente(id), " +
            "id_transportador INTEGER REFERENCES transportador(id))",

            // Tabela Avaliacao
            "CREATE TABLE IF NOT EXISTS avaliacao (" +
            "id SERIAL PRIMARY KEY, " +
            "nota INTEGER NOT NULL CHECK (nota >= 1 AND nota <= 5), " +
            "comentario TEXT, " +
            "data_avaliacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
            "id_frete INTEGER REFERENCES frete(id), " +
            "id_avaliador INTEGER NOT NULL, " +
            "id_avaliado INTEGER NOT NULL, " +
            "tipo VARCHAR(30) NOT NULL)"
        };

        try (Connection conn = Conexao.getConnection();
             Statement stmt = conn.createStatement()) {
            
            for (int i = 0; i < sqls.length; i++) {
                stmt.executeUpdate(sqls[i]);
                System.out.println("✅ Tabela " + (i+1) + " criada com sucesso!");
            }
            
            System.out.println("\n🎉 TODAS AS TABELAS FORAM CRIADAS!");
            System.out.println("👉 Agora execute o TesteCliente.java novamente");
            
        } catch (Exception e) {
            System.out.println("❌ Erro ao criar tabelas: " + e.getMessage());
            e.printStackTrace();
        }
    }
}