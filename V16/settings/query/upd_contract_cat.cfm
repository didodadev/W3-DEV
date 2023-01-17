<cfquery name="UPD_CONTRACT_CAT" datasource="#dsn3#">
	UPDATE 
		CONTRACT_CAT
	SET 
		CONTRACT_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CONTRACT_CAT#">,
		RECORD_EMP = #SESSION.EP.USERID#,
		RECORD_DATE = #NOW()#,
		RECORD_IP = '#CGI.REMOTE_ADDR#'
	WHERE 
		CONTRACT_CAT_ID = #CONTRACT_CAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_contract_cat" addtoken="no">
