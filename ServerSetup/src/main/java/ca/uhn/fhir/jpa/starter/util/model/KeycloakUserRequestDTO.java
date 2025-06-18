package ca.uhn.fhir.jpa.starter.util.model;

import ca.uhn.fhir.jpa.starter.dto.attributes.AttributesDTO;
import ca.uhn.fhir.jpa.starter.dto.attributes.UserPasswordRequestDTO;

import java.util.List;

public class KeycloakUserRequestDTO {

	private String username;
	private String email;

	private boolean emailVerified;
	private List<String> groups;
	private boolean enabled;
	private List<String> requiredActions;

	private AttributesDTO attributes;

	private List<UserPasswordRequestDTO> credentials;



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

	public boolean isEmailVerified() {
		return emailVerified;
	}

	public void setEmailVerified(boolean emailVerified) {
		this.emailVerified = emailVerified;
	}

	public List<String> getGroups() {
		return groups;
	}

	public void setGroups(List<String> groups) {
		this.groups = groups;
	}

	public boolean isEnabled() {
		return enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

	public List<String> getRequiredActions() {
		return requiredActions;
	}

	public void setRequiredActions(List<String> requiredActions) {
		this.requiredActions = requiredActions;
	}

	public AttributesDTO getAttributes() {
		return attributes;
	}

	public void setAttributes(AttributesDTO attributes) {
		this.attributes = attributes;
	}

	public List<UserPasswordRequestDTO> getCredentials() {
		return credentials;
	}

	public void setCredentials(List<UserPasswordRequestDTO> credentials) {
		this.credentials = credentials;
	}
}
