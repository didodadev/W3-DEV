<cfquery name="UPD_RELATION" datasource="#dsn#">
	UPDATE
		OUR_COMPANY_POS_RELATION
	SET
		OUR_COMPANY_ID = #attributes.our_company#,
		POS_TYPE = #attributes.pos_type#,
		POS_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.pos_name#">,
		USER_NAME = <cfif len(attributes.user_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.user_name#"><cfelse>NULL</cfif>,
		PASSWORD = <cfif len(attributes.user_password)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.user_password#"><cfelse>NULL</cfif>,
		BANK_HOST = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.host#">,
		BANK_HOST_3D = <cfif len(attributes.host_3d)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.host_3d#"><cfelse>NULL</cfif>,
		CLIENT_ID = <cfif len(attributes.client_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.client_id#"><cfelse>NULL</cfif>,
		TERMINAL_NO = <cfif len(attributes.terminal_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.terminal_no#"><cfelse>NULL</cfif>,
		STORE_KEY = <cfif len(attributes.store_key)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.store_key#"><cfelse>NULL</cfif>,
		SSL_IP = <cfif len(attributes.ssl_ip)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ssl_ip#"><cfelse>NULL</cfif>,
		IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
		IS_SECURE = <cfif isdefined("attributes.is_secure")>1<cfelse>0</cfif>,
        DETAIL=<cfif isdefined("attributes.detail")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"></cfif>,
		UPDATE_DATE=#NOW()#,
		UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
		UPDATE_EMP=#SESSION.EP.USERID#		
	WHERE
		POS_ID = #attributes.pos_id#
</cfquery>
<script type="text/javascript">
	history.back();
	wrk_opener_reload();
</script>
