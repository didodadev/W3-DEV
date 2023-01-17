<!--- <cfquery name="get_banks" datasource="#DSN#">
	SELECT 
		BANK_ID 
	FROM 
		OUR_COMPANY_POS_RELATION 
	WHERE 
		BANK_ID = #attributes.bank_id# AND 
		OUR_COMPANY_ID = #attributes.our_company#
</cfquery>
<cfif get_banks.recordcount>
	<script type="text/javascript">
		alert("Banka daha önceden bu şirket için pos hesabı açmıştır.");
		history.back();
	</script>
	<cfabort>
</cfif> --->
<cfquery name="ADD_RELATION" datasource="#DSN#">
	INSERT INTO
		OUR_COMPANY_POS_RELATION
		(
			OUR_COMPANY_ID,
			POS_TYPE,
			POS_NAME,
			USER_NAME,
			PASSWORD,
			BANK_HOST,
			BANK_HOST_3D,
			CLIENT_ID,
			TERMINAL_NO,
			STORE_KEY,
			SSL_IP,
			IS_ACTIVE,
			IS_SECURE,
            DETAIL,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		)
		VALUES
		(
			#attributes.our_company#,
			#attributes.pos_type#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.pos_name#">,
			<cfif len(attributes.user_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.user_name#"><cfelse>NULL</cfif>,
			<cfif len(attributes.user_password)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.user_password#"><cfelse>NULL</cfif>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.host#">,
			<cfif len(attributes.host_3d)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.host_3d#"><cfelse>NULL</cfif>,
			<cfif len(attributes.client_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.client_id#"><cfelse>NULL</cfif>,
			<cfif len(attributes.terminal_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.terminal_no#"><cfelse>NULL</cfif>,
			<cfif len(attributes.store_key)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.store_key#"><cfelse>NULL</cfif>,
			<cfif len(attributes.ssl_ip)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ssl_ip#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.is_secure")>1<cfelse>0</cfif>,
            <cfif isdefined("attributes.detail")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"></cfif>,
			#session.ep.userid#,
			#now()#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
		)
</cfquery>
<script type="text/javascript">
	history.back();
	wrk_opener_reload();
</script>
