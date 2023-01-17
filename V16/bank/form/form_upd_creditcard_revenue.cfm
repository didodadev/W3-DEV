<cf_get_lang_set module_name="bank">
<cfset refmodule="#listgetat(attributes.fuseaction,1,'.')#">
<cfquery name="GET_PAYMENT" datasource="#DSN3#">
	SELECT 
		CREDITCARD_PAYMENT_ID,
		PAYMENT_TYPE_ID,
		STORE_REPORT_DATE,
        DUE_START_DATE,
		SALES_CREDIT,
		CARD_NO,
		OTHER_MONEY,
		OTHER_CASH_ACT_VALUE,
		ACTION_DETAIL,
		ACTION_FROM_COMPANY_ID,
		ACTION_TYPE,
		PROCESS_CAT,
		ACTION_TYPE_ID,
		PARTNER_ID,
		CONSUMER_ID,
		ORDER_ID,
		IS_ONLINE_POS,
		CARD_OWNER,
		ACTION_PERIOD_ID,
		CARI_ACTION_ID,
		CARI_ACTION_VALUE,
        SUBSCRIPTION_ID,
		PROJECT_ID,
		PAPER_NO,
		UPD_STATUS,
		TO_BRANCH_ID,
		ASSETP_ID,
		SPECIAL_DEFINITION_ID,
		RECORD_CONS,
		RECORD_PAR,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_DATE,
		UPDATE_EMP,
		REVENUE_COLLECTOR_ID,
        IS_VOID,
        RELATION_CREDITCARD_PAYMENT_ID,
        CANCEL_TYPE_ID
	FROM 
		CREDIT_CARD_BANK_PAYMENTS WITH (NOLOCK) 
	WHERE 
		CREDITCARD_PAYMENT_ID = #attributes.id#
</cfquery>
<cfparam name="attributes.comp_name" default="">
<cf_catalystHeader>
    <div class="col col-12 col-xs-12">
        <cf_box>
            <cfform name="upd_cc_revenue" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_creditcard_revenue">
                <cfoutput>
                    <input type="hidden" name="id" id="id" value="#attributes.id#">
                    <input type="hidden" name="cari_action_id" id="cari_action_id" value="#GET_PAYMENT.CARI_ACTION_ID#">
                    <input type="hidden" name="action_period_id" id="action_period_id" value="#GET_PAYMENT.ACTION_PERIOD_ID#">
                    <input type="hidden" name="action_type_info" id="action_type_info" value="#GET_PAYMENT.ACTION_TYPE#">
                </cfoutput>
                <cfif isdefined("attributes.is_from_payroll")><input type="hidden" name="is_from_payroll" id="is_from_payroll" value="1"></cfif>
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-CreditCards">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57652.Hesap'> / <cf_get_lang dictionary_id='
                                58516.Ödeme Yöntemi'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkCreditCards width='240' is_active='0' call_function='change_comm_value' selected_value='#get_payment.PAYMENT_TYPE_ID#' is_upd='1'>
                            </div>
                        </div>
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'> *</label>
                            <div class="col col-8 col-xs-12">
                                    <cf_workcube_process_cat slct_width="240" process_cat="#get_payment.process_cat#" onclick_function="cancel_type_()">
                            </div>
                        </div> 
                        <div class="form-group" id="item-setup_cancel" style="display:none;">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1413)#</cfoutput></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrk_setup_cancel cancel_type = "CREDIT_CARD" width="240" cancel_id="#get_payment.cancel_type_id#">
                            </div>
                        </div>   
                        <div class="form-group" id="item-DepartmentBranch">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='240' selected_value='#get_payment.to_branch_id#' is_deny_control='1'>
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
                                    <input type="hidden" name="cons_id" id="cons_id" value="<cfoutput>#get_payment.consumer_id#</cfoutput>">
                                    <input type="hidden" name="par_id" id="par_id" value="<cfoutput>#get_payment.partner_id#</cfoutput>">
                                    <input type="hidden" name="action_from_company_id" id="action_from_company_id" value="<cfoutput>#get_payment.action_from_company_id#</cfoutput>">
                                    <!---<cfsavecontent variable="message1"><cf_get_lang no='4.cari hesap girmelisiniz'></cfsavecontent>--->
                                    <cfif len(get_payment.action_from_company_id)>
                                        <cfinput type="text" name="comp_name" id="comp_name" onFocus= "AutoComplete_Create('comp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,PARTNER_ID','cons_id,action_from_company_id,par_id','','2','250','get_money_info(\'upd_cc_revenue\',\'action_date\')');" required="yes" value="#get_par_info(get_payment.action_from_company_id,1,0,0)#">
                                    <cfelseif len(get_payment.consumer_id)>
                                        <cfinput type="text" name="comp_name" id="comp_name" onFocus= "AutoComplete_Create('comp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID','cons_id,action_from_company_id','','2','250','get_money_info(\'upd_cc_revenue\',\'action_date\')');" required="yes" value="#get_cons_info(get_payment.consumer_id,0,0)#">
                                    </cfif>
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_comp_id=upd_cc_revenue.action_from_company_id&field_name=upd_cc_revenue.comp_name&field_partner=upd_cc_revenue.par_id&field_consumer=upd_cc_revenue.cons_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3</cfoutput>','list');" title="<cf_get_lang dictionary_id='48665.cari hesap girmelisini'>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-project_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                            <div class="col col-8 col-xs-12">
                                <cfoutput>
                                <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="#get_payment.project_id#">
                                    <cfif len(get_payment.project_id)>
                                        <cfquery name="get_project_name" datasource="#dsn#">
                                            SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_payment.project_id#
                                        </cfquery>
                                    </cfif>
                                    <cf_wrk_projects form_name='upd_cc_revenue' project_id='project_id' project_name='project_name'>
                                    <input type="text" name="project_name" id="project_name" value="<cfif len(get_payment.project_id)>#get_project_name.project_head#</cfif>" style="width:240px;" onkeyup="get_project_1();">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_head=upd_cc_revenue.project_name&project_id=upd_cc_revenue.project_id');" title="<cf_get_lang dictionary_id='57416.Proje'>"></span>  
                                </div>
                                </cfoutput>
                            </div>
                        </div>
                        <div class="form-group" id="item-subscription_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29502.Abone No'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrk_subscriptions fieldId='subscription_id' fieldName='subscription_no' form_name='upd_cc_revenue' subscription_id='#get_payment.subscription_id#' subscription_no='#get_subscription_no(iif(len(get_payment.subscription_id),get_payment.subscription_id,0))#'>
                            </div>
                        </div>
                        <cfif session.ep.our_company_info.asset_followup eq 1> 
                        <div class="form-group" id="item-asset_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkAssetp asset_id="#get_payment.assetp_id#" fieldId='asset_id' fieldName='asset_name' form_name='upd_cc_revenue' width='240'>
                            </div>
                        </div>
                        </cfif> 
                        <div class="form-group" id="item-relation_card_no">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48854.Kart No'></label>
                            <div class="col col-8 col-xs-12">
                                <!---<cfsavecontent variable="message"><cf_get_lang no ='306.Lütfen Geçerli Kart No Giriniz'> !</cfsavecontent>--->
                                <cf_input_pcKlavye name="card_no" value="" type="text" numpad="true" accessible="true" maxlength="16" required="no" validate="creditcard" onKeyUp="isNumber(this);">
                                <cfif len(GET_PAYMENT.CARD_NO)>
                                    <a href="javascript://" onclick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=bank.popup_form_dsp_cc_number&cc_number_id=#get_payment.CREDITCARD_PAYMENT_ID#</cfoutput>','date');"><img src="/images/question.gif" alt="<cf_get_lang dictionary_id='48854.Kart No'>" align="absmiddle" border="0" title="<cf_get_lang dictionary_id='48854.Kart No'>"></a>
                                </cfif> 
                            </div>
                        </div> 
                        <div class="form-group" id="item-card_owner">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48894.Kart Hamili'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="card_owner" id="card_owner" maxlength="30" value="<cfoutput>#get_payment.card_owner#</cfoutput>">
                            </div>
                        </div> 
                        <div class="form-group" id="item-action_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="date_period_control" id="date_period_control" value="<cfoutput>#get_payment.store_report_date#</cfoutput>"><!--- tahsilatların şirkete taşınmasından sonra eklendi silmeyiniz... --->
                                    <!---<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>--->
                                    <cfinput value="#dateformat(get_payment.store_report_date,dateformat_style)#" validate="#validate_style#" required="Yes" type="text" name="action_date" onBlur="change_money_info('upd_cc_revenue','action_date');">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="action_date" call_function="change_money_info" control_date="#dateformat(get_payment.store_report_date,dateformat_style)#"></span>
                                </div>    
                            </div>
                        </div>                         
                        <div class="form-group" id="item-due_start_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48818.Vade Başlangıç Tarih'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <!---<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>--->
                                    <cfif not len(get_payment.due_start_date)>
                                    <cfset get_payment.due_start_date = get_payment.store_report_date>
                                    </cfif>
                                    <cfinput validate="#validate_style#" required="Yes" type="text" name="due_start_date" value="#dateformat(get_payment.due_start_date,dateformat_style)#" onBlur="change_money_info('upd_cc_revenue','due_start_date');">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="due_start_date"></span><!--- call_function="change_money_info" --->
                                </div>                                  
                            </div>
                        </div> 
                        <div class="form-group" id="item-paper_number">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="paper_number" value="#get_payment.paper_no#">
                            </div>
                        </div> 
                        <div class="form-group" id="item-sales_credit_comm">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'>*</label>
                            <div class="col col-8 col-xs-12">
                                <!---<cfsavecontent variable="message1"><cf_get_lang no='83.Miktar giriniz'></cfsavecontent>--->
                                <cfif isdefined("attributes.is_from_payroll")>
                                    <cfinput type="text" name="sales_credit_comm" class="moneybox" required="yes" value="#attributes.total_amount#" onBlur="change_comm_value();kur_ekle_f_hesapla('account_id');" onkeyup="return(FormatCurrency(this,event));">
                                <cfelseif len(get_payment.cari_action_value)>
                                    <cfinput type="text" name="sales_credit_comm" class="moneybox" required="yes" value="#TLFormat(get_payment.sales_credit-get_payment.cari_action_value)#" onBlur="change_comm_value();kur_ekle_f_hesapla('account_id');" onkeyup="return(FormatCurrency(this,event));">
                                <cfelse>
                                    <cfinput type="text" name="sales_credit_comm" class="moneybox" required="yes" value="#TLFormat(get_payment.sales_credit)#" onBlur="change_comm_value();kur_ekle_f_hesapla('account_id');" onkeyup="return(FormatCurrency(this,event));">
                                </cfif>
                            </div>
                        </div> 
                        <div class="form-group" id="item-sales_credit">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48937.Komisyonlu Tutar'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="sales_credit" class="moneybox" value="#TLFormat(get_payment.sales_credit)#" readonly="yes"> 
                            </div>
                        </div> 
                        <div class="form-group" id="item-other_value_sales_credit">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58056.Dövizli Tutar'></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="other_value_sales_credit" class="moneybox" readonly="readonly" value="#TLFormat(get_payment.other_cash_act_value)#" onBlur="change_comm_value();kur_ekle_f_hesapla('account_id',true);" onkeyup="return(FormatCurrency(this,event));"> 
                            </div>
                        </div> 
            
                        <div class="form-group" id="item-revenue_collector">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48666.Tahsil Eden'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="revenue_collector_id" id="revenue_collector_id" value="<cfoutput>#get_payment.revenue_collector_id#</cfoutput>">
                                    <input type="text" name="revenue_collector" id="revenue_collector" style="width:240px;" value="<cfoutput>#get_emp_info(get_payment.revenue_collector_id,0,0)#</cfoutput>">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="javascript:windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_cc_revenue.revenue_collector_id&field_name=upd_cc_revenue.revenue_collector<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list','popup_list_positions');" title="<cf_get_lang dictionary_id='48666.Tahsil Eden'>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-action_detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="action_detail" id="action_detail"><cfoutput>#get_payment.action_detail#</cfoutput></textarea>
                            </div>
                        </div> 
                        <div class="form-group" id="item-">
                            <label class="col col-4 col-xs-12"></label>
                            <div class="col col-8 col-xs-12">
                                <cfquery name="GET_CC_PAY_ROWS" datasource="#dsn3#">
                                    SELECT BANK_ACTION_DATE FROM CREDIT_CARD_BANK_PAYMENTS_ROWS WITH (NOLOCK) WHERE CREDITCARD_PAYMENT_ID = #attributes.id#
                                </cfquery>
                                <cf_get_lang dictionary_id='48897.Hesaba Geçiş Tarihi'> <cfoutput query="GET_CC_PAY_ROWS"> - #dateformat(get_cc_pay_rows.bank_action_date,dateformat_style)#</cfoutput>
                            </div>
                        </div>                  
                    </div>
                    <div class="col col-6 col-md-4 col-sm-6 col-xs-12 scrollContent scroll-x2" type="column" index="2" sort="false">
                        <div class="form-group">   <label class="bold"><cf_get_lang dictionary_id='48714.İşlem Para Br'></label></div>
                        <div class="form-group">
                            <div class="col col-12">
                                    <cfscript>f_kur_ekle(action_id:attributes.id,process_type:1,base_value:'sales_credit',other_money_value:'other_value_sales_credit',form_name:'upd_cc_revenue',action_table_name:'CREDIT_CARD_BANK_PAYMENT_MONEY',action_table_dsn:'#dsn3#',select_input:'account_id');</cfscript>
                            </div>
                        </div>
                    </div>  
                </cf_box_elements>
                <cf_box_footer>
                    <div class="col col-12">
                            <cfquery name="CONTROL" datasource="#dsn3#" maxrows="1">
                                SELECT BANK_ACTION_ID FROM CREDIT_CARD_BANK_PAYMENTS_ROWS WITH (NOLOCK) WHERE CREDITCARD_PAYMENT_ID = #attributes.id# AND BANK_ACTION_ID IS NOT NULL
                            </cfquery>
                            <cf_record_info query_name="get_payment" is_consumer="1">
                        <cfif not len(isClosed('CREDIT_CARD_BANK_PAYMENTS',attributes.id))>
                            <cfif control.recordcount><!---hesaba geçiş işlemi olmussa--->
                                <b><cf_get_lang dictionary_id='48935.Hesaba Geçişi Yapılmış İşlemler Güncellenemez'>!</b>
                        <cfelseif len(get_payment.order_id)><!---Siparişten yapılmış tahsilatsa--->
                            <cfquery name="GET_ORDER_INFO" datasource="#dsn3#">
                                SELECT ORDER_NUMBER,IS_ENDUSER_PRICE FROM ORDERS WHERE ORDER_ID = #GET_PAYMENT.ORDER_ID#
                            </cfquery>
                            <cfsavecontent variable="extra_">
                                <cfif len(get_order_info.order_number)><cf_get_lang dictionary_id='58211.Sipariş No'>: <cfoutput>#get_order_info.order_number#</cfoutput></cfif>
                                <cfif get_order_info.is_enduser_price eq 1><cf_get_lang no ='275.Son Kullanıcı Fiyatı ile İşlem Yapılmıştır'>!</cfif>
                            </cfsavecontent>
                            <cf_workcube_buttons type_format="1" extra_info="#extra_#" is_upd='1' add_function='kontrol()' del_function_for_submit='del_kontrol()' update_status = '#get_payment.upd_status#' delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_creditcard_revenue&id=#attributes.id#&comp=#attributes.comp_name#&old_process_type=#get_payment.action_type_id#&order_id=#get_payment.order_id#&action_date=#get_payment.store_report_date#&active_period=#get_payment.action_period_id#&cari_action_id=#get_payment.cari_action_id#'>
                        <cfelseif get_payment.is_online_pos eq 1><!---sanal pos işlemi yapılmıssa--->
                            <cf_workcube_buttons type_format="1" is_upd='1' add_function='kontrol()' del_function_for_submit='del_kontrol()' update_status = '#get_payment.upd_status#' delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_creditcard_revenue&id=#attributes.id#&comp=#attributes.comp_name#&old_process_type=#get_payment.action_type_id#&action_date=#get_payment.store_report_date#&active_period=#get_payment.action_period_id#&cari_action_id=#get_payment.cari_action_id#&relation_creditcard_payment_id=#get_payment.relation_creditcard_payment_id#'>
                        <cfelse>
                            <cf_workcube_buttons type_format="1" is_upd='1' add_function='kontrol()' del_function_for_submit='del_kontrol()' update_status = '#get_payment.upd_status#' delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_creditcard_revenue&id=#attributes.id#&comp=#attributes.comp_name#&old_process_type=#get_payment.action_type_id#&action_date=#get_payment.store_report_date#&active_period=#get_payment.action_period_id#&cari_action_id=#get_payment.cari_action_id#&relation_creditcard_payment_id=#get_payment.relation_creditcard_payment_id#'>
                        </cfif>
                        <cfelse>
                            <b ><font color="FF0000"><cf_get_lang dictionary_id='47262.Fatura kapama işlemi yapılan belgede değişiklik yapılamaz'>!</font></b>
                        </cfif>	 
                    </div>  
                </cf_box_footer>    
            </cfform>
        </cf_box>
    </div>
<script type="text/javascript">
    $(document).ready(function(){
   kur_ekle_f_hesapla('account_id');
    cancel_type_();

    });
 

	function del_kontrol()
	{
		if(!control_account_process(<cfoutput>'#attributes.id#','#get_payment.action_type_id#'</cfoutput>)) return false;
		if(!chk_period(document.upd_cc_revenue.action_date, 'İşlem')) return false;
		return true;
	}
	function kontrol()
	{
		if(!control_account_process(<cfoutput>'#attributes.id#','#get_payment.action_type_id#'</cfoutput>)) return false;
		if(!paper_control(upd_cc_revenue.paper_number,'CREDITCARD_REVENUE','1',<cfoutput>'#attributes.id#','#get_payment.paper_no#'</cfoutput>,'','','','<cfoutput>#dsn3#</cfoutput>')) return false;
		if(!chk_process_cat('upd_cc_revenue')) return false;
		if(!check_display_files('upd_cc_revenue')) return false;
		if(!chk_period(document.upd_cc_revenue.action_date, 'İşlem')) return false;
		kur_ekle_f_hesapla('account_id');//dövizli tutarı silinenler için
		var listParam = document.upd_cc_revenue.id.value + "*" + document.upd_cc_revenue.paper_number.value;
		var get_paper_no = wrk_safe_query("bnk_get_paper_no",'dsn3',0,listParam);
		if( get_paper_no.recordcount)
		{
			alert("<cf_get_lang dictionary_id='49009.Girdiğiniz Belge Numarası Kullanılmaktadır'> !");
			return false;
		}
        if(!$("#cancel_type_id").val().length && document.getElementById('process_cat').value != '' && document.getElementById('ct_process_type_'+document.getElementById('process_cat').value).value == 245)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58825.iptal nedeni '>Giriniz</cfoutput>"})    
			return false;
		}
		return true;
	}
	
	function change_comm_value()
	{
		if(document.getElementById('payment_rate_acc').value != "" && document.getElementById('payment_rate').value != "" && document.getElementById('payment_rate').value != 0 && document.upd_cc_revenue.sales_credit_comm.value != "" && document.getElementById('currency_id').value != "")
			document.upd_cc_revenue.sales_credit.value = commaSplit(parseFloat(filterNum(upd_cc_revenue.sales_credit_comm.value)) + (parseFloat(filterNum(upd_cc_revenue.sales_credit_comm.value)) * (parseFloat(document.getElementById('payment_rate').value)/100)));
		else
			document.upd_cc_revenue.sales_credit.value = document.upd_cc_revenue.sales_credit_comm.value;
	}
	function cancel_type_()
	{
		if (document.getElementById('process_cat').value != '' && document.getElementById('ct_process_type_'+document.getElementById('process_cat').value).value == 245)
			document.getElementById('item-setup_cancel').style.display = '';
		else
			document.getElementById('item-setup_cancel').style.display = 'none';
	}
	
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
