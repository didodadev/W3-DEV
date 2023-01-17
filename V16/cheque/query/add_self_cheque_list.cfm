<cf_get_lang_set module_name="cheque">
<cfquery name="CONTROL_CHEQUE_NO" datasource="#DSN2#">
	SELECT CHEQUE_ID FROM CHEQUE WHERE ACCOUNT_ID = #attributes.account_id# AND CHEQUE_NO = '#attributes.cheque_no#'
</cfquery>
<cfif control_cheque_no.recordCount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='264.Bu Bankaya Kayıtlı Aynı Numaralı Bir Çek Mevcuttur Çek Bilgilerinizi Kontrol Ediniz'>!");
		history.go(-1);		
	</script>
	<cfabort>
</cfif>
<cfscript>
	for(a_sy = 1; a_sy lte attributes.kur_say; a_sy = a_sy + 1)
	{
		'attributes.txt_rate1_#a_sy#' = filterNum(evaluate('attributes.txt_rate1_#a_sy#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate2_#a_sy#' = filterNum(evaluate('attributes.txt_rate2_#a_sy#'),session.ep.our_company_info.rate_round_num);
	}
</cfscript>
<cfscript>
	money_type = listfirst(attributes.cheque_currency,";");
	currency_multiplier = '';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.other_money#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}		
</cfscript>
<cf_date tarih='attributes.CHEQUE_DUEDATE'>
<cfquery name="get_payroll" datasource="#DSN2#">
	SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE = 106 AND PAYROLL_NO  = '-2'
</cfquery>
<cfif get_payroll.recordcount>
	<cfset p_id=get_payroll.ACTION_ID> 
<cfelse>
	<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_REVENUE_TO_PAYROLL" datasource="#DSN2#">
			INSERT INTO
			PAYROLL
			(
				PAYROLL_NO,
				PAYROLL_TOTAL_VALUE,
				NUMBER_OF_CHEQUE,
				CURRENCY_ID,
				PAYROLL_REVENUE_DATE,
				PAYROLL_TYPE,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE
			)
			VALUES
			(
				'-2',
				#CHEQUE_VALUE#,
				1,
				'#session.ep.money#',
				#attributes.CHEQUE_DUEDATE#,
				106,
				#session.ep.userid#,
				'#cgi.remote_addr#',
				#now()#
			)
		</cfquery>
		<cfquery name="GET_BORDRO_ID" datasource="#DSN2#">
			SELECT MAX(ACTION_ID) AS P_ID FROM PAYROLL
		</cfquery>
		<cfset p_id = get_bordro_id.P_ID> 
	</cftransaction>
	</cflock> 
</cfif>

<cfset portfoy_no = get_cheque_no(belge_tipi:'cheque')>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_SELF_CHEQUES" datasource="#DSN2#">
			INSERT INTO
			CHEQUE
			(
				CHEQUE_PAYROLL_ID,
				CHEQUE_CODE,
				CHEQUE_DUEDATE,
				CHEQUE_NO,
				COMPANY_ID,
				CONSUMER_ID,
				CHEQUE_VALUE,
				CURRENCY_ID,
				CHEQUE_STATUS_ID,
				BANK_NAME,
				BANK_BRANCH_NAME,
				ACCOUNT_ID,
				ACCOUNT_NO,
				CHEQUE_CITY,
				CHEQUE_PURSE_NO,
				DEBTOR_NAME,
				OTHER_MONEY_VALUE,
				OTHER_MONEY,
				OTHER_MONEY_VALUE2,
				OTHER_MONEY2,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE
			)
			VALUES
			(
				#p_id#,
				'#attributes.CHEQUE_CODE#',
				#attributes.CHEQUE_DUEDATE#,
				'#CHEQUE_NO#',
				<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
				#CHEQUE_VALUE#,
				'#money_type#',
				6,
				'#attributes.bank_name#',
				'#attributes.bank_branch_name#',
				#form.account_id#,
				<cfif isDefined("form.account_no") and len(form.account_no)>'#form.account_no#',<cfelse>NULL,</cfif>
				'#CHEQUE_CITY#',
				'#portfoy_no#',
				'#session.ep.company#',
				#attributes.cheque_other_currency_value#,
				'#session.ep.money#',
				<cfif len(currency_multiplier)>
					#wrk_round(attributes.cheque_other_currency_value/currency_multiplier)#,
					'#session.ep.money2#',	
				<cfelse>
					NULL,
					NULL,
				</cfif>			
				#session.ep.userid#,
				'#cgi.remote_addr#',
				#now()#
			)
		</cfquery>
		<cfset portfoy_no = get_cheque_no(belge_tipi:'cheque',belge_no:portfoy_no+1)>
			
		<cfquery name="GET_LAST_CHEQUES" datasource="#DSN2#">
			SELECT MAX(CHEQUE_ID) AS CHEQUE_ID FROM CHEQUE
		</cfquery>
		
		<cfquery name="ADD_CHEQUE_HISTORY" datasource="#DSN2#">
			INSERT INTO
			CHEQUE_HISTORY
			(
				CHEQUE_ID,
				PAYROLL_ID,
				COMPANY_ID,
				CONSUMER_ID,
				STATUS,
				ACT_DATE,
				CURRENCY_ID,
				CURRENCY_ID_VALUE,
				OTHER_MONEY_VALUE,
				OTHER_MONEY,
				OTHER_MONEY_VALUE2,
				OTHER_MONEY2,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE
			)
			VALUES
			(
				#GET_LAST_CHEQUES.CHEQUE_ID#,
				#p_id#,
				<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
				6,
				#attributes.CHEQUE_DUEDATE#,
				'#money_type#',
				#CHEQUE_VALUE#,
				#attributes.cheque_other_currency_value#,
				'#session.ep.money#',
				<cfif len(currency_multiplier)>
					#wrk_round(attributes.cheque_other_currency_value/currency_multiplier)#,
					'#session.ep.money2#',	
				<cfelse>
					NULL,
					NULL,
				</cfif>		
				#session.ep.userid#,
				'#cgi.remote_addr#',
				#now()#
			)
		</cfquery>
		<cfloop from="1" to="#attributes.kur_say#" index="i">
			<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
				INSERT INTO CHEQUE_MONEY 
				(
					ACTION_ID,
					MONEY_TYPE,
					RATE2,
					RATE1,
					IS_SELECTED
				)
				VALUES
				(
					#GET_LAST_CHEQUES.CHEQUE_ID#,
					'#wrk_eval("attributes.other_money#i#")#',
					#evaluate("attributes.txt_rate2_#i#")#,
					#evaluate("attributes.txt_rate1_#i#")#,
					<cfif evaluate("attributes.other_money#i#") is money_type>1<cfelse>0</cfif>
				)
			</cfquery>
		</cfloop>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script> 
<cf_get_lang_set module_name="cheque">

