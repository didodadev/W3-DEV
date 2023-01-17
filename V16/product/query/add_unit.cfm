<cfquery name="get_unit" datasource="#dsn#">
	SELECT UNIT FROM SETUP_UNIT WHERE UNIT=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.UNIT)#">
</cfquery>
<cfif get_unit.recordcount>
	<script type="text/javascript">
        alert("<cf_get_lang_main no='1922.Birim Adını Kontrol Ediniz'>!");
       history.back();
    </script>
    <cfabort>
</cfif>
<cfquery name="ADD_UNIT" datasource="#DSN#">
	INSERT INTO
		SETUP_UNIT 
		(
			UNIT,
            UNIT_CODE,
            UNECE_NAME,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		)
		VALUES
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.UNIT#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#listlast(attributes.unit_code,',')#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#listfirst(attributes.unit_code,',')#">,
			#NOW()#,
			#SESSION.EP.USERID#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
		)
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
