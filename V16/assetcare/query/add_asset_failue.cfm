<cf_xml_page_edit fuseact="assetcare.form_add_asset_failure">
<cfif isdefined("attributes.failure_date") and  len(attributes.failure_date)>
	<cf_date tarih='attributes.failure_date'>
	<cfscript>
		if(len(attributes.finish_clock))
			attributes.failure_date = date_add('h',attributes.finish_clock, attributes.failure_date);
		if(len(attributes.finish_minute))
			attributes.failure_date = date_add('n',attributes.finish_minute, attributes.failure_date);
	</cfscript>
</cfif>
<cflock timeout="60">
	<cftransaction>
		<cfquery name="ADD_ASSET_FAULIRE" datasource="#DSN#" result="failure_id">
			INSERT INTO
				ASSET_FAILURE_NOTICE
			(
				FAILURE_EMP_ID,
				FAILURE_DATE,
				ASSET_CARE_ID,
				FAILURE_STAGE,
				ASSETP_ID,
				STATION_ID,
				DETAIL,
                NOTICE_HEAD,
				SEND_TO_ID,
				PROJECT_ID,
				DOCUMENT_NO,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				<cfif len(attributes.failure_emp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.failure_emp_id#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.failure_date") and len(attributes.failure_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.failure_date#"><cfelse>NULL</cfif>,
				<cfif len(attributes.care_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.care_type_id#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
				<cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.station_id") and  len(attributes.station_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.station_id#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.failure_detail") and len(attributes.failure_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.failure_detail#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.failure_head") and len(attributes.failure_head)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.failure_head#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.send_to_id") and len(attributes.send_to_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.send_to_id#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.project_id#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.document_no#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">	
			)
		</cfquery>
		<cfif x_km_record eq 1>
			<cfquery name="get_branch" datasource="#dsn#">
				SELECT 
					EMPLOYEE_POSITIONS.EMPLOYEE_ID, 
					BRANCH.BRANCH_ID, 
					DEPARTMENT.DEPARTMENT_ID, 
					ASSET_P.ASSETP_CATID,
					ASSET_P_CAT.MOTORIZED_VEHICLE
				FROM 
					EMPLOYEE_POSITIONS, 
					ASSET_P, 
					ASSET_P_CAT,
					DEPARTMENT, 
					BRANCH 
				WHERE
					ASSET_P.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND 
					DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND 
					ASSET_P.POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE AND 
					ASSET_P_CAT.ASSETP_CATID=ASSET_P.ASSETP_CATID 
                   <cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id)> 
						AND	ASSET_P.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
                    </cfif>
			</cfquery>
           
			<cfif get_branch.recordcount and get_branch.motorized_vehicle eq 1>
				<cfif isdefined("attributes.m_v_previous_date") and isdate(attributes.m_v_previous_date)>
					<cf_date tarih = "attributes.m_v_previous_date">
				</cfif>
				<cfif isdefined("attributes.m_v_last_date") and isdate(attributes.m_v_last_date)>
					<cf_date tarih = "attributes.m_v_last_date">
				</cfif>
				<cfquery name="add_km" datasource="#dsn#">
					INSERT INTO 
						ASSET_P_KM_CONTROL
					(
						ASSETP_ID,
						EMPLOYEE_ID,
						DEPARTMENT_ID, 
						BRANCH_ID,
						KM_START,
						KM_FINISH,
						START_DATE,
						FINISH_DATE,
						DETAIL,
						IS_OFFTIME,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE
					) 
					VALUES 
					(
						<cfif len(get_branch.branch_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#"><cfelse>NULL</cfif>,
						<cfif len(get_branch.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch.employee_id#"><cfelse>NULL</cfif>,
						<cfif len(get_branch.department_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch.department_id#"><cfelse>NULL</cfif>,
						<cfif len(get_branch.branch_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch.branch_id#"><cfelse>NULL</cfif>,
						<cfif len(attributes.m_v_previous_km)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.m_v_previous_km#"><cfelse>0</cfif>,
						<cfif len(attributes.m_v_last_km)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.m_v_last_km#"><cfelse>0</cfif>,
						<cfif len(attributes.m_v_previous_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.m_v_previous_date#"><cfelse>NULL</cfif>,
						<cfif len(attributes.m_v_last_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.m_v_last_date#"><cfelse>NULL</cfif>,
						<cfif len(attributes.failure_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.failure_detail#"><cfelse>NULL</cfif>,
						0,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						'#cgi.remote_addr#',
						#now()#
					)
				</cfquery>
			</cfif>
		</cfif>
		<cfif isdefined("attributes.failure_code") and len(attributes.failure_code)>
			<cfloop list="#attributes.failure_code#" index="m">
				<cfquery name="ADD_FAILURE_CODE_ROWS" datasource="#dsn#">
					INSERT INTO
						FAILURE_CODE_ROWS
					(
						FAILURE_CODE_ID,
						FAILURE_ID
					)				
					VALUES
					(
						#m#,
						#failure_id.identitycol#
					)
				</cfquery>
			</cfloop>
		</cfif>
        <!--- otomatik belge no güncelleme --->
        <cf_papers paper_type="asset_failure">
        <cfset system_paper_no=paper_code & '-' & paper_number>
        <cfset system_paper_no_add=paper_number>
        <cfif len(system_paper_no_add)>
            <cfquery name="UPD_GEN_PAP" datasource="#DSN#">
                UPDATE 
                    GENERAL_PAPERS_MAIN
                SET
                    ASSET_FAILURE_NUMBER = #system_paper_no_add#
                WHERE
                    ASSET_FAILURE_NUMBER IS NOT NULL
            </cfquery>
        </cfif>
	</cftransaction>
</cflock>

<cf_workcube_process is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='ASSET_FAILURE_NOTICE'
	action_column='FAILURE_ID'
	action_id='#failure_id.identitycol#'
	action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_asset_failure&event=upd&failure_id=#failure_id.identitycol#'
	warning_description="#getLang('assetcare',4)# : #failure_id.identitycol#">	
<script>
	window.location.href = "<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_asset_failure&event=upd&failure_id=#failure_id.identitycol#</cfoutput>";
</script>	
