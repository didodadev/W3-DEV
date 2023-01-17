<cfquery name="add_worknet" datasource="#dsn#" result="get_max_id">
	INSERT INTO
		WORKNET
		(
			WORKNET,
			IS_INTERNET,
			WORKNET_STATUS,
			WEBSITE,
			STAGE,
			MANAGER,
			MANAGER_EMAIL,
			DETAIL,
            WORKNET_SABLON_FILE,
            WORKNET_CSS_FILE,
            WORKNET_SITE_NAME,
            WORKNET_HEADER_HEIGHT,
            WORKNET_PAGE_WIDTH,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		)
		VALUES
		(
			'#attributes.worknet#',
			<cfif isdefined('attributes.is_internet')>1<cfelse>0</cfif>,
            <cfif isdefined('attributes.worknet_status')>1<cfelse>0</cfif>,
			<cfif len(attributes.website)>'#attributes.website#',<cfelse>NULL,</cfif>
            #attributes.process_stage#,
			<cfif len(attributes.manager)>'#attributes.manager#',<cfelse>NULL,</cfif>
			<cfif len(attributes.manager_email)>'#attributes.manager_email#',<cfelse>NULL,</cfif>
			<cfif len(attributes.detail)>'#attributes.detail#',<cfelse>NULL,</cfif>
            
            <cfif len(attributes.sablon_file)>'#attributes.sablon_file#',<cfelse>NULL,</cfif>
            <cfif len(attributes.css_file)>'#attributes.css_file#',<cfelse>NULL,</cfif>
            <cfif len(attributes.domain)>'#attributes.domain#',<cfelse>NULL,</cfif>
            <cfif len(attributes.header_height)>#attributes.header_height#,<cfelse>NULL,</cfif>
            <cfif len(attributes.general_width)>#attributes.general_width#,<cfelse>NULL,</cfif>
            
			#now()#,
            #session.ep.userid#,
			'#cgi.remote_addr#'
		)
</cfquery>
<script>
    window.location.href = "<cfoutput>#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['upd']['fuseaction']##get_max_id.identitycol#</cfoutput>";
</script>