package br.com.hermes.test;

import br.com.hermes.dao.ClienteDAO;
import br.com.hermes.dao.TransportadorDAO;
import br.com.hermes.model.Cliente;
import br.com.hermes.model.Transportador;
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
            // dao.deletar(2);
            // System.out.println("️ Cliente deletado!");

            // 6. 🆕 TESTE DE LOGIN - Criar transportador também
            System.out.println("\n=== 🧪 CONFIGURANDO TESTE DE LOGIN ===");
            
            TransportadorDAO transportadorDAO = new TransportadorDAO();
            Transportador transportadorTeste = new Transportador();
            transportadorTeste.setNome("Maria Santos");
            transportadorTeste.setEmail("maria@email.com");
            transportadorTeste.setSenha("4321");
            transportadorTeste.setTipoVeiculo("Fiorino");
            transportadorTeste.setCpf("123.456.789-00");
            
            boolean transportadorInserido = transportadorDAO.inserir(transportadorTeste);
            System.out.println("Transportador de teste criado: " + (transportadorInserido ? "✅ SUCESSO" : "❌ FALHA"));
            
            // 7. 🆕 VERIFICAR CREDENCIAIS PARA LOGIN
            System.out.println("\n=== 🔐 CREDENCIAIS PARA TESTE NO NAVEGADOR ===");
            System.out.println("CLIENTE:");
            System.out.println("  Email: joao@email.com");
            System.out.println("  Senha: 4321");
            System.out.println("  Tipo: Cliente");
            System.out.println("\nTRANSPORTADOR:");
            System.out.println("  Email: maria@email.com"); 
            System.out.println("  Senha: 4321");
            System.out.println("  Tipo: Transportador");
            
            // 8. 🆕 VERIFICAR SE USUÁRIOS ESTÃO NO BANCO
            System.out.println("\n=== 📊 VERIFICAÇÃO NO BANCO ===");
            
            List<Cliente> todosClientes = dao.listarTodos();
            System.out.println("Clientes no banco: " + todosClientes.size());
            for (Cliente c : todosClientes) {
                System.out.println("  - " + c.getEmail() + " | Senha: " + c.getSenha());
            }
            
            List<Transportador> todosTransportadores = transportadorDAO.listarTodos();
            System.out.println("Transportadores no banco: " + todosTransportadores.size());
            for (Transportador t : todosTransportadores) {
                System.out.println("  - " + t.getEmail() + " | Senha: " + t.getSenha());
            }

        } catch (Exception e) {
            System.out.println("❌ Erro: " + e.getMessage());
            e.printStackTrace();
        }
    }
}