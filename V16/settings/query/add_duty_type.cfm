<cfquery name="ADD_DUTY_TYPE" datasource="#DSN#">
	INSERT INTO
		SETUP_DUTY_TYPE
	(
		DUTY_TYPE,
		IS_ACTIVE,
		IS_TARGET,
		IS_VALUE,
		IS_CATEGORY,
		CUSTOMER_TYPE_ID,
		DUTY_UNIT_CAT_ID,
		COST_ID,
		COST_AMOUNT,
		CALCULATE_METHOD,
		CALCULATE_AMOUNT,
		COST_CALCULATE_ID,
		DUTY_AMOUNT,
		DETAIL,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	 ) 
	 VALUES 
	 (
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.duty_type#">,
		<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
		#attributes.is_target#,
		#attributes.is_value#,
		#attributes.is_category#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value=",#attributes.customer_type#,">,
		#attributes.duty_unit_cat#,
		<cfif attributes.cost_id eq 0>
			#attributes.cost_id#,
			#attributes.cost_amount#,
			NULL,
			NULL,
			1,
			#attributes.cost_amount#,
		<cfelse>
			#attributes.cost_id#,
			NULL,
			#attributes.calculate_method#,
			<cfif attributes.calculate_method eq 3>#attributes.calculate_amount#<cfelse>NULL</cfif>,
			<cfif attributes.calculate_method eq 1>2<cfelseif attributes.calculate_method eq 2>3<cfelseif attributes.calculate_method eq 3>4</cfif>,
			<cfif attributes.calculate_method eq 3>#attributes.calculate_amount#<cfelse>NULL</cfif>,
		</cfif>
		<cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		#now()#,
		#session.ep.userid#
	 )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_duty_type" addtoken="no">
