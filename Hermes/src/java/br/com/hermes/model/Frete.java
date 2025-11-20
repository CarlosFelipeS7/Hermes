package br.com.hermes.model;

import java.sql.Timestamp;

public class Frete {

    private int id;
    private String origem;
    private String destino;
    private String descricaoCarga;
    private double peso;
    private double valor;
    private String status; // pendente, aceito, concluido...
    private Timestamp dataSolicitacao;
    private Timestamp dataConclusao;
    private int idCliente;
    private Integer idTransportador;
    private String dddOrigem;
    private String dddDestino;

    // -------------------------------------------
    // Construtores
    // -------------------------------------------
    public Frete() {}

    public Frete(int id, String origem, String destino, double peso, double valor, String status) {
        this.id = id;
        this.origem = origem;
        this.destino = destino;
        this.peso = peso;
        this.valor = valor;
        this.status = status;
    }

    // -------------------------------------------
    // Getters & Setters
    // -------------------------------------------

    public String getDddDestino() { return dddDestino; }
public void setDddDestino(String dddDestino) { this.dddDestino = dddDestino; }
    
    public String getDddOrigem() { return dddOrigem; }
public void setDddOrigem(String dddOrigem) { this.dddOrigem = dddOrigem; }
    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getOrigem() {
        return origem;
    }

    public void setOrigem(String origem) {
        this.origem = origem;
    }

    public String getDestino() {
        return destino;
    }

    public void setDestino(String destino) {
        this.destino = destino;
    }

    public String getDescricaoCarga() {
        return descricaoCarga;
    }

    public void setDescricaoCarga(String descricaoCarga) {
        this.descricaoCarga = descricaoCarga;
    }

    public double getPeso() {
        return peso;
    }

    public void setPeso(double peso) {
        this.peso = peso;
    }

    public double getValor() {
        return valor;
    }

    public void setValor(double valor) {
        this.valor = valor;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getDataSolicitacao() {
        return dataSolicitacao;
    }

    public void setDataSolicitacao(Timestamp dataSolicitacao) {
        this.dataSolicitacao = dataSolicitacao;
    }

    public Timestamp getDataConclusao() {
        return dataConclusao;
    }

    public void setDataConclusao(Timestamp dataConclusao) {
        this.dataConclusao = dataConclusao;
    }

    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }

    public Integer getIdTransportador() {
        return idTransportador;
    }

    public void setIdTransportador(Integer idTransportador) {
        this.idTransportador = idTransportador;
    }
}
