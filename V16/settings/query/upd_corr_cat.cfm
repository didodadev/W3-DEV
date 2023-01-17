<cfset rm = '#chr(13)#'>
<cfset DETAIL = ReplaceList(DETAIL,rm,'')>
<cfset rm = '#chr(10)#'>
<cfset DETAIL = ReplaceList(DETAIL,rm,'')>
<cfquery name="UPDCORRCAT" datasource="#dsn#">
	UPDATE 
		SETUP_CORR 
	SET 
		CORRCAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CORRCAT#">,
		DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DETAIL#">,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
		UPDATE_DATE = #NOW()#
	WHERE 
		CORRCAT_ID=#CORRCAT_ID#
</cfquery>
<script>
	location.href=document.referrer;
</script>
