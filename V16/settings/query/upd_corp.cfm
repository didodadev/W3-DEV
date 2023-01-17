<cfquery name="UPDATE_CORP" datasource="#dsn#">
	UPDATE 
		SETUP_CORPORATIONS
	SET 
		CORPORATION_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.corp_code#">,
		CORPORATION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.corp_name#">,
		CORPORATION_DETAIL= <cfif len(attributes.corp_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.corp_detail#"><cfelse>NULL</cfif>,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE 
		CORPORATION_ID  =#attributes.c_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	self.close();
</script>

