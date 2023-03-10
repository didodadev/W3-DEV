<cfif len(attributes.DATE)>
	<CF_DATE tarih="attributes.DATE">
</cfif>
<cfif len(attributes.apology_date)>
	<cf_date tarih="attributes.apology_date">
</cfif>
<cftransaction>
<cfquery name="ADD_CAUTION" datasource="#DSN#">
	UPDATE 
  		EMPLOYEES_CAUTION 
	SET
		WARNER = <cfif LEN(attributes.WARNER_ID)>#attributes.WARNER_ID#,<cfelse>NULL,</cfif>
		CAUTION_TYPE_ID = <cfif isdefined("attributes.CAUTION_TYPE") and LEN(attributes.CAUTION_TYPE)>#attributes.CAUTION_TYPE#,<cfelse>NULL,</cfif>
		CAUTION_DATE = <cfif LEN(attributes.DATE)>#attributes.DATE#,<cfelse>NULL,</cfif>
		CAUTION_TO = <cfif LEN(attributes.CAUTION_TO_ID)>#attributes.CAUTION_TO_ID#,<cfelse>NULL,</cfif>
		CAUTION_HEAD = '#attributes.CAUTION_HEAD#',
		CAUTION_DETAIL = <cfif LEN(attributes.CAUTION_DETAIL)>'#attributes.CAUTION_DETAIL#',<cfelse>NULL,</cfif>
		APOLOGY='#attributes.apol#',
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_DATE = #NOW()#,
		WARNER_NAME=<cfif LEN(attributes.WARNER)>'#attributes.WARNER#',<cfelse>NULL,</cfif>
		DECISION_NO=<cfif LEN(attributes.DECISION_NO)>'#attributes.DECISION_NO#',<cfelse>NULL,</cfif>
		IS_DISCIPLINE_CENTER=<cfif isdefined("attributes.is_discipline_center")>1,<cfelse>0,</cfif>
		IS_DISCIPLINE_BRANCH=<cfif isdefined("attributes.is_discipline_branch")>1<cfelse>0</cfif>,
        STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
        APOLOGY_DATE = <cfif len(attributes.apology_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.apology_date#"><cfelse>NULL</cfif>,
        IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
        SPECIAL_DEFINITION_ID = <cfif len(attributes.special_definition)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_definition#"><cfelse>NULL</cfif>,
		INTERRUPTION_ID = <cfif len(attributes.interruption_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.interruption_id#"><cfelse>NULL</cfif>,
		INTERRUPTION_DIVIDEND = <cfif len(attributes.interruption_dividend)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.interruption_dividend#"><cfelse>NULL</cfif>,
		INTERRUPTION_DENOMINATOR = <cfif len(attributes.interruption_denominator)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.interruption_denominator#"><cfelse>NULL</cfif>
  WHERE
  		CAUTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.caution_id#">
</cfquery>	
<cfquery name="DELETE_SALARYPARAM" datasource="#dsn#">
	DELETE FROM SALARYPARAM_GET WHERE CAUTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.caution_id#">
</cfquery>
<!--- ??cret kesintisi yap??lacaksa kesinti olarak at??l??r --->
<cfif len(attributes.interruption_id) and len(attributes.interruption_dividend) and len(attributes.interruption_denominator)>
	<cfset allowance_expense_cmp = createObject("component","V16.myhome.cfc.allowance_expense") /><!--- kesinti cmp --->
	<cfset get_payments_cmp = createObject("component","V16.hr.ehesap.cfc.get_payments") /><!--- ??denek Tan??mlar?? --->
	<cfset get_interruption = get_payments_cmp.SETUP_PAYMENT_INTERRUPTION(odkes_id : attributes.interruption_id)><!--- Kesinti Bilgileri --->
	<cfset get_in_out_id  = allowance_expense_cmp.GET_IN_OUT_ID(attributes.caution_to_id,0)><!--- In out Id --->
	<cfset attributes.sal_mon = month(attributes.DATE)>
	<cfset attributes.sal_year = year(attributes.DATE)>
	<cfif get_interruption.recordcount>
		<cfset add_interruption = allowance_expense_cmp.ADD_SALARYPARAM_GET(
			comment_get : get_interruption.comment_pay,<!--- Kesinti ??smi --->
			comment_get_id : get_interruption.odkes_id,<!---Kesinti Id --->
			amount_get : get_interruption.amount_pay,<!--- kesitni ??creti --->
			total_get : get_interruption.amount_pay,<!--- kesitni ??creti --->
			period_get : get_interruption.period_pay, <!--- 1: ayda 1, 2 : 3 ayda 1 , 3 : 6 ayda 1, 4 : y??lda 1---> 
			method_get : get_interruption.method_pay,  <!--- 1: eksi, 2 : ay , 3 : g??n, 4 : saat---> 
			show : get_interruption.show,  <!--- bordroda g??r??ns??n ---> 
			start_sal_mon : attributes.sal_mon,<!--- Ba??lang???? Ay?? --->
			end_sal_mon : attributes.sal_mon,<!--- Biti?? Ay?? --->
			employee_id : attributes.caution_to_id,<!--- ??al????an id --->
			term : attributes.sal_year,<!--- y??l --->
			calc_days : get_interruption.calc_days,<!---tutar g??n?? 0 : t??m??, 1: g??n,2 : fiili g??n --->
			from_salary : get_interruption.from_salary, <!--- 0 :net,1 : br??t --->
			in_out_id : get_in_out_id.in_out_id,<!--- Giri?? ????k???? id --->
			is_inst_avans : get_interruption.is_inst_avans,<!--- Taksitlendirilmi?? Avans --->
			is_ehesap : get_interruption.is_ehesap,<!--- ??st d??zey ik yetkisi 1 : dahi, 0 :dahil de??il--->
			money : get_interruption.MONEY,<!--- Para birimi--->
			tax : get_interruption.tax,<!--- vergi 1 : muaf, 2: muaf de??il--->
			coution_id : attributes.caution_id,<!--- disiplin i??lemleri id --->
			detail : attributes.caution_head<!--- a????klama --->
		)>
	</cfif>
</cfif>
<cf_wrk_get_history datasource="#dsn#" source_table="EMPLOYEES_CAUTION" target_table="EMPLOYEES_CAUTION_HISTORY" record_id= "#attributes.caution_id#" record_name="CAUTION_ID">
<cf_workcube_process 
	is_upd='1' 
	data_source='#dsn#' 
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#'
	record_date='#now()#' 
	action_table='EMPLOYEES_CAUTION'
	action_column='CAUTION_ID'
	action_id='#attributes.caution_id#' 
	action_page='#request.self#?fuseaction=ehesap.list_caution&event=upd&caution_id=#attributes.caution_id#' 
	warning_description='#getLang("","",61355)#: #attributes.caution_id#'>
</cftransaction>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.list_caution&event=upd&caution_id=#attributes.caution_id#</cfoutput>';
</script>

