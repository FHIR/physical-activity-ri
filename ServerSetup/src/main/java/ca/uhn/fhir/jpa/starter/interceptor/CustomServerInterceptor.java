package ca.uhn.fhir.jpa.starter.interceptor;

import ca.uhn.fhir.jpa.starter.constants.AppConstants;
import ca.uhn.fhir.jpa.starter.dto.attributes.AttributesDTO;
import ca.uhn.fhir.jpa.starter.dto.attributes.UserPasswordRequestDTO;
import ca.uhn.fhir.jpa.starter.enums.RoleGroups;
import ca.uhn.fhir.jpa.starter.util.FhirUtil;
import ca.uhn.fhir.jpa.starter.util.JwtUtil;
import ca.uhn.fhir.jpa.starter.util.KeycloakUtil;
import ca.uhn.fhir.jpa.starter.util.auth.PatientAuthUtil;
import ca.uhn.fhir.jpa.starter.util.model.KeycloakUserRequestDTO;
import ca.uhn.fhir.model.api.TagList;
import ca.uhn.fhir.rest.api.RestOperationTypeEnum;
import ca.uhn.fhir.rest.api.server.RequestDetails;
import ca.uhn.fhir.rest.api.server.ResponseDetails;
import ca.uhn.fhir.rest.server.exceptions.AuthenticationException;
import ca.uhn.fhir.rest.server.exceptions.BaseServerResponseException;
import ca.uhn.fhir.rest.server.exceptions.ForbiddenOperationException;
import ca.uhn.fhir.rest.server.interceptor.IServerInterceptor;
import ca.uhn.fhir.rest.server.method.ResourceParameter;
import ca.uhn.fhir.rest.server.servlet.ServletRequestDetails;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.hl7.fhir.instance.model.api.IBaseResource;
import org.hl7.fhir.r4.model.*;
import org.slf4j.ILoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.*;

@Component
public class CustomServerInterceptor implements IServerInterceptor {

	private final PatientAuthUtil patientAuthUtil;

	private final JwtUtil jwtUtil;

	private final FhirUtil fhirUtil;

	private final KeycloakUtil keycloakUtil;


	public CustomServerInterceptor(PatientAuthUtil patientAuthUtil, JwtUtil jwtUtil, FhirUtil fhirUtil, KeycloakUtil keycloakUtil) {
		this.patientAuthUtil = patientAuthUtil;
		this.jwtUtil = jwtUtil;
		this.fhirUtil = fhirUtil;
		this.keycloakUtil = keycloakUtil;
	}

	@Override
	public boolean handleException(RequestDetails theRequestDetails, BaseServerResponseException theException, HttpServletRequest theServletRequest, HttpServletResponse theServletResponse) throws ServletException, IOException {
		return true;
	}

	@Override
	public boolean incomingRequestPostProcessed(RequestDetails theRequestDetails, HttpServletRequest theRequest, HttpServletResponse theResponse) throws AuthenticationException {
		if (theRequest.getRequestURI().equals(AppConstants.META_DATA_URI)) {
			return true;
		}
		try {
			return patientAuthUtil.authenticate(theRequestDetails, theRequest, theResponse);
		} catch (IOException | ClassNotFoundException e) {
			throw new RuntimeException(e);
		}
    }

	@Override
	public void incomingRequestPreHandled(RestOperationTypeEnum theOperation, RequestDetails theProcessedRequest) {
	}

	@Override
	public boolean incomingRequestPreProcessed(HttpServletRequest theRequest, HttpServletResponse theResponse) {
		return true;
	}

	@Override
	public boolean outgoingResponse(RequestDetails theRequestDetails) {
		return true;
	}

	@Override
	public boolean outgoingResponse(RequestDetails theRequestDetails, HttpServletRequest theServletRequest, HttpServletResponse theServletResponse) throws AuthenticationException {
		return true;
	}

	@Override
	public boolean outgoingResponse(RequestDetails theRequestDetails, IBaseResource theResponseObject) {
		return true;
	}

	@Override
	public boolean outgoingResponse(RequestDetails theRequestDetails, IBaseResource theResponseObject, HttpServletRequest theServletRequest, HttpServletResponse theServletResponse) throws AuthenticationException {
		return true;
	}

	@Override
	public boolean outgoingResponse(RequestDetails theRequestDetails, ResponseDetails theResponseDetails, HttpServletRequest theServletRequest, HttpServletResponse theServletResponse) throws AuthenticationException {
		if (theServletRequest.getRequestURI().equals(AppConstants.META_DATA_URI)) {
			return true;
		}
		//Create Practitioner in keycloak once created in fhir
		if (theServletRequest.getRequestURI().equals(AppConstants.PRACTITIONER_RESOURCE_URI) && theServletRequest.getMethod().equals(AppConstants.REQUEST_METHOD_POST)) {
			Practitioner practitioner = (Practitioner) theResponseDetails.getResponseResource();
			Optional<ContactPoint> practitionerEmail = practitioner.getTelecom().stream().filter(tel -> tel.getSystem() == ContactPoint.ContactPointSystem.EMAIL).findAny();
			practitionerEmail.ifPresent((email) -> {
				String id = theResponseDetails.getResponseResource().getIdElement().getIdPart();
				createUserInKeycloak(email.getValue(), id, RoleGroups.PRACTITIONER.toString());
			});
		}

		//Create Patient in keycloak once created in fhir
		if (theServletRequest.getRequestURI().equals(AppConstants.PATIENT_RESOURCE_URI) && theServletRequest.getMethod().equals(AppConstants.REQUEST_METHOD_POST)) {
			Patient patient = ((Patient) theResponseDetails.getResponseResource());
			Optional<ContactPoint> patientEmail = patient.getTelecom().stream().filter(tel -> tel.getSystem() == ContactPoint.ContactPointSystem.EMAIL).findAny();
			patientEmail.ifPresent((email) -> {
				String id = theResponseDetails.getResponseResource().getIdElement().getIdPart();
				createUserInKeycloak(email.getValue(), id, RoleGroups.PATIENT.toString());
			});

		}

		//Delete Patient OR Practitioner from keycloak once get deleted from fhir
		if ((theRequestDetails.getResourceName().equals(AppConstants.PRACTITIONER_RESOURCE) || theRequestDetails.getResourceName().equals(AppConstants.PATIENT_RESOURCE)) && theServletRequest.getMethod().equals(AppConstants.REQUEST_METHOD_DELETE)) {
			String attributeName = null;
			if (theRequestDetails.getResourceName().equals(AppConstants.PRACTITIONER_RESOURCE)) {
				attributeName = AppConstants.PRACTITIONER_ATTRIBUTE;
			}
			if (theRequestDetails.getResourceName().equals(AppConstants.PATIENT_RESOURCE)) {
				attributeName = AppConstants.PATIENT_ATTRIBUTE;
			}
			if (attributeName != null) {
				keycloakUtil.deleteUserFromKeycloak(attributeName, theRequestDetails.getId().getIdPart());
			}
		}

		//Update a Practitioner in keycloak once updated in fhir
		if (theRequestDetails.getResourceName().equals(AppConstants.PRACTITIONER_RESOURCE) &&
			theServletRequest.getMethod().equals(AppConstants.REQUEST_METHOD_PUT) &&
			jwtUtil.getGroups().contains(RoleGroups.ADMIN.toString())) {
			Practitioner practitioner = ((Practitioner) theResponseDetails.getResponseResource());
			Optional<ContactPoint> patientEmail = practitioner.getTelecom().stream().filter(tel -> tel.getSystem() == ContactPoint.ContactPointSystem.EMAIL).findAny();
			patientEmail.ifPresent((email) -> {
					keycloakUtil.updateUserInKeycloak(AppConstants.PRACTITIONER_ATTRIBUTE, theRequestDetails.getId().getIdPart(), email.getValue() );
			});
		}

		//Update a Patient in keycloak once updated in fhir
		if (theRequestDetails.getResourceName().equals(AppConstants.PATIENT_RESOURCE) && theServletRequest.getMethod().equals(AppConstants.REQUEST_METHOD_PUT)) {
				Patient patient = ((Patient) theResponseDetails.getResponseResource());
				Optional<ContactPoint> patientEmail = patient.getTelecom().stream().filter(tel -> tel.getSystem() == ContactPoint.ContactPointSystem.EMAIL).findAny();
				patientEmail.ifPresent((email) -> {
					keycloakUtil.updateUserInKeycloak(AppConstants.PATIENT_ATTRIBUTE, theRequestDetails.getId().getIdPart(), email.getValue());
				});
		}

		//GET Resources(excluding Patient & Practitioner) by id
		
		List<String> userGroup = jwtUtil.getGroups();
     
		if (!userGroup.contains(RoleGroups.ADMIN.toString())) {
			//return true;
			if (theRequestDetails.getResourceName() != null &&
					!theRequestDetails.getResourceName().equals(AppConstants.PRACTITIONER_RESOURCE) &&
					!theRequestDetails.getResourceName().equals(AppConstants.PATIENT_RESOURCE) &&
					theServletRequest.getMethod().equals(AppConstants.REQUEST_METHOD_GET)) {

					List<String> patientIds = new ArrayList<>();
					if (jwtUtil.getGroups().contains(RoleGroups.PRACTITIONER.toString())) {
						patientIds = fhirUtil.getPatientsByPractitioner(jwtUtil.getFhirId());
					} else if (jwtUtil.getGroups().contains(RoleGroups.PATIENT.toString())) {
						patientIds.add(jwtUtil.getFhirId());
					}

					if (theRequestDetails.getId() != null && theRequestDetails.getId().getIdPart() != null) {
						String patientId = getPatientIdFromResponse(theResponseDetails);
						if (patientId != null && patientIds.contains(patientId)) {
							return true;
						} else {
							throw new ForbiddenOperationException("No " + theRequestDetails.getResourceName() + " Present.");
						}
					}


				}
		}
		
		return true;
	}

	public void createUserInKeycloak(String email, String resourceId, String groupName) {
		String resourceName = null;
		KeycloakUserRequestDTO requestDTO = new KeycloakUserRequestDTO();
		requestDTO.setEnabled(true);
		requestDTO.setGroups(List.of(groupName));
		requestDTO.setEmail(email);
		requestDTO.setUsername(email);
//		requestDTO.setEmailVerified(true);
		List<String> actions = Arrays.asList("UPDATE_PASSWORD", "VERIFY_EMAIL");
		requestDTO.setRequiredActions(actions);

		AttributesDTO attributesDTO = new AttributesDTO();

		if (groupName.equals(RoleGroups.PATIENT.toString())) {
			resourceName = AppConstants.PATIENT_RESOURCE;
			attributesDTO.setPatientId(resourceId);

		}

		if (groupName.equals(RoleGroups.PRACTITIONER.toString())) {
			resourceName = AppConstants.PRACTITIONER_RESOURCE;
			attributesDTO.setPractitionerId(resourceId);
		}


		requestDTO.setAttributes(attributesDTO);

		List<UserPasswordRequestDTO> credentials = new ArrayList<>();
		UserPasswordRequestDTO userPasswordRequestDTO = new UserPasswordRequestDTO();
		userPasswordRequestDTO.setValue("Pxema@35389");
		userPasswordRequestDTO.setTemporary("true");
		userPasswordRequestDTO.setType("password");
		credentials.add(userPasswordRequestDTO);
		requestDTO.setCredentials(credentials);
		try {
			ResponseEntity<Map> responseMap = keycloakUtil.createUser(requestDTO, resourceName, resourceId);
			keycloakUtil.sendExecuteActionsEmail(requestDTO.getEmail());
			if(!responseMap.getStatusCode().is2xxSuccessful() || responseMap.getStatusCode().isError()){
				fhirUtil.deleteUserFromFhir(resourceName, resourceId);
			}
		}catch (Exception e){
			fhirUtil.deleteUserFromFhir(resourceName, resourceId);
			throw new ForbiddenOperationException(e.getMessage());
		}

	}

	private String getPatientIdFromResponse(ResponseDetails theResponseDetails) {
		if (theResponseDetails.getResponseResource() instanceof Observation) {
			return ((Observation) theResponseDetails.getResponseResource()).getSubject().getReferenceElement().getIdPart();
		} else if (theResponseDetails.getResponseResource() instanceof Goal) {
			return ((Goal) theResponseDetails.getResponseResource()).getSubject().getReferenceElement().getIdPart();
		} else if (theResponseDetails.getResponseResource() instanceof Task) {
			return (((Task) theResponseDetails.getResponseResource()).getFor().getReferenceElement().getIdPart());
		} else if (theResponseDetails.getResponseResource() instanceof ServiceRequest) {
			return ((ServiceRequest) theResponseDetails.getResponseResource()).getSubject().getReferenceElement().getIdPart();
		} else if (theResponseDetails.getResponseResource() instanceof Condition) {
			return ((Condition) theResponseDetails.getResponseResource()).getSubject().getReferenceElement().getIdPart();
		} else if (theResponseDetails.getResponseResource() instanceof CarePlan) {
			return ((CarePlan) theResponseDetails.getResponseResource()).getSubject().getReferenceElement().getIdPart();
		} else if (theResponseDetails.getResponseResource() instanceof DocumentReference) {
			return ((DocumentReference) theResponseDetails.getResponseResource()).getSubject().getReferenceElement().getIdPart();
		}
		return null;
	}


	@Override
	public boolean outgoingResponse(RequestDetails theRequestDetails, TagList theResponseObject) {
		return true;
	}

	@Override
	public boolean outgoingResponse(RequestDetails theRequestDetails, TagList theResponseObject, HttpServletRequest theServletRequest, HttpServletResponse theServletResponse) throws AuthenticationException {
		return true;
	}

	@Override
	public BaseServerResponseException preProcessOutgoingException(RequestDetails theRequestDetails, Throwable theException, HttpServletRequest theServletRequest) throws ServletException {
		return null;
	}

	@Override
	public void processingCompletedNormally(ServletRequestDetails theRequestDetails) {

	}

}
