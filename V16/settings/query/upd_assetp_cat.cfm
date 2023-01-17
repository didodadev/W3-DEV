<cfquery name="UPD_ASSETP_CAT" datasource="#DSN#">
	UPDATE 
		ASSET_P_CAT 
	SET 
		ASSETP_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.assetp_cat#">,
		ASSETP_RESERVE = <cfif isdefined("attributes.assetp_reserve")>1<cfelse>0</cfif>,
		IT_ASSET = <cfif isdefined("attributes.it_asset")>1<cfelse>0</cfif>,
		MOTORIZED_VEHICLE = <cfif isdefined("attributes.motorized_vehicle")>1<cfelse>0</cfif>,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE 
		ASSETP_CATID = #ASSETP_CATID#
</cfquery>
<script>
	location.href = document.referrer;
</script>
