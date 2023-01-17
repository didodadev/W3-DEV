<div style="display:none;z-index:10;" id="wizard_div"></div>
<cf_xml_page_edit fuseact="objects.income_cost">
<cf_get_lang_set module_name="objects"><!--- sayfanin en altinda kapanisi var --->
<cfscript>
	income_cost= createObject("component","V16.objects.cfc.income_cost") ;
	GET_MONEY=income_cost.GET_MONEY(); 
	GET_EXPENSE_MONEY=income_cost.GET_EXPENSE_MONEY(expense_id:attributes.expense_id);
	GET_EXPENSE=income_cost.GET_EXPENSE(expense_id:attributes.expense_id);
	CHK_SEND_INV=income_cost.CHK_SEND_INV(expense_id:attributes.expense_id);
	CHK_SEND_ARC=income_cost.CHK_SEND_ARC(expense_id:attributes.expense_id);
	CONTROL_EINVOICE=income_cost.CONTROL_EINVOICE(expense_id:attributes.expense_id);
	CONTROL_EARCHIVE=income_cost.CONTROL_EARCHIVE(expense_id:attributes.expense_id);
	GET_DOCUMENT_TYPE=income_cost.GET_DOCUMENT_TYPE();
</cfscript>
<cfif get_expense.recordcount eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='33759.Gelir Fişi Yok veya Silinmiş'>");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfset components2 = createObject('component','V16.workdata.get_budget_period_date')>
<cfset budget_date = components2.get_budget_period_date()>
<cfif len(get_expense.ch_company_id) and get_expense.ch_company_id neq 0>
	<cfset get_expense_comp=income_cost.get_expense_comp(ch_company_id:get_expense.ch_company_id)>
<cfelseif len(get_expense.ch_consumer_id)>
	<cfset GET_CONS_NAME=income_cost.GET_CONS_NAME(ch_consumer_id:get_expense.ch_consumer_id)>
</cfif>
<cfinvoke 
 		component = "/workdata/get_cash" 
 		method="getComponentFunction" 
 		returnvariable="kasa">
		<cfinvokeargument name="acc_code" value="0">
		<cfinvokeargument name="use_period" value="#fusebox.use_period#">
</cfinvoke>
<cf_catalystHeader>
<cf_box>
<cfform name="add_costplan" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_income_cost">
    <input type="hidden" name="branch_id_" id="branch_id_" value="">
	<cfinput type="hidden" name="budget_period" id="budget_period" value="#dateformat(budget_date.budget_period_date,dateformat_style)#">
    <input type="hidden" name="expense_id" id="expense_id" value="<cfoutput>#attributes.expense_id#</cfoutput>">
    <input type="hidden" name="cari_action_type_" id="cari_action_type_" value="<cfif isdefined("get_expense.cari_action_type") and len(get_expense.cari_action_type)><cfoutput>#get_expense.cari_action_type#</cfoutput></cfif>">
    <input type="hidden" name="invoice_payment_plan" id="invoice_payment_plan" value="1">
	<cf_basket_form id="income_cost">
                <cf_box_elements>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    	<div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process_cat process_cat='#get_expense.process_cat#' slct_width='120px;'>
                            </div>
                        </div>
                        <div class="form-group" id="item-ch_member_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                	<cfset emp_id = get_expense.ch_employee_id>
									<cfif len(get_expense.acc_type_id)>
                                        <cfset emp_id = "#emp_id#_#get_expense.acc_type_id#">
                                    </cfif>
                                    <cfif len(get_expense.ch_company_id)>
                                        <cfset ch_member_type="partner">
                                    <cfelseif len(get_expense.ch_consumer_id)>
                                        <cfset ch_member_type="consumer">
                                    <cfelseif len(get_expense.ch_employee_id)>
                                        <cfset ch_member_type="employee">
                                    <cfelse>
                                        <cfset ch_member_type="">
                                    </cfif>
                                    <cfoutput>
                                        <input type="hidden" name="ch_member_type" id="ch_member_type" value="#ch_member_type#">
                                        <input type="hidden" name="ch_company_id" id="ch_company_id" value="#get_expense.ch_company_id#">
                                        <input type="hidden" name="ch_partner_id" id="ch_partner_id" value="<cfif ch_member_type eq "partner">#get_expense.ch_partner_id#<cfelseif ch_member_type eq "consumer">#get_expense.ch_consumer_id#</cfif>">
                                        <input type="hidden" name="emp_id" id="emp_id" value="#emp_id#">
                                        <input type="text" name="ch_company" id="ch_company" style="width:120px;" onfocus="AutoComplete_Create('ch_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','MEMBER_TYPE,COMPANY_ID,PARTNER_CODE,EMPLOYEE_ID,MEMBER_PARTNER_NAME','ch_member_type,ch_company_id,ch_partner_id,emp_id,ch_partner','','3','250','return_company()');" value="<cfif ch_member_type eq "partner">#get_par_info(get_expense.ch_company_id,1,1,0)#<cfelseif ch_member_type eq "consumer">#get_cons_info(get_expense.ch_consumer_id,2,0)#</cfif>" autocomplete="off">
                                    </cfoutput>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&field_id=add_costplan.ch_partner_id&field_adress_id=add_costplan.ship_address_id&field_long_address=add_costplan.adres&field_comp_name=add_costplan.ch_company&field_name=add_costplan.ch_partner&field_comp_id=add_costplan.ch_company_id&field_type=add_costplan.ch_member_type&field_emp_id=add_costplan.emp_id&field_paymethod_id=add_costplan.paymethod&field_paymethod=add_costplan.paymethod_name&field_basket_due_value=add_costplan.basket_due_value&call_function=change_due_date()<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,2,3,9','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-ch_partner">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="ch_partner" id="ch_partner" style="width:120px;" value="<cfif ch_member_type eq "partner"><cfoutput>#get_par_info(get_expense.ch_partner_id,0,-1,0)#</cfoutput><cfelseif ch_member_type eq "consumer"><cfoutput>#get_cons_info(get_expense.ch_consumer_id,0,0)#</cfoutput><cfelseif ch_member_type eq "employee"><cfoutput>#get_emp_info(get_expense.ch_employee_id,0,0,0,get_expense.acc_type_id)#</cfoutput></cfif>">
                            </div>
                        </div>
                        <div class="form-group" id="item-expense_employee_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33483.Tahsil Eden'>  *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="Hidden" name="expense_employee_id" id="expense_employee_id" value="<cfoutput>#get_expense.emp_id#</cfoutput>">
                                    <input type="hidden" name="expense_employee_type" id="expense_employee_type" value="<cfoutput>employee</cfoutput>">
                                    <input type="text" name="expense_employee" id="expense_employee" style="width:120px;" onfocus="AutoComplete_Create('expense_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID,MEMBER_TYPE','expense_employee_id,expense_employee_type','','3','135');" value="<cfoutput>#get_emp_info(get_expense.emp_id,0,0)#</cfoutput>" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_costplan.expense_employee_id&field_name=add_costplan.expense_employee&field_type=add_costplan.expense_employee_type&select_list=1,9','list');"></span>
                                </div>
                            </div>
                        </div>
                         <!--- MCP tarafından #75176 numaralı iş için eklendi.e-Fatura kullanıyorsa gösterilecek --->
                        <cfif session.ep.our_company_info.is_efatura eq 1 >
                        <div class="form-group" id="item-ship_address_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41165.Cari Şube'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="ship_address_id" id="ship_address_id" value="<cfif len(get_expense.SHIP_ADDRESS_ID) and len(get_expense.SHIP_ADDRESS)><cfoutput>#get_expense.ship_address_id#</cfoutput></cfif>"  />
                					<input type="text" name="adres" id="adres" value="<cfif len(get_expense.SHIP_ADDRESS_ID) and len(get_expense.SHIP_ADDRESS)><cfoutput>#get_expense.ship_address#</cfoutput></cfif>" style="width:115px;"/>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="add_adress();"></span>
                                </div>
                            </div>
                        </div>
                        </cfif>
                    </div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
							<div class="form-group" id="item-process_stage">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
								<div class="col col-8 col-xs-12">
									<cf_workcube_process is_upd='0' select_value='#get_expense.process_stage#' process_cat_width='150' is_detail='1'>
								</div>
							</div>
						</cfif>
                    	<div class="form-group" id="item-serial_number">
                        	<cfif len(get_expense.paymethod_id)>
								<cfquery name="get_pay_meyhod" datasource="#dsn#">
									SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_expense.paymethod_id#">
								</cfquery>
							</cfif>
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29412.Seri'> - <cf_get_lang dictionary_id='57487.No'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="serial_number" id="serial_number" maxlength="5" style="width:20px;" value="<cfoutput>#get_expense.serial_number#</cfoutput>">
                                    <span class="input-group-addon no-bg">-</span>
                                    <input type="text" name="serial_no" id="serial_no" maxlength="50" style="width:88px;" value="<cfoutput>#get_expense.serial_no#</cfoutput>" onblur="paper_control(this,'INCOME_COST',true,'<cfoutput>#attributes.expense_id#</cfoutput>','<cfoutput>#get_expense.serial_no#</cfoutput>','','','','','',add_costplan.serial_number);">
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-expense_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33203.Belge Tarihi'>  *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='33454.Lütfen Harcama Tarihi Giriniz'></cfsavecontent>
                					<cfinput type="text" name="expense_date" id="expense_date" value="#dateformat(get_expense.expense_date,dateformat_style)#" validate="#validate_style#" required="yes" message="#alert#" readonly maxlength="10" style="width:118px;" onchange="change_paper_duedate();" onblur="change_money_info('add_costplan','expense_date');">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="expense_date" call_function="change_money_info" control_date="#dateformat(get_expense.expense_date,dateformat_style)#"></span>
                                    
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-expense_paper_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58578.Belge Türü'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="expense_paper_type" id="expense_paper_type" style="width:120px;">
                                    <option value=""><cf_get_lang dictionary_id='58578.Belge Türü'></option>
                                    <cfoutput query="get_document_type">
                                        <option value="#document_type_id#" <cfif get_expense.paper_type eq document_type_id>selected</cfif>>#document_type_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
						<cfif len(get_expense.law_request_id)>
							<cfset components = createObject('component','V16.objects.cfc.income_cost')>
							<cfset getLaw = components.getLawRequest(law_id:get_expense.law_request_id)>
							<div class="form-group" id="item-law_request_no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50363.İcra'>-<cf_get_lang dictionary_id='53302.Dosya No'></label>
								<div class="col col-8 col-xs-12">
									<input type="hidden" name="law_request_id" id="law_request_id" value="<cfoutput>#get_expense.law_request_id#</cfoutput>">
									<input type="text" name="law_request_no" id="law_request_no" value="<cfoutput>#getLaw.file_number#</cfoutput>">
								</div>
							</div>
						</cfif>
                        <cfif x_select_project eq 1 or x_select_project eq 2>
                        <div class="form-group" id="item-project_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('get_expense.project_id')><cfoutput>#get_expense.project_id#</cfoutput></cfif>">
                    				<input type="text" name="project_head" id="project_head" value="<cfif isdefined('get_expense.project_id') and len(get_expense.project_id)><cfoutput>#GET_PROJECT_NAME(get_expense.project_id)#</cfoutput></cfif>"  style="width:115px;" onfocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','add_costplan','3','135')" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_costplan.project_id&project_head=add_costplan.project_head');"></span>
                                    
                                </div>
                            </div>
                        </div>
                        <cfelse>
            			</cfif>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    	<div class="form-group" id="item-paymethod">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="paymethod" id="paymethod" value="<cfif len(get_expense.paymethod_id)><cfoutput>#get_expense.paymethod_id#</cfoutput></cfif>">
                                    <input type="text" name="paymethod_name" id="paymethod_name" style="width:100px;" value="<cfif len(get_expense.paymethod_id)><cfoutput>#get_pay_meyhod.paymethod#</cfoutput></cfif>" onchange="change_paper_duedate2();">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=add_costplan.paymethod&field_dueday=add_costplan.basket_due_value&field_name=add_costplan.paymethod_name&is_paymethods=1&function_name=change_due_date</cfoutput>','list');" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-basket_due_value_date_">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57640.Vade'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='33756.Vade Tarihi İçin Geçerli Bir Format Giriniz'></cfsavecontent>
                                    <input name="basket_due_value" id="basket_due_value" type="text" value="<cfif len(get_expense.due_date)><cfoutput>#datediff('d',get_expense.expense_date,get_expense.due_date)#</cfoutput></cfif>" onchange="change_due_date();change_paper_duedate();" style="width:30px;">
                					<span class="input-group-addon no-bg"></span>
                                    <cfinput type="text" name="basket_due_value_date_" id="basket_due_value_date_" value="#dateformat(get_expense.due_date,dateformat_style)#" onChange="change_due_date(1);change_paper_duedate();" validate="#validate_style#" message="#message#" maxlength="10" style="width:65px;" readonly>
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="basket_due_value_date_"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-system_relation">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58794.Referans No'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="system_relation" id="system_relation" style="width:100px;" value="<cfoutput>#get_expense.system_relation#</cfoutput>">
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    	<div class="form-group" id="item-detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="detail" id="detail" style="width:150px;height:50px;"><cfoutput>#get_expense.detail#</cfoutput></textarea>
                            </div>
                        </div>
                        <cfif x_select_branch eq 1 or session.ep.isBranchAuthorization eq 1>
							<div class="form-group" id="item-branch_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
								<div class="col col-8 col-xs-12">
									<cf_wrkdepartmentbranch fieldid='branch_id' is_branch='1' width='150' selected_value='#get_expense.branch_id#' is_deny_control='1'>
								</div>
							</div>
						</cfif>
						<div id="hidden_fields" style="display:none;"></div>
                        <div class="form-group" id="item-cash">
                        	<label style="display:none!important"><cf_get_lang dictionary_id='58645.Nakit'>/<cf_get_lang dictionary_id='57521.Banka'></label>
                            <div class="col col-12 col-xs-12">
                                <label>
                                <input type="Checkbox" name="cash" id="cash" onclick="ayarla_gizle_goster(1);" <cfif get_expense.is_cash eq 1>checked</cfif>>
                                    <cf_get_lang dictionary_id='58645.Nakit'>
                                </label>
                                <label>
                                    <input type="Checkbox" name="bank" id="bank" onclick="ayarla_gizle_goster(2);" <cfif get_expense.is_bank eq 1>checked</cfif>>
                                    <cf_get_lang dictionary_id='57521.Banka'>
                                </label>
                            </div>
                        </div>
                        <div class="form-group" id="item-banka1">
                            <label style="display:none!important"><cf_get_lang dictionary_id='57520.Kasa'> / <cf_get_lang dictionary_id='57521.Banka '></label>
                            <div class="col col-12 col-xs-12">
                                <div <cfif get_expense.is_cash eq 0>style="display:none;"</cfif> id="kasa1"><cf_get_lang dictionary_id='57520.Kasa'></div>
                                <div <cfif get_expense.is_bank eq 0>style="display:none;"</cfif> id="banka1"><cf_get_lang dictionary_id='57521.Banka'></div>
                                    <div <cfif get_expense.is_cash eq 0>style="display:none;"</cfif> id="kasa2">
										<cf_wrk_Cash name="kasa" acc_code="0" currency_branch="0" value="#get_expense.expense_cash_id#">
                                    </div>
                                    <div <cfif get_expense.is_bank eq 0>style="display:none;"</cfif> id="banka2">
                                        <cf_wrkbankaccounts width='150' is_upd='1' selected_value='#get_expense.expense_cash_id#'>
                                    </div>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
				<cf_box_footer>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<cf_record_info query_name='get_expense'>
					</div>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<cfif not len(isClosed('EXPENSE_ITEM_PLANS',attributes.expense_id)) and (GET_EXPENSE.RELATED_ACTION_TABLE eq '' or not len(isClosed(GET_EXPENSE.RELATED_ACTION_TABLE,GET_EXPENSE.RELATED_ACTION_ID)))>	
							<cfif get_expense.is_iptal eq 1 and session.ep.our_company_info.is_earchive eq 1>
								<b><font color="FF0000" class="pull-right"><cf_get_lang dictionary_id='59833.Fatura İptal Edildi'> <cfif control_earchive.recordcount and control_earchive.is_cancel eq 0>(<cf_get_lang dictionary_id='59847.İptal Bilgisi E-Arşiv Sistemine Gönderilmedi'>)</cfif></font></b>
							<cfelseif get_expense.upd_status neq 0>
								<cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='1' del_function_for_submit='del_kontrol()' delete_page_url='#request.self#?fuseaction=objects.emptypopup_del_collacted_expense_cost&expense_id=#attributes.expense_id#&head=#get_expense.paper_no#&process_cat=#get_expense.process_cat#&active_period=#session.ep.period_id#'>
							</cfif>
						<cfelse>
							<font color="FF0000" class="pull-right"><cf_get_lang dictionary_id='47262.Fatura kapama işlemi yapılan belgede değişiklik yapılamaz'>!</font>
						</cfif>
					</div>					
				</cf_box_footer>
	</cf_basket_form>
	<cf_basket id="income_cost_bask">
		<!--- Satirlar Masrafla ortak kullanildigindan xml parametrelerinden bazilari buraya gore sekilleniyor --->
		<cfset x_row_project_priority_from_product = 0><!--- Satırda Proje Seçilmeden Ürün Seçilemesin --->
		<cfset x_is_add_position_to_asset_list = 0><!--- Varlık Sorumlusu Harcama Yapan Olsun --->
		<cfset x_row_workgroup_project = 0><!--- Satırda Proje Seçilince İş Grubu Otomatik Gelsin --->
		<cfset x_is_project_select = 1><!--- Satırda Ürün Varken Proje Değiştirilebilsin --->
		<cfset x_row_copy_product_info = 1><!--- Satır Kopyalanırken Ürün Bilgileri Taşınsın --->
		<cfset x_row_copy_asset_info = 1><!--- Satır Kopyalanırken Fiziki Varlık Bilgileri Taşınsın --->
		<cfset is_income = 1><!--- Gider/Gelir Kalemi Belirlenir. --->
		<cfinclude template="../display/list_plan_rows_cost.cfm">
		<cf_basket_footer height="125">
			<cfoutput>
				<div id="sepetim_total">
					<div class="col col-3 col-sm-6 col-xs-12">
						<div class="totalBox">
							<div class="totalBoxHead font-grey-mint">
								<span class="headText"><cf_get_lang dictionary_id='57677.Dövizler'></span>
								<div class="collapse">
									<span class="icon-minus"></span>
								</div>
							</div>
						
						<div class="totalBoxBody">
							
							<table>	
								<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#GET_EXPENSE_MONEY.recordcount#</cfoutput>">
								<cfloop query="GET_EXPENSE_MONEY">
									<tr>
										<td><input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
											<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
											<input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onclick="other_calc();" <cfif get_expense.other_money eq money>checked</cfif>>
										</td>
										<cfif session.ep.rate_valid eq 1>
											<cfset readonly_info = "yes">
										<cfelse>
											<cfset readonly_info = "no">
										</cfif>
										<td>#money#</td>
										<td>#TLFormat(rate1,0)#/</td>
										<td valign="bottom"><input type="text" <cfif readonly_info>readonly</cfif> class="box" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="other_calc();"></td>
									</tr>
								</cfloop>
							</table>
						
						</div>
						</div>
					</div>
					<div class="col col-3 col-sm-6 col-xs-12">
						<div class="totalBox">
							<div class="totalBoxHead font-grey-mint">
								<span class="headText"><cf_get_lang dictionary_id='57492.Toplam'></span>
								<div class="collapse">
									<span class="icon-minus"></span>
								</div>
							</div>
							<div class="totalBoxBody">
								<table>
									<tr>
										<td class="txtbold" ><cf_get_lang dictionary_id='57492.Toplam'></td>
										<td style="text-align:right;"><input type="text" name="total_amount" id="total_amount" class="box" readonly="" value="<cfoutput>#TLFormat(get_expense.total_amount,xml_genel_number)#</cfoutput>"></td>
										<td><cfoutput>#session.ep.money#</cfoutput></td>
									</tr>
									<tr>
										<td class="txtbold"><cf_get_lang dictionary_id='33213.Toplam KDV'></td>
										<td style="text-align:right;"><input type="text" name="kdv_total_amount" id="kdv_total_amount" class="box" readonly="" value="<cfoutput>#TLFormat(get_expense.kdv_total,xml_genel_number)#</cfoutput>"></td>
										<td><cfoutput>#session.ep.money#</cfoutput></td>
									</tr>
									<tr>
										<td  class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='58021.ÖTV'></td>
										<td  style="text-align:right;"><input type="text" name="otv_total_amount" id="otv_total_amount" class="box" readonly="" value="#TLFormat(get_expense.otv_total,xml_genel_number)#"></td>
										<td>#session.ep.money#</td>
									</tr>
									<tr>
										<td class="txtbold"><cf_get_lang dictionary_id='50923.BSMV'></td>
										<td style="text-align:right;"><input type="text" name="bsmv_total_amount" id="bsmv_total_amount" class="box" readonly="" value="#TLFormat(get_expense.bsmv_total,xml_genel_number)#"></td>
										<td>#session.ep.money#</td>
									</tr>
									<tr>
										<td class="txtbold"><cf_get_lang dictionary_id='50982.OIV'></td>
										<td style="text-align:right;"><input type="text" name="oiv_total_amount" id="oiv_total_amount" class="box" readonly="" value="#TLFormat(get_expense.oiv_total,xml_genel_number)#"></td>
										<td>#session.ep.money#</td>
									</tr>
									<tr>
										<td class="txtbold">
											<a href="javascript://" onclick="getStopajRate();"><img src="/images/plus_small.gif" title="Stopaj Oranları" border="0" align="absbottom"></a>
											<cf_get_lang dictionary_id='57711.Stopaj'>%
										</td>
										<input type="hidden" name="stopaj_rate_id" id="stopaj_rate_id" value="#get_expense.stopaj_rate_id#">
										<td style="width:40px;"><input type="text" name="stopaj_yuzde" id="stopaj_yuzde" class="box" onblur="calc_stopaj();" onkeyup="return(FormatCurrency(this,event,0));" value="#TLFormat(get_expense.stopaj_oran,xml_genel_number)#" autocomplete="off">
												
										<input type="text" name="stopaj" id="stopaj" class="box" value="#TLFormat(get_expense.stopaj)#" onblur="toplam_hesapla(1);"></td>
									</tr>
									<tr>
										<td class="txtbold"><cf_get_lang dictionary_id='34019.KDV li Toplam'></td>
										<td style="text-align:right;"><input type="text" name="net_total_amount" id="net_total_amount" class="box" readonly="" value="<cfoutput>#TLFormat(get_expense.total_amount_kdvli,xml_genel_number)#</cfoutput>"></td>
										<td><cfoutput>#session.ep.money#</cfoutput></td>
									</tr>
								</table>
							</div>
						</div>
					</div>
					<div class="col col-3 col-sm-6 col-xs-12">
						<div class="totalBox">
							<div class="totalBoxHead font-grey-mint">
								<span class="headText"><cf_get_lang_main no='1148'></span>
								<div class="collapse">
									<span class="icon-minus"></span>
								</div>
							</div>
							<div class="totalBoxBody">
								<table>
									<tr>
										<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='58124.Döviz Toplam'></td>
										<td id="rate_value1" style="text-align:right;"><input type="text" name="other_total_amount" id="other_total_amount" class="box" readonly="" value="<cfoutput>#TLFormat(get_expense.other_money_amount,xml_genel_number)#</cfoutput>"></td>
										<td><input type="text" name="tl_value1" id="tl_value1" class="box" readonly="" value="<cfoutput>#get_expense.other_money#</cfoutput>" style="width:40px;"></td>
									</tr>
									<tr>
										<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='51331.Döviz KDV'></td>
										<td id="rate_value2" style="text-align:right;"><input type="text" name="other_kdv_total_amount" id="other_kdv_total_amount" class="box" readonly="" value="<cfoutput>#TLFormat(get_expense.other_money_kdv,xml_genel_number)#</cfoutput>"></td>
										<td><input type="text" name="tl_value2" id="tl_value2" class="box" readonly="" value="<cfoutput>#get_expense.other_money#</cfoutput>" style="width:40px;"></td>
									</tr>
									<tr>
										<td  class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='58021.ÖTV'> <cf_get_lang dictionary_id='57673.Tutar'></td>
										<td  style="text-align:right;"><input type="text" name="other_otv_total_amount" id="other_otv_total_amount" class="box" readonly="" value="#TLFormat(get_expense.other_money_otv,xml_genel_number)#"></td>
										<td><input type="text" name="tl_value4" id="tl_value4" class="box" readonly="" value="#get_expense.other_money#" style="width:40px;"></td>
									</tr>
									<tr>
										<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='33215.Döviz KDV li Toplam'></td>
										<td id="rate_value3" style="text-align:right;"><input type="text" name="other_net_total_amount" id="other_net_total_amount" class="box" readonly="" value="<cfoutput>#TLFormat(get_expense.other_money_net_total,xml_genel_number)#</cfoutput>"></td>
										<td><input type="text" name="tl_value3" id="tl_value3" class="box" readonly="" value="<cfoutput>#get_expense.other_money#</cfoutput>" style="width:40px;"></td>
									</tr>
								</table>
							</div>
						</div>
					</div>	
					<div class="col col-3 col-sm-6 col-xs-12">
						<div class="totalBox">
							<div class="totalBoxHead font-grey-mint">
								<span class="headText"><cf_get_lang dictionary_id='59181.Vergi'> </span>
								<div class="collapse">
									<span class="icon-minus"></span>
								</div>
							</div>
							<div class="totalBoxBody">  
								<table>
									<tr class="color-list" height="20">
										<td id="td_kdv_list">
											<b><cf_get_lang dictionary_id='57639.KDV'></b>
											<cfif isdefined("kdv_rate_counter") and len(kdv_rate_counter)>
												<cfloop from="1" to="#kdv_rate_counter#" index="m">
													
													<cfset sepet.kdv_array["kdv_total"][m] = wrk_round(sepet.kdv_array["kdv_total"][m],xml_genel_number)>
													<b>% #sepet.kdv_array["rate"][m]#:</b> #TLFormat(sepet.kdv_array["kdv_total"][m],xml_genel_number)#
												</cfloop>
											</cfif>
										</td>
									</tr>
									<tr height="20">
										<td id="td_otv_list">
											<b class="txtbold"><cf_get_lang dictionary_id='58021.ÖTV'></b>
											<cfif isdefined("otv_rate_counter") and len(otv_rate_counter)>
												<cfloop from="1" to="#otv_rate_counter#" index="m">
													<cfset sepet.otv_array["otv_total"][m] = wrk_round(sepet.otv_array["otv_total"][m],xml_genel_number)>
													<b>% #sepet.otv_array["otv_rate"][m]#:</b> #TLFormat(sepet.otv_array["otv_total"][m],xml_genel_number)#
												</cfloop>
											</cfif>
										</td>
									</tr>
									<tr class="color-list" height="20">
										<td id="td_bsmv_list">
											<b class="txtbold"><cf_get_lang dictionary_id="50923.BSMV"></b>
											<cfif isdefined("bsmv_rate_counter") and len(bsmv_rate_counter)>
												<cfloop from="1" to="#bsmv_rate_counter#" index="m">
													<cfset sepet.bsmv_array["bsmv_total"][m] = wrk_round(sepet.bsmv_array["bsmv_total"][m],xml_genel_number)>
													<b>% #sepet.bsmv_array["bsmv_rate"][m]#:</b> #TLFormat(sepet.bsmv_array["bsmv_total"][m],xml_genel_number)#
												</cfloop>
											</cfif>
										</td>
									</tr>
									<tr height="20">
										<td id="td_oiv_list">
											<b class="txtbold"><cf_get_lang dictionary_id="50982.OIV"></b>
											<cfif isdefined("oiv_rate_counter") and len(oiv_rate_counter)>
												<cfloop from="1" to="#oiv_rate_counter#" index="m">
													<cfset sepet.oiv_array["oiv_total"][m] = wrk_round(sepet.oiv_array["oiv_total"][m],xml_genel_number)>
													<b>% #sepet.oiv_array["oiv_rate"][m]#:</b> #TLFormat(sepet.oiv_array["oiv_total"][m],xml_genel_number)#
												</cfloop>
											</cfif>
										</td>
									</tr> 
									<tr>
										<td colspan="2">
											<input type="checkbox" name="tevkifat_box" id="tevkifat_box" onclick="gizle_goster(tevkifat_oran);gizle_goster(tevkifat_plus);gizle_goster(tevk_1);gizle_goster(tevk_2);gizle_goster(beyan_1);gizle_goster(beyan_2);toplam_hesapla();" <cfif get_expense.tevkifat eq 1>checked</cfif>>
											<b><cf_get_lang dictionary_id='58022.Tevkifat'></b>
											<input type="hidden" id="tevkifat_id" name="tevkifat_id" value="#get_expense.tevkifat_id#">
											<input type="text" name="tevkifat_oran" id="tevkifat_oran" value="#TLFormat(get_expense.tevkifat_oran,8)#" readonly <cfif get_expense.tevkifat neq 1>style="display:none;width:35px;"<cfelse>style="width:35px;"</cfif> onblur="toplam_hesapla();">
											<a <cfif get_expense.tevkifat neq 1>style="display:none;cursor:pointer"</cfif> id="tevkifat_plus" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_tevkifat_rates&field_tevkifat_rate=add_costplan.tevkifat_oran&field_tevkifat_rate_id=add_costplan.tevkifat_id&call_function=toplam_hesapla()','small')"> <img src="images/plus_thin.gif" border="0" align="absbottom"></a>
										</td>
									</tr>
									<tr>
										<td id="tevk_1" <cfif get_expense.tevkifat neq 1>style="display:none"</cfif>><b><cf_get_lang dictionary_id ='58022.Tevkifat'> :</b></td>
										<td id="tevk_2" <cfif get_expense.tevkifat neq 1>style="display:none"</cfif> nowrap="nowrap"><div id="tevkifat_text"></div></td>
									</tr>
									<tr>
										<td id="beyan_1" <cfif get_expense.tevkifat neq 1>style="display:none"</cfif>><b><cf_get_lang dictionary_id ='58024.Beyan Edilen'>:</b></td>
										<td id="beyan_2" <cfif get_expense.tevkifat neq 1>style="display:none"</cfif> nowrap="nowrap"><div id="beyan_text"></div></td>
									</tr>   
								</table>
							</div>
						</div>
					</div>
				</div>
			</cfoutput>
		</cf_basket_footer>
	</cf_basket>
</cfform>
</cf_box>
<script type="text/javascript">
	function open_wizard() {
		document.getElementById("wizard_div").style.display ='';
		
		$("#wizard_div").css('margin-left',$("#tabMenu").position().left - 500);
		$("#wizard_div").css('margin-top',$("#tabMenu").position().top + 50);
		$("#wizard_div").css('position','absolute');
		
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_budget_row_calculator&type=income','wizard_div',1);
		return true;
	}
	
		var count = 0;
       $('.collapse').click(function(){
        $(this).parent().parent().find('.totalBoxBody').slideToggle();
            if($(this).find("span").hasClass("icon-minus")){
                $(this).find("span").removeClass("icon-minus").addClass("icon-pluss");
            }
            else{
                $(this).find("span").removeClass("icon-pluss").addClass("icon-minus");
            }
       });
	function getStopajRate(){
		bank_code = $("input#bank_code").val();
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stoppage_rates&field_stoppage_rate=add_costplan.stopaj_yuzde&field_stoppage_rate_id=add_costplan.stopaj_rate_id&field_decimal=#xml_satir_number#</cfoutput>&bank_code='+bank_code+'&call_function=toplam_hesapla()','list');
	}
	function add_adress()
		{
			
			if(document.getElementById("ch_company_id").value=="" || document.getElementsByName("ch_consumer_id").value=="" || document.getElementById("ch_company").value=="")
			{
				alert("<cf_get_lang dictionary_id='57183.Cari Hesap Seçmelisiniz'>!");
				return false;
			}
			else
			{
				if(document.getElementsByName("ch_company_id").value!="")
				{
					
					str_adrlink = '&field_long_adres=add_costplan.adres&field_adress_id=add_costplan.ship_address_id&is_compname_readonly=1';
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(add_costplan.ch_company.value)+''+ str_adrlink , 'list');
					return true;
				}
				else
				{
					str_adrlink = '&field_long_adres=add_costplan.adres&field_adress_id=add_costplan.ship_address_id&is_compname_readonly=1';
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(add_costplan.ch_partner.value)+''+ str_adrlink , 'list');
					return true;
				}
			}
		}
	// Odeme plani icin sube bilgisi
	if(document.getElementById("cash")!= undefined && document.getElementById("cash").checked == true && document.getElementById("kasa") != undefined && document.getElementById("kasa").value != "")
		var branch_id_ = document.getElementById('kasa').value.split(';')[2];
	else
		var branch_id_ = '<cfoutput>#ListGetAt(session.ep.user_location,2,"-")#</cfoutput>';
	document.getElementById("branch_id_").value = branch_id_;
	// Odeme plani icin sube bilgisi
	row_count=<cfoutput>#get_rows.recordcount#</cfoutput>;
	function  auto_project(no)
	{
		AutoComplete_Create('project'+no,'PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id'+no ,'','3','200');
	}
	function kontrol_et()
	{
		if(row_count ==0) return false;
		else return true;
	}
	function banka_kontrol()
	{
		if (document.getElementById("bank")) 
		{	
			document.getElementById("bank").checked = false;
			document.getElementById("banka1").style.display='none';
			document.getElementById("banka2").style.display='none';
		}
		if (document.getElementById("cash")) 
		{
			document.getElementById("cash").checked = false;
			document.getElementById("kasa1").style.display='none';
			document.getElementById("kasa2").style.display='none';
		}
		return true;
	}
	<cfoutput>
	function change_paper_duedate()
	{ 
		var is_holiday = 0;
		var is_nextday = 0;
		if(document.getElementById("paymethod").value.length != 0)
			var paymethod_id_ = document.getElementById("paymethod").value;  
		else
			var paymethod_id_ = 0;
		if(paymethod_id_ != 0){
				var paper_date_ = document.getElementById("expense_date").value; 
				var due_day = document.getElementById("basket_due_value").value;
				var deger= document.getElementById("basket_due_value_date_").value;
				add_url = "";	
				add_url += "&action_date="+paper_date_;
				add_url += "&paymethod_id="+paymethod_id_;			
				$.ajax({ url :'cfc/paymethod_calc.cfc?method=calc_duedate&isAjax=1'+add_url,
					async:false,
					success : function(res){
							data = res.replace('//""','');
							data = $.parseJSON(data);
							}
						}); 
				if(data != ""){
					is_holiday = data.ISHOLIDAY;
					is_nextday = data.NEXT_DAY;
					deger = data.DAYDIFF;
					deger = data.DUE_DATE;
				}else{
					alert("Vade hesaplamasında hata oluştu!");
				} 
				if (data.DUE_DATE != undefined && data.DAYDIFF != undefined){
				document.getElementById("basket_due_value_date_").value=data.DUE_DATE; 
				document.getElementById("basket_due_value").value=data.DAYDIFF;
				}
				if(is_holiday)
					alert("Ödeme Yönteminde Genel Tatil ve Hafta Tatilinde Vade İlk İş Gününe Ertelensin Parametresi Seçili. Vade Tarihi İlk İş Gününe Ertelendi!");
				if(is_nextday)
					alert("Ödeme Yönteminde hafta günü seçili. Vade Tarihi Düzenlendi!");	
		}
	}
	function change_paper_duedate2()
	{   
		var is_holiday = 0;
		var is_nextday = 0;
		var paymethod_id_ = document.getElementById("paymethod").value;  
		var paper_date_ = document.getElementById("expense_date").value; 
		var due_day = document.getElementById("basket_due_value").value;
		var deger= document.getElementById("basket_due_value_date_").value;
		add_url = "&due_day="+due_day;		
		add_url += "&action_date="+paper_date_;
		add_url += "&paymethod_id="+paymethod_id_;	
		$.ajax({ url :'cfc/paymethod_calc.cfc?method=calc_duedate&isAjax=1'+add_url,
			async:false,
			success : function(res){
					data = res.replace('//""','');
					data = $.parseJSON( data );
					}
				}); 
		if(data != ""){
			is_holiday = data.ISHOLIDAY;
			is_nextday = data.NEXT_DAY;
			deger = data.DAYDIFF;
			deger = data.DUE_DATE;
		}else{
			alert("<cf_get_lang dictionary_id='54842.Vade hesaplamasında hata oluştu'>!");
		} 
		if (data.DUE_DATE != undefined && data.DAYDIFF != undefined){
		document.getElementById("basket_due_value_date_").value=data.DUE_DATE; 
		document.getElementById("basket_due_value").value=data.DAYDIFF;
		}
		if(is_holiday)
			alert("<cf_get_lang dictionary_id='60201.Ödeme Yönteminde Genel Tatil ve Hafta Tatilinde Vade İlk İş Gününe Ertelensin Parametresi Seçili'>. <cf_get_lang dictionary_id='60202.Vade Tarihi İlk İş Gününe Ertelendi'>!");
		if(is_nextday)
			alert("<cf_get_lang dictionary_id='60203.Ödeme Yönteminde hafta günü seçili'>. <cf_get_lang dictionary_id='60204.Vade Tarihi Düzenlendi'>!");	
	}
	function hesapla(field_name,satir,hesap_type,extra_type)
	{
		var toplam_dongu_0 = 0;//satir toplam
		if(document.getElementById("row_kontrol"+satir).value==1)
		{
			if(document.getElementById("total"+satir) != undefined) deger_total = document.getElementById("total"+satir); else deger_total="";//tutar
			if(document.getElementById("quantity"+satir) != undefined) deger_quantity = document.getElementById("quantity"+satir); else deger_quantity="";//miktar
			if(document.getElementById("kdv_total"+satir) != undefined) deger_kdv_total= document.getElementById("kdv_total"+satir); else deger_kdv_total="";//kdv tutarı
			if(document.getElementById("otv_total"+satir) != undefined) deger_otv_total= document.getElementById("otv_total"+satir); else deger_otv_total="";//ötv tutarı
			if(document.getElementById("net_total"+satir) != undefined) deger_net_total = document.getElementById("net_total"+satir); else deger_net_total="";//kdvli tutar
			if(document.getElementById("tax_rate"+satir) != undefined) deger_tax_rate = document.getElementById("tax_rate"+satir); else deger_tax_rate="";//kdv oranı
			if(document.getElementById("otv_rate"+satir) != undefined) deger_otv_rate = document.getElementById("otv_rate"+satir); else deger_otv_rate="";//ötv oranı
			if(document.getElementById("row_bsmv_amount"+satir) != undefined) deger_bsmv_amount = document.getElementById("row_bsmv_amount"+satir); else deger_bsmv_amount=0;//bsmv oranı
					if(document.getElementById("row_bsmv_rate"+satir) != undefined) deger_bsmv_rate = document.getElementById("row_bsmv_rate"+satir); else deger_bsmv_rate=0;//bsmv tutarı
			if(document.getElementById("other_net_total"+satir) != undefined) deger_other_net_total = document.getElementById("other_net_total"+satir); else deger_other_net_total="";//dovizli tutar kdv dahil
			if(document.getElementById("other_net_total_kdvsiz"+satir) != undefined) deger_other_net_total_kdvsiz = document.getElementById("other_net_total_kdvsiz"+satir); else deger_other_net_total_kdvsiz="";//dovizli tutar kdv hariç
			if(document.getElementById("money_id"+satir) != undefined)
			{
				deger_money_id = document.getElementById("money_id"+satir);
				deger_money_id =  list_getat(deger_money_id.value,1,',');
				for(s=1;s<=document.getElementById("kur_say").value;s++)
				{
					money_deger =list_getat(document.add_costplan.rd_money[s-1].value,1,',');
					if(money_deger == deger_money_id)
					{
						deger_diger_para_satir = document.add_costplan.rd_money[s-1];
						form_value_rate_satir = document.getElementById("txt_rate2_"+s);
					}
				}
				deger_para_satir = list_getat(deger_diger_para_satir.value,3,',');
			}
			else
			{
				deger_money_id="";
				deger_para_satir="";
				form_value_rate_satir="";
			}
			if(deger_total != "") deger_total.value = filterNum(deger_total.value,'#xml_satir_number#');
			if(deger_quantity != "") deger_quantity.value = filterNum(deger_quantity.value,'#xml_satir_number#'); else deger_quantity.value = 1;
			if(deger_kdv_total != "") deger_kdv_total.value = filterNum(deger_kdv_total.value,'#xml_satir_number#');
			if(deger_otv_total != "") deger_otv_total.value = filterNum(deger_otv_total.value,'#xml_satir_number#');
			if(deger_net_total != "") deger_net_total.value = filterNum(deger_net_total.value,'#xml_satir_number#');
			if(deger_other_net_total != "") deger_other_net_total.value = filterNum(deger_other_net_total.value,'#xml_satir_number#');
			if(deger_other_net_total_kdvsiz != "") deger_other_net_total_kdvsiz.value = filterNum(deger_other_net_total_kdvsiz.value,'#xml_satir_number#');
			if(hesap_type ==undefined)
			{
				if(deger_otv_total != "" && deger_total != "") deger_otv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_quantity.value)) * deger_otv_rate.value)/100;
				if(deger_kdv_total != "" && deger_total != "") deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_quantity.value)) * deger_tax_rate.value)/100;
			}
			else if(hesap_type == 2)
			{
				if(deger_otv_rate.value == undefined)
					otv_rate_ = 0;
				else 
					otv_rate_ = deger_otv_rate.value;
					
				if(deger_tax_rate != undefined && deger_tax_rate.value == '')
					tax_rate_ = 0;
				else
					tax_rate_ = deger_tax_rate.value;	
				if(deger_total != "" && deger_tax_rate != "") deger_total.value = ((parseFloat(deger_net_total.value)/parseFloat(deger_quantity.value))*100)/ (parseFloat(tax_rate_)+parseFloat(otv_rate_)+100);
				if(deger_kdv_total != "" && deger_total != "") deger_kdv_total.value = (parseFloat(deger_total.value * deger_quantity.value * deger_tax_rate.value))/100;
				if(deger_otv_total != "" && deger_total != "") deger_otv_total.value = (parseFloat(deger_total.value * deger_quantity.value * deger_otv_rate.value))/100;
			}
			toplam_dongu_0 = parseFloat(deger_total.value * deger_quantity.value);
			if(deger_kdv_total != "") toplam_dongu_0 = toplam_dongu_0 + parseFloat(deger_kdv_total.value);
			if(deger_otv_total != "") toplam_dongu_0 = toplam_dongu_0 + parseFloat(deger_otv_total.value);
			if(extra_type != 2)
				if(deger_other_net_total != "") deger_other_net_total.value = ((toplam_dongu_0) * parseFloat(deger_para_satir) / (parseFloat(form_value_rate_satir.value)));
			if(deger_net_total != "") deger_net_total.value = commaSplit(toplam_dongu_0,'#xml_satir_number#');
			if(deger_total != "") deger_total.value = commaSplit(deger_total.value,'#xml_satir_number#');
			if(deger_quantity != "") deger_quantity.value = commaSplit(deger_quantity.value,'#xml_satir_number#');
			if(deger_kdv_total != "") deger_kdv_total.value = commaSplit(deger_kdv_total.value,'#xml_satir_number#');
			if(deger_otv_total != "") deger_otv_total.value = commaSplit(deger_otv_total.value,'#xml_satir_number#');
			if(deger_other_net_total != "") deger_other_net_total.value = commaSplit(deger_other_net_total.value,'#xml_satir_number#');
			if(deger_other_net_total_kdvsiz != "") deger_other_net_total_kdvsiz.value = commaSplit(deger_other_net_total_kdvsiz.value,'#xml_satir_number#');
			
			if( field_name+satir == 'row_bsmv_amount'+satir+'' ){
				row_bsmv_amount = filterNum( document.getElementById('row_bsmv_amount'+satir+'').value);
				row_bsmv_rate = row_bsmv_amount * 100 / filterNum(document.getElementById('total'+satir+'').value);
				row_bsmv_currency = row_bsmv_amount * filterNum(document.getElementById('txt_rate2_'+satir+'').value) / filterNum(document.getElementById('txt_rate1_'+satir+'').value);
			}
			else if( field_name+satir == 'row_bsmv_currency'+satir+'' ){
				row_bsmv_currency = filterNum( document.getElementById('row_bsmv_currency'+satir+'').value);
				row_bsmv_amount = row_bsmv_currency * filterNum(document.getElementById("txt_rate1_"+satir).value) / filterNum(document.getElementById("txt_rate2_"+satir).value);
				row_bsmv_rate = row_bsmv_amount * 100 /  filterNum(document.getElementById('net_total'+satir+'').value);
			}
			else if( field_name+satir == 'row_bsmv_rate'+satir+'' ){
				row_bsmv_rate =  document.getElementById('row_bsmv_rate'+satir+'').value;
				row_bsmv_amount = filterNum(document.getElementById('total'+satir+'').value) * row_bsmv_rate / 100;
				row_bsmv_currency = row_bsmv_amount * filterNum(document.getElementById("txt_rate2_"+satir).value) / filterNum(document.getElementById("txt_rate1_"+satir).value);
			}

			if( document.getElementById("row_bsmv_rate"+satir) != undefined && document.getElementById("row_bsmv_rate"+satir).value != 0) {
				document.getElementById('row_bsmv_amount'+satir+'').value = ( row_bsmv_amount > 0 ) ? commaSplit(row_bsmv_amount,<cfoutput>#xml_satir_number#</cfoutput>) : commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);
				document.getElementById('row_bsmv_currency'+satir+'').value = ( row_bsmv_currency > 0 ) ? commaSplit(row_bsmv_currency,<cfoutput>#xml_satir_number#</cfoutput>) : commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);	
			}
			else if( document.getElementById("row_bsmv_rate"+satir) != undefined && document.getElementById("row_bsmv_rate"+satir).value == 0 ){
				document.getElementById('row_bsmv_amount'+satir+'').value = commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);
				document.getElementById('row_bsmv_currency'+satir+'').value = commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);	
			}

			if( field_name+satir == 'row_oiv_amount'+satir+'' ){   
				row_oiv_amount = filterNum( document.getElementById('row_oiv_amount'+satir+'').value);
				row_oiv_rate = row_oiv_amount * 100 / filterNum(document.getElementById('net_total'+satir+'').value);
				document.getElementById('row_oiv_amount'+satir+'').value = ( row_oiv_amount > 0 ) ? commaSplit(row_oiv_amount,<cfoutput>#xml_satir_number#</cfoutput>) : commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);
			} 
			else if( field_name+satir == 'row_oiv_rate'+satir+'' ){
				row_oiv_rate = document.getElementById('row_oiv_rate'+satir+'').value;
				row_oiv_amount = filterNum(document.getElementById('net_total'+satir+'').value) * row_oiv_rate / 100;
				document.getElementById('row_oiv_amount'+satir+'').value = ( row_oiv_amount > 0 ) ? commaSplit(row_oiv_amount,<cfoutput>#xml_satir_number#</cfoutput>) : commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);
			}

			if( field_name+satir == 'row_tevkifat_amount'+satir+''){
				row_tevkifat_amount = filterNum( document.getElementById('row_tevkifat_amount'+satir+'').value );
				row_tevkifat_rate = row_tevkifat_amount * 100 / filterNum(document.getElementById('kdv_total'+satir+'').value);
				document.getElementById('row_tevkifat_amount'+satir+'').value = ( row_tevkifat_amount > 0 ) ? commaSplit(row_tevkifat_amount,<cfoutput>#xml_satir_number#</cfoutput>) : commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);
			}
			else if(field_name+satir == 'row_tevkifat_rate'+satir+''){
				row_tevkifat_rate = filterNum( document.getElementById('row_tevkifat_rate'+satir+'').value );
				row_tevkifat_amount = filterNum( document.getElementById('kdv_total'+satir+'').value) * row_tevkifat_rate / 100;
				document.getElementById('row_tevkifat_amount'+satir+'').value = ( row_tevkifat_amount > 0 ) ? commaSplit(row_tevkifat_amount,<cfoutput>#xml_satir_number#</cfoutput>) : commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);
			}
		}
		if(extra_type == 2 || extra_type == undefined)
			toplam_hesapla(extra_type);
	}
	function toplam_hesapla(type)
	{
		var toplam_dongu_1 = 0;//tutar genel toplam
		var toplam_dongu_2 = 0;// kdv genel toplam
		var toplam_dongu_3 = 0;// kdvli genel toplam
		var toplam_dongu_4 = 0;// ötv genel toplam
		var toplam_dongu_5 = 0;// bsmv genel toplam
		var toplam_dongu_6 = 0;// oiv genel toplam
		var new_taxArray = new Array(0);
		var new_OtvArray = new Array(0);

		var new_BsmvArray = new Array(0);
		var new_OivArray = new Array(0);
		var beyan_tutar = 0;
		var tevkifat_info = "";
		var beyan_tutar_info = "";
		var bsmvArray = new Array(0);
		var oivArray = new Array(0);
		var taxArray = new Array(0);
		var OtvArray = new Array(0);
		var taxBeyanArray = new Array(0);
		var taxTevkifatArray = new Array(0);
		
		if(type != 2)
			doviz_hesapla();
		for(r=1;r<=document.getElementById("record_num").value;r++)
		{
			if(document.getElementById("row_kontrol"+r).value==1)
			{
				if(document.getElementById("total"+r) != undefined) deger_total = document.getElementById("total"+r); else deger_total="";//tutar
				if(document.getElementById("quantity"+r) != undefined) deger_quantity = document.getElementById("quantity"+r); else deger_quantity="";//miktar
				if(document.getElementById("kdv_total"+r) != undefined) deger_kdv_total= document.getElementById("kdv_total"+r); else deger_kdv_total="";//kdv tutarı
				if(document.getElementById("otv_total"+r) != undefined) deger_otv_total= document.getElementById("otv_total"+r); else deger_otv_total="";//ötv tutarı
				if(document.getElementById("net_total"+r) != undefined) deger_net_total = document.getElementById("net_total"+r); else deger_net_total="";//kdvli tutar
				if(document.getElementById("tax_rate"+r) != undefined) deger_tax_rate = document.getElementById("tax_rate"+r); else deger_tax_rate="";//kdv oranı
				if(document.getElementById("otv_rate"+r) != undefined) deger_otv_rate = document.getElementById("otv_rate"+r); else deger_otv_rate="";//ötv oranı
				if(document.getElementById("other_net_total"+r) != undefined) deger_other_net_total = document.getElementById("other_net_total"+r); else deger_other_net_total="";//dovizli tutar kdv dahil
				if(document.getElementById("other_net_total_kdvsiz"+r) != undefined) deger_other_net_total_kdvsiz = document.getElementById("other_net_total_kdvsiz"+r); else deger_other_net_total_kdvsiz="";//dovizli tutar kdv dahil
				if(document.getElementById("row_bsmv_amount"+r) != undefined) deger_bsmv_amount = document.getElementById("row_bsmv_amount"+r); else deger_bsmv_amount="";//bsmv tutarı
				if(document.getElementById("row_bsmv_rate"+r) != undefined) deger_bsmv_rate = document.getElementById("row_bsmv_rate"+r); else deger_bsmv_rate="";//bsmv oranı
				if(document.getElementById("row_oiv_amount"+r) != undefined) deger_oiv_amount = document.getElementById("row_oiv_amount"+r); else deger_oiv_amount="";//oiv tutarı
				if(document.getElementById("row_oiv_rate"+r) != undefined) deger_oiv_rate = document.getElementById("row_oiv_rate"+r); else deger_oiv_rate="";//oiv oranı
				
				if(deger_total != "") deger_total.value = filterNum(deger_total.value,'#xml_satir_number#');
				if(deger_quantity != "") deger_quantity.value = filterNum(deger_quantity.value,'#xml_satir_number#');
				if(deger_kdv_total != "") deger_kdv_total.value = filterNum(deger_kdv_total.value,'#xml_satir_number#');
				
				if(document.getElementById("tax_rate"+r) != undefined && document.getElementById("kdv_total"+r) != undefined)
				{
					if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true)
					{//tevkifat hesaplamaları
						beyan_tutar = beyan_tutar + wrk_round(deger_kdv_total.value*filterNum(document.getElementById("tevkifat_oran").value,8));
					}
					if(new_taxArray.length != 0)
						for (var m=0; m < new_taxArray.length; m++)
						{
							var tax_flag = false;
							if(new_taxArray[m] == deger_tax_rate.value){
								tax_flag = true;
								if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true )
								{//tevkifat hesaplamaları
									taxBeyanArray[m] += wrk_round(deger_kdv_total.value - (deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value,8))));
									taxTevkifatArray[m] += wrk_round(deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value,8)));
								}
								taxArray[m] += wrk_round(deger_kdv_total.value);
								break;
							}
						}
					if(!tax_flag){
						new_taxArray[new_taxArray.length] = deger_tax_rate.value;
						taxBeyanArray[taxBeyanArray.length] = wrk_round(deger_kdv_total.value - (deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value,8))));
						taxTevkifatArray[taxTevkifatArray.length] = wrk_round(deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value,8)));
						taxArray[taxArray.length] = wrk_round(deger_kdv_total.value);
					}
				}
		
				if(deger_otv_total != "") deger_otv_total.value = filterNum(deger_otv_total.value,'#xml_satir_number#');
				
				tax_flag = false;
				bsmv_flag = false;
				oiv_flag = false;
				if(document.getElementById("otv_rate"+r) != undefined && document.getElementById("otv_total"+r) != undefined)
				{
					if(new_OtvArray.length != 0)
						for (var otv=0; otv < new_OtvArray.length; otv++)
						{	
							tax_flag = false;
							if(new_OtvArray[otv] == deger_otv_rate.value){
								tax_flag = true;
								OtvArray[otv] += wrk_round(deger_otv_total.value);
								break;
							}
						}
					if(!tax_flag){
						new_OtvArray[new_OtvArray.length] = deger_otv_rate.value;
						OtvArray[OtvArray.length] = wrk_round(deger_otv_total.value);
					}
				}

				if(document.getElementById("row_bsmv_amount"+r) != undefined && document.getElementById("row_bsmv_rate"+r)){

					if(new_BsmvArray.length != 0)
						for (var bsmv=0; bsmv < new_BsmvArray.length; bsmv++)
						{
							bsmv_flag = false;
							if(new_BsmvArray[bsmv] == parseFloat(deger_bsmv_rate.value.replace(",","."))){
								bsmv_flag = true;
								bsmvArray[bsmv] += parseFloat(deger_bsmv_amount.value.replace(",","."));
								break;
							}
						}
					if(!bsmv_flag){
						new_BsmvArray[new_BsmvArray.length] = parseFloat(deger_bsmv_rate.value.replace(",","."));
						bsmvArray[bsmvArray.length] = parseFloat(deger_bsmv_amount.value.replace(",","."));
					}

				}

				if(document.getElementById("row_oiv_amount"+r) != undefined && document.getElementById("row_oiv_rate"+r)){

					if(new_OivArray.length != 0)
						for (var oiv=0; oiv < new_OivArray.length; oiv++)
						{    
							oiv_flag = false;
							if(new_OivArray[oiv] == deger_oiv_rate.value){
								oiv_flag = true;
								oivArray[oiv] += parseFloat(deger_oiv_amount.value.replace(",","."));
								break;
							}
						}
					if(!oiv_flag){
						new_OivArray[new_OivArray.length] = deger_oiv_rate.value;
						oivArray[oivArray.length] = parseFloat(deger_oiv_amount.value.replace(",","."));
					}
				}
				
				if(deger_net_total != "") deger_net_total.value = filterNum(deger_net_total.value,'#xml_satir_number#');
				if(deger_total != "") toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value * deger_quantity.value);
				if(deger_kdv_total != "") toplam_dongu_2 = toplam_dongu_2 + parseFloat(deger_kdv_total.value);
				if(deger_otv_total != "") toplam_dongu_4 = toplam_dongu_4 + parseFloat(deger_otv_total.value);
				if(deger_bsmv_amount != "") toplam_dongu_5 = toplam_dongu_5 + parseFloat( filterNum( deger_bsmv_amount.value,'#xml_satir_number#'));
				if(deger_oiv_amount != "") toplam_dongu_6 = toplam_dongu_6 + parseFloat( filterNum( deger_oiv_amount.value,'#xml_satir_number#'));
				if(deger_total != "") toplam_dongu_3 = toplam_dongu_3 + (parseFloat(deger_total.value * deger_quantity.value));
				if(deger_kdv_total != "") toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_kdv_total.value);
				if(deger_otv_total != "") toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_otv_total.value);
				if(deger_bsmv_amount != "") toplam_dongu_3 = toplam_dongu_3 + parseFloat( filterNum( deger_bsmv_amount.value, '#xml_satir_number#'));
				if(deger_oiv_amount != "") toplam_dongu_3 = toplam_dongu_3 + parseFloat( filterNum ( deger_oiv_amount.value, '#xml_satir_number#'));
				if(deger_net_total != "") deger_net_total.value = commaSplit(deger_net_total.value,'#xml_satir_number#');
				if(deger_total != "") deger_total.value = commaSplit(deger_total.value,'#xml_satir_number#');
				if(deger_quantity != "") deger_quantity.value = commaSplit(deger_quantity.value,'#xml_satir_number#');
				if(deger_kdv_total != "") deger_kdv_total.value = commaSplit(deger_kdv_total.value,'#xml_satir_number#');
				if(deger_otv_total != "") deger_otv_total.value = commaSplit(deger_otv_total.value,'#xml_satir_number#');
				if(deger_bsmv_amount != "") deger_bsmv_amount.value = commaSplit(deger_bsmv_amount.value,'#xml_satir_number#');
				if(deger_oiv_amount != "") deger_oiv_amount.value = commaSplit(deger_oiv_amount.value,'#xml_satir_number#');
				<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),6)>
				if(document.getElementById("product_id"+r) != undefined && document.getElementById("product_id"+r) != '')
						view_product_info(r);
				</cfif>
			}
		}

		if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true)
			{//tevkifat hesaplamaları
				toplam_dongu_3 = toplam_dongu_3 - toplam_dongu_2 + beyan_tutar;
				toplam_dongu_2 = beyan_tutar;
				tevkifat_text.style.fontWeight = 'bold';
				tevkifat_text.innerHTML = '';
				beyan_text.style.fontWeight = 'bold';
				beyan_text.innerHTML = '';
				
				for (var tt=0; tt < new_taxArray.length; tt++)
				{
					tevkifat_text.innerHTML += '% ' + new_taxArray[tt] + ' : ' + commaSplit(taxBeyanArray[tt],'#xml_genel_number#') + ' ';
					beyan_text.innerHTML += '% ' + new_taxArray[tt] + ' : ' + commaSplit(taxTevkifatArray[tt],'#xml_genel_number#') + ' ';
				}
			}

		var stopaj_yuzde_ = filterNum(document.getElementById("stopaj_yuzde").value,'#xml_satir_number#');
		if(type == undefined || stopaj_yuzde_ == 0)
			stopaj_ = wrk_round(((toplam_dongu_1 * stopaj_yuzde_) / 100),'#xml_genel_number#');
		else
			stopaj_ = filterNum(document.getElementById("stopaj").value);
			
		document.getElementById("stopaj_yuzde").value = commaSplit(stopaj_yuzde_);
		document.getElementById("stopaj").value = commaSplit(stopaj_,'#xml_genel_number#');
		
		
		toplam_dongu_3 = toplam_dongu_3-parseFloat(stopaj_);
		
		document.getElementById("total_amount").value = commaSplit(toplam_dongu_1,'#xml_genel_number#');
		document.getElementById("kdv_total_amount").value = commaSplit(toplam_dongu_2,'#xml_genel_number#');
		document.getElementById("otv_total_amount").value = commaSplit(toplam_dongu_4,'#xml_genel_number#');
		document.getElementById("net_total_amount").value = commaSplit(toplam_dongu_3,'#xml_genel_number#');
		document.getElementById("bsmv_total_amount").value = commaSplit(toplam_dongu_5,'#xml_genel_number#');
		document.getElementById("oiv_total_amount").value = commaSplit(toplam_dongu_6,'#xml_genel_number#');
		for(s=1;s<=document.getElementById("kur_say").value;s++)
		{
			form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
			if(form_txt_rate2_.value == "")
				form_txt_rate2_.value = 1;
		}
		if(document.getElementById("kur_say").value == 1)
			for(s=1;s<=document.getElementById("kur_say").value;s++)
			{
				if(document.add_costplan.rd_money[s-1].checked == true)
				{
					deger_diger_para = document.getElementById("rd_money");
					form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
				}
			}
		else 
			for(s=1;s<=document.getElementById("kur_say").value;s++)
			{
				if(document.add_costplan.rd_money[s-1].checked == true)
				{
					deger_diger_para = document.add_costplan.rd_money[s-1];
					form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
				}
			}
		deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
		deger_money_id_2 = list_getat(deger_diger_para.value,2,',');
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#');
		document.getElementById("other_total_amount").value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#')),'#xml_genel_number#');
		document.getElementById("other_kdv_total_amount").value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#')),'#xml_genel_number#');
		document.getElementById("other_otv_total_amount").value = commaSplit(toplam_dongu_4 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#')),'#xml_genel_number#');
		document.getElementById("other_net_total_amount").value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#')),'#xml_genel_number#');
	
		document.getElementById("tl_value1").value = deger_money_id_1;
		document.getElementById("tl_value2").value = deger_money_id_1;
		document.getElementById("tl_value3").value = deger_money_id_1;
		form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#');

		td_kdv_list.style.fontWeight = 'bold';
		td_kdv_list.innerHTML = '<b><cf_get_lang dictionary_id='57639.KDV'></b>';
		for (var tt=0; tt < new_taxArray.length; tt++)
		{
			td_kdv_list.innerHTML += ' % ' + new_taxArray[tt] + ' : ' + commaSplit(taxArray[tt],'#xml_genel_number#') + ' ';
		}
		td_otv_list.style.fontWeight = 'bold';
		td_otv_list.innerHTML = '<b><cf_get_lang dictionary_id='58021.ÖTV'></b>';
		for (var tt=0; tt < new_OtvArray.length; tt++)
		{
			td_otv_list.innerHTML += ' % ' + new_OtvArray[tt] + ' : ' + commaSplit(OtvArray[tt],'#xml_genel_number#') + ' ';
		}

		td_bsmv_list.style.fontWeight = 'bold';
		td_bsmv_list.innerHTML = '<b><cf_get_lang dictionary_id="50923.BSMV"></b>';
		for (var ss=0; ss < new_BsmvArray.length; ss++)
		{
			td_bsmv_list.innerHTML += ' % ' + new_BsmvArray[ss] + ' : ' + commaSplit(bsmvArray[ss],'#xml_genel_number#') + ' ';
		}

		td_oiv_list.style.fontWeight = 'bold';
		td_oiv_list.innerHTML = '<b><cf_get_lang dictionary_id="50982.OIV"></b>';
		for (var ss=0; ss < new_OivArray.length; ss++)
		{
			td_oiv_list.innerHTML += ' % ' + new_OivArray[ss] + ' : ' + commaSplit(oivArray[ss],'#xml_genel_number#') + ' ';
		}

	}
	function doviz_hesapla(type)
	{
		for(k=1; k<= document.getElementById("record_num").value;k++)
		{		
			if(document.getElementById("money_id"+k) != undefined)
			{
				deger_money_id = document.getElementById("money_id"+k);
				deger_money_id =  list_getat(deger_money_id.value,1,',');
				for (var t=1; t<=document.getElementById("kur_say").value; t++)
				{
					money_deger =list_getat(document.add_costplan.rd_money[t-1].value,1,',');
					if(money_deger == deger_money_id)	
					{						
						rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'#session.ep.our_company_info.rate_round_num#')/filterNum(document.getElementById("txt_rate1_"+t).value,'#session.ep.our_company_info.rate_round_num#');
						if(document.getElementById("other_net_total"+k) != undefined)
						document.getElementById("other_net_total"+k).value = commaSplit(filterNum(document.getElementById("net_total"+k).value,'#xml_satir_number#')/rate2_value,'#xml_satir_number#');
						if(document.getElementById("other_net_total_kdvsiz"+k) != undefined)
						document.getElementById("other_net_total_kdvsiz"+k).value = commaSplit(filterNum(document.getElementById("total"+k).value,'#xml_satir_number#')/rate2_value,'#xml_satir_number#');
					}
				}
			}
		}
	}
	</cfoutput>
	function del_kontrol()
	{
		if (!control_account_process(<cfoutput>'#attributes.expense_id#','#get_expense.action_type#'</cfoutput>)) return false;
		<cfif session.ep.our_company_info.is_efatura and isdefined("chk_send_inv") and chk_send_inv.count>
			if(1 == 1)
			{
				alert("<cf_get_lang dictionary_id='57114.Fatura ile İlişkili e-Fatura Olduğu için Silinemez'> !");
				return false;
			}
		</cfif>
		<cfif session.ep.our_company_info.is_earchive and isdefined("chk_send_arc") and chk_send_arc.count>
			if(1 == 1)
			{
				alert("<cf_get_lang dictionary_id='54873.Fatura e-Arşiv Sistemine Gönderildiği İçin Silinemez'> !");
				return false;
			}
		</cfif>
		if (!chk_period(document.getElementById("expense_date"),"<cf_get_lang dictionary_id ='57692.İşlem'>")) return false;
		if (!check_display_files('add_costplan')) return false;
		else return true;
	}
	function kontrol()
	{
		var beyan_tutar = 0;
		var tevkifat_info = "";
		var beyan_tutar_info = "";
		var new_taxArray = new Array(0);
		var taxBeyanArray = new Array(0);
		var taxTevkifatArray = new Array(0);

		<cfif xml_upd_row_project eq 1>
			for(i=1; i<row_count+1; i++){
				if(document.getElementById("project_id"+i).value == "" || document.getElementById("project"+i).value == "")
				{ 
					document.getElementById("project_id"+i).value = document.getElementById("project_id").value;
					document.getElementById("project"+i).value = document.getElementById("project_head").value;
				<cfif xml_upd_row_expense_center eq 1>
					if(document.getElementById("project_id"+i).value != "" || document.getElementById("project"+i).value != "")
					{ 
						var xxx = document.getElementById("project_id"+i).value;
						var get_expense_center = wrk_safe_query('obj_get_project_related_expense','dsn2',0,xxx);
						if(get_expense_center.recordcount != 0)
						{
							document.getElementById("expense_center_id"+i).value = get_expense_center.EXPENSE_ID;
							document.getElementById("expense_center_name"+i).value = get_expense_center.EXPENSE;
						}
					}
				</cfif>
				}
			}
		</cfif>
		
		if(((document.getElementById("ch_company_id").value != "" && document.getElementById("ch_company").value == "") || (document.getElementById("ch_company").value == "" && document.getElementById("ch_partner").value == "")) &&
			(document.getElementById("cash") == undefined || document.getElementById("cash").checked == false) &&
			document.getElementById("bank").checked == false)
		{
			alert("<cf_get_lang dictionary_id='33455.Cari, kasa veya banka işleminden birini seçiniz'> !");
			return false;
		}
		<cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
			if(document.add_costplan.process_stage.value == "")
			{
				alert("<cf_get_lang dictionary_id ='41036.Lütfen Süreçlerinizi Tanimlayiniz veya Tanimlanan Süreçler Üzerinde Yetkiniz Yok'>!");
				return false;
			}
		</cfif>	
		if (!control_account_process(<cfoutput>'#attributes.expense_id#','#get_expense.action_type#'</cfoutput>)) return false;
		if (!chk_process_cat('add_costplan')) return false;
		if (!check_display_files('add_costplan')) return false;
		if (!chk_period(document.getElementById("expense_date"),"<cf_get_lang dictionary_id ='57692.İşlem'>")) return false;
		<cfif session.ep.our_company_info.is_efatura>
			<cfif isdefined("xml_upd_einvoice") and xml_upd_einvoice eq 0 and isdefined("chk_send_inv") and chk_send_inv.count>
				if(1 == 1)
				{
					alert("<cf_get_lang dictionary_id='57098.e-Faturası Oluşturulmuş Gelir Fişini Güncelleyemezsiniz'>");
					return false;
				}
				else
				{
					if(confirm("<cf_get_lang dictionary_id='57100.e-Faturası Oluşturulmuş Faturayı Güncellemek İstiyor musunuz'>") == true);
					else
					return false;
				}
			<cfelseif isdefined("chk_send_inv") and chk_send_inv.count>	
				if(confirm("<cf_get_lang dictionary_id='33772.e-Faturası Oluşturulmuş Gelir Fişini Güncellemek İstiyor musunuz'>?") == true);
				else
				return false;
			</cfif>
		</cfif>
		<cfif isdefined('x_select_project') and x_select_project eq 2> //xmlde muhasebe icin proje secimi zorunlu ise
			if(document.getElementById("project_head").value=='' || document.getElementById("project_id").value=='')
			{
				alert("<cf_get_lang dictionary_id='58797.Proje Seçiniz'>");
				return false;
			} 
		</cfif>
		
		<cfif session.ep.our_company_info.is_earchive>
			<cfif xml_upd_earchive eq 0 and isdefined("chk_send_arc") and chk_send_arc.count>
				if(1 == 1)
				{
					alert("<cf_get_lang dictionary_id='41472.e-Arşiv Faturası Oluşturulmuş Gelir Fişini Güncelleyemezsiniz'> !");
					return false;
				}
				else
				{
					if(confirm("<cf_get_lang dictionary_id='59850.e-Arşiv Faturası Oluşturulmuş Faturayı Güncellemek İstiyor musunuz'> ?") == true);
					else
					return false;
				}
			<cfelseif isdefined("chk_send_arc") and chk_send_arc.count>	
				if(confirm("<cf_get_lang dictionary_id='60316.e-Arşiv Faturası Oluşturulmuş Gelir Fişini Güncellemek İstiyor musunuz'> !") == true);
				else
				return false;
			</cfif>
		</cfif>
		//Odeme Plani Guncelleme Kontrolleri
		if (document.getElementById("cari_action_type_").value == 5 && "<cfoutput>#get_expense.paymethod_id#</cfoutput>" != "")
		{
			if (confirm("<cf_get_lang dictionary_id='29460.Güncellediğiniz Belgenin Ödeme Planı Yeniden Oluşturulacaktır'>!"))
				document.getElementById("invoice_payment_plan").value = 1;
			else
			{
				document.getElementById("invoice_payment_plan").value = 0;
				<cfif xml_control_payment_plan_status eq 1>
					return false;
				</cfif>
			}
		}
		<cfif (session.ep.our_company_info.is_efatura eq 1) ><!--- MCP tarafından #75351 numaralı iş için eklendi.e-Fatura kullanıyorsa gösterilecek --->
			if(document.getElementById('ch_company_id') != undefined && document.getElementById('ch_company_id').value != '')
			{
				var get_efatura_info = wrk_query("SELECT USE_EFATURA FROM COMPANY WHERE COMPANY_ID = "+document.getElementById('ch_company_id').value,"dsn");	
				if(get_efatura_info.USE_EFATURA == 1)															   
				{
					if(document.getElementById('ship_address_id').value =='' || document.getElementById('adres').value =='')
					{
						alert("<cf_get_lang dictionary_id='60200.Cari Şube Boş Bırakılmaz'>!");
						return false;
					}
				}
			}
		</cfif>
		if(!paper_control(document.getElementById("serial_no"),'INCOME_COST',true,<cfoutput>'#attributes.expense_id#','#get_expense.serial_no#'</cfoutput>,'','','','','',document.getElementById("serial_number"))) return false;
		if(document.getElementById("expense_date").value == "")
		{
			alert("<cf_get_lang dictionary_id='33454.Lütfen Harcama Tarihi Giriniz'>!");
			return false;
		}
		if(document.getElementById("expense_employee").value == "")
		{
			alert("<cf_get_lang dictionary_id='33486.Lütfen Tahsil Eden Giriniz'> !");
			return false;
		}
		record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
		for(r=1;r<=document.getElementById("record_num").value;r++)
		{
			deger_row_kontrol = document.getElementById("row_kontrol"+r);
			if(document.getElementById("expense_center_id"+r) != undefined) deger_expense_center_id = document.getElementById("expense_center_id"+r).value; else deger_expense_center_id ="";
			if(document.getElementById("expense_center_name"+r) != undefined) deger_expense_center_name = document.getElementById("expense_center_name"+r).value; else deger_expense_center_name ="";		
			if(document.getElementById("expense_item_id"+r) != undefined) deger_expense_item_id = document.getElementById("expense_item_id"+r).value; else deger_expense_item_id = "";
			if(document.getElementById("expense_item_name"+r) != undefined) deger_expense_item_name = document.getElementById("expense_item_name"+r).value; else deger_expense_item_name = "";					
			if(document.getElementById("row_detail"+r) != undefined) deger_row_detail = document.getElementById("row_detail"+r).value; else deger_row_detail = "";
			if(document.getElementById("authorized"+r) != undefined) harcama_yapan = document.getElementById("authorized"+r); else harcama_yapan="";
			if(document.getElementById("company"+r) != undefined) harcama_yapan_firma = document.getElementById("company"+r); else harcama_yapan_firma="";
			deger_total = document.getElementById("total"+r);
			
			<cfif x_is_project_priority eq 1>
				deger_project = document.getElementById("project_id"+r);
				deger_project_name = document.getElementById("project"+r);
				deger_product_id = document.getElementById("product_id"+r);
				deger_product_name = document.getElementById("product_name"+r);
			</cfif>
			
			if(deger_row_kontrol.value == 1)
			{
				record_exist=1;
				
				<cfif x_is_project_priority eq 1>
					if (deger_product_id.value == "" || deger_product_name.value == "")
						{ 
							alert ("<cf_get_lang dictionary_id='57725.Ürün Seçiniz'>!");
							return false;
						}
	
					var get_urun_kalem = wrk_safe_query("obj_get_urun_kalem","dsn3","1",deger_product_id.value);
					var urun_record_ = get_urun_kalem.recordcount;
						if(urun_record_<1)
							{
							alert('<cf_get_lang dictionary_id="34267.Ürün Gider Kalemi Bulunamadı">!');
							return false;
							}
						else
							{
							document.getElementById("expense_item_id"+r).value = get_urun_kalem.EXPENSE_ITEM_ID;
							}
							
					if (urun_record_==1 && document.getElementById("expense_item_id"+r).value == '')		
						{
							alert('<cf_get_lang dictionary_id="34264.Seçmiş Olduğunuz Ürün Dağıtıma Tabidir Başka Bir Ürün Seçmeniz Gerekir">!');
							return false;
						}
							
					if (deger_project.value == "" || deger_project_name.value == "")
						{ 
							alert ("<cf_get_lang dictionary_id='58797.Proje Seçiniz!'>");
							return false;
						}
					var get_proje_merkez = wrk_safe_query("obj_get_proje_merkez","dsn","1",deger_project.value);
					var proje_record_ = get_proje_merkez.recordcount;
						if(proje_record_<1 || get_proje_merkez.EXPENSE_CODE =='' || get_proje_merkez.EXPENSE_CODE==undefined)
							{
							alert('<cf_get_lang dictionary_id="34265.Proje Masraf Merkezi Bulunamadı">!');
							return false;
							}
						else
							{
							var get_code = wrk_safe_query("obj_get_code","dsn2","1",get_proje_merkez.EXPENSE_CODE );
							document.getElementById("expense_center_id"+r).value = get_code.EXPENSE_ID;
							}			


				</cfif>
				//Bütçe tarih kısıtı kontrolü
				if(document.getElementById("expense_date"+r) != undefined && document.getElementById("expense_date"+r) != '')
				if(!date_check_hiddens(document.getElementById("budget_period"),document.getElementById("expense_date"+r),'Bütçe dönemi kapandığı için satırdaki harcama tarihi '+document.getElementById("budget_period").value+' tarihinden sonra girilmiş olmalıdır.'))
				return false;
				var otv_list = "";
				if(document.getElementById("otv_rate"+r) != undefined && document.getElementById("otv_rate"+r).value > 0 && !list_find(otv_list,document.getElementById("otv_rate"+r).value))
					otv_list+= document.getElementById("otv_rate"+r).value+',';
				otv_list = otv_list.substr(0,otv_list.length-1);
				if(otv_list != "")
				{
		
					var otv_control = wrk_safe_query("obj_otv_control",'dsn3',0,otv_list);
					if(otv_control.recordcount != list_len(otv_list))
					{
						alert("<cf_get_lang dictionary_id ='33755.Seçtiğiniz ÖTV Değerlerinin İçinde Tanımlı Olmayan ÖTV ler var'> !");
						return false;
					}	
				}	
				<cfif x_is_project_priority eq 0>
				if (deger_expense_center_id == "" || deger_expense_center_name == "")
				{ 
					alert ("<cf_get_lang dictionary_id='33488.Lütfen Gelir Merkezi Seçiniz'>  !");
					return false;
				}	
				if (deger_expense_item_id == "" || deger_expense_item_name == "")
				{ 
					alert ("<cf_get_lang dictionary_id='33489.Lütfen Gelir Kalemi Seçiniz'> !");
					return false;
				}	
				</cfif>
				if (deger_row_detail == "")
				{ 
					alert ("<cf_get_lang dictionary_id='33463.Lütfen Açıklama Giriniz'>!");
					return false;
				}	
				if (deger_total.value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='29535.Lütfen Tutar Giriniz'>  !");
					return false;
				}	
				if (deger_total.value == 0)
				{ 
					alert ("<cf_get_lang dictionary_id='29535.Lütfen Tutar Giriniz'>  !");
					deger_total.value = commaSplit(deger_total.value);
					return false;
				}
				if(harcama_yapan=="" && harcama_yapan_firma=="")
				{
					if(document.getElementById("member_type"+r) != undefined) document.getElementById("member_type"+r).value="";
					if(document.getElementById("company_id"+r) != undefined) document.getElementById("company_id"+r).value="";
					if(document.getElementById("member_id"+r) != undefined) document.getElementById("member_id"+r).value="";
					if(document.getElementById("company"+r) != undefined) document.getElementById("company"+r).value="";
				}
				<!---Muhasebe hesabı alt hesaplar gelirken üst hesapların yazılamaması kontrolü--->
				var action_account_code = document.getElementById("account_code"+r).value;
				if(action_account_code != "")
				{ 
					if(WrkAccountControl(action_account_code,r+'.Satır: Muhasebe Hesabı Hesap Planında Tanımlı Değildir!') == 0)
					return false;
				}

				if(document.getElementById("tax_rate"+r) != undefined && document.getElementById("kdv_total"+r) != undefined)
					{
						if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true)
						{//tevkifat hesaplamaları
							if(new_taxArray.length != 0)
								for (var m=0; m < new_taxArray.length; m++)
								{
									var tax_flag = false;
									if(new_taxArray[m] == document.getElementById("tax_rate"+r).value){
										tax_flag = true;
										taxBeyanArray[m] += wrk_round(filterNum(document.getElementById("kdv_total"+r).value,'<cfoutput>#xml_satir_number#</cfoutput>') - (filterNum(document.getElementById("kdv_total"+r).value,'<cfoutput>#xml_satir_number#</cfoutput>')*(filterNum(document.getElementById("tevkifat_oran").value,8))));
										taxTevkifatArray[m] += wrk_round(filterNum(document.getElementById("kdv_total"+r).value,'<cfoutput>#xml_satir_number#</cfoutput>')*(filterNum(document.getElementById("tevkifat_oran").value,8)));
										break;
									}
								}
							if(!tax_flag){
								new_taxArray[new_taxArray.length] = document.getElementById("tax_rate"+r).value;
								taxBeyanArray[taxBeyanArray.length] = wrk_round(filterNum(document.getElementById("kdv_total"+r).value,'<cfoutput>#xml_satir_number#</cfoutput>') - (filterNum(document.getElementById("kdv_total"+r).value,'<cfoutput>#xml_satir_number#</cfoutput>')*(filterNum(document.getElementById("tevkifat_oran").value,8))));
								taxTevkifatArray[taxTevkifatArray.length] = wrk_round(filterNum(document.getElementById("kdv_total"+r).value,'<cfoutput>#xml_satir_number#</cfoutput>')*(filterNum(document.getElementById("tevkifat_oran").value,8)));
							}
						}
					}
			}
		}
		if (record_exist == 0) 
			{
				alert("<cf_get_lang dictionary_id='33487.Lütfen Gelir Fişine Satır Ekleyiniz'> !");
				return false;
			}
		change_due_date();
		if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true )
			{
				for (var tt=0; tt < new_taxArray.length; tt++)
				{
					document.getElementById("hidden_fields").innerHTML += '<input type="hidden" id="basket_tax_'+tt+'" name="basket_tax_'+tt+'" value="'+new_taxArray[tt]+'">';
					document.getElementById("hidden_fields").innerHTML += '<input type="hidden" id="basket_tax_value_'+tt+'" name="basket_tax_value_'+tt+'" value="'+taxBeyanArray[tt]+'">';
					document.getElementById("hidden_fields").innerHTML += '<input type="hidden" id="tevkifat_tutar_'+tt+'" name="tevkifat_tutar_'+tt+'" value="'+taxTevkifatArray[tt]+'">';
				}
			}
		
		return unformat_fields();
		
	return true;
	}
	function unformat_fields()
	{
		<cfoutput>
			for(r=1;r<=document.getElementById("record_num").value;r++)
			{
				if(document.getElementById("total"+r) != undefined) deger_total = document.getElementById("total"+r); else deger_total="";
				if(document.getElementById("quantity"+r) != undefined) deger_quantity = document.getElementById("quantity"+r); else deger_quantity="";
				if(document.getElementById("kdv_total"+r) != undefined) deger_kdv_total= document.getElementById("kdv_total"+r); else deger_kdv_total="";
				if(document.getElementById("otv_total"+r) != undefined) deger_otv_total= document.getElementById("otv_total"+r); else deger_otv_total="";
				if(document.getElementById("net_total"+r) != undefined) deger_net_total = document.getElementById("net_total"+r); else deger_net_total="";
				if(document.getElementById("other_net_total"+r) != undefined) deger_other_net_total = document.getElementById("other_net_total"+r); else deger_other_net_total="";
				//if(document.getElementById("row_bsmv_rate"+r) != undefined) row_bsmv_rate = document.getElementById("row_bsmv_rate"+r); else row_bsmv_rate="";
                if(document.getElementById("row_bsmv_amount"+r) != undefined) row_bsmv_amount = document.getElementById("row_bsmv_amount"+r); else row_bsmv_amount="";
                if(document.getElementById("row_bsmv_currency"+r) != undefined) row_bsmv_currency = document.getElementById("row_bsmv_currency"+r); else row_bsmv_currency="";
                //if(document.getElementById("row_oiv_rate"+r) != undefined) row_oiv_rate = document.getElementById("row_oiv_rate"+r); else row_oiv_rate="";
                if(document.getElementById("row_oiv_amount"+r) != undefined) row_oiv_amount = document.getElementById("row_oiv_amount"+r); else row_oiv_amount="";
                if(document.getElementById("row_tevkifat_rate"+r) != undefined) row_tevkifat_rate = document.getElementById("row_tevkifat_rate"+r); else row_tevkifat_rate="";
                if(document.getElementById("row_tevkifat_amount"+r) != undefined) row_tevkifat_amount = document.getElementById("row_tevkifat_amount"+r); else row_tevkifat_amount="";
				
				if(deger_total != "") deger_total.value = filterNum(deger_total.value,'#xml_satir_number#');
				if(deger_quantity != "") deger_quantity.value = filterNum(deger_quantity.value,'#xml_satir_number#');
				if(deger_kdv_total != "") deger_kdv_total.value = filterNum(deger_kdv_total.value,'#xml_satir_number#');
				if(deger_otv_total != "") deger_otv_total.value = filterNum(deger_otv_total.value,'#xml_satir_number#');
				if(deger_net_total != "") deger_net_total.value = filterNum(deger_net_total.value,'#xml_satir_number#');
				if(deger_other_net_total != "") deger_other_net_total.value = filterNum(deger_other_net_total.value,'#xml_satir_number#');
				//if(row_bsmv_rate != "") row_bsmv_rate.value = filterNum(row_bsmv_rate.value);
                if(row_bsmv_amount != "") row_bsmv_amount.value = filterNum(row_bsmv_amount.value,'#xml_satir_number#');
                if(row_bsmv_currency != "") row_bsmv_currency.value = filterNum(row_bsmv_currency.value,'#xml_satir_number#');
                //if(row_oiv_rate != "") row_oiv_rate.value = filterNum(row_oiv_rate.value);
                if(row_oiv_amount != "") row_oiv_amount.value = filterNum(row_oiv_amount.value,'#xml_satir_number#');
                if(row_tevkifat_rate != "") row_tevkifat_rate.value = filterNum(row_tevkifat_rate.value,'#xml_satir_number#');
                if(row_tevkifat_amount != "") row_tevkifat_amount.value = filterNum(row_tevkifat_amount.value,'#xml_satir_number#');
			}
			document.getElementById("stopaj_yuzde").value = filterNum(document.getElementById("stopaj_yuzde").value,'#xml_genel_number#');
			document.getElementById("stopaj").value = filterNum(document.getElementById("stopaj").value,'#xml_genel_number#');
			document.getElementById("total_amount").value = filterNum(document.getElementById("total_amount").value,'#xml_genel_number#');
			document.getElementById("kdv_total_amount").value = filterNum(document.getElementById("kdv_total_amount").value,'#xml_genel_number#');
			document.getElementById("otv_total_amount").value = filterNum(document.getElementById("otv_total_amount").value,'#xml_genel_number#');
			document.getElementById("net_total_amount").value = filterNum(document.getElementById("net_total_amount").value,'#xml_genel_number#');
			document.getElementById("bsmv_total_amount").value = filterNum(document.getElementById("bsmv_total_amount").value,'#xml_genel_number#');
            document.getElementById("oiv_total_amount").value = filterNum(document.getElementById("oiv_total_amount").value,'#xml_genel_number#');
			document.getElementById("other_total_amount").value = filterNum(document.getElementById("other_total_amount").value,'#xml_genel_number#');
			document.getElementById("other_kdv_total_amount").value = filterNum(document.getElementById("other_kdv_total_amount").value,'#xml_genel_number#');
			document.getElementById("other_otv_total_amount").value = filterNum(document.getElementById("other_otv_total_amount").value,'#xml_genel_number#');
			document.getElementById("other_net_total_amount").value = filterNum(document.getElementById("other_net_total_amount").value,'#xml_genel_number#');
			document.getElementById("tevkifat_oran").value = filterNum(document.getElementById("tevkifat_oran").value,8);
			for(s=1;s<=document.getElementById("kur_say").value;s++)
			{
				document.getElementById("txt_rate2_" + s).value = filterNum(document.getElementById("txt_rate2_" + s).value,'#session.ep.our_company_info.rate_round_num#');
				document.getElementById("txt_rate1_" + s).value = filterNum(document.getElementById("txt_rate1_" + s).value,'#session.ep.our_company_info.rate_round_num#');
			}
		</cfoutput>
	}
	change_due_date();
	function change_due_date(type)
	{
		if (type==1)
		{
			document.getElementById("basket_due_value").value = datediff(document.getElementById("expense_date").value,document.getElementById("basket_due_value_date_").value,0);
		}
		else
		{
			if(isNumber(document.getElementById("basket_due_value"))!= false && (document.getElementById("basket_due_value").value != 0))
				document.getElementById("basket_due_value_date_").value = date_add('d',+document.getElementById("basket_due_value").value,document.getElementById("expense_date").value);
			else
				document.getElementById("basket_due_value_date_").value = document.getElementById("expense_date").value;
		}
	}
	toplam_hesapla(2);
	function open_process_row()
	{
		document.getElementById('open_process').style.display ='';
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=cost.emptypopup_form_add_cost_rows&type=2','open_process',1);
	}
	<cfoutput>
		function other_calc(row_info,type_info)
		{
			if(row_info != undefined)
			{
				if(document.getElementById("row_kontrol"+row_info).value==1)
				{
					deger_money_id = list_getat(document.getElementById("money_id"+row_info).value,1,',');
					for(kk=1;kk<=document.getElementById("kur_say").value;kk++)
					{
						money_deger =list_getat(document.all.rd_money[kk-1].value,1,',');
						if(money_deger == deger_money_id)
						{
							deger_diger_para_satir = document.all.rd_money[kk-1];
							form_value_rate_satir = document.getElementById("txt_rate2_" + kk);
						}
					}
					if(document.getElementById("other_net_total_kdvsiz"+row_info) != undefined) document.getElementById("other_net_total_kdvsiz"+row_info).value = filterNum(document.getElementById("other_net_total_kdvsiz"+row_info).value,'#xml_satir_number#');
						if(document.getElementById("otv_rate"+row_info) != undefined) 
							var otv_rate = document.getElementById("otv_rate"+row_info).value;
						else
							var otv_rate = 0;
						<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>
							var tax_multiplier = 100/(100+ + otv_rate + +filterNum(document.getElementById("tax_rate"+row_info).value,'#xml_satir_number#'));
						<cfelse>
							var tax_multiplier = (100/(100+ + otv_rate )*100/(100+ +filterNum(document.getElementById("tax_rate"+row_info).value,'#xml_satir_number#')));
						</cfif>
					if(document.getElementById("other_net_total_kdvsiz"+row_info) != undefined) document.getElementById("other_net_total_kdvsiz"+row_info).value = document.getElementById("other_net_total"+row_info).value*tax_multiplier;
					document.getElementById("other_net_total"+row_info).value = filterNum(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#');
					document.getElementById("net_total"+row_info).value = document.getElementById("other_net_total"+row_info).value*filterNum(form_value_rate_satir.value,'#session.ep.our_company_info.rate_round_num#');
					document.getElementById("other_net_total"+row_info).value = commaSplit(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#');
					document.getElementById("net_total"+row_info).value = commaSplit(document.getElementById("net_total"+row_info).value,'#xml_satir_number#');
					if(document.getElementById("other_net_total_kdvsiz"+row_info) != undefined) document.getElementById("other_net_total_kdvsiz"+row_info).value = commaSplit(document.getElementById("other_net_total_kdvsiz"+row_info).value,'#xml_satir_number#');
				}
				if(type_info==undefined)
					hesapla('other_net_total',row_info,2);
				else
					hesapla('other_net_total',row_info,2,type_info);
			}
			else
			{
				for(yy=1;yy<=document.getElementById("record_num").value;yy++)
				{	
					if(document.getElementById("row_kontrol"+yy).value==1)
					{
						other_calc(yy,1);
					}
				}
				toplam_hesapla();
			}
		}
		function other_calc_kdvsiz(row_info,type_info)
		{
			if(row_info != undefined)
			{
				if(document.getElementById("row_kontrol"+row_info).value==1)
				{
					if(document.getElementById("money_id"+row_info) != undefined)
					{
						deger_money_id = list_getat(document.getElementById("money_id"+row_info).value,1,',');
						for(kk=1;kk<=document.getElementById("kur_say").value;kk++)
						{
							money_deger =list_getat(document.add_costplan.rd_money[kk-1].value,1,',');
							if(money_deger == deger_money_id)
							{
								deger_diger_para_satir = document.add_costplan.rd_money[kk-1];
								form_value_rate_satir = document.getElementById("txt_rate2_"+kk);
							}
						}
						if(document.getElementById("other_net_total_kdvsiz"+row_info) != undefined) document.getElementById("other_net_total_kdvsiz"+row_info).value = filterNum(document.getElementById("other_net_total_kdvsiz"+row_info).value,'#xml_satir_number#');
						if(document.getElementById("otv_rate"+row_info) != undefined) 
							var otv_rate = document.getElementById("otv_rate"+row_info).value;
						else
							var otv_rate = 0;
						<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>
							var tax_multiplier = 100/(100+ + otv_rate + +filterNum(document.getElementById("tax_rate"+row_info).value,'#xml_satir_number#'));
						<cfelse>
							var tax_multiplier = (100/(100+ + otv_rate )*100/(100+ +filterNum(document.getElementById("tax_rate"+row_info).value,'#xml_satir_number#')));
						</cfif>
						if(document.getElementById("other_net_total"+row_info) != undefined) document.getElementById("other_net_total"+row_info).value = document.getElementById("other_net_total_kdvsiz"+row_info).value/tax_multiplier;
						if(document.getElementById("net_total"+row_info) != undefined) document.getElementById("net_total"+row_info).value = document.getElementById("other_net_total"+row_info).value*filterNum(form_value_rate_satir.value,'#session.ep.our_company_info.rate_round_num#');
						if(document.getElementById("net_total"+row_info) != undefined) document.getElementById("net_total"+row_info).value = commaSplit(document.getElementById("net_total"+row_info).value,'#xml_satir_number#');
						if(document.getElementById("other_net_total"+row_info) != undefined) document.getElementById("other_net_total"+row_info).value = commaSplit(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#');
						if(document.getElementById("other_net_total_kdvsiz"+row_info) != undefined) document.getElementById("other_net_total_kdvsiz"+row_info).value = commaSplit(document.getElementById("other_net_total_kdvsiz"+row_info).value,'#xml_satir_number#');
					}
				}
				if(type_info==undefined)
					hesapla('other_net_total_kdvsiz',row_info,2);
				else
					hesapla('other_net_total_kdvsiz',row_info,2,type_info);
			}
			else
			{
				for(yy=1;yy<=document.getElementById("record_num").value;yy++)
				{
					if(document.getElementById("row_kontrol"+yy).value==1)
					{
						other_calc(yy,1);
					}
				}
				toplam_hesapla();
			}
		}
	</cfoutput>
	<cfif get_expense.tevkifat eq 1>//tevkifat hesapları için sayfa yüklenrken çağrılıyor
		toplam_hesapla();
	</cfif>
	var stopaj_yuzde_;
	function calc_stopaj()
	{
		stopaj_yuzde_ = filterNum(document.getElementById("stopaj_yuzde").value,'#xml_genel_number#');
		if((stopaj_yuzde_ < 0) || (stopaj_yuzde_ > 99.99))
		{
			alert("<cf_get_lang dictionary_id='50036.Stopaj Oranı'>");
			document.getElementById("stopaj_yuzde").value = 0;
		}
		toplam_hesapla(0);
	}
	function enterControl(e,objeName,ObjeRowNumber,hesapType)
	{
		if(e.keyCode == 13)
		{
			if(hesapType == undefined)
			{
				hesapla(objeName,ObjeRowNumber);
			}
			else
			{
				hesapla(objeName,ObjeRowNumber,hesapType);
			}	
		}
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
