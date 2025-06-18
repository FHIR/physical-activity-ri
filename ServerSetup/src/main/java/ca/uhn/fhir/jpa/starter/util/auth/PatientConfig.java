package ca.uhn.fhir.jpa.starter.util.auth;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.regex.Pattern;

@ConfigurationProperties(prefix = "fhir")
@Component
public class PatientConfig {

	private Map<String, List<PatientMapDTO>> resources;

	public Map<String, List<PatientMapDTO>> getResources() {
		return resources;
	}

	public void setResources(Map<String, List<PatientMapDTO>> resources) {
		this.resources = resources;
	}

	public boolean matchUrl(String inputUrl, String urlToMatch) {
		String url = inputUrl;
		if (inputUrl.contains("?")) {
			url = inputUrl.substring(0, inputUrl.indexOf("?"));
		}
		String regexPattern = urlToMatch;
		if (regexPattern.contains("{id}")) {
			regexPattern = regexPattern.replace("{id}", "\\d+");
		}
		regexPattern = ".*" + regexPattern + "$";
		Pattern pattern = Pattern.compile(regexPattern);
		return pattern.matcher(url).matches();
	}

	public Optional<PatientMapDTO> getMappedModel(String inputUrl, String method, String resourceName) {
		return resources.getOrDefault(resourceName, Collections.emptyList())
			.stream()
			.filter(patientDTO -> method.equals(patientDTO.getMethod()) && matchUrl(inputUrl, patientDTO.getUrl()))
			.findAny();
	}

}
