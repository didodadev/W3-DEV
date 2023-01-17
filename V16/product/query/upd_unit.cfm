<cfquery name="get_unit" datasource="#dsn#">
	SELECT UNIT_ID,UNIT FROM SETUP_UNIT WHERE UNIT=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.unit)#"> AND UNIT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#">
</cfquery>
<cfif get_unit.recordcount>
	<script type="text/javascript">
       alert("<cf_get_lang_main no='1922.Birim Adını Kontrol Ediniz'>!");
       history.back();
    </script>
    <cfabort>
</cfif>
<cfquery name="upd_unit" datasource="#dsn#">
	UPDATE 
		SETUP_UNIT 
	SET 
		UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#unit#">,
        UNIT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listlast(attributes.unit_code,',')#">,
        UNECE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listfirst(attributes.unit_code,',')#">,
		UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	WHERE 
		UNIT_ID = #unit_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
