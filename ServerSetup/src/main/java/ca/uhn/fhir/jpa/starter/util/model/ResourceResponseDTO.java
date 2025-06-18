package ca.uhn.fhir.jpa.starter.util.model;

import ca.uhn.fhir.rest.api.server.ResponseDetails;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;
import java.util.Map;

public class ResourceResponseDTO{

	private String resourceType;
	private String id;
	private Map<String, Object> meta;

	private Map<String, Object> subject;

	private List<Map<String, Object>> telecom;

	@JsonProperty("for")
	private Map<String, Object> forValue;

	public String getResourceType() {
		return resourceType;
	}

	public void setResourceType(String resourceType) {
		this.resourceType = resourceType;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Map<String, Object> getMeta() {
		return meta;
	}

	public void setMeta(Map<String, Object> meta) {
		this.meta = meta;
	}

	public Map<String, Object> getSubject() {
		return subject;
	}

	public void setSubject(Map<String, Object> subject) {
		this.subject = subject;
	}

	public Map<String, Object> getForValue() {
		return forValue;
	}

	public void setForValue(Map<String, Object> forValue) {
		this.forValue = forValue;
	}

	public List<Map<String, Object>> getTelecom() {
		return telecom;
	}

	public void setTelecom(List<Map<String, Object>> telecom) {
		this.telecom = telecom;
	}
}
