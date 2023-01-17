<cfcomponent>
<cffunction name="wrk_add_project" access="public" returntype="string">
		<cfargument name="company_id" type="string" required="no">
		<cfargument name="partner_id" type="string" required="no">
		<cfargument name="consumer_id" type="string" required="no">
		<cfargument name="project_emp_id" type="string" required="no">
		<cfargument name="task_company_id" type="string" required="no">
		<cfargument name="task_partner_id" type="string" required="no">
		<cfargument name="project_head" type="string" required="yes">
		<cfargument name="project_detail" type="string" required="no">
		<cfargument name="pro_h_start" type="string" required="no">
		<cfargument name="start_hour" type="string" required="no">
		<cfargument name="pro_h_finish" type="string" required="no">
		<cfargument name="finish_hour" type="string" required="no">
		<cfargument name="project_stage" type="string" required="no">
		<cfargument name="priority_cat" type="numeric" required="no">
		<cfargument name="expense_code" type="string" required="no">
		<cfargument name="expected_budget" type="string" required="no">
		<cfargument name="expected_currency" type="string" required="no"><!--- tahmini maliyet ve bütcenin parabirimini tek ekledik --->
		<cfargument name="expected_cost" type="string" required="no">
		<cfargument name="target_project" type="string" required="no">
		<cfargument name="related_project_id" type="string" required="no">
		<cfargument name="process_stage" type="numeric" required="yes">
		<cfargument name="main_process_cat" type="numeric" required="yes">
		<cfargument name="project_folder" type="string" required="no">
		<cfargument name="agreement_no" type="string" required="no">
		<cfargument name="is_copy" type="string" required="no">
		<cfargument name="main_project_id" type="string" required="no">
		
			<cfinclude template="/WMO/functions.cfc">
			<cfset dsn2="#dsn#_#session.ep.period_year#_#session.ep.company_id#">
		<cfset dsn3="#dsn#_#session.ep.company_id#">
		<cfset dsn3_alias=dsn3>
		<cfset dsn2_alias=dsn2>
		<cfset dsn_alias=dsn>
		
		<cfif len(arguments.is_copy) and arguments.is_copy gt 0 >
			<cfquery name="get_req" datasource="#dsn3#">
					SELECT *FROM 
						TEXTILE_SAMPLE_REQUEST,
						#dsn#.PRO_PROJECTS 
					WHERE 
						REQ_ID=#arguments.is_copy#
						AND TEXTILE_SAMPLE_REQUEST.PROJECT_ID=PRO_PROJECTS.PROJECT_ID
			</cfquery>
			<cfif len(get_req.RELATED_PROJECT_ID)>
				<cfset arguments.related_project_id=get_req.RELATED_PROJECT_ID>
			<cfelse>
				<cfset arguments.related_project_id=get_req.PROJECT_ID>
			</cfif>
			<cfquery name="get_project_related" datasource="#dsn#">
					SELECT *FROM PRO_PROJECTS WHERE RELATED_PROJECT_ID=#arguments.related_project_id#
			</cfquery>
			<cfquery name="get_main_project" datasource="#dsn#">
					SELECT *FROM PRO_PROJECTS WHERE PROJECT_ID=#arguments.related_project_id#
			</cfquery>
			<cfset iliskiliprojesayisi=get_project_related.recordcount>
				<cfset arguments.project_head="#get_main_project.project_head#.#iliskiliprojesayisi+1#">
			
		</cfif>
		
		<cfscript>
			if(isdefined('arguments.company_id') and len(arguments.company_id)) attributes.company_id=arguments.company_id; else attributes.company_id='';
			if(isdefined('arguments.partner_id') and len(arguments.partner_id)) attributes.partner_id=arguments.partner_id; else attributes.partner_id='';
			if(isdefined('arguments.consumer_id') and len(arguments.consumer_id)) attributes.consumer_id=arguments.consumer_id; else attributes.consumer_id='';
			if(isdefined('arguments.project_emp_id') and len(arguments.project_emp_id)) attributes.project_emp_id=arguments.project_emp_id; else attributes.project_emp_id='';
			if(isdefined('arguments.task_company_id') and len(arguments.task_company_id)) attributes.task_company_id=arguments.task_company_id; else attributes.task_company_id='';
			if(isdefined('arguments.task_partner_id') and len(arguments.task_partner_id)) attributes.task_partner_id=arguments.task_partner_id; else attributes.task_partner_id='';
			if(isdefined('arguments.project_head') and len(arguments.project_head)) attributes.project_head=arguments.project_head; else attributes.project_head='';
			if(isdefined('arguments.project_detail') and len(arguments.project_detail)) attributes.project_detail=arguments.project_detail; else attributes.project_detail='';
			if(isdefined('arguments.pro_h_start') and len(arguments.pro_h_start)) attributes.pro_h_start=arguments.pro_h_start; else attributes.pro_h_start=dateformat(now(),'dd/mm/yyyy');
			if(isdefined('arguments.start_hour') and len(arguments.start_hour)) attributes.start_hour=arguments.start_hour; else attributes.start_hour='0';
			if(isdefined('arguments.pro_h_finish') and len(arguments.pro_h_finish)) attributes.pro_h_finish=arguments.pro_h_finish; else attributes.pro_h_finish=dateformat(DateAdd("m",1,now()),'dd/mm/yyyy');
			if(isdefined('arguments.finish_hour') and len(arguments.finish_hour)) attributes.finish_hour=arguments.finish_hour; else attributes.finish_hour='0';
			if(isdefined('arguments.project_stage') and len(arguments.project_stage)) attributes.project_stage=arguments.project_stage; else attributes.project_stage='';
			if(isdefined('arguments.priority_cat') and len(arguments.priority_cat)) attributes.priority_cat=arguments.priority_cat; else attributes.priority_cat='1';
			if(isdefined('arguments.expense_code') and len(arguments.expense_code)) attributes.expense_code=arguments.expense_code; else attributes.expense_code='';
			if(isdefined('arguments.expected_budget') and len(arguments.expected_budget)) attributes.expected_budget=arguments.expected_budget; else attributes.expected_budget='';
			if(isdefined('arguments.expected_cost') and len(arguments.expected_cost)) attributes.expected_cost=arguments.expected_cost; else attributes.expected_cost='';
			if(isdefined('arguments.expected_currency') and len(arguments.expected_currency)) attributes.cost_currency=arguments.expected_currency; else attributes.cost_currency='';
			if(isdefined('arguments.expected_currency') and len(arguments.expected_currency)) attributes.budget_currency=arguments.expected_currency; else attributes.budget_currency='';
			if(isdefined('arguments.project_target') and len(arguments.project_target)) attributes.project_target=arguments.project_target; else attributes.project_target='';
			if(isdefined('arguments.related_project_id') and len(arguments.related_project_id)) attributes.related_project_id=arguments.related_project_id; else attributes.related_project_id='';
			if(isdefined('arguments.process_stage') and len(arguments.process_stage)) attributes.process_stage=arguments.process_stage; else attributes.process_stage='';
			if(isdefined('arguments.main_process_cat') and len(arguments.main_process_cat)) attributes.main_process_cat=arguments.main_process_cat; else attributes.main_process_cat='';
			if(isdefined('arguments.project_folder') and len(arguments.project_folder)) attributes.project_folder=arguments.project_folder; else attributes.project_folder='';
			if(isdefined('arguments.agreement_no') and len(arguments.agreement_no)) attributes.agreement_no=arguments.agreement_no; else attributes.agreement_no='';
		</cfscript>
	
		<cfset attributes.PROJECT_POS_CODE="32">
	
		<cfset EXPENSE_CODE="">
	
		<cfset is_web_service="1">
		<cfinclude template="/V16/project/query/add_project.cfm">	
			<cfset projectinfo="#GET_LAST_PRO.PRO_ID#,#arguments.project_head#">
		<cfreturn projectinfo>
	</cffunction>
	</cfcomponent>