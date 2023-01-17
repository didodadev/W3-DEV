<cf_xml_page_edit fuseact="bank.popup_add_creditcard_bank_expense">
<cfparam name="attributes.comp_name" default="">
<cfquery name="GET_EXPENSE" datasource="#dsn3#">
	SELECT 
		CREDITCARD_EXPENSE_ID,
		PROCESS_CAT,
		PROCESS_TYPE,
		ACTION_DATE,
		ACTION_TO_COMPANY_ID,
		CONS_ID,
		PAR_ID,
		CREDITCARD_ID,
		TOTAL_COST_VALUE,
		OTHER_COST_VALUE,
		OTHER_MONEY,
		DETAIL,
		PROJECT_ID,
		PAPER_NO,
		UPD_STATUS,
        SUBSCRIPTION_ID,
		FROM_BRANCH_ID,
		INSTALLMENT_NUMBER,
		ACTION_PERIOD_ID,
		ASSETP_ID,
		SPECIAL_DEFINITION_ID,
		EXPENSE_ID,
		DELAY_INFO,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE
	FROM 
		CREDIT_CARD_BANK_EXPENSE 
	WHERE 
		CREDITCARD_EXPENSE_ID = #attributes.id#
</cfquery>
<cfquery name="CONTROL_INFO" datasource="#dsn3#">
	SELECT
		CRR.BANK_ACTION_ID,
		CRR.BANK_ACTION_PERIOD_ID,
		CR.INSTALLMENT_DETAIL,
		CR.INSTALLMENT_AMOUNT,
		CRR.CLOSED_AMOUNT
	FROM
		CREDIT_CARD_BANK_EXPENSE_RELATIONS CRR,
		CREDIT_CARD_BANK_EXPENSE_ROWS CR
	WHERE
		CRR.CC_BANK_EXPENSE_ROWS_ID = CR.CC_BANK_EXPENSE_ROWS_ID AND
		CR.CREDITCARD_EXPENSE_ID = #attributes.id# AND
		CRR.BANK_ACTION_ID IS NOT NULL
</cfquery>
<cfquery name="CONTROL_RETURN" datasource="#dsn3#">
	SELECT
		CC_BANK_EXPENSE_ROWS_ID
	FROM
		CREDIT_CARD_BANK_EXPENSE_ROWS 
	WHERE
		CREDITCARD_EXPENSE_ID = #attributes.id#
        AND INSTALLMENT_AMOUNT < 0 
</cfquery>
<cf_catalystHeader>
	<cfform name="upd_credit_card_payment"  method="post" action="#request.self#?fuseaction=bank.emptypopup_upd_creditcard_bank_expense">
		<input type="hidden" name="CREDITCARD_EXPENSE_ID" id="CREDITCARD_EXPENSE_ID" value="<cfoutput>#attributes.id#</cfoutput>">
		<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#GET_EXPENSE.ACTION_PERIOD_ID#</cfoutput>">
        <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
    <div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-our_credit_cards">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='787.Kredi Kartı'> *</label>
                            <div class="col col-9 col-xs-12">
                            	<cf_wrk_our_credit_cards slct_width="250" credit_card_info="#get_expense.creditcard_id#" onclick_function="kur_ekle_f_hesapla('credit_card_info');">
                            </div>
                        </div>		
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='388.işlem tipi'> *</label>
                            <div class="col col-9 col-xs-12">
                            	<cf_workcube_process_cat slct_width="175" process_cat="#get_expense.process_cat#">
                            </div>
                        </div>
                      <cfif x_select_branch eq 1 and session.ep.isBranchAuthorization eq 0>						
                        <div class="form-group" id="item-DepartmentBranch">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no ='41.Şube'></label>
                            <div class="col col-9 col-xs-12">
                            	<cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='175' selected_value='#get_expense.from_branch_id#' is_deny_control='1'>
                            </div>
                        </div>
                      </cfif>
                      <cfif x_select_type_info neq 0>
                        <div class="form-group" id="item-special_definition">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='1516.Ödeme Tipi'></label>
                            <div class="col col-9 col-xs-12">
                            	<cf_wrk_special_definition width_info='175' type_info='2' field_id="special_definition_id" selected_value='#get_expense.special_definition_id#'>
                            </div>
                        </div>
                      </cfif>
                        <div class="form-group" id="item-comp_name">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='107.cari Hesap'> *</label>
                            <div class="col col-9 col-xs-12">
                            	<div class="input-group">
                                	<input type="hidden" name="cons_id" id="cons_id" value="<cfoutput>#get_expense.cons_id#</cfoutput>">
                                    <input type="hidden" name="par_id" id="par_id" value="<cfoutput>#get_expense.par_id#</cfoutput>">
                                    <input type="hidden" name="action_to_company_id" id="action_to_company_id" value="<cfoutput>#get_expense.ACTION_TO_COMPANY_ID#</cfoutput>">
                                    <cfsavecontent variable="message1"><cf_get_lang no='4.cari hesap girmelisini'></cfsavecontent>
                                    <cfif len(get_expense.action_to_company_id)>
                                        <cfinput type="text" name="comp_name" id="comp_name" onFocus= "AutoComplete_Create('comp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID','cons_id,action_to_company_id','','2','250','get_money_info(\'upd_credit_card_payment\',\'action_date\')');" required="yes" message="#message1#" value="#get_par_info(get_expense.action_to_company_id,1,0,0)#" style="width:175px;">
                                        <cfset attributes.comp_name="#get_par_info(get_expense.action_to_company_id,1,0,0)#">
                                    <cfelseif len(get_expense.cons_id)>
                                        <cfinput type="text" name="comp_name" id="comp_name" onFocus= "AutoComplete_Create('comp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID','cons_id,action_to_company_id','','2','250','get_money_info(\'upd_credit_card_payment\',\'action_date\')');" required="yes" message="#message1#" value="#get_cons_info(get_expense.cons_id,0,0)#" style="width:175px;">
                                        <cfset attributes.comp_name="#get_cons_info(get_expense.cons_id,0,0)#">
                                    </cfif>
                                	<span class="input-group-addon btnPointer icon-ellipsis" onClick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_id=upd_credit_card_payment.action_to_company_id&field_comp_name=upd_credit_card_payment.comp_name&field_partner=upd_credit_card_payment.par_id&is_cari_action=1&field_consumer=upd_credit_card_payment.cons_id&field_member_name=upd_credit_card_payment.comp_name</cfoutput>','list');"></span>
                                </div>
                            </div>
                        </div>
                      <cfif session.ep.our_company_info.project_followup eq 1>
                    	<div class="form-group" id="item-project_name">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
                            <div class="col col-9 col-xs-12">
                            	<div class="input-group">
                                	<cfoutput>
                                    	<input type="hidden" name="project_id" id="project_id" value="#GET_EXPENSE.project_id#">
										<cfif len(GET_EXPENSE.project_id)>
                                            <cfquery name="get_project_name" datasource="#dsn#">
                                                SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #GET_EXPENSE.project_id#
                                            </cfquery>
                                        </cfif>
                                        <cf_wrk_projects form_name='upd_credit_card_payment' project_id='project_id' project_name='project_name'>
                                        <input type="text" name="project_name" id="project_name" value="<cfif len(GET_EXPENSE.project_id)>#get_project_name.project_head#</cfif>" style="width:175px;" onkeyup="get_project_1();" onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');" autocomplete="off">
                                     <span class="input-group-addon btnPointer icon-ellipsis" onClick="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_head=upd_credit_card_payment.project_name&project_id=upd_credit_card_payment.project_id');" title="<cf_get_lang_main no='4.Proje'>"></span>
                                	</cfoutput>	
                                </div>
                            </div>
                        </div>
                      </cfif>
                       <div class="form-group" id="item-subscription_id">
                                <label class="col col-3 col-xs-12"><cf_get_lang_main no ='1705.Abone No'></label>
                                <div class="col col-9 col-xs-12">
                                    <cf_wrk_subscriptions fieldId='subscription_id' fieldName='subscription_no' form_name='upd_credit_card_payment' subscription_id='#get_expense.subscription_id#' subscription_no='#get_subscription_no(iif(len(get_expense.subscription_id),get_expense.subscription_id,0))#'>
                                </div>
                        </div>
                      <cfif session.ep.our_company_info.asset_followup eq 1>
                    	<div class="form-group" id="item-asset_id">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no ='1421.Fiziki Varlık'></label>
                            <div class="col col-9 col-xs-12">
                            	<cf_wrkAssetp asset_id="#get_expense.assetp_id#" fieldId='asset_id' fieldName='asset_name' form_name='upd_credit_card_payment' width='175'>
                            </div>
                        </div>
                      </cfif>
                        <div class="form-group" id="item-inst_number">
                            <label class="col col-3 col-xs-12"><cf_get_lang no='144.Taksit Sayısı'></label>
                            <div class="col col-9 col-xs-12">
                            	<cfinput type="text" name="inst_number" value="#get_expense.installment_number#" style="width:175px;" onkeyup="return(FormatCurrency(this,event,0));" class="moneybox">
                            </div>
                        </div>
                        <div class="form-group" id="item-delay_info">
                            <label class="col col-3 col-xs-12"><cf_get_lang no='136.Erteleme'></label>
                            <div class="col col-9 col-xs-12">
                            	<div class="input-group">
                                	<cfinput type="text" name="delay_info" value="#get_expense.delay_info#" style="width:175px;" onkeyup="return(FormatCurrency(this,event,0));" class="moneybox">
                                	<span class="input-group-addon btnPointer"><cf_get_lang_main no='1312.Ay'></span>
                            	</div>
                            </div>
                        </div>
                        <div class="form-group" id="item-paper_number">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='468.belge no'></label>
                            <div class="col col-9 col-xs-12">
                            	<cfinput type="text" name="paper_number" id="paper_number" value="#get_expense.paper_no#">
                            </div>
                        </div>
                    	<div class="form-group" id="item-action_date">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='330.Tarih'> *</label>
                            <div class="col col-9 col-xs-12">
                            	<div class="input-group">
                                	<!---<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>--->
									<cfinput type="text" name="action_date" validate="#validate_style#" required="Yes" value="#dateformat(get_expense.action_date,dateformat_style)#" readonly onBlur="change_money_info('upd_credit_card_payment','action_date');">
                                	<span class="input-group-addon btnPointer"><!---HY---><cfif get_expense.recordcount><cf_wrk_date_image date_field="action_date" call_function="change_money_info" control_date="#dateformat(get_expense.action_date,dateformat_style)#"></cfif></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-action_value">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='261.Tutar'> *</label>
                            <div class="col col-9 col-xs-12">
                            	<!---<cfsavecontent variable="message1"><cf_get_lang no='83.Miktar giriniz'></cfsavecontent>--->
								<cfinput type="text" name="action_value" class="moneybox" required="yes" value="#TLFormat(get_expense.total_cost_value)#" onBlur="kur_ekle_f_hesapla('credit_card_info');" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                        </div>
                        <div class="form-group" id="item-other_money_value">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='644.Dövizli Tutar'></label>
                            <div class="col col-9 col-xs-12">
                            	<cfinput type="text" name="other_money_value" class="moneybox" value="#tlformat(get_expense.other_cost_value)#" onBlur="kur_ekle_f_hesapla('credit_card_info',true);" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                        </div>
                    	<div class="form-group" id="item-action_detail">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
                            <div class="col col-9 col-xs-12">
                            	<textarea name="action_detail" id="action_detail" style="width:175px;height:60px;"><cfoutput>#get_expense.detail#</cfoutput></textarea>
                            </div>
                        </div>
                      <cfif CONTROL_INFO.recordcount>
                        <div class="form-group" id="item-">
                            <label class="col col-3 col-xs-12"><cf_get_lang no="137.Kredi Kartı Borç Ödeme İşlemleri"> :</label>
                            <div class="col col-9 col-xs-12">
                            	<cf_form_list>
                                    <thead>
                                        <tr>
                                            <th><cf_get_lang_main no="1165.Sıra"></th>
                                            <th><cf_get_lang_main no="280.İşlem"></th>
                                            <th width="85" style="text-align:right;"><cf_get_lang no="106.Taksit Tutarı"></th>
                                            <th width="105" style="text-align:right;"><cf_get_lang no="107.Ödenen Tutar"></th>
                                            <th width="15"></th>
                                        </tr>
                                    </thead>
                                    <cfoutput query="CONTROL_INFO">
                                        <tbody>
                                            <tr>
                                                <td>#currentrow#</td>
                                                <td>#INSTALLMENT_DETAIL#</td>
                                                <td style="text-align:right;">#TLFormat(INSTALLMENT_AMOUNT)#</td>
                                                <td style="text-align:right;">#TLFormat(CLOSED_AMOUNT)#</td>
                                                <td width="15">
                                                    <cfif BANK_ACTION_ID neq 0><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=bank.list_credit_card_expense&event=updDebit&id=#BANK_ACTION_ID#&period_control=#BANK_ACTION_PERIOD_ID#','small');"><img src="images/report_square2.gif" border="0" alt="İlişkili Borç Ödeme İşlemi" title="İlişkili Borç Ödeme İşlemi"></a></cfif><!--- 0 id liler eski kayıtlardan geliyordukontrol ekledm --->
                                                </td>
                                            </tr>
                                        </tbody>
                                    </cfoutput>         
                                </cf_form_list>
                            </div>
                        </div>
                      </cfif>
                    </div>  
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="false">
                        <div class="form-group">
                        	 <label class=" col col-12 bold"><cf_get_lang no='53.İşlem Para Br'></label>
                            <div class="col col-6 col-xs-12 scrollContent scroll-x3">
								 <cfscript>f_kur_ekle(action_id:attributes.id,process_type:1,base_value:'action_value',other_money_value:'other_money_value',form_name:'upd_credit_card_payment',action_table_name:'CREDIT_CARD_BANK_EXPENSE_MONEY',action_table_dsn:'#dsn3#',select_input:'credit_card_info');</cfscript>
                            </div>
                        </div>
                	</div>                    
                </div>
                <div class="row formContentFooter">
                    <div class="col col-6 col-xs-12">
                        <cf_record_info query_name="get_expense">
                    </div>
                    <div class="col col-6 col-xs-12">    
						<cfif not len(isClosed('CREDIT_CARD_BANK_EXPENSE',attributes.id))>
                                <cfif CONTROL_INFO.recordcount><!---borç ödeme işlemi olmuşsa--->
                                    <b><cf_get_lang dictionary_id="56448.Kredi Kartı Borç Ödemesi"><br/> <cf_get_lang dictionary_id="56449.Yapılmış İşlemler Güncellenemez">!</b>
                                <cfelse>
                                    <cf_workcube_buttons type_format="1" is_upd='1' add_function='kontrol()' del_function_for_submit='del_kontrol()' update_status='#get_expense.upd_status#' delete_page_url='#request.self#?fuseaction=bank.emptypopup_del_creditcard_bank_expense&id=#attributes.id#&comp=#attributes.comp_name#&old_process_type=#get_expense.process_type#&active_period=#GET_EXPENSE.ACTION_PERIOD_ID#'>
                                </cfif>
                        <cfelse>
                            <font color="FF0000"><cf_get_lang_main no='2355.Fatura kapama işlemi yapılan belgede değişiklik yapılamaz'>!</font>
                        </cfif>                        
                    </div>  
                </div>  
			</div>                        
		</div>
	</div>                
	</cfform>
<script type="text/javascript">
	function del_kontrol()
	{
		return control_account_process(<cfoutput>'#attributes.id#','#get_expense.process_type#'</cfoutput>);
		if(!chk_period(upd_credit_card_payment.action_date,'İşlem')) return false;
		else return true;
	}
	function kontrol()
	{
		return control_account_process(<cfoutput>'#attributes.id#','#get_expense.process_type#'</cfoutput>);
		if (!chk_process_cat('upd_credit_card_payment')) return false;
		if(!check_display_files('upd_credit_card_payment')) return false;
		if(!chk_period(document.upd_credit_card_payment.action_date, 'İşlem')) return false;
		x = document.upd_credit_card_payment.credit_card_info.selectedIndex;
		return true;
	}
	kur_ekle_f_hesapla('credit_card_info');
</script>
