/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.hermes.model;

/**
 *
 * @author ccfel
 */
public class Transportador {
    
    private int id;
    private String nome;
    private String cpf;
    private String email;
    private String senha;
    private String tipoVeiculo;
    
    public Transportador(){
    }
    
    public Transportador(int id, String nome, String email, String senha, String tipoVeiculo){
        this.id = id;
        this.nome=nome;
              this.email=email;
        this.senha=senha;
        this.tipoVeiculo = tipoVeiculo;
        
    }
    
    public int getId(){
        return id;
    }
    public void setId(int id){
        this.id=id;
    }
     public String getNome(){
        return nome;
    }
       public void setNome(String nome){
        this.nome=nome;
    }
    
     public String getCpf(){
        return cpf;
    }
     
     public void setCpf(String cpf){
        this.cpf=cpf;
    }
     
     public String getEmail(){
         return email;
     }
 
     public void setEmail(String email){
        this.email=email;
    }
   
       public String getSenha(){
         return senha;
     }
 
     public void setSenha(String senha){
        this.senha=senha;
    }
     
       public String getTipoVeiculo(){
         return tipoVeiculo;
     }
 
     public void setTipoVeiculo(String tipoVeiculo){
        this.tipoVeiculo=tipoVeiculo;
    }
     
}

