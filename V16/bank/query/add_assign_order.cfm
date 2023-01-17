<cf_get_lang_set module_name="bank"><!--- sayfanin en altinda kapanisi var --->
<cfif form.active_period neq session.ep.period_id>
    <script type="text/javascript">
        alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
        <!---Toplu Ödeme Performansından geldiğinde Sorun Olmasın diye eklendi.--->
        <cfif fusebox.circuit contains 'report'>
            window.history.back();
        <cfelse>
            window.location.href='<cfoutput>#request.self#?fuseaction=bank.list_assign_order</cfoutput>';
        </cfif>
    </script>
    <cfabort>
</cfif>
<cfquery name="get_process_type" datasource="#dsn2#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE
	 FROM 
	 	#dsn3_alias#.SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	is_account = get_process_type.IS_ACCOUNT;
	is_cari = get_process_type.IS_CARI;
</cfscript>
<cfset attributes.acc_type_id = "">
<cfscript>
	if(isDefined("attributes.employee_id") and listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}
</cfscript>
<cfif (is_account eq 1)>
	<cfif len(attributes.COMPANY_ID)><!--- firmanın muhasebe kodu --->
		<cfset borclu_hesap = GET_COMPANY_PERIOD(attributes.COMPANY_ID)>
	<cfelseif len(attributes.CONSUMER_ID)><!---bireysel uyenin muhasebe kodu--->
		<cfset borclu_hesap = GET_CONSUMER_PERIOD(attributes.CONSUMER_ID)>
	<cfelseif len(attributes.EMPLOYEE_ID) ><!---çalışanın muhasebe kodu--->
		<cfset borclu_hesap = GET_EMPLOYEE_PERIOD(attributes.EMPLOYEE_ID, attributes.ACC_TYPE_ID)>
	</cfif>
	<cfif not len(borclu_hesap)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='393.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>!");
			history.back();	
		</script>
		<cfabort>
	</cfif>
	<cfif len(attributes.account_id)>
		<cfquery name="GET_BANK_ORDER_CODE" datasource="#dsn2#">
			SELECT ACCOUNT_ORDER_CODE FROM #dsn3_alias#.ACCOUNTS WHERE ACCOUNT_ID = #attributes.account_id#
		</cfquery>
		<cfif not len(GET_BANK_ORDER_CODE.ACCOUNT_ORDER_CODE)>
			<script type="text/javascript">
				alert("<cf_get_lang no ='388.Seçtiğiniz Banka Hesabının Talimat Muhasebe Kodu Seçilmemiş'>!");
				history.back();	
			</script>
			<cfabort>
		</cfif>
	</cfif>
</cfif>
<cfif len(attributes.company_id)>
	<cfquery name="get_bank" datasource="#dsn2#">
		SELECT 
			COMPANY_BANK_ID AS BANK_ID
		 FROM 
			#dsn_alias#.COMPANY_BANK
		WHERE 
			COMPANY_ID = #attributes.company_id#
			AND COMPANY_ACCOUNT_DEFAULT = 1
			AND COMPANY_BANK_MONEY = '#attributes.currency_id#'
	</cfquery>
<cfelseif len(attributes.consumer_id)> 
	<cfquery name="get_bank" datasource="#dsn2#">
		SELECT 
			CONSUMER_BANK_ID AS BANK_ID
		 FROM 
			#dsn_alias#.CONSUMER_BANK
		WHERE 
			CONSUMER_ID = #attributes.consumer_id#
			AND CONSUMER_ACCOUNT_DEFAULT = 1
			AND MONEY = '#attributes.currency_id#'
	</cfquery>
</cfif>
<cfif not isdefined("is_from_premium")>
	<cf_date tarih='attributes.ACTION_DATE'>
	<cf_date tarih='attributes.PAYMENT_DATE'>
</cfif>
<cfscript>
	paper_currency_multiplier = 0;
	if(not isDefined("is_from_makeage"))
	{
		attributes.ORDER_AMOUNT = filterNum(attributes.ORDER_AMOUNT);
		attributes.OTHER_CASH_ACT_VALUE = filterNum(attributes.OTHER_CASH_ACT_VALUE);
		attributes.system_amount = filterNum(attributes.system_amount);
		for(d_sy=1; d_sy lte attributes.kur_say; d_sy=d_sy+1)
		{
			'attributes.txt_rate1_#d_sy#' = filterNum(evaluate('attributes.txt_rate1_#d_sy#'),session.ep.our_company_info.rate_round_num);
			'attributes.txt_rate2_#d_sy#' = filterNum(evaluate('attributes.txt_rate2_#d_sy#'),session.ep.our_company_info.rate_round_num);
			if(evaluate("attributes.hidden_rd_money_#d_sy#") is attributes.money_type)
				paper_currency_multiplier = evaluate('attributes.txt_rate2_#d_sy#/attributes.txt_rate1_#d_sy#');
		}
	}
	if(isdefined("attributes.branch_id") and len(attributes.branch_id))
		branch_id_info = attributes.branch_id;
	else
		branch_id_info = listgetat(session.ep.user_location,2,'-');
</cfscript>
<!--- Action file larda sorun oluyordu bloklara ayırmak zorunda kaldık Özden-Sevda --->

	<cflock name="#CREATEUUID()#" timeout="60">
		<cftransaction>
			<cfinclude template="add_assign_order_ic.cfm">
		</cftransaction>
	</cflock>
<!---
<cfif not isdefined("is_transaction")>
<cfelse>
	<cfinclude template="add_assign_order_ic.cfm">
</cfif>
--->

<cfif not isDefined("is_from_makeage")>
	<cfset attributes.actionId=MAX_ID.IDENTITYCOL>
	<script type="text/javascript">
		window.location.href = "<cfoutput>#request.self#?fuseaction=bank.list_assign_order&event=upd_incoming&bank_order_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
