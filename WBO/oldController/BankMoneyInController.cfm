<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************	
Description :
	Bu Controller  Para Çekme Objesine  ait CRUD ve list fonksiyonlarını gerceklestirir.
----------------------------------------------------------------------->

<cf_get_lang_set module_name="bank">
<cfif not isdefined('attributes.formSubmittedController') or IsDefined("attributes.id") or attributes.event eq 'del'>
    <cfscript>
		if (not isdefined("attributes.event"))
			attributes.event = "add";
	
        get_all_cash=getAllCash.get();	//utiliy
		cash = "";
		acc="";
		value="";
		otherMoneyValue="";
		emp_id="";
		process_cat="";
		control_status = 1;
		currency = "";
		is_upd = 0;
		branch_id = "";
		is_default = 1;
		paper_number = "";
		action_date = now();
		employeeId = get_emp_info(session.ep.userid,0,0);
		action_detail1 = "";
		
		if((isdefined("attributes.event") and attributes.event is 'add') or not isdefined("attributes.event"))
			kontrol = getControlBillNo.get();	//utiliy
    </cfscript>
	<cfif (isdefined("attributes.event") and attributes.event is 'add') or not isdefined("attributes.event")>
        <cfif not kontrol.recordcount>
            <font color="##FF0000">
                <a href="<cfoutput>#request.self#?fuseaction=account.bill_no</cfoutput>" class="tableyazi"><cf_get_lang_main no='1616.Lütfen Muhasebe Fiş numaralarını Düzenleyiniz'></a>
            </font>
            <cfabort>
        </cfif>
    <cfelseif isdefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'del')>
            <cfscript>
				if (session.ep.isBranchAuthorization)
				{
					get_all_cash=getAllCash.get(status : 0);	//utiliy
					
					cash_list = valuelist(get_all_cash.cash_id);
					if (not listlen(cash_list)) cash_list = 0;
					control_branch_id = ListGetAt(session.ep.user_location,2,"-");
				}
				
				get_action_detail=BankActionsModel.get(id:attributes.id);	//Model
            </cfscript>
        <cfif not get_action_detail.recordcount>
            <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
            <cfexit method="exittemplate">
        <cfelse>
        	<cfscript>
				if (listgetat(attributes.fuseaction,2,'.') is 'popup_upd_get_money')
					url_link = "&is_popup=1";
				else
					url_link = "";
				cash=get_action_detail.ACTION_TO_CASH_ID;
				acc=get_action_detail.ACTION_FROM_ACCOUNT_ID;
				value=get_action_detail.ACTION_VALUE;
				emp_id=get_action_detail.ACTION_EMPLOYEE_ID;
				process_cat = get_action_detail.process_cat;
				control_status = 0;
				currency = get_action_detail.ACTION_CURRENCY_ID;
				is_upd = 1;
				branch_id = get_action_detail.from_branch_id;
				is_default = 0;
				paper_number = get_action_detail.paper_no;
				action_date = get_action_detail.ACTION_DATE;
				otherMoneyValue=get_action_detail.OTHER_CASH_ACT_VALUE;
				employeeId = get_emp_info(get_action_detail.ACTION_EMPLOYEE_ID,0,0);
				action_detail1 = get_action_detail.ACTION_DETAIL;
				attributes.action_type_id = get_action_detail.action_type_id;
			</cfscript>
        </cfif>
    </cfif>
    <script type="text/javascript">
        <cfif isdefined("attributes.event") and attributes.event is 'add'>
            $( document ).ready(function() {
               check_acc_info('');
            });
        </cfif> 
        <cfif isdefined("attributes.event") and attributes.event is 'upd'>
            function del_kontrol()
            {
                control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
                if(!chk_period(document.get_money.action_date, 'İşlem')) return false;
                else return true;
            }
        </cfif>
        function kontrol()
        {	
            if(!chk_period(document.get_money.action_date, 'İşlem')) return false;
            kur_ekle_f_hesapla('account_id');//dövizli tutarı silinenler için
            if(!chk_process_cat('get_money')) return false;
            if(!check_display_files('get_money')) return false;
            <cfif (isdefined("attributes.event") and attributes.event is 'add') or not isdefined("attributes.event")>
                if(!acc_control()) return false;
                
            <cfelseif isdefined("attributes.event") and attributes.event is 'upd'>	
                control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
                
            </cfif>
            return true;
        }
        function check_acc_info(cash_money_info)
        {
            //Seçilen kasaya göre bankaların listelenmesi
            var account_id_len = eval('document.getElementById("account_id")').options.length;
            for(j=account_id_len;j>=0;j--)
                eval('document.getElementById("account_id")').options[j] = null;	
            eval('document.getElementById("account_id")').options[0] = new Option('Seçiniz','');
            var money_info = list_getat(cash_money_info,2,';');
            if(money_info != '')
            {
                <cfif attributes.event is 'add'>
                    var status = 1;
                <cfelseif attributes.event is 'upd'>
                    var status = 0;
                </cfif>
                
                url_= '/V16/bank/cfc/bankInfo.cfc?method=getBankAcc';
                
                $.ajax({
                    type: "get",
                    url: url_,
                    data: {money: money_info,statusInf: status},
                    cache: false,
                    async: false,
                    success: function(read_data){
                        data_ = jQuery.parseJSON(read_data.replace('//',''));
                        if(data_.DATA.length != 0)
                        {
                            $.each(data_.DATA,function(i){
                                document.getElementById('account_id').options[i+1]=new Option(''+data_.DATA[i][0]+' '+data_.DATA[i][1]+'',''+data_.DATA[i][2]+'');						
                                });
                        }
                    }
                });
            }
        }
    </script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isDefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['processCat'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['processType'] = 22;
	WOStruct['#attributes.fuseaction#']['systemObject']['processCatSelected'] = process_cat;
	WOStruct['#attributes.fuseaction#']['systemObject']['paperDate'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['paperDateCallFunction'] = 'change_money_info';
	WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn2;
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.form_add_get_money';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'bank/form/form_get_money.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.form_add_get_money&event=upd&id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'get_money';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrol() && validate().check()';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'bank.popup_upd_get_money';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'bank/form/form_get_money.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'bank.form_add_get_money&event=upd&id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'get_money';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_action_detail';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
    WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'kontrol() && validate().check()';
    WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
    WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteEvent'] = 'del';
    WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteFunction'] = 'del_kontrol()';
	
	if(isdefined("attributes.event") and listFind('upd,del',attributes.event))
	{ 	
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.del_get_money&id=#attributes.id#&old_process_type=#get_action_detail.action_type_id#&paper_no=#get_action_detail.PAPER_NO##url_link#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_bank_actions';
	}
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_action_detail.ACTION_TYPE_ID#','page','upd_get_money');";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=bank.form_add_get_money&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ACTIONS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACTION_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-processCat','item-TO_CASH_ID','item-account_id','item-ACTION_DATE','item-ACTION_VALUE']";
</cfscript>

<!------------------------------------------------------
	modelden CRUD işlemleri yapılıyor...
-------------------------------------------------------->

<cfif isdefined('attributes.event') and isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1>
	<cfif listFind('add,upd',attributes.event)>
    	<cfif isdefined('form.active_period') and form.active_period neq session.ep.period_id>
			<script type="text/javascript">
                alertObject({message: "<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!"});
            </script>
            <cfabort>
        </cfif>
		<cfif isdefined('attributes.paper_number') and len(attributes.paper_number)>
            <cfscript>
                control_paper_no=BankActionsModel.getControlPaperNo//Model
                (
                    paper_number : attributes.paper_number ,
                    id : iif(attributes.event eq 'upd',attributes.id,0)
                );
            </cfscript>
            <cfif control_paper_no.recordcount>
            	<script>
					alertObject({message: "<cf_get_lang no ='348.Girdiğiniz Belge Numarası Kullanılmaktadır'>!"});
				</script>
                <cfabort>
            </cfif>
        </cfif>
    </cfif>
    <cf_date tarih ="attributes.ACTION_DATE">
	<cfif attributes.event eq 'add'>
    	<cfscript>
			get_process_type = getProcessCat.get(process_cat : process_cat);	//Utility
           	process_type = get_process_type.PROCESS_TYPE;
			is_cari =get_process_type.IS_CARI;
			is_account = get_process_type.IS_ACCOUNT;
			TO_CASH_ID = listfirst(attributes.TO_CASH_ID,';');
			to_branch_id = listlast(attributes.TO_CASH_ID,';');
			attributes.ACTION_VALUE = filterNum(attributes.ACTION_VALUE);
			attributes.OTHER_CASH_ACT_VALUE = filterNum(attributes.OTHER_CASH_ACT_VALUE);
			attributes.system_amount = filterNum(attributes.system_amount);
			get_all_cash=getAllCash.get(to_cash_id :iif(TO_CASH_ID neq 0,TO_CASH_ID,0));//Utility
			for(h_sy=1; h_sy lte attributes.kur_say; h_sy=h_sy+1)
			{
				'attributes.txt_rate1_#h_sy#' = filterNum(evaluate('attributes.txt_rate1_#h_sy#'),session.ep.our_company_info.rate_round_num);
				'attributes.txt_rate2_#h_sy#' = filterNum(evaluate('attributes.txt_rate2_#h_sy#'),session.ep.our_company_info.rate_round_num);
			}
			if(isdefined("attributes.branch_id") and len(attributes.branch_id))
				branch_id_info = attributes.branch_id;
			else
				branch_id_info = listgetat(session.ep.user_location,2,'-');
			currency_multiplier = '';
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
					if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
						currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');	
			currency_multiplier_result = wrk_round(attributes.system_amount/currency_multiplier,4);
			
			add = BankActionsModel.add		//Model
			(
				process_cat 	: process_cat,
				process_type 	: process_type,
				action_value 	: attributes.ACTION_VALUE,
				currency_id 	: attributes.currency_id,
				action_date 	: attributes.ACTION_DATE,
				from_account_id : attributes.account_id,
				to_cash_id 		: TO_CASH_ID,
				employee_id 	: EMPLOYEE_ID,
				action_detail 	: iif(isdefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL),"attributes.ACTION_DETAIL",DE("")), 
				money_type 		: iif(isdefined("attributes.money_type") and len(attributes.money_type),"attributes.money_type",DE("")),
				is_account 		: is_account,
				is_account_type : 11,
				action_type 	: 'HESAPTAN PARA ÇEKME',
				paper_number 	: iif(isdefined("attributes.paper_number") and len(attributes.paper_number),"attributes.paper_number",DE("")),
				from_branch_id 	: branch_id_info,
				system_amount 	: attributes.system_amount,
				currency_multiplier : currency_multiplier_result,
				other_cash_act_value :iif(isdefined('attributes.other_cash_act_value') and len(attributes.other_cash_act_value),attributes.other_cash_act_value,0)
			);	
			
			addCash = CashActionsModel.add		//Model
			(
				process_cat 	: process_cat,
				action_type		: 'HESAPTAN PARA ÇEKME',
				process_type 	: process_type,
				action_value 	: attributes.ACTION_VALUE,
				currency_id 	: attributes.currency_id,
				action_date 	: attributes.ACTION_DATE,
				account_id 		: attributes.account_id,
				to_cash_id 		: TO_CASH_ID,
				employee_id 	: EMPLOYEE_ID,
				action_detail 	: iif(isdefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL),"attributes.ACTION_DETAIL",DE("")), 
				money_type 		: iif(isdefined("attributes.money_type") and len(attributes.money_type),"attributes.money_type",DE("")),
				is_account 		: is_account,
				paper_number 	: iif(isdefined("attributes.paper_number") and len(attributes.paper_number),"attributes.paper_number",DE("")),
				from_branch_id 	: branch_id_info,
				system_amount 	: attributes.system_amount,
				currency_multiplier : currency_multiplier_result,
				is_account_type : 11,
				bank_action_id 	: add,
				other_cash_act_value :iif(isdefined('attributes.other_cash_act_value') and len(attributes.other_cash_act_value),attributes.other_cash_act_value,0)
			);	
			if(is_account)
			{
				if(isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
					str_card_detail = '#attributes.ACTION_DETAIL#';
				else
					str_card_detail = '#dateformat(attributes.ACTION_DATE,'dd/mm/yyyy')# TARİHLİ HESAPTAN PARA ÇEKME İŞLEMİ';
				
				muhasebeci (
					action_id			:add,
					workcube_process_type: process_type,
					workcube_process_cat: form.process_cat,
					account_card_type	: 11,
					islem_tarihi		: attributes.ACTION_DATE,
					fis_satir_detay		: str_card_detail,
					borc_hesaplar		: get_all_cash.CASH_ACC_CODE,
					borc_tutarlar		: attributes.system_amount,
					other_amount_borc 	: attributes.ACTION_VALUE,
					other_currency_borc : attributes.currency_id,
					alacak_hesaplar		: attributes.account_acc_code,
					alacak_tutarlar		: attributes.system_amount,
					other_amount_alacak : attributes.ACTION_VALUE,
					other_currency_alacak : attributes.currency_id,
					currency_multiplier : currency_multiplier,
					fis_detay			: 'HESAPTAN PARA ÇEKME İŞLEMİ',
					from_branch_id 		: branch_id_info,
					to_branch_id 		: to_branch_id,
					belge_no			: attributes.paper_number
				);
			}
			f_kur_ekle_action(action_id:add,process_type:0,action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#');
			f_kur_ekle_action(action_id:addCash,process_type:0,action_table_name:'CASH_ACTION_MONEY',action_table_dsn:'#dsn2#');
			attributes.actionId = add;	
		</cfscript>
    <cfelseif attributes.event eq 'upd'>
    	<cfscript>
			get_process_type = getProcessCat.get(process_cat : process_cat);	//Utility
			
			process_type = get_process_type.PROCESS_TYPE;
			is_cari = get_process_type.IS_CARI;
			is_account = get_process_type.IS_ACCOUNT;
			TO_CASH_ID = listfirst(attributes.TO_CASH_ID,';');
			to_branch_id = listlast(attributes.TO_CASH_ID,';');
			attributes.ACTION_VALUE = filterNum(attributes.ACTION_VALUE);
			attributes.OTHER_CASH_ACT_VALUE = filterNum(attributes.OTHER_CASH_ACT_VALUE);
			attributes.system_amount = filterNum(attributes.system_amount);
			
			get_all_cash=getAllCash.get(to_cash_id :iif(TO_CASH_ID neq 0,TO_CASH_ID,0));	//Utility
			
			for(q_sy = 1; q_sy lte attributes.kur_say; q_sy = q_sy+1)
			{
				'attributes.txt_rate1_#q_sy#' = filterNum(evaluate('attributes.txt_rate1_#q_sy#'),session.ep.our_company_info.rate_round_num);
				'attributes.txt_rate2_#q_sy#' = filterNum(evaluate('attributes.txt_rate2_#q_sy#'),session.ep.our_company_info.rate_round_num);
			}
			if(isdefined("attributes.branch_id") and len(attributes.branch_id))
				branch_id_info = attributes.branch_id;
			else
				branch_id_info = listgetat(session.ep.user_location,2,'-');
			currency_multiplier = '';
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
					if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
						currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			currency_multiplier_result = wrk_round(attributes.system_amount/currency_multiplier,4);
			
			upd=BankActionsModel.upd		//Model
			(
				id 				: attributes.id,
				process_cat 	: process_cat,
				process_type 	: process_type,
				action_value 	: attributes.ACTION_VALUE,
				currency_id 	: attributes.currency_id,
				action_date 	: attributes.ACTION_DATE,
				from_account_id : attributes.account_id,
				to_cash_id 		: TO_CASH_ID,
				employee_id 	: EMPLOYEE_ID,
				action_detail 	: iif(isdefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL),"attributes.ACTION_DETAIL",DE("")), 
				money_type 		: iif(isdefined("attributes.money_type") and len(attributes.money_type),"attributes.money_type",DE("")),
				is_account 		: is_account,
				is_account_type : 11,
				paper_number 	: iif(isdefined("attributes.paper_number") and len(attributes.paper_number),"attributes.paper_number",DE("")),
				from_branch_id 	: branch_id_info,
				system_amount 	: attributes.system_amount,
				currency_multiplier : currency_multiplier_result,
				other_cash_act_value :iif(isdefined('attributes.other_cash_act_value') and len(attributes.other_cash_act_value),attributes.other_cash_act_value,0)
			);
			updCash = CashActionsModel.upd		//Model
			(
				id 				: attributes.id,
				process_cat 	: process_cat,
				process_type 	: process_type,
				action_value 	: attributes.ACTION_VALUE,
				currency_id 	: attributes.currency_id,
				action_date 	: attributes.ACTION_DATE,
				from_account_id : attributes.account_id,
				to_cash_id 		: TO_CASH_ID,
				employee_id 	: EMPLOYEE_ID,
				action_detail 	: iif(isdefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL),"attributes.ACTION_DETAIL",DE("")), 
				money_type 		: iif(isdefined("attributes.money_type") and len(attributes.money_type),"attributes.money_type",DE("")),
				is_account 		: is_account,
				is_account_type : 11,
				paper_number 	: iif(isdefined("attributes.paper_number") and len(attributes.paper_number),"attributes.paper_number",DE("")),
				from_branch_id  : branch_id_info,
				system_amount 	: attributes.system_amount,
				currency_multiplier : currency_multiplier_result,
				other_cash_act_value :iif(isdefined('attributes.other_cash_act_value') and len(attributes.other_cash_act_value),attributes.other_cash_act_value,0)
			);
			get_cash_action= getCashAction.get(id : attributes.id);
            if(is_account)
			{
				if(isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
					str_card_detail = '#attributes.ACTION_DETAIL#';
				else
					str_card_detail = '#dateformat(attributes.ACTION_DATE,'dd/mm/yyyy')# TARİHLİ HESAPTAN PARA ÇEKME İŞLEMİ';
					
				muhasebeci (
					action_id				:attributes.id,
					workcube_process_type	:process_type,
					workcube_old_process_type:form.old_process_type,
					workcube_process_cat	:form.process_cat,
					account_card_type		:11,
					islem_tarihi			: attributes.ACTION_DATE,
					fis_satir_detay			:str_card_detail,
					borc_hesaplar			:get_all_cash.CASH_ACC_CODE,
					borc_tutarlar			:attributes.system_amount,
					other_amount_borc 		: attributes.ACTION_VALUE,
					other_currency_borc 	: attributes.currency_id,
					alacak_hesaplar			:attributes.account_acc_code,
					alacak_tutarlar			:attributes.system_amount,
					other_amount_alacak 	: attributes.ACTION_VALUE,
					other_currency_alacak 	: attributes.currency_id,
					currency_multiplier 	: currency_multiplier,
					fis_detay				:'HESAPTAN PARA ÇEKME İŞLEMİ',
					from_branch_id 			: branch_id_info,
					to_branch_id 			: to_branch_id,
					belge_no				: attributes.paper_number
				);
			}
			else
				muhasebe_sil (action_id:attributes.id,process_type:form.old_process_type);			
			f_kur_ekle_action(action_id:attributes.id,process_type:1,action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#');
			
			if(GET_CASH_ACTION.recordcount)
				f_kur_ekle_action(action_id:updCash,process_type:1,action_table_name:'CASH_ACTION_MONEY',action_table_dsn:'#dsn2#');
			attributes.actionId = attributes.id;
		</cfscript>     
        
    <cfelseif attributes.event eq 'del'>
		<cfscript>
			get_cash_action= getCashAction.get(id : attributes.id);		//Utility
			muhasebe_sil(action_id:attributes.id,process_type:attributes.old_process_type,belge_no:attributes.paper_no);
			delBankActions = BankActionsModel.del(id : attributes.id);
			delCashActions = CashActionsModel.del(id : GET_CASH_ACTION.ACTION_ID);
			attributes.actionId = attributes.id;
		</cfscript>	
    </cfif>
</cfif>
