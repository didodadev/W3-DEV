	<cfquery name="upd_salary_plan" datasource="#dsn#">
		UPDATE 
			REMOTE_WORKING_DAY
		SET
			M1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M1#">,
			M2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M2#">,
			M3 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M3#">,
			M4 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M4#">,
			M5 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M5#">,
			M6 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M6#">,
			M7 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M7#">,
			M8 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M8#">,
			M9 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M9#">,
			M10 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M10#">,
			M11 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M11#">,
			M12 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.M12#">,
			PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SAL_YEAR#">,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
			UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
			UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
		WHERE
			REMOTE_DAY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.REMOTE_DAY_ID#">
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