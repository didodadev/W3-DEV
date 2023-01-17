<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
	<cf_wrk_get_history  datasource= "#dsn#" source_table="SETUP_HEADQUARTERS" target_table= "SETUP_HEADQ_HISTORY" record_id= "#attributes.head_id#" record_name="HEADQUARTERS_ID">
	<cfquery name="ADD_ASSET" datasource="#DSN#">
		UPDATE 
			SETUP_HEADQUARTERS
		SET
			IS_ORGANIZATION = <cfif isdefined("attributes.is_organization")>1<cfelse>0</cfif>,
			UPPER_HEADQUARTERS_ID = <cfif len(attributes.upper_headquarters_id) and len(attributes.upper_headquarters_name)>#attributes.upper_headquarters_id#<cfelse>NULL</cfif>,
			NAME=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.NAME#">,
			HIERARCHY=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.HIERARCHY#">,
			HEADQUARTERS_DETAIL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#	 
		WHERE
			HEADQUARTERS_ID=#attributes.head_id#
	</cfquery>
	<cf_add_log  log_type="0" action_id="#attributes.head_id#" action_name="#attributes.head# ">
	</cftransaction>
</cflock>
<cfif isdefined("attributes.callAjax") and attributes.callAjax eq 1><!--- Organizasyon Yönetimi sayfasından geldiyse 20190912ERU --->
	<script>
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_headquarters&event=upd&head_id=<cfoutput>#attributes.head_id#&hr=1</cfoutput>','ajax_right');
	</script>
<cfelseif isdefined("attributes.hr")>
	<script type="text/javascript">
			window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_headquarters&event=upd&head_id=<cfoutput>#attributes.head_id#&hr=1</cfoutput>';
	</script>
<cfelse>
	<script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=settings.list_headquarters&event=upd&head_id=<cfoutput>#attributes.head_id#</cfoutput>';
	</script>
</cfif>