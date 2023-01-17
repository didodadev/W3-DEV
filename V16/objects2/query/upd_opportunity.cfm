<cfif attributes.active_company neq session.pp.company_id>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1445.İşlemin Muhasebe Dönemi İle Aktif Muhasebe Döneminiz Farklı...Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=objects2.list_opportunities</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfif len(attributes.opp_date)><cf_date tarih="attributes.opp_date"></cfif>
<cfinclude template="add_opportunity_history.cfm">
<cfquery name="UPD_OPPORTUNITY" datasource="#DSN3#">
	UPDATE
		OPPORTUNITIES
	SET
		OPPORTUNITY_TYPE_ID = <cfif len(attributes.opportunity_type_id)>#attributes.opportunity_type_id#<cfelse>NULL</cfif>,
        PARTNER_ID = <cfif isDefined('attributes.to_par_ids') and len(attributes.to_par_ids)>#attributes.to_par_ids#<cfelse>NULL</cfif>,
		COMPANY_ID = <cfif isDefined('attributes.to_comp_ids') and len(attributes.to_comp_ids)>#attributes.to_comp_ids#<cfelse>NULL</cfif>,	
		CONSUMER_ID = <cfif isDefined('attributes.to_cons_ids') and len(attributes.to_cons_ids)>#attributes.to_cons_ids#<cfelse>NULL</cfif>,
		<!---PARTNER_ID = <cfif len(attributes.partner_id) and len(attributes.member_name)>#attributes.partner_id#<cfelse>NULL</cfif>,
		COMPANY_ID = <cfif len(attributes.company_id) and len(attributes.member_name)>#attributes.company_id#<cfelse>NULL</cfif>,	
		CONSUMER_ID = <cfif len(attributes.consumer_id) and len(attributes.member_name)>#attributes.consumer_id#<cfelse>NULL</cfif>,--->
		COMMETHOD_ID = <cfif len(attributes.commethod_id)>#attributes.commethod_id#<cfelse>NULL</cfif>,
		OPP_DETAIL = <cfif len(attributes.opp_detail)>'#attributes.opp_detail#'<cfelse>NULL</cfif>,
		INCOME = <cfif len(attributes.income)>#attributes.income#<cfelse>NULL</cfif>,
		MONEY = <cfif len(attributes.money) and len(attributes.income)>'#attributes.money#'<cfelse>NULL</cfif>,
		COST = <cfif len(attributes.cost)>#attributes.cost#<cfelse>NULL</cfif>,
		MONEY2 = <cfif len(attributes.money2) and len(attributes.cost)>'#attributes.money2#'<cfelse>NULL</cfif>,
		SALES_PARTNER_ID = <cfif isDefined('attributes.sales_partner_id') and len(attributes.sales_partner_id)>#attributes.sales_partner_id#<cfelse>NULL</cfif>,
		OPP_DATE = <cfif len(attributes.opp_date)>#attributes.opp_date#<cfelse>NULL</cfif>,
		OPP_CURRENCY_ID = <cfif len(attributes.opp_currency_id)>#attributes.opp_currency_id#<cfelse>NULL</cfif>,
		OPP_STATUS = <cfif isDefined("attributes.opp_status")>1<cfelse>0</cfif>,
		ACTIVITY_TIME = <cfif len(attributes.activity_time)>#attributes.activity_time#<cfelse>NULL</cfif>,
		PROBABILITY = <cfif len(attributes.probability)>#attributes.probability#<cfelse>NULL</cfif>,
		OPP_HEAD = '#attributes.opp_head#',
		OPP_ZONE = 0,
		PROJECT_ID = <cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
		OPP_NO = '#attributes.opportunity_no#',
		SALE_ADD_OPTION_ID = <cfif len(attributes.sales_add_option)>#attributes.sales_add_option#<cfelse>NULL</cfif>,
		UPDATE_PAR = #session.pp.userid#,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#
	WHERE
		OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.opp_id#">
</cfquery>
<cflocation url="#request.self#?fuseaction=objects2.form_upd_opportunity&opp_id=#opp_id#" addtoken="no"> 
