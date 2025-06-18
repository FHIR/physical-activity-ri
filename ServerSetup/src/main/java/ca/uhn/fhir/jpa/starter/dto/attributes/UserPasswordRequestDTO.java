package ca.uhn.fhir.jpa.starter.dto.attributes;

public class UserPasswordRequestDTO {

	private String type;

	private String value;

	private String temporary;

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public String getTemporary() {
		return temporary;
	}

	public void setTemporary(String temporary) {
		this.temporary = temporary;
	}
}
