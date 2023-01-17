<cfif isdefined("attributes.is_from_sale")><!--- Taksitli satıştan geliyorsa --->
	<cf_date tarih='attributes.cheque_duedate'>
	<cfquery name="UPD_CHEQUE" datasource="#dsn2#">
		UPDATE
			CHEQUE
		SET
			CHEQUE_DUEDATE = #attributes.cheque_duedate#,
			CHEQUE_VALUE = #attributes.cheque_value#,
			DEBTOR_NAME = <cfif isdefined("attributes.debtor_name") and len(attributes.debtor_name)>'#attributes.debtor_name#',<cfelse>NULL,</cfif>
			BANK_NAME = <cfif isdefined("attributes.bank_name") and len(attributes.bank_name)>'#attributes.bank_name#',<cfelse>NULL,</cfif>
			BANK_BRANCH_NAME = <cfif isdefined("attributes.bank_branch_name") and len(attributes.bank_branch_name)>'#attributes.bank_branch_name#',<cfelse>NULL,</cfif>
			TAX_NO = <cfif isdefined("attributes.tax_no") and len(attributes.tax_no)>'#attributes.tax_no#',<cfelse>NULL,</cfif>
			TAX_PLACE = <cfif isdefined("attributes.tax_place") and len(attributes.tax_place)>'#attributes.tax_place#',<cfelse>NULL,</cfif>
			ACCOUNT_ID = <cfif isdefined("attributes.account_id") and len(attributes.account_id)>'#attributes.account_id#',<cfelse>NULL,</cfif>
			ACCOUNT_NO = <cfif isdefined("attributes.account_no") and len(attributes.account_no)>'#attributes.account_no#',<cfelse>NULL,</cfif>
			CHEQUE_NO = <cfif isdefined("attributes.cheque_no") and len(attributes.cheque_no)>'#attributes.cheque_no#',<cfelse>NULL,</cfif>
			CHEQUE_PURSE_NO = <cfif isdefined("attributes.portfoy_no") and len(attributes.portfoy_no)>'#attributes.portfoy_no#',<cfelse>NULL,</cfif>
			CHEQUE_CITY = <cfif isdefined("attributes.cheque_city") and len(attributes.cheque_city)>'#attributes.cheque_city#',<cfelse>NULL,</cfif>
			CHEQUE_CODE = <cfif isdefined("attributes.cheque_code") and len(attributes.cheque_code)>'#attributes.cheque_code#'<cfelse>NULL</cfif>
		WHERE
			CHEQUE_ID = #attributes.cheque_id#
	</cfquery>
	<script type="text/javascript">
		location.href = document.referrer;
	</script>
<cfelse>
	<cfif not isdefined("attributes.payroll_entry")><!--- giris bordrosu dışından gelmeli --->
		<cfoutput>
			<script type="text/javascript">
				var kontrol=0;//Sessinda 2 tane aynı çek var mi kontrolü
				<cfif isdefined("attributes.cheque_no") and (attributes.cheque_no neq 0)>
					for(tt=1;tt<=<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.record_num.value;tt++)
					{
						if('#attributes.row#' != tt)
							if(('#attributes.cheque_no#' == eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.cheque_no'+tt).value) && ('#attributes.account_id#' == eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.account_id'+tt).value))
							{
								kontrol = 1;
								break;
							}
					}
				</cfif>
				if(kontrol == 1)
				{
					alert("<cf_get_lang no='16.Aynı Çeki İkinci Kere Girmeye Çalışıyorsunuz !'>");
					history.go(-1);
				}
			</script>
		</cfoutput>
		<!---Cek numarası daha once kaydedilmis mi? --->
		<cfif isDefined("attributes.account_id") and len(attributes.account_id)>
			<cfquery name="CONTROL_CHEQUE_NO" datasource="#DSN2#">
				SELECT CHEQUE_ID FROM CHEQUE WHERE ACCOUNT_ID = #attributes.account_id# AND CHEQUE_NO = '#attributes.cheque_no#'
			</cfquery>
			<cfif control_cheque_no.recordcount and (attributes.cheque_id neq CONTROL_CHEQUE_NO.CHEQUE_ID)>
				<script type="text/javascript">
					alert("<cf_get_lang no ='265.Bu Bankaya Kayıtlı Aynı Numaralı Bir Çek Mevcuttur Çek Bilgilerinizi Kontrol Ediniz'>!");
					history.go(-1);		
				</script>
				<cfabort>
			</cfif> 
		</cfif>
	</cfif>
	<!--- Sistem 2. dövizini hesaplamak için kontroller hesaplamalar vs yapılıyor --->
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
	<cfif not isdefined("attributes.account_no")>
		<cfset attributes.account_no = "">
	</cfif>
	<cfif not isdefined("attributes.account_id")>
		<cfset attributes.account_id = "">
	</cfif>
	<cfif not len(attributes.currency_id)>
		<cfif len(account_id) and isnumeric(account_id)>
			<cfinclude template="../query/get_action_account.cfm">
			<cfset attributes.currency_id = get_action_account.ACCOUNT_CURRENCY_ID>
		</cfif>
	<cfelse>
		<cfset attributes.currency_id = listgetat(attributes.currency_id,1,';')>
	</cfif>
	<cfset money_list = attributes.kur_say & '-'>
	<cfloop from="1" to="#attributes.kur_say#" index="i">
		<cfset money_list= money_list & '#evaluate("attributes.other_money#i#")#' & ',' & '#evaluate("attributes.txt_rate1_#i#")#' & ',' & '#evaluate("attributes.txt_rate2_#i#")#' & '-'>
	</cfloop>
	<cfoutput>
		<script type="text/javascript">
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.tax_place'+#attributes.row#).value = '#attributes.tax_place#';
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.tax_no'+#attributes.row#).value = '#attributes.tax_no#';
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.debtor_name'+#attributes.row#).value = '#attributes.debtor_name#';
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.bank_name'+#attributes.row#).value = '#attributes.bank_name#';
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.bank_branch_name'+#attributes.row#).value = '#attributes.bank_branch_name#';
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.cheque_city'+#attributes.row#).value = '#attributes.cheque_city#';
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.cheque_duedate'+#attributes.row#).value = '#attributes.cheque_duedate#';
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.cheque_value'+#attributes.row#).value = '#attributes.cheque_value#';
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.cheque_no'+#attributes.row#).value = '#attributes.cheque_no#';
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.cheque_code'+#attributes.row#).value = '#attributes.cheque_code#';
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.account_no'+#attributes.row#).value = '#attributes.account_no#';
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.account_id'+#attributes.row#).value = '#attributes.account_id#';
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.currency_id'+#attributes.row#).value = '#attributes.currency_id#';
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.cheque_id'+#attributes.row#).value = '#attributes.cheque_id#';
			<cfif isdefined("attributes.endorsement_member")>
				eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.endorsement_member'+#attributes.row#).value = '#attributes.endorsement_member#';
			</cfif>
			<cfif isDefined("attributes.self_cheque_") and attributes.self_cheque_ eq 1>eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.from_cheque_info'+#attributes.row#).value = 1;<cfelse>eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.from_cheque_info'+#attributes.row#).value = 0;</cfif>
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.cheque_system_currency_value'+#attributes.row#).value = '#attributes.cheque_system_currency_value#';
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.system_money_info'+#attributes.row#).value = '#session.ep.money#';
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.other_money_value2'+#attributes.row#).value = '#wrk_round(filterNum(attributes.cheque_system_currency_value,session.ep.our_company_info.rate_round_num)/currency_multiplier)#';
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.other_money2'+#attributes.row#).value = '#session.ep.money2#';
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.money_list'+#attributes.row#).value = '#money_list#';
			<cfif not isdefined("attributes.draggable")>window.opener.</cfif>cheque_rate_change();
			<cfif not isdefined("attributes.draggable")>window.opener.</cfif>toplam(1,0);
			<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		</script>
	</cfoutput>
</cfif>

