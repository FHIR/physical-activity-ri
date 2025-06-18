package ca.uhn.fhir.jpa.starter.util.model;

import java.util.List;
import java.util.Map;

public class PatientResponseDTO {

	private String resourceType;
	private String id;
	private Map<String, Object> meta;
	private String type;
	private Integer total;
	private List<Object> link;
	private List<Map<String, Object>> entry;

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

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Integer getTotal() {
		return total;
	}

	public void setTotal(Integer total) {
		this.total = total;
	}

	public List<Object> getLink() {
		return link;
	}

	public void setLink(List<Object> link) {
		this.link = link;
	}

	public List<Map<String, Object>> getEntry() {
		return entry;
	}

	public void setEntry(List<Map<String, Object>> entry) {
		this.entry = entry;
	}
}
