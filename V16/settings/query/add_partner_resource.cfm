<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="GET_REOURCE" datasource="#dsn#">
			SELECT
				MAX(RESOURCE_ID) AS MAX_ID
			FROM
				COMPANY_PARTNER_RESOURCE
		</cfquery>
		<cfif isnumeric(GET_REOURCE.MAX_ID)>
			<cfset MAX_ID=GET_REOURCE.MAX_ID+1>
		<cfelse>
			<cfset MAX_ID=1>
		</cfif>
		<cfquery name="ADD_PARTNER_RESOURCE" datasource="#dsn#">
			INSERT INTO
					COMPANY_PARTNER_RESOURCE
				(
					RESOURCE_ID,
					RESOURCE,
					DETAIL,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP
				)
			VALUES
				(
					#MAX_ID#,
					'#FORM.partner_resource#',
					<cfif len(form.DETAIL)>'#form.DETAIL#',<cfelse>NULL,</cfif>
					#SESSION.EP.USERID#,
					#NOW()#,
					'#CGI.REMOTE_ADDR#'
				)
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_add_partner_resorce&resource_id=#MAX_ID#" addtoken="no">
