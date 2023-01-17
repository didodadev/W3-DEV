<cfset this_year = session.ep.period_year>
<cfset last_year = session.ep.period_year-1>
<cfset next_year = session.ep.period_year+1>
<cfscript>
	if (database_type is 'MSSQL') 
		{
		last_year_dsn2 = '#dsn#_#this_year-1#_#session.ep.company_id#';
		next_year_dsn2 = '#dsn#_#this_year+1#_#session.ep.company_id#';
		}
	else if (database_type is 'DB2') 
		{
		last_year_dsn2 = '#dsn#_#session.ep.company_id#_#this_year-1#';
		next_year_dsn2 = '#dsn#_#session.ep.company_id#_#this_year+1#';
		}	
</cfscript>
<cfquery name="get_periods" datasource="#dsn#">
	SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>
<cfquery name="control_last_year" dbtype="query" maxrows="1">
	SELECT PERIOD_YEAR FROM get_periods WHERE PERIOD_YEAR = #last_year#
</cfquery>
<cfif control_last_year.recordcount>
	<cfquery name="get_last_year_ship" datasource="#last_year_dsn2#" maxrows="1">
		SELECT DISTINCT
			S.SHIP_ID,
			S.SHIP_TYPE,
			S.SHIP_NUMBER,
			S.COMPANY_ID,
			S.CONSUMER_ID,
			S.SHIP_DATE
		FROM 
			SHIP S,
			SHIP_ROW SR
		WHERE 
			S.SHIP_ID = SR.SHIP_ID AND
			SR.SERVICE_ID = #ATTRIBUTES.SERVICE_ID#
	</cfquery>
	<cfif get_last_year_ship.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='335.Servis ile ilişkili irsaliye bulunduğu için servisi silemezsiniz'>! <cf_get_lang_main no ='1060.Dönem'> : <cfoutput>#last_year#</cfoutput> - <cf_get_lang_main no='726.İrsaliye No'>:<cfoutput>#get_last_year_ship.SHIP_NUMBER#</cfoutput>");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfquery name="get_new_ship" datasource="#dsn2#" maxrows="1">
	SELECT DISTINCT
		S.SHIP_ID,
		S.SHIP_TYPE,
		S.SHIP_NUMBER,
		S.COMPANY_ID,
		S.CONSUMER_ID,
		S.SHIP_DATE
	FROM 
		SHIP S,
		SHIP_ROW SR
	WHERE 
		S.SHIP_ID = SR.SHIP_ID AND
		SR.SERVICE_ID = #ATTRIBUTES.SERVICE_ID#
</cfquery>
<cfif get_new_ship.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='335.Servis ile ilişkili irsaliye bulunduğu için servisi silemezsiniz'>! <cf_get_lang_main no ='1060.Dönem'> : <cfoutput>#this_year#</cfoutput> - <cf_get_lang_main no='726.İrsaliye No'>:<cfoutput>#get_new_ship.SHIP_NUMBER#</cfoutput>");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="control_next_year" dbtype="query">
	SELECT PERIOD_YEAR FROM get_periods WHERE PERIOD_YEAR = #next_year#
</cfquery>
<cfif control_next_year.recordcount>
	<cfquery name="get_next_year_ship" datasource="#next_year_dsn2#" maxrows="1">
		SELECT DISTINCT
			S.SHIP_ID,
			S.SHIP_TYPE,
			S.SHIP_NUMBER,
			S.COMPANY_ID,
			S.CONSUMER_ID,
			S.SHIP_DATE 
		FROM 
			SHIP S,
			SHIP_ROW SR
		WHERE 
			S.SHIP_ID = SR.SHIP_ID AND
			SR.SERVICE_ID = #ATTRIBUTES.SERVICE_ID#
	</cfquery>
		<cfif get_next_year_ship.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang no ='335.Servis ile ilişkili irsaliye bulunduğu için servisi silemezsiniz'>! <cf_get_lang_main no ='1060.Dönem'>: <cfoutput>#next_year#</cfoutput> - <cf_get_lang_main no='726.İrsaliye No'>:<cfoutput>#get_next_year_ship.SHIP_NUMBER#</cfoutput>");
				history.back();
			</script>
			<cfabort>
		</cfif>
</cfif>
<cftransaction>
	<cfquery name="get_stage" datasource="#dsn3#">
		SELECT SERVICE_NO,SERVICE_STATUS_ID FROM SERVICE WHERE SERVICE_ID = #ATTRIBUTES.SERVICE_ID#
	</cfquery>
	<cfquery name="DEL_" datasource="#DSN3#">
		DELETE FROM SERVICE_HISTORY WHERE SERVICE_ID = #ATTRIBUTES.SERVICE_ID# 
	</cfquery>
	<cfquery name="DEL_" datasource="#DSN3#">
		DELETE FROM SERVICE_OPERATION WHERE SERVICE_ID = #ATTRIBUTES.SERVICE_ID#
	</cfquery>
	<cfquery name="DEL_" datasource="#DSN3#">
		DELETE FROM SERVICE_PLUS WHERE SERVICE_ID = #ATTRIBUTES.SERVICE_ID#
	</cfquery>
	<cfquery name="DEL_" datasource="#DSN3#">
		DELETE FROM SERVICE_REPLY WHERE SERVICE_ID = #ATTRIBUTES.SERVICE_ID#
	</cfquery>
	<cfquery name="DEL_" datasource="#DSN3#">
		DELETE FROM SERVICE WHERE SERVICE_ID = #ATTRIBUTES.SERVICE_ID#
	</cfquery>
	<cfquery name="DEL_" datasource="#dsn3#">
		DELETE FROM SERVICE_CODE_ROWS WHERE SERVICE_ID=#attributes.SERVICE_ID#
	</cfquery>
	<cf_add_log employee_id="#session.ep.userid#" log_type="-1" action_id="#attributes.service_id#" paper_no="#get_stage.service_no#" process_stage="#get_stage.SERVICE_STATUS_ID#" action_name="#attributes.service_head# " period_id="#session.ep.period_id#" data_source="#dsn3#">
</cftransaction>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=service.list_service</cfoutput>';
</script>

