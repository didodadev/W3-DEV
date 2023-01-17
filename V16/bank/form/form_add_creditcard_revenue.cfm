<cf_get_lang_set module_name="bank">
<cf_papers paper_type="creditcard_revenue">
<cf_xml_page_edit fuseact="bank.popup_add_creditcard_revenue">
<cfif isdefined('attributes.payment_id') and len(attributes.payment_id)>
	<cfquery name="GET_PAYMENT" datasource="#DSN3#">
        SELECT 
            CCBP.CREDITCARD_PAYMENT_ID,
            CCBP.PAYMENT_TYPE_ID,
            CCBP.STORE_REPORT_DATE,
            CCBP.SALES_CREDIT,
            CCBP.CARD_NO,
            CCBP.OTHER_MONEY,
            CCBP.OTHER_CASH_ACT_VALUE,
            CCBP.ACTION_DETAIL,
            CCBP.ACTION_FROM_COMPANY_ID,
            CCBP.ACTION_TYPE,
            CCBP.PROCESS_CAT,
            CCBP.ACTION_TYPE_ID,
            CCBP.PARTNER_ID,
            CCBP.CONSUMER_ID,
            CCBP.ORDER_ID,
            CCBP.IS_ONLINE_POS,
            CCBP.CARD_OWNER,
            CCBP.ACTION_PERIOD_ID,
            CCBP.CARI_ACTION_ID,
            CCBP.CARI_ACTION_VALUE,
            CCBP.PROJECT_ID,
            CCBP.SUBSCRIPTION_ID,
            CCBP.PAPER_NO,
            CCBP.UPD_STATUS,
            CCBP.TO_BRANCH_ID,
            CCBP.ASSETP_ID,
            CCBP.SPECIAL_DEFINITION_ID,
            CCBP.REVENUE_COLLECTOR_ID,
            <!---ISNULL(CCBP.WRK_ID,CCBP.WRK_ID_INVOICE) WRK_ID,--->
            CCBP.WRK_ID AS WRK_ID,
            PRO_PROJECTS.PROJECT_HEAD
        FROM 
            CREDIT_CARD_BANK_PAYMENTS CCBP WITH (NOLOCK) 
            LEFT JOIN #dsn_alias#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = CCBP.PROJECT_ID
        WHERE 
            CREDITCARD_PAYMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_id#">
    </cfquery>
    <cfset attributes.consumer_id = get_payment.consumer_id>
    <cfset attributes.company_id = get_payment.action_from_company_id>
    <cfif len(get_payment.cari_action_value)>
		<cfset attributes.total_amount = get_payment.sales_credit-get_payment.cari_action_value>
    <cfelse>
    	<cfset attributes.total_amount = get_payment.sales_credit>
    </cfif>
    <cfquery name="getProcessCat" datasource="#dsn3#">
        SELECT TOP 1 PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 245
    </cfquery>
	<cfset process_cat_ = getProcessCat.PROCESS_CAT_ID>
    <cfif len(get_payment.paper_no)>
		<cfset get_payment.action_detail = "#get_payment.paper_no# nolu Kredi Kartı Tahsilatı İade/İptal İşlemi">
   	<cfelse>
	    <cfset get_payment.action_detail = "#attributes.payment_id# nolu Kredi Kartı Tahsilatı İade/İptal İşlemi">
    </cfif>
    <cfset subscription_id = GET_PAYMENT.subscription_id>
    <cfif len(subscription_id)>
        <cfset subscription_no = get_subscription_no(subscription_id)>
    <cfelse>
        <cfset subscription_no = "">
    </cfif>
<cfelse>
	<cfset get_payment.PAYMENT_TYPE_ID = "">
    <cfset get_payment.to_branch_id = "">
	<cfset get_payment.special_definition_id = "">
    <cfset attributes.consumer_id = "">
    <cfset attributes.company_id = "">
    <cfset get_payment.project_id = "">
    <cfset get_payment.project_head = "">
    <cfset get_payment.assetp_id = "">
    <cfset GET_PAYMENT.CARD_NO = "">
    <cfset get_payment.CREDITCARD_PAYMENT_ID = "">
    <cfset get_payment.card_owner = "">
	<cfset get_payment.other_cash_act_value = "">
    <cfset get_payment.sales_credit = "">
    <cfset get_payment.action_detail = "">
    <cfset process_cat_ = "">
    <cfset subscription_id = "">
    <cfset subscription_no = "">
</cfif>
<cfif isdefined('attributes.payment_id') and len(attributes.payment_id)>
	<cfset pageHead = "#getLang('main',424)# (Sanal Pos)">
<cfelse>
	<cfset pageHead = "#getLang('main',424)#">
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform name="add_cc_revenue" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_creditcard_revenue">
            <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
            <cfif isdefined("attributes.is_from_payroll")>
                <input type="hidden" name="is_from_payroll" id="is_from_payroll" value="1">
            <cfelseif isdefined("attributes.is_from_payroll_revenue")>
                <input type="hidden" name="is_from_payroll_revenue" id="is_from_payroll_revenue" value="1">
            </cfif>
            <cfif isdefined("attributes.payment_id") and len(attributes.payment_id) and GET_PAYMENT.recordcount>
                <cfoutput>
                    <input type="hidden" name="relation_payment_id" id="relation_payment_id" value="#attributes.payment_id#">
                    <input type="hidden" name="cari_action_id" id="cari_action_id" value="#GET_PAYMENT.CARI_ACTION_ID#">
                    <input type="hidden" name="action_period_id" id="action_period_id" value="#GET_PAYMENT.ACTION_PERIOD_ID#">
                    <input type="hidden" name="action_type_info" id="action_type_info" value="#GET_PAYMENT.ACTION_TYPE#">
                    <input type="hidden" name="relation_wrk_id" id="relation_wrk_id" value="#GET_PAYMENT.wrk_id#">
                    <input type="hidden" name="relation_action_date" id="relation_action_date" value="#get_payment.store_report_date#">
                    <input type="hidden" name="is_online_pos" id="is_online_pos" value="#get_payment.is_online_pos#">
                    <cfif isdefined("attributes.is_list_company_extre")>
                        <input type="hidden" name="is_list_company_extre" id="is_list_company_extre" value="#attributes.is_list_company_extre#">
                    </cfif>
                    
                </cfoutput>
            </cfif>
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-9 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-CreditCards">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57652.Hesap'> / <cf_get_lang dictionary_id='
                            58516.Ödeme Yöntemi'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrkCreditCards width='240' call_function='change_comm_value' control_status='1' selected_value='#get_payment.PAYMENT_TYPE_ID#'>
                        </div>
                    </div>
                    <div class="form-group" id="item-process">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process_cat slct_width="240" process_cat="#process_cat_#" onclick_function="cancel_type_()">
                        </div>
                    </div> 
                    <div class="form-group" id="item-setup_cancel"  style="display:none;">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1413)#</cfoutput>*</label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrk_setup_cancel cancel_type = "CREDIT_CARD" is_active="1" width="240">
                        </div>
                    </div>                    
                    <div class="form-group" id="item-DepartmentBranch">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif isdefined("get_payment.to_branch_id")>
                                <cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='240' selected_value='#get_payment.to_branch_id#' is_deny_control='1'>
                            <cfelse>
                                <cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='240' is_default='1' is_deny_control='1'>
                            </cfif>
                        </div>
                    </div> 
                    <div class="form-group" id="item-special_definition">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58929.Tahsilat Tipi'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrk_special_definition width_info='240' type_info='1' field_id="special_definition_id" selected_value='#get_payment.special_definition_id#'>
                        </div>
                    </div> 
                    <div class="form-group" id="item-comp_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.cari Hesap'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                                <cfset cons_id = attributes.consumer_id>
                                <cfset comp_id = ''>
                                <cfset member_name = get_cons_info(attributes.consumer_id,0,0)>
                                <cfelseif isdefined("attributes.company_id") and len(attributes.company_id)>
                                <cfset comp_id = attributes.company_id>
                                <cfset cons_id = ''>
                                <cfset member_name = get_par_info(attributes.company_id,1,0,0)>
                                <cfelse>
                                <cfset comp_id = ''>
                                <cfset cons_id = ''>
                                <cfset member_name =''>
                                </cfif>
                                <input type="hidden" name="cons_id" id="cons_id" value="<cfoutput>#cons_id#</cfoutput>">
                                <input type="hidden" name="par_id" id="par_id" value="">
                                <input type="hidden" name="action_from_company_id" id="action_from_company_id" value="<cfoutput>#comp_id#</cfoutput>">
                                <cfinput type="text" name="comp_name" id="comp_name" required="yes" value="#member_name#" onFocus= "AutoComplete_Create('comp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,PARTNER_ID','cons_id,action_from_company_id,par_id','','2','250','get_money_info(\'add_cc_revenue\',\'action_date\')');">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_comp_id=add_cc_revenue.action_from_company_id&field_member_name=add_cc_revenue.comp_name&field_partner=add_cc_revenue.par_id&field_consumer=add_cc_revenue.cons_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3</cfoutput>','list');" title="<cf_get_lang dictionary_id='48665.cari hesap girmelisini'>"></span>
                            </div>      
                        </div>
                    </div>  
                    <cfif session.ep.our_company_info.project_followup eq 1>         
                    <div class="form-group" id="item-project_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#get_payment.project_id#</cfoutput>">
                                <input type="text" name="project_name" id="project_name" value="<cfoutput>#get_payment.project_head#</cfoutput>" onFocus="AutoComplete_Create('project_name','PROJECT_HEAD,PROJECT_NUMBER','PROJECT_HEAD,PROJECT_NUMBER','get_project','','PROJECT_ID,PROJECT_HEAD','project_id,project_name','','3','250');">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=add_cc_revenue.project_name&project_id=add_cc_revenue.project_id</cfoutput>');" title="<cf_get_lang dictionary_id='57416.Proje'>"></span>                                 
                            </div>
                        </div>
                    </div>  
                    </cfif>  
                    <div class="form-group" id="item-subscription_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29502.Abone No'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrk_subscriptions fieldId='subscription_id' fieldName='subscription_no' form_name='add_cc_revenue' subscription_id='#subscription_id#' subscription_no='#subscription_no#'>
                        </div>
                    </div>
                    <cfif session.ep.our_company_info.asset_followup eq 1>                      
                    <div class="form-group" id="item-asset_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrkAssetp fieldId='asset_id' fieldName='asset_name' form_name='add_cc_revenue' width='240' asset_id="#get_payment.assetp_id#">
                        </div>
                    </div>
                    </cfif>                         
                    <div class="form-group" id="item-relation_card_no">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48854.Kart No'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif len(GET_PAYMENT.CARD_NO)>
                                <cfif len(attributes.company_id)>
                                    <cfset key_type = attributes.company_id>
                                <cfelse>
                                    <cfset key_type = attributes.consumer_id>
                                </cfif>
                                <!--- 
                                    FA-09102013 kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi. 
                                    Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir 
                                --->
                                <cfscript>
                                    getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
                                    getCCNOKey.dsn = dsn;
                                    getCCNOKey1 = getCCNOKey.getCCNOKey1();
                                    getCCNOKey2 = getCCNOKey.getCCNOKey2();
                                </cfscript>
                                <!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
                                <cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
                                    <!--- anahtarlar decode ediliyor --->
                                    <cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
                                    <cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
                                    <!--- kart no encode ediliyor --->
                                    <cfset card_no_ = contentEncryptingandDecodingAES(isEncode:0,content:get_payment.CARD_NO,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
                                    <cfset content = contentEncryptingandDecodingAES(isEncode:0,content:get_payment.CARD_NO,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
                                    <cfset relation_card_no_ = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
                                <cfelse>
                                    <cfset card_no_ = Decrypt(get_payment.card_no,key_type,"CFMX_COMPAT","Hex")>
                                    <cfset relation_card_no_ = '#mid(Decrypt(get_payment.card_no,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(get_payment.card_no,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(get_payment.card_no,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(get_payment.card_no,key_type,"CFMX_COMPAT","Hex")))#'>
                                </cfif>
                                <input type="text" name="relation_card_no" id="relation_card_no" readonly="readonly" value="<cfoutput>#relation_card_no_#</cfoutput>" />
                                <input type="hidden"  name="card_no" id="card_no"value="<cfoutput>#card_no_#</cfoutput>" redonly  />
                            <cfelse>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='48967.Lütfen Geçerli Kart No Giriniz'> !</cfsavecontent>
                                <cf_input_pcKlavye name="card_no" value="" type="text" numpad="true" accessible="true" maxlength="16" inputStyle="width:240px;" message="#message#" required="no" validate="creditcard" onKeyUp="isNumber(this);">
                            </cfif>                                
                        </div>
                    </div>                         
                    <div class="form-group" id="item-card_owner">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48894.Kart Hamili'></label>
                        <div class="col col-8 col-xs-12">
                            <input name="card_owner" id="card_owner" type="text" value="<cfoutput>#get_payment.card_owner#</cfoutput>" maxlength="30">
                        </div>
                    </div>                         
                    <div class="form-group" id="item-action_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput validate="#validate_style#" required="Yes" type="text" name="action_date" value="#dateformat(now(),dateformat_style)#" onBlur="change_money_info('add_cc_revenue','action_date');">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="action_date" call_function="change_money_info"></span>
                            </div>
                        </div>
                    </div>                         
                    <div class="form-group" id="item-due_start_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48818.Vade Başlangıç Tarih'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput validate="#validate_style#" required="Yes" type="text" name="due_start_date" value="#dateformat(now(),dateformat_style)#" onBlur="change_money_info('add_cc_revenue','due_start_date');">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="due_start_date"></span><!--- call_function="change_money_info" --->
                            </div>                                
                        </div>
                    </div>                         
                    <div class="form-group" id="item-paper_number">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="paper_number" value="#paper_code & '-' & paper_number#">
                        </div>
                    </div> 
                    <div class="form-group" id="item-sales_credit_comm">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfif isdefined("attributes.total_amount")><cfset total_amount = attributes.total_amount><cfelse><cfset total_amount = ''></cfif>
                            <cfsavecontent variable="message1"><cfoutput>#getLang('main',1738)#</cfoutput></cfsavecontent>
                            <cfif isdefined('attributes.payment_id') and len(attributes.payment_id)>
                            <cfquery name="getPaymentAmount" datasource="#dsn3#"><!--- iade isleminde toplam odenen tutar --->
                                SELECT ISNULL(SUM(SALES_CREDIT),0) AS PAYMENT_AMOUNT FROM CREDIT_CARD_BANK_PAYMENTS WHERE RELATION_CREDITCARD_PAYMENT_ID = #attributes.payment_id#
                            </cfquery>
                            <cfset total_amount = total_amount - getPaymentAmount.PAYMENT_AMOUNT>
                            <cfif isDefined('x_is_amount_change') And x_is_amount_change eq 1>
                                <cfinput type="text" name="sales_credit_comm" class="moneybox" required="yes" message="#message1#" style="width:240px;" value="#TLFormat(total_amount,2)#" onBlur="change_comm_value();kur_ekle_f_hesapla('account_id');" onkeyup="return(FormatCurrency(this,event));">
                            <cfelse>
                                <cfinput type="text" name="sales_credit_comm" class="moneybox" required="yes" message="#message1#" style="width:240px;" value="#TLFormat(total_amount,2)#" onBlur="change_comm_value();kur_ekle_f_hesapla('account_id');" onkeyup="return(FormatCurrency(this,event));" readonly="readonly">
                            </cfif>
                            <cfelse>
                            <cfinput type="text" name="sales_credit_comm" class="moneybox" required="yes" message="#message1#" style="width:240px;" value="#TLFormat(total_amount,2)#" onBlur="change_comm_value();kur_ekle_f_hesapla('account_id');" onkeyup="return(FormatCurrency(this,event));"> 
                            </cfif>
                        </div>
                    </div>                         
                    <div class="form-group" id="item-sales_credit">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48937.Komisyonlu Tutar'>*</label>
                        <div class="col col-8 col-xs-12">
                                <cfif isdefined('attributes.payment_id') and len(attributes.payment_id)>
                                <input type="hidden" name="old_sales_credit" id="old_sales_credit" value="<cfoutput>#TLFormat(get_payment.sales_credit)#</cfoutput>" />
                                <cfset new_sales_credit = get_payment.sales_credit - getPaymentAmount.PAYMENT_AMOUNT>
                                <input type="hidden" name="new_sales_credit" id="new_sales_credit" value="<cfoutput>#TLFormat(new_sales_credit)#</cfoutput>" />
                                <cfinput type="text" name="sales_credit" class="moneybox" style="width:240px;" value="#TLFormat(new_sales_credit)#" readonly="yes">
                                <cfelse>
                                <cfinput type="text" name="sales_credit" class="moneybox" style="width:240px;" value="#TLFormat(get_payment.sales_credit)#" readonly="yes">
                                </cfif>
                        </div>
                    </div>                                               
                    <div class="form-group" id="item-other_value_sales_credit">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58056.Dövizli Tutar'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="other_value_sales_credit" class="moneybox" value="#TLFormat(get_payment.other_cash_act_value)#" readonly="readonly" onBlur="change_comm_value();kur_ekle_f_hesapla('account_id',true);" onkeyup="return(FormatCurrency(this,event));">
                        </div>
                    </div>                       
                    <div class="form-group" id="item-revenue_collector">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48666.Tahsil Eden'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="revenue_collector_id" id="revenue_collector_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                                <input type="text" name="revenue_collector" id="revenue_collector" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>" style="width:240px;" readonly>
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_cc_revenue.revenue_collector_id&field_name=add_cc_revenue.revenue_collector<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list','popup_list_positions');" title="<cf_get_lang dictionary_id='48666.Tahsil Eden'>"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-action_detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="action_detail" id="action_detail"><cfoutput>#get_payment.action_detail#</cfoutput></textarea>
                        </div>
                    </div>                
                </div>
                <div class="col col-6 col-md-4 col-sm-3 col-xs-12 scrollContent scroll-x2" type="column" index="2" sort="false">
                    <div class="form-group">
                        <label class="bold"><cf_get_lang dictionary_id='48714.İşlem Para Br'></label>
                    </div>
                    <div class="form-group">
                        <div class="col col-12">
                            <cfif isdefined("attributes.payment_id") and len(attributes.payment_id)>
                                <cfscript>f_kur_ekle(action_id:attributes.payment_id,process_type:1,base_value:'sales_credit',other_money_value:'other_value_sales_credit',form_name:'add_cc_revenue',action_table_name:'CREDIT_CARD_BANK_PAYMENT_MONEY',action_table_dsn:'#dsn3#',select_input:'account_id');</cfscript>
                            <cfelse>
                                <cfscript>f_kur_ekle(process_type:0,base_value:'sales_credit',other_money_value:'other_value_sales_credit',form_name:'add_cc_revenue',select_input:'account_id');</cfscript></td>
                            </cfif>
                        </div>
                    </div>
                </div>  
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-12">
                    <cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'>
                </div>  
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	kur_ekle_f_hesapla('account_id');
	function kontrol()
	{
		if(!$("#payment_type_id").val().length)
		{
			alertObject({message: "<cfoutput>#getLang('bank',370)#</cfoutput>"})    
			return false;
		}
		if(!$("#process_cat").val().length)
		{
			alertObject({message: "<cfoutput>#getLang('stock',323)#</cfoutput>"})    
			return false;
		}
		if(!$("#comp_name").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='48665.cari hesap girmelisini'></cfoutput>"})    
			return false;
		}
		if(!$("#action_date").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfoutput>"})    
			return false;
		}
		if(!$("#due_start_date").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfoutput>"})    
			return false;
        }
        <cfif isDefined('x_is_cancel_type') And x_is_cancel_type eq 2>
            if(!$("#cancel_type_id").val().length && document.getElementById('process_cat').value != '' && document.getElementById('ct_process_type_'+document.getElementById('process_cat').value).value == 245)
            {
                alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58825.iptal nedeni '>Giriniz</cfoutput>"})    
                return false;
            }
        </cfif>
        

        
		if(!paper_control(add_cc_revenue.paper_number,'CREDITCARD_REVENUE','1','','','','','','<cfoutput>#dsn3#</cfoutput>')) return false;
		if (!chk_process_cat('add_cc_revenue')) return false;
		if(!check_display_files('add_cc_revenue')) return false;
		if(!chk_period(document.add_cc_revenue.action_date, 'İşlem')) return false;
		if(!acc_control()) return false;
		kur_ekle_f_hesapla('account_id');//dövizli tutarı silinenler için
		
		if(parseFloat(filterNum(document.add_cc_revenue.sales_credit.value)) <= 0)	
		{
			alert("<cf_get_lang dictionary_id='29535.Lutfen Tutar Giriniz'> !");
			return false;
		}
		<cfif isdefined("attributes.payment_id") and len(attributes.payment_id)>
			x = parseFloat(filterNum(document.add_cc_revenue.sales_credit.value));
			y = parseFloat(filterNum(document.add_cc_revenue.new_sales_credit.value));
			if(x > y)
			{
				alert("<cf_get_lang dictionary_id='56612.Toplam tutar büyük olamaz'>:" +document.add_cc_revenue.new_sales_credit.value+ "");
				return false;
			}
		</cfif>
		var get_paper_no = wrk_safe_query('bnk_get_paper_no_pymnt','dsn3',0,document.add_cc_revenue.paper_number.value);
		if( get_paper_no.recordcount)
		{
			alert("<cf_get_lang dictionary_id='49009.Girdiğiniz Belge Numarası Kullanılmaktadır'> !");
			return false;
		}
		
		return true;
	}
	function change_comm_value()
	{
		if(document.getElementById('payment_rate_acc').value != "" && document.getElementById('payment_rate').value != "" && document.getElementById('payment_rate').value != 0 && document.add_cc_revenue.sales_credit_comm.value != "" && document.getElementById('currency_id').value != "")
			document.add_cc_revenue.sales_credit.value = commaSplit(parseFloat(filterNum(add_cc_revenue.sales_credit_comm.value)) + (parseFloat(filterNum(add_cc_revenue.sales_credit_comm.value)) * (parseFloat(document.getElementById('payment_rate').value)/100)));
		else
			document.add_cc_revenue.sales_credit.value = document.add_cc_revenue.sales_credit_comm.value;
	}
	function cancel_type_()
	{
        <cfif isDefined('x_is_cancel_type') And x_is_cancel_type neq 0>
            if (document.getElementById('process_cat').value != '' && document.getElementById('ct_process_type_'+document.getElementById('process_cat').value).value == 245)
                document.getElementById('item-setup_cancel').style.display = '';
            else
                document.getElementById('item-setup_cancel').style.display = 'none';
        </cfif>
	}
	if(document.getElementById('process_cat').value != '')
		cancel_type_();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
