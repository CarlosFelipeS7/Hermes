package br.com.hermes.model;

import java.util.Date;

public class Frete {
    private int id;
    private String origem;
    private String destino;
    private String descricaoCarga;
    private double peso;
    private double valor;
    private String status; 
    private Date dataSolicitacao;
    private Date dataConclusao;
    private int idCliente;
    private int idTransportador;
    
    public Frete() {}
    
    public Frete(String origem, String destino, String descricaoCarga, 
                 double peso, double valor, int idCliente) {
        this.origem = origem;
        this.destino = destino;
        this.descricaoCarga = descricaoCarga;
        this.peso = peso;
        this.valor = valor;
        this.status = "PENDENTE"; 
        this.idCliente = idCliente;
        this.dataSolicitacao = new Date(); 
       
    }

    public Frete(int id, String origem, String destino, String descricaoCarga, 
                 double peso, double valor, String status, Date dataSolicitacao,
                 Date dataConclusao, int idCliente, int idTransportador) {
        this.id = id;
        this.origem = origem;
        this.destino = destino;
        this.descricaoCarga = descricaoCarga;
        this.peso = peso;
        this.valor = valor;
        this.status = status;
        this.dataSolicitacao = dataSolicitacao;
        this.dataConclusao = dataConclusao; 
        this.idCliente = idCliente;
        this.idTransportador = idTransportador;
    }
    
  
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getOrigem() { return origem; }
    public void setOrigem(String origem) { this.origem = origem; }
    
    public String getDestino() { return destino; }
    public void setDestino(String destino) { this.destino = destino; }
    
    public String getDescricaoCarga() { return descricaoCarga; }
    public void setDescricaoCarga(String descricaoCarga) { this.descricaoCarga = descricaoCarga; }
    
    public double getPeso() { return peso; }
    public void setPeso(double peso) { this.peso = peso; }
    
    public double getValor() { return valor; }
    public void setValor(double valor) { this.valor = valor; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Date getDataSolicitacao() { return dataSolicitacao; }
    public void setDataSolicitacao(Date dataSolicitacao) { this.dataSolicitacao = dataSolicitacao; }
    
    public Date getDataConclusao() { return dataConclusao; }
    public void setDataConclusao(Date dataConclusao) { this.dataConclusao = dataConclusao; }
    
    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }
    
    public int getIdTransportador() { return idTransportador; }
    public void setIdTransportador(int idTransportador) { this.idTransportador = idTransportador; }
}