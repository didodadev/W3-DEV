<cf_xml_page_edit fuseact="report.cheque_voucher_analyse">
<cfparam name="attributes.module_id_control" default="16">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.cash_id" default="">
<cfparam name="attributes.bloke_member" default="">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.account_id" default="">
<cfparam name="attributes.new_account_id" default="">
<cfparam name="attributes.employee_id_" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.consumer_id2" default="">
<cfparam name="attributes.company_id2" default="">
<cfparam name="attributes.company2" default="">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.lawyer_id" default="">
<cfparam name="attributes.lawyer_name" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.record_date1" default="">
<cfparam name="attributes.record_date2" default="">
<cfparam name="attributes.action_date1" default="">
<cfparam name="attributes.action_date2" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.is_first_cash" default="">
<cfparam name="attributes.sales_zones" default="">
<cfparam name="attributes.pos_code_text" default="">
<cfparam name="attributes.amount_value1" default="">
<cfparam name="attributes.amount_value2" default="">
<!--- Belge sahibi filtrelenmesi için eklendi. 20122701 ENV --->
<cfparam name="attributes.owner_company" default="">
<cfparam name="attributes.owner_company_id" default="">
<cfparam name="attributes.owner_consumer_id" default="">
<cfparam name="attributes.owner_employee_id" default="">
<cfparam name="attributes.owner_member_type" default="">
<cfparam name="attributes.self_cheque1" default="">
<cfparam name="attributes.self_cheque2" default="">
<cfparam name="attributes.is_branch_control" default="0"><!--- yetkiye göre getiriyor --->
<cfparam name="attributes.is_open_accounts" default="0"><!--- Banka açılışı yapılmamış hesapların gelmesi için eklendi--->
<cfparam name="attributes.money_type_control" default=""><!--- 1 ise sadece tl olanları 2 ise sadece dövizli banka hesaplarını getirir --->
<cfparam name="attributes.currency_id_info" default=""><!--- gönderilen para birimndeki hesapları getirmesi için--->
<cfparam name="attributes.account_type" default="0"><!--- hesap türünü belirler (0:tumu,1:kredili,2:ticari,3:vadeli) --->
<cfparam name="attributes.account_type" default="0"><!--- hesap türünü belirler (0:tumu,1:kredili,2:ticari,3:vadeli) --->
<cfparam name="attributes.is_system_money" default="0"><!--- 1 ise sadece sistem dövizi olan hesapları getirir --->
<cfparam name="attributes.control_status" default="1"><!--- sadece aktif hesaplar gelsin --->
<cfquery name="get_company_cat" datasource="#dsn#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>
<cfquery name="get_consumer_cat" datasource="#dsn#">
	SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY HIERARCHY
</cfquery>
<cfquery name="get_cashes" datasource="#dsn2#">
	SELECT 
		* 
	FROM 
		CASH 
	<cfif session.ep.isBranchAuthorization>
		WHERE 
			BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
	</cfif>
	ORDER BY	
		CASH_NAME
</cfquery>
<cfif session.ep.isBranchAuthorization>
	<cfset attributes.is_branch_control = 1>
</cfif>
<cfscript>
	CreateComponent = CreateObject("component","/../workdata/getAccounts");
	get_accounts = CreateComponent.getCompenentFunction(is_system_money:attributes.is_system_money,money_type_control:attributes.money_type_control,is_branch_control:attributes.is_branch_control,control_status:attributes.control_status,is_open_accounts:attributes.is_open_accounts,currency_id_info:attributes.currency_id_info,account_type:attributes.account_type);	
</cfscript>
<cfquery name="GET_SALES_ZONES" datasource="#DSN#">
	SELECT SZ_ID,SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
</cfquery>
<cfset cash_id_list = valuelist(get_cashes.cash_id,',')>
<cfset account_id_list = valuelist(get_accounts.account_id,',')>
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_cheque_analyse.cfm">
	<cfif attributes.report_type eq 6>
        <cfquery name="GET_MONEY" datasource="#DSN2#">
            SELECT * FROM SETUP_MONEY
        </cfquery>
        <cfset status_id_list = '1,2,5,10,11,12,13,14'>
        <cfset status_name_list= 'Portföyde,Bankada,Tahsil Edildi,Ciro Edildi,Karşılıksız,Ödenmedi,Ödendi,İptal,İade,Karşılıksız Portföyde,Kısmi Tahsil ,İcra,Teminatta,Transfer'>
        <cfoutput query="get_cheque_actions">
            <cfset "last_row_total_#status_id#"=0>
            <cfset "last_colm_total_#currency_id#_#status_id#"=0>
            <cfif type eq 0>
                <cfif isdefined("cash_total_amount_#act_type#_#currency_id#_#status_id#")>
                    <cfset "cash_total_amount_#act_type#_#currency_id#_#status_id#" = evaluate("cash_total_amount_#act_type#_#currency_id#_#status_id#") + AMOUNT_VALUE>
                <cfelse>
                    <cfset "cash_total_amount_#act_type#_#currency_id#_#status_id#" = AMOUNT_VALUE>
                </cfif>
            <cfelse>
                <cfif isdefined("bank_total_amount_#act_type#_#status_id#")>
                    <cfset "bank_total_amount_#act_type#_#currency_id#_#status_id#" = evaluate("bank_total_amount_#act_type#_#currency_id#_#status_id#") + AMOUNT_VALUE>
                <cfelse>
                    <cfset "bank_total_amount_#act_type#_#currency_id#_#status_id#" = AMOUNT_VALUE>
                </cfif>
            </cfif>
        </cfoutput>
    </cfif>	
<cfelse>
	<cfset get_cheque_voucher.recordcount = 0>
	<cfset status_id_list=''>
</cfif>
<cfform name="rapor" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='39643.Çek Senet Analiz Raporu'></cfsavecontent>
<cf_report_list_search title="#title#">
<cf_report_list_search_area>
		<div class="row">
			<div class="col col-12 col-xs-12">
				<div class="row formContent">
					<div class="row" type="row">
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
							<div class="col col-12 col-xs-12">
								<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined('attributes.consumer_id') and len(attributes.company)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
											<input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
											<input type="hidden" name="employee_id_" id="employee_id_" value="<cfif len(attributes.company)><cfoutput>#attributes.employee_id_#</cfoutput></cfif>">
											<input type="text" name="company" id="company" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID','company_id,consumer_id,employee_id_','','3','250');" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=rapor.company&field_comp_id=rapor.company_id&field_consumer=rapor.consumer_id&field_member_name=rapor.company<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>');"></span>
										</div>
									</div>									
								</div>
								<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57431.Çıkış"> <cf_get_lang dictionary_id="58061.Cari"></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="consumer_id2" id="consumer_id2" value="<cfif isdefined('attributes.consumer_id2') and len(attributes.company2)><cfoutput>#attributes.consumer_id2#</cfoutput></cfif>">
											<input type="hidden" name="company_id2" id="company_id2" value="<cfif len(attributes.company2)><cfoutput>#attributes.company_id2#</cfoutput></cfif>">
											<input type="text" name="company2" id="company2" value="<cfif len(attributes.company2)><cfoutput>#attributes.company2#</cfoutput></cfif>" onFocus="AutoComplete_Create('company2','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','','3','250');" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis"  onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=rapor.company2&field_comp_id=rapor.company_id2&field_consumer=rapor.consumer_id2&field_member_name=rapor.company2');"></span>
										</div>
									</div>									
								</div>
								<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='40335.Avukat '></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="lawyer_id" id="lawyer_id" value="<cfif isdefined('attributes.lawyer_id') and len(attributes.lawyer_name)><cfoutput>#attributes.lawyer_id#</cfoutput></cfif>">
											<input type="text" name="lawyer_name" id="lawyer_name" value="<cfif len(attributes.lawyer_name)><cfoutput>#attributes.lawyer_name#</cfoutput></cfif>">
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&&field_consumer=rapor.lawyer_id&field_member_name=rapor.lawyer_name&select_list=3<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>');"></span>
										</div>
									</div>									
								</div>
								<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='39203.Satış Temsilcisi'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="pos_code" id="pos_code" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
											<input type="text" name="pos_code_text" id="pos_code_text" onFocus="AutoComplete_Create('pos_code_text','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','pos_code','','3','120');" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#get_emp_info(attributes.pos_code,1,0)#</cfoutput></cfif>" tabindex="29">
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=rapor.pos_code&field_name=rapor.pos_code_text<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1');return false"></span>
										</div>
									</div>									
								</div>
								<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='58586.İşlem Yapan'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="employee_id" id="employee_id"  value="<cfif len(attributes.employee)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
											<input type="text" name="employee" id="employee" onFocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','125');"value="<cfif len(attributes.employee)><cfoutput>#attributes.employee#</cfoutput></cfif>" maxlength="255">
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=rapor.employee_id&field_name=rapor.employee<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1');"></span>
										</div>
									</div>									
								</div>
								<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="39596.Belge Sahibi"></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="owner_company_id" id="owner_company_id" <cfif len(attributes.owner_company) and len(attributes.owner_company_id)>value="<cfoutput>#attributes.owner_company_id#</cfoutput>"</cfif>>
											<input type="hidden" name="owner_consumer_id" id="owner_consumer_id" <cfif len(attributes.owner_company) and len(attributes.owner_consumer_id)>value="<cfoutput>#attributes.owner_consumer_id#</cfoutput>"</cfif>>
											<input type="hidden" name="owner_employee_id" id="owner_employee_id" <cfif len(attributes.owner_company) and len(attributes.owner_employee_id)>value="<cfoutput>#attributes.owner_employee_id#</cfoutput>"</cfif>>
											<input type="hidden" name="owner_member_type" id="owner_member_type" <cfif len(attributes.owner_company) and len(attributes.owner_member_type)>value="<cfoutput>#attributes.owner_member_type#</cfoutput>"</cfif>>
											<input name="owner_company" type="text" id="owner_company" onFocus="AutoComplete_Create('owner_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',0,0,0','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','owner_company_id,owner_consumer_id,owner_employee_id,owner_member_type','','3','250');" value="<cfif len(attributes.owner_company) ><cfoutput>#attributes.owner_company#</cfoutput></cfif>" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis"  onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=1,2,3,9&field_comp_id=rapor.owner_company_id&field_member_name=rapor.owner_company&field_name=rapor.owner_company&field_consumer=rapor.owner_consumer_id&field_emp_id=rapor.owner_employee_id&field_type=rapor.owner_member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>');"></span>
										</div>
									</div>									
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
									<div class="col col-12 col-xs-12">
										<select name="report_type" id="report_type" onChange="kontrol_report_type();">
											<option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
											<option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id='39257.Müşteri Bazında'></option>
											<option value="3" <cfif attributes.report_type eq 3>selected</cfif>><cf_get_lang dictionary_id='40335.Avukat '><cf_get_lang dictionary_id ='58601.Bazında'></option>
											<option value="4" <cfif attributes.report_type eq 4>selected</cfif>><cf_get_lang dictionary_id='57520.Kasa'><cf_get_lang dictionary_id ='58601.Bazında'></option>
											<option value="5" <cfif attributes.report_type eq 5>selected</cfif>><cf_get_lang dictionary_id="54938.Ay Bazında"></option>
											<option value="6" <cfif attributes.report_type eq 6>selected</cfif>><cf_get_lang dictionary_id="57520.Kasa"> <cf_get_lang dictionary_id="57989.ve"> <cf_get_lang dictionary_id="57521.Banka"> <cf_get_lang dictionary_id="58601.Bazında"></option>
										</select>	
									</div>
								</div>
							</div>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
							<div class="col col-12 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57659.Satış Bölgesi'></label>
									<div class="col col-12 col-xs-12">
										<select name="sales_zones" id="sales_zones">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfoutput query="get_sales_zones">
												<option value="#sz_id#" <cfif sz_id eq attributes.sales_zones> selected</cfif>>#sz_name#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57520.Kasa'></label>
									<div class="col col-12 col-xs-12">
										<select name="cash_id" id="cash_id">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfoutput query="get_cashes">
												<option value="#get_cashes.cash_id#" <cfif attributes.cash_id eq get_cashes.cash_id>selected</cfif>>#GET_CASHES.cash_name#</option>
											</cfoutput>
										</select>	
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29449.Banka Hesabı'></label>
									<div class="col col-12 col-xs-12">
										<cf_wrkBankAccounts width='200' selected_value='#attributes.account_id#' is_multiple="1" is_upd="1">
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57431.Çıkış"> <cf_get_lang dictionary_id="57521.Banka"></label>
									<div class="col col-12 col-xs-12">
										<cf_wrkBankAccounts width='200' fieldId='new_account_id' selected_value='#attributes.new_account_id#' is_multiple="1" is_upd="1">								
									</div>
								</div>	
								<div class="form-group">
									<label class="col col-12 col-xs-12" id="is_bloke_member1" <cfif attributes.report_type neq 2>style="display:none;"</cfif>><cf_get_lang dictionary_id ='39719.İcra'><cf_get_lang dictionary_id ='30111.Durumu'></label>
										<div class="col col-12 col-xs-12" id="is_bloke_member" <cfif attributes.report_type neq 2> style="display:none;"</cfif>>							
										<select name="bloke_member" id="bloke_member">
											<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
											<option value="1" <cfif attributes.bloke_member eq 1>selected</cfif>><cf_get_lang dictionary_id ='39644.İcra Takibi Olanlar'></option>
											<option value="2" <cfif attributes.bloke_member eq 2>selected</cfif>><cf_get_lang dictionary_id ='40336.İcra Takibi Olmayanlar'></option>
										</select>
									</div>
								</div>
							</div>				
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
							<div class="col col-12 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></label>
									<div class="col col-12 col-xs-12">
									<select name="member_cat_type" id="member_cat_type" multiple>
										<optgroup label="<cf_get_lang dictionary_id ='58039.Kurumsal Üye Kategorileri'>">
											<cfoutput query="get_company_cat">
											<option value="1-#COMPANYCAT_ID#" <cfif listfind(attributes.member_cat_type,'1-#COMPANYCAT_ID#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#COMPANYCAT#</option>
											</cfoutput>							
										</optgroup>
										<optgroup label="<cf_get_lang dictionary_id ='58040.Bireysel Üye Kategorileri'>">
											<cfoutput query="get_consumer_cat">
											<option value="2-#CONSCAT_ID#" <cfif listfind(attributes.member_cat_type,'2-#CONSCAT_ID#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#CONSCAT#</option>
											</cfoutput>						
										</optgroup>
									</select>			
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
									<div class="col col-12 col-xs-12">
											<select name="status" id="status" multiple>
												<option value="1" <cfif listfind(attributes.status,'1',',')>selected</cfif>><cf_get_lang dictionary_id='39648.Portföyde'></option>
												<option value="2" <cfif listfind(attributes.status,'2',',')>selected</cfif>><cf_get_lang dictionary_id='39649.Bankada'></option>
												<option value="13" <cfif listfind(attributes.status,'13',',')>selected</cfif>><cf_get_lang dictionary_id='40557.Teminatta'></option>
												<option value="3" <cfif listfind(attributes.status,'3',',')>selected</cfif>><cf_get_lang dictionary_id='39650.Tahsil Edildi'></option>
												<option value="4" <cfif listfind(attributes.status,'4',',')>selected</cfif>><cf_get_lang dictionary_id='39651.Ciro Edildi'></option>
												<option value="5" <cfif listfind(attributes.status,'5',',')>selected</cfif>><cf_get_lang dictionary_id='39482.Karşılıksız'></option>
												<option value="6" <cfif listfind(attributes.status,'6',',')>selected</cfif>><cf_get_lang dictionary_id='39139.Ödenmedi'></option>
												<option value="7" <cfif listfind(attributes.status,'7',',')>selected</cfif>><cf_get_lang dictionary_id='39136.Ödendi'></option>
												<option value="8" <cfif listfind(attributes.status,'8',',')>selected</cfif>><cf_get_lang dictionary_id='58506.İptal'></option>
												<option value="10" <cfif listfind(attributes.status,'10',',')>selected</cfif>><cf_get_lang dictionary_id='39482.Karşılıksız'>-<cf_get_lang dictionary_id='39648.Portföyde'></option>
												<option value="11" <cfif listfind(attributes.status,'11',',')>selected</cfif>><cf_get_lang dictionary_id='39652.Kısmi Tahsil'></option>
												<option value="12" <cfif listfind(attributes.status,'12',',')>selected</cfif>><cf_get_lang dictionary_id='39719.İcra'></option>
												<option value="14" <cfif listfind(attributes.status,'14',',')>selected</cfif>><cf_get_lang dictionary_id="58568.Transfer"></option>
											</select>
									</div>
								</div>
								<div class="form-group">
									<div class="col col-12 col-xs-12">
										<label><cf_get_lang dictionary_id='39646.İşlem Dövizi Göster'><input type="checkbox" name="is_other_money" id="is_other_money" <cfif isdefined("attributes.is_other_money")>checked<cfelseif attributes.report_type eq 6 >disabled</cfif>></label>
										<cfif len(session.ep.money2)>
										<label>2.<cf_get_lang dictionary_id='39647.Döviz Göster'> 
										<input type="checkbox" name="is_money2" id="is_money2" <cfif isdefined("attributes.is_money2")>checked<cfelseif attributes.report_type eq 5 or attributes.report_type eq 6 >disabled</cfif>>
											</label></cfif>
										<label><cf_get_lang dictionary_id='58007.Çek'><input type="checkbox" name="is_cheque" id="is_cheque" <cfif isdefined("attributes.is_cheque")>checked</cfif>></label>
										<label><cf_get_lang dictionary_id='58008.Senet'><input type="checkbox" name="is_voucher" id="is_voucher" <cfif isdefined("attributes.is_voucher")>checked</cfif>></label>
										<label><cf_get_lang dictionary_id="59210.Müşteri Çeki"><input type="checkbox" name="self_cheque2" id="self_cheque2" class="selfcheque" value="1" <cfif attributes.self_cheque2 eq 1>checked</cfif>></label>
										<label><cf_get_lang dictionary_id="57431.Çıkış"> <cf_get_lang dictionary_id="58061.Cari"> <cf_get_lang dictionary_id="58596.Göster"><input type="checkbox" name="show_cari" id="show_cari" <cfif isdefined("attributes.show_cari")>checked<cfelseif attributes.report_type eq 6>disabled</cfif>></label>
										<label><cf_get_lang dictionary_id="29945.Ödeme Sözü"><input type="checkbox" name="is_pay_term" id="is_pay_term" <cfif isdefined("attributes.is_pay_term")>checked</cfif>></label>
										<label><cf_get_lang dictionary_id="59211.Cari Hesap Çeki"><input type="checkbox" name="self_cheque1" id="self_cheque1" class="selfcheque" value="1" <cfif attributes.self_cheque1 eq 1>checked</cfif>></label>
										<label><cf_get_lang dictionary_id="39597.İlk Kasa Gelsin"><input type="checkbox" name="is_first_cash" id="is_first_cash" value="1" <cfif attributes.is_first_cash eq 1>checked</cfif>></label>
										<label><cf_get_lang dictionary_id='40341.Gecikmesi Olanlar'><input type="checkbox" name="is_interest_show" id="is_interest_show"<cfif isdefined("attributes.is_interest_show")>checked</cfif>></label>
										<label><input type="checkbox" name="is_open_acts" id="is_open_acts" <cfif isdefined("attributes.is_open_acts")>checked<cfelseif attributes.report_type eq 6>disabled</cfif>><cf_get_lang dictionary_id='40558.Sadece Açılıştan Gelen Çek/Senet Gelsin'></label>
										<span id="interest" valign="top" <cfif attributes.report_type eq 5 or attributes.report_type eq 6 or not isdefined("attributes.is_interest_show")>style="display:none"</cfif>>
											<label><cf_get_lang dictionary_id='40763.Gecikme Faizi Göster'><input type="checkbox" name="is_interest" id="is_interest" <cfif isdefined("attributes.is_interest")>checked </cfif>></label>	
										</span>            
										<label><cf_get_lang dictionary_id='39133.İşlem Tarihindeki Durumu Göster'><input type="checkbox" name="is_status_info" id="is_status_info" <cfif isdefined("attributes.is_status_info")>checked<cfelseif attributes.report_type eq 6>disabled</cfif>></label>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
							<div class="col col-12 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57881.Vade Tarihi'></label>
										<div class="col col-6">
											<div class="input-group">
													<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#">
													<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>			
											</div>
										</div>
										<div class="col col-6">
											<div class="input-group">
												<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#"  validate="#validate_style#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
											</div>
										</div>
								</div>						
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
									<div class="col col-6">
										<div class="input-group">
											<cfinput type="text" name="record_date1" value="#dateformat(attributes.record_date1,dateformat_style)#" validate="#validate_style#">
											<span class="input-group-addon"><cf_wrk_date_image date_field="record_date1"></span>
										</div>
									</div>
									<div class="col col-6">
										<div class="input-group">
											<cfinput type="text" name="record_date2" value="#dateformat(attributes.record_date2,dateformat_style)#"  validate="#validate_style#">
											<span class="input-group-addon"><cf_wrk_date_image date_field="record_date2"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
									<div class="col col-6">
										<div class="input-group">
												<cfinput type="text" name="action_date1" value="#dateformat(attributes.action_date1,dateformat_style)#" validate="#validate_style#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="action_date1"></span>
											</div>
										</div>
										<div class="col col-6">
											<div class="input-group">
												<cfinput type="text" name="action_date2" value="#dateformat(attributes.action_date2,dateformat_style)#"  validate="#validate_style#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="action_date2"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='40460.Tutar Aralığı'></label>
									<div class="col col-6">
										<input type="text" name="amount_value1" id="amount_value1" value="<cfoutput>#attributes.amount_value1#</cfoutput>" onKeyup="return(FormatCurrency(this,event));">
									</div>
									<div class="col col-6">
										<input type="text" name="amount_value2" id="amount_value2" value="<cfoutput>#attributes.amount_value2#</cfoutput>" onKeyup="return(FormatCurrency(this,event));">
									</div>								
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="row ReportContentBorder">
					<div class="ReportContentFooter">
						<label><cf_get_lang dictionary_id ='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>							
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1," message="#message#" maxlength="3">
						<cfelse>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#"  onKeyUp="isNumber(this)" maxlength="3">
						</cfif>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
						<input type="hidden" name="form_submitted" id="form_submitted" value="">					
						<cf_wrk_report_search_button search_function='kontrol_form()' insert_info='#message#' is_excel='1' button_type='1'>
					</div>
				</div>
			</div>
		</div>
</cf_report_list_search_area>
</cf_report_list_search>
</cfform>
	<cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
	<cfset filename = "cheque_voucher_analyse#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<cfset type_ = 1>
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows=get_cheque_voucher.recordcount>
	<cfelse>
		<cfset type_ = 0>
	</cfif>
<cfif isdefined("attributes.form_submitted")>
<cf_report_list>
	<cfquery name="get_money" datasource="#dsn2#">
		SELECT * FROM SETUP_MONEY
	</cfquery>
	<cfset sistem_toplam = 0>
	<cfset gecikme_toplam = 0>
	<cfset icra_toplam = 0>
	<cfset vade_toplam = 0>
	<cfset sistem2_toplam = 0>
	<cfoutput query="get_money">
		<cfset 'toplam_#money#' = 0>
	</cfoutput>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.totalrecords" default="#get_cheque_voucher.recordcount#">
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfif attributes.report_type neq 5 and attributes.report_type neq 6>
		<thead>
		<tr>
			<th><cf_get_lang dictionary_id='57487.No'></th>
			<cfif attributes.report_type eq 1>
				<cfif isdefined("attributes.is_cheque") and (isdefined("attributes.is_voucher") or isdefined("attributes.is_pay_term"))>
					<th><cf_get_lang dictionary_id='57468.Belge'></th>
				</cfif>
				<th><cf_get_lang dictionary_id='57880.Belge No'></th>
				<th><cf_get_lang_main dictionary_id='50202.Bordro No'></th>
				<th><cf_get_lang dictionary_id='39653.Satış No'></th>
				<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
				<th><cf_get_lang dictionary_id='58178.Hesap No'></th>
				<th><cf_get_lang dictionary_id='57640.Vade'></th>
				<cfif (isdefined("attributes.is_cheque") or isdefined("attributes.is_voucher") or isdefined("attributes.is_pay_term"))><th><cf_get_lang dictionary_id="57879.Islem Tarihi"></th></cfif>
				<cfif isdefined("attributes.is_interest_show")><th><cf_get_lang dictionary_id='40767.Gecikme Farkı (Gün)'></th></cfif>
				<th><cf_get_lang dictionary_id='57482.Aşama'></th>
				<th><cf_get_lang dictionary_id='57416.Proje'></th>
				<th><cf_get_lang dictionary_id='57558.Üye No'></th>
				<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
				<cfif isdefined("attributes.show_cari")><th><cf_get_lang dictionary_id="57431.Çıkış"> <cf_get_lang dictionary_id='57558.Üye No'></th><th><cf_get_lang dictionary_id="57431.Çıkış"> <cf_get_lang dictionary_id="58061.Cari"></th></cfif>
				<th><cf_get_lang dictionary_id='58180.Borçlu'></th>
				<th><cf_get_lang dictionary_id='57520.Kasa'></th>
				<th><cf_get_lang dictionary_id='57521.Banka'>/<cf_get_lang dictionary_id='57453.Şube'></th>
				<th><cf_get_lang dictionary_id='29449.Banka Hesabı'></th>
				<th class="text-right"><cf_get_lang dictionary_id='57673.Tutar'></th>
				<th align="center" ><cf_get_lang dictionary_id='58474.Birim'></th>
				<cfif isdefined("attributes.is_other_money")>
					<th class="text-right"><cf_get_lang dictionary_id='39655.İşlem Dövizi Tutar'></th>
					<th align="center" ><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
				<cfif isdefined("attributes.is_money2")>
					<th class="text-right">2.<cf_get_lang dictionary_id='39656.Döviz Tutar'></th>
					<th align="center" ><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
				<cfif isdefined("attributes.is_interest") and isdefined("attributes.is_interest_show")>
					<th class="text-right"><cf_get_lang dictionary_id='39657.Gecikme'> <cf_get_lang dictionary_id='57673.Tutar'></th>
					<th align="center"><cf_get_lang dictionary_id='58474.Birim'></th>
					<th class="text-right"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='57673.Tutar'></th>
					<th align="center"><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
			<cfelseif attributes.report_type eq 2>
				<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
				<th><cf_get_lang dictionary_id='57558.Üye No'></th>
				<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
				<th><cf_get_lang dictionary_id ='39811.Cep Tel No'></th>
				<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
					<th><cf_get_lang dictionary_id='39658.İcra Dosya No'></th>
					<th><cf_get_lang dictionary_id='40335.Avukat '></th>
				</cfif>
				<th class="text-right"><cf_get_lang dictionary_id='57673.Tutar'></th>
				<th align="center"><cf_get_lang dictionary_id='58474.Birim'></th>
				<cfif isdefined("attributes.is_other_money")>
					<th class="text-right"><cf_get_lang dictionary_id='39655.İşlem Dövizi Tutar'></th>
					<th align="center"><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
				<cfif isdefined("attributes.is_money2")>
					<th class="text-right">2.<cf_get_lang dictionary_id='39656.Döviz Tutar'></th>
					<th align="center"><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
				<cfif isdefined("attributes.is_interest") and isdefined("attributes.is_interest_show")>
					<th class="text-right"><cf_get_lang dictionary_id='39657.Gecikme'> <cf_get_lang dictionary_id='57673.Tutar'></th>
					<th align="center"><cf_get_lang dictionary_id='58474.Birim'></th>
					<th class="text-right"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='57673.Tutar'></th>
					<th align="center"><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
				<th class="text-right"><cf_get_lang dictionary_id='57861.Ortalama Vade'></th>
			<cfelseif attributes.report_type eq 3>
				<th><cf_get_lang dictionary_id ='40335.Avukat '></th>
				<th class="text-right"><cf_get_lang dictionary_id='57673.Tutar'></th>
				<th align="center"><cf_get_lang dictionary_id='58474.Birim'></th>
				<cfif isdefined("attributes.is_other_money")>
					<th class="text-right"><cf_get_lang dictionary_id='39655.İşlem Dövizi Tutar'></th>
					<th align="center"><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
				<cfif isdefined("attributes.is_money2")>
					<th class="text-right">2.<cf_get_lang dictionary_id='39656.Döviz Tutar'></th>
					<th align="center"><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
				<cfif isdefined("attributes.is_interest") and isdefined("attributes.is_interest_show")>
					<th class="text-right"><cf_get_lang dictionary_id='39657.Gecikme'> <cf_get_lang dictionary_id='57673.Tutar'></th>
					<th align="center"><cf_get_lang dictionary_id='58474.Birim'></th>
					<th class="text-right"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='57673.Tutar'></th>
					<th align="center"><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
				<th class="text-right"><cf_get_lang dictionary_id='57861.Ortalama Vade'></th>
			<cfelseif attributes.report_type eq 4>
				<th><cf_get_lang dictionary_id='57520.Kasa'></th>
				<th nowrap class="text-right"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='57673.Tutar'></th>
				<th align="center" ><cf_get_lang dictionary_id='57636.Birim'></th>
				<cfif isdefined("attributes.is_other_money")>
					<th nowrap class="text-right"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='39655.İşlem Dövizi Tutar'></th>
					<th align="center" ><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
				<cfif isdefined("attributes.is_money2")>
					<th nowrap class="text-right"><cf_get_lang dictionary_id='57492.Toplam'> 2.<cf_get_lang dictionary_id='39656.Döviz Tutar'></th>
					<th align="center"><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
				<th nowrap="nowrap"><cf_get_lang dictionary_id='57861.Ortalama Vade'></th>
				<cfif isdefined("attributes.is_interest") and isdefined("attributes.is_interest_show")>
					<th class="color-row" width="1"></th>
					<th nowrap class="text-right"><cf_get_lang dictionary_id='39657.Gecikme'> <cf_get_lang dictionary_id='57673.Tutar'></th>
					<th align="center"><cf_get_lang dictionary_id='58474.Birim'></th>
					<th nowrap class="text-right"><cf_get_lang dictionary_id='39657.Gecikme'> <cf_get_lang dictionary_id='57861.Ortalama Vade'></th>
					<th width="40" nowrap="nowrap" class="text-right">%</th>
				</cfif>
				<th class="color-row" width="1"></th>
				<th class="text-right"><cf_get_lang dictionary_id ='40337.İcralık Müşteri'> <cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='57673.Tutar'></th>
				<th align="center" ><cf_get_lang dictionary_id='58474.Birim'></th>
				<th class="text-right"><cf_get_lang dictionary_id ='40337.İcralık Müşteri'><cf_get_lang dictionary_id='57861.Ortalama Vade'></th>
				<th class="color-row" width="1"></th>
				<th class="text-right"><cf_get_lang dictionary_id ='40338.Vadesi Gelmeyen '><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='57673.Tutar'></th>
				<th align="center" ><cf_get_lang dictionary_id='58474.Birim'></th>
				<th class="text-right"><cf_get_lang dictionary_id ='40338.Vadesi Gelmeyen '><cf_get_lang dictionary_id='57861.Ortalama Vade'></th>
			</cfif>
		</tr>
		</thead>
	<cfelseif attributes.report_type eq 6>
		<thead>
		<tr>
			<th width="130"></th>
			<cfloop list="#status_id_list#" delimiters="," index="sta_indx">
				<th width="100"><cfoutput>#listgetat(status_name_list,sta_indx)#</cfoutput></th>
			</cfloop>
			<th width="100"><cf_get_lang dictionary_id="57492.Toplam"></th>
		</tr>
		</thead>
		<cfif get_cheque_voucher.recordcount>
			<cfset toplam_row_=0>
			<cfset list_len =listlen(status_id_list,',')>
			<tbody>
			<cfoutput query="get_cheque_voucher" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td width="130" class="txtbold" nowrap="nowrap">#ACT_CASH_NAME#</td>
					<cfset toplam_=0>
					<cfloop list="#status_id_list#" delimiters="," index="sta_indx">
					<cfset "total_row_#sta_indx#" = 0>
						<td format="numeric" class="text-right">
							<cfif get_cheque_voucher.type eq 0>
								<cfif isdefined("cash_total_amount_#get_cheque_voucher.act_type#_#currency_id#_#sta_indx#") and not listfind('2,13',sta_indx)>
									#TLFormat(evaluate("cash_total_amount_#get_cheque_voucher.act_type#_#currency_id#_#sta_indx#"))# #currency_id#
									<cfset toplam_= toplam_+ evaluate("cash_total_amount_#get_cheque_voucher.act_type#_#currency_id#_#sta_indx#")>
									<cfset "last_colm_total_#currency_id#_#sta_indx#" = evaluate("last_colm_total_#currency_id#_#sta_indx#") + evaluate("cash_total_amount_#get_cheque_voucher.act_type#_#currency_id#_#sta_indx#")>
									<cfset "last_row_total_#sta_indx#" = evaluate("last_row_total_#sta_indx#") + evaluate("cash_total_amount_#get_cheque_voucher.act_type#_#currency_id#_#sta_indx#")>										
								<cfelse>
									#TLFormat(0)#
								</cfif>
							<cfelse>
								<cfif isdefined("bank_total_amount_#get_cheque_voucher.act_type#_#currency_id#_#sta_indx#")>
									#TLFormat(evaluate("bank_total_amount_#get_cheque_voucher.act_type#_#currency_id#_#sta_indx#"))# #currency_id#
									<cfset toplam_= toplam_+ evaluate("bank_total_amount_#get_cheque_voucher.act_type#_#currency_id#_#sta_indx#")>
									<cfset "last_colm_total_#currency_id#_#sta_indx#" = evaluate("last_colm_total_#currency_id#_#sta_indx#") + evaluate("bank_total_amount_#get_cheque_voucher.act_type#_#currency_id#_#sta_indx#")>
									<cfset "last_row_total_#sta_indx#" =evaluate("last_row_total_#sta_indx#") + evaluate("bank_total_amount_#get_cheque_voucher.act_type#_#currency_id#_#sta_indx#")>										
								<cfelse>
									#TLFormat(0)#
								</cfif>			
							</cfif>
						</td>
						<cfif isdefined("last_row_total_#sta_indx#")>
							<cfset "total_row_#sta_indx#"=evaluate("total_row_#sta_indx#")+evaluate("last_row_total_#sta_indx#")>
						</cfif>
					</cfloop>
					<td class="text-right">#TLFormat(toplam_)# #currency_id#</td>	
					<cfset toplam_row_=toplam_row_+toplam_>
				</tr>
			</cfoutput>
			</tbody>
			<tfoot>
			<tr>
				<td class="txtbold" class="text-right"><cf_get_lang dictionary_id="57492.Toplam"></td>
				<cfoutput>
					<cfloop list="#status_id_list#" delimiters="," index="sta_indx">
						<td class="txtbold" class="text-right">
						<cfloop query="GET_MONEY">
							<cfif isdefined("last_colm_total_#GET_MONEY.money#_#sta_indx#")>
								#TLFormat(evaluate("last_colm_total_#GET_MONEY.money#_#sta_indx#"))# #GET_MONEY.money# <br/>
							</cfif>
						</cfloop>
						</td>
					</cfloop>
					<td class="txtbold" class="text-right">#TLFormat(toplam_row_)# #get_cheque_voucher.currency_id# </td>
				</cfoutput>
			</tr>
			</tfoot>
		
		</cfif>		
	<cfelseif attributes.report_type eq 5 and attributes.report_type neq 6>
		<cfoutput query="get_cheque_voucher">
			<cfif isdefined("attributes.is_other_money")>
				<cfif year_due lt session.ep.period_year>
					<cfif isdefined("old_value_#status#_#other_money#")>
						<cfset "old_value_#status#_#other_money#" = evaluate("old_value_#status#_#other_money#")+tutar>
					<cfelse>
						<cfset "old_value_#status#_#other_money#" = tutar>
					</cfif>
				<cfelseif year_due gt session.ep.period_year>
					<cfif isdefined("new_value_#status#_#other_money#")>
						<cfset "new_value_#status#_#other_money#" = evaluate("new_value_#status#_#other_money#")+tutar>
					<cfelse>
						<cfset "new_value_#status#_#other_money#" = tutar>
					</cfif>
				<cfelse>
					<cfif isdefined("value_#status#_#other_money#_#month_due#")>
						<cfset "value_#status#_#other_money#_#month_due#" = evaluate("value_#status#_#other_money#_#month_due#")+tutar>
					<cfelse>
						<cfset "value_#status#_#other_money#_#month_due#" = tutar>
					</cfif>
				</cfif>
			<cfelse>
				<cfif year_due lt session.ep.period_year>
					<cfif isdefined("old_value_#status#")>
						<cfset "old_value_#status#" = evaluate("old_value_#status#")+tutar>
					<cfelse>
						<cfset "old_value_#status#" = tutar>
					</cfif>
				<cfelseif year_due gt session.ep.period_year>
					<cfif isdefined("new_value_#status#")>
						<cfset "new_value_#status#" = evaluate("new_value_#status#")+tutar>
					<cfelse>
						<cfset "new_value_#status#" = tutar>
					</cfif>
				<cfelse>
					<cfif isdefined("value_#status#_#month_due#")>
						<cfset "value_#status#_#month_due#" = evaluate("value_#status#_#month_due#")+tutar>
					<cfelse>
						<cfset "value_#status#_#month_due#" = tutar>
					</cfif>
				</cfif>
			</cfif>
		</cfoutput>
		<thead>
		<tr>
			<th></th>
			<th><cf_get_lang dictionary_id="39539.Önceki Yıllar"></th>
			<th><cf_get_lang dictionary_id="57592.Ocak"></th>
			<th><cf_get_lang dictionary_id="57593.Şubat"></th>
			<th><cf_get_lang dictionary_id="57594.Mart"></th>
			<th><cf_get_lang dictionary_id="57595.Nisan"></th>
			<th><cf_get_lang dictionary_id="57596.Mayıs"></th>
			<th><cf_get_lang dictionary_id="57597.Haziran"></th>
			<th><cf_get_lang dictionary_id="57598.Temmuz"></th>
			<th><cf_get_lang dictionary_id="57599.Ağustos"></th>
			<th><cf_get_lang dictionary_id="57600.Eylül"></th>
			<th><cf_get_lang dictionary_id="57601.Ekim"></th>
			<th><cf_get_lang dictionary_id="57602.Kasım"></th>
			<th><cf_get_lang dictionary_id="57603.Aralık"></th>
			<th><cf_get_lang dictionary_id="39527.Sonraki Yıllar"></th>
		</tr>
		</thead>
		<cfif isdefined("attributes.is_other_money")>
			<cfoutput query="get_money">
				<cfset "old_tutar_#money#" = 0>
				<cfset "new_tutar_#money#" = 0>
			</cfoutput>
		<cfelse>
			<cfset old_tutar = 0>
			<cfset new_tutar = 0>
		</cfif>
		<cfif isdefined("attributes.is_other_money")>
			<cfloop from="1" to="12" index="jj">
				<cfoutput query="get_money">
					<cfset "toplam_tutar_#jj#_#money#" = 0>
				</cfoutput>
			</cfloop>
		<cfelse>
			<cfloop from="1" to="12" index="jj">
				<cfset "toplam_tutar_#jj#" = 0>
			</cfloop>
		</cfif>
		<cfoutput>
			<cfif len(attributes.status)>
				<cfset STATUS_LIST = "#status#">
			<cfelse>
				<cfset STATUS_LIST = "1,2,3,4,5,6,7,8,9,10,11,12,13,14">
			</cfif>
			<cfset new_status_list = ''>
			<cfif isdefined("attributes.is_other_money")>
				<cfloop from="1" to="#listlen(status_list)#" index="new_indx">
					<cfloop query="get_money">
						<cfset new_value = "#listgetat(status_list,new_indx)#_#get_money.money#">
						<cfset new_status_list = listappend(new_status_list,new_value)>
					</cfloop>
				</cfloop>
			<cfelse>
				<cfset new_status_list = status_list>
			</cfif>
			<cfloop list="#new_status_list#" index="status_indx">
				<cfif isdefined("old_value_#status_indx#")>
					<cfset old_value = evaluate("old_value_#status_indx#")>
				<cfelse>
					<cfset old_value = 0>
				</cfif>
				<cfif isdefined("new_value_#status_indx#")>
					<cfset new_value = evaluate("new_value_#status_indx#")>
				<cfelse>
					<cfset new_value = 0>
				</cfif>
				<cfif isdefined("attributes.is_other_money")>
					<cfset "old_tutar_#listlast(status_indx,'_')#" = evaluate("old_tutar_#listlast(status_indx,'_')#") + old_value>
					<cfset "new_tutar_#listlast(status_indx,'_')#" = evaluate("new_tutar_#listlast(status_indx,'_')#") + new_value>
				<cfelse>
					<cfset old_tutar = old_tutar + old_value>
					<cfset new_tutar = new_tutar + new_value>
				</cfif>
				<tbody>
				<tr>
					<td nowrap class="txtbold">
						<cfif listlen(status_indx,'_') gt 1>
							<cfset status = listfirst(status_indx,'_')>
							<cfswitch expression="#status#">
								<cfcase value="1"><cf_get_lang dictionary_id='39648.Portföyde'></cfcase>
								<cfcase value="2"><cf_get_lang dictionary_id='39649.Bankada'></cfcase>
								<cfcase value="3"><cf_get_lang dictionary_id='39650.Tahsil Edildi'></cfcase>
								<cfcase value="4"><cf_get_lang dictionary_id='39651.Ciro Edildi'></cfcase>
								<cfcase value="5"><cf_get_lang dictionary_id='39482.Karşılıksız'></cfcase>
								<cfcase value="6"><cf_get_lang dictionary_id='39139.Ödenmedi'></cfcase>
								<cfcase value="7"><cf_get_lang dictionary_id='39136.Ödendi'></cfcase>
								<cfcase value="8"><cf_get_lang dictionary_id='58506.İptal'></cfcase>
								<cfcase value="9"><cf_get_lang dictionary_id='29418.İade'></cfcase>
								<cfcase value="10"><cf_get_lang dictionary_id='39482.Karşılıksız'>-<cf_get_lang dictionary_id='39648.Portföyde'></cfcase>
								<cfcase value="11"><cf_get_lang dictionary_id='39652.Kısmi Tahsil'></cfcase>
								<cfcase value="12"><cf_get_lang dictionary_id='39719.İcra'></cfcase>
								<cfcase value="13"><cf_get_lang dictionary_id='40557.Teminatta'></cfcase>
								<cfcase value="14"><cf_get_lang dictionary_id="58568.Transfer"></cfcase>
							</cfswitch>
							#listlast(status_indx,'_')#
						<cfelse>
							<cfset status = status_indx>
							<cfswitch expression="#status#">
								<cfcase value="1"><cf_get_lang dictionary_id='39648.Portföyde'></cfcase>
								<cfcase value="2"><cf_get_lang dictionary_id='39649.Bankada'></cfcase>
								<cfcase value="3"><cf_get_lang dictionary_id='39650.Tahsil Edildi'></cfcase>
								<cfcase value="4"><cf_get_lang dictionary_id='39651.Ciro Edildi'></cfcase>
								<cfcase value="5"><cf_get_lang dictionary_id='39482.Karşılıksız'></cfcase>
								<cfcase value="6"><cf_get_lang dictionary_id='39139.Ödenmedi'></cfcase>
								<cfcase value="7"><cf_get_lang dictionary_id='39136.Ödendi'></cfcase>
								<cfcase value="8"><cf_get_lang dictionary_id='58506.İptal'></cfcase>
								<cfcase value="9"><cf_get_lang dictionary_id='29418.İade'></cfcase>
								<cfcase value="10"><cf_get_lang dictionary_id='39482.Karşılıksız'>-<cf_get_lang dictionary_id='39648.Portföyde'></cfcase>
								<cfcase value="11"><cf_get_lang dictionary_id='39652.Kısmi Tahsil'></cfcase>
								<cfcase value="12"><cf_get_lang dictionary_id='39719.İcra'></cfcase>
								<cfcase value="13"><cf_get_lang dictionary_id='40557.Teminatta'></cfcase>
								<cfcase value="14"><cf_get_lang dictionary_id="58568.Transfer"></cfcase>
							</cfswitch>
						</cfif>
					</td>
					<td format="numeric" class="text-right">#tlformat(old_value)#</td>
					<cfloop from="1" to="12" index="i">
						<cfif isdefined("value_#status_indx#_#i#") and len(evaluate("value_#status_indx#_#i#"))>
							<cfset value = evaluate("value_#status_indx#_#i#")>
						<cfelse>
							<cfset value = 0>
						</cfif>
						<td format="numeric" class="text-right">#tlformat(value)#</td>
						<cfif isdefined("attributes.is_other_money")>
							<cfset "toplam_tutar_#i#_#listlast(status_indx,'_')#" = evaluate("toplam_tutar_#i#_#listlast(status_indx,'_')#") + value>
						<cfelse>
							<cfset "toplam_tutar_#i#" = evaluate("toplam_tutar_#i#") + value>
						</cfif>
					</cfloop>
					<td format="numeric" class="text-right">#tlformat(new_value)#</td>
				</tr>
				</tbody>
			</cfloop>
		</cfoutput>
		<tfoot>
		<tr>
			<td nowrap class="txtbold" class="text-right"><cf_get_lang dictionary_id="57492.Toplam"></td>
			<cfif isdefined("attributes.is_other_money")>
				<td nowrap class="txtbold" class="text-right">
					<cfoutput query="get_money">
						<cfif evaluate("old_tutar_#money#") gt 0>
							#tlformat(evaluate("old_tutar_#money#"))# #money#<br/>
						</cfif>
					</cfoutput>
				</td>
				<cfloop from="1" to="12" index="i">
					<td nowrap class="txtbold" class="text-right">
						<cfoutput query="get_money">
							<cfif evaluate("toplam_tutar_#i#_#money#") gt 0>
								#tlformat(evaluate("toplam_tutar_#i#_#money#"))# #money#<br/>
							</cfif>
						</cfoutput>
					</td>
				</cfloop>
				<td nowrap class="txtbold" class="text-right">
					<cfoutput query="get_money">
						<cfif evaluate("new_tutar_#money#") gt 0>
							#tlformat(evaluate("new_tutar_#money#"))# #money#<br/>
						</cfif>
					</cfoutput>
				</td>
			<cfelse>
				<td format="numeric" nowrap class="txtbold" class="text-right"><cfoutput>#tlformat(old_tutar)#</cfoutput></td>
				<cfloop from="1" to="12" index="i">
					<td format="numeric" nowrap class="txtbold" class="text-right"><cfoutput>#tlformat(evaluate("toplam_tutar_#i#"))#</cfoutput></td>
				</cfloop>
				<td format="numeric" nowrap class="txtbold" class="text-right"><cfoutput>#tlformat(new_tutar)#</cfoutput></td>
			</cfif>
		</tr>
		</tfoot>
	</cfif>
	<cfif get_cheque_voucher.recordcount and attributes.report_type neq 6>
		<cfset total_cheque_value_all = 0>
		<cfset total_cheque_value = 0>
		<cfif attributes.report_type eq 1>
			<cfset order_id_list = ''>
			<cfset cheque_id_list = ''>
			<cfset voucher_id_list = ''>
			<cfset company_id_list = ''>
			<cfoutput query="get_cheque_voucher" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(order_id) and not listfind(order_id_list,order_id)>
					<cfset order_id_list=listappend(order_id_list,order_id)>
				</cfif>
				<cfif type eq 0>
					<cfset cheque_id_list = listappend(cheque_id_list,islem_id)>
				<cfelseif type eq 1>
					<cfset voucher_id_list = listappend(voucher_id_list,islem_id)>
				</cfif>
				<cfif len(new_company_id) and not listfind(company_id_list,new_company_id)>
					<cfset company_id_list=listappend(company_id_list,new_company_id)>
				</cfif>
			</cfoutput>
			<cfif len(order_id_list)>
				<cfset order_id_list=listsort(order_id_list,"numeric","ASC",",")>
				<cfquery name="get_orders" datasource="#dsn3#">
					SELECT ORDER_NUMBER,ORDER_ID FROM ORDERS WHERE ORDER_ID IN (#order_id_list#) ORDER BY ORDER_ID
				</cfquery>
				<cfset order_id_list = listsort(listdeleteduplicates(valuelist(get_orders.ORDER_ID,',')),'numeric','ASC',',')>
			</cfif>
			<cfset pay_id_list = ''>
			<cfoutput query="get_cheque_voucher" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(paymethod_id) and not listfind(pay_id_list,paymethod_id)>
					<cfset pay_id_list=listappend(pay_id_list,paymethod_id)>
				</cfif>
			</cfoutput>
			<cfif len(pay_id_list)>
				<cfset pay_id_list=listsort(pay_id_list,"numeric","ASC",",")>
				<cfquery name="get_paymethods" datasource="#dsn#">
					SELECT DELAY_INTEREST_DAY,DELAY_INTEREST_RATE,PAYMETHOD_ID FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID IN (#pay_id_list#) ORDER BY PAYMETHOD_ID
				</cfquery>
			</cfif>
			<cfif len(company_id_list)>
				<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
				<cfquery name="get_cheque_history" datasource="#dsn#">
					SELECT COMPANY_ID, NICKNAME, FULLNAME,MEMBER_CODE FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
				</cfquery>
			</cfif>
		<cfelseif attributes.report_type eq 2>
			<cfset consumer_id_list = ''>
			<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
				<cfoutput query="get_cheque_voucher" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(law_adwocate) and not listfind(consumer_id_list,law_adwocate)>
						<cfset consumer_id_list=listappend(consumer_id_list,law_adwocate)>
					</cfif>
				</cfoutput>
				<cfif len(consumer_id_list)>
					<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
					<cfquery name="get_consumer" datasource="#dsn#">
						SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
					</cfquery>
				</cfif>
			</cfif>
		<cfelseif attributes.report_type eq 3>
			<cfset consumer_id_list = ''>
			<cfoutput query="get_cheque_voucher" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(law_adwocate) and not listfind(consumer_id_list,law_adwocate)>
					<cfset consumer_id_list=listappend(consumer_id_list,law_adwocate)>
				</cfif>
			</cfoutput>
			<cfif len(consumer_id_list)>
				<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
				<cfquery name="get_consumer" datasource="#dsn#">
					SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
				</cfquery>
			</cfif>
		</cfif>
		<cfif attributes.page neq 1>
			<cfif attributes.report_type eq 1>
				<cfoutput query="get_cheque_voucher" startrow="1" maxrows="#attributes.startrow-1#">
					<cfif len(other_money_value)>
						<cfset sistem_toplam = sistem_toplam + other_money_value>
					</cfif>
					<cfif isdefined("attributes.is_money2") and len(other_money_value2)>
						<cfset sistem2_toplam = sistem2_toplam + other_money_value2>
					</cfif>
					<cfif isdefined("attributes.is_other_money") and len(other_act_value)>
						<cfset 'toplam_#other_money#' = evaluate('toplam_#other_money#') +other_act_value>
					</cfif>
					<cfset due_day = DateDiff("d",due_date,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
					<cfif len(due_day) and len(other_money_value)>
						<cfset total_cheque_value_all = total_cheque_value_all + (other_money_value*due_day)>
						<cfset total_cheque_value = total_cheque_value + other_money_value>
					</cfif>
					<cfif isdefined("attributes.is_interest") and isdefined("attributes.is_interest_show")>
						<cfset gun_farki = DateDiff("d",due_date,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
						<cfif status eq 3>
							<cfset gecikme_tutar = 0>
						<cfelseif type eq 0>
							<cfset gecikme_tutar = (x_cheque_interest/100 *other_money_value/30) * gun_farki>
						<cfelseif type eq 1>
							<cfset gecikme_tutar = (x_voucher_interest/100 *other_money_value/30) * gun_farki>
						</cfif>
						<cfif gun_farki gt 0>	
							<cfset gecikme_toplam = gecikme_toplam + gecikme_tutar>
						</cfif>
					</cfif>
				</cfoutput>	
			<cfelse>
				<cfoutput query="get_cheque_voucher" startrow="1" maxrows="#attributes.startrow-1#">
					<cfif len(total_amount)>
						<cfset sistem_toplam = sistem_toplam + total_amount>
					</cfif>
					<cfif isdefined("attributes.is_money2") and len(total_amount2)>
						<cfset sistem2_toplam = sistem2_toplam + total_amount2>
					</cfif>
					<cfif isdefined("attributes.is_other_money") and len(total_amount_other)>
						<cfset 'toplam_#other_money#' = evaluate('toplam_#other_money#') +total_amount_other>
					</cfif>
					<cfif attributes.report_type eq 4>
						<cfif len(total_amount_icra)>
							<cfset icra_toplam = icra_toplam + total_amount_icra>
						</cfif>
						<cfif len(total_amount_vade)>
							<cfset vade_toplam = vade_toplam + total_amount_vade>
						</cfif>
					</cfif>
					<cfif isdefined("attributes.is_interest") and isdefined("attributes.is_interest_show")>
						<cfset gecikme_toplam = gecikme_toplam + total_gecikme>
					</cfif>
				</cfoutput>	
			</cfif>
		</cfif>
		<cfif attributes.report_type eq 1 and isdefined("attributes.is_cheque")>
			<cfif len(cheque_id_list)>
				<cfset cheque_id_list=listsort(cheque_id_list,"numeric","ASC",",")>
				<cfquery name="get_acc" datasource="#dsn2#">
					SELECT
						C.CHEQUE_ID,
						A.ACCOUNT_NAME
					FROM
						CHEQUE C,
						#dsn3_alias#.ACCOUNTS A
					WHERE
						C.CHEQUE_ID IN(#cheque_id_list#)
						AND A.ACCOUNT_ID = ISNULL((
													SELECT TOP 1
														PAYROLL_ACCOUNT_ID
													FROM
														PAYROLL P,
														CHEQUE_HISTORY CH
													WHERE
														P.ACTION_ID = CH.PAYROLL_ID AND
														CH.CHEQUE_ID = C.CHEQUE_ID AND
														P.PAYROLL_TYPE IN (93,105,106,133,91) AND
														P.PAYROLL_ACCOUNT_ID IS NOT NULL
													ORDER BY
														P.ACTION_ID DESC
												),C.ACCOUNT_ID)
					ORDER BY
						C.CHEQUE_ID
				</cfquery>
				<cfset cheque_id_list = listsort(listdeleteduplicates(valuelist(get_acc.CHEQUE_ID,',')),'numeric','ASC',',')>
			</cfif>
		</cfif>
		<cfif attributes.report_type eq 1 and (isdefined("attributes.is_voucher") or isdefined("attributes.is_pay_term"))>
			<cfif len(voucher_id_list)>
				<cfset voucher_id_list=listsort(voucher_id_list,"numeric","ASC",",")>
				<cfquery name="get_acc_v" datasource="#dsn2#">
					SELECT
						V.VOUCHER_ID,
						A.ACCOUNT_NAME
					FROM
						VOUCHER V,
						#dsn3_alias#.ACCOUNTS A
					WHERE
						V.VOUCHER_ID IN(#voucher_id_list#)
						AND A.ACCOUNT_ID = ISNULL((
													SELECT TOP 1
														PAYROLL_ACCOUNT_ID
													FROM
														VOUCHER_PAYROLL VP,
														VOUCHER_HISTORY VH
													WHERE
														VP.ACTION_ID = VH.PAYROLL_ID AND
														VH.VOUCHER_ID = V.VOUCHER_ID AND
														VP.PAYROLL_TYPE IN (99,100,107,109) AND
														VP.PAYROLL_ACCOUNT_ID IS NOT NULL
													ORDER BY
														VP.ACTION_ID DESC
												),0)
					ORDER BY
						V.VOUCHER_ID
				</cfquery>
				<cfset voucher_id_list = listsort(listdeleteduplicates(valuelist(get_acc_v.VOUCHER_ID,',')),'numeric','ASC',',')>
			</cfif>
		</cfif>
		<cfif attributes.report_type neq 5>
			<tbody>
			<cfoutput query="get_cheque_voucher" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#currentrow#</td>
					<cfif isdefined("attributes.is_cheque")>
							<cfif isdefined("PAY_TYPE") and PAY_TYPE eq 90>
								<!--- <cfset act="Çek Giriş Bordrosu"> --->
								<cfset Xurl="form_add_payroll_entry&event=upd">
							
							<cfelseif isdefined("PAY_TYPE") and PAY_TYPE eq 91>
								<!--- <cfset act="Çek Çıkış Bordrosu-Ciro"> --->
								<cfset Xurl="form_add_payroll_endorsement&event=upd">
							<cfelseif isdefined("PAY_TYPE") and PAY_TYPE eq 92>
								<!--- <cfset act="Çek Çıkış Bordrosu-Tahsil"> --->
								<cfset Xurl="form_add_payroll_bank_revenue&event=upd">
							<cfelseif isdefined("PAY_TYPE") and PAY_TYPE eq 93>
								<!--- <cfset act="Çek Çıkış Bordrosu-Banka"> --->
								<cfset Xurl="form_add_payroll_bank_guaranty&event=upd">
							<cfelseif isdefined("PAY_TYPE") and PAY_TYPE eq 133>
								<!--- <cfset act="Çek Çıkış Bordrosu-Banka Teminat"> --->
								<cfset Xurl="form_add_payroll_bank_guaranty_tem&event=upd">
							<cfelseif isdefined("PAY_TYPE") and PAY_TYPE eq 94>
								<!--- <cfset act="Çek İade Çıkış Bordrosu"> --->
								<cfset Xurl="form_add_payroll_endor_return&event=upd">
							<cfelseif isdefined("PAY_TYPE") and PAY_TYPE eq 95>
								<!--- <cfset act="Çek İade Giriş Bordrosu"> --->
								<cfset Xurl="form_add_payroll_entry_return&event=upd">
							<cfelseif isdefined("PAY_TYPE") and PAY_TYPE eq 105>
								<!--- <cfset act="Çek İade Giriş Bordrosu-Banka"> --->
								<cfset Xurl="form_add_payroll_bank_guaranty_return&event=upd">
							<cfelseif isdefined("PAY_TYPE") and PAY_TYPE eq 134>
								<!--- <cfset act="Çek Transfer işlemi(çıkış)"> --->
								<cfset Xurl="form_add_cheque_transfer&event=upd">
							<cfelseif isdefined("PAY_TYPE") and PAY_TYPE eq 135>
								<!--- <cfset act="Çek Transfer işlemi(giriş)"> --->
								<cfset Xurl="form_add_cheque_transfer&event=upd">
							<cfelseif isdefined("PAY_TYPE") and PAY_TYPE eq 106>
								<!--- <cfset act=""> --->
								<cfset Xurl="">
							<cfelse>
								<!--- <cfset act=""> --->
								<cfset Xurl="">
							</cfif>
					</cfif>	
					<cfif isdefined("attributes.is_voucher")>
							<cfif isdefined("PAY_TYPE") and len(PAY_TYPE) and PAY_TYPE eq 97>
								<cfset Xurl="form_add_voucher_payroll_entry&event=upd">
							<cfelseif isdefined("PAY_TYPE") and len(PAY_TYPE) and PAY_TYPE eq 98>	
								<cfset Xurl="form_add_voucher_payroll_endorsement&event=upd">
							<cfelseif isdefined("PAY_TYPE") and len(PAY_TYPE) and PAY_TYPE eq 99>
								<cfset Xurl="form_add_voucher_payroll_bank_tah&event=upd">
							<cfelseif isdefined("PAY_TYPE") and len(PAY_TYPE) and PAY_TYPE eq 100>
								<cfset Xurl="form_add_voucher_payroll_bank_tem&event=upd">
							<cfelseif isdefined("PAY_TYPE") and len(PAY_TYPE) and PAY_TYPE eq 107>
								<cfset Xurl="">
							<cfelseif isdefined("PAY_TYPE") and len(PAY_TYPE) and PAY_TYPE eq 104>	
								<cfset Xurl="form_add_voucher_payroll_revenue&event=upd">
							<cfelseif isdefined("PAY_TYPE") and len(PAY_TYPE) and PAY_TYPE eq 101>
								<cfset Xurl="add_voucher_payroll_endor_return&event=upd">
							<cfelseif isdefined("PAY_TYPE") and len(PAY_TYPE) and PAY_TYPE eq 108>
								<cfset Xurl="add_voucher_payroll_entry_return&event=upd">
							<cfelseif isdefined("PAY_TYPE") and len(PAY_TYPE) and PAY_TYPE eq 109>
								<cfset Xurl="form_add_voucher_bank_guaranty_return&event=upd">
							<cfelseif isdefined("PAY_TYPE") and len(PAY_TYPE) and PAY_TYPE eq 136>
								<cfset Xurl="form_add_voucher_transfer&event=upd">
							<cfelseif isdefined("PAY_TYPE") and len(PAY_TYPE) and PAY_TYPE eq 137>	
								<cfset Xurl="form_add_voucher_transfer&event=upd">
							<cfelseif isdefined("PAY_TYPE") and len(PAY_TYPE) and PAY_TYPE eq 1057>	
								<cfset Xurl="list_vouchers&event=det">
							</cfif>	
					</cfif>
					<cfif attributes.report_type eq 1>
						<cfif isdefined("attributes.is_cheque") and (isdefined("attributes.is_voucher") or isdefined("attributes.is_pay_term"))>
							<td>
								<cfif type eq 0>
									<cf_get_lang dictionary_id ='58007.Çek'>
								<cfelse>
									<cf_get_lang dictionary_id ='58008.Senet'>
								</cfif>
							</td>
						</cfif>
						<td>
						<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
							#paper_no#
						<cfelse>
							<cfif type eq 0>
								<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_cheque_det&id=#islem_id#','','ui-draggable-box-small')">#paper_no#</a>
							<cfelse>
								<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_voucher_det&id=#islem_id#','','ui-draggable-box-small')">#paper_no#</a>
							</cfif>
						</cfif>
						</td>
						<td>
							<cfif isdefined("PAY") and len(PAY)>
								<cfif (isdefined("attributes.is_cheque") and pay_type neq 106) or (isdefined("attributes.is_voucher") and not listfind('107,1057',pay_type))>
									<a href="#request.self#?fuseaction=cheque.#Xurl#&ID=#PAY#" target="_blank">#PAY_NO#</a> 
								</cfif>
							</cfif>
						<td>
						<cfif len(order_id_list) and len(order_id)>
							<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
								#get_orders.order_number[listfind(order_id_list,order_id,',')]#
							<cfelse>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_voucher&iid=#islem_id#','longpage');">
									#get_orders.order_number[listfind(order_id_list,order_id,',')]#
								</a>
							</cfif>
						</cfif>
						</td>
						<td>#ozel_kod#</td>
						<td>#account_no#</td>
						<td>#dateformat(due_date,dateformat_style)#</td>
						<cfif (isdefined("attributes.is_cheque") or isdefined("attributes.is_voucher") or isdefined("attributes.is_pay_term"))><td>#dateformat(tahsilat_tarihi,dateformat_style)#</td></cfif>
						<cfset due_day = DateDiff("d",due_date,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
						<cfif status eq 3>
							<cfset gecikme_tutar = 0>
						<cfelseif type eq 0>
							<cfset gecikme_tutar = (x_cheque_interest/100 *other_money_value/30) * due_day>
						<cfelseif type eq 1>
							<cfset gecikme_tutar = (x_voucher_interest/100 *other_money_value/30) * due_day>
						</cfif>
						<cfif len(due_day) and len(other_money_value)>
							<cfset total_cheque_value_all = total_cheque_value_all + (other_money_value*due_day)>
							<cfset total_cheque_value = total_cheque_value + other_money_value>
						</cfif>
						<cfif isdefined("attributes.is_interest_show")>
							<td>
								<cfset gun_farki = DateDiff("d",due_date,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
								#gun_farki#
							</td>
						</cfif>
						<td>
							<cfswitch expression="#status#">
								<cfcase value="1"><cf_get_lang dictionary_id='39648.Portföyde'></cfcase>
								<cfcase value="2"><cf_get_lang dictionary_id='39649.Bankada'></cfcase>
								<cfcase value="3"><cf_get_lang dictionary_id='39650.Tahsil Edildi'></cfcase>
								<cfcase value="4"><cf_get_lang dictionary_id='39651.Ciro Edildi'></cfcase>
								<cfcase value="5"><cf_get_lang dictionary_id='39482.Karşılıksız'></cfcase>
								<cfcase value="6"><cf_get_lang dictionary_id='39139.Ödenmedi'></cfcase>
								<cfcase value="7"><cf_get_lang dictionary_id='39136.Ödendi'></cfcase>
								<cfcase value="8"><cf_get_lang dictionary_id='58506.İptal'></cfcase>
								<cfcase value="9"><cf_get_lang dictionary_id='29418.İade'></cfcase>
								<cfcase value="10"><cf_get_lang dictionary_id='39482.Karşılıksız'>-<cf_get_lang dictionary_id='39648.Portföyde'></cfcase>
								<cfcase value="11"><cf_get_lang dictionary_id='39652.Kısmi Tahsil'></cfcase>
								<cfcase value="12"><cf_get_lang dictionary_id='39719.İcra'></cfcase>
								<cfcase value="13"><cf_get_lang dictionary_id='40557.Teminatta'></cfcase>
								<cfcase value="14">Transfer</cfcase>
							</cfswitch>
						</td>
						<td>
							<cfif isdefined("PROJECT_HEAD") and len(PROJECT_HEAD)>
								#PROJECT_HEAD#
							</cfif>
						</td>
						<td>
							#MEMBER_CODE#
						</td>
						<td>
							<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
								#musteri#
							<cfelse>
								<cfif member_type eq 0>
									<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_com_det&company_id=#member_id#');">#musteri#</a>
								<cfelseif member_type eq 1>
									<a href="javascript:// " onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#member_id#','medium');">#musteri#</a>
								<cfelseif member_type eq 2>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#member_id#','medium');">#musteri#</a>
								</cfif>
							</cfif>
						</td>
						<cfif isdefined("attributes.show_cari")>
						<td>
						<cfif len(company_id_list)>#get_cheque_history.MEMBER_CODE[listfind(company_id_list,NEW_COMPANY_ID,',')]#</cfif>
						</td>
						<td>
						<cfif len(company_id_list)>#get_cheque_history.FULLNAME[listfind(company_id_list,NEW_COMPANY_ID,',')]#</cfif>
						</td>
						</cfif>		
						<td>#debtor_name#</td>
						<td>#get_cashes.cash_name[listfind(cash_id_list,cash_id,',')]#</td>
						<td>#bank_name# #bank_branch_name#</td>
						<td>
							<cfif type eq 0 and len(get_acc.account_name[listfind(cheque_id_list,islem_id,',')])>
								#get_acc.account_name[listfind(cheque_id_list,islem_id,',')]#
							<cfelseif type eq 1 and len(get_acc_v.account_name[listfind(voucher_id_list,islem_id,',')])>
								#get_acc_v.account_name[listfind(voucher_id_list,islem_id,',')]#
							<cfelse>
								#get_accounts.account_name[listfind(account_id_list,account_id,',')]#
							</cfif>
						</td>
						<td format="numeric" class="text-right">#TLFormat(other_money_value)# </td>
						<td align="center">#session.ep.money#</td>
						<cfif isdefined("attributes.is_other_money")>
							<td format="numeric" class="text-right">#TLFormat(other_act_value)# </td>
							<td align="center">#other_money#</td>
						</cfif>
						<cfif isdefined("attributes.is_money2")>
							<td format="numeric" class="text-right">#tlformat(other_money_value2)# </td>
							<td align="center">#session.ep.money2#</td>
						</cfif>
						<cfif len(other_money_value)>
							<cfset sistem_toplam = sistem_toplam + other_money_value>
						</cfif>
						<cfif isdefined("attributes.is_money2") and len(other_money_value2)>
							<cfset sistem2_toplam = sistem2_toplam + other_money_value2>
						</cfif>
						<cfif isdefined("attributes.is_other_money") and len(other_act_value)>
							<cfset 'toplam_#other_money#' = evaluate('toplam_#other_money#') +other_act_value>
						</cfif>
						<cfif isdefined("attributes.is_interest") and isdefined("attributes.is_interest_show")>
							<cfset gun_farki = DateDiff("d",due_date,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
							<cfif status eq 3>
								<cfset gecikme_tutar_ = 0>
							<cfelseif type eq 0>
								<cfset gecikme_tutar_ = (x_cheque_interest/100 *other_money_value/30) * gun_farki>
							<cfelseif type eq 1>
								<cfset gecikme_tutar_ = (x_voucher_interest/100 *other_money_value/30) * gun_farki>
							</cfif>
							<td format="numeric" class="text-right">#TLFormat(gecikme_tutar_)#</td>
							<td align="center">#session.ep.money#</td>
							<cfset toplam_tutar = other_money_value + gecikme_tutar_>
							<cfset gecikme_toplam = gecikme_toplam + gecikme_tutar_>
							<td format="numeric" class="text-right">#TlFormat(toplam_tutar)#</td>
							<td align="center">#session.ep.money#</td>
						</cfif>
					<cfelseif attributes.report_type eq 2>
						<td>
						<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
							#musteri#
						<cfelse>	
							<cfif member_type eq 0>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#member_id#','medium');">#musteri#</a>
							<cfelseif member_type eq 1>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#member_id#','medium');">#musteri#</a>
							<cfelseif member_type eq 2>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#member_id#','medium');">#musteri#</a>
							</cfif>
						</cfif>
						</td>
						<td>#member_code#</td>
						<td>#m_ozel_kod#</td>
						<td>#mobil_tel#</td>
						<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
							<td>#file_number#</td>
							<td>
							<cfif len(consumer_id_list) and len(law_adwocate)>
								<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
									#get_consumer.consumer_name[listfind(consumer_id_list,law_adwocate,',')]# #get_consumer.consumer_surname[listfind(consumer_id_list,law_adwocate,',')]#
								<cfelse>	
									<a href="javascript:// " onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#law_adwocate#','medium');">	
										#get_consumer.consumer_name[listfind(consumer_id_list,law_adwocate,',')]# #get_consumer.consumer_surname[listfind(consumer_id_list,law_adwocate,',')]#
									</a>
								</cfif>
							</cfif>
							</td>
						</cfif>
						<cfif len(total_amount)>
							<cfset sistem_toplam = sistem_toplam + total_amount>
						</cfif>
						<cfif isdefined("attributes.is_money2") and len(total_amount2)>
							<cfset sistem2_toplam = sistem2_toplam + total_amount2>
						</cfif>
						<cfif isdefined("attributes.is_other_money") and len(total_amount_other)>
							<cfset 'toplam_#other_money#' = evaluate('toplam_#other_money#') +total_amount_other>
						</cfif>
						<td format="numeric" class="text-right">#tlformat(total_amount)#</td>
						<td align="center">#session.ep.money#</td>
						<cfif isdefined("attributes.is_other_money")>
							<td format="numeric" class="text-right">#tlformat(total_amount_other)#</td>
							<td align="center">#other_money#</td>
						</cfif>
						<cfif isdefined("attributes.is_money2")>
						<td format="numeric" class="text-right">#tlformat(total_amount2)#</td>
						<td align="center">#session.ep.money2#</td>
						</cfif>
						<cfif isdefined("attributes.is_interest") and isdefined("attributes.is_interest_show")>
							<td format="numeric" class="text-right">
								<cfif len(total_gecikme)>
									#tlformat(total_gecikme)# 
									<cfset gecikme_toplam = gecikme_toplam + total_gecikme>
									<cfset toplam_tutar = total_amount + total_gecikme>
								<cfelse>
									#tlformat(0)# 
									<cfset toplam_tutar = total_amount>
								</cfif>
							</td>
							<td align="center">#session.ep.money#</td>
							<td format="numeric" class="text-right">#TlFormat(toplam_tutar)#</td>
							<td align="center">#session.ep.money#</td>
						</cfif>
						<td class="text-right">#dateformat(date_add('d',avg_duedate,now()),dateformat_style)#</td>
					<cfelseif attributes.report_type eq 3>
						<td>
							<cfif len(consumer_id_list) and len(law_adwocate)>
								<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
									#get_consumer.consumer_name[listfind(consumer_id_list,law_adwocate,',')]# #get_consumer.consumer_surname[listfind(consumer_id_list,law_adwocate,',')]#
								<cfelse>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#law_adwocate#','medium');">
										#get_consumer.consumer_name[listfind(consumer_id_list,law_adwocate,',')]# #get_consumer.consumer_surname[listfind(consumer_id_list,law_adwocate,',')]#
									</a>
								</cfif>
							<cfelse>
								<cf_get_lang dictionary_id ='40339.Avukatsız'>	
							</cfif>
						</td>
						<cfif len(total_amount)>
							<cfset sistem_toplam = sistem_toplam + total_amount>
						</cfif>
						<cfif isdefined("attributes.is_money2") and len(total_amount2)>
							<cfset sistem2_toplam = sistem2_toplam + total_amount2>
						</cfif>
						<cfif isdefined("attributes.is_other_money") and len(total_amount_other)>
							<cfset 'toplam_#other_money#' = evaluate('toplam_#other_money#') +total_amount_other>
						</cfif>
						<td format="numeric" class="text-right">#tlformat(total_amount)# </td>
						<td align="center">#session.ep.money#</td>
						<cfif isdefined("attributes.is_other_money")>
							<td format="numeric" class="text-right">#tlformat(total_amount_other)# </td>
							<td align="center">#other_money#</td>
						</cfif>
						<cfif isdefined("attributes.is_money2")>
							<td format="numeric" class="text-right">#tlformat(total_amount2)# </td>
							<td align="center">#session.ep.money2#</td>
						</cfif>
						<cfif isdefined("attributes.is_interest") and isdefined("attributes.is_interest_show")>
							<td format="numeric" class="text-right">
								<cfif len(total_gecikme)>
									#tlformat(total_gecikme)# 
									<cfset gecikme_toplam = gecikme_toplam + total_gecikme>
									<cfset toplam_tutar = total_amount + total_gecikme>
								<cfelse>
									#tlformat(0)# 
									<cfset toplam_tutar = total_amount>
								</cfif>
							</td>
							<td align="center">#session.ep.money#</td>
							<td format="numeric" class="text-right">#TlFormat(toplam_tutar)#</td>
							<td align="center">#session.ep.money#</td>
						</cfif>
						<td class="text-right">#dateformat(date_add('d',avg_duedate,now()),dateformat_style)#</td>
					<cfelseif attributes.report_type eq 4>
						<td>#cash_name#</td>
						<cfif len(total_amount)>
							<cfset sistem_toplam = sistem_toplam + total_amount>
						</cfif>
						<cfif isdefined("attributes.is_money2") and len(total_amount2)>
							<cfset sistem2_toplam = sistem2_toplam + total_amount2>
						</cfif>
						<cfif isdefined("attributes.is_other_money") and len(total_amount_other)>
							<cfset 'toplam_#other_money#' = evaluate('toplam_#other_money#') +total_amount_other>
						</cfif>
						<td format="numeric" class="text-right">#tlformat(total_amount)# </td>
						<td align="center">#session.ep.money#</td>
						<cfif isdefined("attributes.is_other_money")>
							<td format="numeric" class="text-right">#tlformat(total_amount_other)#</td>
							<td align="center"> #other_money#</td>
						</cfif>
						<cfif isdefined("attributes.is_money2")>
							<td format="numeric" class="text-right">#tlformat(total_amount2)# </td>
							<td align="center">#session.ep.money2#</td>
						</cfif>
						<td class="text-right">#dateformat(date_add('d',avg_duedate,now()),dateformat_style)#</td>
						<cfif isdefined("attributes.is_interest") and isdefined("attributes.is_interest_show")>
							<td width="1"></td>
							<td format="numeric" class="text-right">
								<cfif len(total_gecikme)>
									#tlformat(total_gecikme)#
									<cfset gecikme_toplam = gecikme_toplam + total_gecikme>
									<cfset toplam_tutar = total_amount + total_gecikme>
								<cfelse>
									#tlformat(0)#
									<cfset toplam_tutar = total_amount>
								</cfif>
							</td>
							<td>#session.ep.money#</td>
							<cfif total_gecikme gt 0>
								<cfset due_day = total_gecikme_vade / total_gecikme>
							<cfelse>
								<cfset due_day = 0>
							</cfif>
							<td class="text-right">#dateformat(date_add('d',due_day,now()),dateformat_style)#</td>
							<td class="text-right">
								%<cfif total_amount gt 0>#TLFormat((total_gecikme/total_amount)*100)#<cfelse>0</cfif>
							</td>
						</cfif>
						<td width="1"></td>
						<td format="numeric" class="text-right">
							<cfif len(total_amount_icra)>
								#tlformat(total_amount_icra)# 
								<cfset icra_toplam = icra_toplam + total_amount_icra>
							<cfelse>
								#tlformat(0)# 
							</cfif>
						</td>
						<td align="center">#session.ep.money#</td>
						<td class="text-right"><cfif TOTAL_AMOUNT_ICRA eq 0>#dateformat(date_add('d',avg_duedate_icra,now()),dateformat_style)#<cfelse>#dateformat(date_add('d',(avg_duedate_icra/TOTAL_AMOUNT_ICRA),now()),dateformat_style)#</cfif></td>
						<td width="1"></td>
						<td format="numeric" class="text-right">
							<cfif len(total_amount_vade)>
								#tlformat(total_amount_vade)# 
								<cfset vade_toplam = vade_toplam + total_amount_vade>
							<cfelse>
								#tlformat(0)#
							</cfif>
						</td>
						<td align="center">#session.ep.money#</td>
						<td class="text-right"><cfif TOTAL_AMOUNT_VADE eq 0>#dateformat(date_add('d',avg_duedate_vade,now()),dateformat_style)#<cfelse>#dateformat(date_add('d',(avg_duedate_vade/TOTAL_AMOUNT_VADE),now()),dateformat_style)#</cfif></td>
					</cfif>
				</tr>
			</cfoutput>
			</tbody>
		</cfif>
		<cfif attributes.report_type neq 5 and attributes.report_type neq 6>
			<tbody>
			<tr>
			<cfoutput>
				<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
					<cfif attributes.report_type eq 1 and isdefined("attributes.is_cheque") and (isdefined("attributes.is_voucher") or isdefined("attributes.is_pay_term"))>
						<cfset colspan_ = 11>
					<cfelseif attributes.report_type eq 1>
						<cfset colspan_ = 7>
					<cfelseif attributes.report_type eq 2>
						<cfset colspan_ = 7>
					<cfelse>
						<cfset colspan_ = 5>
					</cfif>
					<td colspan="#colspan_#" class="txtbold" class="text-right"><cf_get_lang dictionary_id='80.Toplam'></td>
				<cfelse>
					<cfif attributes.report_type eq 1 and isdefined("attributes.is_cheque") and (isdefined("attributes.is_voucher") or isdefined("attributes.is_pay_term"))>
						<cfset colspan_ = 9>
					<cfelseif attributes.report_type eq 1>
						<cfset colspan_ = 6>
					<cfelseif attributes.report_type eq 2>
						<cfset colspan_ = 5>
					<cfelse>
						<cfset colspan_ = 2>
					</cfif>	
					<td colspan="#colspan_#" class="txtbold" class="text-right"><cf_get_lang dictionary_id='80.Toplam'></td>
				</cfif>
				<cfif attributes.report_type eq 1>
					<td class="txtbold">
						<cfif total_cheque_value neq 0><cfset due_day = total_cheque_value_all/total_cheque_value><cfoutput>#dateformat(date_add('d',(-1*due_day),now()),dateformat_style)#</cfoutput></cfif>
					</td>
					<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
						<cfif attributes.report_type eq 1 and isdefined("attributes.is_cheque") and (isdefined("attributes.is_voucher") or isdefined("attributes.is_pay_term"))>
							<cfset colspan_ = 8>
						<cfelseif attributes.report_type eq 1 and (isdefined("attributes.is_cheque") or isdefined("attributes.is_voucher") or isdefined("attributes.is_pay_term"))>
							<cfset colspan_ = 10>
						<cfelseif attributes.report_type eq 1>
							<cfset colspan_ = 6>
						<cfelseif attributes.report_type eq 2>
							<cfset colspan_ = 7>
						<cfelse>
							<cfset colspan_ = 5>
						</cfif>
						<cfif isdefined("attributes.is_interest_show")>
							<cfset colspan_ = colspan_ + 1>
							<cfif isdefined("attributes.is_interest")>
								<cfset colspan_ = colspan_ + 1>
							</cfif>
						</cfif>	
						<td colspan="#colspan_#" class="txtbold" class="text-right"></td>
					<cfelseif isdefined("attributes.show_cari")>
						<cfif attributes.report_type eq 1 and isdefined("attributes.is_cheque") and (isdefined("attributes.is_voucher") or isdefined("attributes.is_pay_term"))>
							<cfset colspan_ = 11>
						<cfelseif attributes.report_type eq 1 and (isdefined("attributes.is_cheque") or isdefined("attributes.is_voucher") or isdefined("attributes.is_pay_term"))>
							<cfset colspan_ = 10>
						<cfelseif attributes.report_type eq 1>
							<cfset colspan_ = 7>
						<cfelseif attributes.report_type eq 2>
							<cfset colspan_ = 6>
						<cfelse>
							<cfset colspan_ = 2>
						</cfif>
						<cfif isdefined("attributes.is_interest_show")>
							<cfset colspan_ = colspan_ + 1>
							<cfif isdefined("attributes.is_interest")>
								<cfset colspan_ = colspan_ + 1>
							</cfif>
						</cfif>	
						<td colspan="#colspan_#" class="txtbold" class="text-right"></td>
					<cfelse>
						<cfif attributes.report_type eq 1 and isdefined("attributes.is_cheque") and (isdefined("attributes.is_voucher") or isdefined("attributes.is_pay_term"))>
							<cfset colspan_ = 9>
						<cfelseif attributes.report_type eq 1 and (isdefined("attributes.is_cheque") or isdefined("attributes.is_voucher") or isdefined("attributes.is_pay_term"))>
							<cfset colspan_ = 9>
						<cfelseif attributes.report_type eq 1>
							<cfset colspan_ = 6>
						<cfelseif attributes.report_type eq 2>
							<cfset colspan_ = 5>
						<cfelse>
							<cfset colspan_ = 2>
						</cfif>
						<cfif isdefined("attributes.is_interest_show")>
							<cfset colspan_ = colspan_ + 1>
						</cfif>		
						<td colspan="#colspan_#" class="txtbold" class="text-right"></td>
					</cfif>
				</cfif>
			</cfoutput>
				<td format="numeric" class="txtbold" class="text-right"><cfoutput>#Tlformat(sistem_toplam)# </cfoutput></td>
				<td align="center" class="txtbold"><cfoutput>#session.ep.money#</cfoutput></td>
				<cfif isdefined("attributes.is_other_money")>
					<td format="numeric" class="txtbold" class="text-right">
						<cfoutput query="get_money">
							<cfif evaluate('toplam_#money#') gt 0>
								#Tlformat(evaluate('toplam_#money#'))#<br/>
							</cfif>
						</cfoutput>
					</td>
					<td align="center" class="txtbold">
						<cfoutput query="get_money">
							<cfif evaluate('toplam_#money#') gt 0>
								#money#<br/>
							</cfif>
						</cfoutput>
					</td>
				</cfif>
				<cfif isdefined("attributes.is_money2")>
					<td format="numeric" class="txtbold" class="text-right"><cfoutput>#Tlformat(sistem2_toplam)# </cfoutput></td>
					<td align="center" class="txtbold"><cfoutput>#session.ep.money2#</cfoutput></td>
				</cfif>
				<cfif attributes.report_type eq 4>
					<td></td>
				</cfif>
				<cfif isdefined("attributes.is_interest") and isdefined("attributes.is_interest_show")>
					<cfif attributes.report_type eq 4><td width="1"></td></cfif>
					<td format="numeric" class="txtbold" class="text-right"><cfoutput>#Tlformat(gecikme_toplam)# </cfoutput></td>
					<td align="center" class="txtbold"><cfoutput>#session.ep.money#</cfoutput></td>
					<cfif attributes.report_type eq 4>
						<td></td><td></td>
					<cfelse>
						<td format="numeric" class="txtbold" class="text-right"><cfoutput>#Tlformat(gecikme_toplam+sistem_toplam)#</cfoutput></td>
						<td align="center" class="txtbold"><cfoutput>#session.ep.money#</cfoutput></td>
					</cfif>
				</cfif>
				<cfif attributes.report_type eq 4>
					<td width="1"></td>
					<td format="numeric" class="txtbold" class="text-right"><cfoutput>#Tlformat(icra_toplam)# </cfoutput></td>
					<td align="center"><cfoutput>#session.ep.money#</cfoutput></td>
					<td></td>
					<td width="1"></td>
					<td format="numeric" class="txtbold" class="text-right"><cfoutput>#Tlformat(vade_toplam)#</cfoutput></td>
					<td align="center"><cfoutput>#session.ep.money#</cfoutput></td>
					<td></td>
				</cfif>
				<cfif listfind('2,3',attributes.report_type)>
					<td></td>
				</cfif>
			</tr>
			</tbody>
		<cfelseif attributes.report_type neq 5>
			<tr class="color-row" height="20">
				<td colspan="17"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
			</tr>
		</cfif>
	<cfelse>
			<tr>
				<td colspan="23"><cf_get_lang dictionary_id='57484.Kayıt yok'>!</td>
			</tr>
	</cfif>
</cf_report_list>
</cfif>
<cfset adres = "">
<cfif isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.maxrows and attributes.report_type neq 5>
	<cfset adres = "#fusebox.circuit#.cheque_voucher_analyse&form_submitted=1">
	<cfif isdefined("attributes.is_cheque")>
		<cfset adres = "#adres#&is_cheque=1">
	</cfif>
	<cfif isdefined("attributes.is_pay_term")>
		<cfset adres = "#adres#&is_pay_term=1">
	</cfif>
	<cfif isdefined("attributes.is_voucher")>
		<cfset adres = "#adres#&is_voucher=1">
	</cfif>
	<cfif isdefined("attributes.is_money2")>
		<cfset adres = "#adres#&is_money2=1">
	</cfif>
	<cfif isdefined("attributes.is_other_money")>
		<cfset adres = "#adres#&is_other_money=1">
	</cfif>
	<cfif isdefined("attributes.is_interest")>
		<cfset adres = "#adres#&is_interest=1">
	</cfif>
	<cfif isdefined("attributes.show_cari")>
		<cfset adres = "#adres#&show_cari=1">
	</cfif>
	<cfif isdefined("attributes.is_interest_show")>
		<cfset adres = "#adres#&is_interest_show=1">
	</cfif>
	<cfif isdefined("attributes.is_status_info")>
		<cfset adres = "#adres#&is_status_info=1">
	</cfif>
	<cfif isdefined("attributes.is_open_acts")>
		<cfset adres = "#adres#&is_open_acts=1">
	</cfif>
	<cfif isdefined("attributes.is_first_cash")>
		<cfset adres = "#adres#&is_first_cash=1">
	</cfif>
	<cfif isDefined('attributes.status') and len(attributes.status)>
	  <cfset adres = '#adres#&status=#attributes.status#'>
	</cfif>
	<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
		<cfset adres = "#adres#&cash_id=#attributes.cash_id#">
	</cfif>
	<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
		<cfset adres = "#adres#&account_id=#attributes.account_id#">
	</cfif>
	<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
		<cfset adres = "#adres#&new_account_id=#attributes.new_account_id#">
	</cfif>
	<cfif isdefined("attributes.bloke_member") and len(attributes.bloke_member)>
		<cfset adres = "#adres#&bloke_member=#attributes.bloke_member#">
	</cfif>
	<cfif isdefined("attributes.report_type") and len(attributes.report_type)>
		<cfset adres = "#adres#&report_type=#attributes.report_type#">
	</cfif>
	<cfif len(attributes.member_cat_type)>
		<cfset adres = "#adres#&member_cat_type=#attributes.member_cat_type#">
	</cfif>
	<cfif isDefined('attributes.start_date') and len(attributes.start_date)>
	  <cfset adres = '#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
	</cfif>
	<cfif isDefined('attributes.finish_date') and len(attributes.finish_date)>
	  <cfset adres = '#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
	</cfif>
	<cfif isDefined('attributes.record_date1') and len(attributes.record_date1)>
	  <cfset adres = '#adres#&record_date1=#dateformat(attributes.record_date1,dateformat_style)#'>
	</cfif>
	<cfif isDefined('attributes.record_date2') and len(attributes.record_date2)>
	  <cfset adres = '#adres#&record_date2=#dateformat(attributes.record_date2,dateformat_style)#'>
	</cfif>
	<cfif isDefined('attributes.action_date1') and len(attributes.action_date1)>
	  <cfset adres = '#adres#&action_date1=#dateformat(attributes.action_date1,dateformat_style)#'>
	</cfif>
	<cfif isDefined('attributes.action_date2') and len(attributes.action_date2)>
	  <cfset adres = '#adres#&action_date2=#dateformat(attributes.action_date2,dateformat_style)#'>
	</cfif>
	<cfif len(attributes.company_id) and len(attributes.company)>
		<cfset adres = "#adres#&company_id=#attributes.company_id#&company=#attributes.company#">
	</cfif>
	<cfif len(attributes.lawyer_id) and len(attributes.lawyer_name)>
		<cfset adres = "#adres#&lawyer_id=#attributes.lawyer_id#&lawyer_name=#attributes.lawyer_name#">
	</cfif>
	<cfif len(attributes.consumer_id) and len(attributes.company)>
		<cfset adres = "#adres#&consumer_id=#attributes.consumer_id#&company=#attributes.company#">
	</cfif>
	<cfif len(attributes.amount_value1) and len(attributes.amount_value2)>
		<cfset adres = "#adres#&amount_value1=#attributes.amount_value1#&amount_value2=#attributes.amount_value2#">
	</cfif>
	<cfif len(attributes.employee_id) and len(attributes.employee)>
		<cfset adres = "#adres#&employee_id=#attributes.employee_id#&employee=#attributes.employee#">
	</cfif> 
	<cfif len(attributes.owner_company_id) and len(attributes.owner_company)>
		<cfset adres = '#adres#&owner_company_id=#attributes.owner_company_id#'>
	</cfif>
	<cfif len(attributes.owner_consumer_id) and len(attributes.owner_company)>
		<cfset adres = '#adres#&owner_consumer_id=#attributes.owner_consumer_id#'>
	</cfif>
	<cfif len(attributes.owner_employee_id) and len(attributes.owner_company)>
		<cfset adres = '#adres#&owner_employee_id=#attributes.owner_employee_id#'>
	</cfif>
	<cfif len(attributes.owner_company)>
		<cfset adres = '#adres#&owner_company=#attributes.owner_company#'>
	</cfif>
	<cfif len(attributes.owner_member_type)>
		<cfset adres = '#adres#&owner_member_type=#attributes.owner_member_type#'>
	</cfif>
	<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#"></td>
</cfif>
<script type="text/javascript">
	function kontrol_form()
	{
			
		if(document.rapor.is_cheque.checked == false && document.rapor.is_voucher.checked == false && document.rapor.is_pay_term.checked == false)
		{
			alert("<cf_get_lang dictionary_id ='40340.Çek ve Senet Seçeneklerinden Birini Seçmelisiniz'> !");
			return false;
		}
		if (document.rapor.cash_id.value !== '' && document.rapor.account_id.value !== '')
		{
			alert("<cf_get_lang dictionary_id='60663.Kasa ve Banka Hesabı Seçeneklerinden Birini Seçmelisiniz'>");
			return false;
		}
		if(document.rapor.is_status_info.checked == true && document.rapor.action_date2.value == '')
		{
			alert("<cf_get_lang dictionary_id='60664.İşlem Tarihindeki Durumu Göstermesi İçin Lütfen İşlem Tarihi Seçiniz'>");
			return false;
		}
		else
			document.rapor.action="<cfoutput>#request.self#?fuseaction=report.cheque_voucher_analyse</cfoutput>";

		if ((document.rapor.start_date.value != '') && (document.rapor.finish_date.value != '') &&
	    !date_check(rapor.start_date,rapor.finish_date,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;	
		if(document.rapor.is_excel.checked==false)
		{
			document.rapor.action="<cfoutput>#request.self#?fuseaction=report.cheque_voucher_analyse</cfoutput>"
			return true;
		}
		else
			document.rapor.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_cheque_voucher_analyse</cfoutput>"
		
		
	
	}
	function kontrol_report_type()
	{
		if(document.getElementById('report_type').value==2)
		{
			is_bloke_member.style.display = '';
			is_bloke_member1.style.display = '';
		}
		else
		{
			is_bloke_member.style.display = 'none';
			is_bloke_member1.style.display = 'none';
			document.rapor.bloke_member.value = '';
		}
				
		if(document.getElementById('report_type').value==6)
		{
			document.rapor.is_other_money.disabled = true;
			document.rapor.show_cari.disabled = true;
			document.rapor.is_status_info.disabled = true;
			document.rapor.is_interest.checked = false;
			document.rapor.is_other_money.checked = false;
			document.rapor.is_money2.checked = false;
			document.rapor.show_cari.checked = false;
			document.rapor.is_status_info.checked = false;
			
		}
		else
		{
			document.rapor.is_other_money.checked = false
			document.rapor.show_cari.checked = false;
			document.rapor.is_status_info.checked = false;
			document.rapor.is_other_money.disabled = false;
			document.rapor.show_cari.disabled = false;
			document.rapor.is_status_info.disabled = false;
			document.rapor.is_open_acts.disabled = false;
		}
		if(document.getElementById('report_type').value==5 || document.getElementById('report_type').value==6)
		{
			document.rapor.is_money2.disabled = true;
			document.rapor.is_interest.disabled = true;
			document.rapor.is_interest.checked = false;
			document.rapor.is_money2.checked = false;
		}
		else
		{
			document.rapor.is_money2.disabled = false;
			document.rapor.is_interest.disabled = false;
		}
	}
	$(document).ready(function(){
		$('#is_interest_show').change(function(){
			if($('#is_interest_show').is(':checked'))
				$('#interest').show();
			else
			{
				$('#interest').hide();
				$('#is_interest').prop('checked', false);
			}
		});
		$(".selfcheque").change(function() {
			if(this.checked)
			{
				$(".selfcheque").prop('checked', false);
				$(this).prop('checked', true);
			}
			else
			{
				$(".selfcheque").prop('checked', false);
				$(this).prop('checked', false);
			}
		});	
	});
</script>
<cfsetting showdebugoutput="yes"> 