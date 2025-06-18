package ca.uhn.fhir.jpa.starter.dto;

import java.util.Map;

public class PatientRequestDTO {

	private String username;

	private String email;

	private Map<String, Object> fhirRequestBody;

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Map<String, Object> getFhirRequestBody() {
		return fhirRequestBody;
	}

	public void setFhirRequestBody(Map<String, Object> fhirRequestBody) {
		this.fhirRequestBody = fhirRequestBody;
	}
}
