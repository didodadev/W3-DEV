<cfquery name="ADD_ITASSET" datasource="#dsn#">
	INSERT 
		INTO
		ASSET_P_IT
		(
			ASSETP_ID,
			IT_PRO,
			IT_MEMORY,
			IT_HDD,
			IT_CON,
			IT_PROPERTY1,
			IT_PROPERTY2,
			IT_PROPERTY3,
			IT_PROPERTY4,
			IT_PROPERTY5,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE,
			ASSET_IP,
			ASSET_MAC_IP,
			USERNAME,
			PASSWORD,
			NUMBER_OF_USERS
		)
		VALUES
		(
			#ASSETP_ID#,
			<cfif len(attributes.IT_PRO)>'#attributes.IT_PRO#',<cfelse>NULL,</cfif>
			<cfif len(attributes.IT_MEMORY)>'#attributes.IT_MEMORY#',<cfelse>NULL,</cfif>
			<cfif len(attributes.IT_HDD)>'#attributes.IT_HDD#',<cfelse>NULL,</cfif>
			<cfif len(attributes.IT_CON)>'#attributes.IT_CON#',<cfelse>NULL,</cfif>
			<cfif len(attributes.IT_PROPERTY1)>'#attributes.IT_PROPERTY1#',<cfelse>NULL,</cfif>
			<cfif len(attributes.IT_PROPERTY2)>'#attributes.IT_PROPERTY2#',<cfelse>NULL,</cfif>
			<cfif len(attributes.IT_PROPERTY3)>'#attributes.IT_PROPERTY3#',<cfelse>NULL,</cfif>
			<cfif len(attributes.IT_PROPERTY4)>'#attributes.IT_PROPERTY4#',<cfelse>NULL,</cfif>
			<cfif len(attributes.IT_PROPERTY4)>'#attributes.IT_PROPERTY5#',<cfelse>NULL,</cfif>
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#',
			#NOW()#,
			<cfif len(attributes.ASSET_IP)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ASSET_IP#"><cfelse>NULL</cfif>,
			<cfif len(attributes.ASSET_MAC_IP)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ASSET_MAC_IP#"><cfelse>NULL</cfif>,
			<cfif len(attributes.USERNAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.USERNAME#"><cfelse>NULL</cfif>,
			<cfif len(attributes.PASSWORD)><cfqueryparam cfsqltype="cf_sql_varchar" value="#contentEncryptingandDecodingAES(isEncode:1,content:attributes.password,accountKey:'wrk')#"><cfelse>NULL</cfif>,
			<cfif len(attributes.number_of_users)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.number_of_users#"><cfelse>NULL</cfif>
		)
</cfquery>
<cfabort>