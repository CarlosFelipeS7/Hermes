/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.hermes.test;

import br.com.hermes.dao.ClienteDAO;
import br.com.hermes.model.Cliente;
/**
 *
 * @author ccfel
 */
public class TesteCliente {
    public static void main(String[]args){
    try{
        Cliente cliente = new Cliente();
        cliente.setNome("Carlos Felipe");
        cliente.setEmail("carlos@gmail.com");
        cliente.setSenha("1234");
        cliente.setEndereco("Rua das Flores, 123");
        
        ClienteDAO dao = new ClienteDAO();
        dao.inserir(cliente);
        
        System.out.println("✅ Cliente cadastrado com sucesso!");
    } catch (Exception e){
        System.out.println("❌ Erro ao cadastrar cliente");
        e.printStackTrace();
    }
    }
}
