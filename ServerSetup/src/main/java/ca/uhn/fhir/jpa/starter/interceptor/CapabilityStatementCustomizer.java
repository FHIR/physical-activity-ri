package ca.uhn.fhir.jpa.starter.interceptor;

import ca.uhn.fhir.interceptor.api.Hook;
import ca.uhn.fhir.interceptor.api.Pointcut;
import ca.uhn.fhir.jpa.starter.util.auth.PatientMapDTO;
import org.hl7.fhir.instance.model.api.IBaseConformance;
import org.hl7.fhir.r4.model.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import javax.interceptor.Interceptor;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

@ConfigurationProperties(prefix = "fhir")
@Component
@Interceptor
public class CapabilityStatementCustomizer {

	@Value("${spring.security.oauth2.client.provider.keycloak.base-uri}")
	private String keycloakServerBaseUri;

	@Value("${spring.security.oauth2.client.provider.keycloak.realm}")
	private String realm;

	@Value("${server.serverAddress}")
	private String serverAddress;

	private Map<String, List<PatientMapDTO>> resources;

	public Map<String, List<PatientMapDTO>> getResources() {
		return resources;
	}

	public void setResources(Map<String, List<PatientMapDTO>> resources) {
		this.resources = resources;
	}

	@Hook(Pointcut.SERVER_CAPABILITY_STATEMENT_GENERATED)
	public void customize(IBaseConformance theCapabilityStatement) {

		// Cast to the appropriate version
		CapabilityStatement cs = (CapabilityStatement) theCapabilityStatement;

		// Customize the CapabilityStatement as desired
		cs
			.getSoftware()
			.setName("Physical Activity FHIR Server")
			.setVersion("1.0")
			.setReleaseDateElement(new DateTimeType("2024-04-12"));

		cs.getImplementation()
			.setDescription("Physical Activity FHIR Server Endpoint")
			.setUrl(serverAddress);

		List<CapabilityStatement.CapabilityStatementRestComponent> restComponent = cs.getRest();
		restComponent.get(0).setSecurity((CapabilityStatement.CapabilityStatementRestSecurityComponent) new CapabilityStatement.CapabilityStatementRestSecurityComponent()
			.setCors(true) // Example, you can adjust according to your needs
			.addService(new CodeableConcept().addCoding(new Coding()
				.setSystem("http://hl7.org/fhir/restful-security-service")
				.setCode("SMART-on-FHIR")
				.setDisplay("SMART-on-FHIR")))
			.addExtension((Extension) new Extension()
				.setUrl(keycloakServerBaseUri + realm + "/.well-known/openid-configuration")
				.addExtension(new Extension()
					.setUrl("authorize")
					.setValue(new UriType(keycloakServerBaseUri + realm + "/protocol/openid-connect/auth")))
				.addExtension(new Extension()
					.setUrl("token")
					.setValue(new UriType(keycloakServerBaseUri + realm + "/protocol/openid-connect/token")))));
		cs.setRest(restComponent);

		List<CapabilityStatement.CapabilityStatementRestResourceComponent> serverResources = new ArrayList<>();
		resources.forEach((resourceName, patientMapDTOS) -> {

			CapabilityStatement.CapabilityStatementRestResourceComponent resourceComponent = new CapabilityStatement.CapabilityStatementRestResourceComponent();
			resourceComponent.setType(resourceName);
			resourceComponent.setProfile("http://hl7.org/fhir/StructureDefinition/" + resourceName);

			List<CapabilityStatement.ResourceInteractionComponent> theInteraction = new ArrayList<>();
			patientMapDTOS.forEach(patientMapDTO -> {
				if (theInteraction.stream().noneMatch(interactionComponent -> interactionComponent.getCode().equals(patientMapDTO.getType()))) {
					CapabilityStatement.ResourceInteractionComponent interaction = new CapabilityStatement.ResourceInteractionComponent();
					interaction.setCode(patientMapDTO.getType());
					interaction.setDocumentation("This resource is accessible to users with role :- " + patientMapDTO.getGroups());
					theInteraction.add(interaction);
				}
			});
			resourceComponent.setInteraction(theInteraction);
			serverResources.add(resourceComponent);
		});
		List<CapabilityStatement.CapabilityStatementRestResourceComponent> fhirResources = cs.getRestFirstRep().getResource();

		fhirResources.forEach(fhirResource -> serverResources.forEach(serverResource -> {
			if (fhirResource.getType().equals(serverResource.getType())) {
				serverResource.setSearchParam(fhirResource.getSearchParam());
			}
		}));

		cs.getRestFirstRep().setResource(serverResources);
		cs.getRestFirstRep().setInteraction(new ArrayList<>());
		cs.getRestFirstRep().setOperation(new ArrayList<>());
	}

}