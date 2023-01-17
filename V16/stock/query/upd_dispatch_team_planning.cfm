<!--- Sevkiyat Ekip Planlama --->
<cfif len(attributes.planning_date)><cf_date tarih = "attributes.planning_date"></cfif>
<cfif len(attributes.assetp_km_finishdate)><cf_date tarih = "attributes.assetp_km_finishdate"></cfif>
<cfif len(attributes.assetp_name) and len(attributes.team_zones)>
	<cfset attributes.team_code = '#attributes.assetp_name# - #attributes.team_zones#'>
<cfelse>
	<cfset attributes.team_code = ''>
</cfif>
<!--- İliskili uyeler --->
<cfset list_comp = ''>
<cfset list_cons = ''>
<cfif isdefined("attributes.record_num_team") and attributes.record_num_team gt 0>
	<cfloop from="1" to="#attributes.record_num_team#" index="r">
		<cfif evaluate("attributes.row_kontrol_team#r#") eq 1>
			<cfif len(evaluate('attributes.rel_comp_id#r#'))>
				<cfset list_comp = listappend(list_comp,evaluate('attributes.rel_comp_id#r#'),',')>
			</cfif>
			<cfif len(evaluate('attributes.rel_cons_id#r#'))>
				<cfset list_cons = listappend(list_cons,evaluate('attributes.rel_cons_id#r#'),',')>
			</cfif>
		</cfif>
	</cfloop>
</cfif>

<cfquery name="add_dispatch_team_planning" datasource="#dsn3#">
	UPDATE
		DISPATCH_TEAM_PLANNING
	SET
		PLANNING_DATE = <cfif len(attributes.planning_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.planning_date#"><cfelse>NULL</cfif>,
		TEAM_CODE = <cfif len(attributes.team_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.team_code#"><cfelse>NULL</cfif>,
		TEAM_ZONES = <cfif len(attributes.team_zones)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.team_zones#"><cfelse>NULL</cfif>,
		ASSETP_ID = <cfif len(attributes.assetp_id) and len(attributes.assetp_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#"><cfelse>NULL</cfif>,
		ASSETP_KM_START = <cfif len(attributes.assetp_km_start)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.assetp_km_start#"><cfelse>NULL</cfif>,
		ASSETP_KM_STARTDATE = <cfif len(attributes.assetp_km_startdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.assetp_km_startdate#"><cfelse>NULL</cfif>,
		ASSETP_KM_FINISH = <cfif len(attributes.assetp_km_finish)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.assetp_km_finish#"><cfelse>NULL</cfif>,
		ASSETP_KM_FINISHDATE = <cfif len(attributes.assetp_km_finishdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.assetp_km_finishdate#"><cfelse>NULL</cfif>,
		IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
		PROCESS_STAGE = #attributes.process_stage#,
		DETAIL = <cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
		RELATION_COMP_ID = <cfif len(list_comp)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#list_comp#,"><cfelse>NULL</cfif>,
		RELATION_CONS_ID = <cfif len(list_cons)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#list_cons#,"><cfelse>NULL</cfif>,
		UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	WHERE
		PLANNING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.planning_id#">
</cfquery>
<cfif len(attributes.assetp_id) and len(attributes.assetp_name) and len(attributes.assetp_km_finish)>
	<cfquery name="get_assetp_km_control" datasource="#dsn#">
		SELECT DISPATCH_PLANNING_ID FROM ASSET_P_KM_CONTROL WHERE DISPATCH_PLANNING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.planning_id#">
	</cfquery>
	<cfif get_assetp_km_control.recordcount>
		<cfquery name="upd_assetp_km_control" datasource="#dsn#">
			UPDATE
				ASSET_P_KM_CONTROL
			SET
				KM_START = <cfif len(attributes.assetp_km_start)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.assetp_km_start#"><cfelse>NULL</cfif>,
				START_DATE = <cfif len(attributes.assetp_km_startdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.assetp_km_startdate#"><cfelse>NULL</cfif>,
				KM_FINISH = <cfif len(attributes.assetp_km_finish)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.assetp_km_finish#"><cfelse>NULL</cfif>,
				FINISH_DATE = <cfif len(attributes.assetp_km_finishdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.assetp_km_finishdate#"><cfelse>NULL</cfif>,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			WHERE
				ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#"> AND
				DISPATCH_PLANNING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.planning_id#">
		</cfquery>
	<cfelse>
		<cfquery name="get_assetp_info" datasource="#dsn#">
			SELECT (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = ASSET_P.POSITION_CODE AND IS_MASTER = 1) EMPLOYEE_ID, DEPARTMENT_ID,FIRST_KM_DATE,FIRST_KM  FROM ASSET_P WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
		</cfquery>
		<cfquery name="add_assetp_km_control" datasource="#dsn#">
			INSERT INTO
				ASSET_P_KM_CONTROL
			(
				DISPATCH_PLANNING_ID,
				ASSETP_ID,
				DEPARTMENT_ID,
				EMPLOYEE_ID,
				KM_START,
				START_DATE,
				KM_FINISH,
				FINISH_DATE,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.planning_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">,
				<cfif len(get_assetp_info.department_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp_info.department_id#"><cfelse>NULL</cfif>,
				<cfif len(get_assetp_info.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp_info.employee_id#"><cfelse>NULL</cfif>,
				<cfif len(attributes.assetp_km_start)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.assetp_km_start#"><cfelseif Len(get_assetp_info.first_km)><cfqueryparam cfsqltype="cf_sql_float" value="#get_assetp_info.first_km#"><cfelse>NULL</cfif>,
				<cfif len(attributes.assetp_km_startdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.assetp_km_startdate#"><cfelseif Len(get_assetp_info.first_km_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_assetp_info.first_km_date#"><cfelse>NULL</cfif>,
				<cfif len(attributes.assetp_km_finish)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.assetp_km_finish#"><cfelse>NULL</cfif>,
				<cfif len(attributes.assetp_km_finishdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.assetp_km_finishdate#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			)
		</cfquery>
	</cfif>
</cfif>
<cfif isdefined("attributes.record_num") and attributes.record_num gt 0>
	<cfquery name="del_dispatch_team_planning_row" datasource="#dsn3#">
		DELETE FROM DISPATCH_TEAM_PLANNING_ROW WHERE PLANNING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.planning_id#">
	</cfquery>
	<cfloop from="1" to="#attributes.record_num#" index="r">
		<cfif evaluate("attributes.row_kontrol#r#") eq 1>
			<cfquery name="add_dispatch_team_planning_row#r#" datasource="#dsn3#">
				INSERT INTO
					DISPATCH_TEAM_PLANNING_ROW
				(
					PLANNING_ID,
					TEAM_EMPLOYEE_ID,
					OVERTIME_PAY,
					FOOD_PAY,
					SUNDAY_OVERTIME_PAY
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.planning_id#">,
					<cfif len(evaluate("attributes.team_employee_id#r#"))>#evaluate("attributes.team_employee_id#r#")#<cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.overtime_pay#r#"))>#evaluate("attributes.overtime_pay#r#")#<cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.food_pay#r#"))>#evaluate("attributes.food_pay#r#")#<cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.sunday_overtime_pay#r#"))>#evaluate("attributes.sunday_overtime_pay#r#")#<cfelse>NULL</cfif>
				)
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
<script type="text/javascript">
	opener.window.location.reload();
	window.close();
</script>
