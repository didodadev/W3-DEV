<cfscript>
	for(a_sy = 1; a_sy lte attributes.kur_say; a_sy = a_sy + 1)
	{
		'attributes.txt_rate1_#a_sy#' = filterNum(evaluate('attributes.txt_rate1_#a_sy#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate2_#a_sy#' = filterNum(evaluate('attributes.txt_rate2_#a_sy#'),session.ep.our_company_info.rate_round_num);
	}
</cfscript>
<cfscript>
	currency_multiplier = '';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.other_money#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}		
</cfscript>
<cf_date tarih = 'attributes.voucher_duedate'>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="UPD_VOUCHERS" datasource="#dsn2#">
			UPDATE VOUCHER
			SET
				VOUCHER_CODE = <cfif len(attributes.voucher_code)>'#attributes.voucher_code#'<cfelse>NULL</cfif>,
				VOUCHER_DUEDATE = <cfif len(attributes.voucher_duedate)>#attributes.voucher_duedate#<cfelse>NULL</cfif>,
				VOUCHER_NO = <cfif len(attributes.voucher_no)>'#attributes.voucher_no#'<cfelse>NULL</cfif>,
				VOUCHER_VALUE = <cfif len(attributes.voucher_value)>#attributes.voucher_value#<cfelse>NULL</cfif>,
				CURRENCY_ID = '#listfirst(attributes.currency_id,';')#',
				OTHER_MONEY_VALUE =<cfif len(attributes.voucher_system_currency_value)>#attributes.voucher_system_currency_value#<cfelse>NULL</cfif>,
				OTHER_MONEY = <cfif len(attributes.voucher_system_currency_value)>'#session.ep.money#'<cfelse>NULL</cfif>,
				OTHER_MONEY_VALUE2 = <cfif len(attributes.voucher_system_currency_value)>#wrk_round(attributes.voucher_system_currency_value/currency_multiplier)#<cfelse>NULL</cfif>,
				OTHER_MONEY2 =<cfif len(attributes.voucher_system_currency_value)>'#session.ep.money2#'<cfelse>NULL</cfif>,
				VOUCHER_CITY =<cfif len(attributes.voucher_city)>'#attributes.voucher_city#'<cfelse>NULL</cfif>
			WHERE
				VOUCHER_ID = #form.voucher_id#
		</cfquery>
		<cfquery name="del_money" datasource="#dsn2#">
			DELETE FROM VOUCHER_MONEY WHERE ACTION_ID = #form.voucher_id#
		</cfquery>
		<cfloop from="1" to="#attributes.kur_say#" index="i">
			<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
				INSERT INTO VOUCHER_MONEY 
				(
					ACTION_ID,
					MONEY_TYPE,
					RATE2,
					RATE1,
					IS_SELECTED
				)
				VALUES
				(
					#form.voucher_id#,
					'#wrk_eval("attributes.other_money#i#")#',
					#evaluate("attributes.txt_rate2_#i#")#,
					#evaluate("attributes.txt_rate1_#i#")#,
					<cfif evaluate("attributes.other_money#i#") is listfirst(attributes.currency_id)>1<cfelse>0</cfif>
				)
			</cfquery>
		</cfloop>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script> 
