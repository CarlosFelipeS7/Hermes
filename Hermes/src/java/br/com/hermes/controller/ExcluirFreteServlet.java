package br.com.hermes.controller;

import br.com.hermes.service.FreteService;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ExcluirFreteServlet", urlPatterns = {"/ExcluirFreteServlet"})
public class ExcluirFreteServlet extends HttpServlet {

    private final FreteService freteService = new FreteService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        
        // Validar sessão
        if (session == null || session.getAttribute("usuarioId") == null) {
            if (isAjaxRequest(request)) {
                sendJsonResponse(response, false, "Sessão expirada. Faça login novamente.");
                return;
            } else {
                response.sendRedirect(request.getContextPath() + "/auth/login/login.jsp");
                return;
            }
        }

        int idUsuario = (Integer) session.getAttribute("usuarioId");
        String tipoUsuario = (String) session.getAttribute("usuarioTipo");

        System.out.println("=== DEBUG ExcluirFreteServlet ===");
        System.out.println("ID Usuário: " + idUsuario);
        System.out.println("Tipo Usuário: " + tipoUsuario);
        
        try {
            // Obter ID do frete
            String idFreteStr = request.getParameter("idFrete");
            if (idFreteStr == null || idFreteStr.trim().isEmpty()) {
                throw new Exception("ID do frete não informado.");
            }

            int idFrete = Integer.parseInt(idFreteStr);
            System.out.println("🗑️ Tentando excluir frete ID: " + idFrete);

            // ✅ VERIFICAR SE O USUÁRIO PODE EXCLUIR O FRETE PRIMEIRO
            boolean podeExcluir = freteService.usuarioPodeExcluirFrete(idFrete, idUsuario, tipoUsuario);
            
            if (!podeExcluir) {
                System.err.println("❌ Usuário não tem permissão para excluir este frete");
                if (isAjaxRequest(request)) {
                    sendJsonResponse(response, false, "Você não tem permissão para excluir este frete.");
                } else {
                    session.setAttribute("mensagemErro", "Você não tem permissão para excluir este frete.");
                    response.sendRedirect(request.getContextPath() + getPaginaRedirecionamento(tipoUsuario));
                }
                return;
            }

            System.out.println("✅ Usuário tem permissão para excluir. Prosseguindo...");

            // ✅ TENTAR EXCLUIR O FRETE
            boolean exclusaoSucesso = freteService.excluirFrete(idFrete, idUsuario, tipoUsuario);

           // No doPost, após a exclusão bem-sucedida:
if (exclusaoSucesso) {
    System.out.println("✅ Frete excluído com sucesso! ID: " + idFrete);
    
    if (isAjaxRequest(request)) {
        sendJsonResponse(response, true, "Frete excluído com sucesso!", idFrete); // ← ID correto aqui
    } else {
        session.setAttribute("mensagemSucesso", "Frete excluído com sucesso!");
        response.sendRedirect(request.getContextPath() + getPaginaRedirecionamento(tipoUsuario));
    }
}

        } catch (NumberFormatException e) {
            System.err.println("❌ ID do frete inválido: " + e.getMessage());
            handleError(request, response, "ID do frete inválido.", isAjaxRequest(request));
            
        } catch (Exception e) {
            System.err.println("❌ Erro ao excluir frete: " + e.getMessage());
            e.printStackTrace();
            handleError(request, response, "Erro ao excluir frete: " + e.getMessage(), isAjaxRequest(request));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirecionar POST para evitar acesso direto via GET
        response.sendRedirect(request.getContextPath() + "/dashboard");
    }

    // ✅ VERIFICA SE É UMA REQUISIÇÃO AJAX
    private boolean isAjaxRequest(HttpServletRequest request) {
        return "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
    }

    // ✅ ENVIA RESPOSTA JSON PARA AJAX
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) throws IOException {
        sendJsonResponse(response, success, message, 0);
    }

  private void sendJsonResponse(HttpServletResponse response, boolean success, String message, int freteId) throws IOException {
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    PrintWriter out = response.getWriter();
    String json = String.format(
        "{\"success\": %b, \"message\": \"%s\", \"freteId\": %d}",
        success, message.replace("\"", "\\\""), freteId
    );
    System.out.println("✅ Enviando resposta JSON: " + json); // DEBUG
    out.print(json);
    out.flush();
}

    // ✅ MANIPULA ERROS (AJAX ou não)
    private void handleError(HttpServletRequest request, HttpServletResponse response, 
                           String errorMessage, boolean isAjax) 
            throws IOException, ServletException {
        
        if (isAjax) {
            sendJsonResponse(response, false, errorMessage);
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("mensagemErro", errorMessage);
            response.sendRedirect(request.getContextPath() + "/dashboardTransportador");
        }
    }

    private String getPaginaRedirecionamento(String tipoUsuario) {
        if ("transportador".equalsIgnoreCase(tipoUsuario)) {
            return "/dashboardTransportador";
        } else {
            return "/dashboardClientes";
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet para exclusão de fretes com suporte AJAX";
    }
}