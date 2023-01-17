<cfquery name="UPDATE_STAGES" datasource="#dsn#">
	UPDATE 
		SETUP_MEMBERSHIP_STAGES
	SET 
		TR_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tr_name#">, 
	  	TR_DETAIL = <cfif len(attributes.tr_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tr_detail#">,<cfelse>NULL,</cfif>
	  	UPDATE_DATE = #now()#,
	  	UPDATE_EMP = #session.ep.userid#,
	  	UPDATE_IP = '#cgi.REMOTE_ADDR#'
	WHERE 
		TR_ID=#attributes.tr_id#
</cfquery>
<script type="text/javascript">
	window.location='<cfoutput>#request.self#?fuseaction=crm.list_membership_stages</cfoutput>';
</script>
