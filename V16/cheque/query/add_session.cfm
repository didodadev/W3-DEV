<cf_get_lang_set module_name="cheque">
<cfoutput>
	<script type="text/javascript">
		var kontrol=0;
	</script>
	<cfif not isdefined("attributes.payroll_entry")><!--- giris bordrosu dışından gelmeli --->
		<!--- baskette 2 tane aynı çek var mi kontrolü --->
		<script type="text/javascript">
			<cfif isdefined("attributes.cheque_id") and len(attributes.cheque_id) and attributes.cheque_id neq 0>//<!--- Cek kayıtlı ise --->
				for(tt=1;tt<=<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.record_num.value;tt++)
				{
					if(eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.row_kontrol'+tt).value == 1)
					{
						if('#attributes.cheque_id#' == eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.cheque_id'+tt).value)
						{
							kontrol = 1;
							break;
						}
					}
				}
			<cfelse>
				for(jj=1;jj<=<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.record_num.value;jj++)
				{
					if(eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.row_kontrol'+jj).value == 1)
					{
						if(('#attributes.cheque_no#' == eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.cheque_no'+jj).value) && ('#attributes.account_id#' == eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.account_id'+jj).value))
						{
							kontrol = 1;
							break;
						}
					}
				}
			</cfif>
			if (kontrol == 1)
			{
				alert("<cf_get_lang dictionary_id='50211.Aynı Çeki İkinci Kere Girmeye Çalışıyorsunuz !'>");
			}
		</script>
		<cfif not (isDefined("attributes.cheque_id") and len(attributes.cheque_id)) and isDefined("attributes.cheque_no")><!--- >Banka Subesine ait cek no kontrolu  --->
			<cfquery name="CONTROL_CHEQUE_NO" datasource="#dsn2#">
				SELECT CHEQUE_ID FROM CHEQUE WHERE ACCOUNT_ID = #attributes.account_id# AND CHEQUE_NO = '#attributes.cheque_no#'
			</cfquery>
			<cfif CONTROL_CHEQUE_NO.recordcount>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id ='50460.Bu Bankaya Kayıtlı Aynı Numaralı Bir Çek Mevcuttur Çek Bilgilerinizi Kontrol Ediniz'> !");
				</script>
			</cfif>
		</cfif>
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
	<cfif len(attributes.account_id)>
		<cfif isdefined("url.self_cheque") and len(attributes.account_id)>
			<cfquery name="get_bn" datasource="#DSN3#">
				SELECT
					BANK_BRANCH.BANK_NAME,
					BANK_BRANCH.BANK_BRANCH_NAME
				FROM
					BANK_BRANCH,
					ACCOUNTS
				WHERE 
					ACCOUNTS.ACCOUNT_ID = #attributes.account_id# AND
					ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID
			</cfquery>
			<cfif get_bn.recordcount>
				<cfset attributes.bank_name = get_bn.BANK_NAME>
				<cfset attributes.bank_branch_name = get_bn.BANK_BRANCH_NAME>
			</cfif>
		</cfif> 
	</cfif>
	<cfset cheque_position = 1><!--- yeni ya da seçilen çek --->
	<cfset from_cheque_info = ''>
	<cfif not isdefined("attributes.endorsement_member")>
		<cfset attributes.endorsement_member = ''>
	</cfif>
	<cfif isdefined("attributes.self_cheque")>
		<cfset attributes.cheque_status_id = 6><!--- default status : ödenmedi --->
	<cfelse>
		<cfif isdefined("attributes.entry_ret") or isdefined("attributes.endor_ret") or isdefined("attributes.is_return")>
			<cfset attributes.self_cheque = attributes.cheque_status_id>
		<cfelse>
			<cfif isdefined("attributes.self_cheque_")>
				<cfset from_cheque_info = 1><!--- ilgili çekin defterinin sahibi çeki bize veren firmanin kendisi ise --->
			<cfelse>
				<cfset from_cheque_info = 0><!--- çeki bize veren firma cirolayarak vermisse --->
			</cfif>
			<cfset attributes.cheque_status_id = 1><!---default status : portföyde--->
		</cfif>
	</cfif>
	<cfset system_money_info = session.ep.money>
	<cfset money_list = ''>
	<cfset other_money_value2 = ''>
	<cfif isdefined("attributes.kur_say")>
		<cfif len(currency_multiplier)>
			<cfset other_money_value2 = wrk_round(attributes.cheque_system_currency_value/currency_multiplier)><!--- Sistem dövizinden sistem 2. dövizi hesaplanıyor--->
		</cfif>
		<cfset other_money2 = session.ep.money2>
		<cfset money_list = attributes.kur_say & '-'>
		<cfloop from="1" to="#attributes.kur_say#" index="sss">
			<cfset money_list= money_list & '#evaluate("attributes.other_money#sss#")#' & ',' & '#evaluate("attributes.txt_rate1_#sss#")#' & ',' & '#evaluate("attributes.txt_rate2_#sss#")#' & '-'>
		</cfloop>
	<cfelse>
		<cfif isdefined("attributes.cheque_other_money_value") and len(attributes.cheque_other_money_value)>
			<cfset other_money_value2 = attributes.cheque_other_money_value>
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
	<cfif isdefined("attributes.cheque_id") and len(attributes.cheque_id)>
		<cfquery name="GET_NOTE" datasource="#dsn#">
			SELECT
				*
			FROM
				NOTES
			WHERE
				ACTION_SECTION = 'CHEQUE_ID' AND 
				ACTION_ID = #attributes.cheque_id# AND
				IS_WARNING = 1
			ORDER BY 
				ACTION_ID DESC
		</cfquery>
		<cfquery name="get_last_date" datasource="#dsn2#">
			SELECT
				MAX(ISNULL(ACT_DATE,RECORD_DATE)) ACT_DATE
			FROM
				CHEQUE_HISTORY
			WHERE
				CHEQUE_ID = #attributes.cheque_id#
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
			window.open('<cfoutput>#request.self#?fuseaction=objects.popup_detail_company_note&cheque_id=#attributes.cheque_id#</cfoutput>','','scrollbars=0, resizable=0,width=500,height=500,left='+(screen.width-500)/2+',top='+(screen.height-500)/2+"'");
		</cfif>
	</script>
	<script type="text/javascript">
		if(kontrol == undefined || kontrol == 0)
			add_cheque_row('#attributes.portfoy_no#','#attributes.bank_name#','#attributes.debtor_name#','#attributes.cheque_city#','#attributes.cheque_duedate#','#attributes.cheque_value#','#attributes.cheque_no#','#attributes.cheque_code#','#attributes.tax_place#','#attributes.tax_no#','#attributes.bank_branch_name#','#attributes.account_no#','#attributes.account_id#','#listgetat(attributes.cheque_currency_id,1,';')#','#attributes.cheque_id#','#cheque_position#','#from_cheque_info#','#attributes.cheque_status_id#','#attributes.cheque_system_currency_value#','#system_money_info#','#other_money_value2#','#other_money2#','#attributes.kur_say#','#money_list#','#attributes.endorsement_member#','#last_act_date#');

		<cfif isdefined("attributes.copy_cheque_count") and len(attributes.copy_cheque_count) and attributes.copy_cheque_count gt 1>
			<cfif attributes.due_option eq 1 or (attributes.due_option eq 2 and len(attributes.due_day))>
				for(i=1;i<=#attributes.copy_cheque_count-1#;i++)
				{
					var new_cheque_no = (!new_cheque_no)?add_sequential_string('#attributes.cheque_no#'):add_sequential_string(new_cheque_no);
					<cfif attributes.due_option eq 1>
						new_due_date = date_add('m',i,'#attributes.cheque_duedate#');
					<cfelse>
						new_due_date = date_add('d',parseFloat(i*#attributes.due_day#),'#attributes.cheque_duedate#');
					</cfif>
					add_cheque_row('#attributes.portfoy_no#','#attributes.bank_name#','#attributes.debtor_name#','#attributes.cheque_city#',new_due_date,'#attributes.cheque_value#',new_cheque_no,'#attributes.cheque_code#','#attributes.tax_place#','#attributes.tax_no#','#attributes.bank_branch_name#','#attributes.account_no#','#attributes.account_id#','#listgetat(attributes.cheque_currency_id,1,';')#','#attributes.cheque_id#','#cheque_position#','#from_cheque_info#','#attributes.cheque_status_id#','#attributes.cheque_system_currency_value#','#system_money_info#','#other_money_value2#','#other_money2#','#attributes.kur_say#','#money_list#','#attributes.endorsement_member#');
				}
			</cfif>
		</cfif>
		<cfif not isdefined("attributes.draggable")>
			window.close();
		<cfelse>
			closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		</cfif>
	
	</script>
</cfoutput>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
