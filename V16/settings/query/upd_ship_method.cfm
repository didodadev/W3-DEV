<cfquery name="UPD_SHIP_METHOD" datasource="#DSN#">
	UPDATE 
		SHIP_METHOD 
	SET 
		SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_method#">,
		CALCULATE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.calculate#">,
		SHIP_DAY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_day#">,
		SHIP_HOUR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_hour#">,
		<!--- BK kaldirdi 04042006 90 gune siline
		COMP_ID = <cfif len(attributes.comp_id)>#attributes.comp_id#<cfelse>NULL</cfif>,
		IS_TYPE = <cfif isdefined("attributes.is_type") and len(attributes.is_type)>#attributes.is_type#<cfelse>NULL</cfif>,
		UNIT_VALUE = <cfif len(attributes.unit_value)>#attributes.unit_value#<cfelse>0</cfif>,
		UNIT_VALUE_CURRENCY = <cfif len(attributes.money_type)>'#attributes.money_type#'<cfelse>0</cfif>, --->
		IS_OPPOSITE = <cfif isdefined("attributes.is_opposite")>1<cfelse>0</cfif>,
		IS_INTERNET = <cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	WHERE
		SHIP_METHOD_ID = #attributes.ship_method_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_ship_method" addtoken="no">
