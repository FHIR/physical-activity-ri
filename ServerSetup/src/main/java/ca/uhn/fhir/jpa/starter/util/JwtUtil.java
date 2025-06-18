package ca.uhn.fhir.jpa.starter.util;

import ca.uhn.fhir.jpa.starter.enums.RoleGroups;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nimbusds.jwt.JWT;
import com.nimbusds.jwt.JWTParser;
import com.nimbusds.jwt.SignedJWT;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Component;

import java.text.ParseException;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Component
public class JwtUtil {
	@Autowired
	private ObjectMapper objectMapper;

	public Map<String, Object> getClaims() {
		return getJwt().getClaims();
	}

	public Jwt getJwt() {
		return (Jwt) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	}

	public String getFhirId() {
		if(!getGroups().isEmpty()){
			if(getGroups().contains(RoleGroups.PRACTITIONER.toString())){
				return getClaims()!=null? getClaims().get("practitioner_id").toString() : null;
			}else if(getGroups().contains(RoleGroups.PATIENT.toString())){
				return getClaims()!=null? getClaims().get("patient_id").toString():null;
			}
		}else{
			return null;
		}
		return null;
	}

	public List<String> getGroups() {
		return (List<String>) getClaims().get("group");
	}

	public List<String> getPatientIds() {
		Object patientId = getClaims().get("patient_id");
		if (patientId == null) {
			return Collections.emptyList();
		}
        try {
            return objectMapper.readValue(patientId.toString(), new TypeReference<>() {});
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
    }
}

