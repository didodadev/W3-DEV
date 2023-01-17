<cfquery name="UPD_SERVICE_CODE" datasource="#dsn3#">
	UPDATE 
		SETUP_SERVICE_CODE
	SET
		SERVICE_CODE = '#attributes.service_code#',
		SERVICE_CODE_DETAIL = '#attributes.detail#',
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
        <cfif isdefined("attributes.cat_id") and len(attributes.cat_id)>,PRODUCT_CAT = #attributes.cat_id#</cfif>
	WHERE
		SERVICE_CODE_ID = #attributes.service_code_id#	
</cfquery>
<script>
	location.href = document.referrer;
</script>