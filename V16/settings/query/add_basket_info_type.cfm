<cfquery name="ADD_PUNISHMENT_TYPE" datasource="#dsn3#"> 
	INSERT INTO 
		SETUP_BASKET_INFO_TYPES
		(
			BASKET_INFO_TYPE,
			OPTION_NUMBER,
            BASKET_DETAIL,
			BASKET_ID,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		) 
		VALUES 
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.extra_info_type#">,
			<cfif isDefined("attributes.option_number") and Len(attributes.option_number)>#attributes.option_number#<cfelse></cfif>,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_detail#">,
			<cfif len(attributes.basket_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_id#"><cfelse>NULL</cfif>,
			#now()#,
			#session.ep.userid#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_basket_info_type" addtoken="no">
