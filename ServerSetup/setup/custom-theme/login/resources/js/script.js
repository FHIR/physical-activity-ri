document.addEventListener("DOMContentLoaded", async function () {
    const togglePasswordVisibilityButton = document.getElementById("togglePasswordVisibility");
    const passwordInput = document.getElementById("password");

    if (togglePasswordVisibilityButton && passwordInput) {
        togglePasswordVisibilityButton.addEventListener("click", function () {
            if (passwordInput.type === "password") {
                passwordInput.type = "text";
                this.className = "fa fa-eye";
                this.setAttribute('aria-label', this.getAttribute('data-label-hide'));
            } else {
                passwordInput.type = "password";
                this.className = "fa fa-eye-slash";
                this.setAttribute('aria-label', this.getAttribute('data-label-show'));
            }
        });
    }

    const logoutForm = document.getElementById('logoutForm');
    if (logoutForm) {
        logoutForm.addEventListener('submit', async function (event) {
            event.preventDefault();

            const redirectPath = logoutForm.getAttribute('data-redirect-url');

            const regex = /You are already authenticated as different user '(.+?)' in this session/;
            const errorMessageElement = logoutForm.getAttribute('data-error-message');

            const match = errorMessageElement.match(regex);
            let username = '';
            if (match && match[1]) {
                username = match[1];
            }

            await logoutUser(username, redirectPath);

        });
    };
});

async function logoutUser(userId, redirect_url) {
    const url = 'https://fhir.testphysicalactivity.com/logout?username=' + userId;
    try {
        fetch(url, {
            method: 'POST'
        })
            .then(response => {
                if (response.ok) {
                    window.location.href = redirect_url;
                }
            })
            .catch(error => {
                console.error('Error:', error);
            });

    } catch (error) {
        console.error('Failed to log out user:', error);
    }
}
