<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=bank.list_assign_order</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfset attributes.acc_type_id = ''> 
<cfscript>
	if(listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}
</cfscript>
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
	is_cari =get_process_type.IS_CARI;
	is_account = get_process_type.IS_ACCOUNT;
</cfscript>
<cfif (is_account eq 1)>
	<cfif len(attributes.COMPANY_ID)><!--- firmanın muhasebe kodu --->
		<cfset borclu_hesap = GET_COMPANY_PERIOD(attributes.COMPANY_ID)>
	<cfelseif len(attributes.CONSUMER_ID) ><!---bireysel uyenin muhasebe kodu--->
		<cfset borclu_hesap = GET_CONSUMER_PERIOD(attributes.CONSUMER_ID)>
	<cfelseif len(attributes.EMPLOYEE_ID) ><!---çalışanın muhasebe kodu--->
		<cfset borclu_hesap = GET_EMPLOYEE_PERIOD(attributes.EMPLOYEE_ID, attributes.ACC_TYPE_ID)>
	</cfif>
	<cfif not len(borclu_hesap)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='393.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>");
			history.back();	
		</script>
		<cfabort>
	</cfif>
	<cfif len(attributes.account_id)>
		<cfquery name="GET_BANK_ORDER_CODE" datasource="#dsn3#">
			SELECT ACCOUNT_ORDER_CODE FROM ACCOUNTS WHERE ACCOUNT_ID = #attributes.account_id#
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
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			AND COMPANY_ACCOUNT_DEFAULT = 1
			AND COMPANY_BANK_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">
	</cfquery>
<cfelseif len(attributes.consumer_id)> 
	<cfquery name="get_bank" datasource="#dsn2#">
		SELECT 
			CONSUMER_BANK_ID AS BANK_ID
		 FROM 
			#dsn_alias#.CONSUMER_BANK
		WHERE 
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			AND CONSUMER_ACCOUNT_DEFAULT = 1
			AND MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">
	</cfquery>
<cfelseif len(attributes.employee_id)>
	<cfquery name="get_bank" datasource="#dsn#">
    	SELECT
        	EMP_BANK_ID BANK_ID
        FROM
        	EMPLOYEES_BANK_ACCOUNTS
        WHERE
        	EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
            AND DEFAULT_ACCOUNT = 1
            AND MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">
    </cfquery>
</cfif>
<cf_date tarih='attributes.ACTION_DATE'>
<cf_date tarih='attributes.PAYMENT_DATE'>
<cfscript>
	paper_currency_multiplier = '';
	if(not isDefined("is_from_makeage"))
	{
		attributes.ORDER_AMOUNT = filterNum(attributes.ORDER_AMOUNT);
		attributes.OTHER_CASH_ACT_VALUE = filterNum(attributes.OTHER_CASH_ACT_VALUE);
		attributes.system_amount = filterNum(attributes.system_amount);
		for(e_sy=1; e_sy lte attributes.kur_say; e_sy=e_sy+1)
		{
			'attributes.txt_rate1_#e_sy#' = filterNum(evaluate('attributes.txt_rate1_#e_sy#'),session.ep.our_company_info.rate_round_num);
			'attributes.txt_rate2_#e_sy#' = filterNum(evaluate('attributes.txt_rate2_#e_sy#'),session.ep.our_company_info.rate_round_num);
			if(evaluate("attributes.hidden_rd_money_#e_sy#") is attributes.money_type)
				paper_currency_multiplier = evaluate('attributes.txt_rate2_#e_sy#/attributes.txt_rate1_#e_sy#');
		}
	}
	if(isdefined("attributes.branch_id") and len(attributes.branch_id))
		branch_id_info = attributes.branch_id;
	else
		branch_id_info = listgetat(session.ep.user_location,2,'-');
</cfscript>
<!--- Action file larda sorun oluyordu bloklara ayırmak zorunda kaldık Özden-Sevda --->
<cfif not isdefined("is_transaction")>
	<cflock name="#CREATEUUID()#" timeout="60">
		<cftransaction>
			<cfinclude template="upd_assign_order_ic.cfm">
		</cftransaction>
	</cflock>
<cfelse>
	<cfinclude template="upd_assign_order_ic.cfm">
</cfif>
<cfif not isDefined("is_from_makeage")>
	<cfset attributes.actionId=attributes.bank_order_id >
    <script type="text/javascript">
        window.location.href = "<cfoutput>#request.self#?fuseaction=bank.list_assign_order&event=upd_incoming&bank_order_id=attributes.bank_order_id</cfoutput>";
    </script>
</cfif>
