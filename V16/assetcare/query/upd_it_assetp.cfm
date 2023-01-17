<cfquery name="UPD_ITASSET" datasource="#dsn#">
	UPDATE
		ASSET_P_IT
	SET
		ASSETP_ID = #attributes.assetp_id#,
		<cfif len(attributes.IT_PRO)>IT_PRO = '#attributes.IT_PRO#',</cfif>
		IT_MEMORY = '#attributes.IT_MEMORY#',
		IT_HDD = '#attributes.IT_HDD#', 
		IT_CON = '#attributes.IT_CON#',
		IT_PROPERTY1 = '#attributes.IT_PROPERTY1#', 
		IT_PROPERTY2 = '#attributes.IT_PROPERTY2#',
		IT_PROPERTY3 = '#attributes.IT_PROPERTY3#',
		IT_PROPERTY4 = '#attributes.IT_PROPERTY4#',
		IT_PROPERTY5 = '#attributes.IT_PROPERTY5#',
		UPD_EMP = #SESSION.EP.USERID#,
		UPD_IP = '#CGI.REMOTE_ADDR#',
		UPD_DATE = #NOW()#,
		ASSET_IP= <cfif len(attributes.ASSET_IP)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ASSET_IP#"><cfelse>NULL</cfif>,
		ASSET_MAC_IP= <cfif len(attributes.ASSET_MAC_IP)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ASSET_MAC_IP#"><cfelse>NULL</cfif>,
		<cfif isDefined('attributes.username') and len(attributes.username)>USERNAME= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.username#">,</cfif>
		<cfif isDefined('attributes.password') and len(attributes.password)>PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#contentEncryptingandDecodingAES(isEncode:1,content:attributes.password,accountKey:'wrk')#">,</cfif>
		NUMBER_OF_USERS=<cfif len(attributes.number_of_users)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.number_of_users#"><cfelse>NULL</cfif>
	WHERE  
		ASSETP_ID = #ASSETP_ID#
</cfquery>
<cfabort>