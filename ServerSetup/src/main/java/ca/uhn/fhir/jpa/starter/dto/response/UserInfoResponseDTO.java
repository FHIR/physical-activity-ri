package ca.uhn.fhir.jpa.starter.dto.response;

import ca.uhn.fhir.jpa.starter.dto.attributes.AttributesDTO;

public class UserInfoResponseDTO {

	private String id;
	private long createdTimestamp;
	private String username;

	private String email;
	private boolean enabled;
	private boolean emailVerified;
	private String firstName;
	private String lastName;
	private AccessDTO access;
	private BruteForceStatusDTO bruteForceStatus;
//	private AttributesDTO attributes;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public long getCreatedTimestamp() {
		return createdTimestamp;
	}

	public void setCreatedTimestamp(long createdTimestamp) {
		this.createdTimestamp = createdTimestamp;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
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

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public AccessDTO getAccess() {
		return access;
	}

	public void setAccess(AccessDTO access) {
		this.access = access;
	}

	public BruteForceStatusDTO getBruteForceStatus() {
		return bruteForceStatus;
	}

	public void setBruteForceStatus(BruteForceStatusDTO bruteForceStatus) {
		this.bruteForceStatus = bruteForceStatus;
	}

//	public AttributesDTO getAttributes() {
//		return attributes;
//	}
//
//	public void setAttributes(AttributesDTO attributes) {
//		this.attributes = attributes;
//	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
}
