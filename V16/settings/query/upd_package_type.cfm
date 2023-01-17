<!--- Desi hesabi yapiliyor BK 20090120 --->
<cfif attributes.calculate_type eq 1>
	<cfset temp_desi = (attributes.dimension1 * attributes.dimension2 *attributes.dimension3)/3000>
<cfelse>
	<cfset temp_desi = ''>
</cfif>

<cfquery name="UPD_PACKAGE_TYPE" datasource="#DSN#">
	UPDATE 
		SETUP_PACKAGE_TYPE
	SET 
		PACKAGE_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.package_type#">,
		CALCULATE_TYPE_ID = #attributes.calculate_type#,
		DETAIL = <cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
		DIMENTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.dimension#">,
		DESI_VALUE = <cfif len(temp_desi)>#temp_desi#<cfelse>NULL</cfif>,
        WEIGHT = <cfif len(attributes.weight)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.weight#"><cfelse>NULL</cfif>,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE 
		PACKAGE_TYPE_ID = #attributes.package_type_id#
</cfquery>
<script>
	location.href=document.referrer;
</script>
