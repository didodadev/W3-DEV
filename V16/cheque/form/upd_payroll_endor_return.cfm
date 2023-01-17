<cf_get_lang_set module_name="cheque">
<cfset xml_page_control_list = 'is_company_select'>
<cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="1" fuseact="cheque.form_add_payroll_endor_return">
<cfif not isdefined("is_company_select")>
	<cfset is_company_select = 1>
</cfif>
<cfif isnumeric(url.id)>
	<cfquery name="GET_ACTION_DETAIL" datasource="#DSN2#">
		SELECT
			P.*
		FROM
			PAYROLL P
		WHERE 
			P.ACTION_ID = #url.id# AND
			P.PAYROLL_TYPE = 94
		<cfif session.ep.isBranchAuthorization>
			AND P.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
		</cfif>	
	</cfquery>
<cfelse>
	<cfset get_action_detail.recordcount = 0>
</cfif>
<cfif not get_action_detail.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'> <cf_get_lang dictionary_id='58002.Böyle Bir Çek Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
 <cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-1 col-xs-12">
<cf_box>
 <cfform name="form_payroll_revenue" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_payroll_endor_return&id=#attributes.ID#">
	<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
    <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.ID#</cfoutput>">
	<input type="hidden" name="payroll_acc_cari_cheque_based" id="payroll_acc_cari_cheque_based" value="<cfoutput>#GET_ACTION_DETAIL.CHEQUE_BASED_ACC_CARI#</cfoutput>">
	<input type="hidden" name="rev_date" id="rev_date" value="<cfoutput>#dateformat(get_action_detail.payroll_revenue_date,dateformat_style)#</cfoutput>">
	<input type="hidden" name="bordro_type" id="bordro_type" value="4,6,9">
	<input type="hidden" name="x_detail_acc_card" id="x_detail_acc_card" value="<cfoutput>#x_detail_acc_card#</cfoutput>">
    <cf_basket_form id="payroll_endor_return">
            	<cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_workcube_process_cat slct_width="150" process_cat=#get_action_detail.process_cat#>
                            </div>
                        </div>
                        <div class="form-group" id="item-payroll_no">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='33983.Bordro No'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="payroll_no" value="#get_action_detail.PAYROLL_NO#" required="yes" maxlength="10" >
                            </div>
                        </div>
                        <div class="form-group" id="item-payroll_revenue_date">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput value="#dateformat(GET_ACTION_DETAIL.payroll_revenue_date,dateformat_style)#" validate="#validate_style#" required="Yes" type="text" readonly name="payroll_revenue_date" style="width:150px;" onBlur="change_money_info('form_payroll_revenue','payroll_revenue_date');">
                                <span class="input-group-addon">
                                    <cf_wrk_date_image date_field="payroll_revenue_date" call_function="change_money_info" control_date="#dateformat(GET_ACTION_DETAIL.payroll_revenue_date,dateformat_style)#">
                                </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-emp_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58586.İşlem Yapan'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="pro_employee_id" id="pro_employee_id" value="<cfoutput>#get_action_detail.PAYROLL_REV_MEMBER#</cfoutput>" >
                                    <cfinput type="text" name="emp_name" value="#get_emp_info(get_action_detail.PAYROLL_REV_MEMBER,0,0)#" required="yes" readonly>
                                    <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='58586.İşlem Yapan'>" onClick="javascript:windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_payroll_revenue.pro_employee_id&field_name=form_payroll_revenue.emp_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list','popup_list_positions');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-company_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57519.cari Hesap'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfset emp_id = get_action_detail.employee_id>
                                <cfif len(get_action_detail.acc_type_id)>
                                    <cfset emp_id = "#emp_id#_#get_action_detail.acc_type_id#">
                                </cfif>
                                <cfif len(get_action_detail.company_id)>
                                    <cfset member_name=get_par_info(get_action_detail.company_id,1,1,0)>
                                    <cfset member_type="partner">
                                <cfelseif len(get_action_detail.consumer_id)>
                                    <cfset member_name=get_cons_info(get_action_detail.consumer_id,0,0)>
                                    <cfset member_type="consumer">
                                <cfelseif len(get_action_detail.employee_id)>
                                    <cfset member_name=get_emp_info(get_action_detail.employee_id,0,0,0,get_action_detail.acc_type_id)>
                                    <cfset member_type="employee">
                                </cfif>
                                <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_action_detail.company_id#</cfoutput>">
                                <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#get_action_detail.consumer_id#</cfoutput>">
                                <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#emp_id#</cfoutput>">
                                <input type="hidden" name="member_type" id="member_type" value="<cfoutput>#member_type#</cfoutput>">
                                <cfinput type="text" name="company_name" value="#member_name#" style="width:150px;" readonly required="yes" >
                                <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57519.cari Hesap'>" onClick="javascript:windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=1,2,3,9&field_comp_id=form_payroll_revenue.company_id&field_member_name=form_payroll_revenue.company_name&field_name=form_payroll_revenue.company_name&field_consumer=form_payroll_revenue.consumer_id&field_emp_id=form_payroll_revenue.employee_id&field_type=form_payroll_revenue.member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list','popup_list_pars');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-cash_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57520.Kasa'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_wrk_Cash name="cash_id" value="#get_action_detail.payroll_cash_id#" currency_branch="1" cash_status="1" cash_id ="#get_action_detail.PAYROLL_CASH_ID#">
                            </div>
                        </div>
                        <cfif session.ep.our_company_info.asset_followup eq 1>
                            <div class="form-group" id="item-asset_id">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <cf_wrkAssetp asset_id='#get_action_detail.assetp_id#' fieldId='asset_id' fieldName='asset_name' form_name='form_payroll_revenue'>
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-project_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="Hidden" name="project_id" id="project_id" value="<cfoutput>#get_action_detail.project_id#</cfoutput>">
									<cfif len(get_action_detail.project_id)>
                                        <cfquery name="get_project_name" datasource="#dsn#">
                                            SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_action_detail.project_id#
                                        </cfquery>
                                    </cfif>
                                    <input name="project_name" type="text" id="project_name" style="width:150px;" onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" value="<cfif len(get_action_detail.project_id)><cfoutput>#get_project_name.project_head#</cfoutput></cfif>" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57416.Proje'>" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=form_payroll_revenue.project_name&project_id=form_payroll_revenue.project_id</cfoutput>');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-special_definition">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58929.Tahsilat Tipi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_wrk_special_definition width_info='150' type_info='1' field_id="special_definition_id" selected_value='#get_action_detail.special_definition_id#'>
                            </div>
                        </div>
                        <div class="form-group" id="item-action_detail">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:150px;height:50px;"><cfoutput>#get_action_detail.action_detail#</cfoutput></textarea>
                            </div>
                        </div>
                    </div>
            	</cf_box_elements>
                    <cf_box_footer>
                        <cf_record_info query_name="get_action_detail">
                            <input type="button" value="<cf_get_lang dictionary_id='49732.Çek Seç'>" class="ui-wrk-btn ui-wrk-btn-extra " onclick="javascript:cek_sec();">
                            <cf_workcube_buttons 
                            is_upd = '1' 
                            update_status = '#get_action_detail.UPD_STATUS#'
                            del_function_for_submit = 'delete_action()'
                            delete_page_url = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.del_payroll&id=#url.id#&head=#get_action_detail.PAYROLL_NO#'
                            add_function = 'check()'>
                    </cf_box_footer>
    </cf_basket_form>
    <cf_basket id="payroll_endor_return_bask">
		<cfset attributes.rev_date = dateformat(get_action_detail.payroll_revenue_date,dateformat_style)>
        <cfset attributes.bordro_type = '4,6,9'>
        <cfset attributes.endor_ret = 1>
        <cfset attributes.out_kontrol = 1>
        <cfset attributes.out = 1>
        <cfinclude template="../display/basket_cheque.cfm">
     </cf_basket>
 </cfform>
</cf_box>
</cfif>
</div>
<script type="text/javascript">
function delete_action()
{
	if (!chk_period(form_payroll_revenue.payroll_revenue_date, 'İşlem')) return false;			
	if (form_payroll_revenue.del_flag.value != 0)
	{
		alert("<cf_get_lang dictionary_id='49814.İşlem Görmüş Çekler Var, Bordroyu Silemezsiniz !'>");
		return false;
	}
	return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.payroll_type#'</cfoutput>);
}
function check()
{
	if (!chk_process_cat('form_payroll_revenue')) return false;
	if(!check_display_files('form_payroll_revenue')) return false;
	if(document.all.cheque_num.value == 0)
	{
		alert("<cf_get_lang dictionary_id='50223.Çek Seçiniz veya Çek Ekleyiniz !'>");
		return false;
	}
	var kontrol_process_date = document.all.kontrol_process_date.value;
	if(kontrol_process_date != '')
	{
		var liste_uzunlugu = list_len(kontrol_process_date);
		for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
			{
				var tarih_ = list_getat(kontrol_process_date,str_i_row,',');
				var sonuc_ = datediff(document.all.payroll_revenue_date.value,tarih_,0);
				if(sonuc_ > 0)
					{
						alert("<cf_get_lang dictionary_id='50207.İşlem Tarihi Seçilen Çeklerin Son İşlem Tarihinden Önce Olamaz'>!");
						return false;
					}
			}
	}

	for(kk=1;kk<=document.all.kur_say.value;kk++)
	{
		cheque_rate_change(kk);
	}
	if(toplam(1,0,1)==false)return false;
	return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.payroll_type#'</cfoutput>);
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
