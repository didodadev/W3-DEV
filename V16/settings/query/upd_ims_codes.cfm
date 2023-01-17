
<cfquery name="UPDATE_IMS_CODE" datasource="#DSN#">
	UPDATE 
		SETUP_IMS_CODE
	SET 
		IMS_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ims_code#">,
		IMS_CODE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ims_name#">,
		IMS_CODE_501 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ims_code_501#">,
		IMS_CODE_501_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ims_name_501#">,
		IMS_CODE_DESC = <cfif len(attributes.ims_desc)><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(attributes.ims_desc,250)#"><cfelse>null</cfif>,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,    
        UPDATE_EMP= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
	WHERE 
		IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_id#">
</cfquery>

<script type="text/javascript">
	<cfif isDefined("attributes.modal_id") and len(attributes.modal_id)>
		location.href = document.referrer;
	<cfelse>
		wrk_opener_reload();
		self.close();
	</cfif>
</script>

