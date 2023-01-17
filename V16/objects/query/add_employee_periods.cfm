<cfif isDefined('attributes.periods')>
	<cfset APERIODS=ListToArray(attributes.periods)>
	<cfset emp_pos_ids = "">
	<cfset emp_emp_ids = "">
    <cfif isdefined('attributes.auth_emps_pos') and len(attributes.auth_emps_pos) and isdefined('attributes.auth_emps_id') and len(attributes.auth_emps_id)>
    	<cfset emp_pos_ids = attributes.auth_emps_pos>
    	<cfset emp_emp_ids = attributes.auth_emps_id>
    <cfelse>
    	<cfset emp_pos_ids = listappend(emp_pos_ids,attributes.position_id,',')>
    	<cfset emp_emp_ids = listAppend(emp_emp_ids,attributes.employee_id,',')>
    </cfif>
	<cfquery name="DEL_CONSUMER_PERIODS" datasource="#DSN#">
		DELETE FROM
			EMPLOYEE_POSITION_PERIODS
		WHERE
			POSITION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_pos_ids#">)
	</cfquery>
	<cfif isDefined('attributes.period_default') and len(attributes.period_default)>
		<cfquery name="UPD_CONSUMER_PERIODS_DEFAULT" datasource="#DSN#">
			UPDATE
				EMPLOYEE_POSITIONS
			SET
				PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_default#">
			WHERE
				POSITION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_pos_ids#">)
		</cfquery>
	</cfif>
	<cfloop from="1" to="#ArrayLen(APERIODS)#" index="i">
		<cfset attributes.period_date="">
		<cfset attributes.budget_period_date="">
		<cfset attributes.proc_date="">
		<cfif len(evaluate("attributes.ACTION_DATE#APERIODS[i]#")) and isdate(evaluate("attributes.ACTION_DATE#APERIODS[i]#"))>
			<cfset attributes.period_date=evaluate("attributes.ACTION_DATE#APERIODS[i]#")>
			<cf_date tarih='attributes.period_date'>
		</cfif>
		<cfif len(evaluate("attributes.budget_ACTION_DATE#APERIODS[i]#")) and isdate(evaluate("attributes.budget_ACTION_DATE#APERIODS[i]#"))>
			<cfset attributes.budget_period_date=evaluate("attributes.budget_ACTION_DATE#APERIODS[i]#")>
			<cf_date tarih='attributes.budget_period_date'>
		</cfif>
		<cfquery name="ADD_COMPANY_PERIODS" datasource="#DSN#">
			<cfloop list="#emp_pos_ids#" index="pos_id">
				INSERT INTO
					EMPLOYEE_POSITION_PERIODS
				(
					POSITION_ID,
					PERIOD_ID,
					<cfif len(attributes.period_date)>PERIOD_DATE,</cfif>
					<cfif len(attributes.budget_period_date)>BUDGET_PERIOD_DATE,</cfif>
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#pos_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#APERIODS[i]#">,
					<cfif len(attributes.period_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.period_date#">,</cfif>
					<cfif len(attributes.budget_period_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.budget_period_date#">,</cfif>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
				)
			</cfloop>
		</cfquery>
	</cfloop>
	<cfquery name="del_wrk_app" datasource="#dsn#">
		DELETE FROM WRK_SESSION WHERE USERID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_emp_ids#">) AND USER_TYPE = 0
	</cfquery>
	<cfif not isdefined("attributes.draggable")>
		<cfif isdefined("attributes.is_hr")>
			<cfif not isdefined("attributes.page_type")><cfset attributes.page_type = 1></cfif>
			<cflocation url="#request.self#?fuseaction=objects.popup_list_positions_poweruser&page_type=#attributes.page_type#&employee_id=#attributes.employee_id#&position_id=#attributes.position_id#" addtoken="no">
		<cfelse>
			<script type="text/javascript">
				wrk_opener_reload();
				window.close();
			</script>
		</cfif>
	<cfelse>
		<script type="text/javascript">
			closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
			location.reload();
		</script>
	</cfif>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='63208.Muhasebe Dönemi Seçmeden Kayıt Yapamazsınız!'>");
		history.back();
	</script>
</cfif>

