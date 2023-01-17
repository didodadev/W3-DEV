<!--- Çek Giriş Bordrosu --->
<cf_xml_page_edit fuseact="cheque.form_add_payroll_entry">
<cf_get_lang_set module_name="cheque">
<cfparam name="attributes.revenue_collector_id" default="#session.ep.userid#">
<cfparam name="attributes.revenue_collector" default="#session.ep.name# #session.ep.surname#">
<cfinclude template="../query/get_control.cfm">
<cfset cash_status = 1>
<!---<cfinclude template="../query/get_cashes.cfm">--->
<div id="payroll_entry_file" style="margin-left:850px; margin-top:15px; position:absolute;display:none;z-index:9999;"></div><!--- Div disarda olmali --->
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box>
<cfform name="form_payroll_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_payroll_entry">
    <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
    <input type="hidden" name="rev_date" id="rev_date" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
    <input type="hidden" name="bordro_type" id="bordro_type" value="1">
    <input type="hidden" name="x_detail_acc_card" id="x_detail_acc_card" value="<cfoutput>#x_detail_acc_card#</cfoutput>"> 
	<cf_basket_form id="payroll_entry">
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57692.İşlem'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process_cat required>
                            </div>
                        </div>
                        <div class="form-group" id="item-company_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="company_id" id="company_id" value="">
                                    <input type="hidden" name="consumer_id" id="consumer_id" value="">
                                    <input type="hidden" name="employee_id" id="employee_id" value="">
                                    <input type="hidden" name="member_type" id="member_type" value="">
                                    <input type="hidden" name="member_code" id="member_code" value="">
                                    <cfinput type="text" name="company_name" id="company_name" value="" required="yes" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3,9\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE,ACCOUNT_CODE','company_id,consumer_id,employee_id,member_type,member_code','','3','150','get_money_info(\'form_payroll_basket\',\'payroll_revenue_date\')');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57519.Cari Hesap'>" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_member_account_code=form_payroll_basket.member_code&select_list=1,2,3,9&field_comp_id=form_payroll_basket.company_id&field_member_name=form_payroll_basket.company_name&field_name=form_payroll_basket.company_name&field_consumer=form_payroll_basket.consumer_id&field_emp_id=form_payroll_basket.employee_id&field_type=form_payroll_basket.member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-REVENUE_COLLECTOR">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50233.Tahsil Eden'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="revenue_collector_id" id="revenue_collector_id" value="<cfoutput>#attributes.revenue_collector_id#</cfoutput>">
                                    <cfinput type="text" name="revenue_collector" id="revenue_collector" value="#attributes.revenue_collector#" required="yes" readonly>
                                    <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='50233.Tahsil Eden'>" onClick="javascript:windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_payroll_basket.revenue_collector_id&field_name=form_payroll_basket.revenue_collector<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list','popup_list_positions');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-contract_head">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29522.Sözleşme'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="contract_id" id="contract_id" value="">
                                    <input type="text" name="contract_head" id="contract_head" value="">
                                    <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='1174.İşlem Yapan'>" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_contract&field_id=form_payroll_basket.contract_id&field_name=form_payroll_basket.contract_head'</cfoutput>);"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-cash_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57520.Kasa'>*</label>
                            <div class="col col-8 col-xs-12">
                               <cf_wrk_Cash name="cash_id" id="cash_id" currency_branch = "1" cash_status="1" required>
                            </div>
                        </div>
                        <div class="form-group" id="item-project_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="">
                                    <input type="text" name="project_name" id="project_name" onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" value="" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57416.Proje'>" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=form_payroll_basket.project_name&project_id=form_payroll_basket.project_id</cfoutput>');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-payroll_revenue_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="Yes" type="text" name="payroll_revenue_date" id="payroll_revenue_date" onBlur="change_money_info('form_payroll_basket','payroll_revenue_date');">
                                    <span class="input-group-addon">
                                        <cf_wrk_date_image date_field="payroll_revenue_date" call_function="change_money_info">
                                    </span>
                                </div>
                            </div>
                        </div>
                        <cfif session.ep.our_company_info.asset_followup eq 1>
                            <div class="form-group" id="item-asset_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrkAssetp fieldId='asset_id' fieldName='asset_name' form_name='form_payroll_basket'>
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-special_definition_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58929.Tahsilat Tipi'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrk_special_definition width_info='150' type_info='1' field_id="special_definition_id">
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-payroll_no">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49747.Bordro No'></label>
                            <div class="col col-8 col-xs-12">
                                <cfset belge_no = get_cheque_no(belge_tipi:'payroll')>
                                <cfinput type="text" name="payroll_no" value="#belge_no#" required="yes" maxlength="10">
                                <cfset belge_no = get_cheque_no(belge_tipi:'payroll',belge_no:belge_no+1)>
                            </div>
                        </div>
                        <div class="form-group" id="item-ACTION_DETAIL">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="ACTION_DETAIL" id="ACTION_DETAIL" ></textarea>
                            </div>
                        </div>
                    </div>
            	</cf_box_elements>
                <cf_box_footer>
                  <input type="button" value="<cf_get_lang dictionary_id='31314.Çek Ekle'>" class="ui-wrk-btn ui-wrk-btn-extra " onclick="javascript:openBoxDraggable('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.popup_add_cheque');">

                    <cf_workcube_buttons is_upd='0' add_function='kontrol3()'>
                </cf_box_footer>
	</cf_basket_form>
    
        <cf_basket id="payroll_entry_bask">
            <cfset attributes.rev_date = dateformat(now(),dateformat_style)>
            <cfset attributes.bordro_type = "1">
            <cfset attributes.in = 1>
            <cfinclude template="../display/basket_cheque.cfm">
        </cf_basket>
    
</cfform>
</cf_box>
</div>
<script type="text/javascript">
	function open_file()
	{
		document.getElementById("payroll_entry_file").style.display='';
        var form = $(this);
   var url = form.attr('action');
      $.ajax({
	   type: "POST",
	   url: url,
	   success: function(data)
	   {
	   <cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	   }
	 });
		}
    	return false;
	}
	function kontrol3()
	{
		if(!$("#company_name").val().length)
		{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='47508.Cari Hesap Seçiniz'>!</cfoutput>"})    
		return false;
		}
		if(!$("#revenue_collector").val().length)
		{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='33981.Tahsil Eden Girmelisiniz'>!</cfoutput>"})    
		return false;
		}
		if(!$("#payroll_revenue_date").val().length)
		{
		alertObject({message: "<cfoutput><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'>!</cfoutput>"})    
		return false;
		}
		if($("#payroll_no").val().length == "")
		{
		alert("<cf_get_lang dictionary_id='50327.Bordro No Girmelisiniz'>");    
		return false;
		}
		if(!chk_process_cat('form_payroll_basket')) return false;
		if(!check_display_files('form_payroll_basket')) return false;
		if(!chk_period(form_payroll_basket.payroll_revenue_date, 'İşlem')) return false;
		if(document.form_payroll_basket.company_id.value=="" && document.form_payroll_basket.consumer_id.value=="" && document.form_payroll_basket.employee_id.value=="" && document.getElementById('company_name').value!='')
		{
			alert("<cf_get_lang dictionary_id='38238.Geçerli Cari Hesap Giriniz'>!");
			return false;
		}
		if (document.form_payroll_basket.cash_id[document.form_payroll_basket.cash_id.selectedIndex].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='50246.Kasa Seçiniz'>!");
			return false;
		}
		if(document.all.cheque_num.value == 0)
		{
			alert("<cf_get_lang dictionary_id='49853.Çek Ekle'>!");
			return false;
		}
		process=document.form_payroll_basket.process_cat.value;
		var get_process_cat = wrk_safe_query('chq_get_process_cat','dsn3',0,process);
		if(get_process_cat.IS_ACCOUNT ==1)
		{
			if (document.form_payroll_basket.member_code.value=="")
			{ 
				alert ("<cf_get_lang dictionary_id='54481.Seçtiğiniz Üyenin Muhasebe Kodu Secilmemiş'>!");
				return false;
			}
		}
		for(kk=1; kk<=document.getElementById('kur_say').value; kk++)
		{
			cheque_rate_change(kk);
		}
		if(toplam(1,0,1)==false)return false;
		return true;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
