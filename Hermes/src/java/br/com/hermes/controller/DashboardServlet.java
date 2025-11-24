    package br.com.hermes.controller;

    import br.com.hermes.dao.FreteDAO;
    import br.com.hermes.model.Frete;

    import javax.servlet.ServletException;
    import javax.servlet.annotation.WebServlet;
    import javax.servlet.http.*;
    import java.io.IOException;
    import java.util.List;

    @WebServlet(name = "DashboardServlet", urlPatterns = {"/DashboardServlet"})
    public class DashboardServlet extends HttpServlet {

        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            HttpSession session = request.getSession(false);
            if (session == null) {
                response.sendRedirect("auth/login/login.jsp");
                return;
            }

            Integer idUsuario = (Integer) session.getAttribute("usuarioId");
            String tipoUsuario = (String) session.getAttribute("usuarioTipo");

            if (idUsuario == null || tipoUsuario == null) {
                response.sendRedirect("auth/login/login.jsp");
                return;
            }

            try {
                FreteDAO dao = new FreteDAO();

                switch (tipoUsuario.toLowerCase()) {

                    case "cliente":
                        carregarDashboardCliente(idUsuario, dao, request, response);
                        break;

                    case "transportador":
                        carregarDashboardTransportador(dao, request, response);
                        break;

                    case "admin":
                        carregarDashboardAdmin(request, response);
                        break;

                    default:
                        response.sendRedirect("index.jsp");
                        break;
                }

            } catch (Exception e) {
                tratarErro(request, response, "Erro ao carregar dashboard: " + e.getMessage());
            }
        }

        // ==========================================================
        // DASHBOARD CLIENTE
        // ==========================================================
        private void carregarDashboardCliente(int idCliente, FreteDAO dao,
                                              HttpServletRequest request, HttpServletResponse response)
                throws Exception {

            List<Frete> fretes = dao.listarFretesCliente(idCliente, 5);
            request.setAttribute("fretesCliente", fretes);

            request.getRequestDispatcher("/dashboard/clientes/clientes.jsp")
                   .forward(request, response);
        }

        // ==========================================================
        // DASHBOARD TRANSPORTADOR
        // ==========================================================
        private void carregarDashboardTransportador(FreteDAO dao,
                                                    HttpServletRequest request, HttpServletResponse response)
                throws Exception {

            List<Frete> recentes = dao.listarPendentes(3);
            request.setAttribute("fretesRecentes", recentes);

            request.getRequestDispatcher("/dashboard/transportador/transportador.jsp")
                   .forward(request, response);
        }

        // ==========================================================
        // DASHBOARD ADMIN (A IMPLEMENTAR)
        // ==========================================================
        private void carregarDashboardAdmin(HttpServletRequest request, HttpServletResponse response)
                throws Exception {

            request.getRequestDispatcher("/dashboard/admin/admin.jsp")
                   .forward(request, response);
        }

        // ==========================================================
        // MÉTODO CENTRALIZADO DE ERRO
        // ==========================================================
        private void tratarErro(HttpServletRequest request, HttpServletResponse response, String msg)
                throws ServletException, IOException {

            request.setAttribute("mensagem", msg);
            request.setAttribute("tipoMensagem", "error");
            request.getRequestDispatcher("erro.jsp").forward(request, response);
        }
    }
