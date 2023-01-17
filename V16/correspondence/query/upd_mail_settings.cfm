<cfif isDefined("attributes.password") and Len(attributes.password)>
	<cfset pass = Encrypt(attributes.password,attributes.employee_id)>
<cfelse>	
	<cfset pass = "">
</cfif>
<cfif attributes.operation eq 'upd'>
	<cfquery name="upd_emp_mail" datasource="#DSN#">  
		UPDATE
			CUBE_MAIL
		SET
			EMAIL = '#attributes.EMAIL#',
			ACCOUNT = '#attributes.ACCOUNT#',
			ISACTIVE = <cfif isDefined("attributes.isactive")>1,<cfelse>0,</cfif>
			<cfif isDefined("attributes.password") and Len(attributes.password)>PASSWORD = '#pass#',</cfif>
			PRESENT_ISACTIVE= <cfif isDefined("attributes.present_isactive")>1,<cfelse>0,</cfif>
			POP = '#attributes.POP#',
			SMTP = '#attributes.SMTP#',
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_DATE=#now()#,
			UPDATE_IP='#cgi.remote_addr#',
			SMTP_PORT=<cfif len(attributes.smtp_port)>#attributes.smtp_port#,<cfelse>NULL,</cfif>
			POP_PORT=<cfif len(attributes.pop_port)>#attributes.pop_port#<cfelse>NULL</cfif>,
			PRIORITY = #attributes.priority#,
            TEMP_PRESENT_ISACTIVE = <cfif isDefined("attributes.temp_present_isactive")>1<cfelse>0</cfif>
		WHERE
			MAILBOX_ID = #attributes.mailbox_id#
	</cfquery>
<cfelseif attributes.operation eq 'del'>
	<cfquery name="ADD_EMP_MAIL" datasource="#DSN#">  
	  DELETE FROM
		CUBE_MAIL
	  WHERE
		MAILBOX_ID = #attributes.mailbox_id#	 
	</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=correspondence.list_mymails&employee_id=#attributes.employee_id#" addtoken="no"> 
