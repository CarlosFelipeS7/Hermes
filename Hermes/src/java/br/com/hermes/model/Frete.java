package br.com.hermes.model;

import java.sql.Timestamp;

public class Frete {
    private int id;
    private String origem;
    private String destino;
    private String descricaoCarga;
    private double peso;
    private double valor;
    private String status;
    private Timestamp dataSolicitacao;
    private Timestamp dataConclusao;
    private int idCliente;
    private Integer idTransportador;

    // Getters e Setters
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

    public Timestamp getDataSolicitacao() { return dataSolicitacao; }
    public void setDataSolicitacao(Timestamp dataSolicitacao) { this.dataSolicitacao = dataSolicitacao; }

    public Timestamp getDataConclusao() { return dataConclusao; }
    public void setDataConclusao(Timestamp dataConclusao) { this.dataConclusao = dataConclusao; }

    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }

    public Integer getIdTransportador() { return idTransportador; }
    public void setIdTransportador(Integer idTransportador) { this.idTransportador = idTransportador; }
}
