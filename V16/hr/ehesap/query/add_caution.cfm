<cfif len(attributes.DATE)>
	<CF_DATE tarih="attributes.DATE">
</cfif>
<cftransaction>
<cfquery name="ADD_CAUTION" datasource="#DSN#" result="MAX_ID">
  INSERT INTO
 	EMPLOYEES_CAUTION
	(
		WARNER,
		CAUTION_TYPE_ID,
		CAUTION_DATE,
		CAUTION_TO,
		CAUTION_HEAD,
		CAUTION_DETAIL,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE,
		WARNER_NAME,
		DECISION_NO,
		IS_DISCIPLINE_CENTER,
		IS_DISCIPLINE_BRANCH,
        STAGE,
        IS_ACTIVE,
        SPECIAL_DEFINITION_ID,
		INTERRUPTION_DIVIDEND,
		INTERRUPTION_DENOMINATOR,
		INTERRUPTION_ID
	)
  VALUES
    (
		<cfif LEN(attributes.warner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.warner_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
		<cfif isdefined("attributes.caution_type") and LEN(attributes.caution_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.caution_type#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
		<cfif LEN(attributes.date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date#"><cfelse>NULL</cfif>,
		<cfif LEN(attributes.caution_to_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.caution_to_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.caution_head#">,
		<cfif LEN(attributes.caution_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.caution_detail#"><cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		<cfif len(attributes.warner)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.warner#"><cfelse>NULL</cfif>,
		<cfif len(attributes.decision_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.decision_no#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.is_discipline_centre")>1,<cfelse>0,</cfif>
		<cfif isdefined("attributes.is_discipline_branch")>1<cfelse>0</cfif>,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
        <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
        <cfif len(attributes.special_definition)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_definition#"><cfelse>NULL</cfif>,
		<cfif len(attributes.interruption_dividend)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.interruption_dividend#"><cfelse>NULL</cfif>,
		<cfif len(attributes.interruption_denominator)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.interruption_denominator#"><cfelse>NULL</cfif>,
		<cfif len(attributes.interruption_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.interruption_id#"><cfelse>NULL</cfif>
	)
</cfquery>	

<!--- ücret kesintisi yapılacaksa kesinti olarak atılır --->
<cfif len(attributes.interruption_id) and len(attributes.interruption_dividend) and len(attributes.interruption_denominator)>
	<cfset allowance_expense_cmp = createObject("component","V16.myhome.cfc.allowance_expense") /><!--- kesinti cmp --->
	<cfset get_payments_cmp = createObject("component","V16.hr.ehesap.cfc.get_payments") /><!--- Ödenek Tanımları --->
	<cfset get_interruption = get_payments_cmp.SETUP_PAYMENT_INTERRUPTION(odkes_id : attributes.interruption_id)><!--- Kesinti Bilgileri --->
	<cfset get_in_out_id  = allowance_expense_cmp.GET_IN_OUT_ID(attributes.caution_to_id,0)><!--- In out Id --->
	<cfset attributes.sal_mon = month(attributes.DATE)>
	<cfset attributes.sal_year = year(attributes.DATE)>
	<cfif get_interruption.recordcount>
		<cfset add_interruption = allowance_expense_cmp.ADD_SALARYPARAM_GET(
			comment_get : get_interruption.comment_pay,<!--- Kesinti İsmi --->
			comment_get_id : get_interruption.odkes_id,<!---Kesinti Id --->
			amount_get : get_interruption.amount_pay,<!--- kesitni ücreti --->
			total_get : get_interruption.amount_pay,<!--- kesitni ücreti --->
			period_get : get_interruption.period_pay, <!--- 1: ayda 1, 2 : 3 ayda 1 , 3 : 6 ayda 1, 4 : yılda 1---> 
			method_get : get_interruption.method_pay,  <!--- 1: eksi, 2 : ay , 3 : gün, 4 : saat---> 
			show : get_interruption.show,  <!--- bordroda görünsün ---> 
			start_sal_mon : attributes.sal_mon,<!--- Başlangıç Ayı --->
			end_sal_mon : attributes.sal_mon,<!--- Bitiş Ayı --->
			employee_id : attributes.caution_to_id,<!--- çalışan id --->
			term : attributes.sal_year,<!--- yıl --->
			calc_days : get_interruption.calc_days,<!---tutar günü 0 : tümü, 1: gün,2 : fiili gün --->
			from_salary : get_interruption.from_salary, <!--- 0 :net,1 : brüt --->
			in_out_id : get_in_out_id.in_out_id,<!--- Giriş çıkış id --->
			is_inst_avans : get_interruption.is_inst_avans,<!--- Taksitlendirilmiş Avans --->
			is_ehesap : get_interruption.is_ehesap,<!--- üst düzey ik yetkisi 1 : dahi, 0 :dahil değil--->
			money : get_interruption.MONEY,<!--- Para birimi--->
			tax : get_interruption.tax,<!--- vergi 1 : muaf, 2: muaf değil--->
			coution_id : MAX_ID.IDENTITYCOL,<!--- disiplin işlemleri id --->
			detail : attributes.caution_head<!--- açıklama --->
		)>
	</cfif>
</cfif>
<!--- history icin --->
<cfquery name="add_caution_history" datasource="#dsn#">
	INSERT INTO EMPLOYEES_CAUTION_HISTORY (CAUTION_ID,CAUTION_TYPE_ID,CAUTION_DATE,WARNER,CAUTION_TO,CAUTION_DETAIL,RECORD_DATE,RECORD_IP,RECORD_EMP,UPDATE_DATE,UPDATE_IP,UPDATE_EMP,CAUTION_HEAD,WARNER_NAME,DECISION_NO,IS_DISCIPLINE_CENTER,IS_DISCIPLINE_BRANCH,APOLOGY,STAGE,APOLOGY_DATE,IS_ACTIVE,SPECIAL_DEFINITION_ID)
    SELECT CAUTION_ID,CAUTION_TYPE_ID,CAUTION_DATE,WARNER,CAUTION_TO,CAUTION_DETAIL,RECORD_DATE,RECORD_IP,RECORD_EMP,UPDATE_DATE,UPDATE_IP,UPDATE_EMP,CAUTION_HEAD,WARNER_NAME,DECISION_NO,IS_DISCIPLINE_CENTER,IS_DISCIPLINE_BRANCH,APOLOGY,STAGE,APOLOGY_DATE,IS_ACTIVE,SPECIAL_DEFINITION_ID FROM EMPLOYEES_CAUTION WHERE CAUTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">
</cfquery>
<cf_workcube_process 
	is_upd='1' 
	data_source='#dsn#' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#'
	record_date='#now()#' 
	action_table='EMPLOYEES_CAUTION'
	action_column='CAUTION_ID'
	action_id='#MAX_ID.IDENTITYCOL#' 
	action_page='#request.self#?fuseaction=ehesap.list_caution&event=upd&caution_id=#MAX_ID.IDENTITYCOL#' 
	warning_description='#getLang("","",61355)#: #MAX_ID.IDENTITYCOL#'>
</cftransaction>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.list_caution&event=upd&caution_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
</script>

