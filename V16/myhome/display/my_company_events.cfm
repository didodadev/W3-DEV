<cfsetting showdebugoutput="no">
<cfquery name="FIND_DEPARTMENT_BRANCH" datasource="#DSN#">
	SELECT
		BRANCH.BRANCH_ID,
		DEPARTMENT.DEPARTMENT_ID
	FROM
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH
	WHERE
		EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
		EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<cfquery name="GET_GRPS" datasource="#DSN#">
	SELECT GROUP_ID FROM USERS WHERE POSITIONS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.position_code#,%">
</cfquery>
<cfquery name="GET_WRKGROUPS" datasource="#DSN#">
	SELECT WORKGROUP_ID FROM WORKGROUP_EMP_PAR WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<cfset grps = valuelist(get_grps.group_id)>
<cfset wrkgroups = valuelist(get_wrkgroups.workgroup_id)>
<cfif isdefined("attributes.list_partner") and ListLen(attributes.list_partner,',')>
	<cfset my_len = listlen(attributes.list_partner,',')>
	<cfquery name="Get_Related_Consumer" datasource="#dsn#">
		SELECT RELATED_CONSUMER_ID FROM COMPANY_PARTNER WHERE PARTNER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.list_partner#">)
	</cfquery>
	<cfset Related_Consumer_List = ValueList(Get_Related_Consumer.Related_Consumer_Id,',')>
	<cfif listlen(list_partner)>
		<cfquery name="GET_EVENT_LIST" datasource="#DSN#">
			SELECT
				1 TYPE,
				EVENT_ID,
				EVENT_HEAD,
				STARTDATE,
				FINISHDATE,
				NULL AS EVENT_PLAN_ROW_ID,
				NULL AS PARTNER_ID,
				NULL AS VISIT_STAGE,
				RECORD_EMP AS RECORD_EMP
			FROM
				EVENT
			WHERE
				(
				<cfloop list="#list_partner#" index="i">
					EVENT_TO_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#i#,%"> <cfif i neq listlast(list_partner)>OR</cfif>
				</cfloop>
				)
				AND
				(
					EVENT.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR
					EVENT.UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR
					EVENT.EVENT_TO_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.userid#,%"> OR
					EVENT.EVENT_CC_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.userid#,%"> OR
					EVENT.VALID_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
					<cfloop list="#grps#" index="grps_row">
						OR EVENT.EVENT_TO_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#grps_row#,%">
						OR EVENT.EVENT_CC_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#grps_row#,%">
					</cfloop>
					<cfloop list="#wrkgroups#" index="wrk_row">
					   OR EVENT.EVENT_TO_WRKGROUP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#wrk_row#,%">
					   OR EVENT.EVENT_CC_WRKGROUP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#wrk_row#,%">
					</cfloop>
					OR EVENT.VIEW_TO_ALL = 1 
				) 
				AND
				(
					(IS_WIEW_DEPARTMENT IS NOT NULL AND IS_WIEW_BRANCH IS NOT NULL AND IS_WIEW_DEPARTMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="#find_department_branch.department_id#"> AND IS_WIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="#find_department_branch.branch_id#"> ) OR
					(IS_WIEW_BRANCH IS NOT NULL AND IS_WIEW_DEPARTMENT IS NULL AND IS_WIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="#find_department_branch.branch_id#">) OR
					(IS_WIEW_DEPARTMENT IS NULL AND IS_WIEW_BRANCH IS NULL)
				)
		
			UNION
		
			SELECT
				2 TYPE, 
				EVENT_PLAN.EVENT_PLAN_ID,
				EVENT_PLAN.EVENT_PLAN_HEAD,
				EVENT_PLAN_ROW.START_DATE,
				EVENT_PLAN_ROW.FINISH_DATE,
				EVENT_PLAN_ROW_ID,
				EVENT_PLAN_ROW.PARTNER_ID,
				EVENT_PLAN_ROW.VISIT_STAGE,
				EVENT_PLAN_ROW.RECORD_EMP
			FROM  
				EVENT_PLAN,
				EVENT_PLAN_ROW
			WHERE
				EVENT_PLAN.EVENT_PLAN_ID= EVENT_PLAN_ROW.EVENT_PLAN_ID AND
				EVENT_PLAN_ROW.PARTNER_ID IN (#list_partner#) AND
				EVENT_PLAN.SALES_ZONES IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			<cfif listfindnocase(list_partner,i,',') eq my_len>
			ORDER BY
				STARTDATE DESC
			</cfif>
		</cfquery>
	<cfelse>
		<cfparam name="get_event_list.recordcount" default="0">
	</cfif>	
<cfelse>
	<cfquery name="GET_EVENT_LIST" datasource="#DSN#">
		SELECT
			1 TYPE, 
			EVENT_ID,
			EVENT_HEAD,
			STARTDATE,
			FINISHDATE,
			NULL AS EVENT_PLAN_ROW_ID,
			NULL AS PARTNER_ID,
			NULL AS VISIT_STAGE,
			RECORD_EMP AS RECORD_EMP
		FROM
			EVENT
		WHERE
			(
				<cfquery name="Get_Related_Consumer" datasource="#dsn#">
					SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE RELATED_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
				</cfquery>
				<cfif Get_Related_Consumer.RecordCount>
					<cfloop query="Get_Related_Consumer">
						EVENT_TO_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value=",%#Get_Related_Consumer.Partner_Id#%,"> OR
					</cfloop>
				</cfif>
				EVENT_TO_CON LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value=",%#attributes.cid#%,">
			)
	UNION
		SELECT
			2 TYPE, 
			EVENT_PLAN.EVENT_PLAN_ID,
			EVENT_PLAN.EVENT_PLAN_HEAD,
			EVENT_PLAN_ROW.START_DATE STARTDATE,
			EVENT_PLAN_ROW.FINISH_DATE FINISHDATE,
			EVENT_PLAN_ROW_ID,
			EVENT_PLAN_ROW.PARTNER_ID,
			EVENT_PLAN_ROW.VISIT_STAGE,
			EVENT_PLAN_ROW.RECORD_EMP
		FROM  
			EVENT_PLAN,
			EVENT_PLAN_ROW
		WHERE
			EVENT_PLAN.EVENT_PLAN_ID= EVENT_PLAN_ROW.EVENT_PLAN_ID AND
			(
				EVENT_PLAN_ROW.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> OR
				EVENT_PLAN_ROW.PARTNER_ID IN (SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE RELATED_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">) 
			) AND
			EVENT_PLAN.SALES_ZONES IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		ORDER BY
			STARTDATE DESC
	</cfquery>
</cfif>
<cf_ajax_list>
	<thead>
		 <tr>
			<th width="180"><cf_get_lang dictionary_id='57742.Tarih'></th>
			<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
			<th><cf_get_lang dictionary_id='31910.Planlayan'></th>
			<th><cf_get_lang dictionary_id='58511.Takım'></th>
			<th><cf_get_lang dictionary_id='57684.Sonuc'></th>
		</tr>
	</thead>	
    <tbody>
	<cfif get_event_list.recordcount>
	<cfset employee_info_list=''>
	<cfset visit_stage_id_list = ''>
	<cfoutput query="get_event_list" startrow="1" maxrows="#attributes.maxrows#">
		<cfif isdefined("record_emp") and len(record_emp) and not listfind(employee_info_list,record_emp)>
			<cfset employee_info_list = Listappend(employee_info_list,record_emp)>
		</cfif>
		<cfif isdefined("visit_stage") and len(visit_stage) and not listfind(visit_stage_id_list,visit_stage)>
			<cfset visit_stage_id_list = Listappend(visit_stage_id_list,visit_stage)>
		</cfif>
	</cfoutput>
	<cfif len(employee_info_list)>
		<cfquery name="GET_EMPLOYEE_LIST" datasource="#DSN#">
			SELECT EMPLOYEE_ID,	EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_info_list#) ORDER BY EMPLOYEE_ID
		</cfquery>
		<cfset employee_info_list = listsort(listdeleteduplicates(valuelist(get_employee_list.employee_id,',')),'numeric','ASC',',')>
		<cfquery name="GET_TEAM_LIST" datasource="#DSN#">
			SELECT 
				EP.EMPLOYEE_ID,
				ST.TEAM_NAME
			 FROM 
			 	SALES_ZONES_TEAM_ROLES SP,
				EMPLOYEE_POSITIONS EP,
				SALES_ZONES_TEAM ST
			WHERE 
				SP.TEAM_ID = ST.TEAM_ID
				AND EP.POSITION_CODE = SP.POSITION_CODE
				AND EP.EMPLOYEE_ID IN(#employee_info_list#)
			 ORDER BY 
			 	EP.EMPLOYEE_ID
		</cfquery>
		<cfset employee_info_list2 = listsort(listdeleteduplicates(valuelist(get_team_list.employee_id,',')),'numeric','ASC',',')>
	</cfif>
		<tr class="nohover">
			<td class="txtbold" colspan="<cfoutput>5</cfoutput>"><cf_get_lang dictionary_id='57970.ziyaretler'></td>
		</tr>
		<cfoutput query="GET_EVENT_LIST" startrow="1" maxrows="#attributes.maxrows#">
			<cfif type eq 2>
				<cfquery name="CONTROL" datasource="#DSN#">
					SELECT EVENT_ID FROM EVENT_RESULT WHERE EVENT_ID = #event_id#
				</cfquery>
				<tr>
					<td width="180">#dateformat(startdate,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,startdate),timeformat_style)#-#dateformat(finishdate,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,finishdate),timeformat_style)#</td>
					<td>
						<cfif isdefined("event_plan_row_id") and len(event_plan_row_id)>
							<a href="#request.self#?fuseaction=objects.popup_upd_event_plan_result&eventid=#event_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#" class="tableyazi" target="_blank">#event_head#</a>
						<cfelse>
							<a href="#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#event_id#" class="tableyazi">#event_head#</a>
						</cfif>
					</td>
					<td>
						<cfif isdefined("record_emp") and len(record_emp)>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#get_employee_list.employee_name[listfind(employee_info_list,record_emp,',')]# #get_employee_list.employee_surname[listfind(employee_info_list,record_emp,',')]#</a>
						</cfif>
					</td>
					<td>
						<cfif isdefined("record_emp") and len(record_emp)>
							#get_team_list.team_name[listfind(employee_info_list2,record_emp,',')]#
						</cfif>
					</td>
					<td>
						<cfif type eq 1>
						<cfif control.recordcount><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=agenda.popup_event_result&event_id=#event_id#','page');" class="tableyazi"><cf_get_lang dictionary_id='34508.Tutanak Göster'></a></cfif>
						</cfif> 
					</td>
				</tr>
			</cfif>
		</cfoutput>
		<tr class="nohover">
			<td class="txtbold" colspan="<cfoutput>5</cfoutput>"><cf_get_lang dictionary_id='30466.toplantılar'></td>
		</tr>
		<cfoutput query="GET_EVENT_LIST" startrow="1" maxrows="#attributes.maxrows#">
			<cfif type eq 1>
				<cfquery name="CONTROL" datasource="#DSN#">
					SELECT EVENT_ID FROM EVENT_RESULT WHERE EVENT_ID = #event_id#
				</cfquery>
				<tr>
					<td width="180">#dateformat(startdate,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,startdate),timeformat_style)#-#dateformat(finishdate,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,finishdate),timeformat_style)#</td>
					<td>
						<cfif isdefined("event_plan_row_id") and len(event_plan_row_id)>
							<a href="#request.self#?fuseaction=objects.popup_upd_event_plan_result&eventid=#event_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#" class="tableyazi" target="_blank">#event_head#</a>
						<cfelse>
							<a href="#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#event_id#" class="tableyazi">#event_head#</a>
						</cfif>
					</td>
					<td>
						<cfif isdefined("record_emp") and len(record_emp)>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#get_employee_list.employee_name[listfind(employee_info_list,record_emp,',')]# #get_employee_list.employee_surname[listfind(employee_info_list,record_emp,',')]#</a>
						</cfif>
					</td>
					<td>
						<cfif isdefined("record_emp") and len(record_emp)>
							#get_team_list.team_name[listfind(employee_info_list2,record_emp,',')]#
						</cfif>
					</td>
					<td>
						<cfif type eq 1>
						<cfif control.recordcount><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=agenda.popup_event_result&event_id=#event_id#','page');" class="tableyazi"><cf_get_lang dictionary_id='34508.Tutanak Göster'></a></cfif>
						</cfif> 
					</td>
				</tr>
			</cfif>
		</cfoutput>
	<cfelse>
			<tr>
				<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
			</tr>
	</cfif>
</tbody>
</cf_ajax_list>
