<cfscript>
	if(isdefined("to_emp_ids")) j_EMPS = ListSort(to_emp_ids,"Numeric", "Desc") ; else j_EMPS = '';	
</cfscript>
<cf_date tarih='attributes.start_date'>
<cfset attributes.start_date = date_add("h",attributes.start_hour,attributes.start_date)>
<cfset attributes.start_date = date_add("n",attributes.start_min,attributes.start_date)>

<cfif len(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
	<cfset attributes.finish_date = date_add("h",attributes.finish_hour,attributes.finish_date)>
	<cfset attributes.finish_date = date_add("n",attributes.finish_min,attributes.finish_date)>
</cfif>

<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="get_resp" datasource="#dsn#">
			SELECT
				DEPARTMENT_ID,
				POSITION_CODE
			FROM
				ASSET_P
			WHERE 
				ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
		</cfquery>
		<cfquery name="get_emp_id" datasource="#dsn#">
			SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_resp.position_code#"> <!--- POSITION_ID --->
		</cfquery>   
		<cfquery name="get_km" datasource="#dsn#" maxrows="1">
			SELECT 
				KM_FINISH,
				FINISH_DATE,
				EMPLOYEE_ID,
				DEPARTMENT_ID
			FROM 
				ASSET_P_KM_CONTROL
			WHERE
				ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
			ORDER BY
				KM_FINISH DESC
		</cfquery>
		<cfif get_km.recordCount>
			<cfif not len(get_km.km_finish)>
				<cfset get_km.km_finish = 0>
			</cfif>
			<cfif not len(attributes.start_km)>
				<cfset attributes.start_km = 0>
			</cfif>
			<cfset start_km = evaluate("attributes.start_km")>
			<cfset km_finish = evaluate("get_km.km_finish")>
			<cfif len(get_km.finish_date)>
				<cfset get_km.finish_date = #createOdbcDateTime(get_km.finish_date)#>
			</cfif>
			<cfset record_date =#createOdbcDateTime(now())# >
			<!--- gönderilen başlangıç km değeri en son tahsis işlemindeki bitiş km değerinden büyük mü--->
			<cfif start_km gt km_finish>
				<cfquery name="ADD_RESIDUAL_KM" datasource="#dsn#" result="get_max_id">
				INSERT INTO 
					ASSET_P_KM_CONTROL
					(
						ASSETP_ID,
						DEPARTMENT_ID,
						EMPLOYEE_ID,
						KM_START,
						START_DATE,
						FINISH_DATE,
						IS_OFFTIME,
						IS_ALLOCATE,
						IS_RESIDUAL,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE
					) 
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">,
						<cfif len(get_resp.department_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_resp.department_id#"><cfelse> NULL</cfif>,
						<cfif len(get_emp_id.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_id.employee_id#"><cfelse> NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#start_km#">,
						<cfqueryparam  cfsqltype="cf_sql_date" value = "#attributes.start_date#">,
						<cfif len(attributes.finish_date)><cfqueryparam  cfsqltype="cf_sql_date" value = "#attributes.finish_date#"><cfelse> NULL</cfif>,
						<cfif isDefined("attributes.is_offtime")><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
						<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
						#session.ep.userid# ,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#record_date#">
					)
				</cfquery> 
			</cfif>
		</cfif>
		<cfquery name="ADD_KM" datasource="#dsn#" result="get_max_id"> 
			INSERT 
			INTO 
				ASSET_P_KM_CONTROL
				(
				ASSETP_ID,
				EMPLOYEE_ID,
				DEPARTMENT_ID,
				START_DATE,
				FINISH_DATE,
				KM_START,
				IS_OFFTIME,
				IS_ALLOCATE,
				ALLOCATE_DETAIL,
				ALLOCATE_REASON_ID,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				DESTINATION,
				ALLOCATE_NAME,
				PROJECT_ID,
				PROCESS_ROW_ID
				) 
			VALUES 
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">,
				<cfif len(attributes.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"><cfelse>NULL </cfif>,
				<cfif len(attributes.department_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"><cfelse>NULL </cfif>,
				<cfqueryparam  cfsqltype="cf_sql_date" value = "#attributes.start_date#">,
				<cfif len(attributes.finish_date)><cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#"><cfelse>NULL </cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.start_km#">,
				<cfif isDefined("attributes.is_offtime")><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse>NULL </cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
				<cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL </cfif>,
				<cfif isDefined("attributes.reason_id") and len(attributes.reason_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.reason_id#"><cfelse>NULL </cfif>,
				#session.ep.userid# ,
				<cfqueryparam cfsqltype="cf_sql_date" value="#record_date#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				<cfif isdefined("attributes.destination") and len(attributes.destination)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.destination#"><cfelse>NULL </cfif>,
				<cfif isdefined("attributes.allocate_name") and len(attributes.allocate_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.allocate_name#"><cfelse>NULL </cfif>,
				<cfif isdefined("attributes.project_id") and len(attributes.project_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"><cfelse>NULL </cfif>,
				<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL </cfif>
			)
		</cfquery>
	</cftransaction>
</cflock>
<cfset max_id = get_max_id.identitycol>
<cfif len(j_EMPS)>
	<cfloop list="#j_emps#" index="aa" delimiters=",">
	<cfquery name="add_users" datasource="#dsn#">
		INSERT INTO 
		ASSET_P_KM_CONTROL_USERS
		(
		KM_CONTROL_ID,
		STATUS,
		EMPLOYEE_ID,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP,
		ASSETP_ID)
		VALUES
		(
			<cfqueryparam cfsqltype="cf_sql_integer" value="#max_id#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#aa#">,
			<cfqueryparam cfsqltype="cf_sql_date" value="#record_date#">,
			#session.ep.userid# ,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
		)
	</cfquery>
	</cfloop>
</cfif>
<cfif isdefined("attributes.allocate_name") and len(attributes.allocate_name)>
	<cfset allocate_name = attributes.allocate_name>
<cfelse>
	<cfset allocate_name = "">
</cfif>
<cfif isdefined("attributes.process_stage")>
	<cf_workcube_process 
		is_upd='1' 
		old_process_line='0'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		action_table='ASSET_P_KM_CONTROL'
		action_column='KM_CONTROL_ID'
		record_date='#now()#' 
		action_id='#max_id#'
		action_page='#request.self#?fuseaction=assetcare.popup_upd_allocate' 
		warning_description='Tahsis Adı : #allocate_name#'>
	</cfif>
<script type="text/javascript">
	location.href= document.referrer;
	wrk_opener_reload(); 
	window.close();
</script>
