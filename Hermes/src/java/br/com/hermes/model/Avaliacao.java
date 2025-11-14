package br.com.hermes.model;

import java.sql.Timestamp;

public class Avaliacao {

    private int id;
    private int idFrete;
    private int nota; // 1 a 5
    private String comentario;
    private String foto;
    private Timestamp dataAvaliacao;

    // ----------------------------------------------------------
    // CONSTRUTORES
    // ----------------------------------------------------------
    public Avaliacao() {}

    public Avaliacao(int idFrete, int nota, String comentario, String foto) {
        this.idFrete = idFrete;
        this.nota = nota;
        this.comentario = comentario;
        this.foto = foto;
    }

    public Avaliacao(int id, int idFrete, int nota, String comentario,
                     String foto, Timestamp dataAvaliacao) {
        this.id = id;
        this.idFrete = idFrete;
        this.nota = nota;
        this.comentario = comentario;
        this.foto = foto;
        this.dataAvaliacao = dataAvaliacao;
    }

    // ----------------------------------------------------------
    // GETTERS & SETTERS
    // ----------------------------------------------------------

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdFrete() {
        return idFrete;
    }

    public void setIdFrete(int idFrete) {
        this.idFrete = idFrete;
    }

    public int getNota() {
        return nota;
    }

    public void setNota(int nota) {
        this.nota = nota;
    }

    public String getComentario() {
        return comentario;
    }

    public void setComentario(String comentario) {
        this.comentario = comentario;
    }

    public String getFoto() {
        return foto;
    }

    public void setFoto(String foto) {
        this.foto = foto;
    }

    public Timestamp getDataAvaliacao() {
        return dataAvaliacao;
    }

    public void setDataAvaliacao(Timestamp dataAvaliacao) {
        this.dataAvaliacao = dataAvaliacao;
    }
}
