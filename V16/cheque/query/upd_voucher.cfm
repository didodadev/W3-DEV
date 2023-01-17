<cfscript>
	currency_multiplier = '';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			'attributes.txt_rate1_#mon#' = filterNum(evaluate('attributes.txt_rate1_#mon#'),session.ep.our_company_info.rate_round_num);
			'attributes.txt_rate2_#mon#' = filterNum(evaluate('attributes.txt_rate2_#mon#'),session.ep.our_company_info.rate_round_num);
			if(evaluate("attributes.other_money#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}		
</cfscript>
<cfif isdefined("attributes.account_no") and len(attributes.account_no)>
	<cfquery name="get_bn" datasource="#DSN3#">
		SELECT
			BANK_BRANCH.BANK_NAME,
			BANK_BRANCH.BANK_BRANCH_NAME
		FROM
			BANK_BRANCH,
			ACCOUNTS
		WHERE 
			ACCOUNTS.ACCOUNT_ID=#attributes.account_no# AND
			ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID
	</cfquery>
	<cfif get_bn.recordcount>
		<cfset attributes.bank_name = get_bn.BANK_NAME>
		<cfset attributes.bank_branch_name = get_bn.BANK_BRANCH_NAME>
	<cfelse>
		<cfset attributes.bank_name = "">
		<cfset attributes.bank_branch_name = "">
	</cfif>
<cfelse>
	<cfset attributes.account_no = "">
</cfif>
<cfif not len(attributes.currency_id)>
	<cfset account_id=attributes.account_no>
	<cfif len(account_id) and isnumeric(account_id)>
		<cfinclude template="../query/get_action_account.cfm">
		<cfset attributes.currency_id = get_action_account.ACCOUNT_CURRENCY_ID>
	</cfif>
<cfelse>
	<cfset attributes.currency_id = listgetat(attributes.currency_id,1,';')>
</cfif>
<cfif not isdefined("attributes.acc_code")><cfset attributes.acc_code = ''></cfif>
<cfset money_list = attributes.kur_say & '-'>
<cfloop from="1" to="#attributes.kur_say#" index="i">
	<cfset money_list= money_list & '#evaluate("attributes.other_money#i#")#' & ',' & '#evaluate("attributes.txt_rate1_#i#")#' & ',' & '#evaluate("attributes.txt_rate2_#i#")#' & '-'>
</cfloop>
<cfif not isdefined("attributes.is_pay_term")><cfset attributes.is_pay_term = 0></cfif>
<cfoutput>
	<script type="text/javascript">
		eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.debtor_name'+#attributes.row#).value = '#attributes.debtor_name#';
		eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.voucher_city'+#attributes.row#).value = '#attributes.voucher_city#';
		eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.voucher_duedate'+#attributes.row#).value = '#attributes.voucher_duedate#';
		eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.voucher_value'+#attributes.row#).value = '#attributes.voucher_value#';
		eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.voucher_no'+#attributes.row#).value = '#attributes.voucher_no#';
		eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.voucher_code'+#attributes.row#).value = '#attributes.voucher_code#';
		eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.currency_id'+#attributes.row#).value = '#attributes.currency_id#';
		eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.voucher_id'+#attributes.row#).value = '#attributes.voucher_id#';
		eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.acc_code'+#attributes.row#).value = '#attributes.acc_code#';
		eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.from_voucher_info'+#attributes.row#).value = 0;
		eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.voucher_system_currency_value'+#attributes.row#).value = '#attributes.voucher_system_currency_value#';
		eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.system_money_info'+#attributes.row#).value = '#session.ep.money#';
		eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.other_money_value2'+#attributes.row#).value = '#wrk_round(filterNum(attributes.voucher_system_currency_value,session.ep.our_company_info.rate_round_num)/currency_multiplier)#';
		eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.other_money2'+#attributes.row#).value = '#session.ep.money2#';
		eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.money_list'+#attributes.row#).value = '#money_list#';
		eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.is_pay_term'+#attributes.row#).value = '#attributes.is_pay_term#';
		<cfif isDefined("attributes.self_voucher_") and attributes.self_voucher_ eq 1>eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.from_voucher_info'+#attributes.row#).value = 1;<cfelse>eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.from_voucher_info'+#attributes.row#).value = 0;</cfif>
		<cfif not isdefined("attributes.draggable")>window.opener.</cfif>cheque_rate_change();
		<cfif not isdefined("attributes.draggable")>window.opener.</cfif>toplam(1,0);
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	</script>
</cfoutput>
