package br.com.hermes.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class SessionFilter implements Filter {

    // Rotas públicas que NÃO exigem login
    private static final String[] ROTAS_PUBLICAS = {
            "/LoginServlet",
            "/UsuarioServlet",  // cadastro
            "/auth/login/login.jsp",
            "/auth/cadastro/cadastro.jsp",
            "/css/", "/js/", "/images/", "/uploads/"
    };

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String caminho = req.getRequestURI().substring(req.getContextPath().length());

        // ---------------------------------------------------
        // 1️⃣ LIBERAR ROTAS PÚBLICAS AUTOMATICAMENTE
        // ---------------------------------------------------
        if (rotaPublica(caminho)) {
            chain.doFilter(request, response);
            return;
        }

        // ---------------------------------------------------
        // 2️⃣ VALIDAR SESSÃO
        // ---------------------------------------------------
        HttpSession session = req.getSession(false);

        boolean logado = (session != null &&
                session.getAttribute("usuarioId") != null &&
                session.getAttribute("usuarioTipo") != null);

        if (!logado) {
            // Usuário não logado => VOLTAR PARA LOGIN
            resp.sendRedirect(req.getContextPath() + "/auth/login/login.jsp");
            return;
        }

        // ---------------------------------------------------
        // 3️⃣ PERMITIR CONTINUAÇÃO
        // ---------------------------------------------------
        chain.doFilter(request, response);
    }

    // ---------------------------------------------------
    // MÉTODO: verificar se rota é pública
    // ---------------------------------------------------
  private boolean rotaPublica(String caminho) {
    caminho = caminho.toLowerCase();

    // arquivos estáticos
    if (caminho.endsWith(".css") || caminho.endsWith(".js") ||
        caminho.endsWith(".png") || caminho.endsWith(".jpg") ||
        caminho.endsWith(".jpeg") || caminho.endsWith(".gif") ||
        caminho.endsWith(".svg") || caminho.endsWith(".ico") ||
        caminho.endsWith(".webp")) {
        return true;
    }

    // pastas públicas
    String[] rotas = {
        "/loginservlet",
        "/usuarioservlet",
        "/auth/login/",
        "/auth/cadastro/",
        "/index.jsp",
        "/",
        "/uploads/"
    };

    for (String r : rotas) {
        if (caminho.startsWith(r)) {
            return true;
        }
    }

    return false;
}}

