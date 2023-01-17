<cf_papers paper_type="creditcard_payment">
<cf_xml_page_edit fuseact="bank.popup_add_creditcard_bank_expense">
<cfparam name="attributes.credit_card_info" default="">
<cf_catalystHeader>
	<cfform name="add_credit_card_payment" method="post" action="#request.self#?fuseaction=bank.emptypopup_add_creditcard_bank_expense">
		<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
    <div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-our_credit_cards">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='787.Kredi Kartı'> *</label>
                            <div class="col col-9 col-xs-12">
                            	<cf_wrk_our_credit_cards credit_card_info="#attributes.credit_card_info#" slct_width="250" isRequired="required" onclick_function="kur_ekle_f_hesapla('credit_card_info');">
                            </div>
                        </div>
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='388.işlem tipi'> *</label>
                            <div class="col col-9 col-xs-12">
                            	<cf_workcube_process_cat slct_width="175">
                            </div>
                        </div>
					<cfif x_select_branch eq 1 and session.ep.isBranchAuthorization eq 0>
                        <div class="form-group" id="item-DepartmentBranch">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no ='41.Şube'></label>
                            <div class="col col-9 col-xs-12">
                            	<cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='175' is_default='1' is_deny_control='1'>
                            </div>
                        </div>
					</cfif>
                    <cfif x_select_type_info neq 0>
                        <div class="form-group" id="item-special_definition">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='1516.Ödeme Tipi'></label>
                            <div class="col col-9 col-xs-12">
                            	<cf_wrk_special_definition width_info='175' type_info='2' field_id="special_definition_id">
                            </div>
                        </div>
                    </cfif>
                        <div class="form-group" id="item-comp_name">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='107.Cari Hesap'> *</label>
                            <div class="col col-9 col-xs-12">
                            	<div class="input-group">
                                    <input type="hidden" name="cons_id" id="cons_id" value="">
                                    <input type="hidden" name="par_id" id="par_id" value="">
                                    <input type="hidden" name="action_to_company_id" id="action_to_company_id" value="">
                                    <cfinput type="text" name="comp_name" id="comp_name" onFocus= "AutoComplete_Create('comp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,PARTNER_ID','cons_id,action_to_company_id,par_id','','2','250','get_money_info(\'add_credit_card_payment\',\'action_date\')');" required="yes" value="">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&is_cari_action=1&field_comp_id=add_credit_card_payment.action_to_company_id&field_comp_name=add_credit_card_payment.comp_name&field_partner=add_credit_card_payment.par_id&field_consumer=add_credit_card_payment.cons_id&field_member_name=add_credit_card_payment.comp_name</cfoutput>','list');" title="<cf_get_lang_main no='107.Cari Hesap'>"></span>
                            	</div>
                            </div>
                        </div> 
                     <cfif session.ep.our_company_info.project_followup eq 1>                   
                        <div class="form-group" id="item-project_name">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
                            <div class="col col-9 col-xs-12">
                            	<div class="input-group">
                                  	<input type="Hidden" name="project_id" id="project_id" value="">
                                    <cf_wrk_projects form_name='add_credit_card_payment' project_id='project_id' project_name='project_name'>
                                    <input type="text" name="project_name" id="project_name" value="" style="width:175px;" onkeyup="get_project_1();" onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');" autocomplete="off">
							 		<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=add_credit_card_payment.project_name&project_id=add_credit_card_payment.project_id</cfoutput>');" title="<cf_get_lang_main no='4.Proje'>"></span>
                            	</div>
                            </div>
                        </div>
                      </cfif>  
                       <div class="form-group" id="item-subscription_id">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no ='1705.Abone No'></label>
                            <div class="col col-9 col-xs-12">
                                <cf_wrk_subscriptions fieldId='subscription_id' fieldName='subscription_no' form_name='add_credit_card_payment'>
                            </div>
                        </div>
                      <cfif session.ep.our_company_info.asset_followup eq 1>      
                        <div class="form-group" id="item-asset_id">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no ='1421.Fiziki Varlık'></label>
                            <div class="col col-9 col-xs-12">
                               <cf_wrkAssetp fieldId='asset_id' fieldName='asset_name' form_name='add_credit_card_payment' width='175'>
                            </div>
                        </div>                           
                      </cfif>     
                        <div class="form-group" id="item-">
                            <label class="col col-3 col-xs-12"><cf_get_lang no='144.Taksit Sayısı'></label>
                            <div class="col col-9 col-xs-12">
                                  <cfinput type="text" name="inst_number" value="" onkeyup="return(FormatCurrency(this,event,0));" class="moneybox">
                            </div>
                        </div>   
                        <div class="form-group" id="item-delay_info">
                            <label class="col col-3 col-xs-12"><cf_get_lang no='136.Erteleme'></label>
                            <div class="col col-9 col-xs-12">
                                 <div class="input-group">
                                 	<cfinput type="text" name="delay_info" value="" onkeyup="return(FormatCurrency(this,event,0));" class="moneybox">
                                 	<span class="input-group-addon"><cf_get_lang_main no='1312.Ay'></span>
                                 </div> 
                            </div>
                        </div>  
                        <div class="form-group" id="item-paper_number">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='468.Belge No'></label>
                            <div class="col col-9 col-xs-12">
                              	<cfinput type="text" name="paper_number" value="#paper_code & '-' & paper_number#">
                            </div>
                        </div> 
                        <div class="form-group" id="item-action_date">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='330.Tarih'> *</label>
                            <div class="col col-9 col-xs-12">
                                 <div class="input-group">
									<cfinput validate="#validate_style#" required="Yes" type="text" name="action_date" value="#dateformat(now(),dateformat_style)#" onBlur="change_money_info('add_credit_card_payment','action_date');">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="action_date" call_function="change_money_info"></span>
                                 </div> 
                            </div>
                        </div> 
                        <div class="form-group" id="item-action_value">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='261.Tutar'> *</label>
                            <div class="col col-9 col-xs-12">
								<cfinput type="text" name="action_value" class="moneybox" required="yes" onBlur="kur_ekle_f_hesapla('credit_card_info');"  onkeyup="return(FormatCurrency(this,event));"> 
                            </div>
                        </div> 
                        <div class="form-group" id="item-other_money_value">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='644.Dövizli Tutar'></label>
                            <div class="col col-9 col-xs-12">
                             	<cfinput type="text" name="other_money_value" class="moneybox" value="" onBlur="kur_ekle_f_hesapla('credit_card_info',true);" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                        </div> 
                        <div class="form-group" id="item-action_detail">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
                            <div class="col col-9 col-xs-12">
                             	<textarea name="action_detail" id="action_detail" style="width:175px;height:60px;"></textarea>
                            </div>
                        </div>  
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="false">
                        <div class="form-group scrollContent scroll-x2">
                        	 <label class="txtbold"><cf_get_lang no='53.İşlem Para Br'></label>
                            <div class="col col-12">
								 <cfscript>f_kur_ekle(process_type:0,base_value:'action_value',other_money_value:'other_money_value',form_name:'add_credit_card_payment',select_input:'credit_card_info');</cfscript>
                            </div>
                        </div>
                	</div>
                 </div> 
               <div class="row formContentFooter">
                    <div class="col col-12">
                        <cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'>
                    </div>  
               </div>                                             		
        	</div>
         </div>    
     </div>
	</cfform>
<script type="text/javascript">
	function kontrol()
	{
		if (!chk_process_cat('add_credit_card_payment')) return false;
		if(!check_display_files('add_credit_card_payment')) return false;
		if(!chk_period(document.add_credit_card_payment.action_date, 'İşlem')) return false;
		x = document.add_credit_card_payment.credit_card_info.selectedIndex;
		return true;
	}
	kur_ekle_f_hesapla('credit_card_info');
</script>
