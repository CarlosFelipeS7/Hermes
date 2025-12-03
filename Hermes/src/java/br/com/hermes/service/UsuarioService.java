package br.com.hermes.service;

import br.com.hermes.dao.UsuarioDAO;
import br.com.hermes.model.Usuario;
import java.util.List;

public class UsuarioService {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

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

        if (isVazio(u.getTelefone()))
            throw new Exception("Telefone é obrigatório.");

        if (isVazio(u.getEndereco()))
            throw new Exception("Endereço é obrigatório.");

        if (isVazio(u.getEstado()))
            throw new Exception("Estado é obrigatório.");

        if (isVazio(u.getCidade()))
            throw new Exception("Cidade é obrigatória.");

        // Regras específicas para transportador
        if ("transportador".equalsIgnoreCase(u.getTipoUsuario())) {
            if (isVazio(u.getDocumento())) {
                throw new Exception("Documento é obrigatório para transportador.");
            }
            // Veículo agora é opcional - será cadastrado no CRUD de veículos
        }


        // Extrair DDD do telefone automaticamente
        String ddd = extrairDDD(u.getTelefone());
        u.setDdd(ddd);

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

    // ==========================================================
    // BUSCAR TRANSPORTADORES POR DDD
    // ==========================================================
    public List<Usuario> buscarTransportadoresPorDDD(String ddd) throws Exception {
        if (isVazio(ddd)) {
            throw new Exception("DDD não pode ser vazio.");
        }

        if (ddd.length() != 2) {
            throw new Exception("DDD inválido. Deve conter exatamente 2 dígitos.");
        }

        if (!ddd.matches("\\d{2}")) {
            throw new Exception("DDD deve conter apenas números.");
        }

        return usuarioDAO.listarTransportadoresPorDDD(ddd);
    }

    // ==========================================================
    // LISTAR TODOS OS TRANSPORTADORES
    // ==========================================================
    public List<Usuario> listarTodosTransportadores() throws Exception {
        return usuarioDAO.listarTodosTransportadores();
    }

    // ==========================================================
    // LISTAR DDDS DISPONÍVEIS
    // ==========================================================
    public List<String> listarDDDsDisponiveis() throws Exception {
        return usuarioDAO.listarDDDsDisponiveis();
    }

    // ==========================================================
    // BUSCAR USUÁRIO POR ID
    // ==========================================================
    public Usuario buscarPorId(int id) throws Exception {
        if (id <= 0) {
            throw new Exception("ID do usuário inválido.");
        }

        Usuario usuario = usuarioDAO.buscarPorId(id);
        
        if (usuario == null) {
            throw new Exception("Usuário não encontrado.");
        }

        return usuario;
    }

    // ==========================================================
    // ATUALIZAR USUÁRIO
    // ==========================================================
    public void atualizar(Usuario u) throws Exception {
        if (u == null) {
            throw new Exception("Usuário inválido.");
        }

        if (u.getId() <= 0) {
            throw new Exception("ID do usuário inválido.");
        }

        if (isVazio(u.getNome())) {
            throw new Exception("Nome é obrigatório.");
        }

        if (isVazio(u.getEmail())) {
            throw new Exception("E-mail é obrigatório.");
        }

        if (isVazio(u.getTipoUsuario())) {
            throw new Exception("Tipo de usuário inválido.");
        }

        // Atualizar DDD baseado no telefone
        String ddd = extrairDDD(u.getTelefone());
        u.setDdd(ddd);

        usuarioDAO.atualizar(u);
    }

    // ==========================================================
    // ATUALIZAR SENHA
    // ==========================================================
    public void atualizarSenha(int id, String novaSenha) throws Exception {
        if (id <= 0) {
            throw new Exception("ID do usuário inválido.");
        }

        if (isVazio(novaSenha)) {
            throw new Exception("Nova senha não pode ser vazia.");
        }

        if (novaSenha.length() < 6) {
            throw new Exception("A senha deve ter pelo menos 6 caracteres.");
        }

        usuarioDAO.atualizarSenha(id, novaSenha);
    }

    // ==========================================================
    // EXCLUIR USUÁRIO
    // ==========================================================
   public void excluir(int id) throws Exception {
    if (id <= 0) {
        throw new Exception("ID do usuário inválido.");
    }

    Usuario usuario = usuarioDAO.buscarPorId(id);
    if (usuario == null) {
        throw new Exception("Usuário não encontrado.");
    }

    // Exclusão lógica (recomendado)
    // ✅ EXCLUSÃO DEFINITIVA
    usuarioDAO.deletar(id);
    System.out.println("✅ Conta do usuário ID " + id + " EXCLUÍDA definitivamente.");

}

    // ==========================================================
    // LISTAR TODOS OS USUÁRIOS
    // ==========================================================
    public List<Usuario> listarTodos() throws Exception {
        return usuarioDAO.listarTodos();
    }

    // ==========================================================
    // MÉTODO PARA EXTRAIR DDD DO TELEFONE
    // ==========================================================
    private String extrairDDD(String telefone) {
        if (isVazio(telefone)) {
            return "00";
        }

        // Remove caracteres não numéricos
        String numeros = telefone.replaceAll("\\D", "");

        // Extrai DDD baseado em diferentes formatos
        if (numeros.length() >= 11) {
            // Formato: 11 99999-9999 ou (11) 99999-9999
            return numeros.substring(0, 2);
        } else if (numeros.length() >= 10) {
            // Formato: 11 9999-9999 ou (11) 9999-9999
            return numeros.substring(0, 2);
        } else if (numeros.length() >= 2) {
            // Apenas os primeiros 2 dígitos
            return numeros.substring(0, 2);
        }

        return "00";
    }

    // ==========================================================
    // VERIFICAR SE EXISTE TRANSPORTADOR COM DDD
    // ==========================================================
    public boolean existeTransportadorComDDD(String ddd) throws Exception {
        if (isVazio(ddd) || ddd.length() != 2) {
            return false;
        }

        return usuarioDAO.existeTransportadorComDDD(ddd);
    }

    // ==========================================================
    // MÉTODO AUXILIAR PARA VALIDAÇÃO
    // ==========================================================
    private boolean isVazio(String valor) {
        return valor == null || valor.trim().isEmpty();
    }
}