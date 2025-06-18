package ca.uhn.fhir.jpa.starter.util;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import ca.uhn.fhir.jpa.starter.dto.attributes.UserAttributeRequestDTO;
import ca.uhn.fhir.jpa.starter.dto.attributes.UserPasswordRequestDTO;
import ca.uhn.fhir.jpa.starter.dto.response.UserInfoResponseByAttributeDTO;
import ca.uhn.fhir.jpa.starter.dto.response.UserInfoResponseDTO;
import ca.uhn.fhir.jpa.starter.util.model.KeycloakUserRequestDTO;

@Component
public class KeycloakUtil {
	@Value("${server.serverAddress}")
	private String serverAddress;

	@Value("${spring.security.oauth2.client.provider.keycloak.admin-base-uri}")
	private String keycloakServerAdminBaseUri;
	@Value("${spring.security.oauth2.client.provider.keycloak.base-uri}")
	private String keycloakServerBaseUri;

	@Value("${spring.security.oauth2.client.provider.keycloak.realm}")
	private String realm;

	@Value("${spring.security.oauth2.client.registration.keycloak.client-id}")
	private String client;

	@Value("${spring.security.oauth2.client.provider.keycloak.admin-username}")
	private String adminUsername;

	@Value("${spring.security.oauth2.client.provider.keycloak.admin-password}")
	private String adminPassword;

	@Value("${spring.security.oauth2.client.provider.keycloak.fhir-admin-username}")
	private String fhirAdminUsername;

	@Value("${spring.security.oauth2.client.provider.keycloak.fhir-admin-password}")
	private String fhirAdminPassword;
	private final RestTemplate restTemplate;

	private static final Logger logger = LoggerFactory.getLogger(KeycloakUtil.class);
	public KeycloakUtil(RestTemplate restTemplate) {
		this.restTemplate = restTemplate;
	}

	public ResponseEntity<Map> createUser(KeycloakUserRequestDTO requestDTO, String resourceName, String resourceId) {
		HttpHeaders headers = new HttpHeaders();
		headers.setBearerAuth(getAuthToken());
		headers.setContentType(MediaType.APPLICATION_JSON);
		HttpEntity<KeycloakUserRequestDTO> httpEntity = new HttpEntity<>(requestDTO, headers);

		return restTemplate.exchange(keycloakServerAdminBaseUri + realm + "/users", HttpMethod.POST, httpEntity, Map.class);
	}

	public UserInfoResponseDTO getUsersInfo(String email, String token) {

		String url = keycloakServerAdminBaseUri + realm + "/users?username=" + email;
		HttpHeaders headers = new HttpHeaders();
		headers.setBearerAuth(token);
		headers.setContentType(MediaType.APPLICATION_JSON);
		HttpEntity httpEntity = new HttpEntity(headers);
		List<UserInfoResponseDTO> response = restTemplate.exchange(url, HttpMethod.GET, httpEntity, new ParameterizedTypeReference<List<UserInfoResponseDTO>>() {
		}).getBody();
		return Optional.ofNullable(response).flatMap(res -> res.stream().findFirst()).orElse(null);
	}


	public void putUserAttributes(String userId, UserAttributeRequestDTO requestBody) {
		Map authResponse = generateToken();
		String token = Optional.ofNullable(authResponse)
			.map(au -> Objects.requireNonNull(au).get("access_token"))
			.map(Object::toString)
			.orElseThrow(RuntimeException::new);

		String url = keycloakServerAdminBaseUri + realm + "/users/" + userId;
		HttpHeaders headers = new HttpHeaders();
		headers.setBearerAuth(token);
		headers.setContentType(MediaType.APPLICATION_JSON);
		HttpEntity<UserAttributeRequestDTO> httpEntity = new HttpEntity<>(requestBody, headers);
		restTemplate.exchange(url, HttpMethod.PUT, httpEntity, Object.class);
	}

	public void resetUserPassword(String userId, UserPasswordRequestDTO requestBody) {
		Map authResponse = generateToken();
		String token = Optional.ofNullable(authResponse)
			.map(au -> Objects.requireNonNull(au).get("access_token"))
			.map(Object::toString)
			.orElseThrow(RuntimeException::new);

		String url = keycloakServerAdminBaseUri + realm + "/users/" + userId + "/reset-password";
		HttpHeaders headers = new HttpHeaders();
		headers.setBearerAuth(token);
		headers.setContentType(MediaType.APPLICATION_JSON);
		HttpEntity<UserPasswordRequestDTO> httpEntity = new HttpEntity<>(requestBody, headers);
		restTemplate.exchange(url, HttpMethod.PUT, httpEntity, Object.class);
	}

	public UserInfoResponseDTO getUserById(String id) {
		Map authResponse = generateToken();
		String token = Optional.ofNullable(authResponse)
			.map(au -> Objects.requireNonNull(au).get("access_token"))
			.map(Object::toString)
			.orElseThrow(RuntimeException::new);

		String url = keycloakServerAdminBaseUri + realm + "/users/" + id;

		HttpHeaders headers = new HttpHeaders();
		headers.setBearerAuth(token);
		headers.setContentType(MediaType.APPLICATION_JSON);
		HttpEntity httpEntity = new HttpEntity(headers);
		return restTemplate.exchange(url, HttpMethod.GET, httpEntity, UserInfoResponseDTO.class).getBody();
	}

	public void deleteUserFromKeycloak(String attributeName, String attributeValue) {
		UserInfoResponseByAttributeDTO userInfoResponseDTO = getUsersInfoByAttributes(attributeName, attributeValue);
		if (userInfoResponseDTO != null) {
			HttpHeaders headers = new HttpHeaders();
			headers.setBearerAuth(getAuthToken());
			headers.setContentType(MediaType.APPLICATION_JSON);
			HttpEntity httpEntity = new HttpEntity(headers);
			logger.debug("keycloakServerAdminBaseUri:"+keycloakServerAdminBaseUri);
			logger.debug("realm:"+realm);
			restTemplate.exchange(keycloakServerAdminBaseUri + realm + "/users/" + userInfoResponseDTO.getId(), HttpMethod.DELETE, httpEntity, Map.class);
		}
	}


	public void updateUserInKeycloak(String attributeName, String attributeValue, String newMail) {
		UserInfoResponseByAttributeDTO userInfoResponseDTO = getUsersInfoByAttributes(attributeName, attributeValue);
		if (userInfoResponseDTO != null && !userInfoResponseDTO.getEmail().equals(newMail)) {
			Map authResponse = generateToken();
			String token = Optional.ofNullable(authResponse)
				.map(au -> Objects.requireNonNull(au).get("access_token"))
				.map(Object::toString)
				.orElseThrow(RuntimeException::new);

			HttpHeaders headers = new HttpHeaders();
			headers.setBearerAuth(token);
			headers.setContentType(MediaType.APPLICATION_JSON);
			KeycloakUserRequestDTO requestDTO = new KeycloakUserRequestDTO();
			requestDTO.setEmail(newMail);
			requestDTO.setEnabled(true);
			HttpEntity httpEntity = new HttpEntity(requestDTO, headers);
			restTemplate.exchange(keycloakServerAdminBaseUri + realm + "/users/" + userInfoResponseDTO.getId(), HttpMethod.PUT, httpEntity, Map.class);
		}

	}

	public Map generateToken() {
		MultiValueMap<String, String> requestBody = new LinkedMultiValueMap<>();
		requestBody.add("username", adminUsername);
		requestBody.add("password", adminPassword);
		requestBody.add("client_id", "admin-cli");
		requestBody.add("grant_type", "password");

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		HttpEntity<MultiValueMap<String, String>> httpEntity = new HttpEntity<>(requestBody, headers);
		logger.debug("keycloakServerBaseUri:"+keycloakServerBaseUri);
		return restTemplate.exchange(keycloakServerBaseUri + "/master/protocol/openid-connect/token", HttpMethod.POST, httpEntity, Map.class).getBody();
	}
	
	public String getAuthToken() {
		Map authResponse = generateToken();
		String token = Optional.ofNullable(authResponse)
			.map(au -> Objects.requireNonNull(au).get("access_token"))
			.map(Object::toString)
			.orElseThrow(RuntimeException::new);
		logger.debug("Auth Token:"+token);	
		return token;	
	}

	public Map generateInternalToken() {
		MultiValueMap<String, String> requestBody = new LinkedMultiValueMap<>();
		requestBody.add("username", fhirAdminUsername);
		requestBody.add("password", fhirAdminPassword);
		requestBody.add("client_id", client);
		requestBody.add("grant_type", "password");

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		HttpEntity<MultiValueMap<String, String>> httpEntity = new HttpEntity<>(requestBody, headers);
		return restTemplate.exchange(keycloakServerBaseUri + realm + "/protocol/openid-connect/token", HttpMethod.POST, httpEntity, Map.class).getBody();

	}

	public UserInfoResponseByAttributeDTO getUsersInfoByAttributes(String attributeName, String attributeValue) {

		String url = keycloakServerAdminBaseUri + realm + "/users?q=+" + attributeName + ":" + attributeValue;
		logger.info("UsersInfoURL:"+url);
		HttpHeaders headers = new HttpHeaders();
		headers.setBearerAuth(getAuthToken());
		headers.setContentType(MediaType.APPLICATION_JSON);
		HttpEntity httpEntity = new HttpEntity(headers);
		List<UserInfoResponseByAttributeDTO> response = restTemplate.exchange(url, HttpMethod.GET, httpEntity, new ParameterizedTypeReference<List<UserInfoResponseByAttributeDTO>>() {
		}).getBody();
		return Optional.ofNullable(response).flatMap(res -> res.stream().findFirst()).orElse(null);
	}

	public void sendExecuteActionsEmail(String email) {

		Map authResponse = generateToken();
		String token = Optional.ofNullable(authResponse)
			.map(au -> Objects.requireNonNull(au).get("access_token"))
			.map(Object::toString)
			.orElseThrow(RuntimeException::new);
		UserInfoResponseDTO userInfoResponseDTO = getUsersInfo(email, token);
		String url = keycloakServerAdminBaseUri + realm +  "/users/" + userInfoResponseDTO.getId() + "/execute-actions-email";

		try {
			HttpHeaders headers = new HttpHeaders();
			headers.setBearerAuth(token);
			headers.setContentType(MediaType.APPLICATION_JSON);

			List<String> actions = Arrays.asList("UPDATE_PASSWORD", "VERIFY_EMAIL");

			HttpEntity<List<String>> request = new HttpEntity<>(actions, headers);
			restTemplate.exchange(url, HttpMethod.PUT, request, Void.class);

		}catch (Exception e){
			logger.info(e.getMessage());
		}

}
//

	public void logoutFromKeycloak(HttpServletRequest request) {
		Map authResponse = generateToken();
		String token = Optional.ofNullable(authResponse)
			.map(au -> Objects.requireNonNull(au).get("access_token"))
			.map(Object::toString)
			.orElseThrow(RuntimeException::new);
		UserInfoResponseDTO userInfoResponseDTO = getUsersInfo(request.getParameter("username"), token);

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		headers.setBearerAuth(token);
		HttpEntity httpEntity = new HttpEntity(headers);

		String endSessionEndpoint =  keycloakServerAdminBaseUri + realm+ "/users/"+userInfoResponseDTO.getId()+"/logout";

		ResponseEntity<String> logoutResponse = restTemplate.exchange(endSessionEndpoint, HttpMethod.POST,
			httpEntity, String.class);
		if (logoutResponse.getStatusCode().is2xxSuccessful()) {
			logger.info("Successfulley logged out from Keycloak");
		} else {
			logger.error("Could not propagate logout to Keycloak");
		}
	}
}