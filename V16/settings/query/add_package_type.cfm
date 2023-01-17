<!--- Desi hesabi yapiliyor BK 20090120 --->
<cfif attributes.calculate_type eq 1>
	<cfset temp_desi = (attributes.dimension1 * attributes.dimension2 *attributes.dimension3)/3000>
<cfelse>
	<cfset temp_desi = ''>
</cfif>
<cfquery name="INS_PACKAGE_TYPE" datasource="#DSN#">
	INSERT INTO 
		SETUP_PACKAGE_TYPE
	(
		PACKAGE_TYPE,
		CALCULATE_TYPE_ID,
		DETAIL,
		DIMENTION,
		DESI_VALUE,
        WEIGHT,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	) 
	VALUES 
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.package_type#">,
		#attributes.calculate_type#,			
		<cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.dimension#">,
		<cfif len(temp_desi)>#temp_desi#<cfelse>NULL</cfif>,
        <cfif len(attributes.weight)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.weight#"><cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		#now()#,
		#session.ep.userid#
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_package_type" addtoken="no">
