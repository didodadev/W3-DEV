<cf_get_lang_set module_name="cheque">
<cfif isnumeric(attributes.id)>
	<cfquery name="GET_ACTION_DETAIL" datasource="#DSN2#">
		SELECT
			*
		FROM
			VOUCHER_PAYROLL VP
		WHERE
			VP.ACTION_ID = #attributes.id# AND
			VP.PAYROLL_TYPE = 108
		<cfif session.ep.isBranchAuthorization>
			AND VP.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
		</cfif>		
	</cfquery>
<cfelse>
	<cfset get_action_detail.recordcount = 0>
</cfif>
<cfif not get_action_detail.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'> <cf_get_lang dictionary_id='58004.Böyle Bir Senet Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
<cfinclude template="../query/get_voucher_cashes.cfm">
<cf_catalystHeader>
<cf_box>
<cfform name="form_payroll_revenue" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_voucher_payroll_entry_return&id=#attributes.ID#">
    <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
    <input type="hidden" name="rev_date" id="rev_date" value="<cfoutput>#dateformat(get_action_detail.payroll_revenue_date,dateformat_style)#</cfoutput>">
    <input type="hidden" name="bordro_type" id="bordro_type" value="1,8">
    <input type="hidden" name="payroll_acc_cari_voucher_based" id="payroll_acc_cari_voucher_based" value="<cfoutput>#GET_ACTION_DETAIL.VOUCHER_BASED_ACC_CARI#</cfoutput>">
    <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.ID#</cfoutput>">
	<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type = "column" index = "1" sort = "true">
						<div class="form-group" id="item-process_cat">
			              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'> *</label>
			              <div class="col col-8 col-xs-12">
			                <cf_workcube_process_cat slct_width="150" process_cat=#get_action_detail.process_cat#>
			              </div>
			            </div>
						<div class="form-group" id="item-payroll_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33983.Bordro No'> *</label>
							<div class="col col-8 col-xs-12">
								  <cfsavecontent variable="message"><cf_get_lang dictionary_id='50327.Bordro No Girmelisiniz!'></cfsavecontent>
								  <cfinput type="text" name="payroll_no" value="#get_action_detail.PAYROLL_NO#" required="yes" message="#message#" style="width:150px;" maxlength="10">
							</div>
						  </div>
						  <div class="form-group" id="item-payroll_revenue_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
								  <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
								  <cfinput value="#dateformat(GET_ACTION_DETAIL.payroll_revenue_date,dateformat_style)#" required="Yes" message="#message#" type="text" name="payroll_revenue_date" readonly style="width:150px;" validate="#validate_style#" onBlur="change_money_info('form_payroll_revenue','payroll_revenue_date');">							      
								  <span class="input-group-addon"><cf_wrk_date_image date_field="payroll_revenue_date" call_function="change_money_info" control_date="#dateformat(GET_ACTION_DETAIL.payroll_revenue_date,dateformat_style)#"></span>
								</div>
							</div>
						  </div>
						<div class="form-group" id="item-revenue_collector_id">
			              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58586.İşlem Yapan'> *</label>
			              <div class="col col-8 col-xs-12">
							  <div class="input-group">
									<input type="hidden" name="REVENUE_COLLECTOR_ID" id="REVENUE_COLLECTOR_ID" value="<cfoutput>#GET_ACTION_DETAIL.REVENUE_COLLECTOR_ID#</cfoutput>">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='33981.Tahsil Edeni Girmelisiniz !'></cfsavecontent>
                                    <cfinput type="text" name="REVENUE_COLLECTOR" value="#get_emp_info(get_action_detail.REVENUE_COLLECTOR_ID,0,0)#" required="yes" message="#message#" style="width:150px;" readonly>							      
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_payroll_revenue.REVENUE_COLLECTOR_ID&field_name=form_payroll_revenue.REVENUE_COLLECTOR<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1','list','popup_list_positions');" title="<cf_get_lang dictionary_id='58586.İşlem Yapan'>"></span>
							  </div>
			              </div>
			            </div>

					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type = "column" index = "2" sort = "true">
						<div class="form-group" id="item-company_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.cari Hesap'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
								  <cfsavecontent variable="message"><cf_get_lang dictionary_id='54613.Şirket Girmelisiniz !'></cfsavecontent>
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
								  <cfinput type="text" name="company_name" value="#member_name#" style="width:150px;" readonly="readonly" required="yes" message="#message#">								
								  <span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=1,2,3&field_comp_id=form_payroll_revenue.company_id&field_member_name=form_payroll_revenue.company_name&field_name=form_payroll_revenue.company_name&field_consumer=form_payroll_revenue.consumer_id&field_emp_id=form_payroll_revenue.employee_id&field_type=form_payroll_revenue.member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list','popup_list_pars');" title="<cf_get_lang dictionary_id='57519.Cari Hesap'>"></span>
								</div>
							</div>
						  </div>
							<div class="form-group" id="item-cash_id">
			              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57520.Kasa'></label>
			              <div class="col col-8 col-xs-12">
							<cf_wrk_Cash name="cash_id" currency_branch="1" value="#get_action_detail.payroll_cash_id#" acc_code="1">
			              </div>
			            </div>
						<div class="form-group" id = "item-special_definition_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58928.Ödeme Tipi'></label>
							<div class="col col-8 col-xs-12">
								<cf_wrk_special_definition width_info='150' type_info='2' field_id="special_definition_id" selected_value='#get_action_detail.special_definition_id#'>
							</div>
						</div>
						<div class="form-group" id="item-project_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
								  <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#get_action_detail.project_id#</cfoutput>">
								  <cfif len(get_action_detail.project_id)>
									  <cfquery name="get_project_name" datasource="#dsn#">
										  SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_action_detail.project_id#
									  </cfquery>
								  </cfif>
								  <input name="project_name" type="text" id="project_name" style="width:150px;" onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" value="<cfif len(get_action_detail.project_id)><cfoutput>#get_project_name.project_head#</cfoutput></cfif>" autocomplete="off">
								  <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=form_payroll_revenue.project_name&project_id=form_payroll_revenue.project_id</cfoutput>');" title="<cf_get_lang dictionary_id='57416.Proje'>"></span>
								</div>
							</div>
						  </div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type = "column" index = "3" sort = "true">
						<div class="form-group" id = "item-ACTION_DETAIL">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
							<div class="col col-8 col-xs-12">
								<textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:150px;height:50px;"><cfoutput>#get_action_detail.action_detail#</cfoutput></textarea>
							</div>
						</div>
						<cfif session.ep.our_company_info.asset_followup eq 1>
                            <div class="form-group" id="item-asset_id">
                              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></label>
                              <div class="col col-8 col-xs-12">
                                <cf_wrkAssetp asset_id='#get_action_detail.assetp_id#' fieldId='asset_id' fieldName='asset_name' form_name='form_payroll_revenue'></div>
                            </div>
                        </cfif>
					</div>
				</cf_box_elements>
					<cf_box_footer>
                    	<cf_record_info query_name="get_action_detail">
						<input type="button" class="ui-wrk-btn ui-wrk-btn-extra" value="<cf_get_lang dictionary_id='50386.Senet Seç'>" onclick="javascript:senet_sec();">
                        <cf_workcube_buttons is_upd='1' 
                        del_function_for_submit='delete_action()'
                        delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.del_voucher_payroll&id=#attributes.id#&head=#get_action_detail.PAYROLL_NO#'
                        add_function='check()'>
				</cf_box_footer>
    <cf_basket id="voucher_payroll_entry_return_bask">
		<cfset attributes.rev_date = dateformat(get_action_detail.payroll_revenue_date,dateformat_style)>
        <cfset attributes.bordro_type = "1,8">
        <cfset attributes.out = "1">
        <cfset attributes.entry_ret = "1">
        <cfinclude template="../display/basket_voucher.cfm">
    </cf_basket>
</cfform>
</cf_box>
</cfif>
<script type="text/javascript">
function delete_action()
{
	if (!chk_period(form_payroll_revenue.payroll_revenue_date, 'İşlem')) return false;				
	if (document.all.del_flag.value != 0)
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
	if (!chk_period(form_payroll_revenue.payroll_revenue_date, 'İşlem')) return false;			
	if(document.all.voucher_num.value == 0)
	{
		alert("<cf_get_lang dictionary_id='50322.Senet Seçiniz veya Senet Ekleyiniz !'>");
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
						alert("<cf_get_lang dictionary_id='50208.İşlem Tarihi Seçilen Senetlerin Son İşlem Tarihinden Önce Olamaz'>!");
						return false;
					}
			}
	}
	for(kk=1;kk<=document.all.kur_say.value;kk++)
	{
		cheque_rate_change(kk);
	}
	if(toplam(1,0,1)==false)return false;;
	return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.payroll_type#'</cfoutput>);
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
