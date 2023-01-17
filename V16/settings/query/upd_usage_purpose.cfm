<cfquery name="UPD_USAGE_PURPOSE" datasource="#DSN#">
	UPDATE 
		SETUP_USAGE_PURPOSE
	SET
		USAGE_PURPOSE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.usage_purpose#">,
		DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
		ASSETP_RESERVE = <cfif isdefined("attributes.assetp_reserve")>1<cfelse>0</cfif>,
		IT_ASSET = <cfif isdefined("attributes.it_asset")>1<cfelse>0</cfif>,
		MOTORIZED_VEHICLE = <cfif isdefined("attributes.motorized_vehicle")>1<cfelse>0</cfif>,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
	WHERE 
		USAGE_PURPOSE_ID = #attributes.usage_purpose_id#	 
</cfquery>
<script>
	location.href= document.referrer;
</script>