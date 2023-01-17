<cf_get_lang_set module_name="cheque">
<cfoutput>
<cfif not isdefined("attributes.payroll_entry")><!--- giris bordrosu dışından gelmeli --->
	<!--- baskette 2 tane aynı senet var mi kontrolü --->
	<script type="text/javascript">
		kontrol=0;
		<cfif isdefined("attributes.voucher_id") and len(attributes.voucher_id) and attributes.voucher_id neq 0>//<!--- senet kayıtlı ise --->
			for(tt=1;tt<=<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.record_num.value;tt++)
			{
				if('#attributes.voucher_id#' == eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.voucher_id'+tt).value)
				{
					kontrol = 1;
					break;
				}
			}
		</cfif>
		if (kontrol == 1)
		{
			alert("<cf_get_lang dictionary_id='50323.Aynı Senedi İkinci Kere Girmeye Çalışıyorsunuz !'>");
		}
	</script>
</cfif>	
<cfif isdefined("attributes.kur_say")>
<!--- Sistem 2. dövizini hesaplamak için kontroller hesaplamalar vs yapılıyor --->
	<cfscript>
		for(a_sy = 1; a_sy lte attributes.kur_say; a_sy = a_sy + 1)
		{
			'attributes.txt_rate1_#a_sy#' = filterNum(evaluate('attributes.txt_rate1_#a_sy#'),session.ep.our_company_info.rate_round_num);
			'attributes.txt_rate2_#a_sy#' = filterNum(evaluate('attributes.txt_rate2_#a_sy#'),session.ep.our_company_info.rate_round_num);
		}
		currency_multiplier = '';
		if(isDefined('attributes.kur_say') and len(attributes.kur_say))
			for(mon=1;mon lte attributes.kur_say;mon=mon+1)
			{
				if(evaluate("attributes.other_money#mon#") is session.ep.money2)
					currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			}		
	</cfscript>
</cfif>
<cfif isdefined("attributes.self_voucher_")>
	<cfset from_voucher_info = 1><!--- İlgili senetin defterinin sahibi senedi bize veren firmanin kendisi ise--->
<cfelse>
	<cfset from_voucher_info = 0><!--- Senedi bize veren firma cirolayarak vermisse --->
</cfif>
<cfset system_money_info = session.ep.money>
<cfset money_list = ''>
<cfset other_money_value2 = ''>
<cfif not isdefined("attributes.acc_code")><cfset attributes.acc_code = ''></cfif>
<cfif isdefined("attributes.kur_say")>
	<cfif len(currency_multiplier)>
		<cfset other_money_value2 = wrk_round(attributes.voucher_system_currency_value/currency_multiplier)><!--- Sistem dövizinden sistem 2. dövizi hesaplanıyor--->
	</cfif>
	<cfset other_money2 = session.ep.money2>
	<cfset money_list = attributes.kur_say & '-'>
	<cfloop from="1" to="#attributes.kur_say#" index="sss">
		<cfset money_list= money_list & '#evaluate("attributes.other_money#sss#")#' & ',' & '#evaluate("attributes.txt_rate1_#sss#")#' & ',' & '#evaluate("attributes.txt_rate2_#sss#")#' & '-'>
	</cfloop>
<cfelse>
	<cfif isdefined("attributes.voucher_other_money_value") and len(attributes.voucher_other_money_value)>
		<cfset other_money_value2 = attributes.voucher_other_money_value>
	<cfelse>
		<cfset other_money_value2 = ''>
	</cfif>
	<cfif isdefined("attributes.money_type") and len(attributes.money_type)>
		<cfset other_money2 = listfirst(attributes.money_type,';')>
	<cfelse>
		<cfset other_money2 = ''>
	</cfif>
	<cfset attributes.kur_say = "">
</cfif>
<cfif not isDefined("attributes.debtor_name")><cfset attributes.debtor_name = session.ep.company></cfif>
<cfset voucher_position = 1><!--- yeni ya da seçilen senet --->
<cfif isdefined("attributes.self_voucher")>
	<cfset attributes.voucher_status_id = 6><!---default status : ödenmedi--->
<cfelseif  isdefined("attributes.entry_ret") or isdefined("attributes.endor_ret") or isdefined("attributes.is_return") or isdefined("attributes.endorsement")>
	<cfset attributes.voucher_status_id = attributes.voucher_status_id>
<cfelse>
	<cfset attributes.voucher_status_id = 1><!---default status : portföyde--->
</cfif>
<cfif isdefined("attributes.voucher_id") and len(attributes.voucher_id)>
	<cfquery name="GET_NOTE" datasource="#dsn#">
		SELECT
			*
		FROM
			NOTES
		WHERE
			ACTION_SECTION = 'VOUCHER_ID' AND 
			ACTION_ID = #attributes.voucher_id# AND
			IS_WARNING = 1
		ORDER BY 
			ACTION_ID DESC
	</cfquery>
	<cfquery name="get_last_date" datasource="#dsn2#">
		SELECT
			MAX(ISNULL(ACT_DATE,RECORD_DATE)) ACT_DATE
		FROM
			VOUCHER_HISTORY
		WHERE
			VOUCHER_ID = #attributes.voucher_id#
	</cfquery>
	<cfset last_act_date = dateformat(get_last_date.act_date,dateformat_style)>
<cfelse>
	<cfset last_act_date = ''>
	<cfscript>
		get_note.recordcount = 0;
	</cfscript>
</cfif>
<script type="text/javascript">
	<cfif get_note.recordcount>
		window.open('<cfoutput>#request.self#?fuseaction=objects.popup_detail_company_note&voucher_id=#attributes.voucher_id#</cfoutput>','','scrollbars=0, resizable=0,width=500,height=500,left='+(screen.width-500)/2+',top='+(screen.height-500)/2+"'");
	</cfif>
</script>
<cfif not isdefined("attributes.is_pay_term")><cfset attributes.is_pay_term = 0></cfif>
<cfif not (isdefined("attributes.cash_id") and len(attributes.cash_id))>
	<cfif isdefined("attributes.cash_id_row")>
		<cfset attributes.cash_id = attributes.cash_id_row>
	<cfelse>
		<cfset attributes.cash_id = ''>
	</cfif>
</cfif>
<script type="text/javascript">
	if(kontrol == undefined || kontrol == 0)
	<cfif not isdefined("attributes.draggable")>opener.</cfif>add_voucher_row('#attributes.portfoy_no#','#attributes.bank_name#','#attributes.debtor_name#','#attributes.voucher_city#','#attributes.voucher_duedate#','#attributes.voucher_value#','#attributes.voucher_no#','#attributes.voucher_code#','#attributes.tax_place#','#attributes.tax_no#','#attributes.bank_branch_name#','#attributes.account_no#','#listgetat(attributes.currency_id,1,';')#','#attributes.voucher_id#','#voucher_position#','#from_voucher_info#','#attributes.voucher_status_id#','#attributes.voucher_system_currency_value#','#system_money_info#','#other_money_value2#','#other_money2#','#attributes.kur_say#','#money_list#','#attributes.acc_code#','#attributes.is_pay_term#','#last_act_date#','#attributes.cash_id#');
	<cfif isdefined("attributes.copy_voucher_count") and len(attributes.copy_voucher_count) and attributes.copy_voucher_count gt 1>
		<cfif attributes.due_option eq 1 or (attributes.due_option eq 2 and len(attributes.due_day))>
			for(i=1;i<=#attributes.copy_voucher_count-1#;i++)
			{
				 var new_voucher_no = (!new_voucher_no)?add_sequential_string('#attributes.voucher_no#'):add_sequential_string(new_voucher_no);
				<cfif attributes.due_option eq 1>
					new_due_date = date_add('m',i,'#attributes.voucher_duedate#');
				<cfelse>
					new_due_date = date_add('d',parseFloat(i*#attributes.due_day#),'#attributes.voucher_duedate#');
				</cfif>
				<cfif not isdefined("attributes.draggable")>opener.</cfif>add_voucher_row('#attributes.portfoy_no#','#attributes.bank_name#','#attributes.debtor_name#','#attributes.voucher_city#',new_due_date,'#attributes.voucher_value#',new_voucher_no,'#attributes.voucher_code#','#attributes.tax_place#','#attributes.tax_no#','#attributes.bank_branch_name#','#attributes.account_no#','#listgetat(attributes.currency_id,1,';')#','#attributes.voucher_id#','#voucher_position#','#from_voucher_info#','#attributes.voucher_status_id#','#attributes.voucher_system_currency_value#','#system_money_info#','#other_money_value2#','#other_money2#','#attributes.kur_say#','#money_list#','#attributes.acc_code#','#attributes.is_pay_term#','#last_act_date#','#attributes.cash_id#');
			}
		</cfif>
	</cfif>
	<cfif isdefined("attributes.close_syf")>
			<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		<cfelseif  (isdefined("attributes.close_draggable") and attributes.close_draggable eq 1)>
			<cfscript>sleep(1000);
			</cfscript>
			<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		</cfif>
</script>
</cfoutput>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
