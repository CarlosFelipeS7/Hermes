/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.hermes.test;

import br.com.hermes.dao.Conexao;
import java.sql.Connection;
/**
 *
 * @author ccfel
 */
public class TesteConexao {
    public static void main(String[]args){
      try(Connection conn = Conexao.getConnection()){
        System.out.println("✅ Conexao bem-sucedida com o banco Hermes!");
    } catch (Exception e){
            System.out.println("❌ Erro na conexao:");
            e.printStackTrace();
}}
}
