<cfquery name="add_remote_plan" datasource="#dsn#">
	INSERT INTO
		REMOTE_WORKING_DAY
		(
            EMPLOYEE_ID,
            PERIOD_YEAR,
            M1,
            M2,
            M3,
            M4,
            M5,
            M6,
            M7,
            M8,
            M9,
            M10,
            M11,
            M12,
            RECORD_IP,
            RECORD_DATE,
            RECORD_EMP,
            IN_OUT_ID
		)
	VALUES
    (
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SAL_YEAR#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M1#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M2#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M3#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M4#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M5#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M6#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M7#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M8#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M9#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M10#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M11#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M12#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.IN_OUT_ID#">
    )
</cfquery>

<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		location.reload();
	</cfif>
</script>