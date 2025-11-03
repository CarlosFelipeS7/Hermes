package br.com.hermes.model;

import java.util.Date;

public class Avaliacao {
    private int id;
    private int nota;
    private String comentario;
    private Date dataAvaliacao;
    private int idFrete;
    private int idAvaliador; 
    private int idAvaliado;
    private String tipo; 
    
    
    public Avaliacao() {}
    
    public Avaliacao(int nota, String comentario, int idFrete, int idAvaliador, int idAvaliado, String tipo) {
        this.nota = nota;
        this.comentario = comentario;
        this.idFrete = idFrete;
        this.idAvaliador = idAvaliador;
        this.idAvaliado = idAvaliado;
        this.tipo = tipo;
        this.dataAvaliacao = new Date();
    }
    
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getNota() { return nota; }
    public void setNota(int nota) { this.nota = nota; }
    
    public String getComentario() { return comentario; }
    public void setComentario(String comentario) { this.comentario = comentario; }
    
    public Date getDataAvaliacao() { return dataAvaliacao; }
    public void setDataAvaliacao(Date dataAvaliacao) { this.dataAvaliacao = dataAvaliacao; }
    
    public int getIdFrete() { return idFrete; }
    public void setIdFrete(int idFrete) { this.idFrete = idFrete; }
    
    public int getIdAvaliador() { return idAvaliador; }
    public void setIdAvaliador(int idAvaliador) { this.idAvaliador = idAvaliador; }
    
    public int getIdAvaliado() { return idAvaliado; }
    public void setIdAvaliado(int idAvaliado) { this.idAvaliado = idAvaliado; }
    
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
}