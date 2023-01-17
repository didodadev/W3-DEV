<cf_get_lang_set module_name="cheque"><!--- sayfanin en altinda kapanisi var --->
<!--- Banka Subesine ait cek no kontrolu --->
<cfquery name="CONTROL_CHEQUE_NO" datasource="#DSN2#">
	SELECT 
		CHEQUE_ID 
	FROM 
		CHEQUE 
	WHERE 
		ACCOUNT_ID = #attributes.account_id# 
		AND CHEQUE_NO = '#attributes.cheque_no#' 
		AND CHEQUE_ID <> #attributes.cheque_id#
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
<cf_date tarih = 'attributes.CHEQUE_DUEDATE'>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="UPD_SELF_CHEQUES" datasource="#dsn2#">
			UPDATE CHEQUE
			SET
				CHEQUE_CODE ='#CHEQUE_CODE#',
				CHEQUE_DUEDATE = #attributes.CHEQUE_DUEDATE#,
				CHEQUE_NO = '#CHEQUE_NO#',
				COMPANY_ID = <cfif len(form.company_id)>#form.company_id#<cfelse>NULL</cfif>,
				CONSUMER_ID = <cfif len(form.consumer_id)>#form.consumer_id#<cfelse>NULL</cfif>,
				CHEQUE_VALUE = #CHEQUE_VALUE#,
				CURRENCY_ID = '#listfirst(attributes.cheque_currency,";")#',
				CHEQUE_STATUS_ID = 6,
				BANK_NAME = '#attributes.bank_name#',
				BANK_BRANCH_NAME = '#attributes.bank_branch_name#',
				ACCOUNT_ID = #form.ACCOUNT_ID#,
				ACCOUNT_NO = <cfif isDefined("form.account_no") and len(form.account_no)>'#form.account_no#',<cfelse>NULL,</cfif>
				OTHER_MONEY_VALUE = #attributes.cheque_other_currency_value#,
				OTHER_MONEY = '#session.ep.money#',
				OTHER_MONEY_VALUE2=#wrk_round(attributes.cheque_other_currency_value/currency_multiplier)#,
				OTHER_MONEY2='#session.ep.money2#',	
				CHEQUE_CITY = '#CHEQUE_CITY#',
				UPDATE_EMP=#session.ep.userid#,
				UPDATE_IP='#CGI.REMOTE_ADDR#',
				UPDATE_DATE=#NOW()#
			WHERE
				CHEQUE_ID = #form.cheque_id#
		</cfquery>
		<!--- iade edilen cekler icin kontrol edilecek --->
		<cfquery name="GET_CHEQUE_HISTORY" datasource="#dsn2#" maxrows="1">
			SELECT 
				HISTORY_ID 
			FROM 
				CHEQUE_HISTORY 
			WHERE 
				CHEQUE_ID = #form.cheque_id# 
				AND PAYROLL_ID=#form.payroll_id#
			ORDER BY HISTORY_ID ASC
		</cfquery>
		<cfquery name="UPD_CHEQUE_HISTORY" datasource="#dsn2#">
			UPDATE	
				CHEQUE_HISTORY
			SET
				CURRENCY_ID_VALUE = #CHEQUE_VALUE#,
				CURRENCY_ID = '#listfirst(attributes.cheque_currency,";")#',
				OTHER_MONEY_VALUE = #attributes.cheque_other_currency_value#,
				OTHER_MONEY = '#session.ep.money#',
				OTHER_MONEY_VALUE2=#wrk_round(attributes.cheque_other_currency_value/currency_multiplier)#,
				OTHER_MONEY2='#session.ep.money2#',
				UPDATE_EMP=#session.ep.userid#,
				UPDATE_IP='#CGI.REMOTE_ADDR#',
				UPDATE_DATE=#NOW()#
			WHERE
				HISTORY_ID=#GET_CHEQUE_HISTORY.HISTORY_ID#
		</cfquery>
		<!--- //iade edilen cekler icin kontrol edilecek --->
		<cfquery name="del_money" datasource="#dsn2#">
			DELETE FROM CHEQUE_MONEY WHERE ACTION_ID = #form.cheque_id#
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
					#form.cheque_id#,
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
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

