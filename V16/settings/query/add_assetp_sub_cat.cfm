<cfquery name="UPD_CAMP_CAT" datasource="#dsn#">
	INSERT INTO 
		ASSET_P_SUB_CAT 
	(
		ASSETP_SUB_CAT,
		ASSETP_CATID,
		ASSETP_DETAIL,
        RECORD_EMP, 
		RECORD_DATE,
		RECORD_IP 
    )
	VALUES
    (
	    <cfqueryparam cfsqltype="cf_sql_varchar" value="#assetp_sub_cat#">,
	    <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_cat#">,
		<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.assetp_detail#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.rempte_addr#">
    )
    SELECT @@IDENTITY AS MAX_SUB_CAT
</cfquery>
<script>
	location.href = document.referrer;
</script>
