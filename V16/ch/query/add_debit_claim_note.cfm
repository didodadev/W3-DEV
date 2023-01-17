<cfif not isDefined("is_from_premium")>
	<cfif form.active_period neq session.ep.period_id>
		<script type="text/javascript">
			alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
			wrk_opener_reload();
			window.close();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfquery name="get_process_type" datasource="#dsn2#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		PROCESS_CAT,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE
	 FROM 
	 	#dsn3_alias#.SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_type = get_process_type.process_type;
	is_cari =get_process_type.is_cari;
	is_account = get_process_type.is_account;
	ACTION_CURRENCY_ID = listlast(attributes.ACTION_CURRENCY_ID,';');
	attributes.acc_type_id = '';
	if(listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}
</cfscript>
<cfif not isdefined("is_from_premium")>
	<cf_date tarih="attributes.action_date">
</cfif>
<cfif is_account eq 1>
	<cfif len(form.COMPANY_ID)><!--- firmanın muhasebe kodu --->
		<cfset MY_ACC_RESULT=GET_COMPANY_PERIOD(form.COMPANY_ID)>
	<cfelseif len(attributes.employee_id)><!--- çalışanın muhasebe kodu--->
		<cfset MY_ACC_RESULT = GET_EMPLOYEE_PERIOD(attributes.employee_id,attributes.acc_type_id)>
	<cfelseif len(form.CONSUMER_ID)><!---bireysel uyenin muhasebe kodu--->
		<cfset MY_ACC_RESULT = GET_CONSUMER_PERIOD(form.CONSUMER_ID)>
	</cfif>
	<cfif not len(MY_ACC_RESULT)>
		<script type="text/javascript">
			alert("<cf_get_lang no='74.Seçtiğiniz Çalışan veya Üyenin Muhasebe Kodu Seçilmemiş'>!");
			history.back();	
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfscript>
	if(not isDefined("is_from_premium"))
	{
		attributes.action_value = filterNum(attributes.action_value);
		attributes.other_cash_act_value = filterNum(attributes.other_cash_act_value);
		attributes.system_amount = filterNum(attributes.system_amount);
		for(k_sy=1; k_sy lte attributes.kur_say; k_sy=k_sy+1)
		{
			'attributes.txt_rate1_#k_sy#' = filterNum(evaluate('attributes.txt_rate1_#k_sy#'),session.ep.our_company_info.rate_round_num);
			'attributes.txt_rate2_#k_sy#' = filterNum(evaluate('attributes.txt_rate2_#k_sy#'),session.ep.our_company_info.rate_round_num);
		}
	}
</cfscript>
<cfif not isdefined("is_from_premium")>
	<cf_papers paper_type="debit_claim">
	<cflock name="#CREATEUUID()#" timeout="60">
		<cftransaction>
			<cfinclude template="add_debit_claim_note_ic.cfm">
		</cftransaction>
	</cflock>
<cfelse>
	<cfinclude template="add_debit_claim_note_ic.cfm">
</cfif>
<cfif not isDefined("is_from_premium")>
	<cfif my_fuseaction contains 'popup'>
		<script type="text/javascript">
			wrk_opener_reload();
			self.close();
		</script>
	<cfelse>
		<script type="text/javascript">
			window.location.href='<cfoutput>#request.self#?fuseaction=ch.form_add_debit_claim_note&event=upd&id=#get_max.action_id#</cfoutput>';
		</script>
	</cfif>
</cfif>
