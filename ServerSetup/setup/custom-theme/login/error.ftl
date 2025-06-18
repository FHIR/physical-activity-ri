<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
    <#if section == "header">
        ${kcSanitize(msg("errorTitle"))?no_esc}
    <#elseif section == "form">
        <div id="kc-error-message">
            <p class="instruction">${kcSanitize(message.summary)?no_esc}</p>
            <#if skipLink??>
            <#else>
                <#if client?? && client.baseUrl?has_content>
                    <p><a id="backToApplication" href="${client.baseUrl}">${kcSanitize(msg("backToApplication"))?no_esc}</a></p>
                </#if>
            </#if>

            <#-- Add conditional logic for displaying the logout button -->
            <#if kcSanitize(message.summary)?contains("You are already authenticated as different user")>
                <form id="logoutForm" data-redirect-url="${url.getLoginRestartFlowUrl()}" data-error-message="${message.summary}" action="#" method="post">
                    <input type="hidden" name="state" value="${stateParam?default('')}">
                    <button type="submit" id="logoutButton" class="btn btn-danger">${msg("logout")}</button>
                </form>
            </#if>
        </div>
    </#if>
</@layout.registrationLayout>
