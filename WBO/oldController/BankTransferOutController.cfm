<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Sevda Kurt			Developer	: Sevda Kurt		
Analys Date : 04/05/2016			Dev Date	: 04/05/2016		
Description :
	Bu controller giden havale objesine ait kontrolleri yapar modelleri çağırarak ilgili setleri çalıştırır.
	add,upd,addmulti,updmulti ve del event'larını çalıştırır.
----------------------------------------------------------------------->

<!------------------------------------------------------
	Event lere göre kontroller yapılıyor
-------------------------------------------------------->
<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1>
	<cfif isdefined("attributes.active_period") and attributes.active_period neq session.ep.period_id>
        <script type="text/javascript">
			alertObject({message: "<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!"});
        </script>
        <cfabort>
    </cfif>
    <cfif isdefined('attributes.event') and listFind('add,upd',attributes.event)>
    	<cf_date tarih='attributes.action_date'>
    	<cfif isdefined("attributes.paper_number")>
        	<cfif isdefined("attributes.id")>
            	<cfset actionColumn = 'ACTION_ID'>
                <cfset actionId = attributes.id>
            <cfelse>
            	<cfset actionColumn = ''>
                <cfset actionId = ''>            	
            </cfif>
        	<cfset column = "ACTION_ID">
        	<cfset control_paper_no = controlPaperNo.control(
				tableName	:	'BANK_ACTIONS',
				paperNoColumn	:	'PAPER_NO',
				paperNo		:	"'"&attributes.paper_number &"'",
				actionTypeColumn	:	'ACTION_TYPE_ID',
				actionTypes	:	25,
				actionIdColumn	:	actionColumn,
				actionId	:	actionId,
				actionDb	:	dsn2
			)>
            <cfif len(control_paper_no)>
                <script type="text/javascript">
                    alertObject({message: "<cfoutput>#control_paper_no#</cfoutput> <cf_get_lang dictionary_id='52624.Belge Numarası İle Kayıtlı Giden Havale İşlemi Var!'>"});
                </script>
                <cfabort>
            </cfif>
        </cfif>
        <cfif isdefined("form.process_cat")>
            <cfscript>
				get_process_type = getProcessType.get(form.process_cat);
                process_type = get_process_type.PROCESS_TYPE;
                is_cari = get_process_type.IS_CARI;
                is_account = get_process_type.IS_ACCOUNT;
                is_account_group = get_process_type.IS_ACCOUNT_GROUP;
                attributes.ACTION_VALUE = filterNum(attributes.ACTION_VALUE);
                attributes.OTHER_CASH_ACT_VALUE = filterNum(attributes.OTHER_CASH_ACT_VALUE);
                attributes.system_amount = filterNum(attributes.system_amount);
                attributes.masraf = filterNum(attributes.masraf);
                if(isdefined("attributes.branch_id") and len(attributes.branch_id))
                    branch_id_info = attributes.branch_id;
                else
                    branch_id_info = listgetat(session.ep.user_location,2,'-');
                if (session.ep.our_company_info.project_followup neq 1)
                {
                    attributes.project_id = "";
                    attributes.project_head = "";
                }
                attributes.acc_type_id = '';
                if(listlen(attributes.employee_id,'_') eq 2)
                {
                    attributes.acc_type_id = listlast(attributes.employee_id,'_');
                    attributes.employee_id = listfirst(attributes.employee_id,'_');
                }
                paper_currency_multiplier = '';
                for(j_sy = 1; j_sy lte attributes.kur_say; j_sy = j_sy+1)
                {
                    'attributes.txt_rate1_#j_sy#' = filterNum(evaluate('attributes.txt_rate1_#j_sy#'),session.ep.our_company_info.rate_round_num);
                    'attributes.txt_rate2_#j_sy#' = filterNum(evaluate('attributes.txt_rate2_#j_sy#'),session.ep.our_company_info.rate_round_num);
                    if( evaluate("attributes.hidden_rd_money_#j_sy#") is form.money_type)
                        paper_currency_multiplier = evaluate('attributes.txt_rate2_#j_sy#/attributes.txt_rate1_#j_sy#');
                }
                currency_multiplier = '';
                if(isDefined('attributes.kur_say') and len(attributes.kur_say))
                    for(mon=1;mon lte attributes.kur_say;mon=mon+1)
                    {
                        if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
                            currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
                        if(evaluate("attributes.hidden_rd_money_#mon#") is form.money_type)
                            masraf_curr_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
                        if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.currency_id)
                            dovizli_islem_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
                    }
            </cfscript>
			<cfif not len(attributes.masraf)>
                <cfset attributes.masraf = 0>
            </cfif>
			<cfif attributes.event is "add">
				<cfif len(form.bank_order_process_cat)>
                	<cfset get_bank_order_process_type = getProcessType.get(form.bank_order_process_cat)>
                    <cfset assign_order_process_type = get_bank_order_process_type.PROCESS_TYPE>
                    <cfset assign_order_cari = get_bank_order_process_type.IS_CARI>
                    <cfset assign_order_account = get_bank_order_process_type.IS_ACCOUNT>
                    <cfif ((assign_order_cari eq 1) and (is_cari eq 1)) or ((assign_order_account eq 1) and (is_account eq 0))>
                        <script type="text/javascript">
                            alertObject({message: "<cf_get_lang no ='399.İşlem Kategorilerinizi Kontrol Ediniz'>!"});
                        </script>
                        <cfabort>
                    </cfif>
                <cfelse>
					<cfset assign_order_cari = "">
                    <cfset assign_order_account = "">
                </cfif>
                <cfif (is_account eq 1) and len(form.acc_order_code) and (assign_order_account eq 1)><!--- Banka Talimatı Muhasebe Kodu --->
                    <cfset MY_ACC_RESULT = form.acc_order_code>
                <cfelseif is_account eq 1>
                    <cfif len(attributes.employee_id)><!--- çalışanın muhasebe kodu--->
                        <cfset MY_ACC_RESULT = GET_EMPLOYEE_PERIOD(attributes.employee_id,attributes.acc_type_id)>
                    <cfelseif len(form.ACTION_TO_COMPANY_ID)><!--- firmanın muhasebe kodu --->
                        <cfset MY_ACC_RESULT = GET_COMPANY_PERIOD(form.ACTION_TO_COMPANY_ID)>
                    <cfelseif len(form.ACTION_TO_CONSUMER_ID)><!---bireysel uyenin muhasebe kodu--->
                        <cfset MY_ACC_RESULT = GET_CONSUMER_PERIOD(form.ACTION_TO_CONSUMER_ID)>
                    </cfif>
                    <cfif not len(MY_ACC_RESULT)>
                        <script type="text/javascript">
                            alertObject({message: "<cf_get_lang no ='402.Seçtiğiniz Çalışan veya Üyenin Muhasebe Kodu Seçilmemiş'>!"});
                        </script>
                        <cfabort>
                    </cfif>
                </cfif>
                <cfscript>
					add = BankActionsModel.add(
						bank_order_id	:	iif(len(attributes.bank_order_id),attributes.bank_order_id,0),
						action_type		:	ACTION_TYPE,
						process_type	:	25,
						process_cat		:	form.process_cat,
						processStage	:	attributes.process_stage,
						to_company_id	:	iif(len(ACTION_TO_COMPANY_ID) and (len(attributes.employee_id) eq 0),ACTION_TO_COMPANY_ID,0),
						to_consumer_id	:	iif(len(ACTION_TO_CONSUMER_ID),ACTION_TO_CONSUMER_ID,0),
						to_employee_id	:	iif(len(attributes.employee_id),attributes.employee_id,0),
						from_account_id	:	attributes.account_id,
						action_value	:	iif(len(attributes.masraf),attributes.ACTION_VALUE + attributes.masraf,attributes.ACTION_VALUE),
						action_date		:	attributes.action_date,
						currency_id		:	attributes.currency_id,
						action_detail	:	attributes.ACTION_DETAIL,
						other_cash_act_value	:	attributes.OTHER_CASH_ACT_VALUE,
						money_type		:	money_type,
						is_account		:	is_account,
						is_account_type	:	13,
						paper_number	:	attributes.paper_number,
						project_id		:	iif(len(attributes.project_head) and len(attributes.project_id),attributes.project_id,0),
						expense			:	iif(len(attributes.masraf),attributes.masraf,0),
						expense_center_id	:	iif(isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and len(attributes.expense_center_name),attributes.expense_center_id,0),
						expense_item_id	:	iif(isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name),attributes.expense_item_id,0),
						from_branch_id	:	branch_id_info,
						system_amount	:	wrk_round((attributes.ACTION_VALUE + attributes.masraf)*dovizli_islem_multiplier),
						special_definition_id	:	iif(isdefined("attributes.special_definition_id") and len(attributes.special_definition_id),attributes.special_definition_id,0),
						assetp_id		:	iif(isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name),attributes.asset_id,0),
						acc_department_id	:	iif(isdefined("attributes.acc_department_id") and len(attributes.acc_department_id),attributes.acc_department_id,0),
						acc_type_id		:	iif(isdefined("attributes.acc_type_id") and len(attributes.acc_type_id),attributes.acc_type_id,0),
						action_value2	:	wrk_round(((attributes.ACTION_VALUE + attributes.masraf)*dovizli_islem_multiplier)/currency_multiplier,4)
					);
					if(assign_order_cari eq 1)
						setCariProcessedInfo.upd(
							isProcessed	:	1,
							actionId	:	attributes.bank_order_id,
							actionTypeId	:	assign_order_process_type
						);
					attributes.actionId = add;
                    if(is_cari eq 1)
                    {
                        carici (
                            action_id : add,
                            action_table : 'BANK_ACTIONS',
                            islem_belge_no : attributes.paper_number,
                            workcube_process_type :process_type,		
                            process_cat : form.process_cat,	
                            islem_tarihi : attributes.ACTION_DATE,
                            from_account_id : attributes.account_id,
                            islem_tutari : attributes.system_amount,
                            action_currency : session.ep.money,
                            other_money_value : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
                            other_money : form.money_type,
                            currency_multiplier : currency_multiplier,
                            islem_detay : ACTION_TYPE,
                            action_detail : attributes.action_detail,
                            account_card_type : 13,
                            acc_type_id : attributes.acc_type_id,
                            due_date: attributes.action_date,
                            to_employee_id : attributes.employee_id,
                            to_cmp_id : ACTION_TO_COMPANY_ID,
                            to_consumer_id : ACTION_TO_CONSUMER_ID,
                            project_id : attributes.project_id,
                            from_branch_id : branch_id_info,
                            expense_center_id : iif((isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and len(attributes.expense_center_name)),'attributes.expense_center_id',de('')),
                            expense_item_id : iif((isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)),'attributes.expense_item_id',de('')),
                            special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
                            assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
                            rate2:masraf_curr_multiplier
                            );
                    }
                    if(len(attributes.expense_item_id) and len(attributes.expense_item_name) and (attributes.masraf gt 0) and len(attributes.expense_center_id) and len(attributes.expense_center_name))
                    {
                        if(attributes.currency_id is session.ep.money)
                        {
                            butceci(
                                action_id : add,
                                muhasebe_db : dsn2,
                                is_income_expense : false,
                                process_type : process_type,
                                nettotal : attributes.masraf,
                                other_money_value : wrk_round(attributes.masraf/masraf_curr_multiplier),
                                action_currency : form.money_type,
                                currency_multiplier : currency_multiplier,
                                expense_date : attributes.action_date,
                                expense_center_id : attributes.expense_center_id,
                                expense_item_id : attributes.expense_item_id,
                                detail : 'GİDEN HAVALE MASRAFI',
                                paper_no : attributes.paper_number,
                                project_id : attributes.project_id,
                                company_id : ACTION_TO_COMPANY_ID,
                                consumer_id : ACTION_TO_CONSUMER_ID,
                                employee_id : attributes.employee_id,
                                branch_id : branch_id_info,
                                insert_type : 1//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
                            );
                        }
                        else
                        {
                            butceci(
                                action_id : add,
                                muhasebe_db : dsn2,
                                is_income_expense : false,
                                process_type : process_type,
                                nettotal : wrk_round(attributes.masraf*dovizli_islem_multiplier),
                                other_money_value : attributes.masraf,
                                action_currency : attributes.currency_id,
                                currency_multiplier : currency_multiplier,
                                expense_date : attributes.action_date,
                                expense_center_id : attributes.expense_center_id,
                                expense_item_id : attributes.expense_item_id,
                                detail : 'GİDEN HAVALE MASRAFI',
                                paper_no : attributes.paper_number,
                                project_id : attributes.project_id,
                                company_id : ACTION_TO_COMPANY_ID,
                                consumer_id : ACTION_TO_CONSUMER_ID,
                                employee_id : attributes.employee_id,
                                branch_id : branch_id_info,
                                insert_type : 1
                            );
                        }
                        GET_EXP_ACC = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #attributes.expense_item_id#");
                    }
                    if(is_account eq 1)
                    {
                        if(len(attributes.comp_name))
                            member_name_='#attributes.comp_name#';
                        else
                            member_name_='#attributes.emp_name#';
                    
                        if(isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
                            str_card_detail = '#member_name_#-#attributes.ACTION_DETAIL#';
                        else if(attributes.currency_id is session.ep.money)
                            str_card_detail = '#member_name_#-GİDEN HAVALE İŞLEMİ';
                        else
                            str_card_detail = '#member_name_#-DÖVİZLİ GİDEN HAVALE İŞLEMİ';
                        
                        str_borclu_hesaplar = MY_ACC_RESULT;
                        str_alacakli_hesaplar = attributes.account_acc_code;
                        str_tutarlar = attributes.system_amount;
                        
                        if(len(form.acc_order_code) and (assign_order_account eq 1))//talimattan havale oluştrmak için
                        {
                            str_borclu_other_amount_tutar = attributes.ACTION_VALUE;
                            str_borclu_other_currency = attributes.currency_id;
                        }
                        else
                        {
                            str_borclu_other_amount_tutar = attributes.OTHER_CASH_ACT_VALUE;
                            str_borclu_other_currency = form.money_type;
                        }
                        str_alacakli_other_amount_tutar = attributes.ACTION_VALUE;
                        str_alacakli_other_currency = attributes.currency_id;
                        
                        if(len(attributes.masraf) and attributes.masraf gt 0 and len(GET_EXP_ACC.ACCOUNT_CODE))
                        {
                            str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,GET_EXP_ACC.ACCOUNT_CODE,",");	
                            str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,attributes.account_acc_code,",");	
                            if(attributes.currency_id is session.ep.money)
                                str_tutarlar = ListAppend(str_tutarlar,attributes.masraf,",");
                            else
                                str_tutarlar = ListAppend(str_tutarlar,wrk_round(attributes.masraf*dovizli_islem_multiplier),",");
                            str_borclu_other_amount_tutar = ListAppend(str_borclu_other_amount_tutar,attributes.masraf,",");
                            str_borclu_other_currency = ListAppend(str_borclu_other_currency,attributes.currency_id,",");
                            str_alacakli_other_amount_tutar = ListAppend(str_alacakli_other_amount_tutar,attributes.masraf,",");
                            str_alacakli_other_currency = ListAppend(str_alacakli_other_currency,attributes.currency_id,",");
                        }
                        
                        if(isdefined('attributes.acc_department_id') and len(attributes.acc_department_id) )
                            acc_department_id = attributes.acc_department_id;
                        else
                            acc_department_id = '';
                            
                        muhasebeci (
                            action_id:add,
                            workcube_process_type:process_type,
                            workcube_process_cat:form.process_cat,
                            acc_department_id : acc_department_id,
                            account_card_type:13,
                            company_id: attributes.ACTION_TO_COMPANY_ID,
                            consumer_id:attributes.ACTION_TO_CONSUMER_ID,
                            islem_tarihi : attributes.ACTION_DATE,
                            belge_no : attributes.paper_number,
                            fis_satir_detay : str_card_detail,
                            borc_hesaplar : str_borclu_hesaplar,
                            borc_tutarlar : str_tutarlar,
                            other_amount_borc : str_borclu_other_amount_tutar,
                            other_currency_borc : str_borclu_other_currency,
                            alacak_hesaplar : str_alacakli_hesaplar,
                            alacak_tutarlar : str_tutarlar,
                            other_amount_alacak : str_alacakli_other_amount_tutar,
                            other_currency_alacak : str_alacakli_other_currency,
                            currency_multiplier : currency_multiplier,
                            is_account_group : is_account_group,
                            fis_detay:'GİDEN HAVALE İŞLEMİ',
                            from_branch_id : branch_id_info,
                            acc_project_id : attributes.project_id,
                            is_abort : iif(isdefined('xml_import'),0,1)
                        );			
                    }
                    f_kur_ekle_action(action_id:add,process_type:0,action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#');
					
					updPaperNo.upd(
						columnName	: 'OUTGOING_TRANSFER_NUMBER',
						paperNumber	: listLast(attributes.paper_number,'-')
					);
					if(isdefined("attributes.order_id") and len(attributes.order_id) and is_cari and isdefined("attributes.order_row_id") and len(attributes.order_row_id))//ödeme emirlerinden ödeme yapıldıgnda
					{
						GET_CARI_INFO = getCariActionId.get(
							actionId : add,
							actionType : process_type
						);
						if(len(GET_CARI_INFO.recordcount) and (isDefined("attributes.correspondence_info") and len(attributes.correspondence_info)))	
						{
							BankTransferOutModel.setClosedInfo(
								orderId : attributes.order_id,
								correspondence_info : attributes.correspondence_info,
								cariActionId	:	GET_CARI_INFO.CARI_ACTION_ID
							);
						}
						else if(len(GET_CARI_INFO.recordcount))
						{
							addClosed = BankTransferOutModel.addClosedInfo(
								orderId	:	attributes.order_id,
								cariActionId	:	GET_CARI_INFO.CARI_ACTION_ID,
								bankActionId	:	add,
								actionType		:	process_type,
								systemAmount	:	attributes.system_amount,
								otherMoneyValue	:	attributes.other_cash_act_value,
								otherMoney		:	attributes.money_type,
								dueDate			:	attributes.action_date
							);
							if(isdefined("attributes.order_row_id") and len(attributes.order_row_id))
							{
								BankTransferOutModel.setClosedInfo(
									orderId : attributes.order_id,
									order_row_id : attributes.order_row_id,
									closedRowId	:	addClosed
								);
							}
						}
					}
					if(len(attributes.bank_order_id))
					{
						GET_BANK_ORDERS = BankTransferOutModel.getBankOrder(orderId	: attributes.bank_order_id);
						if(len(get_bank_orders.closed_id))
						{
							GET_CARI_INFO = getCariActionId.get(
								actionId : add,
								actionType : process_type
							);
							if(len(GET_CARI_INFO.recordcount))
							{
								addClosed = BankTransferOutModel.addClosedInfo(
									orderId	:	get_bank_orders.closed_id,
									cariActionId	:	GET_CARI_INFO.CARI_ACTION_ID,
									bankActionId	:	add,
									actionType		:	process_type,
									systemAmount	:	GET_CARI_INFO.ACTION_VALUE,
									otherMoneyValue	:	GET_CARI_INFO.OTHER_CASH_ACT_VALUE,
									otherMoney		:	GET_CARI_INFO.OTHER_MONEY,
									dueDate			:	createodbcdatetime(GET_CARI_INFO.DUE_DATE)
								);
								BankTransferOutModel.setClosedInfo(
									orderId : get_bank_orders.closed_id,
									closedRowId	:	addClosed
								);
							}
						}
						updBankOrderStatus.upd(
							bankOrderId	:	attributes.bank_order_id,
							isPaid		:	1
						);	
					}
                </cfscript>
			<cfelseif attributes.event is "upd">
                <cfif isdefined('attributes.bank_order_id') and len(attributes.bank_order_id)>
                    <cfset get_bank_order = BankTransferOutModel.getBankOrder(attributes.bank_order_id)>
					<cfset process_type_inf = getProcessType.get(get_bank_order.bank_order_type_id)>
                    <cfif get_bank_order.recordcount>
                        <cfset assign_order_process_type = process_type_inf.PROCESS_TYPE>
                        <cfset assign_order_cari = process_type_inf.IS_CARI>
                        <cfset assign_order_account = process_type_inf.IS_ACCOUNT>
                    <cfelse>
                        <cfset assign_order_cari = "">
                        <cfset assign_order_account = "">
                    </cfif>
                    <cfif ((assign_order_cari eq 1) and (is_cari eq 1)) or ((assign_order_account eq 1) and (is_account eq 0))>
                        <script type="text/javascript">
                            alertObject({message: "<cf_get_lang no ='399.İşlem Kategorilerinizi Kontrol Ediniz'>!"});
                        </script>
                        <cfabort>
                    </cfif>
                <cfelse>
                    <cfset get_bank_order.recordcount=0>
                </cfif>
                <cfif is_account eq 1 and get_bank_order.recordcount neq 0 and assign_order_account eq 1 and len(get_bank_order.ACCOUNT_ORDER_CODE)> <!--- Banka Talimatı Muhasebe Kodu --->
                    <cfset MY_ACC_RESULT = get_bank_order.ACCOUNT_ORDER_CODE> <!--- banka talimatının muhasebe işleminde kullanılan talimat hesabı --->
                <cfelseif is_account eq 1>
                    <cfif len(attributes.employee_id)><!--- çalışanın muhasebe kodu--->
                        <cfset MY_ACC_RESULT = GET_EMPLOYEE_PERIOD(attributes.employee_id,attributes.acc_type_id)>
                    <cfelseif len(form.ACTION_TO_COMPANY_ID)><!--- firmanın muhasebe kodu --->
                        <cfset MY_ACC_RESULT = GET_COMPANY_PERIOD(form.ACTION_TO_COMPANY_ID)>
                    <cfelseif len(form.ACTION_TO_CONSUMER_ID)><!---	bireysel uyenin muhasebe kodu--->
                        <cfset MY_ACC_RESULT = GET_CONSUMER_PERIOD(form.ACTION_TO_CONSUMER_ID)>
                    </cfif>
                    <cfif not len(MY_ACC_RESULT)>
                        <script type="text/javascript">
                            alertObject({message: "<cf_get_lang no ='402.Seçtiğiniz Çalışan veya Üyenin Muhasebe Kodu Seçilmemiş'>!"});
                        </script>
                        <cfabort>
                    </cfif>
                </cfif>
                <cfset	upd = BankActionsModel.upd(
								id				:	attributes.ID,
								process_cat		:	form.process_cat,
								processStage	:	attributes.process_stage,
								to_company_id	:	iif(len(ACTION_TO_COMPANY_ID) and (len(attributes.employee_id) eq 0),ACTION_TO_COMPANY_ID,0),
								to_consumer_id	:	iif(len(ACTION_TO_CONSUMER_ID),ACTION_TO_CONSUMER_ID,0),
								to_employee_id	:	iif(len(attributes.employee_id),attributes.employee_id,0),
								from_account_id	:	attributes.account_id,
								action_value	:	iif(len(attributes.masraf),attributes.ACTION_VALUE + attributes.masraf,attributes.ACTION_VALUE),
								action_date		:	attributes.action_date,
								currency_id		:	attributes.currency_id,
								action_detail	:	attributes.ACTION_DETAIL,
								other_cash_act_value	:	attributes.OTHER_CASH_ACT_VALUE,
								money_type		:	money_type,
								is_account		:	is_account,
								is_account_type	:	13,
								paper_number	:	attributes.paper_number,
								project_id		:	iif(len(attributes.project_head) and len(attributes.project_id),attributes.project_id,0),
								expense			:	iif(len(attributes.masraf),attributes.masraf,0),
								expense_center_id	:	iif(isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and len(attributes.expense_center_name),attributes.expense_center_id,0),
								expense_item_id	:	iif(isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name),attributes.expense_item_id,0),
								from_branch_id	:	branch_id_info,
								system_amount	:	wrk_round((attributes.ACTION_VALUE + attributes.masraf)*dovizli_islem_multiplier),
								special_definition_id	:	iif(isdefined("attributes.special_definition_id") and len(attributes.special_definition_id),attributes.special_definition_id,0),
								assetp_id		:	iif(isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name),attributes.asset_id,0),
								acc_department_id	:	iif(isdefined("attributes.acc_department_id") and len(attributes.acc_department_id),attributes.acc_department_id,0),
								acc_type_id		:	iif(isdefined("attributes.acc_type_id") and len(attributes.acc_type_id),attributes.acc_type_id,0),
								action_value2	:	wrk_round(((attributes.ACTION_VALUE + attributes.masraf)*dovizli_islem_multiplier)/currency_multiplier,4)
						)>
				<cfscript>
                    //masraf kaydını siler
                    butce_sil(action_id:attributes.ID,process_type:form.old_process_type);
                    
                    if (is_cari eq 1)
                    {
                        carici(
                            action_id : attributes.ID,
                            action_table : 'BANK_ACTIONS',
                            islem_belge_no : attributes.paper_number,
                            workcube_process_type :process_type,
                            workcube_old_process_type :form.old_process_type,		
                            process_cat : form.process_cat,		
                            islem_tarihi : attributes.ACTION_DATE,
                            from_account_id : attributes.account_id,
                            islem_tutari : attributes.system_amount,
                            action_currency : session.ep.money,
                            other_money_value : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
                            other_money : iif(len(form.money_type),'form.money_type',de('')),
                            currency_multiplier : currency_multiplier,
                            islem_detay : ACTION_TYPE,
                            action_detail : attributes.action_detail,
                            account_card_type : 13,
                            acc_type_id : attributes.acc_type_id,
                            due_date: attributes.action_date,
                            to_employee_id : attributes.employee_id,	
                            to_cmp_id : ACTION_TO_COMPANY_ID,
                            to_consumer_id : ACTION_TO_CONSUMER_ID,
                            project_id : iif((len(attributes.project_id) and len(attributes.project_head)),attributes.project_id,de('')),
                            expense_center_id : iif((isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and len(attributes.expense_center_name)),'attributes.expense_center_id',de('')),
                            expense_item_id : iif((isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)),'attributes.expense_item_id',de('')),
                            special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
                            from_branch_id : branch_id_info,
                            assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
                            rate2:paper_currency_multiplier
                            );
                    }
                    else
                        cari_sil(action_id:attributes.ID,process_type:form.old_process_type);
                    
                    if(len(attributes.expense_item_id) and len(attributes.expense_item_name) and (attributes.masraf gt 0) and len(attributes.expense_center_id) and len(attributes.expense_center_name))
                    {
                        if(attributes.currency_id is session.ep.money)
                        {
                            butceci(
                                action_id : attributes.ID,
                                muhasebe_db : dsn2,
                                is_income_expense : false,
                                process_type : process_type,
                                nettotal : attributes.masraf,
                                other_money_value : wrk_round(attributes.masraf/masraf_curr_multiplier),
                                action_currency : form.money_type,
                                currency_multiplier : currency_multiplier,
                                expense_date : attributes.action_date,
                                expense_center_id : attributes.expense_center_id,
                                expense_item_id : attributes.expense_item_id,
                                detail : 'GİDEN HAVALE MASRAFI',
                                paper_no : attributes.paper_number,
                                project_id : iif((len(attributes.project_id) and len(attributes.project_head)),attributes.project_id,de('')),
                                company_id : ACTION_TO_COMPANY_ID,
                                consumer_id : ACTION_TO_CONSUMER_ID,
                                employee_id : attributes.employee_id,
                                branch_id : branch_id_info,
                                insert_type : 1
                            );
                        }
                        else
                        {				
                            butceci(
                                action_id : attributes.ID,
                                muhasebe_db : dsn2,
                                is_income_expense : false,
                                process_type : process_type,
                                nettotal : wrk_round(attributes.masraf*dovizli_islem_multiplier),
                                other_money_value : attributes.masraf,
                                action_currency : attributes.currency_id,
                                currency_multiplier : currency_multiplier,
                                expense_date : attributes.action_date,
                                expense_center_id : attributes.expense_center_id,
                                expense_item_id : attributes.expense_item_id,
                                detail : 'GİDEN HAVALE MASRAFI',
                                paper_no : attributes.paper_number,
                                project_id : iif((len(attributes.project_id) and len(attributes.project_head)),attributes.project_id,de('')),
                                company_id : ACTION_TO_COMPANY_ID,
                                consumer_id : ACTION_TO_CONSUMER_ID,
                                employee_id : attributes.employee_id,
                                branch_id : branch_id_info,
                                insert_type : 1
                            );
                        }
                        GET_EXP_ACC = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #attributes.expense_item_id#");
                    }
                    if (is_account eq 1)
                    {
                        if(len(attributes.comp_name))
                            member_name_='#attributes.comp_name#';
                        else
                            member_name_='#attributes.emp_name#';
                
                        if(isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
                            str_card_detail = '#member_name_#-#attributes.ACTION_DETAIL#';
                        else if(attributes.currency_id is session.ep.money)
                            str_card_detail = '#member_name_#-GİDEN HAVALE İŞLEMİ';
                        else
                            str_card_detail = '#member_name_#-DÖVİZLİ GİDEN HAVALE İŞLEMİ';
                
                        str_borclu_hesaplar = MY_ACC_RESULT;
                        str_alacakli_hesaplar = attributes.account_acc_code;
                        str_tutarlar = attributes.system_amount;
                        
                        if(get_bank_order.recordcount neq 0 and assign_order_account eq 1 and len(get_bank_order.ACCOUNT_ORDER_CODE))//talimattan havale oluştrmak için
                        {
                            str_borclu_other_amount_tutar = attributes.ACTION_VALUE;
                            str_borclu_other_currency = attributes.currency_id;
                        }
                        else
                        {
                            str_borclu_other_amount_tutar = attributes.OTHER_CASH_ACT_VALUE;
                            str_borclu_other_currency = form.money_type;
                        }
                        str_alacakli_other_amount_tutar = attributes.ACTION_VALUE;
                        str_alacakli_other_currency = attributes.currency_id;
                        
                        if(len(attributes.masraf) and attributes.masraf gt 0 and len(GET_EXP_ACC.ACCOUNT_CODE))
                        {
                            str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,GET_EXP_ACC.ACCOUNT_CODE,",");	
                            str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,attributes.account_acc_code,",");	
                            if(attributes.currency_id is session.ep.money)
                                str_tutarlar = ListAppend(str_tutarlar,attributes.masraf,",");
                            else
                                str_tutarlar = ListAppend(str_tutarlar,wrk_round(attributes.masraf*dovizli_islem_multiplier),",");
                            str_borclu_other_amount_tutar = ListAppend(str_borclu_other_amount_tutar,attributes.masraf,",");
                            str_borclu_other_currency = ListAppend(str_borclu_other_currency,attributes.currency_id,",");
                            str_alacakli_other_amount_tutar = ListAppend(str_alacakli_other_amount_tutar,attributes.masraf,",");
                            str_alacakli_other_currency = ListAppend(str_alacakli_other_currency,attributes.currency_id,",");
                        }
                        
                        if(isdefined('attributes.acc_department_id') and len(attributes.acc_department_id) )
                            acc_department_id = attributes.acc_department_id;
                        else
                            acc_department_id = '';
                            
                        muhasebeci (
                            action_id:attributes.ID,
                            workcube_process_type:process_type,
                            workcube_old_process_type:form.old_process_type,
                            workcube_process_cat:form.process_cat,
                            acc_department_id : acc_department_id,
                            account_card_type:13,
                            company_id: attributes.ACTION_TO_COMPANY_ID,
                            consumer_id:attributes.ACTION_TO_CONSUMER_ID,
                            islem_tarihi : attributes.ACTION_DATE,
                            belge_no : attributes.paper_number,
                            fis_satir_detay : str_card_detail,
                            borc_hesaplar : str_borclu_hesaplar,
                            borc_tutarlar : str_tutarlar,
                            other_amount_borc : str_borclu_other_amount_tutar,
                            other_currency_borc : str_borclu_other_currency,
                            alacak_hesaplar : str_alacakli_hesaplar,
                            alacak_tutarlar : str_tutarlar,
                            other_amount_alacak : str_alacakli_other_amount_tutar,
                            other_currency_alacak : str_alacakli_other_currency,
                            currency_multiplier : currency_multiplier,
                            is_account_group : is_account_group,
                            fis_detay:'GİDEN HAVALE İŞLEMİ',
                            acc_project_id : iif((len(attributes.project_id) and len(attributes.project_head)),attributes.project_id,de('')),
                            from_branch_id : branch_id_info
                        );
                    }
                    else
                        muhasebe_sil(action_id:attributes.ID,process_type:form.old_process_type);
                    f_kur_ekle_action(action_id:attributes.ID,process_type:1,action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#');
					attributes.actionId = attributes.id;
                </cfscript>
            </cfif>
        </cfif>
    <cfelseif isdefined('attributes.event') and listFind('addmulti,updmulti',attributes.event)>
    	<cf_papers paper_type="outgoing_transfer">
        <cf_date tarih='attributes.action_date'>
    	<cfscript>
        	if(not isdefined("attributes.new_period_id"))
				new_period_id = session.ep.period_id;
			else
				new_period_id = attributes.new_period_id;
			if(not isdefined("attributes.new_dsn3"))
				new_dsn3 = dsn3;
			else
				new_dsn3 = attributes.new_dsn3;
			if(not isdefined("attributes.new_dsn2"))
				new_dsn2 = dsn2;
			else
				new_dsn2 = attributes.new_dsn2;
				
			get_process_type = getProcessType.get(form.process_cat);
			process_type = get_process_type.process_type;
			multi_type = get_process_type.multi_type;
			is_account_group = get_process_type.is_account_group;
			for(r=1; r lte attributes.record_num; r=r+1)
			{
				if(evaluate('attributes.row_kontrol#r#') eq 1)
				{
					'attributes.action_value#r#' = filterNum(evaluate('attributes.action_value#r#'));
					'attributes.action_value_other#r#' = filterNum(evaluate('attributes.action_value_other#r#'));
					'attributes.system_amount#r#' = filterNum(evaluate('attributes.system_amount#r#'));
					'attributes.expense_amount#r#' = filterNum(evaluate('attributes.expense_amount#r#'));
				}
			}
			for(k=1; k lte attributes.kur_say; k=k+1)
			{
				'attributes.txt_rate2_#k#' = filterNum(evaluate('attributes.txt_rate2_#k#'),session.ep.our_company_info.rate_round_num);
				'attributes.txt_rate1_#k#' = filterNum(evaluate('attributes.txt_rate1_#k#'),session.ep.our_company_info.rate_round_num);
			}
			if(isdefined("attributes.branch_id") and len(attributes.branch_id))
				branch_id_info = attributes.branch_id;
			else
				branch_id_info = listgetat(session.ep.user_location,2,'-');
				
			currency_multiplier = '';
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
			{
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
				{
					if( evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
						currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					if(evaluate("attributes.hidden_rd_money_#mon#") is listfirst(attributes.rd_money,','))
						masraf_curr_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					if(evaluate("attributes.hidden_rd_money_#mon#") eq attributes.currency_id)
						dovizli_islem_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				}
			}
			if(attributes.event is "addmulti")
			{
				/*giden havale işlem tarihine göre ilgili döneme kayıt atacak SG 20141017*/
				get_period_id = getSetupPeriod.get(
					branchId	:	branch_id_info,
					date		:	attributes.action_date
				);
				new_dsn2 = '#dsn#_#get_period_id.period_year#_#get_period_id.OUR_COMPANY_ID#';
				new_dsn3 = '#dsn#_#get_period_id.OUR_COMPANY_ID#';
				new_period_id = get_period_id.period_id;
			}
        </cfscript>
        <cfif attributes.event is "addmulti">
            <cfset addMulti = BankActionsModel.addMulti(
				processCat	:	attributes.process_cat,
				processType	:	process_type,
				processStage:	attributes.process_stage,
				accountId	:	attributes.account_id,
				actionDate	:	attributes.action_date,
				isAccount	:	get_process_type.is_account,
				accountType	:	13,
				dsn			:	new_dsn2
			)>
            <cfset attributes.actionId = addMulti>
			<cfif isdefined("attributes.puantaj_id")><!--- puantajdan geliyorsa puantaj tablolarını update edecek--->
            	<cfset aaa = updPuantajInfo.upd(
					actionId	:	addMulti,
					periodId	:	new_period_id,
					puantajId	:	attributes.puantaj_id,
					isVirtual	:	attributes.is_virtual
				)>
            </cfif>
            <cfif isdefined("attributes.record_num") and len(attributes.record_num)>
            	<cfloop from="1" to="#attributes.record_num#" index="i">
                	<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
                    	<cfif isDefined("attributes.bank_order_id#i#") and len(evaluate("attributes.bank_order_id#i#"))>
                        	<cfset get_bank_order_process_type = getProcessType(evaluate("attributes.bank_order_process_cat#i#"))>
							<cfset bank_order_process_type = get_bank_order_process_type.PROCESS_TYPE>
                            <cfset bank_order_cari = get_bank_order_process_type.IS_CARI>
                            <cfset bank_order_account = get_bank_order_process_type.IS_ACCOUNT>
                            <!--- Eğer banka talimatında cari işlem yapılmışsa havalede yapılmamalı, 
                            veya banka talimatında muhasebe işlemi yapılmışsa havalede de bu işlemi kapatmak için muhasebe işlemi yapılmalı. Bunlar için kontrol yapılıyor.--->
                            <cfif ((bank_order_cari eq 1) and (get_process_type.is_cari eq 1)) or ((bank_order_account eq 1) and (get_process_type.is_account eq 0))>
                                <script type="text/javascript">
                                    alertObject({message : "<cf_get_lang no ='399.İşlem Kategorilerinizi Kontrol Ediniz'>!"});
                                </script>
                                <cfabort>
                            </cfif>
                        </cfif>
                    </cfif>
                </cfloop>
            </cfif>
        <cfelseif attributes.event is "updmulti">
            <cfset updMulti = BankActionsModel.updMulti(
				actionId	:	form.multi_id,
				processCat	:	attributes.process_cat,
				processType	:	process_type,
				processStage:	attributes.process_stage,
				accountId	:	attributes.account_id,
				actionDate	:	attributes.action_date,
				isAccount	:	get_process_type.is_account,
				accountType	:	13,
				dsn			:	new_dsn2	
			)>
            <cfset attributes.actionId = updMulti>    
    	</cfif>
        <cfif isdefined("attributes.record_num") and len(attributes.record_num)>
            <cfloop from="1" to="#attributes.record_num#" index="i">
                <cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") and (attributes.event is "addmulti" or (attributes.event is "updmulti" and not isdefined("attributes.act_row_id#i#")))><!--- satır silinmemişse, ekleme işlemi ise ya da güncelleme olup yeni satır eklemeler ise --->
					<cfscript>
                        attributes.acc_type_id = '';
                        if(listlen(evaluate("action_employee_id#i#"),'_') eq 2)
                        {
                            attributes.acc_type_id = listlast(evaluate("action_employee_id#i#"),'_');
                            "action_employee_id#i#" = listfirst(evaluate("action_employee_id#i#"),'_');
                        }
                        paper_currency_multiplier = '';
                        if(isDefined('attributes.kur_say') and len(attributes.kur_say))
                            for(mon=1;mon lte attributes.kur_say;mon=mon+1)
                                if( evaluate("attributes.hidden_rd_money_#mon#") is listfirst(evaluate("attributes.money_id#i#"),';'))
                                    paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
						if(len(paper_number))
							paper_number++;
						if(not len(evaluate("attributes.expense_amount#i#")))
							"attributes.expense_amount#i#" = 0;
						if(attributes.event is "addmulti")
						{
							add = BankActionsModel.add(
								multi_action_id	:	addMulti,
								bank_order_id	:	iif(isDefined("attributes.bank_order_id#i#") and len(evaluate("attributes.bank_order_id#i#")),de("attributes.bank_order_id#i#"),0),
								action_type		:	'GİDEN HAVALE',
								process_type	:	25,
								process_cat		:	form.process_cat,
								to_company_id	:	iif(len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'partner' and len(evaluate("action_company_id#i#")),evaluate("action_company_id#i#"),0),
								to_consumer_id	:	iif(len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'consumer' and len(evaluate("action_consumer_id#i#")),evaluate("action_consumer_id#i#"),0),
								to_employee_id	:	iif(len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'employee' and len(evaluate("action_employee_id#i#")),evaluate("action_employee_id#i#"),0),
								from_account_id	:	attributes.account_id,
								action_value	:	iif(len(evaluate("attributes.expense_amount#i#")),evaluate("attributes.action_value#i#") + evaluate("attributes.expense_amount#i#"),evaluate("attributes.action_value#i#")),
								action_date		:	attributes.action_date,
								currency_id		:	attributes.currency_id,
								action_detail	:	iif(isDefined("attributes.action_detail#i#") and len(evaluate("attributes.action_detail#i#")),wrk_eval("attributes.action_detail#i#"),''),
								other_cash_act_value	:	evaluate("attributes.action_value_other#i#"),
								money_type		:	listfirst(evaluate("attributes.money_id#i#"),';'),
								is_account		:	get_process_type.is_account,
								is_account_type	:	12,
								paper_number	:	evaluate("attributes.paper_number#i#"),
								project_id		:	iif(len(attributes['project_head#i#']) and len(attributes['project_id#i#']),attributes['project_id#i#'],0),
								expense			:	iif(len(evaluate("attributes.expense_amount#i#")),wrk_eval("attributes.expense_amount#i#"),0),
								expense_center_id	:	iif(len(evaluate("attributes.expense_center_id#i#")),wrk_eval("attributes.expense_center_id#i#"),0),
								expense_item_id	:	iif(len(evaluate("attributes.expense_item_id#i#")),wrk_eval("attributes.expense_item_id#i#"),0),
								from_branch_id	:	branch_id_info,
								system_amount	:	wrk_round((evaluate("attributes.action_value#i#") + evaluate("attributes.expense_amount#i#"))*dovizli_islem_multiplier),
								special_definition_id	:	iif(isDefined("attributes.special_definition_id#i#") and len(evaluate("attributes.special_definition_id#i#")),evaluate("attributes.special_definition_id#i#"),0),
								assetp_id		:	iif(isDefined("attributes.asset_id#i#") and len(evaluate("attributes.asset_name#i#")) and len(evaluate("attributes.asset_id#i#")),evaluate("attributes.asset_id#i#"),0),
								acc_department_id	:	iif(isdefined("attributes.acc_department_id") and len(attributes.acc_department_id),attributes.acc_department_id,0),
								acc_type_id		:	iif(isdefined("attributes.acc_type_id") and len(attributes.acc_type_id),attributes.acc_type_id,0),
								avans_id		:	iif(len(evaluate("attributes.avans_id#i#")),evaluate("attributes.avans_id#i#"),0),
								related_cari_action_id	:	iif(isdefined("attributes.related_cari_action_id#i#") and len(evaluate("attributes.related_cari_action_id#i#")),de("attributes.related_cari_action_id#i#"),0),
								action_value2	:	wrk_round((evaluate("attributes.action_value#i#") + evaluate("attributes.expense_amount#i#"))*dovizli_islem_multiplier/currency_multiplier,4),
								dsn				:	new_dsn2
							);
							/*banka talimatlarından kaydedilen toplu gelen havale satirlari icin 1 set ediliyor*/
							if(isDefined("attributes.bank_order_id#i#") and len(evaluate("attributes.bank_order_id#i#")))
							{
								updBankOrderStatus.upd(
									bankOrderId	:	evaluate("attributes.bank_order_id#i#"),
									isPaid		:	1,
									newDsn		:	new_dsn2
								);
								setCariProcessedInfo.upd(
									isProcessed	:	1,
									actionId	:	evaluate("attributes.bank_order_id#i#"),
									actionTypeId	:	bank_order_process_type,
									dsn			:	new_dsn2
								);
							}
							if(isdefined("attributes.payment_ids") and len(evaluate("attributes.avans_id#i#")))/*avans taleplerinden geliyor ise avans*/
								updCorrespondencePayment.upd(
                                    correspondenceId	:	evaluate("attributes.avans_id#i#"),
                                    actionId			:	add,
                                    actionTypeId		:	25,
                                    actionPeriodId		:	new_period_id
                                );
						}
						else if(attributes.event is "updmulti")
						{
							add = BankActionsModel.add(
								multi_action_id	:	updMulti,
								action_type		:	'GİDEN HAVALE',
								process_type	:	25,
								process_cat		:	form.process_cat,
								to_company_id	:	iif(len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'partner' and len(evaluate("action_company_id#i#")),evaluate("action_company_id#i#"),0),
								to_consumer_id	:	iif(len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'consumer' and len(evaluate("action_consumer_id#i#")),evaluate("action_consumer_id#i#"),0),
								to_employee_id	:	iif(len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'employee' and len(evaluate("action_employee_id#i#")),evaluate("action_employee_id#i#"),0),
								from_account_id	:	attributes.account_id,
								action_value	:	iif(len(evaluate("attributes.expense_amount#i#")),evaluate("attributes.action_value#i#") + evaluate("attributes.expense_amount#i#"),evaluate("attributes.action_value#i#")),
								action_date		:	attributes.action_date,
								currency_id		:	attributes.currency_id,
								action_detail	:	iif(isDefined("attributes.action_detail#i#") and len(evaluate("attributes.action_detail#i#")),wrk_eval("attributes.action_detail#i#"),''),
								other_cash_act_value	:	evaluate("attributes.action_value_other#i#"),
								money_type		:	listfirst(evaluate("attributes.money_id#i#"),';'),
								is_account		:	get_process_type.is_account,
								is_account_type	:	12,
								paper_number	:	evaluate("attributes.paper_number#i#"),
								project_id		:	iif(len(attributes['project_head#i#']) and len(attributes['project_id#i#']),attributes['project_id#i#'],0),
								expense			:	iif(len(evaluate("attributes.expense_amount#i#")),wrk_eval("attributes.expense_amount#i#"),0),
								expense_center_id	:	iif(len(evaluate("attributes.expense_center_id#i#")),wrk_eval("attributes.expense_center_id#i#"),0),
								expense_item_id	:	iif(len(evaluate("attributes.expense_item_id#i#")),wrk_eval("attributes.expense_item_id#i#"),0),
								from_branch_id	:	branch_id_info,
								system_amount	:	wrk_round((evaluate("attributes.action_value#i#") + evaluate("attributes.expense_amount#i#"))*dovizli_islem_multiplier),
								special_definition_id	:	iif(isDefined("attributes.special_definition_id#i#") and len(evaluate("attributes.special_definition_id#i#")),evaluate("attributes.special_definition_id#i#"),0),
								assetp_id		:	iif(isDefined("attributes.asset_id#i#") and len(evaluate("attributes.asset_name#i#")) and len(evaluate("attributes.asset_id#i#")),evaluate("attributes.asset_id#i#"),0),
								acc_department_id	:	iif(isdefined("attributes.acc_department_id") and len(attributes.acc_department_id),attributes.acc_department_id,0),
								acc_type_id		:	iif(isdefined("attributes.acc_type_id") and len(attributes.acc_type_id),attributes.acc_type_id,0),
								action_value2	:	wrk_round((evaluate("attributes.action_value#i#") + evaluate("attributes.expense_amount#i#"))*dovizli_islem_multiplier/currency_multiplier,4),
								dsn				:	new_dsn2
							);	
						}
                        exp_center_id = evaluate("expense_center_id#i#");
                        exp_item_id = evaluate("expense_item_id#i#");
                        
                        to_cmp_id = '';
                        to_consumer_id = '';
                        to_employee_id = '';
                        if (len(evaluate("action_company_id#i#")) and evaluate("member_type#i#") eq 'partner')
                            to_cmp_id = evaluate("action_company_id#i#");
                        else if (len(evaluate("action_consumer_id#i#")) and evaluate("member_type#i#") eq 'consumer') 
                            to_consumer_id = evaluate("action_consumer_id#i#");
                        else
                            to_employee_id = evaluate("action_employee_id#i#");
                        
                        if(isDefined("attributes.asset_id#i#") and len(evaluate("attributes.asset_name#i#")) and len(evaluate("attributes.asset_id#i#")))
                            asset_id = evaluate("asset_id#i#");
                        else
                            asset_id = '';
                        if(isDefined("attributes.special_definition_id#i#") and len(evaluate("attributes.special_definition_id#i#")))
                            special_definition_id = evaluate("special_definition_id#i#");
                        else
                            special_definition_id = '';
                        if (session.ep.our_company_info.project_followup neq 1)//isdefined lar altta functionlarda sıkıntı yaratıyordu buraya tanımlandı
                        {
                            attributes.project_id = "";
                            attributes.project_head = "";
                        }
                        else
                        {
                            attributes.project_id = evaluate("attributes.project_id#i#");
                            attributes.project_head = evaluate("attributes.project_head#i#");
                        }
                        
                        if(get_process_type.is_cari eq 1)
                        {	
                            carici(
                                action_id : add,
                                action_table : 'BANK_ACTIONS',
                                islem_belge_no : evaluate("attributes.paper_number#i#"),
                                workcube_process_type : 25,		
                                process_cat : 0,	
                                islem_tarihi : attributes.action_date,
                                from_account_id : attributes.account_id,
                                from_branch_id : branch_id_info,
                                islem_tutari : evaluate("attributes.system_amount#i#"),
                                action_currency : session.ep.money,
								action_detail : evaluate("attributes.action_detail#i#"),
                                other_money_value : evaluate("attributes.action_value_other#i#"),
                                other_money : listfirst(evaluate("attributes.money_id#i#"),';'),		
                                currency_multiplier : currency_multiplier,
                                account_card_type : 13,
                                acc_type_id : attributes.acc_type_id,
                                islem_detay : 'GİDEN HAVALE İŞLEMİ',
                                action_detail : evaluate("attributes.action_detail#i#"),
                                due_date: attributes.action_date,
                                project_id : iif((len(attributes.project_id) and len(attributes.project_head)),attributes.project_id,de('')),
                                to_cmp_id : to_cmp_id,
                                to_consumer_id : to_consumer_id,
                                to_employee_id : to_employee_id,
                                special_definition_id : special_definition_id,
                                assetp_id : asset_id,
                                rate2:paper_currency_multiplier,
                                cari_db : new_dsn2
                                );
                        }
                        if(len(exp_center_id) and len(exp_item_id) and evaluate("attributes.expense_amount#i#") gt 0)
                        {
                            butceci(
                                action_id : add,
                                muhasebe_db : new_dsn2,
                                is_income_expense : false,
                                process_type : 25,
                                nettotal : wrk_round(evaluate("attributes.expense_amount#i#")*dovizli_islem_multiplier),
                                other_money_value : evaluate("attributes.expense_amount#i#"),
                                action_currency : attributes.currency_id,
                                currency_multiplier : currency_multiplier,
                                expense_date : attributes.action_date,
                                expense_center_id : exp_center_id,
                                expense_item_id : exp_item_id,
                                detail : 'GİDEN HAVALE MASRAFI',
                                paper_no : evaluate("attributes.paper_number#i#"),
                                project_id : iif((len(attributes.project_id) and len(attributes.project_head)),attributes.project_id,de('')),
                                company_id : to_cmp_id,
                                consumer_id : to_consumer_id,
                                employee_id : to_employee_id,
                                branch_id : branch_id_info,
                                insert_type : 1
                            );
                        }
						if(attributes.event is "addmulti")
						{
							/*Eğer talimattan geliyorsa talimatın bağlı olduğu ödeme emri kapatılıyor*/
							if(isDefined("attributes.bank_order_id#i#") and len(evaluate("attributes.bank_order_id#i#")))
							{
								GET_BANK_ORDERS = BankTransferOutModel.getBankOrder(orderId	: attributes.bank_order_id);
								if(len(get_bank_orders.closed_id))
								{
									GET_CARI_INFO = getCariActionId.get(
										actionId : add,
										actionType : 25
									);
									if(len(GET_CARI_INFO.recordcount))
									{
										addClosed = BankTransferOutModel.addClosedInfo(
											orderId	:	get_bank_orders.closed_id,
											cariActionId	:	GET_CARI_INFO.CARI_ACTION_ID,
											bankActionId	:	add,
											actionType		:	25,
											systemAmount	:	GET_CARI_INFO.ACTION_VALUE,
											otherMoneyValue	:	GET_CARI_INFO.OTHER_CASH_ACT_VALUE,
											otherMoney		:	GET_CARI_INFO.OTHER_MONEY,
											dueDate			:	createodbcdatetime(GET_CARI_INFO.DUE_DATE)
										);
										BankTransferOutModel.setClosedInfo(
											orderId : get_bank_orders.closed_id,
											closedRowId	:	addClosed
										);		
									}
								}
							}
						}
                    </cfscript>
                <cfelseif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") and attributes.event is "updmulti" and isdefined("attributes.act_row_id#i#") and len(evaluate("attributes.act_row_id#i#"))><!--- güncelleme işleminde güncellenecek satırlar --->
                    <cfscript>
						attributes.acc_type_id = '';
						if(listlen(evaluate("attributes.action_employee_id#i#"),'_') eq 2)
						{
							attributes.acc_type_id = listlast(evaluate("attributes.action_employee_id#i#"),'_');
							attributes['action_employee_id#i#'] = listfirst(evaluate("attributes.action_employee_id#i#"),'_');
						}
						upd = BankActionsModel.upd(
								multi_action_id	:	updMulti,
								id				:	evaluate("attributes.act_row_id#i#"),
								process_cat		:	form.process_cat,
								to_company_id	:	iif(len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'partner' and len(evaluate("action_company_id#i#")),evaluate("action_company_id#i#"),0),
								to_consumer_id	:	iif(len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'consumer' and len(evaluate("action_consumer_id#i#")),evaluate("action_consumer_id#i#"),0),
								to_employee_id	:	iif(len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'employee' and len(evaluate("action_employee_id#i#")),evaluate("action_employee_id#i#"),0),
								from_account_id	:	attributes.account_id,
								action_value	:	iif(len(evaluate("attributes.expense_amount#i#")),evaluate("attributes.action_value#i#") + evaluate("attributes.expense_amount#i#"),evaluate("attributes.action_value#i#")),
								action_date		:	attributes.action_date,
								currency_id		:	attributes.currency_id,
								action_detail	:	iif(isDefined("attributes.action_detail#i#") and len(evaluate("attributes.action_detail#i#")),wrk_eval("attributes.action_detail#i#"),''),
								other_cash_act_value	:	evaluate("attributes.action_value_other#i#"),
								money_type		:	listfirst(evaluate("attributes.money_id#i#"),';'),
								is_account		:	get_process_type.is_account,
								paper_number	:	evaluate("attributes.paper_number#i#"),
								project_id		:	iif(len(attributes['project_head#i#']) and len(attributes['project_id#i#']),attributes['project_id#i#'],0),
								expense			:	iif(len(evaluate("attributes.expense_amount#i#")),wrk_eval("attributes.expense_amount#i#"),0),
								expense_center_id	:	iif(len(evaluate("attributes.expense_center_id#i#")),wrk_eval("attributes.expense_center_id#i#"),0),
								expense_item_id	:	iif(len(evaluate("attributes.expense_item_id#i#")),wrk_eval("attributes.expense_item_id#i#"),0),
								from_branch_id	:	branch_id_info,
								system_amount	:	wrk_round((evaluate("attributes.action_value#i#") + evaluate("attributes.expense_amount#i#"))*dovizli_islem_multiplier),
								special_definition_id	:	iif(isDefined("attributes.special_definition_id#i#") and len(evaluate("attributes.special_definition_id#i#")),evaluate("attributes.special_definition_id#i#"),0),
								assetp_id		:	iif(isDefined("attributes.asset_id#i#") and len(evaluate("attributes.asset_name#i#")) and len(evaluate("attributes.asset_id#i#")),evaluate("attributes.asset_id#i#"),0),
								acc_department_id	:	iif(isdefined("attributes.acc_department_id") and len(attributes.acc_department_id),attributes.acc_department_id,0),
								acc_type_id		:	iif(isdefined("attributes.acc_type_id") and len(attributes.acc_type_id),attributes.acc_type_id,0),
								action_value2	:	wrk_round((evaluate("attributes.action_value#i#") + evaluate("attributes.expense_amount#i#"))*dovizli_islem_multiplier/currency_multiplier,4),
								dsn				:	new_dsn2
						);
                        butce_sil(action_id:evaluate("attributes.act_row_id#i#"),process_type:25,muhasebe_db : new_dsn2);
                        exp_center_id = evaluate("expense_center_id#i#");
                        exp_item_id = evaluate("expense_item_id#i#");
                        to_cmp_id = '';
                        to_consumer_id = '';
                        to_employee_id = '';
						attributes.acc_type_id = '';
                        if (len(evaluate("action_company_id#i#")) and evaluate("member_type#i#") eq 'partner')
                            to_cmp_id = evaluate("action_company_id#i#");
                        else if (len(evaluate("action_consumer_id#i#")) and evaluate("member_type#i#") eq 'consumer') 
                            to_consumer_id = evaluate("action_consumer_id#i#");
                        else
						{
							if(listlen(evaluate("attributes.action_employee_id#i#"),'_') eq 2)
							{
								attributes.acc_type_id = listlast(evaluate("attributes.action_employee_id#i#"),'_');
								to_employee_id = listfirst(evaluate("attributes.action_employee_id#i#"),'_');
							}
							else
								to_employee_id = evaluate("action_employee_id#i#");
						}
                        if(isDefined("attributes.asset_id#i#") and len(evaluate("attributes.asset_name#i#")) and len(evaluate("attributes.asset_id#i#")))
                            asset_id = evaluate("asset_id#i#");
                        else
                            asset_id = '';
                        if(isDefined("attributes.special_definition_id#i#") and len(evaluate("attributes.special_definition_id#i#")))
                            special_definition_id = evaluate("special_definition_id#i#");
                        else
                            special_definition_id = '';
                            
                        if (session.ep.our_company_info.project_followup neq 1)//isdefined lar altta functionlarda sıkıntı yaratıyordu buraya tanımlandı
                        {
                            attributes.project_id = "";
                            attributes.project_head = "";
                        }
                        else
                        {
                            attributes.project_id = evaluate("attributes.project_id#i#");
                            attributes.project_head = evaluate("attributes.project_head#i#");
                        }
						paper_currency_multiplier = '';
                        if(isDefined('attributes.kur_say') and len(attributes.kur_say))
                            for(mon=1;mon lte attributes.kur_say;mon=mon+1)
                                if( evaluate("attributes.hidden_rd_money_#mon#") is listfirst(evaluate("attributes.money_id#i#"),';'))
                                    paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
                        if(get_process_type.is_cari eq 1)
                        {
                            carici(
                                action_id : evaluate("attributes.act_row_id#i#"),
                                action_table : 'BANK_ACTIONS',
                                islem_belge_no : evaluate("attributes.paper_number#i#"),
                                workcube_process_type : 25,		
                                workcube_old_process_type : 25,		
                                process_cat : 0,	
                                islem_tarihi : attributes.action_date,
                                from_account_id : attributes.account_id,
                                from_branch_id : branch_id_info,
                                islem_tutari : evaluate("attributes.system_amount#i#"),
                                action_currency : session.ep.money,
                                other_money_value : evaluate("attributes.action_value_other#i#"),
                                other_money : listfirst(evaluate("attributes.money_id#i#"),';'),		
                                currency_multiplier : currency_multiplier,
                                account_card_type : 13,
                                acc_type_id : attributes.acc_type_id,
                                islem_detay : 'GİDEN HAVALE İŞLEMİ',
                                action_detail : evaluate("attributes.action_detail#i#"),
                                due_date: attributes.action_date,
                                project_id : iif((len(attributes.project_id) and len(attributes.project_head)),attributes.project_id,de('')),
                                to_cmp_id : to_cmp_id,
                                to_consumer_id : to_consumer_id,
                                to_employee_id : to_employee_id,
                                special_definition_id : special_definition_id,
                                assetp_id : asset_id,
                                rate2:paper_currency_multiplier,
                                cari_db : new_dsn2
                                );
                        }
                        else
                            cari_sil(action_id:evaluate("attributes.act_row_id#i#"),process_type:25);
                        if(len(exp_center_id) and len(exp_item_id) and evaluate("attributes.expense_amount#i#") gt 0)
                        {
                            butceci(
                                action_id : evaluate("attributes.act_row_id#i#"),
                                muhasebe_db : new_dsn2,
                                is_income_expense : false,
                                process_type : 25,
                                nettotal : wrk_round(evaluate("attributes.expense_amount#i#")*dovizli_islem_multiplier),
                                other_money_value : evaluate("attributes.expense_amount#i#"),
                                action_currency : attributes.currency_id,
                                currency_multiplier : currency_multiplier,
                                expense_date : attributes.action_date,
                                expense_center_id : exp_center_id,
                                expense_item_id : exp_item_id,
                                detail : 'GİDEN HAVALE MASRAFI',
                                paper_no : evaluate("attributes.paper_number#i#"),
                                project_id : iif((len(attributes.project_id) and len(attributes.project_head)),attributes.project_id,de('')),
                                company_id : to_cmp_id,
                                consumer_id : to_consumer_id,
                                employee_id : to_employee_id,
                                branch_id : branch_id_info,
                                insert_type : 1
                            );
                        }
                    </cfscript>
				<cfelseif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") eq 0 and isdefined("attributes.act_row_id#i#") and len(evaluate("attributes.act_row_id#i#"))><!--- satır silmeler --->
                    <cfscript>
						/*avans taleplerinde bu satırla ilgili kayıt var ise update et*/
                    	if(len(evaluate("attributes.avans_id#i#")))
							updCorrespondencePayment.upd(
								correspondenceId	: evaluate("attributes.avans_id#i#"),
								actionId			: evaluate("attributes.act_row_id#i#")
							);
							
						getBankOrderId = getOrderId.get(
							multiId		:	form.multi_id,
							actionId	:	evaluate("attributes.act_row_id#i#"),
							dsn			:	new_dsn2
						);
						if(getBankOrderId.recordcount)
						{
							updBankOrderStatus.upd(
								bankOrderId	:	getBankOrderId.bank_order_id,
								isPaid		:	0,
								newDsn		:	new_dsn2
							);
						}
						BankActionsModel.del(
							id	:	evaluate("attributes.act_row_id#i#"),
							multi_action_id	:	form.multi_id
						);
                        cari_sil(action_id:evaluate("attributes.act_row_id#i#"),process_type:25,cari_db : new_dsn2);
                        butce_sil(action_id:evaluate("attributes.act_row_id#i#"),process_type:25,muhasebe_db : new_dsn2);
                    </cfscript>
                </cfif>
           	</cfloop>
       	</cfif>
		<cfscript>
            if(get_process_type.is_account eq 1)
            {
                borc_hesap_list='';
                alacak_hesap_list='';
                borc_tutar_list ='';
                alacak_tutar_list = '';
                doviz_tutar_borc = '';
                doviz_tutar_alacak = '';
                doviz_currency_borc = '';
                doviz_currency_alacak = '';
                acc_project_list_borc = '';
                acc_project_list_alacak = '';
                satir_detay_list = ArrayNew(2);
                if(isdefined('attributes.acc_department_id') and len(attributes.acc_department_id) )
                    acc_department_id = attributes.acc_department_id;
                else
                    acc_department_id = '';
                    
                if( isdefined("attributes.record_num") and attributes.record_num neq "")
                {
                    for(j=1; j lte attributes.record_num; j=j+1)
                        if( isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#") eq 1)
                        {
                            attributes.acc_type_id = '';
                            if(listlen(evaluate("attributes.action_employee_id#j#"),'_') eq 2)
                            {
                                attributes.acc_type_id = listlast(evaluate("attributes.action_employee_id#j#"),'_');
                                "action_employee_id#j#" = listfirst(evaluate("attributes.action_employee_id#j#"),'_');
                            }
                            alacak_hesap_list = listappend(alacak_hesap_list,attributes.account_acc_code,',');
                            alacak_tutar_list = listappend(alacak_tutar_list,evaluate("attributes.system_amount#j#"));
                            doviz_tutar_alacak = listappend(doviz_tutar_alacak,evaluate("attributes.action_value#j#"));
                            doviz_currency_alacak = listappend(doviz_currency_alacak,attributes.currency_id,',');
                            if(is_account_group neq 1)
                            {
                                if (len(evaluate("attributes.action_detail#j#")))
                                    satir_detay_list[1][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#j#")# - #evaluate("attributes.action_detail#j#")#';
                                else
                                    satir_detay_list[1][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#j#")# - TOPLU GİDEN HAVALE';
                            }
                            else
                            {
                                satir_detay_list[1][listlen(alacak_tutar_list)]='TOPLU GİDEN HAVALE';
                            }
                            if(len(evaluate("action_company_id#j#")) and len(evaluate("member_type#j#")) and evaluate("member_type#j#") eq 'partner')
                                my_acc_result = GET_COMPANY_PERIOD(evaluate("action_company_id#j#"),new_period_id,new_dsn2);
                            else if(len(evaluate("action_consumer_id#j#")) and len(evaluate("member_type#j#")) and evaluate("member_type#j#") eq 'consumer')
                                my_acc_result = GET_CONSUMER_PERIOD(evaluate("action_consumer_id#j#"),new_period_id,new_dsn2);
                            else
                                my_acc_result = GET_EMPLOYEE_PERIOD(evaluate("action_employee_id#j#"),attributes.acc_type_id,new_dsn2,new_dsn3,new_period_id);
                            borc_hesap_list = listappend(borc_hesap_list,my_acc_result,',');
                            borc_tutar_list = listappend(borc_tutar_list,evaluate("attributes.system_amount#j#"));
                            doviz_tutar_borc = listappend(doviz_tutar_borc,evaluate("attributes.action_value_other#j#"),',');
                            doviz_currency_borc = listappend(doviz_currency_borc,listfirst(evaluate("attributes.money_id#j#"),';'),',');
                            
                            if(isdefined("attributes.project_id#j#") and len(evaluate("attributes.project_id#j#")) and len(evaluate("attributes.project_head#j#")))
                            {
                                acc_project_list_alacak = listappend(acc_project_list_alacak,evaluate("attributes.project_id#j#"),',');
                                acc_project_list_borc = listappend(acc_project_list_borc,evaluate("attributes.project_id#j#"),',');
                            }
                            else
                            {
                                acc_project_list_alacak = listappend(acc_project_list_alacak,'0',',');
                                acc_project_list_borc = listappend(acc_project_list_borc,'0',',');
                            }
                            
                            if(is_account_group neq 1)
                            {
                                if (len(evaluate("attributes.action_detail#j#")))
                                    satir_detay_list[2][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#j#")# - #evaluate("attributes.action_detail#j#")#';
                                else
                                    satir_detay_list[2][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#j#")# - TOPLU GİDEN HAVALE';
                            }
                            else
                            {
                                satir_detay_list[2][listlen(borc_tutar_list)]='TOPLU GİDEN HAVALE';
                            }
                            //masraf varsa muhasebeciye ekleniyor
                            exp_center_id = evaluate("expense_center_id#j#");
                            exp_item_id = evaluate("expense_item_id#j#");							
                            if(evaluate("attributes.expense_amount#j#") gt 0 and len(exp_center_id) and len(exp_item_id))
                            {
                                GET_EXP_ACC = cfquery(datasource : "#new_dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #exp_item_id#");
                                borc_hesap_list = ListAppend(borc_hesap_list,GET_EXP_ACC.ACCOUNT_CODE,",");	
                                alacak_hesap_list = ListAppend(alacak_hesap_list,attributes.account_acc_code,",");	
                                    
                                borc_tutar_list = ListAppend(borc_tutar_list,wrk_round(evaluate("attributes.expense_amount#j#")*dovizli_islem_multiplier),",");
                                alacak_tutar_list = ListAppend(alacak_tutar_list,wrk_round(evaluate("attributes.expense_amount#j#")*dovizli_islem_multiplier),",");
                                
                                doviz_tutar_borc = ListAppend(doviz_tutar_borc,evaluate("attributes.expense_amount#j#"),",");
                                doviz_currency_borc = ListAppend(doviz_currency_borc,attributes.currency_id,",");
                                
                                doviz_tutar_alacak = ListAppend(doviz_tutar_alacak,evaluate("attributes.expense_amount#j#"),",");
                                doviz_currency_alacak = ListAppend(doviz_currency_alacak,attributes.currency_id,",");
                                /* masraf icin project_id_list ekleniyor */
                                if(isdefined("attributes.project_id#j#") and len(evaluate("attributes.project_id#j#")) and len(evaluate("attributes.project_head#j#")))
                                {
                                    acc_project_list_alacak = listappend(acc_project_list_alacak,evaluate("attributes.project_id#j#"),',');
                                    acc_project_list_borc = listappend(acc_project_list_borc,evaluate("attributes.project_id#j#"),',');
                                }
                                else
                                {
                                    acc_project_list_alacak = listappend(acc_project_list_alacak,'0',',');
                                    acc_project_list_borc = listappend(acc_project_list_borc,'0',',');
                                }
                                
                                if(is_account_group neq 1)
                                {
                                    if (len(evaluate("attributes.action_detail#j#")))
                                        satir_detay_list[1][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#j#")# - #evaluate("attributes.action_detail#j#")#';
                                    else
                                        satir_detay_list[1][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#j#")# - TOPLU GİDEN HAVALE';
        
                                    if (len(evaluate("attributes.action_detail#j#")))
                                        satir_detay_list[2][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#j#")# - #evaluate("attributes.action_detail#j#")#';
                                    else
                                        satir_detay_list[2][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#j#")# - TOPLU GİDEN HAVALE';
                                }
                                else
                                {
                                    satir_detay_list[1][listlen(alacak_tutar_list)]='TOPLU GİDEN HAVALE';
                                    satir_detay_list[2][listlen(borc_tutar_list)]='TOPLU GİDEN HAVALE';
                                }
                            }
                        }
                }
				if(attributes.event is "addmulti")
				{
					muhasebeci (
						action_id:  addMulti,
						workcube_process_type: multi_type,
						workcube_process_cat:form.process_cat,
						account_card_type: 13,
						acc_department_id:acc_department_id,
						islem_tarihi: attributes.action_date,
						fis_satir_detay: satir_detay_list,
						borc_hesaplar: borc_hesap_list,
						borc_tutarlar: borc_tutar_list,
						other_amount_borc : doviz_tutar_borc,
						other_currency_borc : doviz_currency_borc,
						from_branch_id : branch_id_info,
						alacak_hesaplar: alacak_hesap_list,
						alacak_tutarlar: alacak_tutar_list,
						other_amount_alacak : doviz_tutar_alacak,
						other_currency_alacak : doviz_currency_alacak,
						currency_multiplier : currency_multiplier,
						fis_detay: 'TOPLU GİDEN HAVALE İŞLEMI',
						is_account_group : is_account_group,
						acc_project_list_alacak : acc_project_list_alacak,
						acc_project_list_borc : acc_project_list_borc,
						muhasebe_db : new_dsn2
					);
				}
				else if(attributes.event is "updmulti")
				{
					muhasebeci (
						action_id: updMulti,
						workcube_process_type: multi_type,
						workcube_old_process_type: form.old_process_multi_type,
						workcube_process_cat:form.process_cat,
						account_card_type: 13,
						acc_department_id:acc_department_id,
						islem_tarihi: attributes.action_date,
						fis_satir_detay: satir_detay_list,
						borc_hesaplar: borc_hesap_list,
						borc_tutarlar: borc_tutar_list,
						other_amount_borc : doviz_tutar_borc,
						other_currency_borc : doviz_currency_borc,
						from_branch_id : branch_id_info,
						alacak_hesaplar: alacak_hesap_list,
						alacak_tutarlar: alacak_tutar_list,
						other_amount_alacak : doviz_tutar_alacak,
						other_currency_alacak : doviz_currency_alacak,
						currency_multiplier : currency_multiplier,
						fis_detay: 'TOPLU GİDEN HAVALE İŞLEMI',
						is_account_group : is_account_group,
						acc_project_list_alacak : acc_project_list_alacak,
						acc_project_list_borc : acc_project_list_borc,
						muhasebe_db : new_dsn2
					);
				}
            }
			else if(attributes.event is "updmulti")
				muhasebe_sil(action_id:form.multi_id,process_type:attributes.old_process_multi_type);
			attributes.money_type = attributes.rd_money;
			if(attributes.event is "addmulti")
				f_kur_ekle_action(action_id:addMulti,process_type:0,action_table_name:'BANK_ACTION_MULTI_MONEY',action_table_dsn:'#new_dsn2#');
			else if(attributes.event is "updmulti")
				f_kur_ekle_action(action_id:updMulti,process_type:1,action_table_name:'BANK_ACTION_MULTI_MONEY',action_table_dsn:'#new_dsn2#');
			if((attributes.event is "addmulti" or (attributes.event is "updmulti" and not isdefined("attributes.act_row_id#attributes.record_num#"))) and len(paper_number))
				updPaperNo.upd(
					columnName	: 'OUTGOING_TRANSFER_NUMBER',
					paperNumber	: paper_number-1,
					paperDsn	: new_dsn3
				);
			if(attributes.event is "addmulti" and isdefined("attributes.from_bank_orders_list") and len(attributes.from_bank_orders_list))
			{
				updBankOrderStatus.upd(
					bankOrderId	:	attributes.from_bank_orders_list,
					isPaid		:	1,
					newDsn		:	dsn2
				);
			}
        </cfscript>
    <cfelseif attributes.event is "del">
    	<cfscript>
        	if(isdefined("attributes.multi_id") and len(attributes.multi_id))
			{
				get_action_multi = BankTransferOutModel.getMulti(multiId:attributes.multi_id);
				if(get_action_multi.recordcount)
				{
					CONTROL_BANK_ORDER = getOrderId.get(multiId	: attributes.multi_id);
					if(len(control_bank_order.bank_order_id))
					{
						for(i=1;i<=control_bank_order.recordcount;i++)
						{
							bank_order_info = getOrderId.get(orderId: control_bank_order.bank_order_id[i]);
							BANK_ORDER_PROCESS_TYPE = getProcessType(bank_order_info.process_cat_id);
							if(BANK_ORDER_PROCESS_TYPE.IS_CARI)
								setCariProcessedInfo.upd(
									isProcessed	:	0,
									actionId	:	control_bank_order.bank_order_id[i],
									actionTypeId	:	BANK_ORDER_PROCESS_TYPE.bank_order_type
								);
							updBankOrderStatus.upd(
								bankOrderId	:	control_bank_order.bank_order_id[i],
								isPaid		:	0
							);
						}
					}
					get_all_action = BankTransferOutModel.getAllAction(attributes.multi_id);
					for (k = 1; k lte get_all_action.recordcount;k=k+1)
					{
						cari_sil(action_id:get_all_action.action_id[k],process_type:get_all_action.action_type_id[k]);
						butce_sil(action_id:get_all_action.action_id[k],process_type:get_all_action.action_type_id[k]);
					}
					/*avans talepleri güncelleniyor*/	
					updCorrespondencePayment.upd(
						multiId	:	attributes.multi_id,
						actionTypeId		:	25,
						actionPeriodId		:	session.ep.period_id
					);
					BankActionsModel.delMulti(attributes.multi_id);
					attributes.actionId = attributes.multi_id;
				}
			}
			else if(isdefined("attributes.id") and len(attributes.id))
			{
				CONTROL_BANK_ORDER = getOrderId.get(actionId: attributes.id);
				if(len(control_bank_order.bank_order_id))
				{
					bank_order_info = getOrderId.get(orderId: control_bank_order.bank_order_id);
					BANK_ORDER_PROCESS_TYPE = getProcessType(bank_order_info.process_cat_id);
					if(BANK_ORDER_PROCESS_TYPE.IS_CARI)
						setCariProcessedInfo.upd(
							isProcessed	:	0,
							actionId	:	control_bank_order.bank_order_id,
							actionTypeId	:	BANK_ORDER_PROCESS_TYPE.bank_order_type
						);
					updBankOrderStatus.upd(
						bankOrderId	:	control_bank_order.bank_order_id,
						isPaid		:	0
					);
				}
				cari_sil(action_id:attributes.id,process_type:attributes.old_process_type);
				muhasebe_sil (action_id:attributes.id,process_type:attributes.old_process_type);
				butce_sil(action_id:attributes.id,process_type:attributes.old_process_type);
				BankActionsModel.del(attributes.id);
				attributes.actionId = attributes.id;
			}
        </cfscript>
    </cfif>
</cfif>
<cf_xml_page_edit fuseact="bank.form_add_gidenh">
<cf_get_lang_set module_name="bank">
<cfif not isdefined("attributes.event")>
	<cfset attributes.event = "add">
</cfif>
<cfif attributes.event is "add" or attributes.event is "upd">
	<cfscript>
    	if(isdefined("attributes.ID") and len(attributes.ID))
		{
			if(attributes.event is "add")
			{
				get_action_detail = BankTransferOutModel.get(actionId : attributes.id, isCopy : 1);
        		other_money_order = get_action_detail.other_money;
        		to_amount = get_action_detail.action_value+get_action_detail.masraf;
			}
			else if(attributes.event is "upd")
			{
				get_action_detail = BankTransferOutModel.get(attributes.id);
    			bank_order_id = get_action_detail.bank_order_id;
    			paper_num = get_action_detail.paper_no;
    			to_amount = get_action_detail.ACTION_VALUE-get_action_detail.MASRAF;
				if(len(get_action_detail.action_id) and len(get_action_detail.action_type_id))
					get_closed = IsCariClosed.get(
						actionId : get_action_detail.action_id,
						actionTypeId : get_action_detail.action_type_id
					);
			}
			company_id = get_action_detail.ACTION_TO_COMPANY_ID;
        	consumer_id = get_action_detail.ACTION_TO_CONSUMER_ID;
        	emp_id = get_action_detail.ACTION_TO_EMPLOYEE_ID;
			if(len(get_action_detail.acc_type_id))
            	emp_id = "#emp_id#_#get_action_detail.acc_type_id#";
			if(len(get_action_detail.ACTION_TO_COMPANY_ID))
				member_name=get_par_info(get_action_detail.ACTION_TO_COMPANY_ID,1,1,0);
			else if(len(get_action_detail.ACTION_TO_CONSUMER_ID))
				member_name=get_cons_info(get_action_detail.ACTION_TO_CONSUMER_ID,0,0);
			else if(len(get_action_detail.ACTION_TO_EMPLOYEE_ID))
				member_name=get_emp_info(get_action_detail.ACTION_TO_EMPLOYEE_ID,0,0,0,get_action_detail.acc_type_id);
				
    		project_id = get_action_detail.project_id;
   			project_head = get_action_detail.project_head;
    		assetp_id = get_action_detail.assetp_id;
    		from_branch_id = get_action_detail.from_branch_id;
    		special_definition_id = get_action_detail.special_definition_id;
    		acc_department_id = get_action_detail.ACC_DEPARTMENT_ID;
    		process_cat = get_action_detail.process_cat;
    		from_account_id = get_action_detail.action_from_account_id;
			is_disabled = 0;
			action_date = get_action_detail.action_date;
			action_detail = get_action_detail.action_detail;
			expense_center_id = get_action_detail.expense_center_id;
    		expense_item_id = get_action_detail.expense_item_id;
    		if(get_action_detail.masraf gt 0)
    			masraf = get_action_detail.masraf;
    		else
				masraf = "";
    		other_cash_act_value = get_action_detail.other_cash_act_value;
		}
		else if(attributes.event is "add" and isdefined("attributes.bank_order_id") and len(attributes.bank_order_id))
		{
    		if(isdefined("is_company"))
        		memberType = 1;
        	else if(isdefined("is_consumer"))
        		memberType = 2;
        	else if(isdefined("is_employee"))
        		memberType = 3;
			get_order = BankTransferOutModel.getBankOrder(orderId : attributes.bank_order_id, memberType : memberType);
			if(get_order.recordcount)
			{
				bank_order_id = attributes.bank_order_id;
				other_money_order = get_order.OTHER_MONEY;
				from_account_id = get_order.account_id;
				action_date = get_order.PAYMENT_DATE;
				to_amount = get_order.ACTION_VALUE;
				if (len(get_order.COMPANY_ID))
					company_id = get_order.COMPANY_ID;
				else
					consumer_id = get_order.CONSUMER_ID;
				member_name = get_order.fullname;
				is_disabled = 1;
				action_detail = get_order.action_detail;
				attributes.project_id=get_order.project_id;
				from_branch_id=get_order.from_branch_id;
				bank_order_type_id = get_order.BANK_ORDER_TYPE_ID;
				account_order_code = get_order.ACCOUNT_ORDER_CODE;
				special_definition_id=get_order.special_definition_id;	
			}
		}
		else if(attributes.event is "add" and isdefined("attributes.order_id") and len(attributes.order_id))
		{
			if (isdefined("attributes.to_company_id") and len(attributes.to_company_id))
				member_name= get_par_info(attributes.to_company_id,1,1,0);
			else if(isdefined("attributes.to_employee_id") and len(attributes.to_employee_id))
				if(listlen(attributes.to_employee_id,'_') eq 2)
					member_name= get_emp_info(listfirst(attributes.to_employee_id,'_'),0,0,0,listlast(attributes.to_employee_id,'_'));
				else
					member_name= get_emp_info(attributes.to_employee_id,0,0);
			else if(isdefined("attributes.to_consumer_id") and len(attributes.to_consumer_id))
				member_name= get_cons_info(attributes.to_consumer_id,0,0);
            if(isDefined("attributes.action_date"))
                action_date = attributes.action_date;
            else
                action_date = dateformat(now(),'dd/mm/yyyy');
            to_amount = abs(attributes.ORDER_AMOUNT);
            if (isdefined("attributes.to_company_id") and len(attributes.to_company_id))
            {
                company_id = attributes.to_company_id;
                consumer_id = "";
                emp_id = "";
            }
            from_account_id = "";
            bank_order_id = "";
            if (isdefined("attributes.to_employee_id") and len(attributes.to_employee_id))
            {
                emp_id = attributes.to_employee_id;
                consumer_id = "";
                company_id = "";
            }
            
            if (isdefined("attributes.to_consumer_id") and len(attributes.to_consumer_id))
            {
                consumer_id = attributes.to_consumer_id;
                emp_id = "";
                company_id = "";
            }
            is_disabled = 0;
            other_money_order = '';
			orderId = attributes.order_id;
		}
		else
		{
        	member_name = "";
        	company_id = "";
        	consumer_id = "";
        	emp_id = "";
        	from_branch_id = '';
        	from_account_id = '';
        	process_cat = '';
        	to_branch_id = '';
        	special_definition_id = '';
        	acc_department_id = '';
        	project_id = '';
        	project_head = '';
        	assetp_id = '';
        	action_date = dateformat(now(),'dd/mm/yyyy');
        	other_cash_act_value = '';
        	masraf = "";
        	expense_center_id = '';
        	expense_item_id = '';
        	other_cash_act_value = '';
        	other_money_order = '';
        	to_amount = '';
        	action_detail = '';
		}
		if(attributes.event is "add")
		{
			bank_order_id = "";
			is_disabled = 0;
			bank_order_type_id = "";
			account_order_code = "";
			orderId = "";
			if(not isdefined("attributes.order_row_id"))
				attributes.order_row_id = "";
			if(not isdefined("attributes.correspondence_info"))
				attributes.correspondence_info = "";
		}
    </cfscript>
</cfif>
<cfif attributes.event is 'add'>
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.project_id" default="">
    <cfset orderId = "">
	<cfif len(attributes.project_id)>
        <cfset project_id = attributes.project_id>
        <cfset project_head = get_project_name(attributes.project_id)>
    <cfelse>
        <cfset project_id = "">
        <cfset project_head = "">   	
    </cfif>
<cfelseif attributes.event is 'upd'>
    <cfif not get_action_detail.recordcount>
        <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
        <cfexit method="exittemplate">
    </cfif>
<cfelseif attributes.event is 'addmulti'>
	<cfset action_date = now()>
    <cfset kontrol = getControlBillNo.get()>
	<cfif not kontrol.recordcount>
        <font color="##FF0000">
            <a href="<cfoutput>#request.self#?fuseaction=account.bill_no</cfoutput>" class="tableyazi"><cf_get_lang_main no='1616.Lütfen Muhasebe Fiş numaralarını Düzenleyiniz'></a>
        </font>
        <cfabort>
    </cfif>
    <cfscript>
		get_money = getMoneyInfo.get(
			moneyStatus : 1,
		 	money : iif(isDefined('attributes.money') and len(attributes.money),de('attributes.money'),de(''))
		);
		if(isdefined("attributes.multi_id") or isdefined("attributes.puantaj_id") or isdefined("attributes.collacted_havale_list"))
			get_action_detail = BankTransferOutModel.getMulti(
				multiId		:	iif(isdefined("attributes.multi_id") and len(attributes.multi_id),de(attributes.multi_id),0),
				puantajId	:	iif(isdefined("attributes.puantaj_id") and len(attributes.puantaj_id),de('attributes.puantaj_id'),0),
				isVirtualPuantaj	:	iif(isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1,de('attributes.is_virtual_puantaj'),0),
				collactedTransferList	:	iif(isdefined("attributes.collacted_havale_list") and len(attributes.collacted_havale_list),de('attributes.collacted_havale_list'),''),
				collactedProcessCat	:	iif(isdefined("attributes.collacted_process_cat") and len(attributes.collacted_process_cat),de('attributes.collacted_process_cat'),''),
				isCopy	: 1,
				dsn	: dsn2
			);
		if(isdefined("attributes.multi_id") and len(attributes.multi_id))
		{
       		get_money = getCurrencyFromTable.get(
				actionId	: attributes.multi_id,
				tableName	: 'BANK_ACTION_MULTI_MONEY',
				dsn			: dsn2
			);
        	from_account_id = get_action_detail.from_account_id;
        	from_branch_id = get_action_detail.from_branch_id;
        	from_department_id = get_action_detail.ACC_DEPARTMENT_ID;	
			is_copy = 1;
		}
		else if(isdefined("attributes.puantaj_id") and len(attributes.puantaj_id))
		{
			if(get_action_detail.recordcount)
				get_money = getCurrencyFromTable.get(
					actionId	: get_action_detail.dekont_id,
					tableName	: 'EMPLOYEES_PUANTAJ_CARI_ACTIONS_MONEY',
					dsn			: dsn
				);
			from_account_id = '';
			from_branch_id = '';
			from_department_id = '';
			is_copy = 1;	
		}
		else if(isdefined("attributes.collacted_havale_list") and len(attributes.collacted_havale_list))
		{
			if(len(attributes.collacted_bank_account))
				from_account_id = attributes.collacted_bank_account;
			else
				from_account_id = get_action_detail.from_account_id;	
		    from_branch_id = get_action_detail.from_branch_id;
        	from_department_id = get_action_detail.ACC_DEPARTMENT_ID;
		}
		else
		{
			from_account_id = '';
			from_branch_id = '';
			from_department_id = '';
		}
		if(isdefined("get_action_detail"))
			process_cat = get_action_detail.process_cat;
		else
			process_cat = "";
		isDefault = 1;
    	paper_type = 2;
    </cfscript>
	<cfif isdefined('attributes.payment_ids') and len(attributes.payment_ids)>
		<cfset get_payments = BankTransferOutModel.getPayments(paymentIds : attributes.payment_ids)>
        <cfif get_payments.recordcount>
            <cfoutput query="get_payments">
                <script type="text/javascript">
                    add_row('#AMOUNT#','','#EMPLOYEE_NO#','employee','','','#TO_EMPLOYEE_ID#_#ACC_TYPE_ID#','#NAMESURNAME#-#ACC_TYPE_NAME#','#ACCOUNT_CODE#','','#EXPENSE_ID#','#EXPENSE_ITEM_ID#','#EXPENSE_NAME#','#EXPENSE_ITEM_NAME#','','','','','#PROJECT_ID#','#PROJECT_HEAD#','','#DETAIL#','','','','','','','','#get_payments.id#','');
                </script>
            </cfoutput>
        </cfif>
    </cfif>
    <!--- cari action id list gönderilirse ona göre geliyor--->
    <cfif isdefined('attributes.cari_action_id_list') and len(attributes.cari_action_id_list)>
    	<cfset get_payments = BankTransferOutModel.getPayments(cariActionIdList : attributes.cari_action_id_list)>
        <cfif get_payments.recordcount>
            <cfoutput query="get_payments">
                <script type="text/javascript">
                    add_row('#ACTION_VALUE#','','#EMPLOYEE_NO#','employee','','','#FROM_EMPLOYEE_ID#_#ACC_TYPE_ID#','#NAMESURNAME#-#ACC_TYPE_NAME#','#ACCOUNT_CODE#','','#EXPENSE_ID#','#EXPENSE_ITEM_ID#','#EXPENSE_NAME#','#EXPENSE_ITEM_NAME#','','','','','','','','','','','','','','','','','','#get_payments.cari_action_id#');
                </script>
            </cfoutput>
        </cfif>
    </cfif>	
	<cfif isdefined("attributes.in_out_id_list") and len(attributes.in_out_id_list)>
		<cfset is_copy = 1>
	</cfif>
<cfelseif attributes.event is 'updmulti'>
	<cfscript>
    	if(not isdefined("attributes.new_dsn3"))
			new_dsn3 = dsn3;
		else
			new_dsn3 = attributes.new_dsn3;
		if(not isdefined("attributes.new_dsn2"))
			new_dsn2 = dsn2;
		else
			new_dsn2 = attributes.new_dsn2;
        get_action_detail = BankTransferOutModel.getMulti(
			multiId		:	iif(isdefined("attributes.multi_id") and len(attributes.multi_id),attributes.multi_id,de(0)),
			puantajId	:	iif(isdefined("attributes.puantaj_id") and len(attributes.puantaj_id),de('attributes.puantaj_id'),de(0)),
			isVirtualPuantaj	:	iif(isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1,de('attributes.is_virtual_puantaj'),de(0)),
			collactedTransferList	:	iif(isdefined("attributes.collacted_havale_list") and len(attributes.collacted_havale_list),de('attributes.collacted_havale_list'),de('')),
			collactedProcessCat	:	iif(isdefined("attributes.collacted_process_cat") and len(attributes.collacted_process_cat),de('attributes.collacted_process_cat'),de('')),
			isCopy	: 1,
			dsn	: new_dsn2
		);
		get_money = getCurrencyFromTable.get(
			actionId	: attributes.multi_id,
			tableName	: 'BANK_ACTION_MULTI_MONEY',
			dsn			: new_dsn2
		);
		if(len(get_action_detail.action_id) and len(get_action_detail.action_type_id))
			get_closed = IsCariClosed.get(
				actionId : Trim(valueList(get_action_detail.action_id,',')),
				actionTypeId : get_action_detail.action_type_id
			);
    		action_date = get_action_detail.action_date;
    		process_cat = get_action_detail.process_cat;
    		from_branch_id = get_action_detail.from_branch_id;
   			from_department_id = get_action_detail.acc_department_id;
    		isDefault = 0;
    		paper_type = 2;
    		is_update = 1;
	</cfscript>
    <cfif not get_action_detail.recordcount>
        <font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
        <cfexit method="exittemplate">
    </cfif>
</cfif>
<script type="text/javascript">
	<cfif attributes.event is "add" or attributes.event is "upd">
		$( document ).ready(function() {
			kur_ekle_f_hesapla('account_id');
		});
	<cfelseif attributes.event is "addmulti" or attributes.event is "updmulti">
		$( document ).ready(function() {
			change_money_info('add_process','action_date');
		});
	</cfif>
	<cfif attributes.event is "upd">
        function del_kontrol()
        {
            control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
            if(!chk_period(document.getElementById('action_date'), 'İşlem')) return false;
            else return true;
        }
        function giden_havale_ekle()
        {
            window.opener.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=bank.form_add_gidenh';
            window.close();
        }
	</cfif>
	<cfif attributes.event is "add" or attributes.event is "upd">
		function kontrol()
		{
			<cfif attributes.event is "upd">
				control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
			</cfif>
			if(!chk_process_cat('gidenh')) return false;
			if(!check_display_files('gidenh')) return false;
			if(!chk_period(document.getElementById('action_date'), 'İşlem')) return false;

			kur_ekle_f_hesapla('account_id');//dövizli tutarı silinenler için
			var formName = 'gidenh',
				form = $('form[name="'+ formName +'"]');
				
			if (form.find('input#masraf').val() !='' && form.find('input#masraf').val().length != 0 ){
				if (form.find('input#expense_item_id').val() =='' && form.find('input#expense_item_name').val().length == '' )
					validateMessage('notValid',form.find('input#expense_item_name') );
				else
					validateMessage('valid', form.find('input#expense_item_name') );
					
				if (form.find('input#expense_center_id').val() =='' && form.find('input#expense_center_name').val().length == '' )
					validateMessage('notValid',form.find('input#expense_center_name') );
				else
					validateMessage('valid', form.find('input#expense_center_name') );
					
			}
			<cfif attributes.event is "add">
				if(document.getElementById('account_id').disabled == true)
					document.getElementById('account_id').disabled = false;
			</cfif>
			return true;
		}
	</cfif>
</script> 
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['processCat'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['processType'] = 25;
	if(not attributes.event is "del")
		WOStruct['#attributes.fuseaction#']['systemObject']['processCatSelected'] = process_cat;
	else
		WOStruct['#attributes.fuseaction#']['systemObject']['processCatSelected'] = '';

	WOStruct['#attributes.fuseaction#']['systemObject']['processStage'] = true;
	if(attributes.event contains 'upd')
		WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = get_action_detail.process_stage;
	else
		WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = '';
		
	if(not attributes.event contains 'multi'){
	   WOStruct['#attributes.fuseaction#']['systemObject']['paperNumber'] = true;
	   WOStruct['#attributes.fuseaction#']['systemObject']['paperType'] = 'outgoing_transfer';
	}
		
	WOStruct['#attributes.fuseaction#']['systemObject']['paperDate'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['paperDateCallFunction'] = 'change_money_info';
	WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn2; // Transaction icin yapildi.
	
	if(attributes.event is "add" or attributes.event is "upd")
	{
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ACTIONS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACTION_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-processCat','item-from_account_id','item-comp_name','item-ACTION_DATE','item-ACTION_VALUE']";
	}
	else if(attributes.event is "addmulti" or attributes.event is "updmulti")
	{
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'addmulti,updmulti';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ACTIONS_MULTI';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'MULTI_ACTION_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-action_date','item-process_cat','item-account_id']";
	}	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.form_add_gidenh';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'bank/form/FormBankTransferOut.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.form_add_gidenh&event=upd&id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'gidenh';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrol() && validate().check()';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'bank.form_add_gidenh';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'bank/form/FormBankTransferOut.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'bank.form_add_gidenh&event=upd&id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_action_detail';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'gidenh';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();

	if (not(session.ep.our_company_info.is_paper_closer eq 1 and isdefined("get_closed") and get_closed.recordcount neq 0))
	{
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'kontrol() && validate().check()';
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteEvent'] = 'del';
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteFunction'] = 'del_kontrol()';
	}
	else
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['info'] = '#getLang('crm',965)#';
	
	WOStruct['#attributes.fuseaction#']['addmulti'] = structNew();
	WOStruct['#attributes.fuseaction#']['addmulti']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addmulti']['fuseaction'] = 'bank.form_add_gidenh';
	WOStruct['#attributes.fuseaction#']['addmulti']['filePath'] = 'bank/form/FormBankTransferOut.cfm';
	WOStruct['#attributes.fuseaction#']['addmulti']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['addmulti']['nextEvent'] = 'bank.form_add_gidenh&event=updmulti&multi_id=';
	WOStruct['#attributes.fuseaction#']['addmulti']['js'] = "javascript:gizle_goster_ikili('collacted_gidenh','collacted_gidenh_bask')";
	WOStruct['#attributes.fuseaction#']['addmulti']['formName'] = 'add_process';
	
	WOStruct['#attributes.fuseaction#']['addMulti']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['addMulti']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['addMulti']['buttons']['saveFunction'] = 'control_form() && validate()';

	WOStruct['#attributes.fuseaction#']['updmulti'] = structNew();
	WOStruct['#attributes.fuseaction#']['updmulti']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['updmulti']['fuseaction'] = 'bank.form_add_gidenh';
	WOStruct['#attributes.fuseaction#']['updmulti']['filePath'] = 'bank/form/FormBankTransferOut.cfm';
	WOStruct['#attributes.fuseaction#']['updmulti']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['updmulti']['nextEvent'] = 'bank.form_add_gidenh&event=updmulti&multi_id=';
	WOStruct['#attributes.fuseaction#']['updmulti']['parameters'] = 'multi_id=##attributes.multi_id##';
	WOStruct['#attributes.fuseaction#']['updmulti']['Identity'] = '##attributes.multi_id##';
	WOStruct['#attributes.fuseaction#']['updmulti']['js'] = "javascript:gizle_goster_ikili('collacted_gidenh','collacted_gidenh_bask')";
	WOStruct['#attributes.fuseaction#']['updmulti']['formName'] = 'add_process';
	WOStruct['#attributes.fuseaction#']['updmulti']['recordQuery'] = 'get_action_detail';
	
	WOStruct['#attributes.fuseaction#']['updmulti']['buttons'] = structNew();
	if (not(session.ep.our_company_info.is_paper_closer eq 1 and isdefined("get_closed") and get_closed.recordcount neq 0))
	{
		if(isdefined("attributes.puantaj_id") and len(attributes.puantaj_id) and dsn2 eq new_dsn2)
		{
		   WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['update'] = 1;
		   WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['updateFunction'] = 'control_form()';
		   WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['delete'] = 1;
		   WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['deleteFunction'] = 'control_del_form()';
		   WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['deleteUrl'] = '#request.self#?fuseaction=bank.form_add_gidenh&event=del&is_virtual=#attributes.is_virtual_puantaj#&puantaj_id=#attributes.puantaj_id#';			
		}
		else if(isdefined("attributes.puantaj_id") and len(attributes.puantaj_id))
		{
		   WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['update'] = 1;
		   WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['updateFunction'] = 'control_form()';
		}
		else
		{
		   WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['update'] = 1;
		   WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['updateFunction'] = 'control_form()';
		   WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['delete'] = 1;
		   WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['deleteFunction'] = 'control_del_form()';
		   WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['deleteUrl'] = '#request.self#?fuseaction=bank.form_add_gidenh&event=del';		
		}
	}
	
	if ((session.ep.our_company_info.is_paper_closer eq 1 and isdefined("get_closed") and get_closed.recordcount neq 0))
	{
	   if (get_closed.is_closed eq 1)
			WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['info'] = '#getLang('crm',965)#';
	   else if(get_closed.is_demand eq 1)
			WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['info'] = '#getLang('crm',1057)#';
	   else if(get_closed.is_order eq 1)
			WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['info'] = '#getLang('crm',1072)#';
	}
		
	if(attributes.event is 'upd' or attributes.event is 'updmulti' or attributes.event is 'del')
	{
		if(isdefined("attributes.multi_id"))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			if(not isdefined('attributes.formSubmittedController'))
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'bank.del_collacted_action&multi_id=#attributes.multi_id#&old_process_type=#get_action_detail.action_type_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = '';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_bank_actions';	
		}
		else if(isdefined("attributes.ID"))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			if(not isdefined('attributes.formSubmittedController'))
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'bank.del_gidenh&id=#attributes.id#&head=#get_action_detail.paper_no#&old_process_type=#get_action_detail.action_type_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = '';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_bank_actions';
		}
	}
	if(attributes.event is 'addmulti')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addmulti'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addmulti']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addmulti']['menus'][0]['text'] = '#lang_array_main.item[2576]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addmulti']['menus'][0]['onClick'] = "openBox('#request.self#?fuseaction=objects.popup_add_collacted_from_file&type=3',this)";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addmulti']['menus'][1]['text'] = '#lang_array_main.item[1998]# #lang_array_main.item[280]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addmulti']['menus'][1]['href'] = "#request.self#?fuseaction=bank.form_add_gidenh&event=add"; 
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is 'updmulti' and not (isdefined("attributes.puantaj_id") and len(attributes.puantaj_id)))
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="19" action_section="BANK_MULTI_ACTION_ID" action_id="#attributes.multi_id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['menus'][1]['text'] = '#lang_array_main.item[35]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.multi_id#&process_cat=253','page','add_process')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons']['add']['href'] = "#request.self#?fuseaction=bank.form_add_gidenh&event=addmulti";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons']['copy']['href'] = '#request.self#?fuseaction=bank.form_add_gidenh&event=addmulti&multi_id=#attributes.multi_id#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons']['copy']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&print_type=154&action_id=#attributes.multi_id#&action_type=#get_action_detail.action_type_id#&keyword=multi','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="19" action_section="BANK_ACTION_ID" action_id="#attributes.id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[35]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_action_detail.action_type_id#','page','gidenh');";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=bank.form_add_gidenh";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=bank.form_add_gidenh&ID=#get_action_detail.action_id#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=154&action_type=#get_action_detail.action_type_id#','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is 'add')
	{
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#lang_array_main.item[620]# #lang_array_main.item[280]#';
	   tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['href'] = "#request.self#?fuseaction=bank.form_add_gidenh&event=addmulti";
	   tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
