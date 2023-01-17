<!--- Çek Çıkış Bordrosu-Ciro --->
<cf_xml_page_edit fuseact="cheque.form_add_payroll_endorsement">
<cf_get_lang_set module_name="cheque">
<cfinclude template="../query/get_control.cfm">
<cfif isdefined("attributes.order_id") and len(attributes.order_id)>
	<cfif isdefined("attributes.to_company_id") and len(attributes.to_company_id)>
		<cfset to_company= get_par_info(attributes.to_company_id,1,1,0)>
		<cfset member_type="partner"> 
		<cfset member_code_ = get_company_period(attributes.to_company_id)>
	<cfelseif isdefined("attributes.to_employee_id") and len(attributes.to_employee_id)>
		<cfif listlen(attributes.to_employee_id,'_') eq 2>
			<cfset to_company= get_emp_info(listfirst(attributes.to_employee_id,'_'),0,0,0,listlast(attributes.to_employee_id,'_'))>
			<cfset attributes.to_employee_id = listfirst(attributes.to_employee_id,'_')>
		<cfelse>
			<cfset to_company= get_emp_info(attributes.to_employee_id,0,0)>
		</cfif>
		<cfset member_type="employee"> 
		<cfset member_code_ = get_employee_period(attributes.to_employee_id)>
	<cfelseif isdefined("attributes.to_consumer_id") and len(attributes.to_consumer_id)>
		<cfset to_company= get_cons_info(attributes.to_consumer_id,0,0)>
		<cfset member_type="consumer"> 
		<cfset member_code_ = get_consumer_period(attributes.to_consumer_id)>
	</cfif>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form_payroll_revenue" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_payroll_endorsement">
			<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
			<input type="hidden" name="rev_date" id="rev_date" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
			<input type="hidden" name="bordro_type" id="bordro_type" value="4,6">
			<input type="hidden" name="x_detail_acc_card" id="x_detail_acc_card" value="<cfoutput>#x_detail_acc_card#</cfoutput>">
			<cfif isdefined("attributes.order_amount")><!--- Ödeme emirlerinden gelip gelmediğini tutuyor --->
				<input type="hidden" name="order_amount" id="order_amount" value="<cfoutput>#attributes.order_amount#</cfoutput>">
				<input type="hidden" name="order_money_type" id="order_money_type" value="<cfoutput>#attributes.money_type#</cfoutput>">
				<input type="hidden" name="order_id" id="order_id" value="<cfif isdefined("attributes.order_id")><cfoutput>#attributes.order_id#</cfoutput></cfif>">
				<input type="hidden" name="order_row_id" id="order_row_id" value="<cfif isdefined("attributes.order_row_id")><cfoutput>#attributes.order_row_id#</cfoutput></cfif>">
				<cfif isdefined("attributes.id")> <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>"></cfif>
				<input type="hidden" name="correspondence_info" id="correspondence_info" value="<cfif isdefined("attributes.correspondence_info")><cfoutput>#attributes.correspondence_info#</cfoutput></cfif>">
			</cfif>
    		<cf_basket_form id="payroll_endorsement">
            	<cf_box_elements>
                 	<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                     	<div class="form-group" id="item-process_cat">
                        	 <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'> * </label>
                              <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                              	<cf_workcube_process_cat slct_width="237">
                              </div>
                        </div>
						<div class="form-group" id="item-payroll_no">
                        	<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='49747.Bordro No'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfset belge_no = get_cheque_no(belge_tipi:'payroll')>
                                    <cfinput type="text" name="payroll_no" value="#belge_no#" required="yes" style="width:150px;" maxlength="10" >
                                    <cfset belge_no = get_cheque_no(belge_tipi:'payroll',belge_no:belge_no+1)>
                            </div>
                        </div>
                        <div class="form-group" id="item-payroll_revenue_date">
                        	<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            	<div class="input-group">
                                <cfinput value="#dateformat(now(),dateformat_style)#"  validate="#validate_style#" required="Yes"  type="text" name="payroll_revenue_date" style="width:150px;" onBlur="change_money_info('form_payroll_revenue','payroll_revenue_date');">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="payroll_revenue_date" call_function="change_money_info"></span>
                            	</div>
                            </div>
                        </div>
						<cfif session.ep.isBranchAuthorization eq 0>
                            <div class="form-group" id="item-branch_id">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='57453.Şube'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='150' is_default='1' is_deny_control='1'>
                                </div>
                            </div>
                        </cfif>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-company_id">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'> *</label>
						  <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							  <div class="input-group">
							  <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.to_company_id") and len(attributes.to_company_id)><cfoutput>#attributes.to_company_id#</cfoutput></cfif>">
							  <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.to_consumer_id") and len(attributes.to_consumer_id)><cfoutput>#attributes.to_consumer_id#</cfoutput></cfif>">
							  <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.to_employee_id") and len(attributes.to_employee_id)><cfoutput>#attributes.to_employee_id#</cfoutput></cfif>">
							  <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("member_type")><cfoutput>#member_type#</cfoutput></cfif>">
							  <input type="hidden" name="member_code" id="member_code" value="<cfif isdefined("member_code_")><cfoutput>#member_code_#</cfoutput></cfif>">
							  <cfif isdefined("to_company")>
							  <cfinput type="text" name="company_name" value="#to_company#" required="yes"  style="width:150px;" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3,9\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE,ACCOUNT_CODE','company_id,consumer_id,employee_id,member_type,member_code','','3','150','get_money_info(\'form_payroll_revenue\',\'payroll_revenue_date\')');" autocomplete="off">
							  <cfelse>
							  <cfinput type="text" name="company_name" value="" required="yes"  style="width:150px;"onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3,9\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE,ACCOUNT_CODE','company_id,consumer_id,employee_id,member_type,member_code','','3','150','get_money_info(\'form_payroll_revenue\',\'payroll_revenue_date\')');" autocomplete="off">
							  </cfif>
							  <span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_member_account_code=form_payroll_revenue.member_code&select_list=1,2,3,9&field_comp_id=form_payroll_revenue.company_id&field_member_name=form_payroll_revenue.company_name&field_name=form_payroll_revenue.company_name&field_consumer=form_payroll_revenue.consumer_id&field_emp_id=form_payroll_revenue.employee_id&field_type=form_payroll_revenue.member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>','list','popup_list_pars');"></span>
								 </div>
						  </div>
					  </div>
                        <div class="form-group" id="item-pro_employee_id">
                        	<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58586.İşlem Yapan'> *</label>
                             <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                             	<div class="input-group">
                                    <input type="hidden" name="pro_employee_id" id="pro_employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                                    <cfinput type="text" name="emp_name" value="#get_emp_info(session.ep.userid,0,0)#" required="yes"  style="width:150px;" readonly>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=form_payroll_revenue.pro_employee_id&field_name=form_payroll_revenue.emp_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9</cfoutput>','list','popup_list_positions');"></span>
                                </div>
                             </div>
                        </div>
						<div class="form-group" id="item-special_definition_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58928.Ödeme Tipi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_wrk_special_definition width_info='150' type_info='2' field_id="special_definition_id">
                        	</div>
                     	</div>
						<div class="form-group" id="item-project_id">
                        	<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            	<div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="<cfif isDefined("attributes.project_id") and len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                    <input name="project_name" type="text" id="project_name" style="width:150px;" value="<cfif isDefined("attributes.project_id") and len(attributes.project_id)><cfoutput>#get_project_name(attributes.project_id)#</cfoutput></cfif>"  onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');"autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=form_payroll_revenue.project_name&project_id=form_payroll_revenue.project_id</cfoutput>');"></span>
                                </div>
                            </div>
                        </div>
         			</div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                     	<div class="form-group" id="item-ACTION_DETAIL">
                        	<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            	<textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:150px;height:50px;"></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-contract_id">
                        	<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29522.Sozlesme'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="contract_id" id="contract_id" value="">
                                    <input type="text" name="contract_head" id="contract_head" value="" style="width:150px;">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_contract&field_id=form_payroll_revenue.contract_id&field_name=form_payroll_revenue.contract_head'</cfoutput>,'large');"></span>
                                </div>
                            </div>
                        </div>
						<cfif session.ep.our_company_info.asset_followup eq 1>
                            <div class="form-group" id="item-asset_id">
                            	<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                	 <cf_wrkAssetp fieldId='asset_id' fieldName='asset_name' form_name='form_payroll_revenue'>
                                </div>
                            </div>
                        </cfif>
                    </div>
                </cf_box_elements>
                 <cf_box_footer>
					<cfoutput> <input type="button" value="<cf_get_lang dictionary_id='31314.Çek Ekle'>" class="ui-wrk-btn ui-wrk-btn-extra " onclick="javascript:openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_self_cheque');"></cfoutput>
						<input type="button" value="<cf_get_lang dictionary_id='49732.Çek Seç'>" class="ui-wrk-btn ui-wrk-btn-extra " onclick="javascript:cek_sec();">
					<cf_workcube_buttons is_upd='0' add_function='check()'>
				</cf_box_footer>
			</cf_basket_form>
			<cf_basket id="payroll_endorsement_bask">
					<cfset attributes.rev_date = dateformat(now(),dateformat_style)>
					<cfset attributes.bordro_type = "4,6">
					<cfset attributes.self = 1>
					<cfset attributes.out = 1>
					<cfset attributes.endorsement = 1>
					<cfif isdefined("attributes.order_id")><!--- Ödeme emrinden oluşuyorsa --->
						<cfset is_from_payment = 0>
					</cfif>
					<cfinclude template="../display/basket_cheque.cfm">
			</cf_basket>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function check()
{
	<cfif isdefined("attributes.order_id")>
		if(document.all.other_payroll_currency.value != document.form_payroll_revenue.order_money_type.value)
		{
			alert("<cf_get_lang dictionary_id='50486.Bordronun İşlem Para Birimi Ödeme Emrinin Para Biriminden Farklı Olamaz'> !");
			return false;
		}
		if(filterNum(document.all.other_payroll_total.value) != Math.abs(document.form_payroll_revenue.order_amount.value))
		{
			alert("<cf_get_lang dictionary_id='50487.Bordronun Tutarı Ödeme Emrinin Tutarından Farklı Olamaz'> !");
			return false;
		}
	</cfif>
	if(!chk_process_cat('form_payroll_revenue')) return false;
	if(!check_display_files('form_payroll_revenue')) return false;
	if(!chk_period(form_payroll_revenue.payroll_revenue_date, 'İşlem')) return false;
	if(document.form_payroll_revenue.company_id.value=="" && document.form_payroll_revenue.consumer_id.value=="" && document.form_payroll_revenue.employee_id.value=="" && document.getElementById('company_name').value!='')
	{
		alert("<cf_get_lang dictionary_id ='59024.Geçerli cari hesap giriniz'>!");
		return false;
	}
	if(document.all.cheque_num.value == 0)
	{
		alert("<cf_get_lang dictionary_id='50223.Çek Seçiniz veya Çek Ekleyiniz !'>");
		return false;
	}
	process=document.form_payroll_revenue.process_cat.value;
	var get_process_cat = wrk_safe_query('chq_get_process_cat','dsn3',0,process);
	if(get_process_cat.IS_ACCOUNT ==1)
	{
		if (document.form_payroll_revenue.member_code.value=="")
		{ 
			alert ("<cf_get_lang dictionary_id='50321.Seçtiğiniz Üyenin Muhasebe Kodu Secilmemiş !'>");
			return false;
		}
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
	return true;
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">  