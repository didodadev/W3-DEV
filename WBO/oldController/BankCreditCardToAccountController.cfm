<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Sevda Kurt			Developer	: Sevda Kurt		
Analys Date : 23/05/2016			Dev Date	: 23/05/2016		
Description :
	* Bu controller, kredi kartı hesaba geçiş objesine ait kontrolleri yapar. Modelleri çağırarak ilgili setleri çalıştırır.
	
	* add,upd,del ve list eventlerini içerisinde barındırır.
----------------------------------------------------------------------->
<!--- add,list utility --->
<cfscript>
	bankAccounts = bankAccounts.get();
</cfscript>
<cfif not isdefined("attributes.event")>
	<cfset attributes.event = "list">
</cfif>
<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1>
	<cfif attributes.event is "add">
    	<cf_date tarih='attributes.start_date'>
        <cfset moneys = getMoneyInfo.get()>
       	<cfoutput query="moneys">
            <cfset "rate_2_#money#" = rate2>
        </cfoutput>
        <cfscript>
        	getProcessCat = getProcessCat.get(attributes.process_cat);
			process_type = getProcessCat.PROCESS_TYPE;
			is_account = getProcessCat.IS_ACCOUNT;
			if(len(attributes.checked_value))
			{
				for(i = 1; i lte attributes.kayit_toplam; i++)
					attributes['masraf_#i#'] = filterNum(attributes['masraf_#i#']);
					
				getRows = BankCreditCardToAccountModel.getRows(attributes.checked_value);
				for(i=1;i<=getRows.recordcount;i++)
				{
					if(len(getRows.OTHER_MONEY[i]) and getRows.DOVIZ_TOPLAM[i] gt 0)
						currency_info = wrk_round(abs(getRows.TOPLAM[i]/getRows.DOVIZ_TOPLAM[i]));
					else
						currency_info = 1;
					add = BankCreditCardToAccountModel.add(
						processCat 		: attributes.process_cat,
						processType		: process_type,
						paperNo			: attributes.paper_number,
						actionAccountId	: getRows.ACTION_TO_ACCOUNT_ID[i],
						actionValue		: getRows.TOPLAM[i],
						expense			: evaluate("attributes.masraf_"&i),
						startDate		: attributes.start_date,
						actionDetail	: attributes.action_detail,
						otherMoneyValue	: wrk_round(abs(getRows.DOVIZ_TOPLAM[i]) - (evaluate("attributes.masraf_"&i)/currency_info)),
						otherMoney		: getRows.OTHER_MONEY[i],
						expenseCenterId	: iif(len(attributes.expense_center_id),attributes.expense_center_id,0),
						expenseItemId 	: iif(len(attributes.expense_item_id),attributes.expense_item_id,0),
						actionValue2	: wrk_round((abs(getRows.TOPLAM[i]) - evaluate("attributes.masraf_"&i))/evaluate("rate_2_"& session.ep.money2),4),
						isAccount		: is_account
					);
					attributes.actionId = add;	
					updBankActionId = BankCreditCardToAccountModel.updBankActionId(
						bankActionId	: add,
						checkedValue	: attributes.checked_value,
						paymentTypeId	: getRows.PAYMENT_TYPE_ID[i],
						bankActionDate	: getRows.BANK_ACTION_DATE[i],
						actionAccountId	: getRows.ACTION_TO_ACCOUNT_ID[i],
						otherMoney		: getRows.OTHER_MONEY[i]
					);
					if(evaluate("attributes.masraf_"&i) gt 0)
					{
						butceci(
							action_id			: add,
							muhasebe_db			: dsn2,
							is_income_expense	: iif((process_type eq 243),false,true),
							process_type		: process_type,
							nettotal			: evaluate("attributes.masraf_"&i),
							other_money_value	: wrk_round(evaluate("attributes.masraf_"&i)/currency_info),
							action_currency		: getRows.OTHER_MONEY[i],
							currency_multiplier	: currency_info,
							expense_date		: attributes.start_date,
							expense_center_id	: attributes.expense_center_id,
							expense_item_id		: attributes.expense_item_id,
							detail				: iif((process_type eq 243),de('HESABA GEÇİŞ MASRAFI'),de('HESABA GEÇİŞ İPTAL TUTARI')),
							paper_no			: attributes.paper_number,
							branch_id			: listgetat(session.ep.user_location,2,'-'),
							insert_type			: 1//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
						);	
					}
					if(len(attributes.expense_item_id))
						GET_EXP_ACC = expenseAccountCode.get(attributes.expense_item_id);
						
					if (is_account)//sadece sistem para birimi işlemleri yapılır tahsilatlarda
					{	
						//borc
						str_borclu_hesaplar = getRows.ACCOUNT_ACC_CODE[i];
						str_borclu_tutarlar = abs(getRows.TOPLAM[i]);
						str_other_borclu_tutarlar = abs(getRows.TOPLAM[i]);
						str_other_borclu_currency = session.ep.money;
						//alacak
						str_alacak_hesaplar = getRows.ACC_CODE_PAYMENT_TYPE[i];
						str_alacak_tutarlar = abs(getRows.TOPLAM[i]);
						str_other_alacak_tutarlar = abs(getRows.TOPLAM[i]);
						str_other_alacak_currency = session.ep.money;
						if(evaluate("attributes.masraf_"&i) gt 0 and len(GET_EXP_ACC.ACCOUNT_CODE))
						{
							//borc
							str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,GET_EXP_ACC.ACCOUNT_CODE, ",");	
							str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,evaluate("attributes.masraf_"&i),",");
							str_other_borclu_tutarlar = ListAppend(str_other_borclu_tutarlar,evaluate("attributes.masraf_"&i),",");
							str_other_borclu_currency = ListAppend(str_other_borclu_currency,session.ep.money,",");	
							//alacak
							str_alacak_hesaplar = ListAppend(str_alacak_hesaplar,getRows.ACCOUNT_ACC_CODE[i], ",");	
							str_alacak_tutarlar = ListAppend(str_alacak_tutarlar,evaluate("attributes.masraf_"&i),",");
							str_other_alacak_tutarlar = ListAppend(str_other_alacak_tutarlar,evaluate("attributes.masraf_"&i),",");
							str_other_alacak_currency = ListAppend(str_other_alacak_currency,session.ep.money,",");	
						}
						muhasebeci (
							action_id				: add,
							workcube_process_type	: process_type,
							workcube_process_cat	: attributes.process_cat,
							account_card_type		: 13,
							belge_no				: attributes.paper_number,
							islem_tarihi			: attributes.start_date,
							fis_satir_detay			: iif((process_type eq 243),de('KREDİ KARTI HESABA GEÇİŞ'),de('KREDİ KARTI HESABA GEÇİŞ İPTAL')),
							borc_hesaplar			: iif((process_type eq 243),de('#str_borclu_hesaplar#'),de('#str_alacak_hesaplar#')),
							borc_tutarlar			: iif((process_type eq 243),de('#str_borclu_tutarlar#'),de('#str_alacak_tutarlar#')),
							other_amount_borc		: iif((process_type eq 243),de('#str_other_borclu_tutarlar#'),de('#str_other_alacak_tutarlar#')),
							other_currency_borc		: iif((process_type eq 243),de('#str_other_borclu_currency#'),de('#str_other_alacak_currency#')),
							alacak_hesaplar			: iif((process_type eq 243),de('#str_alacak_hesaplar#'),de('#str_borclu_hesaplar#')),
							alacak_tutarlar			: iif((process_type eq 243),de('#str_alacak_tutarlar#'),de('#str_borclu_tutarlar#')),
							other_amount_alacak		: iif((process_type eq 243),de('#str_other_alacak_tutarlar#'),de('#str_other_borclu_tutarlar#')),
							other_currency_alacak	: iif((process_type eq 243),de('#str_other_alacak_currency#'),de('#str_other_borclu_currency#')),
							to_branch_id			: iif((process_type eq 243),listgetat(session.ep.user_location,2,'-'),de('')),
							from_branch_id			: iif((process_type neq 243),listgetat(session.ep.user_location,2,'-'),de('')),
							fis_detay:				iif((process_type eq 243),de('KREDİ KARTI HESABA GEÇİŞ'),de('KREDİ KARTI HESABA GEÇİŞ İPTAL'))
						);
					}
					updPaperNo.upd(
						columnName	: 'CREDITCARD_CC_BANK_ACTION_NUMBER',
						paperNumber	: listLast(attributes.paper_number,'-')
					);
				}
			}
        </cfscript>
    <cfelseif attributes.event is "del">
    	<cfscript>
			del = BankCreditCardToAccountModel.del(attributes.id);
			attributes.actionId = attributes.id;
			butce_sil(action_id:attributes.id,process_type:attributes.old_process_type);
			muhasebe_sil (action_id:attributes.id,process_type:attributes.old_process_type);
		</cfscript>
    </cfif>
</cfif>
<cf_get_lang_set module_name="bank">
<!------------------------------------------------------
	Event lere göre kontroller yapılıyor
-------------------------------------------------------->

<cfif attributes.event is 'add'>
	<cf_papers paper_type="creditcard_cc_bank_action">
	<cfset toplam_tutar = 0>
	<cfset GET_PAYMENT_ROWS = BankCreditCardToAccountModel.getRows(attributes.checked_value)>
    
    <script type="text/javascript">
		$(document).ready(function(){
			$('#process_cat').change(function(){
				clean_exp();
			});	
			formName = 'paymentCreditCards';
			form = $('form[name="'+ formName +'"]');
		});
		function kontrol()
		{
			if(!chk_period(document.getElementById('start_date'), 'İşlem')) return false;
			if(!chk_process_cat('paymentCreditCards')) return false;
			if(!check_display_files('paymentCreditCards')) return false;
			var selected_ptype = form.find('select#process_cat').val();
			var proc_control = form.find('input#ct_process_type_'+selected_ptype).val();
			<cfif toplam_tutar gte 0>
				if(proc_control == 247)
				{
					alertObject({message :"<cf_get_lang_main no='2647.Lütfen Hesaba Geçiş İşlem Tipi Seçiniz'>"});
					clean_exp();
					return false;
				}
			<cfelse>
				if(proc_control == 243)
				{
					alertObject({message :"<cf_get_lang_main no='2648.Lütfen Hesaba Geçiş İptal İşlem Tipi Seçiniz'>"});
					clean_exp();
					return false;
				}
			</cfif>
			if(form.find('input#expense_item_id').val() == "" || form.find('input#expense_item_name').val() == "")
			{
				var flag = false;
				for(var i=1;i<=form.find('input#kayit_toplam').val();i++)
				{
					if(filterNum(form.find('input#masraf_'+i).val()) > 0)
						flag = true;
				}
				if(flag)
					validateMessage('notValid',form.find('input#expense_item_name'));
				else
					validateMessage('valid', form.find('input#expense_item_name'));
			}
			if(form.find('input#expense_center_id').val() == "" || form.find('input#expense_center').val() == "")
			{
				var flag = false;
				for(var i=1;i<=form.find('input#kayit_toplam').val();i++)
				{
					if(filterNum(form.find('input#masraf_'+i).val()) > 0)
						flag = true;
				}
				if(flag)
					validateMessage('notValid',form.find('input#expense_center'));
				else
					validateMessage('valid', form.find('input#expense_center'));
			}
		
			var get_paper_no = wrk_safe_query('bnk_paper_no','dsn2',0,form.find('input#paper_no').val());
			if(get_paper_no.recordcount)
			{
				alertObject({message:"<cf_get_lang no='348.Girdiğiniz Belge Numarası Kullanılmaktadır'>!"});
				return false;
			}
			return true;
		}
		function open_exp_item()
		{
			if(!chk_process_cat('paymentCreditCards')) return false;
			var selected_ptype = form.find('select#process_cat').val();
			var proc_control = form.find('input#ct_process_type_'+selected_ptype).val();
			if(proc_control == 243)
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=paymentCreditCards.expense_item_id&field_name=paymentCreditCards.expense_item_name','list');
			else
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=paymentCreditCards.expense_item_id&field_name=paymentCreditCards.expense_item_name&is_income=1','list');
		}
		function open_exp_center()
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=paymentCreditCards.expense_center_id&field_name=paymentCreditCards.expense_center','list');
		}
		function clean_exp()
		{
			form.find('input#expense_item_id').val("");
			form.find('input#expense_center_id').val("");
			form.find('input#expense_item_name').val("");
			form.find('input#expense_center').val("");
		}
	</script>
<cfelseif attributes.event eq 'list'>
    <cfparam name="attributes.record_emp_id" default="">
    <cfparam name="attributes.record_emp_name" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.cons_id" default="">
    <cfparam name="attributes.par_id" default="">
    <cfparam name="attributes.member_name" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.date_1" default="">
    <cfparam name="attributes.date_2" default="">
    <cfparam name="attributes.bank_account" default="">
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.action_type_" default="">
    <cfparam name="attributes.payment_status" default="">
    <cfparam name="attributes.bank_action_date" default="1">
	<cfif len(attributes.date_1)>
        <cf_date tarih='attributes.date_1'>
    </cfif>
    <cfif len(attributes.date_2)>
        <cf_date tarih='attributes.date_2'>
    </cfif>
	<cfif isDefined("attributes.is_submitted")>
		<cfscript>
        	if((session.ep.isBranchAuthorization) or (isdefined('attributes.branch_id') and len(attributes.branch_id)))
			{
				if(isdefined('attributes.branch_id') and len(attributes.branch_id))
					control_branch_id = attributes.branch_id;
				else
					control_branch_id = ListGetAt(session.ep.user_location,2,"-");
			}
			else
				control_branch_id = '';
			arama_yapilmali = 0;
			GET_CREDIT_MAIN = BankCreditCardToAccountModel.list(
				record_emp_id	: iif(len(attributes.record_emp_id),attributes.record_emp_id,''),
				record_emp_name	: iif(len(attributes.record_emp_name),attributes.record_emp_name,''),
				keyword			: iif(len(attributes.keyword),attributes.keyword,''),
				date_1			: iif(len(attributes.date_1),attributes.date_1,''),
				date_2			: iif(len(attributes.date_2),attributes.date_2,''),
				bank_account	: iif(len(attributes.bank_account),attributes.bank_account,0),
				branch_id		: iif(len(control_branch_id),control_branch_id,''),
				company_id		: iif(len(attributes.company_id),attributes.company_id,''),
				cons_id			: iif(len(attributes.cons_id),attributes.cons_id,''),
				member_name		: iif(len(attributes.member_name),attributes.member_name,''),
				payment_status	: iif(len(attributes.payment_status),attributes.payment_status,0),
				action_type_	: iif(len(attributes.action_type_),attributes.action_type_,''),
				bank_action_date: iif(len(attributes.bank_action_date),attributes.bank_action_date,'')
			);
        </cfscript>
    <cfelse>
        <cfset arama_yapilmali = 1>
        <cfset GET_CREDIT_MAIN.recordcount = 0>
    </cfif>
    <cfparam name="attributes.totalrecords" default='#GET_CREDIT_MAIN.recordcount#'>
    <cfparam name="attributes.page" default='1'>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
    <script type="text/javascript">
		$( document ).ready(function() {
			formName = 'paymentCreditCards';
			form = $('form[name="'+ formName +'"]');
			
			formNameList = 'add_action_bank';
			formList = $('form[name="'+ formNameList +'"]');
			
			form.find("input#keyword").focus();
			formList.find("input#all_view").click(function(){
				formList.find('input:checkbox').not(this).prop('checked', this.checked);
			});
		});
		
		function kontrol()
		{
			if ((form.find('input#date_1').val() != "")&&(form.find('input#date_2').val() != ""))
				return date_check(document.getElementById('date_1'),document.getElementById('date_2'),"<cf_get_lang no ='281.Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'>!");
			return true;
		}
		function hesaba_aktar()
		{	
			kontrol_row = 0;
			if(formList.find('input#checked_value') != undefined)
			{
				if (formList.find('input#checked_value').length > 1)
				{
					first_checked_value = "";
					for(i=0; i<formList.find('input#checked_value').length; i++)
					{
						if(add_action_bank.checked_value[i].checked == true)
						{
							if(first_checked_value=="")
								first_checked_value = document.getElementsByName('kontrol_act_type')[i].value;
							if(first_checked_value != document.getElementsByName('kontrol_act_type')[i].value)
							{
								alertObject({message : "<cf_get_lang_main no='2650.Kredi Kartı Tahsilat ve Kredi Kartı Tahsilat İptal işlem tipleri birlikte seçilemez'>"});
								return false;
							}	
							kontrol_row = 1;
						}
					}
				}
				else
					if(formList.find('input#checked_value').prop("checked"))
					{
						kontrol_row = 1;
					}
			}
			if(formList.find('input#checked_value') != undefined && kontrol_row == 1)
			{
				var ckeckeds = [];
				$.each($("input[name='checked_value']:checked"), function(){            
					ckeckeds.push($(this).val());
				});
				windowopen('','medium','cc_paym');
				add_action_bank.action='<cfoutput>#request.self#?fuseaction=bank.list_payment_credit_cards&event=add</cfoutput>&checked_value='+ckeckeds;
				add_action_bank.target='cc_paym';
				add_action_bank.submit();
			}
			else
			{
				alertObject({message : "<cf_get_lang no='425.En Az Bir İşlem Seçmelisiniz'>"});
				return false;
			}
		}
	</script>
<cfelseif attributes.event is "upd">
    <cf_xml_page_edit fuseact="bank.popup_upd_bank_cc_payment">
    <cfset get_action_detail = BankCreditCardToAccountModel.get(attributes.id)>
    <cfif not get_action_detail.recordcount or (isDefined("attributes.action_period_id") and attributes.action_period_id neq session.ep.period_id)>
        <cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='2651.Bu Kayıt, Çalıştığınız Muhasebe Döneminde Bulunmamaktadır'></cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../dsp_hata.cfm">
        <cfabort>
    <cfelse>
    	<cfset get_cards = getAccountCardId.get(get_action_detail.action_id,get_action_detail.action_type_id)>
        <cfsavecontent variable="head_">
            <cfif get_action_detail.action_type_id eq 243><cf_get_lang_main no='1751.Kredi Kartı Hesaba Geçiş'><cfelse><cf_get_lang_main no='1752.Kredi Kartı Hesaba Geçiş İptal'></cfif>
        </cfsavecontent>
        <cfif xml_show_tahsilat_id eq 1 and session.ep.admin>
        	<cfscript>
            	GET_CC_ROWS = BankCreditCardToAccountModel.getPaymentIds(attributes.id);
            </cfscript>
        </cfif>
    </cfif>
</cfif>
<cfscript>

	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['processCat'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['processType'] = 243;
	WOStruct['#attributes.fuseaction#']['systemObject']['processCatSelected'] = '';

	if(attributes.event is 'add'){
	   WOStruct['#attributes.fuseaction#']['systemObject']['paperNumber'] = true;
	   WOStruct['#attributes.fuseaction#']['systemObject']['paperType'] = 'creditcard_cc_bank_action';
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn2;
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = false;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ACTIONS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACTION_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-start_date','item-process_cat']";
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'bank.list_payment_credit_cards';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'bank/display/list_payment_credit_cards.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.list_payment_credit_cards';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'bank/form/FormBankCreditCardToAccount.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'paymentCreditCards';

	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrol() && validate().check()';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'bank.list_payment_credit_cards';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'bank/form/FormBankCreditCardToAccount.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'bank.list_payment_credit_cards';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'aaa';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_action_detail';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['isInsert'] = 0;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteEvent'] = 'del';
	
	if( IsDefined('attributes.event') and (attributes.event is 'upd' or attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		if(not isdefined('attributes.formSubmittedController'))
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'bank.list_payment_credit_cards&event=del&id=#attributes.id#&old_process_type=#get_action_detail.action_type_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_payment_credit_cards';
	}
	
	if(attributes.event is "upd" and len(get_cards.CARD_ID))
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[35]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&card_id=#get_cards.CARD_ID#','page');";
	
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>

