<cfif len(attributes.work_h_start)>
	<cf_date tarih='attributes.work_h_start'>
</cfif>
<cfif len(attributes.work_h_finish)>
	<cf_date tarih='attributes.work_h_finish'>
</cfif>
<cfset cc_emp_list = "">
<cfset cc_par_list = "">
<cfif isDefined("attributes.record_num") and attributes.record_num gt 0>
	<cfloop from="1" to="#attributes.record_num#" index="rn">
		<cfif isDefined("attributes.row_kontrol#rn#") and Evaluate("attributes.row_kontrol#rn#") eq 1>
			<cfif isDefined("attributes.cc_emp_ids#rn#") and Len(Evaluate("attributes.cc_emp_ids#rn#"))>
				<cfset cc_emp_list = ListAppend(cc_emp_list,Evaluate("attributes.cc_emp_ids#rn#"))>
			</cfif>
			<cfif (isDefined("attributes.cc_par_ids#rn#") and Len(Evaluate("attributes.cc_par_ids#rn#")))>
				<cfset cc_par_list = ListAppend(cc_par_list,Evaluate("attributes.cc_par_ids#rn#"))>
			</cfif>
		</cfif>
	</cfloop>
</cfif>
<cfscript>
	attributes.work_h_start = date_add("h",attributes.start_hour,attributes.work_h_start);
	attributes.work_h_finish = date_add("h",attributes.finish_hour,attributes.work_h_finish);
</cfscript>

<cflock name="#createUUID()#" timeout="20">
	<cftransaction>	
		<cfquery name="ADD_WORK" datasource="#DSN#">
			INSERT INTO
				PRO_WORKS
				(
					WORK_HEAD,
					WORK_DETAIL,
					WORK_CAT_ID,
					TARGET_START,
					TARGET_FINISH,
					PROJECT_EMP_ID,
					WORK_CURRENCY_ID,
					WORK_PRIORITY_ID,
                    PROJECT_ID,
					RECORD_AUTHOR,
					RECORD_DATE,
					RECORD_IP
				)
				VALUES
				(
                    '#attributes.work_head#',
                    <cfif isDefined('attributes.work_detail') and len(attributes.work_detail)>'#attributes.work_detail#'<cfelse>''</cfif>,
                    #attributes.pro_work_cat#,
                    <cfif isDefined('attributes.work_h_start') and len(attributes.work_h_start)>#attributes.work_h_start#<cfelse>NULL</cfif>,
                    <cfif isDefined('attributes.work_h_finish') and len(attributes.work_h_finish)>#attributes.work_h_finish#<cfelse>NULL</cfif>,
                    <cfif isDefined('attributes.employee_id') and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
                    <cfif isDefined('attributes.work_currency') and len(attributes.work_currency)>#attributes.work_currency#<cfelse>NULL</cfif>,
                    #attributes.priority_cat#,
                    <cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
                    #session.pda.userid#,
                    #now()#,
                    '#cgi.remote_addr#'
                )
		</cfquery>
        
		<cfquery name="GET_MAX_WORK" datasource="#DSN#">
			SELECT MAX(WORK_ID) WORK_ID FROM PRO_WORKS
		</cfquery>
               		
		<cfquery name="ADD_HIST_WORK" datasource="#DSN#">
			INSERT INTO
				PRO_WORKS_HISTORY
				(
					WORK_ID,
					WORK_HEAD,
					WORK_DETAIL,
					WORK_CAT_ID,
					TARGET_START,
					TARGET_FINISH,
					PROJECT_EMP_ID,
					WORK_CURRENCY_ID,
					WORK_PRIORITY_ID,
					UPDATE_DATE,
                    UPDATE_AUTHOR
				)
				VALUES
				(
					#get_max_work.work_id#,
					'#attributes.work_head#',
					<cfif isDefined('attributes.work_detail') and len(attributes.work_detail)>'#attributes.work_detail#'<cfelse>''</cfif>,
					#attributes.pro_work_cat#,
                    <cfif isdefined("attributes.work_h_start") and len(attributes.work_h_start)>#attributes.work_h_start#,<cfelse>NULL,</cfif>
                    <cfif isdefined("attributes.work_h_finish") and len(attributes.work_h_finish)>#attributes.work_h_finish#,<cfelse>NULL,</cfif>
					<cfif isDefined('attributes.employee_id') and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
					<cfif isDefined('attributes.process_stage') and len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
					#attributes.priority_cat#,
					#now()#,	
                    #session.pda.userid#
				)
		</cfquery>
        
		<cfif isdefined("attributes.cc_par_ids") or isdefined("attributes.cc_emp_ids")>
			<cfquery name="DEL_WORK_CC" datasource="#DSN#">	
				DELETE FROM PRO_WORKS_CC WHERE WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_work.work_id#">
			</cfquery>
			<cfif (isdefined("attributes.cc_par_ids") and ListLen(attributes.cc_par_ids)) or (isdefined("attributes.cc_emp_ids") and ListLen(attributes.cc_emp_ids))>
				<cfif isDefined("attributes.cc_par_ids") and ListLen(attributes.cc_par_ids)>
					<cfloop list="#attributes.cc_par_ids#" index="pid">
						<cfquery name="ADD_WORK_CC_PAR" datasource="#DSN#">
							INSERT INTO PRO_WORKS_CC (CC_PAR_ID, WORK_ID) VALUES (#pid#, #get_max_work.work_id#)
						</cfquery>
					</cfloop>
				</cfif>
				<cfif isDefined("attributes.cc_emp_ids") and ListLen(attributes.cc_emp_ids)>
					<cfloop list="#attributes.cc_emp_ids#" index="eid">
						<cfquery name="ADD_WORK_CC_EMP" datasource="#DSN#">
							INSERT INTO PRO_WORKS_CC (CC_EMP_ID, WORK_ID) VALUES (#eid#, #get_max_work.work_id#)
						</cfquery>
					</cfloop>
				</cfif>
			</cfif>
		</cfif>
	</cftransaction>
</cflock>

<cf_workcube_process is_upd='1' 
    old_process_line='0'
    process_stage='#attributes.process_stage#' 
    record_member='#session.pda.userid#' 
    record_date='#now()#' 
    action_table='PRO_WORKS'
    action_column='WORK_ID'
    action_id='#get_max_work.work_id#'
    action_page='#request.self#?fuseaction=pda.form_upd_work&id=#get_max_work.work_id#' 
    warning_description = 'Ilgili Is : #attributes.work_head#'>

<cflocation url="#request.self#?fuseaction=pda.form_upd_work&work_id=#get_max_work.work_id#&project_id=#attributes.project_id#" addtoken="no">
