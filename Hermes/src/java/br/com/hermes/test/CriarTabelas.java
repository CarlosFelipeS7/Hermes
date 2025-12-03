package br.com.hermes.test;

import br.com.hermes.dao.Conexao;
import java.sql.Connection;
import java.sql.Statement;

public class CriarTabelas {

    public static void main(String[] args) {

        System.out.println("=== 🗃️ CRIANDO TABELAS DO BANCO HERMES ===\n");

        String[] sqls = {

            // =========================================================
            // TABELA USUÁRIO
            // =========================================================
            """
            CREATE TABLE IF NOT EXISTS usuario (
                id SERIAL PRIMARY KEY,
                nome VARCHAR(100) NOT NULL,
                email VARCHAR(100) NOT NULL UNIQUE,
                senha VARCHAR(100) NOT NULL,
                tipo_usuario VARCHAR(30) NOT NULL,
                telefone VARCHAR(20),
                endereco TEXT,
                estado VARCHAR(50),            
                cidade VARCHAR(50),           
                veiculo VARCHAR(100),
                documento VARCHAR(30),
                data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                ddd VARCHAR(5)
            );
            """,

            // =========================================================
            // TABELA CLIENTE
            // =========================================================
            """
            CREATE TABLE IF NOT EXISTS cliente (
                id SERIAL PRIMARY KEY,
                nome VARCHAR(100) NOT NULL,
                email VARCHAR(100) NOT NULL UNIQUE,
                senha VARCHAR(100) NOT NULL,
                endereco TEXT,
                data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                telefone VARCHAR(20),
                foto_perfil VARCHAR(255),
                data_nascimento DATE
            );
            """,

            // =========================================================
            // TABELA TRANSPORTADOR
            // =========================================================
            """
            CREATE TABLE IF NOT EXISTS transportador (
                id SERIAL PRIMARY KEY,
                nome VARCHAR(100) NOT NULL,
                email VARCHAR(100) NOT NULL UNIQUE,
                senha VARCHAR(100) NOT NULL,
                veiculo VARCHAR(50),
                documento VARCHAR(20),
                data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                telefone VARCHAR(20),
                foto_perfil VARCHAR(255),
                data_nascimento DATE,
                avaliacao_media NUMERIC(3,2) DEFAULT 0
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
                peso NUMERIC(10,2),
                valor NUMERIC(10,2),
                status VARCHAR(20) DEFAULT 'PENDENTE',
                data_solicitacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                data_conclusao TIMESTAMP,
                id_cliente INTEGER REFERENCES usuario(id),
                id_transportador INTEGER REFERENCES usuario(id),
                origem_ddd VARCHAR(5),
                ddd_origem VARCHAR(2),
                ddd_destino VARCHAR(3)
            );
            """,

            // =========================================================
            // TABELA NOTIFICAÇÃO
            // =========================================================
            """
            CREATE TABLE IF NOT EXISTS notificacao (
                id SERIAL PRIMARY KEY,
                id_usuario INTEGER NOT NULL REFERENCES usuario(id),
                titulo VARCHAR(200) NOT NULL,
                mensagem TEXT NOT NULL,
                tipo VARCHAR(50) NOT NULL,
                lida BOOLEAN DEFAULT FALSE,
                data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                id_frete INTEGER REFERENCES frete(id)
            );
            """,

            // =========================================================
            // TABELA AVALIAÇÃO
            // =========================================================
            """
            CREATE TABLE IF NOT EXISTS avaliacao (
                id SERIAL PRIMARY KEY,
                id_frete INTEGER REFERENCES frete(id),
                nota INTEGER NOT NULL,
                comentario TEXT,
                data_avaliacao TIMESTAMP DEFAULT NOW()
            );
            """,
            // =========================================================
            // TABELA VEÍCULO
            // =========================================================
            """
            CREATE TABLE IF NOT EXISTS veiculo (
                id SERIAL PRIMARY KEY,
                id_usuario INTEGER NOT NULL REFERENCES usuario(id),
                tipo_veiculo VARCHAR(50) NOT NULL,
                marca VARCHAR(50) NOT NULL,
                modelo VARCHAR(50) NOT NULL,
                ano INTEGER NOT NULL,
                placa VARCHAR(10) UNIQUE NOT NULL,
                capacidade NUMERIC(10,2) NOT NULL,
                cor VARCHAR(30),
                ativo BOOLEAN DEFAULT TRUE,
                data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
            """,

            // =========================================================
            // TABELA AVALIAÇÃO BACKUP
            // =========================================================
            """
            CREATE TABLE IF NOT EXISTS avaliacao_backup (
                id SERIAL PRIMARY KEY,
                nota INTEGER NOT NULL CHECK (nota BETWEEN 1 AND 5),
                comentario TEXT,
                data_avaliacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                id_frete INTEGER REFERENCES frete(id),
                id_avaliador INTEGER REFERENCES usuario(id),
                id_avaliado INTEGER REFERENCES usuario(id),
                tipo VARCHAR(30),
                foto VARCHAR(255)
            );
            
            
            -- 1. Adicionar a coluna ativo à tabela usuario
            ALTER TABLE usuario ADD COLUMN IF NOT EXISTS ativo BOOLEAN DEFAULT true;
            
            -- 2. Atualizar todos os usuários existentes para ativo = true
            UPDATE usuario SET ativo = true WHERE ativo IS NULL;
            
            -- 3. Adicionar constraint NOT NULL após atualizar
            ALTER TABLE usuario ALTER COLUMN ativo SET NOT NULL;
            """
                
                
        };

        try (Connection conn = Conexao.getConnection();
             Statement stmt = conn.createStatement()) {

            for (int i = 0; i < sqls.length; i++) {
                stmt.executeUpdate(sqls[i]);
                System.out.println("✅ Tabela criada: " + (i + 1));
            }

            System.out.println("\n🎉 TODAS AS TABELAS FORAM CRIADAS COM SUCESSO!");

        } catch (Exception e) {
            System.out.println("❌ Erro: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
