<cfquery name="ADD_COMMENT" datasource="#dsn#">
	INSERT INTO 
		TRAINING_NOTES
			(
				<cfif isdefined("attributes.training_id")>TRAINING_ID,</cfif>
				<cfif isdefined("attributes.class_id")>CLASS_ID,</cfif>
				NOTE_HEAD,
				NOTE_DETAIL,
				<cfif isdefined('session.ep')>
				EMPLOYEE_ID,
				<cfelseif isdefined('session.pp')>
				PARTNER_ID,
				</cfif>
				RECORD_DATE,
				RECORD_IP
			)
		VALUES
			(
				<cfif isdefined("attributes.training_id")>#attributes.TRAINING_ID#,</cfif>
				<cfif isdefined("attributes.class_id")>#attributes.CLASS_ID#,</cfif>
				'#attributes.NOTE_HEAD#',
				'#attributes.NOTE_DETAIL#',		
				<cfif isdefined('session.ep')>
				#session.ep.userid#,
				<cfelseif isdefined('session.pp')>
				#session.pp.userid#,
				</cfif>						
				#NOW()#,
				'#CGI.REMOTE_ADDR#'
			)
</cfquery>		
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
