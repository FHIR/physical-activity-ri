//package ca.uhn.fhir.jpa.starter.controller;
//
//import ca.uhn.fhir.jpa.starter.dto.PatientRequestDTO;
//import ca.uhn.fhir.jpa.starter.dto.attributes.AttributesDTO;
//import ca.uhn.fhir.jpa.starter.dto.attributes.UserAttributeRequestDTO;
//import ca.uhn.fhir.jpa.starter.dto.attributes.UserPasswordRequestDTO;
//import ca.uhn.fhir.jpa.starter.dto.response.UserInfoResponseDTO;
//import ca.uhn.fhir.jpa.starter.util.JwtUtil;
//import ca.uhn.fhir.jpa.starter.util.KeycloakUtil;
//import ca.uhn.fhir.jpa.starter.util.model.KeycloakUserRequestDTO;
//import ca.uhn.fhir.model.dstu2.resource.Patient;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.http.HttpEntity;
//import org.springframework.http.HttpHeaders;
//import org.springframework.http.HttpMethod;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.MediaType;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestBody;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RestController;
//import org.springframework.web.client.RestTemplate;
//
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import java.io.IOException;
//import java.nio.file.AccessDeniedException;
//import java.util.ArrayList;
//import java.util.List;
//import java.util.Map;
//
//@RestController
//@RequestMapping("/api/v1/practitioner")
//public class PractitionerController {
//
//	@Autowired
//	private JwtUtil jwtUtil;
//
//	@Autowired
//	private RestTemplate restTemplate;
//
//	@Autowired
//	private KeycloakUtil keycloakUtil;
//
//	@Value("${server.serverAddress}")
//	private String serverAddress;
//
//	@GetMapping("/patients")
//	public void getPatients(HttpServletRequest request, HttpServletResponse response) throws IOException {
//		List<String> claims = jwtUtil.getPatientIds();
//		if (claims.isEmpty()) {
//			throw new AccessDeniedException("no patient");
//		}
//		String idsString = String.join(",", claims);
//		response.sendRedirect("/fhir/Patient?_id=" + idsString);
//
//		Patient p;
//	}
//
//	@PostMapping("/patients")
//	public ResponseEntity<Map<String, Object>> createPatient(@RequestBody PatientRequestDTO body, HttpServletRequest request, HttpServletResponse response) {
//
//		HttpHeaders headers = new HttpHeaders();
//		headers.setContentType(MediaType.APPLICATION_JSON);
//		headers.setBearerAuth(jwtUtil.getJwt().getTokenValue());
//		HttpEntity<Map<String, Object>> httpEntity = new HttpEntity<>(body.getFhirRequestBody(), headers);
//
//		Map<String, Object> apiResponse = restTemplate.exchange(serverAddress + "/Patient", HttpMethod.POST, httpEntity, Map.class).getBody();
//
//		KeycloakUserRequestDTO dto = new KeycloakUserRequestDTO();
//		dto.setEnabled(true);
//		dto.setEmail(body.getEmail());
//		dto.setGroups(new ArrayList<>(List.of("patient")));
//		dto.setUsername(body.getUsername());
//		keycloakUtil.createUser(dto);
//
//		UserInfoResponseDTO userInfo = keycloakUtil.getUsersInfo(body.getUsername());
//		UserAttributeRequestDTO userAttributeRequest = new UserAttributeRequestDTO();
////		userAttributeRequest.setUsername(body.getUsername());
//		userAttributeRequest.setEnabled(true);
//
//		AttributesDTO attributesDTO = new AttributesDTO();
////		attributesDTO.setFhirId(new ArrayList<>(List.of(apiResponse.get("id").toString())));
//		attributesDTO.setPatientId(apiResponse.get("id").toString());
//		userAttributeRequest.setAttributes(attributesDTO);
//
//		keycloakUtil.putUserAttributes(userInfo.getId(), userAttributeRequest);
//
//		UserInfoResponseDTO practitionerUserInfo = keycloakUtil.getUserById(jwtUtil.getJwt().getClaim("sub"));
//
//		UserAttributeRequestDTO practitionerRequest = new UserAttributeRequestDTO();
////		practitionerRequest.setUsername(practitionerUserInfo.getUsername());
//		practitionerRequest.setEnabled(true);
//
//		UserPasswordRequestDTO userPasswordRequestDTO = new UserPasswordRequestDTO();
//		userPasswordRequestDTO.setTemporary("true");
//		userPasswordRequestDTO.setType("password");
//		userPasswordRequestDTO.setValue("1234");
//
//		practitionerUserInfo.getAttributes().getResourceId().add(apiResponse.get("id").toString());
//		practitionerRequest.setAttributes(practitionerUserInfo.getAttributes());
//		keycloakUtil.putUserAttributes(practitionerUserInfo.getId(), practitionerRequest);
//		keycloakUtil.resetUserPassword(practitionerUserInfo.getId(),userPasswordRequestDTO );
//
//		return ResponseEntity.status(HttpStatus.CREATED).body(apiResponse);
//	}
//
//	@GetMapping("/test")
//	public void testAPI() {
//		keycloakUtil.getUsersInfo("patent1");
//	}
//
//}
