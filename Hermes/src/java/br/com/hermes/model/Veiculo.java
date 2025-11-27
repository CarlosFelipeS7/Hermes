package br.com.hermes.model;

import java.time.LocalDateTime;

public class Veiculo {
    private Integer id;
    private Integer idUsuario;
    private String tipoVeiculo;
    private String marca;
    private String modelo;
    private Integer ano;
    private String placa;
    private Double capacidade;
    private String cor;
    private Boolean ativo;
    private LocalDateTime dataCadastro;

    // Construtores
    public Veiculo() {}

    public Veiculo(Integer idUsuario, String tipoVeiculo, String marca, String modelo, 
                  Integer ano, String placa, Double capacidade, String cor) {
        this.idUsuario = idUsuario;
        this.tipoVeiculo = tipoVeiculo;
        this.marca = marca;
        this.modelo = modelo;
        this.ano = ano;
        this.placa = placa;
        this.capacidade = capacidade;
        this.cor = cor;
        this.ativo = true;
    }

    // Getters e Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Integer idUsuario) { this.idUsuario = idUsuario; }

    public String getTipoVeiculo() { return tipoVeiculo; }
    public void setTipoVeiculo(String tipoVeiculo) { this.tipoVeiculo = tipoVeiculo; }

    public String getMarca() { return marca; }
    public void setMarca(String marca) { this.marca = marca; }

    public String getModelo() { return modelo; }
    public void setModelo(String modelo) { this.modelo = modelo; }

    public Integer getAno() { return ano; }
    public void setAno(Integer ano) { this.ano = ano; }

    public String getPlaca() { return placa; }
    public void setPlaca(String placa) { this.placa = placa; }

    public Double getCapacidade() { return capacidade; }
    public void setCapacidade(Double capacidade) { this.capacidade = capacidade; }

    public String getCor() { return cor; }
    public void setCor(String cor) { this.cor = cor; }

    public Boolean getAtivo() { return ativo; }
    public void setAtivo(Boolean ativo) { this.ativo = ativo; }

    public LocalDateTime getDataCadastro() { return dataCadastro; }
    public void setDataCadastro(LocalDateTime dataCadastro) { this.dataCadastro = dataCadastro; }
}