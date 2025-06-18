package ca.uhn.fhir.jpa.starter;


import ca.uhn.fhir.jpa.starter.dto.response.UserInfoResponseDTO;
import ca.uhn.fhir.jpa.starter.util.KeycloakUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.oauth2.core.oidc.OidcIdToken;
import org.springframework.security.oauth2.core.oidc.OidcUserInfo;
import org.springframework.security.oauth2.core.oidc.user.OidcUser;
import org.springframework.security.web.authentication.logout.LogoutHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Collection;
import java.util.Map;

@Component
public class KeycloakLogoutHandler implements LogoutHandler {

	private static final Logger logger = LoggerFactory.getLogger(KeycloakLogoutHandler.class);
	private final RestTemplate restTemplate;

	private final KeycloakUtil keycloakUtil;

	@Value("${spring.security.oauth2.client.provider.keycloak.admin-base-uri}")
	private String keycloakServerBaseUri;


	@Value("${spring.security.oauth2.client.provider.keycloak.realm}")
	private String realm;

	public KeycloakLogoutHandler(RestTemplate restTemplate, KeycloakUtil keycloakUtil) {
		this.restTemplate = restTemplate;
		this.keycloakUtil = keycloakUtil;
	}

	@Override
	public void logout(HttpServletRequest request, HttpServletResponse response,
							 Authentication auth) {
		keycloakUtil.logoutFromKeycloak(request);
	}


}


