<cfquery name="ADD_SHIP_METHOD" datasource="#DSN#">
	INSERT INTO 
		SHIP_METHOD
	(
		SHIP_METHOD,
		CALCULATE,
		SHIP_HOUR,
		SHIP_DAY, 
		<!--- BK kaldirdi 04042006 90 gune siline
		COMP_ID,
		IS_TYPE, 
		UNIT_VALUE,
		UNIT_VALUE_CURRENCY,--->
		IS_OPPOSITE,
		IS_INTERNET,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	) 
	VALUES 
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_method#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.calculate#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_hour#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_day#">,
		<!---<cfif len(attributes.comp_id)>#attributes.comp_id#<cfelse>NULL</cfif>,
		 <cfif isdefined("attributes.is_type") and len(attributes.is_type)>#attributes.is_type#<cfelse>NULL</cfif>, 
		<cfif len(attributes.unit_value)>#attributes.unit_value#<cfelse>0</cfif>,
		<cfif len(attributes.money_type)>'#attributes.money_type#'<cfelse>0</cfif>,--->
		<cfif isdefined("attributes.is_opposite")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
		#now()#,
		#session.ep.userid#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_ship_method" addtoken="no">
