<cfquery name="upd_worknet" datasource="#dsn#">
	UPDATE
		WORKNET
	SET
		WORKNET = '#attributes.worknet#',
        IS_INTERNET = <cfif isdefined('attributes.is_internet')>1<cfelse>0</cfif>,
        WORKNET_STATUS = <cfif isdefined('attributes.worknet_status')>1<cfelse>0</cfif>,
        WEBSITE = <cfif len(attributes.website)>'#attributes.website#',<cfelse>NULL,</cfif>
        STAGE = #attributes.process_stage#,
        MANAGER = <cfif len(attributes.manager)>'#attributes.manager#',<cfelse>NULL,</cfif>
        MANAGER_EMAIL = <cfif len(attributes.manager_email)>'#attributes.manager_email#',<cfelse>NULL,</cfif>
        DETAIL = <cfif len(attributes.detail)>'#attributes.detail#',<cfelse>NULL,</cfif>
        WORKNET_SABLON_FILE = <cfif len(attributes.sablon_file)>'#attributes.sablon_file#',<cfelse>NULL,</cfif>
        WORKNET_CSS_FILE = <cfif len(attributes.css_file)>'#attributes.css_file#',<cfelse>NULL,</cfif>
        WORKNET_SITE_NAME = <cfif len(attributes.domain)>'#attributes.domain#',<cfelse>NULL,</cfif>
        WORKNET_HEADER_HEIGHT = <cfif len(attributes.header_height)>#attributes.header_height#,<cfelse>NULL,</cfif>
        WORKNET_PAGE_WIDTH = <cfif len(attributes.general_width)>#attributes.general_width#,<cfelse>NULL,</cfif>
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE
		WORKNET_ID = #attributes.worknet_id#
</cfquery>
<script>
    window.location.href = "<cfoutput>#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['upd']['fuseaction']##attributes.worknet_id#</cfoutput>";
</script>
