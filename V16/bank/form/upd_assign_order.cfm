<cf_xml_page_edit fuseact="bank.popup_upd_assign_order">
	<cfquery name="get_order" datasource="#dsn2#">
		SELECT 
			BON.*,
			BB.BANK_NAME,
			BB.BANK_BRANCH_NAME,
			A.ACCOUNT_NO
		FROM 
			BANK_ORDERS BON,
			#dsn3_alias#.ACCOUNTS AS A,
			#dsn3_alias#.BANK_BRANCH AS BB
		WHERE 		
			A.ACCOUNT_ID = BON.ACCOUNT_ID
			AND A.ACCOUNT_BRANCH_ID=BB.BANK_BRANCH_ID
			AND BON.BANK_ORDER_TYPE = 260
		<cfif isdefined("attributes.id")>
			AND BON.BANK_ORDER_ID = #attributes.id#
		<cfelse>
			AND BON.BANK_ORDER_ID = #attributes.bank_order_id#
		</cfif>
	</cfquery>
	<cfif len(get_order.company_id)> 
		<cfquery name="account_branch" datasource="#dsn#">
			SELECT
				COMPANY_BANK_ID AS ID,
				COMPANY_ACCOUNT_NO AS NO,
				COMPANY_BANK AS BANK,
				COMPANY_BANK_BRANCH AS BRANCH,
				COMPANY_BANK_MONEY AS MONEY
			FROM
				COMPANY_BANK
			WHERE
				COMPANY_ID = #get_order.company_id#
		</cfquery>
	<cfelseif len(get_order.consumer_id)>
		<cfquery name="account_branch" datasource="#dsn#">
			SELECT
				CONSUMER_BANK_ID AS ID,
				CONSUMER_ACCOUNT_NO AS NO,
				CONSUMER_BANK AS BANK,
				CONSUMER_BANK_BRANCH AS BRANCH,
				MONEY
			FROM
				CONSUMER_BANK
			WHERE
				CONSUMER_ID = #get_order.consumer_id#
		</cfquery>
	<cfelseif len(get_order.employee_id)>
		<cfquery name="account_branch" datasource="#dsn#">
			SELECT
				EMP_BANK_ID AS ID,
				BANK_ACCOUNT_NO AS NO,
				BANK_NAME AS BANK,
				BANK_BRANCH_NAME AS BRANCH,
				MONEY
			FROM
				EMPLOYEES_BANK_ACCOUNTS
			WHERE
				EMPLOYEE_ID = #get_order.employee_id#
		</cfquery>
	</cfif>
	<cfquery name="get_credit_limits" datasource="#dsn3#">
		SELECT 
			CR.CREDIT_LIMIT_ID, 
			CR.LIMIT_HEAD 
		FROM
			CREDIT_LIMIT CR
	</cfquery>
	<cfif not get_order.recordcount>
		<br/><font class="txtbold"><cf_get_lang  dictionary_id="48794.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Banka Talimatı Bulunamadı"> !</font>
		<cfexit method="exittemplate">
	</cfif>
	<cfif len(get_order.special_definition_id)>
		<cfset special_definition_id=get_order.special_definition_id>
	<cfelse>
		<cfset special_definition_id=''>
	</cfif>
	
	<cf_catalystHeader>
	<div class="col col-12 col-xs-12">
		<cf_box>
			<cfform name="add_entry" action="#request.self#?fuseaction=bank.emptypopup_upd_assign_order" method="post">
				<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
				<input type="hidden" name="bank_order_id" id="bank_order_id" value="<cfoutput>#get_order.bank_order_id#</cfoutput>">
				<input type="hidden" name="is_havale" id="is_havale" value="<cfoutput><cfif len(get_order.is_paid)>#get_order.is_paid#<cfelse>0</cfif></cfoutput>">
				<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-process_cat">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'> *</label>
							<div class="col col-8 col-xs-12">
								<cf_workcube_process_cat process_cat="#get_order.BANK_ORDER_TYPE_ID#" slct_width="250" process_type_info="260">
							</div>
						</div>
						<div class="form-group" id="item-wrkBankAccounts">
							<label class="col col-4 col-xs-12"><cf_get_lang  dictionary_id='48706.Banka/Hesap'> *</label>
							<div class="col col-8 col-xs-12">
								<cf_wrkBankAccounts width='250' call_function='kur_ekle_f_hesapla' selected_value='#get_order.account_id#' is_upd='1'>
							</div>
						</div>
						<cfif x_select_branch>
							<div class="form-group" id="item-wrkDepartmentBranch">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
								<div class="col col-8 col-xs-12">
									<cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='250' is_default='1' selected_value='#get_order.from_branch_id#' is_deny_control='1'>
								</div>
							</div>
						</cfif>
						<div class="form-group" id="item-credit_limit">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58963.Kredi Limiti"></label>
							<div class="col col-8 col-xs-12">
								<select name="credit_limit" id="credit_limit">
									<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
									<cfoutput query="get_credit_limits">
										<option value="#credit_limit_id#" <cfif get_order.credit_limit_id eq get_credit_limits.credit_limit_id>selected</cfif>>#limit_head#</option>
									</cfoutput>
								</select> 
							</div>
						</div>
						<cfset emp_id = get_order.employee_id>
						<cfif len(get_order.acc_type_id)>
							<cfset emp_id = "#emp_id#_#get_order.acc_type_id#">
						</cfif>
						<div class="form-group" id="item-company_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='
								57519.Cari Hesap'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_order.company_id#</cfoutput>">
									<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#get_order.consumer_id#</cfoutput>">
									<input type="hidden" name="employee_id" id="employee_id"  value="<cfoutput>#emp_id#</cfoutput>">
									<cfsavecontent variable="message"><cf_get_lang  dictionary_id='33557.Cari Hesap Seçmelisiniz'>!</cfsavecontent>
									<cfif len(get_order.company_id)>
										<cfinput type="text" name="company_name" value="#get_par_info(get_order.company_id,1,1,0)#" required="yes" message="#message#" style="width:250px;" readonly>
									<cfelseif len(get_order.consumer_id)>
										<cfinput type="text" name="company_name" value="#get_cons_info(get_order.consumer_id,0,0)#" required="yes" message="#message#" style="width:250px;" readonly>
									<cfelseif len(get_order.employee_id)>
										<cfinput type="text" name="company_name" value="#get_emp_info(get_order.employee_id,0,0,0,get_order.acc_type_id)#" required="yes" message="#message#" style="width:250px;" readonly>
									</cfif>
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=1,2,3&field_comp_id=add_entry.company_id&field_member_name=add_entry.company_name&field_name=add_entry.company_name&field_emp_id=add_entry.employee_id&field_consumer=add_entry.consumer_id&call_function=account_load()</cfoutput>','list');" title="<cfoutput>#getLang('bank', 165)#</cfoutput>"></span>
								</div>
							</div>
						</div>
						
						<cfif x_bank_account neq 0>
							<div class="form-group" id="item-list_bank">
								<label class="col col-4 col-xs-12"><cf_get_lang  dictionary_id="48785.Carinin Banka Hesapları"><cfif x_bank_account eq 2> *</cfif></label>
								<div class="col col-8 col-xs-12" id="bank_list">
									<select name="list_bank" id="list_bank">
										<option value=""><cf_get_lang  dictionary_id="38839.Banka Hesabı Seçmelisiniz"></option>
										<cfoutput query="account_branch">
											<option value="#ID#"<cfif id eq get_order.action_bank_account>selected</cfif>>#BANK#-#BRANCH#-#NO#-#MONEY#</option>
										</cfoutput>
									</select>
								</div>
							</div>
						</cfif>
						<cfif x_select_payment_type neq 0><!--- gösterilsin veya zorunlu durumu --->
							<div class="form-group" id="item-special_definition_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58928.Ödeme Tipi'><cfif x_select_payment_type eq 2> *</cfif></label>
								<div class="col col-8 col-xs-12">
									<cf_wrk_special_definition selected_value='#special_definition_id#' width_info='150' type_info='2' field_id="special_definition_id">
								</div>
							</div>
						</cfif>
						<div class="form-group" id="item-project_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'><cfif x_required_project> *</cfif></label>
							<div class="col col-8 col-xs-12">
								<cf_wrkProject project_Id="#get_order.project_id#" fieldName="project_name" AgreementNo="1" Customer="2" Employee="3" Priority="4" Stage="5" width="150" boxwidth="600" boxheight="400" buttontype="2">
							</div>
						</div>
						<cfif session.ep.our_company_info.asset_followup eq 1>
							<div class="form-group" id="item-asset_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></label>
								<div class="col col-8 col-xs-12">
									<cf_wrkAssetp asset_id="#get_order.assetp_id#" fieldId='asset_id' fieldName='asset_name' form_name='add_entry'>
								</div>
							</div>
						</cfif>
						<div class="form-group" id="item-order_amount">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'> *</label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='29535.Tutar Girmelisiniz'>!</cfsavecontent>
								<cfinput type="text" name="ORDER_AMOUNT" class="moneybox" value="#TLFormat(get_order.action_value)#" required="yes" onBlur="kur_ekle_f_hesapla('account_id');" onkeyup="return(FormatCurrency(this,event));" message="#message#">
							</div>
						</div>
						<div class="form-group" id="item-other_cash_act_value">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58056.Dövizli Tutar'></label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="OTHER_CASH_ACT_VALUE" value="#TLFormat(get_order.OTHER_MONEY_VALUE)#" class="moneybox" onBlur="kur_ekle_f_hesapla('account_id',true);" onkeyup="return(FormatCurrency(this,event));">
							</div>
						</div>
						<div class="form-group" id="item-payment_date">
							<label class="col col-4 col-xs-12"><cfoutput>#getLang('main', 1439)#</cfoutput> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfinput value="#dateformat(get_order.payment_date,dateformat_style)#" type="text" name="PAYMENT_DATE" validate="#validate_style#" onblur="change_money_info('add_entry','PAYMENT_DATE');">
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="PAYMENT_DATE" call_function="change_money_info"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-action_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfinput value="#dateformat(get_order.action_date,dateformat_style)#" required="Yes" message="#message#" type="text" name="ACTION_DATE" validate="#validate_style#">
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="ACTION_DATE"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-action-detail">
							<label class="col col-4 col-xs-12"><cfoutput>#getLang('main', 217)#</cfoutput></label>
							<div class="col col-8 col-xs-12">
								<textarea name="ACTION_DETAIL" id="ACTION_DETAIL"><cfoutput>#get_order.ACTION_DETAIL#</cfoutput></textarea>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="false">
						<div class="form-group">
								<label class="bold">
									<cfoutput>#getLang('bank', 53)#</cfoutput>
								</label>
						</div>
						 <div class="form-group" id="item-kur_ekle">                    
							<div class="col col-12 scrollContent scroll-x3">
								<cfscript>f_kur_ekle(action_id:get_order.bank_order_id,process_type:1,base_value:'ORDER_AMOUNT',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'add_entry',action_table_name:'BANK_ORDER_MONEY',action_table_dsn:'#dsn2#',select_input:'account_id');</cfscript>
							</div>
                    </div>
					</div>				
				</cf_box_elements>
				<cf_box_footer>
					<div class="col col-6 col-xs-12">
						<cf_record_info query_name="get_order">
					</div>
					<div class="col col-6 col-xs-12">
						<cfquery name="control_payment" datasource="#dsn2#">
							SELECT I.CAMPAIGN_ID FROM INVOICE_MULTILEVEL_PAYMENT_ROWS IR,INVOICE_MULTILEVEL_PAYMENT I WHERE I.INV_PAYMENT_ID = IR.INV_PAYMENT_ID AND IR.BANK_ORDER_ID IS NOT NULL AND IR.BANK_ORDER_ID = #get_order.bank_order_id#
						</cfquery>
						<cfquery name="control_bank" datasource="#dsn2#">
							SELECT ACTION_ID FROM BANK_ACTIONS WHERE BANK_ORDER_ID IS NOT NULL AND BANK_ORDER_ID = #get_order.bank_order_id#
						</cfquery>
						<cfif control_payment.recordcount eq 0 and control_bank.recordcount eq 0>
							<cf_workcube_buttons is_upd='1' is_delete='1' add_function="kontrol()" delete_page_url='#request.self#?fuseaction=bank.emptypopup_del_assign_order&bank_order_id=#get_order.bank_order_id#&old_process_type=#get_order.bank_order_type#'>
						<cfelseif control_payment.recordcount eq 0 and control_bank.recordcount neq 0>
							<cf_workcube_buttons is_upd='1' is_delete='0' add_function="kontrol()">
						<cfelse>
							<cfif x_upd_prim_act eq 1 and control_bank.recordcount eq 0>
								<cf_workcube_buttons is_upd='1' is_insert='0' is_delete='1' add_function="kontrol()" delete_page_url='#request.self#?fuseaction=bank.emptypopup_del_assign_order&bank_order_id=#get_order.bank_order_id#&old_process_type=#get_order.bank_order_type#'>
							</cfif>
							<cfquery name="get_camp_head" datasource="#dsn3#">
								SELECT CAMP_HEAD FROM CAMPAIGNS WHERE CAMP_ID = #control_payment.campaign_id#
							</cfquery>
							<b><cf_get_lang  dictionary_id="48795.Bu İşlem Prim Ödeme İşleminden Oluşmuştur">. (<cfoutput>#get_camp_head.camp_head#</cfoutput>)</b>
						</cfif>
					</div>
				</cf_box_footer>
			</cfform>
		</cf_box>
	</div>
	<script type="text/javascript">
		function kontrol()
		{	
			if(!chk_process_cat('add_entry')) return false;
			if(!check_display_files('add_entry')) return false;
			kur_ekle_f_hesapla('account_id');//dövizli tutarı silenler için..
			if(!$("#company_name").val().length)
			{
				alertObject({message: "<cfoutput><cf_get_lang  dictionary_id='48826.Cari Hesap Seçmelisiniz'> !</cfoutput>"})    
				return false;
			}
			
			if(!$("#ORDER_AMOUNT").val().length)
			{
				alertObject({message: "<cfoutput><cf_get_lang dictionary_id='29535.Tutar Girmelisiniz'> !</cfoutput>"})    
				return false;
			}
			
			if(!$("#PAYMENT_DATE").val().length)
			{
				alertObject({message: "<cfoutput><cf_get_lang  dictionary_id='48833.Ödeme Tarihi Girmelisiniz'> !</cfoutput>"})    
				return false;
			}
			
			if(!$("#ACTION_DATE").val().length)
			{
				alertObject({message: "<cfoutput><cf_get_lang dictionary_id='57906.İşlem Tarihi Girmelisiniz'> !</cfoutput>"})    
				return false;
			}	
							
			<cfif x_bank_account eq 2>
				if(document.getElementById('list_bank').value == '')
				{
					alertObject({message: "<cf_get_lang  dictionary_id='48791.Carinin Banka Hesaplarından Birini Seçmelisiniz'>"})
					return false;
				}
			</cfif>
			<cfif x_required_project>
				if(document.getElementById('project_name').value =='')
				{
					alertObject({message: "<cf_get_lang dictionary_id='58797.Proje Seçiniz'>"})
					return false;
				}
			</cfif>
			<cfif x_select_payment_type eq 2>
				if(document.getElementById('special_definition_id').value == '')
				{
					alertObject({message: "<cf_get_lang  dictionary_id='50236.Tahsilat Tipi Seçiniz'>"});
					return false;
				}
			</cfif>
			return true;
		}
		function account_load()
		{
			if(document.getElementById('consumer_id').value!='')
			{	
				var id=document.getElementById('consumer_id').value;
				AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.popup_bank_process_ajax&consumer_id='+id,'bank_list',1,'İlişkili Hesaplar');
			}
			else if(document.getElementById('company_id').value!='')
			{
				var id=document.getElementById('company_id').value;
				AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.popup_bank_process_ajax&company_id='+id,'bank_list',1,'İlişkili Hesaplar');
			}
			else if(document.getElementById('employee_id').value!='')
			{
				var id=document.getElementById('employee_id').value;
				AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.popup_bank_process_ajax&employee_id='+id,'bank_list',1,'İlişkili Hesaplar');
			}
		}
		kur_ekle_f_hesapla('account_id');
	</script>
	