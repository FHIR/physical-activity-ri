package ca.uhn.fhir.jpa.starter.dto.attributes;

public class UserAttributeRequestDTO {

	private String email;

	private AttributesDTO attributes;

	private boolean enabled = true;

	private boolean emailVerified = true;

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public AttributesDTO getAttributes() {
		return attributes;
	}

	public void setAttributes(AttributesDTO attributes) {
		this.attributes = attributes;
	}

	public boolean isEnabled() {
		return enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

	public boolean isEmailVerified() {
		return emailVerified;
	}

	public void setEmailVerified(boolean emailVerified) {
		this.emailVerified = emailVerified;
	}
}
