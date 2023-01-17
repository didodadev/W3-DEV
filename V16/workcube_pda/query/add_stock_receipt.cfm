<cf_papers paper_type="OPPORTUNITY">
<cfset system_paper_no = paper_code & '-' & paper_number>
<cfset system_paper_no_add = paper_number>
<cfset attributes.sales_emp_id = session.pda.userid>
<cfif isdefined('attributes.opp_date') and len(attributes.opp_date)><cf_date tarih="attributes.opp_date"></cfif>
<cfparam name="attributes.opp_date" default="#now()#">
<!--- <cfif len(attributes.opp_date)><cf_date tarih="attributes.opp_date"></cfif>
<cfset attributes.sales_team_id = ''>
<cfif len(attributes.sales_emp_id) and len(attributes.company_id)>
	<cfquery name="get_sales_team" datasource="#dsn#">
		SELECT
			SZT.TEAM_ID
		FROM
			COMPANY C,
			SALES_ZONES_TEAM SZT,
			SALES_ZONES_TEAM_ROLES SZTR
		WHERE
			C.SALES_COUNTY = SZT.SALES_ZONES AND
			SZT.TEAM_ID = SZTR.TEAM_ID AND
			C.COMPANY_ID = #attributes.company_id# AND
			SZTR.POSITION_CODE IN (SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #attributes.sales_emp_id#)
	</cfquery>
	<cfset attributes.sales_team_id = get_sales_team.team_id>
</cfif> --->
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_OPPORTUNITY" datasource="#DSN3#" result="MAX_ID">
			INSERT INTO
				OPPORTUNITIES
				(
				OPPORTUNITY_TYPE_ID,
				<cfif attributes.member_type is 'partner'>
					PARTNER_ID,
					COMPANY_ID,	
				<cfelseif attributes.member_type is 'consumer'>
					CONSUMER_ID,
				</cfif>
				<cfif attributes.ref_member_type is 'partner'>
					REF_PARTNER_ID,
					REF_COMPANY_ID,				
				<cfelseif attributes.ref_member_type is 'consumer'>
					REF_CONSUMER_ID,
				<cfelseif attributes.ref_member_type is 'employee'>
					REF_EMPLOYEE_ID,
				<cfelse>
					REF_PARTNER_ID,
					REF_COMPANY_ID,
					REF_CONSUMER_ID,
					REF_EMPLOYEE_ID,
				</cfif>
				OPP_STAGE,
				<!--- COMMETHOD_ID,
				PRODUCT_CAT_ID, --->
				OPP_DETAIL,
				<!--- INCOME,
				MONEY,
				COST,
				MONEY2,
				STOCK_ID,
				SALES_TEAM_ID, --->
				SALES_EMP_ID,
				<!--- SALES_PARTNER_ID, --->
				OPP_DATE,
				OPP_CURRENCY_ID,
				OPP_STATUS,
				<!--- ACTIVITY_TIME,
				PROBABILITY, --->
				OPP_HEAD,
				OPP_ZONE,
				<!--- PROJECT_ID, --->
				OPP_NO,
				SALE_ADD_OPTION_ID,
				<!--- SERVICE_ID, --->
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE				
				)
			VALUES
				(
				<cfif len(attributes.opportunity_type_id)>#attributes.opportunity_type_id#<cfelse>NULL</cfif>,
				<cfif attributes.member_type is 'partner'>
					#attributes.member_id#,
					#attributes.company_id#,					
				<cfelseif attributes.member_type is 'consumer'>
					#attributes.member_id#,
				</cfif>
				<cfif attributes.ref_member_type is 'partner'>
					#attributes.ref_partner_id#,
					#attributes.ref_company_id#,					
				<cfelseif attributes.ref_member_type is 'consumer'>
					#attributes.ref_consumer_id#,
				<cfelseif attributes.ref_member_type is 'employee'>
					#attributes.ref_employee_id#,
				<cfelse>
					NULL,
					NULL,
					NULL,
					NULL,				
				</cfif>
				#attributes.process_stage#,
				<!--- <cfif len(attributes.commethod_id)>#attributes.commethod_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.product_cat_id)>#attributes.product_cat_id#<cfelse>NULL</cfif>, --->
				'#attributes.opp_detail#',
				<!--- <cfif len(attributes.income)>#attributes.income#<cfelse>NULL</cfif>,
				<cfif len(attributes.money) and len(attributes.income)>'#attributes.money#'<cfelse>NULL</cfif>,
				<cfif len(attributes.cost)>#attributes.cost#<cfelse>NULL</cfif>,
				<cfif len(attributes.money2) and len(attributes.cost)>'#attributes.money2#'<cfelse>NULL</cfif>,
				<cfif len(attributes.stock_id)>#attributes.stock_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.sales_team_id)>#attributes.sales_team_id#<cfelse>NULL</cfif>, --->
				<cfif len(attributes.sales_emp_id)>#attributes.sales_emp_id#<cfelse>NULL</cfif>,
				<!--- <cfif len(attributes.sales_partner_id)>#attributes.sales_partner_id#<cfelse>NULL</cfif>, --->
				<cfif len(attributes.opp_date)>#attributes.opp_date#<cfelse>NULL</cfif>,
				-1,
				1,
				<!--- <cfif len(attributes.activity_time)>#attributes.activity_time#<cfelse>NULL</cfif>,
				<cfif len(attributes.probability)>#attributes.probability#<cfelse>NULL</cfif>, --->
				'#attributes.opp_head#',
				0,
				<!--- <cfif len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>, --->
				'#system_paper_no#',
				<cfif len(attributes.sales_add_option)>#attributes.sales_add_option#<cfelse>NULL</cfif>,
				<!--- <cfif len(attributes.service_id)>#attributes.service_id#<cfelse>NULL</cfif>, --->
				#session.pda.userid#,
				'#cgi.remote_addr#',
				#now()#				
				)
		</cfquery>
		<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
			UPDATE
				GENERAL_PAPERS
			SET
				OPPORTUNITY_NUMBER = #system_paper_no_add#
			WHERE
				OPPORTUNITY_NUMBER IS NOT NULL
		</cfquery>
		<!--- <cf_workcube_process 
			is_upd='1' 
			data_source='#dsn3#' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.pda.userid#' 
			record_date='#now()#' 
			action_page='#request.self#?fuseaction=sales.form_upd_opportunity&opp_id=#MAX_ID.IDENTITYCOL#' 
			action_id='#MAX_ID.IDENTITYCOL#'
			warning_description='Fırsat : #MAX_ID.IDENTITYCOL#'>	 --->
	</cftransaction>
</cflock>

<cflocation addtoken="no" url="#request.self#?fuseaction=pda.form_upd_opportunity&opp_id=#MAX_ID.IDENTITYCOL#">

