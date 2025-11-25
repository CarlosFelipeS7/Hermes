package br.com.hermes.model;

import java.sql.Timestamp;

public class Notificacao {
    private int id;
    private int idUsuario;
    private String titulo;
    private String mensagem;
    private String tipo;
    private boolean lida;
    private Timestamp dataCriacao;
    private int idFrete;

    // Construtores
    public Notificacao() {}
    
    public Notificacao(int idUsuario, String titulo, String mensagem, String tipo, int idFrete) {
        this.idUsuario = idUsuario;
        this.titulo = titulo;
        this.mensagem = mensagem;
        this.tipo = tipo;
        this.idFrete = idFrete;
    }

    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getMensagem() { return mensagem; }
    public void setMensagem(String mensagem) { this.mensagem = mensagem; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public boolean isLida() { return lida; }
    public void setLida(boolean lida) { this.lida = lida; }

    public Timestamp getDataCriacao() { return dataCriacao; }
    public void setDataCriacao(Timestamp dataCriacao) { this.dataCriacao = dataCriacao; }

    public int getIdFrete() { return idFrete; }
    public void setIdFrete(int idFrete) { this.idFrete = idFrete; }
}