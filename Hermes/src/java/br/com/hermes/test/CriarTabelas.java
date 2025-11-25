package br.com.hermes.test;

import br.com.hermes.dao.Conexao;
import java.sql.Connection;
import java.sql.Statement;

public class CriarTabelas {

    public static void main(String[] args) {

        System.out.println("=== 🗃️ CRIANDO TABELAS DO BANCO HERMES ===\n");

        String[] sqls = {

            
            //TABELA notificacao 
            """
            CREATE TABLE notificacao (
                id SERIAL PRIMARY KEY,
                id_usuario INTEGER NOT NULL,
                titulo VARCHAR(200) NOT NULL,
                mensagem TEXT NOT NULL,
                tipo VARCHAR(50) NOT NULL, -- 'frete_aceito', 'frete_concluido', 'avaliacao_recebida'
                lida BOOLEAN DEFAULT FALSE,
                data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                id_frete INTEGER, -- opcional: link para o frete relacionado
                FOREIGN KEY (id_usuario) REFERENCES usuario(id)
            );
            """,
            
            
            
            
            // =========================================================
            // TABELA USUÁRIO (unificada)
            // =========================================================
            """
            CREATE TABLE IF NOT EXISTS usuario (
                id SERIAL PRIMARY KEY,
                nome VARCHAR(100) NOT NULL,
                email VARCHAR(100) UNIQUE NOT NULL,
                senha VARCHAR(200) NOT NULL,
                tipo_usuario VARCHAR(20) NOT NULL CHECK (tipo_usuario IN ('cliente','transportador','admin')),
                telefone VARCHAR(20),
                endereco TEXT,
                documento VARCHAR(20),
                veiculo VARCHAR(50),
                data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
            """,

            // =========================================================
            // TABELA FRETE
            // =========================================================
            """
            CREATE TABLE IF NOT EXISTS frete (
                id SERIAL PRIMARY KEY,
                origem VARCHAR(200) NOT NULL,
                destino VARCHAR(200) NOT NULL,
                descricao_carga TEXT,
                peso DECIMAL(10,2),
                valor DECIMAL(10,2),
                status VARCHAR(20) DEFAULT 'PENDENTE',
                data_solicitacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                data_conclusao TIMESTAMP NULL,
                id_cliente INTEGER REFERENCES usuario(id),
                id_transportador INTEGER REFERENCES usuario(id)
            );
            """,

            // =========================================================
            // TABELA AVALIAÇÃO
            // =========================================================
            """
            CREATE TABLE IF NOT EXISTS avaliacao (
                id SERIAL PRIMARY KEY,
                nota INTEGER NOT NULL CHECK (nota >= 1 AND nota <= 5),
                comentario TEXT,
                data_avaliacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                id_frete INTEGER REFERENCES frete(id),
                id_avaliador INTEGER REFERENCES usuario(id),
                id_avaliado INTEGER REFERENCES usuario(id),
                tipo VARCHAR(30) NOT NULL
            );
            """
        };

        try (Connection conn = Conexao.getConnection();
             Statement stmt = conn.createStatement()) {

            for (int i = 0; i < sqls.length; i++) {
                stmt.executeUpdate(sqls[i]);
                System.out.println("✅ Tabela criada com sucesso (" + (i + 1) + ")!");
            }

            System.out.println("\n🎉 TODAS AS TABELAS FORAM CRIADAS COM SUCESSO!");
            System.out.println("👉 Agora você já pode cadastrar usuário e fazer login.");

        } catch (Exception e) {
            System.out.println("❌ Erro ao criar tabelas: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
