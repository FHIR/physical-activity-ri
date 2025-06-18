package ca.uhn.fhir.jpa.starter.util.auth;

import org.hl7.fhir.r4.model.CapabilityStatement;

import java.util.List;

public class PatientMapDTO {

	private String url;
	private String method;
	private Boolean byId = false;
	private List<String> groups;
	private Boolean byResourceId = false;
	private Boolean byFhirId = false;
	private CapabilityStatement.TypeRestfulInteraction type;

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getMethod() {
		return method;
	}

	public void setMethod(String method) {
		this.method = method;
	}

	public Boolean getById() {
		return byId;
	}

	public void setById(Boolean byId) {
		this.byId = byId;
	}

	public List<String> getGroups() {
		return groups;
	}

	public void setGroups(List<String> groups) {
		this.groups = groups;
	}

	public Boolean getByResourceId() {
		return byResourceId;
	}

	public void setByResourceId(Boolean byResourceId) {
		this.byResourceId = byResourceId;
	}

	public Boolean getByFhirId() {
		return byFhirId;
	}

	public void setByFhirId(Boolean byFhirId) {
		this.byFhirId = byFhirId;
	}

	public CapabilityStatement.TypeRestfulInteraction getType() {
		return type;
	}

	public void setType(CapabilityStatement.TypeRestfulInteraction type) {
		this.type = type;
	}

}
