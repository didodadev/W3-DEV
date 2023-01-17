<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.list_partner') and ListLen(attributes.list_partner,',')>
	<cfset my_len = listlen(attributes.list_partner,',')>
	<cfif listlen(list_partner)>
		<cfquery name="GET_EVENT_LIST" datasource="#dsn#">
			SELECT
				1 TYPE,
				EVENT_ID,
				EVENT_HEAD,
				STARTDATE,
				FINISHDATE,
				NULL AS EVENT_PLAN_ROW_ID,
				NULL AS PARTNER_ID,
				RECORD_EMP AS RECORD_EMP
			FROM
				EVENT
			WHERE
		<cfloop list="#list_partner#" index="i">
			EVENT_TO_PAR LIKE '%,#i#,%' <cfif listfindnocase(list_partner,i,',') lt my_len>	OR</cfif>
		</cfloop>
		AND
		(
			EVENT.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
			EVENT.UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
			EVENT.EVENT_TO_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.userid#,%"> OR
			EVENT.EVENT_CC_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.userid#,%"> OR
			EVENT.VALID_PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
		OR EVENT.VIEW_TO_ALL = 1 
		) 
		
		UNION
		
			SELECT
				2 TYPE, 
				EVENT_PLAN.EVENT_PLAN_ID,
				EVENT_PLAN.EVENT_PLAN_HEAD,
				EVENT_PLAN.MAIN_START_DATE,
				EVENT_PLAN.MAIN_FINISH_DATE,
				EVENT_PLAN_ROW_ID,
				EVENT_PLAN_ROW.PARTNER_ID,
				EVENT_PLAN_ROW.RECORD_EMP
			FROM  
				EVENT_PLAN,
				EVENT_PLAN_ROW
			WHERE
				EVENT_PLAN.EVENT_PLAN_ID= EVENT_PLAN_ROW.EVENT_PLAN_ID AND
				EVENT_PLAN_ROW.PARTNER_ID IN (#list_partner#)
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
		EVENT_ID,
		EVENT_HEAD,
		STARTDATE,
		FINISHDATE
	FROM
		EVENT
	WHERE
		EVENT_TO_CON LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value=",%#attributes.cid#%,">
	ORDER BY
		STARTDATE DESC
	</cfquery>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_event_list.recordcount#">

<div class="table-responsive-lg">
	<table class="table">
		<thead class="main-bg-color">
			<tr>
				<td><cf_get_lang dictionary_id='57742.Tarih'></td>
				<td><cf_get_lang dictionary_id='57629.Açıklama'></td>
				<td><cf_get_lang dictionary_id ='35682.Planlayan'></td>
			</tr>
		</thead>
		<tbody>
			<cfif GET_EVENT_LIST.recordcount>
				<cfset employee_info_list=''>
				<cfoutput query="GET_EVENT_LIST" startrow="1" maxrows="#attributes.maxrows#">
					<cfif isdefined("record_emp") and len(record_emp) and not listfind(employee_info_list,record_emp)>
						<cfset employee_info_list = Listappend(employee_info_list,record_emp)>
					</cfif>
				</cfoutput>
				<cfif len(employee_info_list)>
				<cfquery name="GET_EMPLOYEE_LIST" datasource="#DSN#">
					SELECT 
						EMPLOYEE_NAME, 
						EMPLOYEE_SURNAME, 
						EMPLOYEE_ID 
					FROM 
						EMPLOYEES 
					WHERE 
						EMPLOYEE_ID IN (#employee_info_list#)
					ORDER BY
						EMPLOYEE_ID
				</cfquery>
					<cfset employee_info_list = listsort(listdeleteduplicates(valuelist(get_employee_list.employee_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfoutput query="GET_EVENT_LIST" startrow="1" maxrows="#attributes.maxrows#">
					<tr>
						<td>#dateformat(startdate,'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,startdate),'HH:MM')#-#dateformat(finishdate,'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,finishdate),'HH:MM')#</td>
						<td>
						<cfif isdefined('EVENT_PLAN_ROW_ID') and len(EVENT_PLAN_ROW_ID)>
							#event_head#
						<cfelse>
							#event_head#
						</cfif>
						</td>
						<td><cfif isdefined('record_emp') and len(record_emp)>
							#get_employee_list.employee_name[listfind(employee_info_list,record_emp,',')]# #get_employee_list.employee_surname[listfind(employee_info_list,record_emp,',')]#
							</cfif>
						</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
				</tr>
			</cfif>
		</tbody>
	</table>
</div>