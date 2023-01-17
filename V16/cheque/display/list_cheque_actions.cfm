<cf_get_lang_set module_name="cheque">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.cheque_number" default="">
<cfparam name="attributes.page_action_type" default="">
<cfparam name="attributes.account_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.special_definition_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.product_name" default="">
<cfif isdefined("attributes.is_form_submitted")>
	<cfinclude template="../query/get_cheque_actions.cfm">
<cfelse>
	<cfset GET_CHEQUE_ACTIONS.recordcount = 0>
</cfif>
<cfset islem_tipi = '90,91,92,93,94,95,105,133,134,135'>
<cfquery name="get_process_cat" datasource="#dsn3#">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,#dsn#.Get_Dynamic_Language(PROCESS_CAT_ID,'#session.ep.language#','SETUP_PROCESS_CAT','PROCESS_CAT',NULL,NULL,PROCESS_CAT) AS PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#islem_tipi#) ORDER BY PROCESS_TYPE
</cfquery>
<cfquery name="GET_MONEY" datasource="#DSN2#">
	SELECT * FROM SETUP_MONEY
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_cheque_actions.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_cheque_actions" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_cheque_actions" method="post">
			<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="cheque_number" style="width:85px;" placeholder="#getLang(170,'Çek Numarası',50365)#" value="#attributes.cheque_number#" maxlength="50">
				</div>
				<div class="form-group">
					<cfinput type="text" name="keyword" style="width:100px;" placeholder="#getLang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="255">
				</div>
				<div class="form-group">
					<select name="oby" id="oby" style="width:85px;">
						<option value="1" <cfif isDefined('attributes.oby') and attributes.oby eq 1>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
						<option value="2" <cfif isDefined('attributes.oby') and attributes.oby eq 2>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
						<option value="3" <cfif isDefined('attributes.oby') and attributes.oby eq 3>selected</cfif>><cf_get_lang dictionary_id='29459.Artan No'></option>
						<option value="4" <cfif isDefined('attributes.oby') and attributes.oby eq 4>selected</cfif>><cf_get_lang dictionary_id='29458.Azalan No'></option>
					</select>
				</div>					
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-page_action_type">
							<label class="col col-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
							<div class="col col-12">
							<select name="page_action_type" id="page_action_type" style="width:150px;">
									<option value="" selected><cfoutput>#getLang(322,'Seçiniz',57734)#</cfoutput></option>
									<cfoutput query="get_process_cat" group="process_type">
										<option value="#process_type#-0" <cfif '#process_type#-0' is attributes.page_action_type>selected</cfif>>#get_process_name(process_type)#</option>										
										<cfoutput>
											<option value="#process_type#-#process_cat_id#" <cfif attributes.page_action_type is '#process_type#-#process_cat_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;#process_cat#</option>
										</cfoutput>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-company_id">
							<label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" id="company_id" name="company_id" <cfif len(attributes.company) and len(attributes.company_id)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
									<input type="hidden" id="consumer_id" name="consumer_id" <cfif len(attributes.company) and len(attributes.consumer_id)> value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>
									<input type="hidden" id="employee_id" name="employee_id" <cfif len(attributes.company) and len(attributes.employee_id)> value="<cfoutput>#attributes.employee_id#</cfoutput>"</cfif>>
									<input type="hidden" id="member_type" name="member_type" <cfif len(attributes.company) and len(attributes.member_type)> value="<cfoutput>#attributes.member_type#</cfoutput>"</cfif>>
									<input name="company" type="text" id="company"  style="width:100px;" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'0\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','','3','250','return_company()');" value="<cfif len(attributes.company) ><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=1,2,3,9&field_comp_id=list_cheque_actions.company_id&field_member_name=list_cheque_actions.company&field_name=list_cheque_actions.company&field_consumer=list_cheque_actions.consumer_id&field_emp_id=list_cheque_actions.employee_id&field_type=list_cheque_actions.member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list','popup_list_pars');" title="<cf_get_lang dictionary_id='57899.Kaydeden'>"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-account_id">
							<label class="col col-12"><cfoutput>#getLang(1652,'Banka Hesabı',29449)#</cfoutput></label>
							<div class="col col-12">
								<cf_wrkBankAccounts width='200' selected_value='#attributes.account_id#'>
							</div>
						</div>
						<div class="form-group" id="item-branch_id">
							<cfsavecontent variable="opt_value"><cfoutput>#getLang(322,'Seçiniz',57734)#</cfoutput></cfsavecontent>
							<label class="col col-12"><cf_get_lang dictionary_id='41.Şube'></label>
							<div class="col col-12">
								<cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='100' selected_value='#attributes.branch_id#' option_value='#opt_value#'>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-record_emp_id">
							<label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
									<input name="record_emp_name" type="text" id="record_emp_name" style="width:120px;" onFocus="AutoComplete_Create('record_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp_id','','3','135');" value="<cfif len(attributes.record_emp_name)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=list_cheque_actions.record_emp_name&field_emp_id=list_cheque_actions.record_emp_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list');return false"></span>
								</div>
							</div>
						</div>
						
						<div class="form-group" id="item-special_definition">
							<label class="col col-12"><cf_get_lang dictionary_id='58928.Tahsilat Tipi'></label>
							<div class="col col-12">
								<cf_wrk_special_definition width_info="130" list_filter_info="1" field_id="special_definition_id" selected_value='#attributes.special_definition_id#'>
							</div>
						</div>                    
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
						<div class="form-group" id="item-start_date">
							<label class="col col-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'>/<cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
							<div class="col col-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57655.Başlama Tarihi'></cfsavecontent>
									<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
									<span class="input-group-addon no-bg"></span>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
									<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-project_id">
							<label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
							<div class="col col-12">
								<cfif isdefined('attributes.project_head') and len(attributes.project_head)>
									<cfset project_id_ = #attributes.project_id#>
								<cfelse>
									<cfset project_id_ = ''>
								</cfif>
								<cf_wrkProject
								project_Id="#project_id_#"
								width="100"
								AgreementNo="1" Customer="2" Employee="3" Priority="4" Stage="5"
								boxwidth="540"
								boxheight="400">
							</div>
						</div>
					</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(2290,'Çek İşlemleri',30087)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<cfset colspan = 13>
			<thead>
				<tr> 
					<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='50206.Bordro No'></th>
					<th><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
					<th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
					<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
					<th><cf_get_lang dictionary_id='57520.Kasa'></th>
					<th><cf_get_lang dictionary_id='57652.Hesap'></th>
					<th><cf_get_lang dictionary_id='57861.Ort Vade'></th>
					<th><cf_get_lang dictionary_id='57673.Tutar'></th>
					<th><cf_get_lang dictionary_id ='57489.Para Br'></th>
					<th><cfoutput>#getLang(355,'İşlem Döviz Tutarı',49016)#</cfoutput></th>
					<th><cf_get_lang dictionary_id ='57489.Para Br'></th>
					<cfif len(session.ep.money2)>
						<cfset colspan = colspan+2>
						<th><cfoutput>#getLang(123,'2.Döviz',47385)# <cf_get_lang dictionary_id='57673.Tutar'></cfoutput></th>
						<th width="20"><cf_get_lang dictionary_id ='57489.Para Br'></th>
					</cfif>
					<!-- sil --><th class="text-center"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57474.Print'>" title="<cf_get_lang dictionary_id='57474.Print'>"></i></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfset sayfa_toplam = 0>
				<cfset sayfa_toplam2 = 0>
				<cfif attributes.page neq 1 and len(attributes.page_action_type)>
					<cfoutput query="get_cheque_actions" startrow="1" maxrows="#attributes.startrow-1#">
						<cfif len(PAYROLL_TOTAL_VALUE)>
							<cfset sayfa_toplam = sayfa_toplam +PAYROLL_TOTAL_VALUE>
						</cfif>
						<cfif len(PAYROLL_OTHER_MONEY_VALUE2)>
							<cfset sayfa_toplam2 = sayfa_toplam2 +PAYROLL_OTHER_MONEY_VALUE2>
						</cfif>
						<cfif not isDefined("other_money_total_#get_cheque_actions.PAYROLL_OTHER_MONEY#")>
							<cfset "other_money_total_#get_cheque_actions.PAYROLL_OTHER_MONEY#" = get_cheque_actions.PAYROLL_OTHER_MONEY_VALUE>
						<cfelse>
							<cfset "other_money_total_#get_cheque_actions.PAYROLL_OTHER_MONEY#" = evaluate("other_money_total_#get_cheque_actions.PAYROLL_OTHER_MONEY#") + get_cheque_actions.PAYROLL_OTHER_MONEY_VALUE>
						</cfif>
					</cfoutput>				  
				</cfif>
				<cfif get_cheque_actions.recordcount>
					<cfoutput query="get_cheque_actions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<tr>
							<td>#get_cheque_actions.currentrow#&nbsp;</td>
							<td>#get_cheque_actions.PAYROLL_NO#</td>
							<td>
								<cfset type=get_cheque_actions.PAYROLL_TYPE>
								<cfswitch expression="#type#">
									<cfcase value="90">
										<!--- <cfset act="Çek Giriş Bordrosu"> --->
										<cfset Xurl="form_add_payroll_entry&event=upd">
									</cfcase>
									<cfcase value="91">
										<!--- <cfset act="Çek Çıkış Bordrosu-Ciro"> --->
										<cfset Xurl="form_add_payroll_endorsement&event=upd">
									</cfcase>
									<cfcase value="92">
										<!--- <cfset act="Çek Çıkış Bordrosu-Tahsil"> --->
										<cfset Xurl="form_add_payroll_bank_revenue&event=upd">
									</cfcase>
									<cfcase value="93">
										<!--- <cfset act="Çek Çıkış Bordrosu-Banka"> --->
										<cfset Xurl="form_add_payroll_bank_guaranty&event=upd">
									</cfcase>
									<cfcase value="133">
										<!--- <cfset act="Çek Çıkış Bordrosu-Banka Teminat"> --->
										<cfset Xurl="form_add_payroll_bank_guaranty_tem&event=upd">
									</cfcase>
									<cfcase value="94">
										<!--- <cfset act="Çek İade Çıkış Bordrosu"> --->
										<cfset Xurl="form_add_payroll_endor_return&event=upd">
									</cfcase>
									<cfcase value="95">
										<!--- <cfset act="Çek İade Giriş Bordrosu"> --->
										<cfset Xurl="form_add_payroll_entry_return&event=upd">
									</cfcase>
									<cfcase value="105">
										<!--- <cfset act="Çek İade Giriş Bordrosu-Banka"> --->
										<cfset Xurl="form_add_payroll_bank_guaranty_return&event=upd">
									</cfcase>
									<cfcase value="134">
										<!--- <cfset act="Çek Transfer işlemi(çıkış)"> --->
										<cfset Xurl="form_add_cheque_transfer&event=upd">
									</cfcase>
									<cfcase value="135">
										<!--- <cfset act="Çek Transfer işlemi(giriş)"> --->
										<cfset Xurl="form_add_cheque_transfer&event=upd">
									</cfcase>
									<cfcase value="106">
										<!--- <cfset act=""> --->
										<cfset Xurl="">
									</cfcase>
									<cfdefaultcase>
										<!--- <cfset act=""> --->
										<cfset Xurl="">
									</cfdefaultcase>
								</cfswitch>
								<cfif (payroll_type eq 90 and process_cat eq 0)>
									<a class="tableyazi" href="javascript://" onClick="control_update(#payment_order_id#);">#get_process_name(type)#</a>	
								<cfelse>
									<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.#Xurl#&ID=#get_cheque_actions.ACTION_ID#" class="tableyazi">#get_process_name(type)#</a> 
								</cfif>
							</td>
							<td>#dateformat(get_cheque_actions.PAYROLL_REVENUE_DATE,dateformat_style)#&nbsp;</td>
							<td>
								#get_cheque_actions.FULLNAME#
							</td>
							<td><cfif len(PAYROLL_CASH_ID)>#get_cheque_actions.CASH_NAME#</cfif></td>
							<td><cfif len(PAYROLL_ACCOUNT_ID)>#get_cheque_actions.ACCOUNT_NAME#</cfif></td>
							<td>#dateformat(get_cheque_actions.PAYROLL_AVG_DUEDATE,dateformat_style)#</td>
							<td style="text-align:right;">#TLFormat(get_cheque_actions.PAYROLL_TOTAL_VALUE)#</td>
							<cfif len(attributes.page_action_type)>
								<cfif len(PAYROLL_TOTAL_VALUE)>
									<cfset sayfa_toplam = sayfa_toplam +PAYROLL_TOTAL_VALUE>
								</cfif>
							</cfif>
							<td>#get_cheque_actions.CURRENCY_ID#</td>
							<td style="text-align:right;">
								#TLFormat(get_cheque_actions.PAYROLL_OTHER_MONEY_VALUE)#
								<cfif not isDefined("other_money_total_#get_cheque_actions.PAYROLL_OTHER_MONEY#")>
									<cfset "other_money_total_#get_cheque_actions.PAYROLL_OTHER_MONEY#" = get_cheque_actions.PAYROLL_OTHER_MONEY_VALUE>
								<cfelse>
									<cfset "other_money_total_#get_cheque_actions.PAYROLL_OTHER_MONEY#" = evaluate("other_money_total_#get_cheque_actions.PAYROLL_OTHER_MONEY#") + get_cheque_actions.PAYROLL_OTHER_MONEY_VALUE>
								</cfif>						
							</td>
							<td>#get_cheque_actions.PAYROLL_OTHER_MONEY#</td>
							<cfif len(session.ep.money2)>
								<td style="text-align:right;">
									#TLFormat(get_cheque_actions.PAYROLL_OTHER_MONEY_VALUE2)#
									<cfif len(PAYROLL_OTHER_MONEY_VALUE2)>
										<cfset sayfa_toplam2 = sayfa_toplam2 +PAYROLL_OTHER_MONEY_VALUE2>
									</cfif>
								</td>
								<td>#session.ep.money2#</td>
							</cfif>
							<!-- sil -->
							<td>
								<cfset my_flag=0>
								<cfswitch expression="#type#">
									<cfcase value="91">
										<cfset my_flag=1>
										<cfset str_len="#request.self#?fuseaction=objects.popup_print_files&action_id=#action_id#&print_type=112">
									</cfcase>	
									<cfcase value="92">
										<cfset my_flag=1>
										<cfset str_len="#request.self#?fuseaction=objects.popup_print_files&action_id=#action_id#&print_type=112">
									</cfcase>			
									<cfcase value="93">
										<cfset my_flag=1>
										<cfset str_len="#request.self#?fuseaction=objects.popup_print_files&action_id=#action_id#&print_type=112">
									</cfcase>
									<cfcase value="133">
										<cfset my_flag=1>
										<cfset str_len="#request.self#?fuseaction=objects.popup_print_files&action_id=#action_id#&print_type=112">
									</cfcase>	
									<cfcase value="94">
										<cfset my_flag=1>
										<cfset str_len="#request.self#?fuseaction=objects.popup_print_files&action_id=#action_id#&print_type=112">
									</cfcase>	
									<cfcase value="95">
										<cfset my_flag=1>
										<cfset str_len="#request.self#?fuseaction=objects.popup_print_files&action_id=#action_id#&print_type=111">
									</cfcase>
									<cfcase value="90">
										<cfset my_flag=1>
										<cfset str_len="#request.self#?fuseaction=objects.popup_print_files&action_id=#action_id#&print_type=111">
									</cfcase>
									<cfcase value="134">
										<cfset my_flag=1>
										<cfset str_len="#request.self#?fuseaction=objects.popup_print_files&action_id=#action_id#&print_type=112">
									</cfcase>	
									<cfdefaultcase>
										<cfset my_flag=1>
										<cfset str_len="#request.self#?fuseaction=objects.popup_print_files&action_id=#action_id#&print_type=111">
									</cfdefaultcase>
								</cfswitch>
								<cfif my_flag eq 1>
									<a href="#str_len#" target="_blank"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57474.Print'>" title="<cf_get_lang dictionary_id='57474.Print'>"></i></a>				
								</cfif>
							</td>
							<!-- sil -->
						</tr>
					</cfoutput> 
					<cfif len(attributes.page_action_type)>
						<tr>
							<td colspan="8" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
							<td class="txtbold" style="text-align:right;"><cfoutput>#Tlformat(sayfa_toplam)#</cfoutput></td>
							<td class="txtbold"><cfoutput>#session.ep.money#</cfoutput></td>
							<td class="txtbold" style="text-align:right;">
								<cfoutput query="get_money">
									<cfif isDefined("other_money_total_#money#") and len(evaluate("other_money_total_#money#"))>
										#tlformat(evaluate("other_money_total_#money#"))#<br/>
									</cfif>
								</cfoutput>
							</td>
							<td class="txtbold">
								<cfoutput query="get_money">
									<cfif isDefined("other_money_total_#money#") and len(evaluate("other_money_total_#money#"))>
										#money#<br/>
									</cfif>
								</cfoutput>
							</td>
							<cfif len(session.ep.money2)>
								<td class="txtbold" style="text-align:right;"><cfoutput>#Tlformat(sayfa_toplam2)#</cfoutput></td>
								<td class="txtbold"><cfoutput>#session.ep.money2#</cfoutput></td>
							</cfif>
							<td>&nbsp;</td>
						</tr>
					</cfif>
				<cfelse>
					<tr>
						<td colspan="<cfoutput>#colspan#</cfoutput>"><cfif not isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id ='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_cheque_actions">
		<cfif isDefined('attributes.page_action_type') and len(attributes.page_action_type)>
			<cfset adres = '#adres#&page_action_type=#attributes.page_action_type#'>
		</cfif>
		<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
			<cfset adres = '#adres#&keyword=#attributes.keyword#'>
		</cfif>
		<cfif isDefined('attributes.cheque_number') and len(attributes.cheque_number)>
			<cfset adres = '#adres#&cheque_number=#attributes.cheque_number#'>
		</cfif>
		<cfif isDefined('attributes.start_date') and len(attributes.start_date)>
			<cfset adres = '#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
		</cfif>
		<cfif isDefined('attributes.finish_date') and len(attributes.finish_date)>
			<cfset adres = '#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
		</cfif>
		<cfif isDefined('attributes.oby') and len(attributes.oby)>
			<cfset adres = '#adres#&oby=#attributes.oby#'>
		</cfif>
		<cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
			<cfset adres = '#adres#&is_form_submitted=#attributes.is_form_submitted#'>
		</cfif>
		<cfif len(attributes.company_id) and len(attributes.company)>
			<cfset adres = '#adres#&company_id=#attributes.company_id#'>
		</cfif>
		<cfif len(attributes.consumer_id) and len(attributes.company)>
			<cfset adres = '#adres#&consumer_id=#attributes.consumer_id#'>
		</cfif>
		<cfif len(attributes.employee_id) and len(attributes.company)>
			<cfset adres = '#adres#&employee_id=#attributes.employee_id#'>
		</cfif>
		<cfif len(attributes.company)>
			<cfset adres = '#adres#&company=#attributes.company#'>
		</cfif>
		<cfif len(attributes.member_type)>
			<cfset adres = '#adres#&member_type=#attributes.member_type#'>
		</cfif>
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			<cfset adres = '#adres#&branch_id=#attributes.branch_id#'>
		</cfif>
		<cfif isDefined('attributes.account_id') and len(attributes.account_id)>
			<cfset adres = '#adres#&account_id=#attributes.account_id#'>
		</cfif>
		<cfif isDefined('attributes.special_definition_id') and len(attributes.special_definition_id)>
			<cfset adres = '#adres#&special_definition_id=#attributes.special_definition_id#'>
		</cfif>
		<cfif isDefined('attributes.record_emp_name') and len(attributes.record_emp_name)>
			<cfset adres = '#adres#&record_emp_id=#attributes.record_emp_id#'>
			<cfset adres = '#adres#&record_emp_name=#attributes.record_emp_name#'>
		</cfif>
		<cfif isDefined('attributes.project_id') and len(attributes.project_id)>
			<cfset adres = '#adres#&project_id=#attributes.project_id#'>
		</cfif>
		<cfif isDefined('attributes.project_head') and len(attributes.project_head)>
			<cfset adres = '#adres#&project_head=#attributes.project_head#'>
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#adres#">
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function control_update(act_id)
{
	var get_ord_number = wrk_safe_query('chq_get_ord_number','dsn3',0,act_id);
	alert('<cf_get_lang dictionary_id="50470.Bu İşlemi İlgili Olduğu"> ' + get_ord_number.ORDER_NUMBER +' <cf_get_lang dictionary_id="50471.Nolu Siparişin Ödeme Planından Güncelleyebilirsiniz">!');
	return false;
}	
function return_company()
{	
	if(document.getElementById('member_type').value=='employee')
	{	
		var emp_id=document.getElementById('employee_id').value;
		var GET_COMPANY=wrk_safe_query('chq_get_company','dsn',0,emp_id);
		document.getElementById('company_id').value=GET_COMPANY.COMP_ID;
	}
	else
		return false;
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
