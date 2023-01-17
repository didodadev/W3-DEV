<cfquery name="UPD_CAMP_CAT" datasource="#dsn#">
	UPDATE 
		ASSET_P_SUB_CAT 
	SET 
		ASSETP_SUB_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#assetp_sub_cat#">,
		ASSETP_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_cat#">,
		ASSETP_DETAIL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.assetp_detail#">,
        UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.rempte_addr#">
	WHERE 
		ASSETP_SUB_CATID = #attributes.sub_cat#
</cfquery>
<script>
	location.href = document.referrer;
</script>
