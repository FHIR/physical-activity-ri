package ca.uhn.fhir.jpa.starter.constants;

public final class AppConstants {

	public static final String CONTEXT_PATH = "/fhir";
	public static final String PRACTITIONER_RESOURCE = "Practitioner";

	public static final String PATIENT_RESOURCE = "Patient";

	public static final String TASK_RESOURCE = "Task";

	//Uri Constants
	public static final String META_DATA_URI = CONTEXT_PATH + "/metadata";

	public static final String PRACTITIONER_RESOURCE_URI = CONTEXT_PATH + "/" + PRACTITIONER_RESOURCE;

	public static final String PATIENT_RESOURCE_URI	 = CONTEXT_PATH + "/" + PATIENT_RESOURCE;

	//Request Method Constants
	public static final String REQUEST_METHOD_GET = "GET";
	public static final String REQUEST_METHOD_POST = "POST";

	public static final String REQUEST_METHOD_PUT = "PUT";
	public static final String REQUEST_METHOD_DELETE = "DELETE";


	//Attribute Constants
	public  static final String PRACTITIONER_ATTRIBUTE = "practitionerId";
	public  static final String PATIENT_ATTRIBUTE = "patientId";

	//Message Constants

	public static final String FORBIDDEN  = "Forbidden";
	public static final String NO_RECORDS = "No Records.";
	public static final String NO_PATIENTS = "No Patients assigned to you.";

	public static final String NOT_ALLOWED_TO_ACCESS_PATIENTS = "You are not allowed to access Patient with ids ";

	public static final String WRONG_PRACTITIONER = "You are referencing wrong Practitioner.";

	public static final String NOT_ALLOWED_TO_PERFORM_OPERATION = "You are not allowed to perform this operation.";


}
