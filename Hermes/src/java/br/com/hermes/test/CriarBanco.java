package br.com.hermes.test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class CriarBanco {
    public static void main(String[] args) {
        String url = "jdbc:postgresql://localhost:5432/postgres"; // Conecta no banco padrão
        String user = "postgres";
        String password = "1012";
        
        try (Connection conn = DriverManager.getConnection(url, user, password);
             Statement stmt = conn.createStatement()) {
            
            // Criar banco Hermes
            stmt.executeUpdate("CREATE DATABASE Hermes");
            System.out.println("✅ Banco 'Hermes' criado com sucesso!");
            
        } catch (Exception e) {
            System.out.println("❌ Erro ao criar banco: " + e.getMessage());
        }
    }
}