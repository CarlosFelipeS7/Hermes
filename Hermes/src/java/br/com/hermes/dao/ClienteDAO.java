/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.hermes.dao;

import br.com.hermes.model.Cliente;
import java.sql.Connection;
import java.sql.PreparedStatement;
/**
 *
 * @author ccfel
 */
public class ClienteDAO {
    
    public void inserir(Cliente cliente) throws Exception{
     String sql = "INSERT INTO cliente(nome, email, senha, endereco) VALUES (?,?,?,?)";
     
     try(Connection conn = Conexao.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)){
     
         stmt.setString(1, cliente.getNome());
         stmt.setString(2, cliente.getEmail());
         stmt.setString(3, cliente.getSenha());
         stmt.setString(4, cliente.getEndereco());
         
         stmt.executeUpdate();
     }
    }
    
}
