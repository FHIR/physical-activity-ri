package ca.uhn.fhir.jpa.starter.dto.response;

public class BruteForceStatusDTO {

	private int numFailures;
	private boolean disabled;
	private String lastIPFailure;
	private long lastFailure;

	public int getNumFailures() {
		return numFailures;
	}

	public void setNumFailures(int numFailures) {
		this.numFailures = numFailures;
	}

	public boolean isDisabled() {
		return disabled;
	}

	public void setDisabled(boolean disabled) {
		this.disabled = disabled;
	}

	public String getLastIPFailure() {
		return lastIPFailure;
	}

	public void setLastIPFailure(String lastIPFailure) {
		this.lastIPFailure = lastIPFailure;
	}

	public long getLastFailure() {
		return lastFailure;
	}

	public void setLastFailure(long lastFailure) {
		this.lastFailure = lastFailure;
	}
}
