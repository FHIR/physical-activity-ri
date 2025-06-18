package ca.uhn.fhir.jpa.starter.enums;

public enum RoleGroups {
	ADMIN("admin"),

	PRACTITIONER("practitioner"),

	PATIENT("patient");

	private final String group;

	RoleGroups(String group) {
		this.group = group;
	}

	@Override
	public String toString() {
		return group;
	}

}
