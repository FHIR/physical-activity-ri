package ca.uhn.fhir.jpa.starter.util;

import ca.uhn.fhir.jpa.starter.util.model.PatientResponseDTO;
import ca.uhn.fhir.jpa.starter.util.model.ResourceResponseDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
public class FhirUtil {

	@Value("${server.serverAddress}")
	private String serverAddress;
	@Autowired
	private RestTemplate restTemplate;

	@Autowired
	private KeycloakUtil keycloakUtil;

	@Autowired
	private  JwtUtil jwtUtil;

	private static final Logger logger = LoggerFactory.getLogger(FhirUtil.class);

	public List<String> getPatientsByPractitioner(String fhirId) {


		Map authResponse = keycloakUtil.generateInternalToken();
		String token = Optional.ofNullable(authResponse)
			.map(au -> Objects.requireNonNull(au).get("access_token"))
			.map(Object::toString)
			.orElseThrow(RuntimeException::new);

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		headers.setBearerAuth(token);

		HttpEntity<String> httpEntity = new HttpEntity<>(headers);

		String url = serverAddress + "Patient?general-practitioner=" + fhirId;

		PatientResponseDTO response = restTemplate.exchange(url, HttpMethod.GET, httpEntity, PatientResponseDTO.class).getBody();

		return Optional.ofNullable(response.getEntry())
			.map(entry -> entry.stream().map(en -> ((Map)en.get("resource")).get("id").toString()).collect(Collectors.toList()))
			.orElse(Collections.emptyList());

	}

	public List<String> getResource(String url) {


		Map authResponse = keycloakUtil.generateInternalToken();
		String token = Optional.ofNullable(authResponse)
			.map(au -> Objects.requireNonNull(au).get("access_token"))
			.map(Object::toString)
			.orElseThrow(RuntimeException::new);

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		headers.setBearerAuth(token);

		HttpEntity<String> httpEntity = new HttpEntity<>(headers);

		PatientResponseDTO response = restTemplate.exchange(url, HttpMethod.GET, httpEntity, PatientResponseDTO.class).getBody();

		return Optional.ofNullable(response.getEntry())
			.map(entry -> entry.stream().map(en -> ((Map)en.get("resource")).get("id").toString()).collect(Collectors.toList()))
			.orElse(Collections.emptyList());

	}


	public ResourceResponseDTO getResourceById(String resourceId, String resourceName) throws ClassNotFoundException {
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		headers.setBearerAuth(jwtUtil.getJwt().getTokenValue());

		HttpEntity<String> httpEntity = new HttpEntity<>(headers);

		String url = serverAddress + resourceName + "/" + resourceId;

		return restTemplate.exchange(url, HttpMethod.GET, httpEntity, ResourceResponseDTO.class).getBody();


	}

	public void deleteUserFromFhir(String resourceName, String resourceId) {
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		String token  = jwtUtil.getJwt().getTokenValue();
		logger.debug("AUTH token:"+token);
		headers.setBearerAuth(token);

		HttpEntity<String> httpEntity = new HttpEntity<>(headers);

		String url = serverAddress + resourceName + "/" + resourceId;
		
		logger.debug("SERVER URL:"+url);

		restTemplate.exchange(url, HttpMethod.DELETE, httpEntity, ResourceResponseDTO.class).getBody();

	}
}
