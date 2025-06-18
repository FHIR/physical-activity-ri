package ca.uhn.fhir.jpa.starter;


import ca.uhn.fhir.jpa.starter.constants.AppConstants;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtDecoders;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;
import org.springframework.security.web.authentication.logout.SimpleUrlLogoutSuccessHandler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Configuration
@EnableWebSecurity
class SecurityConfig {


	@Value("${spring.security.oauth2.client.provider.keycloak.server-uri}")
	private String keycloakServerUri;
	@Value("${spring.security.oauth2.client.provider.keycloak.base-uri}")
	private String keycloakServerBaseUri;

	@Value("${spring.security.oauth2.client.provider.keycloak.realm}")
	private String realm;

	private final KeycloakLogoutHandler keycloakLogoutHandler;

	SecurityConfig(KeycloakLogoutHandler keycloakLogoutHandler) {
		this.keycloakLogoutHandler = keycloakLogoutHandler;
	}

//	@Bean
//	protected SessionAuthenticationStrategy sessionAuthenticationStrategy() {
//		return new RegisterSessionAuthenticationStrategy(new SessionRegistryImpl());
//	}


	@Bean
	public JwtDecoder jwtDecoder() {
		return JwtDecoders.fromIssuerLocation(keycloakServerBaseUri + realm);
	}

	@Bean
	public SecurityFilterChain resourceServerFilterChain(HttpSecurity http) throws Exception {
		http.authorizeHttpRequests(auth -> auth
			.antMatchers(AppConstants.META_DATA_URI)
			.permitAll()
			.antMatchers("/logout")
			.permitAll()
			.anyRequest()
			.authenticated()
		).csrf().ignoringAntMatchers("/logout");
		http.oauth2ResourceServer((oauth2) -> oauth2
			.jwt(Customizer.withDefaults()));
		http.oauth2Login(Customizer.withDefaults())
			.logout(logout -> logout.logoutUrl("/logout")
				.addLogoutHandler(keycloakLogoutHandler).logoutSuccessHandler(logoutSuccessHandler()));
		return http.build();
	}


	private LogoutSuccessHandler logoutSuccessHandler() {
		return new SimpleUrlLogoutSuccessHandler() {
			@Override
			public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication)
				throws IOException {

				response.setHeader("Access-Control-Allow-Origin", keycloakServerUri);
				response.setStatus(HttpServletResponse.SC_OK);
				response.setContentType("application/json");
				response.getWriter().write("{\"message\": \"Logout successful\"}");
				response.getWriter().flush();
			}
		};
	}
}
