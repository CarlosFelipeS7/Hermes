/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.hermes.dao;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author ccfel
 */
public class Conexao {
    
    //Dados do banco
    private static final String URL = "jdbc:postgresql://localhost:5432/Hermes";
    private static final String USER = "postgres";
    private static final String PASSWORD = "1012";
    
    public static Connection getConnection() throws SQLException{
        try{
            //Carregar o driver do postgres
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);  
        } catch (ClassNotFoundException e){
            throw new SQLException("Driver do PostgreSQL nao encontrado!",e);
        }
    }
    
}
