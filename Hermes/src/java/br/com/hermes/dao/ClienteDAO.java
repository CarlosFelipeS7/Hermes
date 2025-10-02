/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.hermes.dao;

import br.com.hermes.model.Cliente;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;
import java.sql.ResultSet;

/**
 *
 * @author ccfel
 */
public class ClienteDAO {
    
    //Create
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
    
    //Read(Listar)
    public List<Cliente> listarTodos() throws Exception {
        String sql = "SELECT * FROM cliente";
        List<Cliente> clientes = new ArrayList<>();
        
        try(Connection conn = Conexao.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery()){
            
            while(rs.next()){
                Cliente c = new Cliente();
                c.setId(rs.getInt("id"));
                c.setNome(rs.getString("nome"));
                c.setEmail(rs.getString("email"));
                c.setSenha(rs.getString("senha"));
                c.setEndereco(rs.getString("endereco"));
                
                 clientes.add(c);
                
            }
        }
        return clientes;
    }
    
    //READ(Buscar por id)
    public Cliente buscarPorId(int id) throws Exception{
        String sql = "SELECT * FROM cliente WHERE id = ?";
        Cliente cliente = null;
        
        try(Connection conn = Conexao.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)){
        
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if(rs.next()){
                cliente = new Cliente();
                cliente.setId(rs.getInt("id"));
                cliente.setNome(rs.getString("nome"));
                cliente.setEmail(rs.getString("email"));
                cliente.setSenha(rs.getString("senha"));
                cliente.setEndereco(rs.getString("endereco"));
            }
        }
        return cliente;
        }
    
    //UPDATE
    public void atualizar(Cliente cliente) throws Exception{
        String sql = "UPDATE cliente SET nome=?, email=?, senha=?, endereco=? WHERE id=?";
        try(Connection conn = Conexao.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)){
            
            stmt.setString(1, cliente.getNome());
            stmt.setString(2, cliente.getEmail());
            stmt.setString(3, cliente.getSenha());
            stmt.setString(4, cliente.getEndereco());
            stmt.setInt(5, cliente.getId());
            
            stmt.executeUpdate();
    }
}
    //DELETE
    public void deletar(int id) throws Exception{
        String sql = "DELETE FROM cliente WHERE id=?";
        try(Connection conn = Conexao.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)){
                
                    stmt.setInt(1, id);
                    stmt.executeUpdate();
                }
        }}