package ca.uhn.fhir.jpa.starter.controller;

import org.springframework.security.oauth2.core.oidc.user.OidcUser;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;

@RestController
@RequestMapping("/api/v1/keycloak")
public class KeycloakUserController {
	@GetMapping
	public void asdasd(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws IOException {
		System.out.println("");
		httpServletResponse.sendRedirect("/fhir/Patient?_id=2");
		System.out.println("");
		CaptureResponseWrapper wrapper = new CaptureResponseWrapper(httpServletResponse);
//		wrapper.getWriter().write();
	}

	public static class CaptureResponseWrapper extends HttpServletResponseWrapper {
		private final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();

		public CaptureResponseWrapper(HttpServletResponse response) {
			super(response);
		}

		@Override
		public PrintWriter getWriter() throws IOException {
			return new PrintWriter(byteArrayOutputStream);
		}

		public String getCapturedResponseContent() {
			return byteArrayOutputStream.toString();
		}
	}

}
