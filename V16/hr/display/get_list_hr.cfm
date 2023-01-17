<cfsetting showdebugoutput="no">
<cfparam name="department_id" default="">
<cfparam name="show_div" default="1">
<cfif isdefined("attributes.is_multiselect") and isdefined('attributes.branch_id')>
	<cfquery name="get_department" datasource="#dsn#">
		SELECT
			DEPARTMENT_ID,
			BRANCH_ID,
			DEPARTMENT_HEAD
		FROM
			DEPARTMENT
		WHERE
			<cfif len(attributes.branch_id)>
				BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.branch_id#">)
			<cfelse>
				1 = 0
			</cfif>
            <cfif isdefined("attributes.dept") and len(attributes.dept)>
	            AND IS_STORE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.dept#">)
            </cfif>
			AND DEPARTMENT_STATUS = 1
		ORDER BY 
			DEPARTMENT_HEAD
	</cfquery>
	<cfif isdefined("attributes.onchange_func") and len(attributes.onchange_func)>
		<cf_multiselect_check 
			query_name="get_department"  
			name="#attributes.name#"
			width="150" 
			option_text="#getLang('main',322)#" 
			option_value="department_id"
			option_name="department_head"
			onchange="#attributes.onchange_func#">
	<cfelse>
		<cf_multiselect_check 
			query_name="get_department"  
			name="#attributes.name#"
			width="150" 
			option_text="#getLang('main',322)#" 
			option_value="department_id"
			option_name="department_head">
	</cfif>
<cfelseif isdefined('attributes.branch_id') and not isdefined("attributes.upper_dep")>
	<cfif attributes.branch_id eq 'all'>
		<cfset get_department.recordcount = 0>
	<cfelse>
		<cfif isdefined("attributes.self_department_control")>
			<cfquery name="get_emp_pos" datasource="#dsn#">
				SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
			</cfquery>
			<cfset pos_code_list = valuelist(get_emp_pos.position_code)>
			<!---İzinde olan kişilerin vekalet bilgileri alınıypr --->
			<cfquery name="Get_Offtime_Valid" datasource="#dsn#">
				SELECT
					O.EMPLOYEE_ID,
					EP.POSITION_CODE
				FROM
					OFFTIME O,
					EMPLOYEE_POSITIONS EP
				WHERE
					O.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
					O.VALID = 1 AND
					#Now()# BETWEEN O.STARTDATE AND O.FINISHDATE
			</cfquery>
			<cfif Get_Offtime_Valid.recordcount>
				<cfset Now_Offtime_PosCode = ValueList(Get_Offtime_Valid.Position_Code)>
				<cfquery name="Get_StandBy_Position1" datasource="#dsn#"><!--- Asil Kisi Izinli ise ve 1.Yedek Izinli Degilse --->
					SELECT POSITION_CODE, CANDIDATE_POS_1 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#Now_Offtime_PosCode#">) AND CANDIDATE_POS_1 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)
				</cfquery>
				<cfoutput query="Get_StandBy_Position1">
					<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position1.Position_Code))>
				</cfoutput>
				<cfquery name="Get_StandBy_Position2" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek Izinli ise ve 2.Yedek Izinli Degilse --->
					SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#Now_Offtime_PosCode#">) AND CANDIDATE_POS_2 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)
				</cfquery>
				<cfif Get_StandBy_Position2.RecordCount>
					<cfquery name="Get_StandBy_Position_Other_Offtime" datasource="#dsn#">
						SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE CANDIDATE_POS_1 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#Now_Offtime_PosCode#">) AND CANDIDATE_POS_2 IN(<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)
					</cfquery>
					<cfoutput query="Get_StandBy_Position_Other_Offtime">
						<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position_Other_Offtime.Position_Code))>
					</cfoutput>
				</cfif>
				<cfquery name="Get_StandBy_Position3" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek,2.Yedek Izinli ise ve 3.Yedek Izinli Degilse --->
					SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#Now_Offtime_PosCode#">) AND CANDIDATE_POS_3 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)
				</cfquery>
				<cfif Get_StandBy_Position3.RecordCount>
					<cfquery name="Get_StandBy_Position_Other_Offtime" datasource="#dsn#">
						SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE CANDIDATE_POS_1 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#Now_Offtime_PosCode#">) AND CANDIDATE_POS_2 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#Now_Offtime_PosCode#">) AND CANDIDATE_POS_3 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)
					</cfquery>
					<cfoutput query="Get_StandBy_Position_Other_Offtime">
						<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position_Other_Offtime.Position_Code))>
					</cfoutput>
				</cfif>
			</cfif>
			<cfquery name="get_department" datasource="#dsn#">
				SELECT
					DEPARTMENT_ID,
					BRANCH_ID,
					DEPARTMENT_HEAD
				FROM
					DEPARTMENT
				WHERE
					BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND
					DEPARTMENT_STATUS = 1
					<cfif attributes.x_manager_pos_code neq session.ep.position_code and not get_module_power_user(48)>
					AND 
					(
					DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
					OR
					ADMIN1_POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)
					OR
					ADMIN2_POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)
					)
					</cfif>
				ORDER BY 
					DEPARTMENT_HEAD
			</cfquery>
		<cfelse>
			<cfquery name="get_department" datasource="#dsn#">
				SELECT	
					DEPARTMENT_ID,
					BRANCH_ID,
					DEPARTMENT_HEAD
				FROM 
					DEPARTMENT
				WHERE  
					DEPARTMENT_STATUS = 1 AND 
                    IS_STORE <> 1 AND
					BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> 
				ORDER BY 
					DEPARTMENT_HEAD
			</cfquery>
		</cfif>
	</cfif>
        <cfif show_div eq 1>
			<div class="col col-12">
				<select name="department" id="department" style="width:150px;" <cfif isdefined("attributes.onchange_func") and len(attributes.onchange_func)>onchange="<cfoutput>#attributes.onchange_func#()</cfoutput>"</cfif>>
					<option value=""><cfoutput>#getlang('main',160)#</cfoutput> <cfoutput>#getlang('main',322)#</cfoutput></option>
					<cfif get_department.recordcount>
					<cfoutput query="get_department">
						<option value="#DEPARTMENT_ID#">#DEPARTMENT_HEAD#</option>
					</cfoutput>
					</cfif>
				</select>
			</div>
		<cfelse>
			<select name="DEPARTMENT_ID" id="DEPARTMENT_ID" style="width:150px;" <cfif isdefined("attributes.onchange_func") and len(attributes.onchange_func)>onchange="<cfoutput>#attributes.onchange_func#()</cfoutput>"</cfif>>
				<option value=""><cfoutput>#getlang('main',160)#</cfoutput> <cfoutput>#getlang('main',322)#</cfoutput></option>
				<cfif get_department.recordcount>
				<cfoutput query="get_department">
					<option value="#DEPARTMENT_ID#">#DEPARTMENT_HEAD#</option>
				</cfoutput>
				</cfif>
			</select>
		</cfif>
<cfelseif isdefined('attributes.branch_id') and isdefined("attributes.upper_dep")>
	<cfif attributes.branch_id eq 'all'>
		<cfset get_departmant.recordcount = 0>
	<cfelse>	
		<!---Alt üst departman ilişkisi için py --->
		<cfquery name="get_departmant" datasource="#dsn#">
			 SELECT 
				DEPARTMENT_ID, 
				DEPARTMENT_HEAD,
				HIERARCHY_DEP_ID
			FROM 
				DEPARTMENT 
			WHERE 
				BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
				AND DEPARTMENT_STATUS = 1
			ORDER BY 
				HIERARCHY_DEP_ID,DEPARTMENT_HEAD
		</cfquery>
	</cfif>
    <select name="department" id="department" style="width:150px;">
		<option value=""><cf_get_lang_main no='160.Departman'></option>
        <cfif get_departmant.recordcount>
		<cfoutput query="get_departmant">
			<cfset uzunluk = listlen(HIERARCHY_DEP_ID,'.')>
            <cfif HIERARCHY_DEP_ID eq DEPARTMENT_ID>
                <option value="#HIERARCHY_DEP_ID#"<cfif isdefined('attributes.department') and (attributes.department eq get_departmant.DEPARTMENT_ID)>selected</cfif>>#DEPARTMENT_HEAD#</option>
            <cfelse>
                <option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department') and (attributes.department eq get_departmant.DEPARTMENT_ID)>selected</cfif>><cfif uzunluk eq 2>&nbsp;&nbsp;&nbsp;&nbsp;<cfelseif uzunluk eq 3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cfelseif uzunluk eq 4>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</cfif>#DEPARTMENT_HEAD#</option>
            </cfif>
        </cfoutput>
		</cfif>
	</select>
</cfif>
<cfif isdefined("attributes.comp_id")>
	<cfif isdefined('attributes.is_multiselect')>
		<cfquery name="get_branch" datasource="#dsn#">
			SELECT
				BRANCH_ID,
				BRANCH_NAME,
				COMPANY_ID,
				OUR_COMPANY.COMPANY_NAME,
				OUR_COMPANY.NICK_NAME
			FROM
				BRANCH
				INNER JOIN OUR_COMPANY ON BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
			WHERE
            	BRANCH_STATUS = 1
            	<cfif len(attributes.comp_id)>
					AND COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.comp_id#">)
				</cfif>
                <cfif isdefined('attributes.is_ssk_offices') and attributes.is_ssk_offices eq 1>
                	AND SSK_NO IS NOT NULL 
                    AND SSK_OFFICE IS NOT NULL 
                    AND SSK_BRANCH IS NOT NULL 
                    AND SSK_NO <> '' 
                    AND SSK_OFFICE <> '' 
                    AND SSK_BRANCH <> ''
				</cfif>
				<cfif not session.ep.ehesap>
					AND BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
					)
				</cfif>
			ORDER BY
				BRANCH.COMPANY_ID
		</cfquery>	
		<cf_multiselect_check 
			query_name="get_branch"  
			name="#attributes.name#"
			width="150" 
			option_text="#getLang('main',322)#" 
			option_value="BRANCH_ID"
			option_name="BRANCH_NAME-NICK_NAME"
			onchange="get_department_list(this.value)"			
			>
	<cfelse>
		<cfparam name="branch_id" default="">
		<cfparam name="department_id" default="">
		<cfif attributes.comp_id is "all">
			<cfset get_branch.recordcount = 0>
		<cfelse>
			<cfquery name="get_branch" datasource="#dsn#">
				SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE BRANCH_STATUS = 1 AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#">
				<cfif not session.ep.ehesap>
					AND BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
					)
				</cfif>
				ORDER BY BRANCH_NAME
			</cfquery>
		</cfif>	
		<div class="col col-12">
			<select name="branch_id" id="branch_id" style="width:150px;" onChange="showDepartment(this.value)">
				<option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
				<cfif get_branch.recordcount>
					<cfoutput query="get_branch">
						<option value="#branch_id#">#branch_name#</option>
					</cfoutput>
				</cfif>
			</select>
		</div>
	</cfif>
</cfif>
