<cfquery name="ADD_" datasource="#dsn#">
    UPDATE
        MAIN_SITE_LAYOUTS 
    SET
        IS_ACTIVE = <cfif isdefined("attributes.is_active")>1,<cfelse>0,</cfif>
        LAYOUT_NAME = '#attributes.LAYOUT_NAME#',
        LEFT_WIDTH = <cfif len(attributes.LEFT_WIDTH)>#attributes.LEFT_WIDTH#,<cfelse>NULL,</cfif>
        RIGHT_WIDTH = <cfif len(attributes.RIGHT_WIDTH)>#attributes.RIGHT_WIDTH#,<cfelse>NULL,</cfif>
        CENTER_WIDTH = <cfif len(attributes.CENTER_WIDTH)>#attributes.CENTER_WIDTH#,<cfelse>NULL,</cfif>
        UPDATE_DATE = #NOW()#,
        UPDATE_EMP = #SESSION.EP.USERID#,
        UPDATE_IP = '#CGI.REMOTE_ADDR#'
    WHERE
        LAYOUT_ID = #attributes.layout_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_upd_site_layout&layout_id=#attributes.layout_id#" addtoken="no">
