package com.example.backend.security;

import com.example.backend.service.ClientDetailsService;
import io.jsonwebtoken.ExpiredJwtException;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.*;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.*;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;

@Component
@RequiredArgsConstructor
public class JWTAuthorizationFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;
    private final ClientDetailsService clientDetailsService;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain chain) throws ServletException, IOException {

        final String authorizationHeader = request.getHeader("Authorization");

        String username = null;
        String jwt = null;

        // Vérifie si le header Authorization est présent et commence par "Bearer "
        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
            jwt = authorizationHeader.substring(7);
            try {
                // Extrait le nom d'utilisateur du token JWT
                username = jwtUtil.extractUsername(jwt);
            } catch (ExpiredJwtException e) {
                // Gestion du token expiré
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Token JWT expiré");
                return;
            } catch (Exception e) {
                // Gestion des autres exceptions liées au token
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Token JWT invalide");
                return;
            }
        }

        // Si le nom d'utilisateur est extrait et qu'il n'y a pas déjà d'authentification dans le contexte
        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            UserDetails userDetails = this.clientDetailsService.loadUserByUsername(username);

            if (userDetails != null) {
                // Crée un objet d'authentification et le place dans le contexte de sécurité
                UsernamePasswordAuthenticationToken authentication =
                        new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());

                SecurityContextHolder.getContext().setAuthentication(authentication);
            }
        }

        // Continue le filtre
        chain.doFilter(request, response);
    }
}
