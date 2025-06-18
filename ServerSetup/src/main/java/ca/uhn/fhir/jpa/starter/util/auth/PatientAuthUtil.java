package ca.uhn.fhir.jpa.starter.util.auth;

import ca.uhn.fhir.jpa.starter.constants.AppConstants;
import ca.uhn.fhir.jpa.starter.enums.RoleGroups;
import ca.uhn.fhir.jpa.starter.util.FhirUtil;
import ca.uhn.fhir.jpa.starter.util.JwtUtil;
import ca.uhn.fhir.rest.api.RequestTypeEnum;
import ca.uhn.fhir.rest.api.server.RequestDetails;
import ca.uhn.fhir.rest.server.exceptions.ForbiddenOperationException;
import ca.uhn.fhir.rest.server.method.ResourceParameter;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.hl7.fhir.r4.model.CapabilityStatement;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.*;

@Component
public class PatientAuthUtil {


	private final PatientConfig patientConfig;
	private final FhirUtil fhirUtil;

	private final JwtUtil jwtUtil;

	public PatientAuthUtil(FhirUtil fhirUtil, JwtUtil jwtUtil, PatientConfig patientConfig) {
		this.patientConfig = patientConfig;
		this.fhirUtil = fhirUtil;
		this.jwtUtil = jwtUtil;
	}

	public boolean authenticate(RequestDetails requestDetails, HttpServletRequest request, HttpServletResponse response) throws IOException, ClassNotFoundException {
		List<String> userGroup = jwtUtil.getGroups();

		if (userGroup.contains(RoleGroups.ADMIN.toString())) {
			return true;
		}

		PatientMapDTO patientDTO = patientConfig.getMappedModel(request.getRequestURI(), request.getMethod(), requestDetails.getResourceName()).orElse(null);
		if (patientDTO != null) {
			boolean isUserAllowed = patientDTO.getGroups().stream().anyMatch(userGroup::contains);
			if (isUserAllowed) {
				//GET Patient Resource by id (GET => /fhir/Patient/{id} )
				if (patientDTO.getType() == CapabilityStatement.TypeRestfulInteraction.SEARCHTYPE && Boolean.TRUE.equals(patientDTO.getById())) {
					if (requestDetails.getResourceName().equals(AppConstants.PATIENT_RESOURCE) || requestDetails.getResourceName().equals(AppConstants.PRACTITIONER_RESOURCE)) {
						return authenticateById(requestDetails, request, patientDTO);
					}
				}

				if (request.getMethod().equals(AppConstants.REQUEST_METHOD_POST) || request.getMethod().equals(AppConstants.REQUEST_METHOD_PUT)) {
					if (requestDetails.getResourceName().equals(AppConstants.PATIENT_RESOURCE)) {
						boolean valid = validatePractitionerInRequest(requestDetails);
						if(valid && request.getMethod().equals(AppConstants.REQUEST_METHOD_POST)){
							return true;
						}
					}
				}
				String fhirId = jwtUtil.getFhirId();
				List<String> patientIds = new ArrayList<>();
				if (!requestDetails.getResourceName().equals(AppConstants.PRACTITIONER_RESOURCE) && jwtUtil.getGroups().contains("practitioner")) {
					patientIds = fhirUtil.getPatientsByPractitioner(fhirId);
				} else {
					patientIds.add(fhirId);
				}

				if (patientIds.isEmpty()) {
					throw new ForbiddenOperationException(AppConstants.NO_PATIENTS);
				}


				//GET All Resources (GET => /fhir/{Resource})
				if (patientDTO.getType() == CapabilityStatement.TypeRestfulInteraction.SEARCHTYPE) {
					if (requestDetails.getResourceName().equals(AppConstants.PRACTITIONER_RESOURCE)) {
						return true;
					}
					requestDetails.setRequestPath(requestDetails.getResourceName() + "/" + "_search");
					requestDetails.setCompleteUrl(requestDetails.getFhirServerBase() + "/" + requestDetails.getResourceName() + "/_search");
					requestDetails.setOperation("_search");
					requestDetails.setRequestType(RequestTypeEnum.POST);

					String paramName = "patient";
					if (requestDetails.getResourceName().equals(AppConstants.PATIENT_RESOURCE) || requestDetails.getResourceName().equals(AppConstants.PRACTITIONER_RESOURCE)) {
						paramName = "_id";
					}

					//If query params present in request(_id in case of Patient and subject for other resources)
					if (request.getQueryString() != null && requestDetails.getParameters() != null) {
						String[] requestedPatientIds = requestDetails.getParameters().get(paramName);
						if (requestedPatientIds != null) {
							String[] numbers = requestedPatientIds[0].split(",");
							if (numbers.length > 0) {
								List<String> missingElements = new ArrayList<>();
								boolean containsAll = arrayContainsAllElements(Arrays.asList(numbers), patientIds, missingElements);

								if (containsAll) {
									requestDetails.addParameter(paramName, new String[]{String.join(",", Arrays.asList(numbers))});
									return true;

								} else {
									if (missingElements.isEmpty()) {
										throw new ForbiddenOperationException(AppConstants.NO_RECORDS);
									}
									throw new ForbiddenOperationException(AppConstants.NOT_ALLOWED_TO_ACCESS_PATIENTS + missingElements);
								}
							}

						}
						requestDetails.addParameter(paramName, new String[]{String.join(",", patientIds)});
					} else {
						requestDetails.addParameter(paramName, new String[]{String.join(",", patientIds)});
					}
					return true;
				}


				//POST or UPDATE the resources (e.g. POST => /fhir/Patient , /fhir/Observation, /fhir/Goal etc)
				else if (request.getMethod().equals(AppConstants.REQUEST_METHOD_POST) || request.getMethod().equals(AppConstants.REQUEST_METHOD_PUT)) {
					return validateRequestBodyForPatientAndOtherResources(requestDetails, patientIds, request);

				}
			} else {
				throw new ForbiddenOperationException(AppConstants.FORBIDDEN);
			}
		} else {
			throw new ForbiddenOperationException(AppConstants.FORBIDDEN);
		}
		return true;
	}

	public boolean validateRequestBodyForPatientAndOtherResources(RequestDetails requestDetails, List<String> patientIds, HttpServletRequest request) {
		Charset charset = ResourceParameter.determineRequestCharset(requestDetails);
		String requestText = new String(requestDetails.loadRequestContents(), charset);
		String referenceId = null;
		JsonParser parser = new JsonParser();
		JsonObject jsonObject = parser.parse(requestText).getAsJsonObject();
		if (requestDetails.getResourceName().equals(AppConstants.PATIENT_RESOURCE) && request.getMethod().equals(AppConstants.REQUEST_METHOD_PUT)) {
			referenceId = requestDetails.getId().getIdPart();
		} else if (requestDetails.getResourceName().equals(AppConstants.TASK_RESOURCE)) {
			if (jsonObject.has("for")) {
				referenceId = jsonObject.get("for").getAsJsonObject().get("reference").getAsString().split("/")[1];
			}
		} else {
			if (jsonObject.has("subject")) {
				referenceId = jsonObject.get("subject").getAsJsonObject().get("reference").getAsString().split("/")[1];
			}
		}


		if (referenceId != null && !patientIds.contains(referenceId)) {
			throw new ForbiddenOperationException(AppConstants.NOT_ALLOWED_TO_PERFORM_OPERATION);
		}
		return true;
	}

	private boolean validatePractitionerInRequest(RequestDetails requestDetails) {
		Charset charset = ResourceParameter.determineRequestCharset(requestDetails);
		String requestText = new String(requestDetails.loadRequestContents(), charset);
		JsonParser parser = new JsonParser();
		JsonObject jsonObject = parser.parse(requestText).getAsJsonObject();
		if (jsonObject.has("generalPractitioner")) {
			JsonArray generalPractitionerArray = jsonObject.get("generalPractitioner").getAsJsonArray();
			List<String> practitionerIds = new ArrayList<>();
			// Iterate through the JSONArray
			for (int i = 0; i < generalPractitionerArray.size(); i++) {
				if (generalPractitionerArray.get(i).getAsJsonObject().has("reference")) {
					practitionerIds.add(generalPractitionerArray.get(i).getAsJsonObject().get("reference").getAsString().split("/")[1]);
				}
			}
			if (!practitionerIds.isEmpty()) {
//					if (!jwtUtil.getGroups().contains(RoleGroups.ADMIN.toString()) && practitionerIds.size() > 1) {
//						throw new ForbiddenOperationException(AppConstants.NOT_MORE_THAN_ONE_PRACTITIONER);
//					}
				if (!practitionerIds.contains(jwtUtil.getFhirId())) {
					throw new ForbiddenOperationException(AppConstants.WRONG_PRACTITIONER);
				}
			}
		}
		return true;
	}

	public boolean authenticateById(RequestDetails requestDetails, HttpServletRequest request, PatientMapDTO patientDTO) {
		List<String> userGroup = jwtUtil.getGroups();
		String fhirId = jwtUtil.getFhirId();
		if (userGroup.contains(RoleGroups.PRACTITIONER.toString()) && requestDetails.getResourceName().equals(AppConstants.PATIENT_RESOURCE)) {
			List<String> resourceIds = fhirUtil.getPatientsByPractitioner(fhirId);
			if (resourceIds.contains(requestDetails.getId().getIdPart())) {
				return true;
			}
		} else {
			if (fhirId.equals(requestDetails.getId().getIdPart())) {
				return true;
			}
		}
		throw new ForbiddenOperationException(AppConstants.NO_RECORDS);
	}

	public static boolean arrayContainsAllElements(List<String> strings, List<String> stringList, List<String> missingElements) {
		boolean containsAll = true;
		for (String str : strings) {
			if (!stringList.contains(str)) {
				containsAll = false;
				missingElements.add(str);
			}
		}

		return containsAll;
	}

}
