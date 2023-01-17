<cfif isdefined('attributes.opp_detail') and not len(attributes.opp_detail)>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1623.Lütfen Fırsat İle İlgili Detay Giriniz!'>");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfquery name="GET_STAGE" datasource="#DSN#" maxrows="1">
	SELECT TOP 1
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		<cfif isdefined("session.pp")>
			PTR.IS_PARTNER = 1 AND
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
		<cfelseif isdefined("session.ww")>
			PTR.IS_CONSUMER = 1 AND
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
		<cfelse>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		</cfif>
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.form_add_opportunity%">
	ORDER BY 
		PTR.LINE_NUMBER
</cfquery>

<cfif not get_stage.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='33.İşlem Tipleri Tanımlı Değil! Lütfen Müşteri Temsilcinize Başvurunuz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cf_papers paper_type="OPPORTUNITY">
<cfset system_paper_no=paper_code & '-' & paper_number>
<cfset system_paper_no_add=paper_number>
<cfif len(attributes.opp_date)>
	<cf_date tarih="attributes.opp_date">
</cfif>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_OPPORTUNITY" datasource="#DSN3#">
			INSERT INTO
				OPPORTUNITIES
			(
				OPPORTUNITY_TYPE_ID,
				PARTNER_ID,
				COMPANY_ID,			
				CONSUMER_ID,
				OPP_STAGE,
				COMMETHOD_ID,
				OPP_DETAIL,
				INCOME,
				MONEY,
				COST,
				MONEY2,
				SALES_PARTNER_ID,
				OPP_DATE,
				OPP_CURRENCY_ID,
				OPP_STATUS,
				ACTIVITY_TIME,
				PROBABILITY,
				OPP_HEAD,
				OPP_ZONE,
				PROJECT_ID,
				OPP_NO,
				SALE_ADD_OPTION_ID,
				RECORD_PAR,
				RECORD_IP,
				RECORD_DATE			
			)
			VALUES
			(
				<cfif len(attributes.opportunity_type_id)>#attributes.opportunity_type_id#<cfelse>NULL</cfif>,
                <cfif isDefined('attributes.to_par_ids') and len(attributes.to_par_ids)>#attributes.to_par_ids#<cfelse>NULL</cfif>,
				<cfif isDefined('attributes.to_comp_ids') and len(attributes.to_comp_ids)>#attributes.to_comp_ids#<cfelse>NULL</cfif>,
				<cfif isDefined('attributes.to_cons_ids') and len(attributes.to_cons_ids)>#attributes.to_cons_ids#<cfelse>NULL</cfif>,
				<!---<cfif len(attributes.partner_id) and len(attributes.member_name)>#attributes.partner_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.company_id) and len(attributes.member_name)>#attributes.company_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.consumer_id) and len(attributes.member_name)>#attributes.consumer_id#<cfelse>NULL</cfif>,--->
				#get_stage.process_row_id#,
				<cfif len(attributes.commethod_id)>#attributes.commethod_id#<cfelse>NULL</cfif>,
				'#attributes.opp_detail#',
				<cfif len(attributes.income)>#attributes.income#<cfelse>NULL</cfif>,
				<cfif len(attributes.money) and len(attributes.income)>'#attributes.money#'<cfelse>NULL</cfif>,
				<cfif len(attributes.cost)>#attributes.cost#<cfelse>NULL</cfif>,
				<cfif len(attributes.money2) and len(attributes.cost)>'#attributes.money2#'<cfelse>NULL</cfif>,
				#attributes.sales_partner_id#,
				<cfif len(attributes.opp_date)>#attributes.opp_date#<cfelse>NULL</cfif>,
				-1,
				1,
				<cfif len(attributes.activity_time)>#attributes.activity_time#<cfelse>NULL</cfif>,
				<cfif len(attributes.probability)>#attributes.probability#<cfelse>NULL</cfif>,
				'#attributes.opp_head#',
				0,
				<cfif len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
				'#system_paper_no#',
				<cfif len(attributes.sales_add_option)>#attributes.sales_add_option#<cfelse>NULL</cfif>,
				#session.pp.userid#,
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
		<cfquery name="GET_OPP_MAX" datasource="#DSN3#">
			SELECT MAX(OPP_ID) AS MAX_ID FROM OPPORTUNITIES
		</cfquery>
	</cftransaction>
</cflock>
<cf_workcube_process 
		is_upd='1' 
		old_process_line='0'
		process_stage='#get_stage.process_row_id#' 
		record_member='#session.pp.userid#' 
		record_date='#now()#' 
		action_table='OPPORTUNITIES'
		action_column='OPP_ID'
		action_id='#get_opp_max.max_id#'
		action_page='#request.self#?fuseaction=objects2.form_upd_opportunity&opp_id=#get_opp_max.max_id#' 
		warning_description='Fırsat : #get_opp_max.max_id#'>
<cfif attributes.is_popup eq 0 >
	<cflocation addtoken="no" url="#request.self#?fuseaction=objects2.form_upd_opportunity&opp_id=#get_opp_max.max_id#">
<cfelseif attributes.is_popup eq 1 >
	<script type="text/javascript">
		window.close();
	</script>
</cfif>

