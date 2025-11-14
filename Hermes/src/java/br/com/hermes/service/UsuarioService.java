package br.com.hermes.service;

import br.com.hermes.dao.UsuarioDAO;
import br.com.hermes.model.Usuario;

public class UsuarioService {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    // ==========================================================
    // CRIAR USUÁRIO COM VALIDAÇÕES
    // ==========================================================
    public void cadastrar(Usuario u) throws Exception {

        if (u == null)
            throw new Exception("Usuário inválido.");

        if (isVazio(u.getNome()))
            throw new Exception("Nome é obrigatório.");

        if (isVazio(u.getEmail()))
            throw new Exception("E-mail é obrigatório.");

        if (isVazio(u.getSenha()))
            throw new Exception("Senha é obrigatória.");

        if (usuarioDAO.existeEmail(u.getEmail()))
            throw new Exception("E-mail já cadastrado.");

        if (isVazio(u.getTipoUsuario()))
            throw new Exception("Tipo de usuário inválido.");

        usuarioDAO.inserir(u);
    }


    // ==========================================================
    // VALIDAR LOGIN
    // ==========================================================
    public Usuario autenticar(String email, String senha) throws Exception {

        if (isVazio(email) || isVazio(senha))
            throw new Exception("Credenciais inválidas.");

        Usuario u = usuarioDAO.autenticar(email, senha);

        if (u == null)
            throw new Exception("E-mail ou senha incorretos.");

        return u;
    }

    private boolean isVazio(String valor) {
        return valor == null || valor.trim().isEmpty();
    }

}
