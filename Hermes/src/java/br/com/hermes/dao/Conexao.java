package br.com.hermes.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexao {

    // ✅ Dados reais da sua conexão PostgreSQL
    private static final String URL = "jdbc:postgresql://localhost:5432/hermesdb";
    private static final String USER = "postgres";
    private static final String PASSWORD = "1403";

    public static Connection getConnection() throws SQLException {
        try {
            // Carregar o driver JDBC do PostgreSQL
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("❌ Driver do PostgreSQL não encontrado!", e);
        }
    }
}