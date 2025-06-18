package ca.uhn.fhir.jpa.starter.dto.attributes;

import java.util.ArrayList;
import java.util.List;

public class AttributesDTO {

	private String patientId;

	private String practitionerId;


	public String getPatientId() {
		return patientId;
	}

	public void setPatientId(String patientId) {
		this.patientId = patientId;
	}

	public String getPractitionerId() {
		return practitionerId;
	}

	public void setPractitionerId(String practitionerId) {
		this.practitionerId = practitionerId;
	}
}
