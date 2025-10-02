package br.com.hermes.test;

import br.com.hermes.dao.ClienteDAO;
import br.com.hermes.model.Cliente;
import java.util.List;

public class TesteCliente {
    public static void main(String[] args) {
        try {
            ClienteDAO dao = new ClienteDAO();

            // 1. Inserir novo cliente
            Cliente novo = new Cliente();
            novo.setNome("Joao Silva");
            novo.setEmail("joao@email.com");
            novo.setSenha("4321");
            novo.setEndereco("Rua Nova, 456");
            dao.inserir(novo);
            System.out.println("Cliente inserido!");

            // 2. Listar todos
            List<Cliente> clientes = dao.listarTodos();
            System.out.println(" Lista de clientes:");
            for (Cliente c : clientes) {
                System.out.println(c.getId() + " - " + c.getNome() + " - " + c.getEmail());
            }

            // 3. Buscar por ID
            Cliente cliente = dao.buscarPorId(1);
            if (cliente != null) {
                System.out.println(" Encontrado: " + cliente.getNome());
            }

            // 4. Atualizar cliente
            if (cliente != null) {
                cliente.setNome("Joao da Silva Atualizado");
                dao.atualizar(cliente);
                System.out.println(" Cliente atualizado!");
            }

            // 5. Deletar cliente (exemplo: id = 2)
            dao.deletar(2);
            System.out.println("️ Cliente deletado!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
