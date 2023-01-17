
<!--- <cfscript>
	if(isdefined("attributes.to_emp_ids")) j_EMPS = ListSort(attributes.to_emp_ids,"Numeric", "Desc") ; else j_EMPS = '';	
</cfscript> --->
<cfif len(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
	<cfset attributes.finish_date = date_add("h",attributes.finish_hour,attributes.finish_date)>
	<cfset attributes.finish_date = date_add("n",attributes.finish_min,attributes.finish_date)> 
	<cfset record_date = #createOdbcDateTime(now())#>
</cfif>
	 <cfquery name="UPD_ALLOCATE" datasource="#DSN#"> 
		UPDATE
			 ASSET_P_KM_CONTROL
				SET 
				ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">,
				EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">,
				DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">,
				FINISH_DATE = <cfif len(attributes.finish_date)> <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#"><cfelse> NULL</cfif>,
				KM_START = <cfif len(attributes.start_km)> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.start_km#"><cfelse> NULL</cfif>,
				KM_FINISH = <cfif len(attributes.finish_km)> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.finish_km#"><cfelse> NULL</cfif>,
				IS_OFFTIME = <cfif isDefined("attributes.is_offtime")> <cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
				ALLOCATE_REASON_ID = <cfif len(attributes.allocate_reason_id)> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.allocate_reason_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="true" value=""></cfif>,
				ALLOCATE_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
				ALLOCATE_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.allocate_name#">,
				DESTINATION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.destination#">,
				PROJECT_ID = <cfif len(attributes.project_id)> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"><cfelse> NULL</cfif>,
				PROCESS_ROW_ID = <cfif len(attributes.process_stage)> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse> NULL</cfif>,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		WHERE 
				KM_CONTROL_ID = #attributes.km_control_id#
	</cfquery>
	<cfquery name="delete_allocate_user" datasource="#dsn#">
		DELETE FROM
			ASSET_P_KM_CONTROL_USERS
		WHERE
			KM_CONTROL_ID = #attributes.km_control_id#
	</cfquery>		

	<cfif isdefined("attributes.to_emp_ids") and ListLen(attributes.to_emp_ids)>
		<cfloop list="#attributes.to_emp_ids#" index="aa" >
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
				VALUES(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.km_control_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
					#aa#,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					#session.ep.userid# , 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#"> 
				)
			</cfquery>
		</cfloop>
	</cfif>
	
	<!--- <cfquery name="name" datasource="#dsn#">
		select * from ASSET_P_KM_CONTROL_USERS Where KM_CONTROL_ID = 46
	</cfquery>
	<cfdump var="#name#" abort> --->
	<script type="text/javascript">
		location.href= document.referrer;
		wrk_opener_reload(); 
		window.close();
	</script>
	