<cfparam name="attributes.module_id_control" default="4">
<cfinclude template="report_authority_control.cfm">
<cf_xml_page_edit fuseact ="report.collacted_make_age_report">
<cfset get_comp_remainder_main.recordcount = 0>
<cfquery name="get_period" datasource="#dsn#">
	SELECT PERIOD_ID, PERIOD FROM SETUP_PERIOD WHERE PERIOD_YEAR <= #year(now())+1#
</cfquery>
<cfinclude template="../../objects/query/get_acc_types.cfm">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.action_type" default="1">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.pos_code_text" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.employee_cat_type" default="">
<cfparam name="attributes.customer_value" default="">
<cfparam name="attributes.duty_claim" default="">
<cfparam name="attributes.consumer_cat_type" default="">
<cfparam name="attributes.is_detail" default="">
<cfparam name="attributes.detail_type" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.due_date1" default="">
<cfparam name="attributes.due_date2" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.buy_status" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.money_type_info" default="">
<cfparam name="attributes.list_type" default="">
<cfset tr_kapat_ = '</tr>'>
<cfif attributes.is_excel eq 1>
	<cfset function_td_type = 1><!--- excel --->
<cfelseif attributes.is_excel eq 2>
	<cfset function_td_type = 0><!--- csv --->
<cfelse>
	<cfset function_td_type = 2>
</cfif>
<cfquery name="get_customer_value" datasource="#dsn#">
	SELECT CUSTOMER_VALUE_ID,CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
</cfquery>
<cfquery name="get_sales_zone" datasource="#dsn#">	
	SELECT 
    	SZ_ID, 
        SZ_NAME, 
        SZ_HIERARCHY, 
        SALES_ZONE, 
        OZEL_KOD 
    FROM 
	    SALES_ZONES 
    ORDER BY 
    	SZ_NAME
</cfquery>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT
		B.BRANCH_ID,
		B.BRANCH_NAME,
		B.BRANCH_STATUS
	FROM
		BRANCH B
	WHERE
		B.COMPANY_ID = #session.ep.company_id#
		<cfif not session.ep.ehesap>
		AND B.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
		</cfif>
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfquery name="get_department" datasource="#DSN#">
	SELECT
		DEPARTMENT_ID,
		DEPARTMENT_HEAD,
		BRANCH_ID,
		DEPARTMENT_STATUS
	FROM
		DEPARTMENT D 
	ORDER BY 
		DEPARTMENT_HEAD
</cfquery>
<cfquery name="get_company_cat" datasource="#dsn#">
	SELECT DISTINCT	
		COMPANYCAT_ID,
		COMPANYCAT
	FROM
		GET_MY_COMPANYCAT
	WHERE
		EMPLOYEE_ID = #session.ep.userid# AND
		OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY
		COMPANYCAT
</cfquery>
<cfquery name="get_consumer_cat" datasource="#dsn#">
	SELECT DISTINCT	
		CONSCAT_ID,
		CONSCAT,
		HIERARCHY
	FROM
		GET_MY_CONSUMERCAT
	WHERE
		EMPLOYEE_ID = #session.ep.userid# AND
		OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY
		HIERARCHY		
</cfquery>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT
		MONEY,
		RATE2,
		RATE1
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		MONEY_STATUS = 1
	ORDER BY 
		MONEY_ID
</cfquery>
<cfquery name="get_all_ch_type" datasource="#dsn#">
    SELECT ACC_TYPE_ID,ACC_TYPE_NAME FROM SETUP_ACC_TYPE ORDER BY ACC_TYPE_ID
</cfquery>
<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
	<cf_date tarih = "attributes.action_date1">
<cfelse>
	<cfset action_date1="01/01/#session.ep.period_year#">
	<cfparam name="attributes.action_date1" default="#action_date1#">
</cfif>
<cfif isdefined('attributes.action_date2') and isdate(attributes.action_date2)>
	<cf_date tarih = "attributes.action_date2">
<cfelse>
	<cfset action_date2 = "31/12/#session.ep.period_year#">
	<cfparam name="attributes.action_date2" default="#action_date2#">
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfif isdefined("attributes.due_date1") and isdate(attributes.due_date1)>
		<cf_date tarih = "attributes.due_date1">
	</cfif>
	<cfif isdefined("attributes.due_date2") and isdate(attributes.due_date2)>
		<cf_date tarih = "attributes.due_date2">
	</cfif>
</cfif>
<cfscript>
	total_cari_toplam_islem_tutar = 0;
	total_all_money = 0;
	total_taken_inv_rates = 0;
	total_given_inv_rates = 0;
	total_claim_rates = 0;
	total_debt_rates = 0;
	total_taken= 0;
	total_given= 0;
</cfscript>
<cfif isDefined("attributes.form_submitted") and attributes.form_submitted eq 1 and  isDefined("attributes.detail_type") and attributes.detail_type eq 4 and isDefined("attributes.zero_bakiye")>
	<cfset zero_diff_rate = 1>
<cfelse>
	<cfset zero_diff_rate = 0>
</cfif>
<cfif attributes.is_excel neq 1 or attributes.is_excel neq 2>
<cfform name="rapor" action="#request.self#?fuseaction=report.collacted_make_age_report" method="post">
	<cfsavecontent variable='title'><cf_get_lang dictionary_id='39777.Toplu Ödeme Performansı'></cfsavecontent>
	<cf_report_list_search title="#title#">
		<cf_report_list_search_area>
			<div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12">
									<div class="form-group">
									    <label class="col col-12"> <cf_get_lang dictionary_id='57519.Cari Hesap'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
												<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(attributes.company)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
												<input type="hidden" name="employee_id" id="employee_id" value="<cfif len(attributes.company)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
												<input type="text" name="company" id="company" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','','3','250',true,'fill_country(0,0)');" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=rapor.company&field_comp_id=rapor.company_id&field_consumer=rapor.consumer_id&field_member_name=rapor.company&field_emp_id=rapor.employee_id&field_name=rapor.company&select_list=1,2,3,9','list');"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
									    <label class="col col-12"><cf_get_lang dictionary_id='58795.Müşteri Temsilcisi'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="pos_code" id="pos_code" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
												<input type="text" name="pos_code_text" id="pos_code_text" style="width:110px;" value="<cfif len(attributes.pos_code)><cfoutput>#get_emp_info(attributes.pos_code,1,0,0)#</cfoutput></cfif>" onfocus="AutoComplete_Create('pos_code_text','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','pos_code','','3','130');" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=rapor.pos_code&field_name=rapor.pos_code_text&select_list=1,9','list')"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
									  <label class="col col-12"><cf_get_lang dictionary_id ='57416.Proje'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')><cfoutput>#attributes.project_id#</cfoutput></cfif>">
												<cf_wrk_projects form_name='rapor' project_id='project_id' project_name='project_head'>
												<input type="text" name="project_head" id="project_head" style="width:145px;" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');" value="<cfoutput>#attributes.project_head#</cfoutput>" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=rapor.project_id&project_head=rapor.project_head');"> </span>	
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12" id="file_type_label" <cfif attributes.is_detail eq 1>style="display:none;"</cfif>><cf_get_lang dictionary_id='39345.Dosya Tipi'></label>
										<div class="col col-12 col-xs-12" id="file_type" <cfif attributes.is_detail eq 1>style="display:none;"</cfif>>
											<select name="is_excel_" id="is_excel_" >
												<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
												<option value="2" <cfif attributes.is_excel eq 2>selected</cfif>>CSV</option>
											</select>
										</div>
										<label class="col col-12" <cfif attributes.is_detail neq 1>style="display:none;"</cfif> id="detail_type_td1_label"><cf_get_lang dictionary_id ='57509.Liste'></label>
										<div class="col col-12 col-xs-12" <cfif attributes.is_detail neq 1>style="display:none;"</cfif> id="detail_type_td1">
											<select name="detail_type" id="detail_type" onchange="check_detail(1);">
												<option value=""><cf_get_lang dictionary_id='58081.Hepsi'></option>
												<option value="2" <cfif isDefined("attributes.detail_type") and attributes.detail_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='57890.Açık İşlemler'></option>
												<option value="1" <cfif isDefined("attributes.detail_type") and attributes.detail_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='57802.Ödeme Performansı'></option>
												<option value="4" <cfif isDefined("attributes.detail_type") and attributes.detail_type eq 4>selected</cfif>><cf_get_lang dictionary_id ='59192.Kur Farkları'></option>
												<option value="3" <cfif isDefined("attributes.detail_type") and attributes.detail_type eq 3>selected</cfif>><cf_get_lang dictionary_id ='38836.Sadece Borç Karakterli İşlemler'></option>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12">	
									<div class="form-group">
										<label class="col col-12"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></label>
										<div class="col col-12 col-xs-12">
											<select name="zone_id" id="zone_id">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="get_sales_zone">
													<option value="#sz_id#" <cfif attributes.zone_id eq sz_id>selected</cfif>>#sz_name#</option>
												</cfoutput>
											</select>	
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12"><cf_get_lang dictionary_id='58552.Müşteri Değeri'></label>
										<div class="col col-12 col-xs-12">
											<select name="customer_value" id="customer_value">
												<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
												<cfoutput query="get_customer_value">
													<option value="#customer_value_id#" <cfif isdefined('attributes.customer_value') and customer_value_id eq attributes.customer_value> selected</cfif>>#customer_value#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12"><cf_get_lang dictionary_id ='57587.Borç'>/<cf_get_lang dictionary_id ='57588.Alacak'></label>
										<div class="col col-12 col-xs-12">
											<select name="duty_claim" id="duty_claim">
												<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
												<option value="1" <cfif isDefined("attributes.duty_claim") and attributes.duty_claim eq 1>selected</cfif>><cf_get_lang dictionary_id ='40026.Borçlu Üyeler'></option>
												<option value="2" <cfif isDefined("attributes.duty_claim") and attributes.duty_claim eq 2>selected</cfif>><cf_get_lang dictionary_id ='40027.Alacaklı Üyeler'></option>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12" id="buy_status1"><cf_get_lang dictionary_id='58733.Alıcı'> / <cf_get_lang dictionary_id='58873.Satıcı'></label>
										<div class="col col-12 col-xs-12" id="buy_status2">
											<select name="buy_status" id="buy_status" style="width:150px;">
												<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
												<option value="1" <cfif isDefined('attributes.buy_status') and attributes.buy_status eq 1>selected</cfif>><cf_get_lang dictionary_id='58733.Alıcı'></option>
												<option value="2" <cfif isDefined('attributes.buy_status') and attributes.buy_status eq 2>selected</cfif>><cf_get_lang dictionary_id='58873.Satıcı'></option>
												<option value="3" <cfif isDefined('attributes.buy_status') and attributes.buy_status eq 3>selected</cfif>><cf_get_lang dictionary_id='57577.Potansiyel'></option>								
											</select>
										</div>
									</div>
								</div>	
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12">
									<div class="form-group">									
										<label class="col col-12"> <cf_get_lang dictionary_id='60498.Liste Tipi'></label>
										<div class="col col-12 col-xs-12">
											<select name="list_type" id="list_type" multiple style="height:65px;">
												<optgroup label="<cf_get_lang dictionary_id='60498.Liste Tipi'>"></optgroup>
												<option value="9" <cfif listfind(attributes.list_type,9)>selected</cfif>><cf_get_lang dictionary_id ='59007.IBAN No'></option>
												<option value="1" <cfif listfind(attributes.list_type,1)>selected</cfif>><cf_get_lang dictionary_id ='58552.Müşteri Değeri'></option>
												<option value="3" <cfif listfind(attributes.list_type,3)>selected</cfif>><cf_get_lang dictionary_id ='38844.Alış Ödeme Yöntemi'></option>
												<option value="4" <cfif listfind(attributes.list_type,4)>selected</cfif>><cf_get_lang dictionary_id ='38845.Satış Ödeme Yöntemi'></option>
												<option value="5" <cfif listfind(attributes.list_type,5)>selected</cfif>><cf_get_lang dictionary_id ='39976.İl Kodu'></option>
												<option value="6" <cfif listfind(attributes.list_type,6)>selected</cfif>><cf_get_lang dictionary_id ='57659.Satış Bölgesi'></option>
												<option value="10" <cfif listfind(attributes.list_type,10)>selected</cfif>><cf_get_lang_main no ='722.Mikro Bölge'></option>
												<option value="7" <cfif listfind(attributes.list_type,7)>selected</cfif>><cf_get_lang dictionary_id ='58795.Müşteri Temsilcisi'></option>
												<option value="8" <cfif listfind(attributes.list_type,8)>selected</cfif>><cf_get_lang dictionary_id ='57486.Kategori'></option>
											</select>
										</div>	
									</div>
									<div class="form-group">									
										<label class="col col-12" id="cat_" <cfif attributes.action_type eq 3>style="display:none;"</cfif>><cf_get_lang dictionary_id='58609.Üye Kategorisi'></label>
										<div class="col col-12 col-xs-12" id="comp_cat" <cfif attributes.action_type neq 1>style="display:none;"</cfif>>
											<select name="member_cat_type" id="member_cat_type" style="height:75px;" multiple>
												<cfoutput query="get_company_cat">
													<option value="#companycat_id#" <cfif listfind(attributes.member_cat_type,companycat_id)>selected</cfif>>&nbsp;#companycat#</option>
												</cfoutput>						
											</select>
										</div>
										<div class="col col-12" id="cons_cat" <cfif attributes.action_type neq 2>style="display:none;"</cfif>>
											<select name="consumer_cat_type" id="consumer_cat_type" multiple>
												<cfoutput query="get_consumer_cat">
													<option value="#conscat_id#" <cfif listfind(attributes.consumer_cat_type,conscat_id)>selected</cfif>>&nbsp;#conscat#</option>
												</cfoutput>						
											</select>
										</div>
									</div>	
									<div class="form-group">
										<div class="col col-12" id="department_sec3" <cfif attributes.action_type neq 3>style="display:none;"</cfif>><cf_get_lang dictionary_id='57453.Cari'></div>
										<div class="col col-12 col-xs-12" id="department_sec" <cfif attributes.action_type neq 3>style="display:none;"</cfif>>
											<select name="department_id" id="department_id" multiple style="width:150px; height:75px;">
												<cfoutput query="get_branch">
													<optgroup label="#branch_name#" <cfif branch_status neq 1>style="color:##FF0000"</cfif>>
													<cfquery name="get_dept" dbtype="query">
														SELECT * FROM get_department WHERE BRANCH_ID = #get_branch.branch_id[currentrow]#
													</cfquery>
													<cfif get_dept.recordcount>
														<cfloop from="1" to="#get_dept.recordcount#" index="s">
															<option <cfif get_dept.department_status neq 1>style="color:##FF0000"</cfif> value="#branch_id#-#get_dept.department_id[s]#" <cfif listfind(attributes.department_id,'#branch_id#-#get_dept.department_id[s]#',',')>selected</cfif>>&nbsp;&nbsp;#get_dept.department_head[s]#</option>
														</cfloop>
													</cfif>
													</optgroup>					  
												</cfoutput>
											</select>
										</div>		
									</div>	
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12">
									<div class="form-group">
										<label class="col col-12" ><cf_get_lang dictionary_id='57881.Vade Tarihi'></label>
										<div class="col col-6">
											<div class="input-group">
												<cfinput type="text" name="due_date1" id="due_date1" value="#dateformat(attributes.due_date1,dateformat_style)#" validate="#validate_style#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="due_date1"></span>
											</div>
										</div>
										<div class="col col-6">
											<div class="input-group">
												<cfinput type="text" name="due_date2" id="due_date2" value="#dateformat(attributes.due_date2,dateformat_style)#" validate="#validate_style#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="due_date2"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'>*</label>
										<div class="col col-6">
											<div class="input-group">
												<cfsavecontent variable="message1"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
												<cfinput type="text" name="action_date1" id="action_date1" value="#dateformat(attributes.action_date1,dateformat_style)#" validate="#validate_style#" message="#message1#" required="yes">
												<span class="input-group-addon"><cf_wrk_date_image date_field="action_date1"></span>
											</div>
										</div>
										<div class="col col-6">
											<div class="input-group">
												<cfsavecontent variable="message1"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
												<cfinput type="text" name="action_date2" id="action_date2" value="#dateformat(attributes.action_date2,dateformat_style)#" validate="#validate_style#" message="#message1#" required="yes">
												<span class="input-group-addon"><cf_wrk_date_image date_field="action_date2"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<div class="col col-12"></div>
										<div class="col col-12 col-xs-12">
											<label><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'><input name="action_type" id="action_type" type="radio" value="1" onclick="kontrol_display();" <cfif attributes.action_type eq 1>checked</cfif>></label>
											<label><cf_get_lang dictionary_id='29406.Bireysel Üyeler'><input name="action_type" id="action_type" type="radio" value="2" onclick="kontrol_display();" <cfif attributes.action_type eq 2>checked</cfif>></label>
											<label><cf_get_lang dictionary_id='58875.Çalışanlar'><input name="action_type" id="action_type" type="radio" value="3" onclick="kontrol_display();" <cfif attributes.action_type eq 3>checked</cfif>></label>
											<label><cf_get_lang dictionary_id='58785.Detaylı'><input type="checkbox" name="is_detail" id="is_detail" onclick="check_detail(0);" value="1" <cfif attributes.is_detail eq 1>checked</cfif>></label>
											<label><cf_get_lang dictionary_id='59153.Sıfır Bakiye Getirme'><input type="checkbox" name="zero_bakiye" id="zero_bakiye" <cfif isdefined('attributes.zero_bakiye')>checked</cfif>></label>
											<cfif session.ep.our_company_info.is_paper_closer eq 1>
												<label><cf_get_lang dictionary_id='38837.Manuel Ödeme Performansı'><input type="checkbox" name="is_manuel" id="is_manuel" value="1" <cfif isdefined("attributes.is_manuel")>checked</cfif>></label>
												<label><cf_get_lang dictionary_id='58828.Ay Bazında Grupla'><input type="checkbox" name="is_duedate_group" id="is_duedate_group" value="" <cfif isdefined("attributes.is_duedate_group")>checked</cfif>></label>	
											</cfif> 
											<label><cf_get_lang dictionary_id='57913.Ödenmemiş Çek/Senetleri Getirme'><input type="checkbox" name="is_pay_cheques" id="is_pay_cheques" <cfif isdefined('attributes.is_pay_cheques')>checked</cfif>></label>										
											<label><cf_get_lang dictionary_id='59191.Bitiş Tarihine Göre Hesapla'><input type="checkbox" name="is_finish_day" id="is_finish_day" <cfif isdefined('attributes.is_finish_day') and len(attributes.is_finish_day)>checked value="1"<cfelse>value="0"</cfif>></label>
											<label><cf_get_lang dictionary_id='58931.Proje Bazında Grupla'><input type="checkbox" name="is_project_group" id="is_project_group" value="1" <cfif isdefined("attributes.is_project_group")>checked</cfif>></label>
											<label><cf_get_lang dictionary_id='57795.İşlem Dövizli'><input type="checkbox" name="is_other_money_transfer" id="is_other_money_transfer" onclick="show_money_type();" value="1" <cfif isdefined("attributes.is_other_money_transfer")>checked</cfif>></label>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12" id="_money_type_label_" <cfif not isdefined("attributes.is_other_money_transfer")>style="display:none"</cfif>><cf_get_lang dictionary_id='57489.Para Birimi'></label>
										<div class="col col-12 col-xs-12" id="_money_type_" <cfif not isdefined("attributes.is_other_money_transfer")>style="display:none"</cfif>>
											<select name="money_type_info" id="money_type_info">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="get_money">
													<option value="#MONEY#" <cfif get_money.money eq attributes.money_type_info>selected</cfif>>#MONEY#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12" id="ch_type3_" <cfif attributes.action_type neq 3>style="display:none;"</cfif>><cf_get_lang dictionary_id='59132.Cari'></label>
										<div class="col col-12 col-xs-12" id="ch_type_" <cfif attributes.action_type neq 3>style="display:none;"</cfif>>
											<select name="employee_cat_type" id="employee_cat_type" multiple>
												<optgroup label="Cari Hesap Tipleri">
													<cfoutput query="get_all_ch_type">
														<option value="#acc_type_id#" <cfif listfind(attributes.employee_cat_type,acc_type_id)>selected</cfif>>&nbsp;#acc_type_name#</option>
													</cfoutput>
												</optgroup>	
											</select>	
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
						<label id='is_excel_display' <cfif attributes.is_detail eq 1>style="display:none;"</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
							<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
						<cfelse>
							<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer"  onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">
						</cfif>
						<input name="form_submitted" id="form_submitted" value="1" type="hidden">
						<cf_wrk_report_search_button search_function='kontrol()' button_type='1' is_excel='1'>
						</div>
					</div>
				</div>
			</div>
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
</cfif>
<cfif isdefined('attributes.is_excel') and listfind('1,2',attributes.is_excel)>
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=get_comp_remainder_main.recordcount>
</cfif>
<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
<cfset filename="collacted_make_age_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
<cfheader name="Expires" value="#Now()#">
<cfcontent type="application/vnd.msexcel;charset=utf-16">
<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
<meta http-equiv="content-type" content="text/plain; charset=utf-16">
<cfset type_ = 1>
<cfelse>
	<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.form_submitted")>
<cf_report_list>		
		<cfif attributes.is_detail neq 1 or(attributes.is_detail eq 1 and attributes.detail_type eq 4)>
			<thead>
                <tr>
                    <cfif attributes.is_detail neq 1>							
                        <th><cf_get_lang dictionary_id ='57558.Üye No'></th>
                        <th><cf_get_lang dictionary_id ='57519.Cari Hesap'></th>
                        <cfif listfind(attributes.list_type,9)>
                        	<th><cf_get_lang dictionary_id='59007.IBAN No'></th>
                        </cfif>
                        <cfif attributes.action_type neq 3 and listfind(attributes.list_type,1)>
                        	<th><cf_get_lang dictionary_id='58552.Müşteri Değeri'></th>
                        </cfif>
                        <cfif isdefined("attributes.is_project_group")> 
                            <th><cf_get_lang dictionary_id ='57416.Proje'></th>
                        </cfif>
                        <cfif attributes.action_type neq 3>
							<cfif listfind(attributes.list_type,3)>
								<th><cf_get_lang dictionary_id ='38844.Alış Ödeme Yöntemi'></th>
							</cfif>
							<cfif listfind(attributes.list_type,4)>
								<th><cf_get_lang dictionary_id ='38845.Satış Ödeme Yöntemi'></th>
							</cfif>
							<cfif listfind(attributes.list_type,5)>
								<th><cf_get_lang dictionary_id ='39976.İl Kodu'></th>
							</cfif>
							<cfif listfind(attributes.list_type,6)>
								<th><cf_get_lang dictionary_id ='57659.Satış Bölgesi'></th>
							</cfif>
							<cfif listfind(attributes.list_type,10)>
								<th><cf_get_lang_main no ='722.Mikro Bölge'></th>
							</cfif>
							<cfif listfind(attributes.list_type,7)>
								<th><cf_get_lang dictionary_id='58795.Müşteri Temsilcisi'></th>
							</cfif>
							<cfif listfind(attributes.list_type,8)>
								<th><cf_get_lang dictionary_id='57486.Kategori'></th>
							</cfif>
                        </cfif>
						<th ><cf_get_lang dictionary_id ='57587.Borc'></th>
						<th><cf_get_lang dictionary_id ='57588.Alacak'></th>
                        <th><cf_get_lang dictionary_id ='57589.Bakiye'></th>
                        <th><cf_get_lang dictionary_id='29683.B/A'></th>
                        <cfif isdefined("attributes.is_other_money_transfer")>
                            <th><cf_get_lang dictionary_id ='58121.İşlem Dövizi'></th>
                        </cfif>
                         <th><cf_get_lang dictionary_id ='40033.İşlem Tarihi Ortalaması'></th>
                         <th><cf_get_lang dictionary_id ='57490.Gun'></th>
                         <th><cf_get_lang dictionary_id ='40034.Vade Tarihi Ortalaması'></th>
                         <th><cf_get_lang dictionary_id ='57490.Gun'></th>
                    <cfelse>
                         <th><cf_get_lang dictionary_id ='57558.Üye No'></th>
                         <th><cf_get_lang dictionary_id ='57519.Cari Hesap'></th>
                         <th><cf_get_lang dictionary_id ='58121.İşlem Dövizi'></th>
                         <cfoutput>
                             <th>#session.ep.money# <cf_get_lang dictionary_id ='57673.Tutar'></th>
                             <th><cf_get_lang dictionary_id ='39655.İşlem Dövizi Tutar'></th>
                             <th>#session.ep.money# <cf_get_lang dictionary_id ='59193.Karşılık'></th>
                             <th><cf_get_lang dictionary_id ='59194.Alınan Kur Farkları'></th>
                             <th><cf_get_lang dictionary_id ='59195.Verilen Kur Farkları'></th>
                             <th><cf_get_lang dictionary_id ='59196.Alacak Kur Dekontları'></th>
                             <th><cf_get_lang dictionary_id ='59197.Borç Kur Dekontları'></th>
                             <th><cf_get_lang dictionary_id ='59198.Alınması Gereken Kur Farkı'></th>
                             <th><cf_get_lang dictionary_id ='59199.Kesilmesi Gereken Kur Farkı'></th>
                         </cfoutput>
                        <cfif attributes.is_excel neq 1 and attributes.is_excel neq 2>
                            <th></th>
                        </cfif>
                    </cfif>
                </tr>
            </thead>
		</cfif>
		<cfquery name="GET_HIERARCHIES" datasource="#DSN#">
			SELECT
				DISTINCT
				SZ_HIERARCHY
			FROM
				SALES_ZONES_ALL_1
			WHERE
				POSITION_CODE = #session.ep.position_code#
		</cfquery>
		<cfset row_block = 500>
		<cfif isDefined("attributes.action_date2") and len(attributes.action_date2) and attributes.action_date2 lt now()>
			<cfset new_date = attributes.action_date2>
		<cfelse>
			<cfif session.ep.period_year lt year(now())>
				<cfset new_date = createodbcdatetime('31/12/#session.ep.period_year#')>
			<cfelse>
				<cfset new_date = now()>
			</cfif>
		</cfif> 
		<cfif listlen(attributes.employee_id,'_') eq 2>
			<cfset employee_type_id = listlast(attributes.employee_id,'_')>
			<cfset attributes.employee_id = listfirst(attributes.employee_id,'_')>
		<cfelse>
			<cfset employee_type_id = ''>
		</cfif>
		<!--- kurumsal uyeler --->
		<cfif attributes.action_type eq 1>
			<cfquery name="GET_COMP_REMAINDER_MAIN" datasource="#dsn2#">
				SELECT 
                    CB.COMPANY_IBAN_CODE AS IBAN_CODE,
                    EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME EMPLOYEE,
                    WEB.POSITION_CODE,
					C.COMPANY_ID,
					MEMBER_CODE ,
					C.FULLNAME,
					C.CITY,
					C.SALES_COUNTY,
					C.IMS_CODE_ID,
					CC.COMPANYCAT,
					C.COMPANY_VALUE_ID AS VALUE_ID,
					ISNULL((SELECT TOP 1 PAYMETHOD_ID FROM #dsn_alias#.COMPANY_CREDIT CCC WHERE CCC.COMPANY_ID = C.COMPANY_ID AND CCC.OUR_COMPANY_ID = #session.ep.company_id#),0) AS PAY_METHOD,
					ISNULL((SELECT TOP 1 REVMETHOD_ID FROM #dsn_alias#.COMPANY_CREDIT CCC WHERE CCC.COMPANY_ID = C.COMPANY_ID AND CCC.OUR_COMPANY_ID = #session.ep.company_id#),0) AS REV_METHOD
					<cfif isdefined("attributes.is_project_group")>
						,CR.PROJECT_ID
						,(SELECT PP.PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS PP WHERE PP.PROJECT_ID = CR.PROJECT_ID) PROJECT_HEAD
					<cfelse>
						,'' PROJECT_ID
						,'' PROJECT_HEAD
					</cfif>
					<cfif isDefined("attributes.is_other_money_transfer")>
						,OTHER_MONEY MONEY
					<cfelse>
						,'#session.ep.money#' AS MONEY
					</cfif>
					,(
					SELECT
						ISNULL(SUM(CRNEW.ACTION_VALUE),0)
					FROM
						CARI_ROWS CRNEW
					WHERE
						CRNEW.FROM_CMP_ID = C.COMPANY_ID AND
						CRNEW.ACTION_TYPE_ID = 49 
						<cfif isDefined("attributes.is_other_money_transfer")>
							AND CRNEW.OTHER_MONEY = CR.OTHER_MONEY
							<cfif len(attributes.money_type_info)>
								AND CRNEW.OTHER_MONEY = '#attributes.money_type_info#'
							</cfif>
						</cfif>
						<cfif isdefined("attributes.is_project_group")>
							AND CRNEW.PROJECT_ID = CR.PROJECT_ID
						</cfif>
						<cfif session.ep.isBranchAuthorization>
							AND	(CRNEW.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CRNEW.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
						</cfif>
					) TAKEN_INV_RATES
					,(
					SELECT
						ISNULL(SUM(CRNEW.ACTION_VALUE),0)
					FROM
						CARI_ROWS CRNEW
					WHERE
						CRNEW.TO_CMP_ID = C.COMPANY_ID AND
						CRNEW.ACTION_TYPE_ID = 48
						<cfif isDefined("attributes.is_other_money_transfer")>
							AND CRNEW.OTHER_MONEY = CR.OTHER_MONEY
							<cfif len(attributes.money_type_info)>
								AND CRNEW.OTHER_MONEY = '#attributes.money_type_info#'
							</cfif>
						</cfif>
						<cfif session.ep.isBranchAuthorization>
							AND	(CRNEW.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CRNEW.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
						</cfif>
						<cfif isdefined("attributes.is_project_group")>
							AND CRNEW.PROJECT_ID = CR.PROJECT_ID
						</cfif>
					) GIVEN_INV_RATES
					,(
					SELECT
						ISNULL(SUM(CRNEW.ACTION_VALUE),0)
					FROM
						CARI_ROWS CRNEW
					WHERE
						CRNEW.FROM_CMP_ID = C.COMPANY_ID AND
						CRNEW.ACTION_TYPE_ID = 46
						<cfif isDefined("attributes.is_other_money_transfer")>
							AND CRNEW.OTHER_MONEY = CR.OTHER_MONEY
							<cfif len(attributes.money_type_info)>
								AND CRNEW.OTHER_MONEY = '#attributes.money_type_info#'
							</cfif>
						</cfif>
						<cfif isdefined("attributes.is_project_group")>
							AND CRNEW.PROJECT_ID = CR.PROJECT_ID
						</cfif>
						<cfif session.ep.isBranchAuthorization>
							AND	(CRNEW.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CRNEW.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
						</cfif>
					) CLAIM_RATES
					,(
					SELECT
						ISNULL(SUM(CRNEW.ACTION_VALUE),0)
					FROM
						CARI_ROWS CRNEW
					WHERE
						CRNEW.TO_CMP_ID = C.COMPANY_ID AND
						CRNEW.ACTION_TYPE_ID = 45
						<cfif isDefined("attributes.is_other_money_transfer")>
							AND CRNEW.OTHER_MONEY = CR.OTHER_MONEY
							<cfif len(attributes.money_type_info)>
								AND CRNEW.OTHER_MONEY = '#attributes.money_type_info#'
							</cfif>
						</cfif>
						<cfif session.ep.isBranchAuthorization>
							AND	(CRNEW.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CRNEW.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
						</cfif>
						<cfif isdefined("attributes.is_project_group")>
							AND CRNEW.PROJECT_ID = CR.PROJECT_ID
						</cfif>
					) DEBT_RATES,
					0 ACC_TYPE_ID,
					'' ACC_TYPE_NAME,
                    <!--- borc/alacak tutarlari company --->
					<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1) and isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                        (SELECT
                            <cfif isDefined("attributes.is_other_money_transfer")>
                                ISNULL(SUM(CARI_ROWS.OTHER_CASH_ACT_VALUE),0)
                            <cfelse>
                                ISNULL(SUM(CARI_ROWS.ACTION_VALUE),0)
                            </cfif>
                        FROM
                            CARI_ROWS
                        WHERE
                            CARI_ROWS.TO_CMP_ID = C.COMPANY_ID AND
                            CARI_ROWS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#"> AND CARI_ROWS.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                            <cfif isDefined("attributes.is_other_money_transfer")>
                            	AND CARI_ROWS.OTHER_MONEY = CR.OTHER_MONEY
                            </cfif>
                            <cfif isDefined("attributes.due_date2") and isdate(attributes.due_date2) and isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
                                AND CARI_ROWS.DUE_DATE BETWEEN #attributes.due_date1# AND #attributes.due_date2#
                            <cfelseif isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
                                AND CARI_ROWS.DUE_DATE >= #attributes.due_date1#
                            <cfelseif isDefined("attributes.due_date2") and isdate(attributes.due_date2)>
                                AND CARI_ROWS.DUE_DATE <= #attributes.due_date2#
							</cfif>
							<cfif session.ep.isBranchAuthorization>
								AND	(CARI_ROWS.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CARI_ROWS.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
							</cfif>
                            <cfif isdefined("attributes.is_pay_cheques")>
                                AND
                                (
                                    (	
                                        CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR
                                    (	
                                        CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE <= #new_date#)
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR 
                                    (
                                        CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR 
                                    (
                                        CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE <= #new_date#)
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR 
                                    (
                                        CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
                                        AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
                                                AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                )
                            </cfif>
                        ) BORC,
                        (SELECT
                        	<cfif isDefined("attributes.is_other_money_transfer")>
                            	ISNULL(SUM(CARI_ROWS.OTHER_CASH_ACT_VALUE),0)
                            <cfelse>
                            	ISNULL(SUM(CARI_ROWS.ACTION_VALUE),0)
                            </cfif>
                        FROM
                            CARI_ROWS
                        WHERE
                            CARI_ROWS.FROM_CMP_ID = C.COMPANY_ID AND
                            CARI_ROWS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#"> AND CARI_ROWS.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                            <cfif isDefined("attributes.is_other_money_transfer")>
                            	AND CARI_ROWS.OTHER_MONEY = CR.OTHER_MONEY
                            </cfif>
                            <cfif isDefined("attributes.due_date2") and isdate(attributes.due_date2) and isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
                                AND CARI_ROWS.DUE_DATE BETWEEN #attributes.due_date1# AND #attributes.due_date2#
                            <cfelseif isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
                                AND CARI_ROWS.DUE_DATE >= #attributes.due_date1#
                            <cfelseif isDefined("attributes.due_date2") and isdate(attributes.due_date2)>
                                AND CARI_ROWS.DUE_DATE <= #attributes.due_date2#
							</cfif>
							<cfif session.ep.isBranchAuthorization>
								AND	(CARI_ROWS.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CARI_ROWS.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
							</cfif>
                            <cfif isdefined("attributes.is_pay_cheques")>
                                AND
                                (
                                    (	
                                        CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR
                                    (	
                                        CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE <= #new_date#)
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR 
                                    (
                                        CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR 
                                    (
                                        CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE <= #new_date#)
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR 
                                    (
                                        CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
                                        AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
                                                AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                )
                            </cfif>
                        ) ALACAK
                    </cfif>
				FROM 
					<cfif isdefined("attributes.is_project_group")>
						<cfif isDefined("attributes.is_other_money_transfer")>
							COMPANY_REMAINDER_MONEY_PROJECT CR,
						<cfelse>
							COMPANY_REMAINDER_PROJECT  CR,
						</cfif>
					<cfelse>
						<cfif isDefined("attributes.is_other_money_transfer")>
							COMPANY_REMAINDER_MONEY CR,
						<cfelse>
							COMPANY_REMAINDER CR,
						</cfif>
					</cfif>
					#dsn_alias#.COMPANY C 
					LEFT JOIN #dsn_alias#.WORKGROUP_EMP_PAR WEB 
						ON WEB.COMPANY_ID = C.COMPANY_ID 
						AND WEB.COMPANY_ID IS NOT NULL 
						AND WEB.OUR_COMPANY_ID = #session.ep.company_id#
						AND WEB.IS_MASTER = 1
					LEFT JOIN #dsn_alias#.EMPLOYEE_POSITIONS EP ON WEB.POSITION_CODE = EP.POSITION_CODE
                    LEFT JOIN #dsn_alias#.COMPANY_CAT CC ON C.COMPANYCAT_ID = CC.COMPANYCAT_ID
                    LEFT JOIN #dsn_alias#.COMPANY_BANK CB ON CB.COMPANY_ID=C.COMPANY_ID AND COMPANY_ACCOUNT_DEFAULT=1
				WHERE 
					C.COMPANY_ID = CR.COMPANY_ID  
					<cfif isdefined("attributes.is_detail") and attributes.detail_type eq 4>
						AND CR.OTHER_MONEY <> '#session.ep.money#'
					</cfif>
					<cfif isdefined("attributes.zero_bakiye") and isdefined("attributes.action_date1") and isdate(attributes.action_date1) and isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
						AND C.COMPANY_ID IN (SELECT CRT.COMPANY_ID FROM CARI_ROWS_TOPLAM CRT WHERE CRT.COMPANY_ID = C.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#"> AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#"> GROUP BY CRT.COMPANY_ID HAVING ROUND(SUM(CRT.BORC-CRT.ALACAK),2) <> 0)
                        <cfif isDefined("attributes.is_other_money_transfer")>
	                        AND OTHER_MONEY IN (SELECT OTHER_MONEY FROM CARI_ROWS_TOPLAM CRT WHERE CRT.COMPANY_ID = C.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#"> AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#"> GROUP BY CRT.COMPANY_ID,OTHER_MONEY HAVING ROUND(SUM(CRT.BORC2-CRT.ALACAK2),2) <> 0) 
                        </cfif>
					<cfelse>
						AND C.COMPANY_ID IN
						(
								SELECT 
									ISNULL(FROM_CMP_ID,TO_CMP_ID)
								FROM
									CARI_ROWS
								WHERE
									ISNULL(FROM_CMP_ID,TO_CMP_ID)=C.COMPANY_ID
									<cfif session.ep.isBranchAuthorization>
										AND	(CARI_ROWS.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CARI_ROWS.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
									</cfif>
								<cfif isdefined("attributes.is_pay_cheques")>
									AND
									(
										(	
											CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
											AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
											<cfif is_make_age_date>
												<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
													AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
												</cfif>
												<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
													AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
												</cfif>
											</cfif>
										)
										OR
										(	
											CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
											AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE <= #new_date#)
											<cfif is_make_age_date>
												<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
													AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
												</cfif>
												<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
													AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
												</cfif>
											</cfif>
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
											AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
											<cfif is_make_age_date>
												<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
													AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
												</cfif>
												<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
													AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
												</cfif>
											</cfif>
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
											AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE <= #new_date#)
											<cfif is_make_age_date>
												<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
													AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
												</cfif>
												<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
													AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
												</cfif>
											</cfif>
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
											AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
											<cfif is_make_age_date>
												<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
													AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
												</cfif>
												<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
													AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
												</cfif>
											</cfif>
										)
									)
								<cfelse>
									<cfif is_make_age_date>
										<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
											AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
										</cfif>
										<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
											AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
										</cfif>
									</cfif>
								</cfif>
						)
					</cfif>
					<cfif len(attributes.member_cat_type)>
						AND C.COMPANYCAT_ID IN(#attributes.member_cat_type#)
					</cfif>
					<cfif len(attributes.zone_id)>
						AND C.SALES_COUNTY = #attributes.zone_id#
					</cfif>
					<cfif len(attributes.pos_code) and len(attributes.pos_code_text)>
						AND C.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID= #session.ep.company_id#)
					</cfif>
					<cfif isdefined("attributes.is_project_group")>
						<cfif len(attributes.project_id)>
							AND CR.PROJECT_ID = #attributes.project_id#
						</cfif>
					</cfif>
					<cfif isDefined("attributes.is_other_money_transfer")>
						<cfif len(attributes.money_type_info)>
							AND CR.OTHER_MONEY = '#attributes.money_type_info#'
						</cfif>
					</cfif>
					<cfif len(attributes.duty_claim) and attributes.duty_claim eq 1>
						AND <cfif isDefined("attributes.is_other_money_transfer")>CR.BAKIYE3 > 0<cfelse>CR.BAKIYE > 0</cfif>
					<cfelseif len(attributes.duty_claim) and attributes.duty_claim eq 2>
						AND <cfif isDefined("attributes.is_other_money_transfer")>CR.BAKIYE3 <= 0<cfelse>CR.BAKIYE <= 0</cfif>
					</cfif>
					<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
						AND C.COMPANY_VALUE_ID = #attributes.customer_value#
					</cfif>
					<cfif isdefined("attributes.company") and len(attributes.company) and len(attributes.company_id)>
						AND C.COMPANY_ID = #attributes.company_id#
					</cfif>
					<cfif isdefined("attributes.company") and len(attributes.company) and len(attributes.consumer_id)>
						AND 1 = 0
					</cfif>
					<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 1>
						AND C.IS_BUYER = 1
					<cfelseif isdefined("attributes.buy_status") and attributes.buy_status eq 2>
						AND C.IS_SELLER= 1
					<cfelseif isdefined("attributes.buy_status") and attributes.buy_status eq 3>
						AND C.ISPOTANTIAL= 1
					</cfif>
					<cfif session.ep.our_company_info.sales_zone_followup eq 1>
						<!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
						AND 
						(
							C.IMS_CODE_ID IN (
												SELECT
													IMS_ID
												FROM
													#dsn_alias#.SALES_ZONES_ALL_2
												WHERE
													POSITION_CODE = #session.ep.position_code# 
											 )
						<!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
						<cfif get_hierarchies.recordcount>
							OR C.IMS_CODE_ID IN (
												SELECT
													IMS_ID
												FROM
													#dsn_alias#.SALES_ZONES_ALL_1
												WHERE											
													<cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
														<cfset start_row=(page_stock*row_block)+1>	
														<cfset end_row=start_row+(row_block-1)>
														<cfif (end_row) gte get_hierarchies.recordcount>
															<cfset end_row=get_hierarchies.recordcount>
														</cfif>
															(
															<cfloop index="add_stock" from="#start_row#" to="#end_row#">
																<cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy[add_stock]#%'
															</cfloop>
															
															)<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
													</cfloop>											
											)
						  </cfif>
						 )
					</cfif>			
				ORDER BY
					C.FULLNAME
					<cfif isDefined("attributes.is_other_money_transfer")>
						,OTHER_MONEY
					</cfif>
			</cfquery>
		<!--- bireysel uyeler --->
		<cfelseif attributes.action_type eq 2>
			<cfquery name="GET_COMP_REMAINDER_MAIN" datasource="#dsn2#">
				SELECT 
					C.CONSUMER_ID AS COMPANY_ID,
                    EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME EMPLOYEE,
                    WEB.POSITION_CODE,
                    CB.CONSUMER_IBAN_CODE AS IBAN_CODE,
					MEMBER_CODE ,
					C.CONSUMER_NAME + ' ' +C.CONSUMER_SURNAME FULLNAME,
					(SELECT PLATE_CODE FROM #dsn_alias#.SETUP_CITY WHERE CITY_ID = C.WORK_CITY_ID) CITY,
					C.SALES_COUNTY,
					C.IMS_CODE_ID,
					CC.CONSCAT COMPANYCAT,
					C.CUSTOMER_VALUE_ID AS VALUE_ID,
					ISNULL((SELECT TOP 1 PAYMETHOD_ID FROM #dsn_alias#.COMPANY_CREDIT CCC WHERE CCC.CONSUMER_ID = C.CONSUMER_ID AND CCC.OUR_COMPANY_ID = #session.ep.company_id#),0) AS PAY_METHOD,
					ISNULL((SELECT TOP 1 REVMETHOD_ID FROM #dsn_alias#.COMPANY_CREDIT CCC WHERE CCC.CONSUMER_ID = C.CONSUMER_ID AND CCC.OUR_COMPANY_ID = #session.ep.company_id#),0) AS REV_METHOD
					<cfif isdefined("attributes.is_project_group")>
						,CR.PROJECT_ID
						,(SELECT PP.PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS PP WHERE PP.PROJECT_ID = CR.PROJECT_ID) PROJECT_HEAD
					<cfelse>
						,'' PROJECT_ID
						,'' PROJECT_HEAD
					</cfif>
					<cfif isDefined("attributes.is_other_money_transfer")>
						,OTHER_MONEY MONEY
					<cfelse>
						,'#session.ep.money#' AS MONEY
					</cfif>
					,(
					SELECT
						ISNULL(SUM(CRNEW.ACTION_VALUE),0)
					FROM
						CARI_ROWS CRNEW
					WHERE
						CRNEW.FROM_CONSUMER_ID = C.CONSUMER_ID AND
						CRNEW.ACTION_TYPE_ID = 49
						<cfif isDefined("attributes.is_other_money_transfer")>
							AND CRNEW.OTHER_MONEY = CR.OTHER_MONEY
							<cfif len(attributes.money_type_info)>
								AND CRNEW.OTHER_MONEY = '#attributes.money_type_info#'
							</cfif>
						</cfif>
						<cfif session.ep.isBranchAuthorization>
							AND	(CRNEW.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CRNEW.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
						</cfif>
						<cfif isdefined("attributes.is_project_group")>
							AND CRNEW.PROJECT_ID = CR.PROJECT_ID
						</cfif>
					) TAKEN_INV_RATES
					,(
					SELECT
						ISNULL(SUM(CRNEW.ACTION_VALUE),0)
					FROM
						CARI_ROWS CRNEW
					WHERE
						CRNEW.TO_CONSUMER_ID = C.CONSUMER_ID AND
						CRNEW.ACTION_TYPE_ID = 48
						<cfif isDefined("attributes.is_other_money_transfer")>
							AND CRNEW.OTHER_MONEY = CR.OTHER_MONEY
							<cfif len(attributes.money_type_info)>
								AND CRNEW.OTHER_MONEY = '#attributes.money_type_info#'
							</cfif>
						</cfif>
						<cfif session.ep.isBranchAuthorization>
							AND	(CRNEW.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CRNEW.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
						</cfif>
						<cfif isdefined("attributes.is_project_group")>
							AND CRNEW.PROJECT_ID = CR.PROJECT_ID
						</cfif>
					) GIVEN_INV_RATES
					,(
					SELECT
						ISNULL(SUM(CRNEW.ACTION_VALUE),0)
					FROM
						CARI_ROWS CRNEW
					WHERE
						CRNEW.FROM_CONSUMER_ID = C.CONSUMER_ID AND
						CRNEW.ACTION_TYPE_ID = 46
						<cfif isDefined("attributes.is_other_money_transfer")>
							AND CRNEW.OTHER_MONEY = CR.OTHER_MONEY
							<cfif len(attributes.money_type_info)>
								AND CRNEW.OTHER_MONEY = '#attributes.money_type_info#'
							</cfif>
						</cfif>
						<cfif session.ep.isBranchAuthorization>
							AND	(CRNEW.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CRNEW.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
						</cfif>
						<cfif isdefined("attributes.is_project_group")>
							AND CRNEW.PROJECT_ID = CR.PROJECT_ID
						</cfif>
					) CLAIM_RATES
					,(
					SELECT
						ISNULL(SUM(CRNEW.ACTION_VALUE),0)
					FROM
						CARI_ROWS CRNEW
					WHERE
						CRNEW.TO_CONSUMER_ID = C.CONSUMER_ID AND
						CRNEW.ACTION_TYPE_ID = 45
						<cfif isDefined("attributes.is_other_money_transfer")>
							AND CRNEW.OTHER_MONEY = CR.OTHER_MONEY
							<cfif len(attributes.money_type_info)>
								AND CRNEW.OTHER_MONEY = '#attributes.money_type_info#'
							</cfif>
						</cfif>
						<cfif session.ep.isBranchAuthorization>
							AND	(CRNEW.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CRNEW.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
						</cfif>
						<cfif isdefined("attributes.is_project_group")>
							AND CRNEW.PROJECT_ID = CR.PROJECT_ID
						</cfif>
					) DEBT_RATES,
					0 ACC_TYPE_ID,
					'' ACC_TYPE_NAME,
                    <!--- borc/alacak tutarlari consumer --->
					<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1) and isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                        (SELECT
                            <cfif isDefined("attributes.is_other_money_transfer")>
                                ISNULL(SUM(CARI_ROWS.OTHER_CASH_ACT_VALUE),0)
                            <cfelse>
                                ISNULL(SUM(CARI_ROWS.ACTION_VALUE),0)
                            </cfif>
                        FROM
                            CARI_ROWS
                        WHERE
                            CARI_ROWS.TO_CONSUMER_ID = C.CONSUMER_ID AND
                            CARI_ROWS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#"> AND CARI_ROWS.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                            <cfif isDefined("attributes.is_other_money_transfer")>
                            	AND CARI_ROWS.OTHER_MONEY = CR.OTHER_MONEY
                            </cfif>
                            <cfif isDefined("attributes.due_date2") and isdate(attributes.due_date2) and isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
                                AND CARI_ROWS.DUE_DATE BETWEEN #attributes.due_date1# AND #attributes.due_date2#
                            <cfelseif isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
                                AND CARI_ROWS.DUE_DATE >= #attributes.due_date1#
                            <cfelseif isDefined("attributes.due_date2") and isdate(attributes.due_date2)>
                                AND CARI_ROWS.DUE_DATE <= #attributes.due_date2#
							</cfif>
							<cfif session.ep.isBranchAuthorization>
								AND	(CARI_ROWS.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CARI_ROWS.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
							</cfif>
                            <cfif isdefined("attributes.is_pay_cheques")>
                                AND
                                (
                                    (	
                                        CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR
                                    (	
                                        CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE <= #new_date#)
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR 
                                    (
                                        CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR 
                                    (
                                        CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE <= #new_date#)
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR 
                                    (
                                        CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
                                        AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
                                                AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                )
                            </cfif>
                        ) BORC,
                        (SELECT
                        	<cfif isDefined("attributes.is_other_money_transfer")>
                            	ISNULL(SUM(CARI_ROWS.OTHER_CASH_ACT_VALUE),0)
                            <cfelse>
                            	ISNULL(SUM(CARI_ROWS.ACTION_VALUE),0)
                            </cfif>
                        FROM
                            CARI_ROWS
                        WHERE
                            CARI_ROWS.FROM_CONSUMER_ID = C.CONSUMER_ID AND
                            CARI_ROWS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#"> AND CARI_ROWS.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                            <cfif isDefined("attributes.is_other_money_transfer")>
                            	AND CARI_ROWS.OTHER_MONEY = CR.OTHER_MONEY
							</cfif>
							<cfif session.ep.isBranchAuthorization>
								AND	(CARI_ROWS.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CARI_ROWS.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
							</cfif>
                            <cfif isDefined("attributes.due_date2") and isdate(attributes.due_date2) and isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
                                AND CARI_ROWS.DUE_DATE BETWEEN #attributes.due_date1# AND #attributes.due_date2#
                            <cfelseif isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
                                AND CARI_ROWS.DUE_DATE >= #attributes.due_date1#
                            <cfelseif isDefined("attributes.due_date2") and isdate(attributes.due_date2)>
                                AND CARI_ROWS.DUE_DATE <= #attributes.due_date2#
                            </cfif>
                            <cfif isdefined("attributes.is_pay_cheques")>
                                AND
                                (
                                    (	
                                        CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR
                                    (	
                                        CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE <= #new_date#)
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR 
                                    (
                                        CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR 
                                    (
                                        CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE <= #new_date#)
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR 
                                    (
                                        CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
                                        AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
                                                AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                )
                            </cfif>
                        ) ALACAK
                    </cfif>
				FROM 
					<cfif isdefined("attributes.is_project_group")>
						<cfif isDefined("attributes.is_other_money_transfer")>
							CONSUMER_REMAINDER_MONEY_PROJECT CR,
						<cfelse>
							CONSUMER_REMAINDER_PROJECT  CR,
						</cfif>
					<cfelse>
						<cfif isDefined("attributes.is_other_money_transfer")>
							CONSUMER_REMAINDER_MONEY CR,
						<cfelse>
							CONSUMER_REMAINDER CR,
						</cfif>
					</cfif>
					#dsn_alias#.CONSUMER C
					LEFT JOIN #dsn_alias#.WORKGROUP_EMP_PAR WEB 
						ON WEB.CONSUMER_ID = C.CONSUMER_ID 
						AND WEB.CONSUMER_ID IS NOT NULL 
						AND WEB.OUR_COMPANY_ID = #session.ep.company_id#
						AND WEB.IS_MASTER = 1
					LEFT JOIN #dsn_alias#.EMPLOYEE_POSITIONS EP ON WEB.POSITION_CODE = EP.POSITION_CODE
					LEFT JOIN #dsn_alias#.CONSUMER_CAT CC ON C.CONSUMER_CAT_ID = CC.CONSCAT_ID
                    LEFT JOIN #dsn_alias#.CONSUMER_BANK CB ON CB.CONSUMER_ID=C.CONSUMER_ID AND CONSUMER_ACCOUNT_DEFAULT=1
				WHERE 
					C.CONSUMER_ID = CR.CONSUMER_ID 
					AND LEN(MEMBER_CODE) > 0
					<cfif isdefined("attributes.is_detail") and attributes.detail_type eq 4>
						AND CR.OTHER_MONEY <> '#session.ep.money#'
					</cfif>
					<cfif isdefined("attributes.zero_bakiye") and isdefined("attributes.action_date1") and isdate(attributes.action_date1) and isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
						AND C.CONSUMER_ID IN(SELECT CRT.CONSUMER_ID FROM CARI_ROWS_CONSUMER CRT WHERE CRT.CONSUMER_ID = C.CONSUMER_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#"> AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#"> GROUP BY CRT.CONSUMER_ID HAVING ROUND(SUM(CRT.BORC-CRT.ALACAK),2) <> 0) 
					    <cfif isDefined("attributes.is_other_money_transfer")>
	                        AND OTHER_MONEY IN (SELECT OTHER_MONEY FROM CARI_ROWS_CONSUMER CRT WHERE CRT.CONSUMER_ID = C.CONSUMER_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#"> AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#"> GROUP BY CRT.CONSUMER_ID,OTHER_MONEY HAVING ROUND(SUM(CRT.BORC2-CRT.ALACAK2),2) <> 0) 
                        </cfif>
                    <cfelse>
						AND C.CONSUMER_ID IN
						(
							SELECT 
								ISNULL(FROM_CONSUMER_ID,TO_CONSUMER_ID)
							FROM
								CARI_ROWS
							WHERE
								ISNULL(FROM_CONSUMER_ID,TO_CONSUMER_ID)=C.CONSUMER_ID
								<cfif session.ep.isBranchAuthorization>
									AND	(CARI_ROWS.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CARI_ROWS.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
								</cfif>
								<cfif isdefined("attributes.is_pay_cheques")>
									AND
									(
										(	
											CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
											AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
											<cfif is_make_age_date>
												<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
													AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
												</cfif>
												<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
													AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
												</cfif>
											</cfif>
										)
										OR
										(	
											CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
											AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE <= #new_date#)
											<cfif is_make_age_date>
												<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
													AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
												</cfif>
												<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
													AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
												</cfif>
											</cfif>
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
											AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
											<cfif is_make_age_date>
												<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
													AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
												</cfif>
												<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
													AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
												</cfif>
											</cfif>
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
											AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE <= #new_date#)
											<cfif is_make_age_date>
												<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
													AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
												</cfif>
												<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
													AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
												</cfif>
											</cfif>
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
											AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
											<cfif is_make_age_date>
												<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
													AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
												</cfif>
												<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
													AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
												</cfif>
											</cfif>
										)
									)
								<cfelse>
									<cfif is_make_age_date>
										<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
											AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
										</cfif>
										<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
											AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
										</cfif>
									</cfif>
								</cfif>
						)
					</cfif>
					<cfif len(attributes.consumer_cat_type)>
						AND C.CONSUMER_CAT_ID IN(#attributes.consumer_cat_type#)
					</cfif>
					<cfif len(attributes.zone_id)>
						AND C.SALES_COUNTY = #attributes.zone_id#
					</cfif>
					<cfif len(attributes.pos_code) and len(attributes.pos_code_text)>
						AND C.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID= #session.ep.company_id#)
					</cfif>
					<cfif isdefined("attributes.is_project_group")>
						<cfif len(attributes.project_id)>
							AND CR.PROJECT_ID = #attributes.project_id#
						</cfif>
					</cfif>
					<cfif isdefined("attributes.company") and len(attributes.company) and len(attributes.company_id)>
						AND 1 = 0
					</cfif>
					<cfif isdefined("attributes.company") and len(attributes.company) and len(attributes.consumer_id)>
						AND C.CONSUMER_ID = #attributes.consumer_id#
					</cfif>
					<cfif isDefined("attributes.is_other_money_transfer")>
						<cfif len(attributes.money_type_info)>
							AND CR.OTHER_MONEY = '#attributes.money_type_info#'
						</cfif>
					</cfif>
					<cfif len(attributes.duty_claim) and attributes.duty_claim eq 1>
						AND <cfif isDefined("attributes.is_other_money_transfer")>CR.BAKIYE3 > 0<cfelse>CR.BAKIYE > 0</cfif>
					<cfelseif len(attributes.duty_claim) and attributes.duty_claim eq 2>
						AND <cfif isDefined("attributes.is_other_money_transfer")>CR.BAKIYE3 <= 0<cfelse>CR.BAKIYE <= 0</cfif>
					</cfif>
					<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
						AND C.CUSTOMER_VALUE_ID = #attributes.customer_value#
					</cfif>
					<cfif session.ep.our_company_info.sales_zone_followup eq 1>
						<!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
						AND 
						(
							C.IMS_CODE_ID IN (
														SELECT
															IMS_ID
														FROM
															#dsn_alias#.SALES_ZONES_ALL_2
														WHERE
															POSITION_CODE = #session.ep.position_code# 
													)
						<!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
						<cfif get_hierarchies.recordcount>
						OR C.IMS_CODE_ID IN (
														SELECT
															IMS_ID
														FROM
															#dsn_alias#.SALES_ZONES_ALL_1
														WHERE											
															<cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
																<cfset start_row=(page_stock*row_block)+1>	
																<cfset end_row=start_row+(row_block-1)>
																<cfif (end_row) gte get_hierarchies.recordcount>
																	<cfset end_row=get_hierarchies.recordcount>
																</cfif>
																	(
																	<cfloop index="add_stock" from="#start_row#" to="#end_row#">
																		<cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy[add_stock]#%'
																	</cfloop>
																	
																	)<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
															</cfloop>											
													)
						  </cfif>						
						)
					</cfif>
				ORDER BY
					C.CONSUMER_NAME,
					C.CONSUMER_SURNAME
					<cfif isDefined("attributes.is_other_money_transfer")>
						,OTHER_MONEY
					</cfif>
			</cfquery>
		<!--- calisanlar --->
		<cfelseif attributes.action_type eq 3>	
			<cfquery name="GET_COMP_REMAINDER_MAIN" datasource="#dsn2#">
				SELECT 
					C.EMPLOYEE_ID AS COMPANY_ID,
					EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME EMPLOYEE,
					WEB.POSITION_CODE,
 					CB.IBAN_NO IBAN_CODE,
					C.EMPLOYEE_NO AS MEMBER_CODE,
					C.EMPLOYEE_NAME + ' ' +C.EMPLOYEE_SURNAME FULLNAME,
					'' AS CITY,
					'' AS SALES_COUNTY,
					'' AS IMS_CODE_ID,
					'' COMPANYCAT,
					'' AS VALUE_ID,
					'' AS PAY_METHOD,
					'' AS REV_METHOD
					<cfif isdefined("attributes.is_project_group")>
						,CR.PROJECT_ID
						,(SELECT PP.PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS PP WHERE PP.PROJECT_ID = CR.PROJECT_ID) PROJECT_HEAD
					<cfelse>
						,'' PROJECT_ID
						,'' PROJECT_HEAD
					</cfif>
					<cfif isDefined("attributes.is_other_money_transfer")>
						,OTHER_MONEY MONEY
					<cfelse>
						,'#session.ep.money#' AS MONEY
					</cfif>
					,(
					SELECT
						ISNULL(SUM(CRNEW.ACTION_VALUE),0)
					FROM
						CARI_ROWS CRNEW
					WHERE
						CRNEW.FROM_EMPLOYEE_ID = C.EMPLOYEE_ID AND
						CRNEW.ACTION_TYPE_ID = 49
						<cfif isDefined("attributes.is_other_money_transfer")>
							AND CRNEW.OTHER_MONEY = CR.OTHER_MONEY
							<cfif len(attributes.money_type_info)>
								AND CRNEW.OTHER_MONEY = '#attributes.money_type_info#'
							</cfif>
						</cfif>
						<cfif session.ep.isBranchAuthorization>
							AND	(CRNEW.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CRNEW.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
						</cfif>
						<cfif isdefined("attributes.is_project_group")>
							AND CRNEW.PROJECT_ID = CR.PROJECT_ID
						</cfif>
					) TAKEN_INV_RATES
					,(
					SELECT
						ISNULL(SUM(CRNEW.ACTION_VALUE),0)
					FROM
						CARI_ROWS CRNEW
					WHERE
						CRNEW.TO_EMPLOYEE_ID = C.EMPLOYEE_ID AND
						CRNEW.ACTION_TYPE_ID = 48
						<cfif session.ep.isBranchAuthorization>
							AND	(CRNEW.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CRNEW.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
						</cfif>
						<cfif isDefined("attributes.is_other_money_transfer")>
							AND CRNEW.OTHER_MONEY = CR.OTHER_MONEY
							<cfif len(attributes.money_type_info)>
								AND CRNEW.OTHER_MONEY = '#attributes.money_type_info#'
							</cfif>
						</cfif>
						<cfif isdefined("attributes.is_project_group")>
							AND CRNEW.PROJECT_ID = CR.PROJECT_ID
						</cfif>
					) GIVEN_INV_RATES
					,(
					SELECT
						ISNULL(SUM(CRNEW.ACTION_VALUE),0)
					FROM
						CARI_ROWS CRNEW
					WHERE
						CRNEW.FROM_EMPLOYEE_ID = C.EMPLOYEE_ID AND
						CRNEW.ACTION_TYPE_ID = 46
						<cfif session.ep.isBranchAuthorization>
							AND	(CRNEW.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CRNEW.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
						</cfif>
						<cfif isDefined("attributes.is_other_money_transfer")>
							AND CRNEW.OTHER_MONEY = CR.OTHER_MONEY
							<cfif len(attributes.money_type_info)>
								AND CRNEW.OTHER_MONEY = '#attributes.money_type_info#'
							</cfif>
						</cfif>
						<cfif isdefined("attributes.is_project_group")>
							AND CRNEW.PROJECT_ID = CR.PROJECT_ID
						</cfif>
					) CLAIM_RATES
					,(
					SELECT
						ISNULL(SUM(CRNEW.ACTION_VALUE),0)
					FROM
						CARI_ROWS CRNEW
					WHERE
						CRNEW.TO_EMPLOYEE_ID = C.EMPLOYEE_ID AND
						CRNEW.ACTION_TYPE_ID = 45
						<cfif session.ep.isBranchAuthorization>
							AND	(CRNEW.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CRNEW.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
						</cfif>
						<cfif isDefined("attributes.is_other_money_transfer")>
							AND CRNEW.OTHER_MONEY = CR.OTHER_MONEY
							<cfif len(attributes.money_type_info)>
								AND CRNEW.OTHER_MONEY = '#attributes.money_type_info#'
							</cfif>
						</cfif>
						<cfif isdefined("attributes.is_project_group")>
							AND CRNEW.PROJECT_ID = CR.PROJECT_ID
						</cfif>
					) DEBT_RATES,
					ISNULL(CR.ACC_TYPE_ID,0) ACC_TYPE_ID,
					(SELECT ACC_TYPE_NAME FROM #dsn_alias#.SETUP_ACC_TYPE WHERE ACC_TYPE_ID = ISNULL(CR.ACC_TYPE_ID,0)) ACC_TYPE_NAME,
                    <!--- borc/alacak tutarlari employee --->
					<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1) and isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                        (SELECT
                            <cfif isDefined("attributes.is_other_money_transfer")>
                                ISNULL(SUM(CARI_ROWS.OTHER_CASH_ACT_VALUE),0)
                            <cfelse>
                                ISNULL(SUM(CARI_ROWS.ACTION_VALUE),0)
                            </cfif>
                        FROM
                            CARI_ROWS
                        WHERE
                            CARI_ROWS.TO_EMPLOYEE_ID = C.EMPLOYEE_ID AND
                            CARI_ROWS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#"> AND CARI_ROWS.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                            <cfif isDefined("attributes.is_other_money_transfer")>
                            	AND CARI_ROWS.OTHER_MONEY = CR.OTHER_MONEY
							</cfif>
							<cfif session.ep.isBranchAuthorization>
								AND	(CARI_ROWS.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CARI_ROWS.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
							</cfif>
                            <cfif isDefined("attributes.due_date2") and isdate(attributes.due_date2) and isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
                                AND CARI_ROWS.DUE_DATE BETWEEN #attributes.due_date1# AND #attributes.due_date2#
                            <cfelseif isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
                                AND CARI_ROWS.DUE_DATE >= #attributes.due_date1#
                            <cfelseif isDefined("attributes.due_date2") and isdate(attributes.due_date2)>
                                AND CARI_ROWS.DUE_DATE <= #attributes.due_date2#
                            </cfif>
                            <cfif isdefined("attributes.is_pay_cheques")>
                                AND
                                (
                                    (	
                                        CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR
                                    (	
                                        CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE <= #new_date#)
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR 
                                    (
                                        CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR 
                                    (
                                        CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE <= #new_date#)
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR 
                                    (
                                        CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
                                        AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
                                                AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                )
                            </cfif>
                        ) BORC,
                        (SELECT
                        	<cfif isDefined("attributes.is_other_money_transfer")>
                            	ISNULL(SUM(CARI_ROWS.OTHER_CASH_ACT_VALUE),0)
                            <cfelse>
                            	ISNULL(SUM(CARI_ROWS.ACTION_VALUE),0)
                            </cfif>
                        FROM
                            CARI_ROWS
                        WHERE
                            CARI_ROWS.FROM_EMPLOYEE_ID = C.EMPLOYEE_ID AND
                            CARI_ROWS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#"> AND CARI_ROWS.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                            <cfif isDefined("attributes.is_other_money_transfer")>
                            	AND CARI_ROWS.OTHER_MONEY = CR.OTHER_MONEY
							</cfif>
							<cfif session.ep.isBranchAuthorization>
								AND	(CARI_ROWS.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CARI_ROWS.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
							</cfif>
                            <cfif isDefined("attributes.due_date2") and isdate(attributes.due_date2) and isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
                                AND CARI_ROWS.DUE_DATE BETWEEN #attributes.due_date1# AND #attributes.due_date2#
                            <cfelseif isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
                                AND CARI_ROWS.DUE_DATE >= #attributes.due_date1#
                            <cfelseif isDefined("attributes.due_date2") and isdate(attributes.due_date2)>
                                AND CARI_ROWS.DUE_DATE <= #attributes.due_date2#
                            </cfif>
                            <cfif isdefined("attributes.is_pay_cheques")>
                                AND
                                (
                                    (	
                                        CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR
                                    (	
                                        CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE <= #new_date#)
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR 
                                    (
                                        CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR 
                                    (
                                        CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
                                        AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE <= #new_date#)
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
                                                AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                    OR 
                                    (
                                        CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
                                        AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
                                        <cfif is_make_age_date>
                                            <cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
                                                AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
                                            </cfif>
                                            <cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
                                                AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
                                            </cfif>
                                        </cfif>
                                    )
                                )
                            </cfif>
                        ) ALACAK
                    </cfif>
				FROM 
					<cfif isdefined("attributes.is_project_group")>
						<cfif isDefined("attributes.is_other_money_transfer")>
							EMPLOYEE_REMAINDER_MONEY_PROJECT CR,
						<cfelse>
							EMPLOYEE_REMAINDER_PROJECT  CR,
						</cfif>
					<cfelse>
						<cfif isDefined("attributes.is_other_money_transfer")>
							EMPLOYEE_REMAINDER_MONEY CR,
						<cfelse>
							EMPLOYEE_REMAINDER CR,
						</cfif>
					</cfif>
					#dsn_alias#.EMPLOYEES C
						LEFT JOIN #dsn_alias#.WORKGROUP_EMP_PAR WEB 
							ON WEB.EMPLOYEE_ID = C.EMPLOYEE_ID 
							AND WEB.EMPLOYEE_ID IS NOT NULL 
							AND WEB.OUR_COMPANY_ID = #session.ep.company_id#
							AND WEB.IS_MASTER = 1
						LEFT JOIN #dsn_alias#.EMPLOYEE_POSITIONS EP ON WEB.POSITION_CODE = EP.POSITION_CODE
                    	LEFT JOIN #dsn_alias#.EMPLOYEE_POSITIONS CC ON C.EMPLOYEE_ID = CC.EMPLOYEE_ID AND CC.IS_MASTER = 1
						LEFT JOIN #dsn_alias#.DEPARTMENT D ON CC.DEPARTMENT_ID = D.DEPARTMENT_ID
                        LEFT JOIN #dsn_alias#.EMPLOYEES_BANK_ACCOUNTS CB ON CB.EMPLOYEE_ID=C.EMPLOYEE_ID AND DEFAULT_ACCOUNT=1
				WHERE 
					C.EMPLOYEE_ID = CR.EMPLOYEE_ID 
					AND LEN(EMPLOYEE_NO) > 0
					<cfif isdefined("attributes.is_detail") and attributes.detail_type eq 4>
						AND CR.OTHER_MONEY <> '#session.ep.money#'
					</cfif>
					<cfif isdefined("attributes.zero_bakiye") and isdefined("attributes.action_date1") and isdate(attributes.action_date1) and isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
						AND C.EMPLOYEE_ID IN(SELECT CRT.EMPLOYEE_ID FROM CARI_ROWS_EMPLOYEE CRT WHERE CRT.EMPLOYEE_ID = C.EMPLOYEE_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#"> AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#"> GROUP BY CRT.EMPLOYEE_ID HAVING ROUND(SUM(CRT.BORC-CRT.ALACAK),2) <> 0) 
						<cfif isDefined("attributes.is_other_money_transfer")>
	                        AND OTHER_MONEY IN (SELECT OTHER_MONEY FROM CARI_ROWS_EMPLOYEE CRT WHERE CRT.EMPLOYEE_ID = C.EMPLOYEE_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#"> AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#"> GROUP BY CRT.EMPLOYEE_ID,OTHER_MONEY HAVING ROUND(SUM(CRT.BORC2-CRT.ALACAK2),2) <> 0) 
                        </cfif>
                    <cfelse>
						AND C.EMPLOYEE_ID IN
						(
							SELECT 
								ISNULL(FROM_EMPLOYEE_ID,TO_EMPLOYEE_ID)
							FROM
								CARI_ROWS
							WHERE
								ISNULL(FROM_EMPLOYEE_ID,TO_EMPLOYEE_ID)=C.EMPLOYEE_ID
								<cfif session.ep.isBranchAuthorization>
									AND	(CARI_ROWS.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CARI_ROWS.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
								</cfif>
								<cfif isdefined("attributes.is_pay_cheques")>
									AND
									(
										(	
											CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
											AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
											<cfif is_make_age_date>
												<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
													AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
												</cfif>
												<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
													AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
												</cfif>
											</cfif>
										)
										OR
										(	
											CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
											AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE <= #new_date#)
											<cfif is_make_age_date>
												<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
													AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
												</cfif>
												<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
													AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
												</cfif>
											</cfif>
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
											AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
											<cfif is_make_age_date>
												<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
													AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
												</cfif>
												<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
													AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
												</cfif>
											</cfif>
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
											AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE <= #new_date#)
											<cfif is_make_age_date>
												<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
													AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
												</cfif>
												<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
													AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
												</cfif>
											</cfif>
										)
										OR 
										(
											CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
											AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
											<cfif is_make_age_date>
												<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
													AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
												</cfif>
												<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
													AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
												</cfif>
											</cfif>
										)
									)
								<cfelse>
									<cfif is_make_age_date>
										<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
											AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
										</cfif>
										<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
											AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
										</cfif>
									</cfif>
								</cfif>
						)
					</cfif>
					<cfif len(attributes.department_id)>
						AND
						(
							<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
							(D.BRANCH_ID = #listfirst(dept_i,'-')# AND D.DEPARTMENT_ID = #listlast(dept_i,'-')#)
							<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
							</cfloop>
						)
					</cfif>
					<cfif len(attributes.pos_code) and len(attributes.pos_code_text)>
						AND C.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID= #session.ep.company_id#)
					</cfif>
					<cfif isdefined("attributes.is_project_group")>
						<cfif len(attributes.project_id)>
							AND CR.PROJECT_ID = #attributes.project_id#
						</cfif>
					</cfif>
					<cfif isdefined("attributes.company") and len(attributes.company) and len(attributes.employee_id)>
						AND C.EMPLOYEE_ID = #attributes.employee_id#
					</cfif>
					<cfif isdefined("employee_type_id") and len(employee_type_id)>
						AND CR.ACC_TYPE_ID = #employee_type_id#
					</cfif>
					<cfif isDefined("attributes.is_other_money_transfer")>
						<cfif len(attributes.money_type_info)>
							AND CR.OTHER_MONEY = '#attributes.money_type_info#'
						</cfif>
					</cfif>
					<cfif len(attributes.duty_claim) and attributes.duty_claim eq 1>
						AND <cfif isDefined("attributes.is_other_money_transfer")>CR.BAKIYE3 > 0<cfelse>CR.BAKIYE > 0</cfif>
					<cfelseif len(attributes.duty_claim) and attributes.duty_claim eq 2>
						AND <cfif isDefined("attributes.is_other_money_transfer")>CR.BAKIYE3 <= 0<cfelse>CR.BAKIYE <= 0</cfif>
					</cfif>
					<cfif len(attributes.employee_cat_type)>
						AND CR.ACC_TYPE_ID IN (#attributes.employee_cat_type#)
					</cfif>
				ORDER BY
					C.EMPLOYEE_NAME,
					C.EMPLOYEE_SURNAME
					<cfif isDefined("attributes.is_other_money_transfer")>
						,OTHER_MONEY
					</cfif>
			</cfquery>
		</cfif>
		<cfparam name="attributes.page" default=1>
		<cfparam name="attributes.totalrecords" default="#get_comp_remainder_main.recordcount#">
		<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
		<cfif attributes.is_excel eq 1 or attributes.is_excel eq 2>
			<cfset attributes.startrow=1>
			<cfset attributes.maxrows=get_comp_remainder_main.recordcount>
		</cfif>
		<cfoutput query="get_money">
			<cfset 'toplam_#trim(money)#' = 0>
			<cfset 'borc_#trim(money)#' = 0>
			<cfset 'alacak_#trim(money)#' = 0>
		</cfoutput>
		<cfset vade_farki = 0>
		<cfset acik_fat_toplamlari = 0>
		<cfset acik_fat_toplam_due_day = 0>
            <cfset zero_count = 0>
            <cfif zero_diff_rate eq 1>
            	<cfset max_rows = get_comp_remainder_main.recordcount>
                <cfset start_row = 1>
            <cfelse>
            	<cfset max_rows = attributes.maxrows>
                <cfset start_row = attributes.startrow>
            </cfif>
		<cfif get_comp_remainder_main.recordcount>
			<cfset city_id_list = ''>
			<cfset comp_id_list = ''>
			<cfset zone_id_list = ''>
			<cfset ims_id_list = ''>
			<cfset project_id_list = ''>
			<cfset value_id_list = ''>
			<cfset pay_id_list = ''>
			<cfoutput query="get_comp_remainder_main" maxrows="#max_rows#" startrow="#start_row#">
				<cfif not listfind(city_id_list,city)>
					<cfset city_id_list = listappend(city_id_list,city)>
				</cfif>
				<cfif len(pay_method) and pay_method neq 0 and not listfind(pay_id_list,pay_method)>
					<cfset pay_id_list = listappend(pay_id_list,pay_method)>
				</cfif>	
				<cfif len(rev_method) and rev_method neq 0 and not listfind(pay_id_list,rev_method)>
					<cfset pay_id_list = listappend(pay_id_list,rev_method)>
				</cfif>
				<cfif not listfind(comp_id_list,company_id)>
					<cfset comp_id_list = listappend(comp_id_list,company_id)>
				</cfif>		
				<cfif not listfind(zone_id_list,sales_county)>
					<cfset zone_id_list = listappend(zone_id_list,sales_county)>
				</cfif>	
				<cfif not listfind(ims_id_list,ims_code_id)>
					<cfset ims_id_list = listappend(ims_id_list,ims_code_id)>
				</cfif>	
				<cfif not listfind(value_id_list,value_id)>
					<cfset value_id_list = listappend(value_id_list,value_id)>
				</cfif>	
				<cfif isdefined("project_id") and not listfind(project_id_list,project_id)>
					<cfset project_id_list = listappend(project_id_list,project_id)>
				</cfif>	
			</cfoutput>
			<cfif len(city_id_list)>
				<cfset city_id_list=listsort(city_id_list,"numeric","ASC",",")>
				<cfquery name="get_city_name" datasource="#dsn#">
					SELECT CITY_ID,PLATE_CODE FROM SETUP_CITY WHERE CITY_ID IN (#city_id_list#) ORDER BY CITY_ID
				</cfquery>
				<cfset city_id_list = listsort(listdeleteduplicates(valuelist(get_city_name.city_id,',')),'numeric','ASC',',')>
			</cfif> 
			<cfif len(zone_id_list)>
				<cfset zone_id_list=listsort(zone_id_list,"numeric","ASC",",")>
				<cfquery name="get_zone_name" datasource="#dsn#">
					SELECT SZ_ID,SZ_NAME FROM SALES_ZONES WHERE SZ_ID IN (#zone_id_list#) ORDER BY SZ_ID
				</cfquery>
				<cfset zone_id_list = listsort(listdeleteduplicates(valuelist(get_zone_name.sz_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(ims_id_list)>
				<cfset ims_id_list=listsort(ims_id_list,"numeric","ASC",",")>
				<cfquery name="get_ims_name" datasource="#dsn#">
					SELECT IMS_CODE_ID,IMS_CODE,IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID IN (#ims_id_list#) ORDER BY IMS_CODE_ID
				</cfquery>
				<cfset ims_id_list = listsort(listdeleteduplicates(valuelist(get_ims_name.ims_code_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(project_id_list)>
				<cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>
				<cfquery name="get_pro_name" datasource="#dsn#">
					SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
				</cfquery>
				<cfset project_id_list = listsort(listdeleteduplicates(valuelist(get_pro_name.project_id,',')),'numeric','ASC',',')>
			</cfif> 
			<cfif len(value_id_list)>
				<cfset value_id_list=listsort(value_id_list,"numeric","ASC",",")>
				<cfquery name="get_val_name" datasource="#dsn#">
					SELECT CUSTOMER_VALUE_ID,CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE WHERE CUSTOMER_VALUE_ID IN (#value_id_list#) ORDER BY CUSTOMER_VALUE_ID
				</cfquery>
				<cfset value_id_list = listsort(listdeleteduplicates(valuelist(get_val_name.customer_value_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(pay_id_list)>
				<cfset pay_id_list=listsort(pay_id_list,"numeric","ASC",",")>
				<cfquery name="get_pay_name" datasource="#dsn#">
					SELECT PAYMETHOD,PAYMETHOD_ID FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID IN (#pay_id_list#) ORDER BY PAYMETHOD_ID
				</cfquery>
				<cfset pay_id_list = listsort(listdeleteduplicates(valuelist(get_pay_name.PAYMETHOD_ID,',')),'numeric','ASC',',')>
			</cfif> 
			<cfif isDefined("session.pp.money")>
				<cfset session_base_money = session.pp.money>
			<cfelseif isDefined("session.ww.money")>
				<cfset session_base_money = session.ww.money>
			<cfelse>
				<cfset session_base_money = session.ep.money>
			</cfif>
            <tbody>
			<cfoutput query="get_comp_remainder_main" maxrows="#max_rows#" startrow="#start_row#">
				<cfif attributes.action_type eq 1>
					<cfset attributes.company_id = GET_COMP_REMAINDER_MAIN.COMPANY_ID>
					<cfset member_code_info = GET_COMP_REMAINDER_MAIN.MEMBER_CODE>
				<cfelseif attributes.action_type eq 2>
					<cfset attributes.consumer_id = GET_COMP_REMAINDER_MAIN.COMPANY_ID>
					<cfset member_code_info = GET_COMP_REMAINDER_MAIN.MEMBER_CODE>
				<cfelseif attributes.action_type eq 3>
					<cfset attributes.employee_id = GET_COMP_REMAINDER_MAIN.COMPANY_ID>
					<cfset member_code_info = GET_COMP_REMAINDER_MAIN.MEMBER_CODE>
				</cfif>
				<cfset acc_type_id = GET_COMP_REMAINDER_MAIN.ACC_TYPE_ID>
				<cfset acc_type_name = GET_COMP_REMAINDER_MAIN.ACC_TYPE_NAME>
				<cfif (isDefined("attributes.company_id") and len(attributes.company_id)) or (isDefined("attributes.consumer_id") and len(attributes.consumer_id)) or (isdefined("attributes.employee_id") and len(attributes.employee_id))>
					<cfset attributes.project_id = GET_COMP_REMAINDER_MAIN.PROJECT_ID>
					<cfif get_comp_remainder_main.money eq session_base_money and not isDefined("attributes.is_other_money_transfer")>
						<cfquery name="GET_COMP_REMAINDER" datasource="#dsn2#">
							SELECT
								ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
								ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2
							FROM
								(
									SELECT
										SUM(ACTION_VALUE) AS BORC,
										SUM(ACTION_VALUE_2) AS BORC2,		
										0 AS ALACAK,
										0 AS ALACAK2
									FROM
										CARI_ROWS
									WHERE
										<cfif attributes.action_type eq 1>
											TO_CMP_ID = #attributes.company_id#
										<cfelseif attributes.action_type eq 2>
											TO_CONSUMER_ID = #attributes.consumer_id#
										<cfelseif attributes.action_type eq 3>
											TO_EMPLOYEE_ID = #attributes.employee_id#
										</cfif>
										<cfif len(attributes.project_id)>
											AND PROJECT_ID = #attributes.project_id#
										<cfelseif isdefined("attributes.is_project_group")>
											AND PROJECT_ID IS NULL
										</cfif>
										<cfif isdefined("attributes.is_other_money_transfer")>
											AND ACTION_TYPE_ID NOT IN (48,49,45,46)
										</cfif>
										<cfif len(acc_type_id) and acc_type_id neq 0>
											AND ISNULL(ACC_TYPE_ID,0) = #acc_type_id#
										</cfif>
										<cfif session.ep.isBranchAuthorization>
											AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
										</cfif>
										<cfif isdefined("attributes.is_pay_cheques")>
											AND
											(
												(	
													CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
													AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
													<cfif is_make_age_date>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
															AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													<cfelse>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
															AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													</cfif>
												)
												OR
												(	
													CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
													AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE <= #new_date#)


													<cfif is_make_age_date>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
															AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													<cfelse>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
															AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													</cfif>
												)
												OR 
												(
													CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
													AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
													<cfif is_make_age_date>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
															AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													<cfelse>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
															AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													</cfif>
												)
												OR 
												(
													CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
													AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE <= #new_date#)
													<cfif is_make_age_date>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
															AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													<cfelse>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
															AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													</cfif>
												)
												OR 
												(
													CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
													AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
													<cfif is_make_age_date>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
															AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													<cfelse>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
															AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													</cfif>
												)
											)
										<cfelse>
											<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
												AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
											</cfif>
											<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
												AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
											</cfif>
										</cfif>
                                        <cfif isDefined("attributes.due_date2") and isdate(attributes.due_date2) and isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
                                            AND DUE_DATE BETWEEN #attributes.due_date1# AND #attributes.due_date2#
                                        <cfelseif isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
                                            AND DUE_DATE >= #attributes.due_date1#
                                        <cfelseif isDefined("attributes.due_date2") and isdate(attributes.due_date2)>
                                            AND DUE_DATE <= #attributes.due_date2#
                                        </cfif>
								UNION ALL
									SELECT
										0 AS BORC,
										0 AS BORC2,
										SUM(ACTION_VALUE) AS ALACAK,
										SUM(ACTION_VALUE_2) AS ALACAK2
									FROM
										CARI_ROWS
									WHERE
										<cfif attributes.action_type eq 1>
											FROM_CMP_ID = #attributes.company_id#
										<cfelseif attributes.action_type eq 2>
											FROM_CONSUMER_ID = #attributes.consumer_id#
										<cfelseif attributes.action_type eq 3>
											FROM_EMPLOYEE_ID = #attributes.employee_id#
										</cfif>
										<cfif session.ep.isBranchAuthorization>
											AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
										</cfif>
										<cfif len(attributes.project_id)>
											AND PROJECT_ID = #attributes.project_id#
										<cfelseif isdefined("attributes.is_project_group")>
											AND PROJECT_ID IS NULL 
										</cfif>
										<cfif isdefined("attributes.is_other_money_transfer")>
											AND ACTION_TYPE_ID NOT IN (48,49,45,46)
										</cfif>
										<cfif len(acc_type_id) and acc_type_id neq 0>
											AND ISNULL(ACC_TYPE_ID,0) = #acc_type_id#
										</cfif>
										<cfif isdefined("attributes.is_pay_cheques")>
											AND
											(
												(	
													CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
													AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
													<cfif is_make_age_date>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
															AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													<cfelse>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
															AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													</cfif>
												)
												OR
												(	
													CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
													AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE <= #new_date#)
													<cfif is_make_age_date>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
															AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													<cfelse>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
															AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													</cfif>
												)
												OR 
												(
													CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
													AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
													<cfif is_make_age_date>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
															AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													<cfelse>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
															AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													</cfif>
												)
												OR 
												(
													CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
													AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE <= #new_date#)
													<cfif is_make_age_date>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
															AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													<cfelse>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
															AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													</cfif>
												)
												OR 
												(
													CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
													AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
													<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
														AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
													</cfif>
													<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
														AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
													</cfif>
												)
											)
										<cfelse>
											<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
												AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
											</cfif>
											<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
												AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
											</cfif>
										</cfif>
                                        <cfif isDefined("attributes.due_date2") and isdate(attributes.due_date2) and isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
                                            AND DUE_DATE BETWEEN #attributes.due_date1# AND #attributes.due_date2#
                                        <cfelseif isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
                                            AND DUE_DATE >= #attributes.due_date1#
                                        <cfelseif isDefined("attributes.due_date2") and isdate(attributes.due_date2)>
                                            AND DUE_DATE <= #attributes.due_date2#
                                        </cfif>
								) AS COMP_REMAINDER
						</cfquery>
						<cfset bakiye_kontrol = GET_COMP_REMAINDER.BAKIYE>
					<cfelse>
						<cfquery name="GET_COMP_REMAINDER" datasource="#dsn2#">
							SELECT
								ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
								ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2,
								ROUND(SUM(BORC3-ALACAK3),5) AS BAKIYE3,
								OTHER_MONEY
							FROM
								(
									SELECT
										SUM(ACTION_VALUE) AS BORC,
										SUM(ACTION_VALUE_2) AS BORC2,		
										0 AS ALACAK,
										0 AS ALACAK2,
										0 AS ALACAK3,		
										SUM(ISNULL(OTHER_CASH_ACT_VALUE,0)) AS BORC3,
										OTHER_MONEY
									FROM
										CARI_ROWS
									WHERE
										<cfif attributes.action_type eq 1>
											TO_CMP_ID = #attributes.company_id#
										<cfelseif attributes.action_type eq 2>
											TO_CONSUMER_ID = #attributes.consumer_id#
										<cfelseif attributes.action_type eq 3>
											TO_EMPLOYEE_ID = #attributes.employee_id#
										</cfif>
										<cfif len(attributes.project_id)>
											AND PROJECT_ID = #attributes.project_id#
										<cfelseif isdefined("attributes.is_project_group")>
											AND PROJECT_ID IS NULL 
										</cfif>
										<cfif isdefined("attributes.is_other_money_transfer")>
											AND ACTION_TYPE_ID NOT IN (48,49,45,46)
										</cfif>
										<cfif session.ep.isBranchAuthorization>
											AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
										</cfif>
										<cfif len(acc_type_id) and acc_type_id neq 0>
											AND ISNULL(ACC_TYPE_ID,0) = #acc_type_id#
										</cfif>
										AND OTHER_MONEY = '#get_comp_remainder_main.money#'
										<cfif isdefined("attributes.is_pay_cheques")>
											AND
											(
												(	
													CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
													AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
													<cfif is_make_age_date>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
															AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													<cfelse>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
															AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													</cfif>
												)
												OR
												(	
													CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
													AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE <= #new_date#)
													<cfif is_make_age_date>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
															AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													<cfelse>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
															AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">


														</cfif>
													</cfif>
												)
												OR 
												(
													CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
													AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
													<cfif is_make_age_date>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
															AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													<cfelse>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
															AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													</cfif>
												)
												OR 
												(
													CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
													AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE <= #new_date#)
													<cfif is_make_age_date>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
															AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													<cfelse>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
															AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													</cfif>
												)
												OR 
												(
													CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
													AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
													<cfif is_make_age_date>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
															AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													<cfelse>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
															AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													</cfif>
												)
											)
										<cfelse>
											<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
												AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
											</cfif>
											<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
												AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
											</cfif>
										</cfif>
                                        <cfif isDefined("attributes.due_date2") and isdate(attributes.due_date2) and isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
                                            AND DUE_DATE BETWEEN #attributes.due_date1# AND #attributes.due_date2#
                                        <cfelseif isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
                                            AND DUE_DATE >= #attributes.due_date1#
                                        <cfelseif isDefined("attributes.due_date2") and isdate(attributes.due_date2)>
                                            AND DUE_DATE <= #attributes.due_date2#
                                        </cfif>
									GROUP BY
										OTHER_MONEY
								UNION ALL
									SELECT
										0 AS BORC,
										0 AS BORC2,
										SUM(ACTION_VALUE) AS ALACAK,
										SUM(ACTION_VALUE_2) AS ALACAK2,
										SUM(ISNULL(OTHER_CASH_ACT_VALUE,0)) AS ALACAK3,		
										0 AS BORC3,
										OTHER_MONEY
									FROM
										CARI_ROWS
									WHERE
										<cfif attributes.action_type eq 1>
											FROM_CMP_ID = #attributes.company_id#
										<cfelseif attributes.action_type eq 2>
											FROM_CONSUMER_ID = #attributes.consumer_id#
										<cfelseif attributes.action_type eq 3>
											FROM_EMPLOYEE_ID = #attributes.employee_id#
										</cfif>
										<cfif session.ep.isBranchAuthorization>
											AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
										</cfif>
										<cfif len(attributes.project_id)>
											AND PROJECT_ID = #attributes.project_id#
										<cfelseif isdefined("attributes.is_project_group")>
											AND PROJECT_ID IS NULL
										</cfif>
										<cfif isdefined("attributes.is_other_money_transfer")>
											AND ACTION_TYPE_ID NOT IN (48,49,45,46)
										</cfif>
										<cfif len(acc_type_id) and acc_type_id neq 0>
											AND ISNULL(ACC_TYPE_ID,0) = #acc_type_id#
										</cfif>
										AND OTHER_MONEY = '#get_comp_remainder_main.money#'
										<cfif isdefined("attributes.is_pay_cheques")>
											AND
											(
												(	
													CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
													AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
													<cfif is_make_age_date>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
															AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													<cfelse>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
															AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													</cfif>
												)
												OR
												(	
													CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
													AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE <= #new_date#)
													<cfif is_make_age_date>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
															AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													<cfelse>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
															AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													</cfif>
												)
												OR 
												(
													CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
													AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
													<cfif is_make_age_date>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
															AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													<cfelse>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
															AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													</cfif>
												)
												OR 
												(
													CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
													AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE <= #new_date#)
													<cfif is_make_age_date>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
															AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													<cfelse>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
															AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													</cfif>
												)
												OR 
												(
													CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
													AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
													<cfif is_make_age_date>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
															AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													<cfelse>
														<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
															AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
														</cfif>
														<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
															AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
														</cfif>
													</cfif>
												)
											)
										<cfelse>
											<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
												AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
											</cfif>
											<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
												AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
											</cfif>
										</cfif>
                                        <cfif isDefined("attributes.due_date2") and isdate(attributes.due_date2) and isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
                                            AND DUE_DATE BETWEEN #attributes.due_date1# AND #attributes.due_date2#
                                        <cfelseif isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
                                            AND DUE_DATE >= #attributes.due_date1#
                                        <cfelseif isDefined("attributes.due_date2") and isdate(attributes.due_date2)>
                                            AND DUE_DATE <= #attributes.due_date2#
                                        </cfif>
									GROUP BY
										OTHER_MONEY
								) AS COMP_REMAINDER
							GROUP BY
								OTHER_MONEY
						</cfquery>
						<cfset bakiye_kontrol = GET_COMP_REMAINDER.BAKIYE3>
					</cfif>
				</cfif>
				<cfif not isdefined("attributes.is_manuel")>
					<cfif isDefined("attributes.is_other_money_transfer")>
						<cfset OPEN_INVOICE = QueryNew("INVOICE_NUMBER,TOTAL_SUB,TOTAL_OTHER_SUB,T_OTHER_MONEY,INVOICE_DATE,ROW_COUNT,DUE_DATE,INV_RATE,ACTION_TYPE_ID,PROJECT_ID","VarChar,Double,Double,VarChar,Date,integer,Date,Double,integer,integer")>
					</cfif>
					<cfset open_rows_ = 0>
					<cfif (isDefined("attributes.company_id") and len(attributes.company_id)) or (isDefined("attributes.consumer_id") and len(attributes.consumer_id)) or (isdefined("attributes.employee_id") and len(attributes.employee_id))>
						<cfquery name="GET_REVENUE" datasource="#dsn2#">
							SELECT 
								FROM_CMP_ID,
								ACTION_VALUE AS TOTAL,
								ACTION_DATE,
								DUE_DATE,
								ACTION_TYPE_ID,
								PROJECT_ID,
								ISNULL(OTHER_CASH_ACT_VALUE,0) AS OTHER_MONEY_VALUE,
								OTHER_MONEY,
								PAPER_NO,
								CARI_ACTION_ID
							FROM
								CARI_ROWS
							WHERE
							<cfif bakiye_kontrol gt 0>
								<cfif attributes.action_type eq 1>
									FROM_CMP_ID = #attributes.company_id#
								<cfelseif attributes.action_type eq 2>
									FROM_CONSUMER_ID = #attributes.consumer_id#
								<cfelseif attributes.action_type eq 3>
									FROM_EMPLOYEE_ID = #attributes.employee_id#
								</cfif>
							<cfelse>
								<cfif attributes.action_type eq 1>
									TO_CMP_ID = #attributes.company_id#
								<cfelseif attributes.action_type eq 2>
									TO_CONSUMER_ID = #attributes.consumer_id#
								<cfelseif attributes.action_type eq 3>
									TO_EMPLOYEE_ID = #attributes.employee_id#
								</cfif>
							</cfif>
							<cfif len(acc_type_id) and acc_type_id neq 0>
								AND ISNULL(ACC_TYPE_ID,0) = #acc_type_id#
							</cfif>
							<cfif session.ep.isBranchAuthorization>
								AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
							</cfif>
							<cfif isdefined("attributes.is_other_money_transfer")>
								AND ACTION_TYPE_ID NOT IN (48,49,45,46)
							</cfif>
							<cfif isDefined("attributes.is_other_money_transfer")>
								AND OTHER_MONEY = '#get_comp_remainder_main.money#'
							</cfif>
							<cfif isdefined("attributes.is_pay_cheques")>
								AND
								(
									(	
										CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
										AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
										<cfif is_make_age_date>
											<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
												AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
											</cfif>
											<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
												AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
											</cfif>
										</cfif>
									)
									OR
									(	
										CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
										AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE <= #new_date#)
										<cfif is_make_age_date>
											<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
												AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
											</cfif>
											<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
												AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
											</cfif>
										</cfif>
									)
									OR 
									(
										CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
										AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
										<cfif is_make_age_date>
											<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
												AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
											</cfif>
											<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
												AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
											</cfif>
										</cfif>
									)
									OR 
									(
										CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
										AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE <= #new_date#)
										<cfif is_make_age_date>
											<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
												AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
											</cfif>
											<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
												AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
											</cfif>
										</cfif>
									)
									OR 
									(
										CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
										AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
										<cfif is_make_age_date>
											<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
												AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
											</cfif>
											<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
												AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
											</cfif>
										</cfif>
									)
								)
							<cfelse>
								<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
									AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
								</cfif>
								<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
									AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
								</cfif>
							</cfif>
                            <cfif isDefined("attributes.due_date2") and isdate(attributes.due_date2) and isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
								AND DUE_DATE BETWEEN #attributes.due_date1# AND #attributes.due_date2#
							<cfelseif isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
								AND DUE_DATE >= #attributes.due_date1#
							<cfelseif isDefined("attributes.due_date2") and isdate(attributes.due_date2)>
								AND DUE_DATE <= #attributes.due_date2#
							</cfif>
							<cfif len(attributes.project_id)>
								AND PROJECT_ID = #attributes.project_id#
							<cfelseif isdefined("attributes.is_project_group")>
								AND PROJECT_ID IS NULL
							</cfif>
							ORDER BY
								ISNULL(DUE_DATE,ACTION_DATE)
						</cfquery>
						<cfquery name="get_invoice" datasource="#dsn2#">
							SELECT 
								ACTION_VALUE TOTAL,
								ISNULL(OTHER_CASH_ACT_VALUE,0) OTHER_MONEY_VALUE,
								OTHER_MONEY,
								PAPER_NO INVOICE_NUMBER,
								ACTION_DATE INVOICE_DATE,
								ACTION_TYPE_ID,
								PROJECT_ID,
								ACTION_NAME,
								DUE_DATE,
								<cfif isdefined("attributes.is_other_money_transfer")>
									(ACTION_VALUE/ISNULL(OTHER_CASH_ACT_VALUE,ACTION_VALUE)) INV_RATE
								<cfelse>
									1 INV_RATE
								</cfif>
							FROM
								CARI_ROWS
							WHERE
								1 = 1
							<cfif isdefined("attributes.is_other_money_transfer")>
								AND OTHER_CASH_ACT_VALUE > 0
								AND ACTION_TYPE_ID NOT IN (48,49,45,46)
							</cfif>
							<cfif session.ep.isBranchAuthorization>
								AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
							</cfif>
							<cfif bakiye_kontrol gt 0>
								<cfif attributes.action_type eq 1>
									AND	TO_CMP_ID = #attributes.company_id# 
								<cfelseif attributes.action_type eq 2>
									AND TO_CONSUMER_ID = #attributes.consumer_id#
								<cfelseif attributes.action_type eq 3>
									AND TO_EMPLOYEE_ID = #attributes.employee_id#
								</cfif>
							<cfelse>
								<cfif attributes.action_type eq 1>
									AND FROM_CMP_ID = #attributes.company_id#
								<cfelseif attributes.action_type eq 2>
									AND FROM_CONSUMER_ID = #attributes.consumer_id# 
								<cfelseif attributes.action_type eq 3>
									AND FROM_EMPLOYEE_ID = #attributes.employee_id# 
								</cfif>
							</cfif>
							<cfif len(acc_type_id) and acc_type_id neq 0>
								AND ISNULL(ACC_TYPE_ID,0) = #acc_type_id#
							</cfif>
							<cfif isdefined("attributes.is_pay_cheques")>
								AND
								(
									(	
										CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
										AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
										<cfif is_make_age_date>
											<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
												AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
											</cfif>
											<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
												AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
											</cfif>
										</cfif>
									)
									OR
									(	
										CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
										AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE <= #new_date#)
										<cfif is_make_age_date>
											<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
												AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
											</cfif>
											<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
												AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
											</cfif>
										</cfif>
									)
									OR 
									(
										CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
										AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
										<cfif is_make_age_date>
											<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
												AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
											</cfif>
											<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
												AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
											</cfif>
										</cfif>
									)
									OR 
									(
										CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
										AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE <= #new_date#)
										<cfif is_make_age_date>
											<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
												AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
											</cfif>
											<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>
												AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
											</cfif>
										</cfif>
									)
									OR 
									(
										CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
										AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
										<cfif is_make_age_date>
											<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
												AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
											</cfif>
											<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
												AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
											</cfif>
										</cfif>
									)
								)
							<cfelse>
								<cfif isdefined("attributes.action_date1") and isdate(attributes.action_date1)>
									AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date1#">
								</cfif>
								<cfif isdefined("attributes.action_date2") and isdate(attributes.action_date2)>	
									AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date2#">
								</cfif>
							</cfif>
                            <cfif isDefined("attributes.due_date2") and isdate(attributes.due_date2) and isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
								AND DUE_DATE BETWEEN #attributes.due_date1# AND #attributes.due_date2#
							<cfelseif isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
								AND DUE_DATE >= #attributes.due_date1#
							<cfelseif isDefined("attributes.due_date2") and isdate(attributes.due_date2)>
								AND DUE_DATE <= #attributes.due_date2#
							</cfif>
							<cfif isDefined("attributes.is_other_money_transfer")>
								AND OTHER_MONEY = '#get_comp_remainder_main.money#'
							</cfif>
							<cfif len(attributes.project_id)>
								AND PROJECT_ID = #attributes.project_id#
							<cfelseif isdefined("attributes.is_project_group")>
								AND PROJECT_ID IS NULL
							</cfif>
							ORDER BY
								ISNULL(DUE_DATE,ACTION_DATE)
						</cfquery>
						<cfset row_of_query = 0>
						<cfset row_of_query_2 = 0>
						<cfset ALL_INVOICE = QueryNew("INVOICE_NUMBER,TOTAL_SUB,TOTAL_OTHER_SUB,T_OTHER_MONEY,INVOICE_DATE,ROW_COUNT,DUE_DATE,INV_RATE,ACTION_TYPE_ID,PROJECT_ID","VarChar,Double,Double,VarChar,Date,integer,Date,Double,integer,integer")>
						<cfloop query="get_invoice">
							<cfscript>
								tarih_inv = CreateODBCDateTime(get_invoice.INVOICE_DATE);
								total_pesin = 0;
								en_genel_toplam = 0;
								kalan_pesin = TOTAL - total_pesin;
								en_genel_toplam = en_genel_toplam + total_pesin;									
								total_pesin = TOTAL;
								row_of_query = row_of_query + 1 ;
								QueryAddRow(ALL_INVOICE,1);
								QuerySetCell(ALL_INVOICE,"INVOICE_NUMBER","#INVOICE_NUMBER#",row_of_query);
								QuerySetCell(ALL_INVOICE,"TOTAL_SUB","#total_pesin#",row_of_query);
								QuerySetCell(ALL_INVOICE,"TOTAL_OTHER_SUB","#OTHER_MONEY_VALUE#",row_of_query);
								QuerySetCell(ALL_INVOICE,"T_OTHER_MONEY","#OTHER_MONEY#",row_of_query);
								QuerySetCell(ALL_INVOICE,"INVOICE_DATE","#tarih_inv#",row_of_query);
								QuerySetCell(ALL_INVOICE,"ROW_COUNT","#row_of_query#",row_of_query);
								if(len(DUE_DATE))
									QuerySetCell(ALL_INVOICE,"DUE_DATE","#CreateODBCDateTime(DUE_DATE)#",row_of_query);
								else
									QuerySetCell(ALL_INVOICE,"DUE_DATE","#CreateODBCDateTime(INVOICE_DATE)#",row_of_query);
								QuerySetCell(ALL_INVOICE,"INV_RATE","#INV_RATE#",row_of_query);
								QuerySetCell(ALL_INVOICE,"ACTION_TYPE_ID","#ACTION_TYPE_ID#",row_of_query);
								QuerySetCell(ALL_INVOICE,"PROJECT_ID","#PROJECT_ID#",row_of_query);
							</cfscript>
						</cfloop>
						<cfset cari_toplam_tutar=0>
						<cfset cari_toplam_islem_tutar=0>
						<cfset total_money=0>
						<cfset total_kur_farki=0>
						<cfif GET_REVENUE.recordcount and get_invoice.recordcount>
							<cfset TOPLAM_VALUE = 0>
							<cfset TOPLAM_GUN_TUTARLARI=0>
							<cfset TOPLAM_AGIRLIK=0>
							<cfif GET_REVENUE.recordcount>
								<cfloop query="GET_REVENUE">
									<cfif len(GET_REVENUE.OTHER_MONEY_VALUE[currentrow]) and GET_REVENUE.OTHER_MONEY_VALUE[currentrow] gt 0>
										<cfset kur_cari_row = wrk_round(GET_REVENUE.TOTAL[currentrow]/GET_REVENUE.OTHER_MONEY_VALUE[currentrow],4)>
									<cfelse>
										<cfset kur_cari_row = 0>
									</cfif>
									<cfif isDefined("attributes.is_other_money_transfer")>
										<cfset TOPLAM_VALUE = GET_REVENUE.OTHER_MONEY_VALUE[currentrow]>
									<cfelse>
										<cfset TOPLAM_VALUE = GET_REVENUE.TOTAL[currentrow]>
									</cfif>
									<cfset cari_toplam_tutar = cari_toplam_tutar + GET_REVENUE.TOTAL[currentrow]>
									<cfif len(GET_REVENUE.OTHER_MONEY_VALUE[currentrow])>
										<cfset cari_toplam_islem_tutar = cari_toplam_islem_tutar + GET_REVENUE.OTHER_MONEY_VALUE[currentrow]>
									</cfif>
									<cfquery name="GET_INV_RECORD" dbtype="query">
										SELECT
											TOTAL_SUB,
											TOTAL_OTHER_SUB,
											INVOICE_NUMBER,
											INVOICE_DATE,
											T_OTHER_MONEY,
											ROW_COUNT,
											DUE_DATE,
											INV_RATE,
											ACTION_TYPE_ID,
											PROJECT_ID
										FROM
											ALL_INVOICE
										WHERE
										<cfif isDefined("attributes.is_other_money_transfer")>
											TOTAL_OTHER_SUB IS NOT NULL AND 
											TOTAL_OTHER_SUB <> 0
										<cfelse>
											TOTAL_SUB IS NOT NULL AND 
											TOTAL_SUB <> 0
										</cfif>
										ORDER BY
											DUE_DATE
									</cfquery>
									<cfif GET_INV_RECORD.recordcount>
										<cfset i_index=0>
										<cfloop condition="i_index lt GET_INV_RECORD.recordcount">
											<cfset i_index=i_index+1>
											<cfif len(GET_REVENUE.DUE_DATE[GET_REVENUE.currentrow])>
												<cfset GUN_FARKI = DateDiff("d",GET_INV_RECORD.DUE_DATE[i_index],GET_REVENUE.DUE_DATE[GET_REVENUE.currentrow])>
											<cfelse>
												<cfset GUN_FARKI = DateDiff("d",GET_INV_RECORD.DUE_DATE[i_index],GET_REVENUE.ACTION_DATE[GET_REVENUE.currentrow])>
											</cfif>
											<cfif GUN_FARKI eq 0><cfset GUN_FARKI=1></cfif>
											<cfset TOPLAM_TEMP = TOPLAM_VALUE>													
											<cfif isDefined("attributes.is_other_money_transfer")>
												<cfset TOPLAM_VALUE = TOPLAM_VALUE - GET_INV_RECORD.TOTAL_OTHER_SUB[i_index] >
											<cfelse>
												<cfset TOPLAM_VALUE = TOPLAM_VALUE - GET_INV_RECORD.TOTAL_SUB[i_index] >
											</cfif>
											<cfif TOPLAM_VALUE gt 0>
												<cfif isDefined("attributes.is_other_money_transfer")>
													<cfset GUN_TUTARI = GET_INV_RECORD.TOTAL_OTHER_SUB[i_index]>
												<cfelse>
													<cfset GUN_TUTARI = GET_INV_RECORD.TOTAL_SUB[i_index]>
												</cfif>
											<cfelse>
												<cfif isDefined("attributes.is_other_money_transfer")>
													<cfset GUN_TUTARI = GET_INV_RECORD.TOTAL_OTHER_SUB[i_index]+TOPLAM_VALUE>
												<cfelse>
													<cfset GUN_TUTARI = GET_INV_RECORD.TOTAL_SUB[i_index]+TOPLAM_VALUE>
												</cfif>
											</cfif>
											<cfif len(GET_INV_RECORD.INV_RATE[i_index]) and GET_INV_RECORD.INV_RATE[i_index] gt 0 and GUN_TUTARI gt 0>
												<cfset kur_inv = wrk_round(GUN_TUTARI/(GUN_TUTARI/GET_INV_RECORD.INV_RATE[i_index]),4)>
											<cfelse>
												<cfset kur_inv = 1>
											</cfif>
											<cfset TOPLAM_GUN_TUTARLARI = TOPLAM_GUN_TUTARLARI + GUN_TUTARI>
											<cfset TOPLAM_AGIRLIK = TOPLAM_AGIRLIK + (GUN_TUTARI*GUN_FARKI)>
											<cfset total_money = total_money + wrk_round(GUN_TUTARI*GET_INV_RECORD.INV_RATE[i_index])>
											<cfif len(GET_REVENUE.FROM_CMP_ID)>
												<cfset ara_kur_farki = (kur_cari_row - kur_inv)>
											<cfelse>
												<cfset ara_kur_farki = (kur_inv - kur_cari_row)>
											</cfif>
											<cfset total_kur_farki = total_kur_farki + wrk_round(GUN_TUTARI * ara_kur_farki)>
											<cfif TOPLAM_VALUE gt 0>
												<cfif isDefined("attributes.is_other_money_transfer")>
													<cfset INVOICE_TEMP = QuerySetCell(ALL_INVOICE,"TOTAL_OTHER_SUB",0,GET_INV_RECORD.ROW_COUNT[i_index])>
												<cfelse>
													<cfset INVOICE_TEMP = QuerySetCell(ALL_INVOICE,"TOTAL_SUB",0,GET_INV_RECORD.ROW_COUNT[i_index])>
												</cfif>
											<cfelse>
												<cfif isDefined("attributes.is_other_money_transfer")>
													<cfset INVOICE_TEMP = QuerySetCell(ALL_INVOICE,"TOTAL_OTHER_SUB",GET_INV_RECORD.TOTAL_OTHER_SUB[i_index]-TOPLAM_TEMP,GET_INV_RECORD.ROW_COUNT[i_index])>
												<cfelse>
													<cfset INVOICE_TEMP = QuerySetCell(ALL_INVOICE,"TOTAL_SUB",GET_INV_RECORD.TOTAL_SUB[i_index]-TOPLAM_TEMP,GET_INV_RECORD.ROW_COUNT[i_index])>
												</cfif>
												<cfbreak>
											</cfif>
										</cfloop>
									</cfif>
								</cfloop>
							</cfif>
						</cfif>
						<cfif isDefined("attributes.is_other_money_transfer")>
							<cfif isdefined("ALL_INVOICE") and ALL_INVOICE.recordcount>
								<cfloop query="ALL_INVOICE">
									<cfset open_rows_ = open_rows_ + 1> 
									<cfscript>
										QueryAddRow(OPEN_INVOICE,1);
										QuerySetCell(OPEN_INVOICE,"INVOICE_NUMBER","#INVOICE_NUMBER#",open_rows_);
										QuerySetCell(OPEN_INVOICE,"TOTAL_SUB","#TOTAL_SUB#",open_rows_);
										QuerySetCell(OPEN_INVOICE,"TOTAL_OTHER_SUB","#wrk_round(TOTAL_OTHER_SUB)#",open_rows_);
										QuerySetCell(OPEN_INVOICE,"T_OTHER_MONEY","#T_OTHER_MONEY#",open_rows_);
										QuerySetCell(OPEN_INVOICE,"INVOICE_DATE","#INVOICE_DATE#",open_rows_);
										QuerySetCell(OPEN_INVOICE,"ROW_COUNT","#open_rows_#",open_rows_);
										QuerySetCell(OPEN_INVOICE,"DUE_DATE","#DUE_DATE#",open_rows_);
										QuerySetCell(OPEN_INVOICE,"INV_RATE","#INV_RATE#",open_rows_);
										QuerySetCell(OPEN_INVOICE,"ACTION_TYPE_ID","#ACTION_TYPE_ID#",open_rows_);
										QuerySetCell(OPEN_INVOICE,"PROJECT_ID","#PROJECT_ID#",open_rows_);
									</cfscript>
								</cfloop>
							</cfif>
						</cfif>
						<cfquery name="GET_INV_RECORD" dbtype="query">
							SELECT
								TOTAL_SUB,
								TOTAL_OTHER_SUB,
								T_OTHER_MONEY,
								INVOICE_NUMBER,
								INVOICE_DATE,
								ROW_COUNT,
								DUE_DATE,
								INV_RATE,
								ACTION_TYPE_ID,
								PROJECT_ID
							FROM
							<cfif isDefined("attributes.is_other_money_transfer")>
								OPEN_INVOICE
							<cfelse>
								ALL_INVOICE
							</cfif>
							WHERE
							<cfif isDefined("attributes.is_other_money_transfer")>
								TOTAL_OTHER_SUB IS NOT NULL AND 
								TOTAL_OTHER_SUB <> 0
							<cfelse>
								TOTAL_SUB IS NOT NULL AND 
								TOTAL_SUB <> 0
							</cfif>
							<cfif isDefined("attributes.is_other_money_transfer")>
								AND T_OTHER_MONEY = '#get_comp_remainder_main.money#'
							</cfif>
							ORDER BY
								DUE_DATE
						</cfquery>
					</cfif>
				<cfelse>
					<cfset cari_toplam_tutar=0>
					<cfset cari_toplam_tutar1=0>
					<cfset cari_toplam_tutar2=0>
					<cfset cari_toplam_tutar1_all=0>
					<cfset cari_toplam_tutar1_all_act=0>
					<cfset cari_toplam_tutar2_all=0>
					<cfset total_kur_farki=0>
					<cfset total_money=0>
					<cfset cari_toplam_islem_tutar=0>
					<cfset toplam_value = 0>
					<cfset attributes.project_id = GET_COMP_REMAINDER_MAIN.PROJECT_ID>
					<cfquery name="GET_INV_RECORD" datasource="#dsn2#">
						SELECT 
							*
							FROM 
							(
							SELECT
								CR.ACTION_NAME,
								CR.PROCESS_CAT,
								CR.ACTION_ID,
								CR.PAPER_NO,
								CR.ACTION_TYPE_ID,
								CR.TO_CMP_ID,
								CR.FROM_CMP_ID,
								CR.TO_CONSUMER_ID,
								CR.FROM_CONSUMER_ID,
								CR.TO_EMPLOYEE_ID,
								CR.FROM_EMPLOYEE_ID,
								CR.ACTION_VALUE TOTAL_SUB,
								CR.ACTION_DATE AS INVOICE_DATE,
								CR.DUE_DATE,
								ISNULL(CR.OTHER_CASH_ACT_VALUE,0) AS TOTAL_OTHER_SUB,
								CR.OTHER_MONEY,		
								0 TOTAL_CLOSED_AMOUNT,
								0 OTHER_CLOSED_AMOUNT,
								'' T_OTHER_MONEY,
								0 KONTROL
								<cfif isdefined("attributes.is_other_money_transfer")>
									,(CR.ACTION_VALUE/ISNULL(CR.OTHER_CASH_ACT_VALUE,CR.ACTION_VALUE)) INV_RATE
								<cfelse>
									,1 INV_RATE
								</cfif>
							FROM 
								CARI_ROWS CR
							WHERE	
								<cfif isDefined("attributes.company_id") and len(attributes.company_id) and not len(attributes.employee_id)>
									(TO_CMP_ID =  #attributes.company_id# OR FROM_CMP_ID = #attributes.company_id#)
								<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
									(TO_CONSUMER_ID =  #attributes.consumer_id# OR FROM_CONSUMER_ID = #attributes.consumer_id#)
								<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
									(TO_EMPLOYEE_ID =  #attributes.employee_id# OR FROM_EMPLOYEE_ID = #attributes.employee_id#)
								</cfif>			
								<cfif isdefined("attributes.is_other_money_transfer")>
									AND ACTION_TYPE_ID NOT IN (48,49,45,46)
								</cfif>
								<cfif len(acc_type_id) and acc_type_id neq 0>
									AND ISNULL(ACC_TYPE_ID,0) = #acc_type_id#
								</cfif>
								<cfif session.ep.isBranchAuthorization>
									AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
								</cfif>
								AND CR.ACTION_VALUE > 0
								AND	CR.ACTION_ID NOT IN (
										SELECT 
											ICR.ACTION_ID 
										FROM 
											CARI_CLOSED_ROW ICR,CARI_CLOSED IC
										WHERE 
											ICR.CLOSED_ID = IC.CLOSED_ID 
											AND CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID
											AND ICR.CLOSED_AMOUNT IS NOT NULL
											AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS'))
											AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS'))
											AND CR.OTHER_MONEY = ICR.OTHER_MONEY	
											<cfif isDefined("attributes.company_id") and len(attributes.company_id) and not len(attributes.employee_id)>
												AND IC.COMPANY_ID =  #attributes.company_id#
											<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
												AND IC.CONSUMER_ID =  #attributes.consumer_id#
											<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
												AND 1=0
											</cfif>	
										)
								<cfif isDefined("attributes.due_date2") and isdate(attributes.due_date2) and isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
									AND CR.DUE_DATE BETWEEN #attributes.due_date1# AND #attributes.due_date2#
								<cfelseif isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
									AND CR.DUE_DATE >= #attributes.due_date1#
								<cfelseif isDefined("attributes.due_date2") and isdate(attributes.due_date2)>
									AND CR.DUE_DATE <= #attributes.due_date2#
								</cfif>
								<cfif isDefined("attributes.is_other_money_transfer")>
									AND CR.OTHER_MONEY = '#get_comp_remainder_main.money#'
								</cfif>
								<cfif len(attributes.project_id)>
									AND PROJECT_ID = #attributes.project_id#
								<cfelseif isdefined("attributes.is_project_group")>
									AND PROJECT_ID IS NULL
								</cfif>
							UNION ALL
							SELECT
								CR.ACTION_NAME,
								CR.PROCESS_CAT,
								CR.ACTION_ID,
								CR.PAPER_NO,
								CR.ACTION_TYPE_ID,
								CR.TO_CMP_ID,
								CR.FROM_CMP_ID,
								CR.TO_CONSUMER_ID,
								CR.FROM_CONSUMER_ID,
								CR.TO_EMPLOYEE_ID,
								CR.FROM_EMPLOYEE_ID,
								CR.ACTION_VALUE TOTAL_SUB,
								CR.ACTION_DATE AS INVOICE_DATE,
								CR.DUE_DATE,
								ISNULL(CR.OTHER_CASH_ACT_VALUE,0) AS TOTAL_OTHER_SUB,
								CR.OTHER_MONEY,		
								SUM(ICR.CLOSED_AMOUNT) TOTAL_CLOSED_AMOUNT,
								SUM(ICR.OTHER_CLOSED_AMOUNT) OTHER_CLOSED_AMOUNT,
								ICR.OTHER_MONEY T_OTHER_MONEY,
								1 KONTROL
								<cfif isdefined("attributes.is_other_money_transfer")>
									,(CR.ACTION_VALUE/ISNULL(CR.OTHER_CASH_ACT_VALUE,CR.ACTION_VALUE)) INV_RATE
								<cfelse>
									,1 INV_RATE
								</cfif>
							FROM 
								CARI_ROWS CR,
								CARI_CLOSED_ROW ICR,
								CARI_CLOSED
							WHERE		
								<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
									(TO_CMP_ID =  #attributes.company_id# OR FROM_CMP_ID = #attributes.company_id#) AND
									CARI_CLOSED.COMPANY_ID = #attributes.company_id#  AND 
								<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
									(TO_CONSUMER_ID =  #attributes.consumer_id# OR FROM_CONSUMER_ID = #attributes.consumer_id#) AND
									CARI_CLOSED.CONSUMER_ID = #attributes.consumer_id#  AND 
								<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
									1=0 AND
								</cfif>		
								CARI_CLOSED.CLOSED_ID = ICR.CLOSED_ID AND				
								<cfif isdefined("attributes.is_other_money_transfer")>
									CR.ACTION_TYPE_ID NOT IN (48,49,45,46) AND 
								</cfif>
								CR.ACTION_ID = ICR.ACTION_ID AND
								CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID AND 
								ICR.CLOSED_AMOUNT IS NOT NULL AND
								((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND
								(((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND
								CR.OTHER_MONEY = ICR.OTHER_MONEY
								AND CR.ACTION_VALUE > 0		
								<cfif session.ep.isBranchAuthorization>
									AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
								</cfif>		
								<cfif isDefined("attributes.due_date2") and isdate(attributes.due_date2) and isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
									AND CR.DUE_DATE BETWEEN #attributes.due_date1# AND #attributes.due_date2#
								<cfelseif isDefined("attributes.due_date1") and isdate(attributes.due_date1)>
									AND CR.DUE_DATE >= #attributes.due_date1#
								<cfelseif isDefined("attributes.due_date2") and isdate(attributes.due_date2)>
									AND CR.DUE_DATE <= #attributes.due_date2#
								</cfif>
								<cfif isDefined("attributes.is_other_money_transfer")>
									AND CR.OTHER_MONEY = '#get_comp_remainder_main.money#'
								</cfif>
								<cfif len(attributes.project_id)>
									AND CR.PROJECT_ID = #attributes.project_id#
								<cfelseif isdefined("attributes.is_project_group")>
									AND CR.PROJECT_ID IS NULL
								</cfif>
							GROUP BY
								CR.ACTION_NAME,
								CR.PROCESS_CAT,
								CR.ACTION_ID,
								CR.PAPER_NO,
								CR.ACTION_TYPE_ID,
								CR.TO_CMP_ID,
								CR.FROM_CMP_ID,
								CR.TO_CONSUMER_ID,
								CR.FROM_CONSUMER_ID,
								CR.TO_EMPLOYEE_ID,
								CR.FROM_EMPLOYEE_ID,
								CR.ACTION_VALUE,
								CR.ACTION_DATE,
								CR.DUE_DATE,
								CR.OTHER_CASH_ACT_VALUE,
								CR.OTHER_MONEY,
								ICR.OTHER_MONEY	
							)T1
							WHERE
							<cfif isDefined("attributes.is_other_money_transfer")>
								ROUND(OTHER_CLOSED_AMOUNT,2) <> ROUND(TOTAL_OTHER_SUB,2)<!--- kısmi kapamaları getirsn diye.. --->
							<cfelse>
								ROUND(TOTAL_CLOSED_AMOUNT,2) <> ROUND(TOTAL_SUB,2)
							</cfif>
							AND (ROUND(TOTAL_SUB,2) - ROUND(TOTAL_CLOSED_AMOUNT,2)) > 0.001
							ORDER BY
								DUE_DATE
					</cfquery>
					<cfquery name="GET_CLOSEDS" datasource="#DSN2#">
						SELECT DISTINCT
							CR.CLOSED_ID 
						FROM 
							CARI_CLOSED_ROW CCR,
							CARI_CLOSED CR
						WHERE 
							CCR.CLOSED_ID = CR.CLOSED_ID AND
							<cfif isDefined("attributes.company_id") and len(attributes.company_id)>	
								CR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
							<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
								CR.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">	
							<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
								1=0
							</cfif>
							<cfif isDefined("attributes.is_other_money_transfer")>
								AND CCR.OTHER_MONEY = '#get_comp_remainder_main.money#'
							</cfif>
						GROUP BY
							CR.CLOSED_ID 
					</cfquery>
					<cfquery name="GET_CLOSED_ACTIONS" datasource="#DSN2#">
						SELECT 
							CR.ACTION_NAME,
							CR.ACTION_ID,
							CR.PAPER_NO,
							CR.ACTION_TYPE_ID,
							CR.PROCESS_CAT,
							CR.TO_CMP_ID,
							CR.FROM_CMP_ID,
							CR.TO_CONSUMER_ID,
							CR.FROM_CONSUMER_ID,
							CR.TO_EMPLOYEE_ID,
							CR.FROM_EMPLOYEE_ID,
							CR.ACTION_VALUE,
							ISNULL(CR.PAPER_ACT_DATE,CR.ACTION_DATE) ACTION_DATE,
							CR.DUE_DATE,
							ISNULL(CR.OTHER_CASH_ACT_VALUE,0) OTHER_CASH_ACT_VALUE,
							CR.OTHER_MONEY,
							ICR.CLOSED_ID,	
							ICR.CLOSED_AMOUNT TOTAL_CLOSED_AMOUNT,
							ICR.OTHER_CLOSED_AMOUNT OTHER_CLOSED_AMOUNT,
							ICR.OTHER_MONEY I_OTHER_MONEY,
							(ICR.CLOSED_AMOUNT/ISNULL(ICR.OTHER_CLOSED_AMOUNT,ICR.CLOSED_AMOUNT)) INV_RATE
						FROM 
							CARI_ROWS CR,
							CARI_CLOSED_ROW ICR
						WHERE
							<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
								(TO_CMP_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> OR FROM_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">) AND
							<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
								(TO_CONSUMER_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> OR FROM_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">) AND
							<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
								(TO_EMPLOYEE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> OR FROM_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">) AND
							</cfif>		
							<cfif session.ep.isBranchAuthorization>
								AND	(CR.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CR.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
							</cfif>
							CR.ACTION_TYPE_ID NOT IN (48,49,45,46) AND
							CR.ACTION_ID = ICR.ACTION_ID AND
							CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID AND 
							ICR.CLOSED_AMOUNT IS NOT NULL AND
							((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND
							(((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND
							CR.OTHER_MONEY = ICR.OTHER_MONEY						
							<cfif isDefined("attributes.is_other_money_transfer")>
								AND CR.OTHER_MONEY = '#get_comp_remainder_main.money#'
							</cfif>
							AND ROUND(ICR.CLOSED_AMOUNT,2) > 0
						ORDER BY
							ICR.CLOSED_ROW_ID
					</cfquery>
					<cfloop query="get_closeds">
						<cfquery name="get_rows_b" dbtype="query">
							SELECT 
								* 
							FROM 
								GET_CLOSED_ACTIONS 
							WHERE 
								CLOSED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#closed_id#"> 
								<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
									AND TO_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> 
								<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
									AND TO_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> 
								<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
									AND TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> 
								</cfif>		
						</cfquery>
						<cfquery name="GET_ROWS_A" dbtype="query">
							SELECT 
								* 
							FROM 
								GET_CLOSED_ACTIONS 
							WHERE 
								CLOSED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#closed_id#"> 
								<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
									AND FROM_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> 
								<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
									AND FROM_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> 
								<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
									AND FROM_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> 
								</cfif>		
						</cfquery>
						<cfset row_ = get_rows_b.recordcount>
						<cfif get_rows_a.recordcount gt get_rows_b.recordcount>
							<cfset row_ = get_rows_a.recordcount>
						</cfif>
						<cfloop from="1" to="#row_#" index="ccc">
							<cfif ccc lte get_rows_b.recordcount>
								<cfif isDefined("attributes.is_doviz_group")>
									<cfset toplam_value = get_rows_b.other_closed_amount[ccc]>
								<cfelse>
									<cfset toplam_value = get_rows_b.total_closed_amount[ccc]>
								</cfif>
								<cfset cari_toplam_tutar1 = cari_toplam_tutar1 + get_rows_b.total_closed_amount[ccc]>
								<cfset cari_toplam_tutar = cari_toplam_tutar + get_rows_b.total_closed_amount[ccc]>
								<cfif len(get_rows_b.other_closed_amount[ccc])>
									<cfset cari_toplam_islem_tutar = cari_toplam_islem_tutar +get_rows_b.other_closed_amount[ccc]>
								</cfif>
								<cfif len(get_rows_b.due_date[ccc])>
									<cfset day_1 = DateDiff("d",get_rows_b.due_date[ccc],createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
								<cfelse>
									<cfset day_1 = DateDiff("d",get_rows_b.action_date[ccc],createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
								</cfif>
								<cfset day_2 = DateDiff("d",get_rows_b.action_date[ccc],createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
								<cfset cari_toplam_tutar1_all_act = cari_toplam_tutar1_all_act + (get_rows_b.total_closed_amount[ccc]*day_2)>
								<cfset cari_toplam_tutar1_all = cari_toplam_tutar1_all + (get_rows_b.total_closed_amount[ccc]*day_1)>
							</cfif>
							<cfif ccc lte get_rows_a.recordcount>
								<cfset last_rate = get_rows_a.INV_RATE[ccc]>
								<cfset cari_toplam_tutar2 = cari_toplam_tutar2 + get_rows_a.total_closed_amount[ccc]>
								<cfset total_money = total_money + get_rows_a.total_closed_amount[ccc]>
								<cfif len(get_rows_a.due_date[ccc])>
									<cfset day_2 = DateDiff("d",get_rows_a.due_date[ccc],createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
								<cfelse>
									<cfset day_2 = DateDiff("d",get_rows_a.action_date[ccc],createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
								</cfif>
								<cfset cari_toplam_tutar2_all = cari_toplam_tutar2_all + (get_rows_a.total_closed_amount[ccc]*day_2)>
							</cfif>
						</cfloop>
					</cfloop>
					<cfset total_kur_farki = wrk_round(cari_toplam_tutar2 - cari_toplam_tutar1)>
				</cfif>
				<cfset acik_fat_toplam_agirlik = 0>
				<cfset acik_fat_toplam = 0>
				<cfset acik_fat_toplam_agirlik2 = 0>

				<cfset acik_fat_toplam2 = 0>
				<cfset bakiye_ = 0>
				<cfset due_day = 0>
				<cfset due_day2 = 0>
				
				<cfloop query="GET_INV_RECORD">
					<cfif len(GET_INV_RECORD.DUE_DATE)>
						<cfset GUN_FARKI = DateDiff("d",DUE_DATE,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
					<cfelse>
						<cfset GUN_FARKI = DateDiff("d",INVOICE_DATE,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
					</cfif>
					<cfset GUN_FARKI2 = DateDiff("d",INVOICE_DATE,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
					<cfif GUN_FARKI eq 0><cfset GUN_FARKI=1></cfif>
					<cfif GUN_FARKI2 eq 0><cfset GUN_FARKI2=1></cfif>
					<cfif not isdefined("attributes.is_manuel")>
						<cfif isDefined("attributes.is_other_money_transfer")>
							<cfset acik_fat_toplam_agirlik = acik_fat_toplam_agirlik + ((TOTAL_OTHER_SUB*INV_RATE)*GUN_FARKI)>
							<cfset acik_fat_toplam_agirlik2 = acik_fat_toplam_agirlik2 + ((TOTAL_OTHER_SUB*INV_RATE)*GUN_FARKI2)>
						<cfelse>
							<cfset acik_fat_toplam_agirlik = acik_fat_toplam_agirlik + (TOTAL_SUB*GUN_FARKI)>
							<cfset acik_fat_toplam_agirlik2 = acik_fat_toplam_agirlik2 + (TOTAL_SUB*GUN_FARKI2)>
						</cfif>
						<cfif isDefined("attributes.is_other_money_transfer")>
							<cfset acik_fat_toplam = acik_fat_toplam+(TOTAL_OTHER_SUB*INV_RATE)>
							<cfset acik_fat_toplam2 = acik_fat_toplam2+(TOTAL_OTHER_SUB*INV_RATE)>
							<cfset bakiye_ = bakiye_ + TOTAL_OTHER_SUB>
						<cfelse>
							<cfset acik_fat_toplam = acik_fat_toplam+TOTAL_SUB>
							<cfset acik_fat_toplam2 = acik_fat_toplam2+TOTAL_SUB>
							<cfset bakiye_ = TOTAL_SUB/INV_RATE>
						</cfif>
					<cfelse>
						<cfif isDefined("attributes.is_other_money_transfer")>
							<cfset acik_fat_toplam2 = acik_fat_toplam2 + (((TOTAL_OTHER_SUB-OTHER_CLOSED_AMOUNT)*INV_RATE))>
							<cfset acik_fat_toplam_agirlik = acik_fat_toplam_agirlik + (((TOTAL_OTHER_SUB-OTHER_CLOSED_AMOUNT)*INV_RATE)*GUN_FARKI)>
							<cfset acik_fat_toplam_agirlik2 = acik_fat_toplam_agirlik2 + (((TOTAL_OTHER_SUB-OTHER_CLOSED_AMOUNT)*INV_RATE)*GUN_FARKI2)>
						<cfelse>
							<cfset acik_fat_toplam2 = acik_fat_toplam2 + ((TOTAL_SUB-TOTAL_CLOSED_AMOUNT))>
							<cfset acik_fat_toplam_agirlik = acik_fat_toplam_agirlik + ((TOTAL_SUB-TOTAL_CLOSED_AMOUNT)*GUN_FARKI)>
							<cfset acik_fat_toplam_agirlik2 = acik_fat_toplam_agirlik2 + ((TOTAL_SUB-TOTAL_CLOSED_AMOUNT)*GUN_FARKI2)>
						</cfif>
						<cfif isDefined("attributes.is_other_money_transfer")>
							<cfif len(to_consumer_id) or len(to_cmp_id) or len(to_employee_id)>
								<cfset acik_fat_toplam = acik_fat_toplam+((TOTAL_OTHER_SUB-OTHER_CLOSED_AMOUNT)*INV_RATE)>
								<cfset bakiye_ = bakiye_ + (TOTAL_OTHER_SUB-OTHER_CLOSED_AMOUNT)>
							<cfelse>
								<cfset acik_fat_toplam = acik_fat_toplam-((TOTAL_OTHER_SUB-OTHER_CLOSED_AMOUNT)*INV_RATE)>
								<cfset bakiye_ = bakiye_ - (TOTAL_OTHER_SUB-OTHER_CLOSED_AMOUNT)>
							</cfif>
						<cfelse>
							<cfif len(to_consumer_id) or len(to_cmp_id) or len(to_employee_id)>
								<cfset acik_fat_toplam = acik_fat_toplam+(TOTAL_SUB-TOTAL_CLOSED_AMOUNT)>
								<cfset bakiye_ = (TOTAL_SUB-TOTAL_CLOSED_AMOUNT)/INV_RATE>
							<cfelse>
								<cfset acik_fat_toplam = acik_fat_toplam-(TOTAL_SUB-TOTAL_CLOSED_AMOUNT)>
								<cfset bakiye_ = (TOTAL_SUB-TOTAL_CLOSED_AMOUNT)/INV_RATE>
							</cfif>
						</cfif>
					</cfif>
					<cfset money = T_OTHER_MONEY>
				</cfloop>
				<cfif acik_fat_toplam2 neq 0>
					<cfset due_day = acik_fat_toplam_agirlik/acik_fat_toplam2>
					<cfset due_day2 = acik_fat_toplam_agirlik2/acik_fat_toplam2>
				</cfif>
				<cfif attributes.is_detail neq 1 or (attributes.is_detail eq 1 and attributes.detail_type eq 4)>
					<cfif isdefined("attributes.is_other_money_transfer")>
						<cfset 'toplam_#trim(money)#' = (evaluate('toplam_#trim(money)#')) + bakiye_>
						<cfset 'borc_#trim(money)#' = (evaluate('borc_#trim(money)#')) + borc>
                        <cfset 'alacak_#trim(money)#' = (evaluate('alacak_#trim(money)#')) + alacak>
					<cfelse>
						<cfset 'toplam_#trim(money)#' = (evaluate('toplam_#trim(money)#')) + bakiye_>
						<cfset 'borc_#trim(money)#' = (evaluate('borc_#trim(money)#')) + borc>
                        <cfset 'alacak_#trim(money)#' = (evaluate('alacak_#trim(money)#')) + alacak>
					</cfif>
					<cfset acik_fat_toplamlari = acik_fat_toplamlari + acik_fat_toplam>
					<cfset acik_fat_toplam_due_day = acik_fat_toplam_due_day + (acik_fat_toplam * due_day)>
					<cfif acik_fat_toplamlari neq 0>
						<cfset vade_farki = acik_fat_toplam_due_day/acik_fat_toplamlari>
					<cfelse>
						<cfset vade_farki = 1>
					</cfif>
					<cfset colspan_info = 2>
					<cfif attributes.is_detail neq 1>
						<tr>
							<td>#member_code#</td>
							<td width="200">
								<cfif attributes.is_excel neq 1 and attributes.is_excel neq 2>
									<cfif attributes.action_type eq 1>
										<a href="javascript://"   onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_comp_remainder_main.company_id#','list')">
											#get_comp_remainder_main.fullname#
										</a>
									<cfelseif attributes.action_type eq 2>
										<a href="javascript://"   onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_comp_remainder_main.company_id#','list')">
											#get_comp_remainder_main.fullname#
										</a>
									<cfelse>
										<a href="javascript://"   onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_comp_remainder_main.company_id#','list')">
											#get_comp_remainder_main.fullname# <cfif len(acc_type_name)> -  #acc_type_name#</cfif>
										</a>
									</cfif> 
								<cfelse>
									#get_comp_remainder_main.fullname#
								</cfif>
							</td>
                            <cfif listfind(attributes.list_type,9)>
								<cfset colspan_ = colspan_info + 1>
								<td>
									<cfif len(get_comp_remainder_main.iban_code)>
										#get_comp_remainder_main.iban_code#
									</cfif>
								</td>
							</cfif>
							<cfif attributes.action_type neq 3 and listfind(attributes.list_type,1)>
								<cfset colspan_ = colspan_info + 1>
								<td>
									<cfif len(value_id_list) and len(get_comp_remainder_main.value_id)>
										#get_val_name.customer_value[listfind(value_id_list,get_comp_remainder_main.value_id,',')]#
									</cfif>
								</td>
							</cfif>
							<cfif isdefined("attributes.is_project_group")>
								<cfset colspan_info = colspan_info + 1>
								<td>
									<cfif len(project_id_list)>
										#get_pro_name.project_head[listfind(project_id_list,get_comp_remainder_main.project_id,',')]#
									</cfif>
								</td>
							</cfif>
							<cfif attributes.action_type neq 3>
								<cfif listfind(attributes.list_type,3)>
									<cfset colspan_info = colspan_info + 1>
									<td>
										<cfif len(pay_method) and len(pay_id_list)>
											#get_pay_name.paymethod[listfind(pay_id_list,get_comp_remainder_main.pay_method,',')]#
										</cfif>
									</td>
								</cfif>
								<cfif listfind(attributes.list_type,4)>
									<cfset colspan_info = colspan_info + 1>
									<td>
										<cfif len(rev_method) and len(pay_id_list)>
											#get_pay_name.paymethod[listfind(pay_id_list,get_comp_remainder_main.rev_method,',')]#
										</cfif>
									</td>
								</cfif>
								<cfif listfind(attributes.list_type,5)>
									<cfset colspan_info = colspan_info + 1>
									<cfif len(city_id_list)>#get_city_name.plate_code[listfind(city_id_list,city,',')]#</cfif>
									<!--- <td><cfif isdefined("plate_code") and len(plate_code)>#plate_code#</cfif></td> --->
								</cfif>
								<cfif listfind(attributes.list_type,6)>
									<cfset colspan_info = colspan_info + 1>
									<td><cfif len(zone_id_list)>#get_zone_name.sz_name[listfind(zone_id_list,sales_county,',')]#</cfif></td>
								</cfif>
								<cfif listfind(attributes.list_type,10)>
									<cfset colspan_info = colspan_info + 1> 									
									<td><cfif len(ims_id_list)>#get_ims_name.IMS_CODE_NAME[listfind(ims_id_list,ims_code_id,',')]#</cfif></td>
								</cfif>
								<cfif listfind(attributes.list_type,7)>
									<cfset colspan_info = colspan_info + 1>
									<td>
										<cfif len(comp_id_list)>
											<cfif attributes.is_excel neq 1 and attributes.is_excel neq 2> 
												<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&pos_code=#get_comp_remainder_main.position_code#','medium');" >
													#get_comp_remainder_main.employee#
												</a>
											<cfelse>
												#get_comp_remainder_main.employee#
											</cfif>
										</cfif>
									</td>
								</cfif>
								<cfif listfind(attributes.list_type,8)>
									<cfset colspan_info = colspan_info + 1>
									<td nowrap="nowrap">#companycat#</td>
								</cfif>
							</cfif>
							<!--- borc --->
							<td style="text-align:right;" nowrap="nowrap" format="numeric">
								#tlformat(borc)#
							</td>
							<!--- alacak --->
							<td style="text-align:right;" nowrap="nowrap" format="numeric">
								#tlformat(alacak)#
							</td>
							<!--- bakiye --->
							<td style="text-align:right;" nowrap="nowrap" format="numeric">
								<cfif len(acc_type_id) and acc_type_id neq 0><cfset acc_type_id__ = acc_type_id><cfelse><cfset acc_type_id__ = ""></cfif>
								<cfif attributes.is_excel neq 1 and attributes.is_excel neq 2>
									<a href="javascript://" onclick="sayfa_getir(#get_comp_remainder_main.currentrow#,#get_comp_remainder_main.company_id#<cfif isdefined("attributes.is_other_money_transfer")>,1,'#get_comp_remainder_main.money#'<cfelse>,0,''</cfif>,<cfif len(get_comp_remainder_main.project_id)>#get_comp_remainder_main.project_id#<cfelse>''</cfif>,<cfif isdefined("attributes.is_project_group")>1<cfelse>0</cfif>,<cfif bakiye_kontrol lt 0>1<cfelse>0</cfif>,#add_bank_order#,#acc_type_id__#)"  title="Ödeme Performansı">
										<cfif isdefined("attributes.is_other_money_transfer")>
											#tlformat(abs(bakiye_))# 
										<cfelse>
											#tlformat(abs(acik_fat_toplam))# 
										</cfif>
									</a>
								<cfelse>
									<cfif isdefined("attributes.is_other_money_transfer")>
										#tlformat(abs(bakiye_))# 
									<cfelse>
										#tlformat(abs(acik_fat_toplam))# 
									</cfif>
								</cfif>
							</td>
							<!--- b/a --->
							<td style="text-align:center;" nowrap="nowrap">
								<cfif bakiye_kontrol gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif>
							</td>
							<cfif isdefined("attributes.is_other_money_transfer")>
								<td>
									#get_comp_remainder_main.money#
								</td>
							</cfif>
							<td style="text-align:right;">
								#dateformat(date_add('d',(-1*due_day2),now()),dateformat_style)#
							</td>
							<td style="text-align:right;" format="numeric">
								<cfif attributes.is_excel neq 2>
									<cfif isdefined("attributes.is_finish_day")>
										<cfset depend_finish_date = DateDiff("d",#dateformat(date_add('d',(-1*due_day2),now()),'yyyy/mm/dd')#,createodbcdatetime('#year(attributes.action_date2)#-#month(attributes.action_date2)#-#day(attributes.action_date2)#'))>
										#tlformat(depend_finish_date,2)#
									<cfelse>
										#tlformat(due_day2,2)# 
									</cfif>
								</cfif>
							</td>
							<td style="text-align:right;">
								#dateformat(date_add('d',(-1*due_day),now()),dateformat_style)#
							</td>
							<td style="text-align:right;" format="numeric">
								<cfif attributes.is_excel neq 2>
									<cfif isdefined("attributes.is_finish_day")>
										<cfset depend_finish_date = DateDiff("d",#dateformat(date_add('d',(-1*due_day),now()),'yyyy/mm/dd')#,createodbcdatetime('#year(attributes.action_date2)#-#month(attributes.action_date2)#-#day(attributes.action_date2)#'))>
										#tlformat(depend_finish_date,2)#
									<cfelse>
										#tlformat(due_day,2)# 
									</cfif>
								</cfif>
							</td>
						 </tr>
					<cfelse>
						<cfif cari_toplam_islem_tutar gt 0>										
							<cfset total_diff_1 = TAKEN_INV_RATES + CLAIM_RATES><!--- alınan kur farkı toplam --->
							<cfset total_diff_2 = GIVEN_INV_RATES + DEBT_RATES><!--- verilen kur farkı toplam --->
						<cfelse>
							<cfset total_diff_1 = 0>
							<cfset total_diff_2 = 0>
						</cfif>
						<cfif total_kur_farki gt 0>
							<cfset new_diff = total_kur_farki - (total_diff_2-total_diff_1)>
						<cfelseif total_kur_farki lte 0>
							<cfset new_diff = total_kur_farki + (total_diff_1 - total_diff_2)>
						<cfelse>
							<cfset new_diff = 0>
						</cfif>
						<cfif new_diff neq 0>
                            <cfset zero_count = zero_count + 1>
                        </cfif>
                        <cfif zero_diff_rate eq 0 or (zero_diff_rate eq 1 and new_diff neq 0 and zero_count gte attributes.startrow and zero_count lt attributes.maxrows+attributes.startrow)>
                            <cfscript>
                                total_cari_toplam_islem_tutar = total_cari_toplam_islem_tutar+cari_toplam_tutar;
                                total_all_money =total_all_money + total_money;
                                total_taken_inv_rates = total_taken_inv_rates+TAKEN_INV_RATES;
                                total_given_inv_rates = total_given_inv_rates+GIVEN_INV_RATES;
                                total_claim_rates = total_claim_rates+CLAIM_RATES;
                                total_debt_rates = total_debt_rates+DEBT_RATES;
                            </cfscript>
                            <tr>
                                <td>#member_code#</td>
                                <td>
                                    <cfif attributes.is_excel neq 1 and attributes.is_excel neq 2>
                                        <cfif attributes.action_type eq 1>
                                            <a href="javascript://"   onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_comp_remainder_main.company_id#','list')">
                                                #get_comp_remainder_main.fullname#
                                            </a>
                                        <cfelseif attributes.action_type eq 2>
                                            <a href="javascript://"   onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_comp_remainder_main.company_id#','list')">
                                                #get_comp_remainder_main.fullname#
                                            </a>
                                        <cfelse>
                                            #get_comp_remainder_main.fullname#
                                        </cfif> 
                                    <cfelse>#get_comp_remainder_main.fullname#</cfif>
                                </td>
                                <td>#get_comp_remainder_main.money#</td>
                                <td style="text-align:right;" format="numeric">#tlformat(cari_toplam_tutar)#</td>
                                <td style="text-align:right;" format="numeric">#tlformat(cari_toplam_islem_tutar)#</td>
                                <td style="text-align:right;" format="numeric">
                                    <cfif attributes.is_excel neq 1 and attributes.is_excel neq 2> 
                                        <a href="javascript://" onclick="sayfa_getir(#get_comp_remainder_main.currentrow#,#get_comp_remainder_main.company_id#<cfif isdefined("attributes.is_other_money_transfer")>,1,'#get_comp_remainder_main.money#'<cfelse>,0,''</cfif>,<cfif len(get_comp_remainder_main.project_id)>#get_comp_remainder_main.project_id#<cfelse>''</cfif>,<cfif isdefined("attributes.is_project_group")>1<cfelse>0</cfif>,<cfif bakiye_kontrol lt 0>1<cfelse>0</cfif>,#add_bank_order#)"  title="<cf_get_lang dictionary_id='57802.Ödeme Performansı'>">
                                            #tlformat(total_money)#
                                        </a>
                                    <cfelse>
                                        #tlformat(total_money)#
                                    </cfif>
                                </td>
                                <td style="text-align:right;" format="numeric">#tlformat(TAKEN_INV_RATES)#</td>
                                <td style="text-align:right;" format="numeric">#tlformat(GIVEN_INV_RATES)#</td>
                                <td style="text-align:right;" format="numeric">#tlformat(CLAIM_RATES)#</td>
                                <td style="text-align:right;" format="numeric">#tlformat(DEBT_RATES)#</td>
                                <cfif new_diff lt 0>
                                    <cfset total_taken= total_taken + new_diff>
                                    <td	style="text-align:right;" format="numeric">#TLFormat(new_diff)#</td>
                                    <td ></td>
                                <cfelseif new_diff gte 0>
                                    <cfset total_given= total_given + new_diff>
                                    <td ></td>
                                    <td style="text-align:right;" format="numeric">#TLFormat(new_diff)#</td>
                                </cfif>
                                <cfif attributes.is_excel neq 1 and attributes.is_excel neq 2> 
                                    <td>					
                                        <cfif new_diff gt 0>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=invoice.form_add_bill<cfif attributes.action_type eq 1>&company_id=#company_id#<cfelseif attributes.action_type eq 2>&consumer_id=#consumer_id#<cfelse>&employee_id=#employee_id#</cfif>','wide');">
                                                <img src="/images/notkalem.gif" border="0" title="Kur Farkı Faturası Kes">
                                            </a>										
                                        <cfelseif new_diff lt 0>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=invoice.form_add_bill_purchase<cfif attributes.action_type eq 1>&company_id=#company_id#<cfelseif attributes.action_type eq 2>&consumer_id=#consumer_id#<cfelse>&employee_id=#employee_id#</cfif>','wide');">
                                                <img src="/images/notkalem.gif" border="0" title="Kur Farkı Faturası Kes">
                                            </a>										
                                        </cfif>
                                    </td>
                                </cfif>
                            </tr>	
                        </cfif>
					</cfif>														
					<cfif attributes.is_excel neq 1 and attributes.is_excel neq 2> 
						<tr class="nohover" style="display:none;" id="dsp_make_age_#get_comp_remainder_main.currentrow#">
							<td colspan="16">
								<div id="show_dsp_make#get_comp_remainder_main.currentrow#" style="outset cccccc;"></div>
							</td>
						</tr>
					</cfif>
				<cfelseif attributes.is_detail eq 1 and attributes.is_excel neq 1 and attributes.is_excel neq 2>
					<cfif ((attributes.detail_type eq 2 or attributes.detail_type eq 3)) or attributes.detail_type eq 1 or not len(attributes.detail_type)>
						<cfif len(acc_type_id) and acc_type_id neq 0>
							<cfquery name="get_acc_type" datasource="#dsn#">
								SELECT ACC_TYPE_ID,ACC_TYPE_NAME FROM SETUP_ACC_TYPE WHERE ACC_TYPE_ID = #acc_type_id# 
							</cfquery>
						</cfif>
						<cfif len(acc_type_id) and acc_type_id neq 0>
							<cfset acc_type_id_ = acc_type_id>
						<cfelse>
							<cfset acc_type_id_ = "">
						</cfif>
						<tr class="total" onclick="gizle_goster(dsp_make_age_#get_comp_remainder_main.currentrow#)" style="cursor:pointer;">
							<td class="formbold" nowrap="nowrap" colspan="13">#fullname# <cfif isdefined("get_acc_type") and get_acc_type.recordcount>- #get_acc_type.ACC_TYPE_NAME#</cfif><cfif isdefined("attributes.is_other_money_transfer")>:#money#</cfif>
								<cfif isdefined("attributes.is_project_group") and len(project_id)>/#project_head#</cfif>
							</td>
						</tr>
						<tr class="nohover" id="dsp_make_age_#get_comp_remainder_main.currentrow#">
							<td colspan="13">
								<div id="show_dsp_make#get_comp_remainder_main.currentrow#"></div>
							</td>
						 </tr>
						 <cfif isdefined("GET_INV_RECORD.PROCESS_CAT") and len(GET_INV_RECORD.PROCESS_CAT)>
							<cfquery name="get_process_cat_info" datasource="#dsn3#">
								SELECT IS_ROW_PROJECT_BASED_CARI FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #GET_INV_RECORD.PROCESS_CAT#
							</cfquery>
							<cfset IS_ROW_PROJECT_BASED_CARI = get_process_cat_info.IS_ROW_PROJECT_BASED_CARI>
						<cfelse>
							<cfset IS_ROW_PROJECT_BASED_CARI = 0>
						</cfif>
						 <script type="text/javascript">
						 
							<cfif not isdefined("attributes.is_manuel")>
								<cfif isdefined("is_make_age_date") and is_make_age_date eq 1>
									is_make_age_date = 1;
									if(document.rapor.is_pay_cheques.checked == true)
										is_pay_cheque = 1;
									else
										is_pay_cheque = 0;
								<cfelse>
									is_make_age_date = 0;
									is_pay_cheque = 0;
								</cfif>
								if(document.rapor.is_other_money_transfer.checked == true)
								{
									if(rapor.action_type[0].checked)
										AjaxPageLoad('#request.self#?fuseaction=report.emptypopup_dsp_make_age&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&is_report=1&is_pay_cheque='+is_pay_cheque+'&is_make_age_date='+is_make_age_date+'&row_id=#currentrow#&is_ajax_popup&other_money=#money#&is_doviz_group=1&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date1='+document.rapor.action_date1.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&company_id=#company_id#&acc_type_id=#acc_type_id_#&project_id=#trim(project_id)#&detail_type='+document.rapor.detail_type.value+'&bakiye_kontrol=<cfif bakiye_kontrol lt 0>1<cfelse>0</cfif>&add_bank_order=#add_bank_order#&<cfif isdefined("attributes.is_project_group")>is_project_group=1<cfelse>is_project_group=0</cfif>','show_dsp_make#currentrow#');
									else if(rapor.action_type[1].checked)
										AjaxPageLoad('#request.self#?fuseaction=report.emptypopup_dsp_make_age&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&is_report=1&is_pay_cheque='+is_pay_cheque+'&is_make_age_date='+is_make_age_date+'&row_id=#currentrow#&is_ajax_popup&other_money=#money#&is_doviz_group=1&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date1='+document.rapor.action_date1.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&consumer_id=#company_id#&acc_type_id=#acc_type_id_#&project_id=#trim(project_id)#&detail_type='+document.rapor.detail_type.value+'&bakiye_kontrol=<cfif bakiye_kontrol lt 0>1<cfelse>0</cfif>&add_bank_order=#add_bank_order#&<cfif isdefined("attributes.is_project_group")>is_project_group=1<cfelse>is_project_group=0</cfif>','show_dsp_make#currentrow#');
									else	
										AjaxPageLoad('#request.self#?fuseaction=report.emptypopup_dsp_make_age&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&is_report=1&is_pay_cheque='+is_pay_cheque+'&is_make_age_date='+is_make_age_date+'&row_id=#currentrow#&is_ajax_popup&other_money=#money#&is_doviz_group=1&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date1='+document.rapor.action_date1.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&employee_id=#company_id#&acc_type_id=#acc_type_id_#&project_id=#trim(project_id)#&detail_type='+document.rapor.detail_type.value+'&bakiye_kontrol=<cfif bakiye_kontrol lt 0>1<cfelse>0</cfif>&add_bank_order=#add_bank_order#&<cfif isdefined("attributes.is_project_group")>is_project_group=1<cfelse>is_project_group=0</cfif>','show_dsp_make#currentrow#');
								}
								else
								{
									if(rapor.action_type[0].checked)
										AjaxPageLoad('#request.self#?fuseaction=report.emptypopup_dsp_make_age&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&is_report=1&is_pay_cheque='+is_pay_cheque+'&is_make_age_date='+is_make_age_date+'&row_id=#currentrow#&is_ajax_popup&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date1='+document.rapor.action_date1.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&company_id=#company_id#&acc_type_id=#acc_type_id_#&project_id=#trim(project_id)#&detail_type='+document.rapor.detail_type.value+'&bakiye_kontrol=<cfif bakiye_kontrol lt 0>1<cfelse>0</cfif>&add_bank_order=#add_bank_order#&<cfif isdefined("attributes.is_project_group")>is_project_group=1<cfelse>is_project_group=0</cfif>','show_dsp_make#currentrow#');
									else if(rapor.action_type[1].checked)
										AjaxPageLoad('#request.self#?fuseaction=report.emptypopup_dsp_make_age&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&is_report=1&is_pay_cheque='+is_pay_cheque+'&is_make_age_date='+is_make_age_date+'&row_id=#currentrow#&is_ajax_popup&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date1='+document.rapor.action_date1.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&consumer_id=#company_id#&acc_type_id=#acc_type_id_#&project_id=#trim(project_id)#&detail_type='+document.rapor.detail_type.value+'&bakiye_kontrol=<cfif bakiye_kontrol lt 0>1<cfelse>0</cfif>&add_bank_order=#add_bank_order#&<cfif isdefined("attributes.is_project_group")>is_project_group=1<cfelse>is_project_group=0</cfif>','show_dsp_make#currentrow#');
									else
										AjaxPageLoad('#request.self#?fuseaction=report.emptypopup_dsp_make_age&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&is_report=1&is_pay_cheque='+is_pay_cheque+'&is_make_age_date='+is_make_age_date+'&row_id=#currentrow#&is_ajax_popup&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date1='+document.rapor.action_date1.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&employee_id=#company_id#&acc_type_id=#acc_type_id_#&project_id=#trim(project_id)#&detail_type='+document.rapor.detail_type.value+'&bakiye_kontrol=<cfif bakiye_kontrol lt 0>1<cfelse>0</cfif>&add_bank_order=#add_bank_order#&<cfif isdefined("attributes.is_project_group")>is_project_group=1<cfelse>is_project_group=0</cfif>','show_dsp_make#currentrow#');
								}
							<cfelse>
								
								if(document.rapor.is_duedate_group.checked == true)
									due_control = 1;
								else
									due_control = 0;
								if(document.rapor.is_other_money_transfer.checked == true)
								{
									if(rapor.action_type[0].checked)
										AjaxPageLoad('#request.self#?fuseaction=report.emptypopup_dsp_make_age_manuel&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&is_report=1&row_id=#currentrow#&is_ajax_popup&other_money=#money#&is_duedate_group='+due_control+'&is_doviz_group=1&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&company_id=#company_id#&acc_type_id=#acc_type_id_#&project_id=#trim(project_id)#&project_head=#project_id#&detail_type='+document.rapor.detail_type.value+'&bakiye_kontrol=<cfif bakiye_kontrol lt 0>1<cfelse>0</cfif>&add_bank_order=#add_bank_order#&<cfif isdefined("attributes.is_project_group")>is_project_group=1<cfelse>is_project_group=0</cfif>&IS_ROW_PROJECT_BASED_CARI=#IS_ROW_PROJECT_BASED_CARI#','show_dsp_make#currentrow#');
									else if(rapor.action_type[1].checked)
										AjaxPageLoad('#request.self#?fuseaction=report.emptypopup_dsp_make_age_manuel&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&is_report=1&row_id=#currentrow#&is_ajax_popup&other_money=#money#&is_duedate_group='+due_control+'&is_doviz_group=1&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&consumer_id=#company_id#&acc_type_id=#acc_type_id_#&project_id=#trim(project_id)#&project_head=#project_id#&detail_type='+document.rapor.detail_type.value+'&bakiye_kontrol=<cfif bakiye_kontrol lt 0>1<cfelse>0</cfif>&add_bank_order=#add_bank_order#&<cfif isdefined("attributes.is_project_group")>is_project_group=1<cfelse>is_project_group=0</cfif>&IS_ROW_PROJECT_BASED_CARI=#IS_ROW_PROJECT_BASED_CARI#','show_dsp_make#currentrow#');
									else
										AjaxPageLoad('#request.self#?fuseaction=report.emptypopup_dsp_make_age_manuel&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&row_id=#currentrow#&is_ajax_popup&other_money=#money#&is_duedate_group='+due_control+'&is_doviz_group=1&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&employee_id=#company_id#&acc_type_id=#acc_type_id_#&project_id=#trim(project_id)#&project_head=#project_id#&detail_type='+document.rapor.detail_type.value+'&bakiye_kontrol=<cfif bakiye_kontrol lt 0>1<cfelse>0</cfif>&add_bank_order=#add_bank_order#&<cfif isdefined("attributes.is_project_group")>is_project_group=1<cfelse>is_project_group=0</cfif>&IS_ROW_PROJECT_BASED_CARI=#IS_ROW_PROJECT_BASED_CARI#','show_dsp_make#currentrow#');
								}
								else
								{
									if(rapor.action_type[0].checked)
										AjaxPageLoad('#request.self#?fuseaction=report.emptypopup_dsp_make_age_manuel&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&is_report=1&row_id=#currentrow#&is_duedate_group='+due_control+'&is_ajax_popup&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&company_id=#company_id#&acc_type_id=#acc_type_id_#&project_id=#trim(project_id)#&project_head=#project_id#&detail_type='+document.rapor.detail_type.value+'&bakiye_kontrol=<cfif bakiye_kontrol lt 0>1<cfelse>0</cfif>&add_bank_order=#add_bank_order#&<cfif isdefined("attributes.is_project_group")>is_project_group=1<cfelse>is_project_group=0</cfif>&IS_ROW_PROJECT_BASED_CARI=#IS_ROW_PROJECT_BASED_CARI#','show_dsp_make#currentrow#');
									else if(rapor.action_type[1].checked)
										AjaxPageLoad('#request.self#?fuseaction=report.emptypopup_dsp_make_age_manuel&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&is_report=1&row_id=#currentrow#&is_duedate_group='+due_control+'&is_ajax_popup&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&consumer_id=#company_id#&acc_type_id=#acc_type_id_#&project_id=#trim(project_id)#&project_head=#project_id#&detail_type='+document.rapor.detail_type.value+'&bakiye_kontrol=<cfif bakiye_kontrol lt 0>1<cfelse>0</cfif>&add_bank_order=#add_bank_order#&<cfif isdefined("attributes.is_project_group")>is_project_group=1<cfelse>is_project_group=0</cfif>&IS_ROW_PROJECT_BASED_CARI=#IS_ROW_PROJECT_BASED_CARI#','show_dsp_make#currentrow#');
									else
										AjaxPageLoad('#request.self#?fuseaction=report.emptypopup_dsp_make_age_manuel&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&is_report=1&row_id=#currentrow#&is_duedate_group='+due_control+'&is_ajax_popup&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&employee_id=#company_id#&acc_type_id=#acc_type_id_#&project_id=#trim(project_id)#&project_head=#project_id#&detail_type='+document.rapor.detail_type.value+'&bakiye_kontrol=<cfif bakiye_kontrol lt 0>1<cfelse>0</cfif>&add_bank_order=#add_bank_order#&<cfif isdefined("attributes.is_project_group")>is_project_group=1<cfelse>is_project_group=0</cfif>&IS_ROW_PROJECT_BASED_CARI=#IS_ROW_PROJECT_BASED_CARI#','show_dsp_make#currentrow#');
								}
							</cfif>
						 </script>
					</cfif>
				</cfif>
			</cfoutput>
            </tbody>
			<cfif isdefined("attributes.is_detail") and attributes.is_detail eq 1 and attributes.detail_type eq 4>
					<cfoutput>
                    <tfoot>
                        <tr>
                            <cfif attributes.action_type neq 3>
                                <cfset cols =3>
                            <cfelse>
                                <cfset cols=6>
                            </cfif>
                            <td colspan="<cfoutput>#cols#</cfoutput>">Toplam</td>
                            <td style="text-align:right;" format="numeric">#TLFormat(total_cari_toplam_islem_tutar)#</td>
                            <td></td>
                            <td style="text-align:right;" format="numeric">#TLFormat(total_all_money)#</td>
                            <td style="text-align:right;" format="numeric">#TLFormat(total_taken_inv_rates)#</td>
                            <td style="text-align:right;" format="numeric">#TLFormat(total_given_inv_rates)#</td>
                            <td style="text-align:right;" format="numeric">#TLFormat(total_claim_rates)#</td>
                            <td style="text-align:right;" format="numeric">#TLFormat(total_debt_rates)#</td>
                            <td style="text-align:right;" format="numeric">#TLFormat(total_taken)#</td>
                            <td style="text-align:right;" format="numeric">#TLFormat(total_given)#</td>	
                            <td></td>							
                        </tr>
                    </tfoot>
					</cfoutput>				
			</cfif>
			<cfif attributes.is_excel neq 2> 

			</cfif>
			<cfif attributes.is_detail neq 1>
            <tfoot>
                <tr>
                    <cfif type_ eq 1><cfset class="txtbold"><cfelse><cfset class="txtboldblue"></cfif>
                    <td style="text-align:right;" colspan="<cfoutput>#colspan_info#</cfoutput>"><cf_get_lang dictionary_id="57492.Toplam"></td>
					<!--- toplam borc --->
					<td class="<cfoutput>#class#</cfoutput>" style="text-align:right;" nowrap="nowrap">
						<cfloop query="get_money">
                            <cfif evaluate('borc_#money#') neq 0>
                                <cfoutput>
                                    #TLFormat(evaluate('borc_#money#'))# #money#<cfif attributes.is_excel neq 2><br /></cfif>
                                </cfoutput>
                            </cfif>
                        </cfloop>
					</td>
					<!--- toplam alacak --->
					<td class="<cfoutput>#class#</cfoutput>" style="text-align:right;" nowrap="nowrap">
						<cfloop query="get_money">
                            <cfif evaluate('alacak_#money#') neq 0>
                                <cfoutput>
                                    #TLFormat(evaluate('alacak_#money#'))# #money#<cfif attributes.is_excel neq 2><br /></cfif>
                                </cfoutput>
                            </cfif>
                        </cfloop>
					</td>
					<!--- toplam bakiye --->
                    <td class="<cfoutput>#class#</cfoutput>" style="text-align:right;" nowrap="nowrap">
                        <cfloop query="get_money">
                            <cfif evaluate('borc_#money#') neq 0 or evaluate('alacak_#money#') neq 0>
								<cfoutput>
									<cfif not isdefined("attributes.is_other_money_transfer")>
										<cfif bakiye_kontrol gt 0>
											#TLFormat(evaluate('borc_#money#')-evaluate('alacak_#money#'))# #money#<cfif attributes.is_excel neq 2><br /></cfif>
										<cfelse>
											#TLFormat(evaluate('alacak_#money#')-evaluate('borc_#money#'))# #money#<cfif attributes.is_excel neq 2><br /></cfif>
										</cfif>
									<cfelse>
										<cfif (evaluate('borc_#money#')-evaluate('alacak_#money#')) gt 0>
											#TLFormat(evaluate('borc_#money#')-evaluate('alacak_#money#'))# #money#<cfif attributes.is_excel neq 2><br /></cfif>
										<cfelse>
											#TLFormat(evaluate('alacak_#money#')-evaluate('borc_#money#'))# #money#<cfif attributes.is_excel neq 2><br /></cfif>
										</cfif>
									</cfif>
                                </cfoutput>
                            </cfif>
                        </cfloop>
                    </td>
                    <td class="#class#" style="text-align:center;">
                        <cfloop query="get_money">
                            <cfoutput>
								<cfif evaluate('borc_#money#') neq 0 or evaluate('alacak_#money#') neq 0>
									<cfif not isdefined("attributes.is_other_money_transfer")>
										<cfif bakiye_kontrol gt 0>
											<cf_get_lang dictionary_id='58591.B'><cfif attributes.is_excel neq 2><br /></cfif>
										<cfelse>
											<cf_get_lang dictionary_id='29684.A'><cfif attributes.is_excel neq 2><br /></cfif>
										</cfif>
									<cfelse>
										<cfif (evaluate('borc_#money#')-evaluate('alacak_#money#')) gt 0>
											<cf_get_lang dictionary_id='58591.B'><cfif attributes.is_excel neq 2><br /></cfif>
										<cfelse>
											<cf_get_lang dictionary_id='29684.A'><cfif attributes.is_excel neq 2><br /></cfif>
										</cfif>
									</cfif>
                                </cfif>
                            </cfoutput>
                        </cfloop>
                    </td>
                
                    <cfif isdefined("attributes.is_other_money_transfer")>
                        <td  colspan="3"></td>
                        <td  style="text-align:right;"><cfoutput>#dateformat(date_add('d',(-1*vade_farki),now()),dateformat_style)#</cfoutput></td>
                        <td  style="text-align:right;"><cfoutput>#TLFormat(vade_farki,2)#</cfoutput></td>
                    <cfelse>
                        <td colspan="2"></td>
                        <td style="text-align:right;"><cfoutput>#dateformat(date_add('d',(-1*vade_farki),now()),dateformat_style)#</cfoutput></td>
                        <td  style="text-align:right;"><cfif not isDefined("attributes.is_finish_day")><cfoutput>#TLFormat(vade_farki,2)#</cfoutput></cfif></td>
                    </cfif>
                </tr>
            </tfoot>
			</cfif>
			<cfif attributes.is_excel neq 1 and attributes.is_excel neq 2 and add_bank_order eq 1 and len(attributes.is_Detail) and attributes.detail_type eq 2> 
            <form name="add_bank_order" action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.emptypopup_add_bank_order" method="post" target="blank">
				<input type="hidden" name="bank_order_list" id="bank_order_list" value=""><!--- Seçilmiş olanları tutacak... --->
				<div id="_all_form_objects_" style="display:none;"></div>
				<tr class="total">
					<td height="35" colspan="13" style="width:100%;">
                    	<cfsavecontent variable="message"><cf_get_lang dictionary_id ='38838.Banka Talimatı Oluştur'></cfsavecontent>
                        <cf_workcube_buttons is_upd='0' insert_info="#message#" is_cancel='0' add_function='bank_order_control()' type_format="1">
                        <div style="float:right; margin-right:10px;" id="noShow1">
                        	<cf_get_lang dictionary_id ='57521.Banka'><cfset system_money_info = session.ep.money><cf_wrkbankaccounts width='220' control_status='1'>
                        </div>
                         <div style="float:right; margin-right:10px;" id="noShow2">    
                       		<cf_get_lang dictionary_id='57800.İşlem Tipi'><cf_workcube_process_cat slct_width="150">
                        </div>
                        <div style="float:right; margin-right:10px;" id="noShow3">
                        	<cf_get_lang dictionary_id ='39711.Hepsini Seç'> <input type="checkbox" name="all_input" id="all_input" value="1" onclick="select_add_bank(this.checked);" checked>
                        </div>
					</td>
				</tr>
			</form>
			</cfif>
			<cfif attributes.is_excel neq 2> 

			</cfif>
		<cfelse>
			<tr>
				<td colspan="17"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
			</tr>
		</cfif>
</cf_report_list>			
</cfif>
<cfif isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.maxrows>
				<cfset adres = "">
				<cfset adres = "report.collacted_make_age_report&form_submitted=1">
				<cfif len(attributes.member_cat_type)>
					<cfset adres = "#adres#&member_cat_type=#attributes.member_cat_type#">
				</cfif>
				<cfif len(attributes.employee_cat_type)>
					<cfset adres = "#adres#&employee_cat_type=#attributes.employee_cat_type#">
				</cfif>
				<cfif len(attributes.consumer_cat_type)>
					<cfset adres = "#adres#&consumer_cat_type=#attributes.consumer_cat_type#">
				</cfif>
				<cfif len(attributes.department_id)>
					<cfset adres = "#adres#&department_id=#attributes.department_id#">
				</cfif>
				<cfif len(attributes.action_type)>
					<cfset adres = "#adres#&action_type=#attributes.action_type#">
				</cfif>
				<cfif len(attributes.zone_id)>
					<cfset adres = "#adres#&zone_id=#attributes.zone_id#">
				</cfif>
				<cfif len(attributes.is_detail)>
					<cfset adres = "#adres#&is_detail=#attributes.is_detail#">
				</cfif>
				<cfif len(attributes.pos_code) and len(attributes.pos_code_text)>
					<cfset adres = "#adres#&pos_code_text=#attributes.pos_code_text#&pos_code=#attributes.pos_code#">
				</cfif>
				<cfif isdefined("attributes.is_other_money_transfer")>
					<cfset adres = "#adres#&is_other_money_transfer=#attributes.is_other_money_transfer#">
				</cfif>	
				<cfif len(attributes.due_date2)>
					<cfset adres = "#adres#&due_date2=#dateformat(attributes.due_date2,dateformat_style)#">
				</cfif>
				<cfif len(attributes.due_date1)>
					<cfset adres = "#adres#&due_date1=#dateformat(attributes.due_date1,dateformat_style)#">
				</cfif>
				<cfif len(attributes.customer_value)>
					<cfset adres = "#adres#&customer_value=#attributes.customer_value#">
				</cfif>
				<cfif len(attributes.detail_type)>
					<cfset adres = "#adres#&detail_type=#attributes.detail_type#">
				</cfif>
				<cfif isDefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
					<cfset adres = "#adres#&project_id=#attributes.project_id#&project_head=#attributes.project_head#">
				</cfif>
				<cfif isdefined("attributes.is_manuel")>
					<cfset adres = "#adres#&is_manuel=#attributes.is_manuel#">
				</cfif>
				<cfif len(attributes.action_date2)>
					<cfset adres = "#adres#&action_date2=#dateformat(attributes.action_date2,dateformat_style)#">
				</cfif>
				<cfif len(attributes.action_date1)>
					<cfset adres = "#adres#&action_date1=#dateformat(attributes.action_date1,dateformat_style)#">
				</cfif>
				<cfif isdefined("attributes.is_pay_cheques")>
					<cfset adres = "#adres#&is_pay_cheques=#attributes.is_pay_cheques#">
				</cfif>
				<cfif isdefined("attributes.zero_other_money")>
					<cfset adres = "#adres#&zero_other_money=#attributes.zero_other_money#">
				</cfif>
				<cfif isdefined("attributes.is_project_group")>
					<cfset adres = "#adres#&is_project_group=#attributes.is_project_group#">
				</cfif>
				<cfif isdefined('attributes.buy_status') and len(attributes.buy_status)>
					<cfset adres = "#adres#&buy_status=#attributes.buy_status#">
				</cfif>
				<cfif isdefined('attributes.zero_bakiye') and len(attributes.zero_bakiye)>
					<cfset adres = "#adres#&zero_bakiye=#attributes.zero_bakiye#">
				</cfif>
				<cfif isdefined('attributes.duty_claim') and len(attributes.duty_claim)>
					<cfset adres = "#adres#&duty_claim=#attributes.duty_claim#">
				</cfif>
				<cfif isdefined('attributes.money_type_info') and len(attributes.money_type_info)>
					<cfset adres = "#adres#&money_type_info=#attributes.money_type_info#">
				</cfif>
				<cfif isdefined('attributes.is_excel') and len(attributes.is_excel)>
					<cfset adres = "#adres#&is_excel=#attributes.is_excel#">
				</cfif>
				<cfif isDefined("attributes.list_type") and len(attributes.list_type)>
					<cfset adres = "#adres#&list_type=#attributes.list_type#">
				</cfif>
                <cfif zero_diff_rate eq 1>
                	<cfset total_rec = zero_count>
                <cfelse>
                	<cfset total_rec = attributes.totalrecords>
                </cfif>
				<cf_paging page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#total_rec#"
					startrow="#attributes.startrow#"
					adres="#adres#">
</cfif>

<script type="text/javascript">	
	$(function() {
		if ($('#is_detail').is(":checked")) 	
			$('#list_type').val("").prop('disabled', 'disabled');
	});
	$('#is_detail').change(function(){
		if ($(this).is(":checked")) {
			if (confirm("Detaylı ve liste tipi aynı anda seçilemez. Liste tipi seçilemeyecek onaylıyor musunuz?"))
				$('#list_type').val("").prop('disabled', 'disabled');
			else
				$("#is_detail").attr("checked", false);
		}
		else $('#list_type').prop('disabled',false);
	});
	function kontrol()
	{
		if(((rapor.action_type[0].checked && document.rapor.member_cat_type.value == '') || (rapor.action_type[1].checked && document.rapor.consumer_cat_type.value == '') || (rapor.action_type[2].checked && document.rapor.department_id.value == '' && document.rapor.employee_cat_type.value == ''))&& document.rapor.pos_code_text.value == '' && (document.rapor.company_id.value == '' || document.rapor.company.value == '') && (document.rapor.consumer_id.value == '' || document.rapor.company.value == '') && (document.rapor.employee_id.value == '' || document.rapor.company.value == '') && document.rapor.zone_id.value == '' && document.rapor.customer_value.value == '')
		{
			alert("<cf_get_lang dictionary_id='58950.En Az Bir Alanda Filtre Etmelisiniz'> !");
			return false;
		}
		if(document.rapor.detail_type.value == 4 && rapor.is_other_money_transfer.checked == false)
		{
			alert("<cf_get_lang dictionary_id='60665.Kur Farklarını Listelemek İçin İşlem Dövizli Seçeneğini Seçmelisiniz'> !");
			return false;
		}
		if ((document.rapor.due_date1.value != '') && (document.rapor.due_date1.value != '') &&
	    !date_check(rapor.due_date1,rapor.due_date2,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;
		if ((document.rapor.action_date1.value != '') && (document.rapor.action_date2.value != '') &&
	    !date_check(rapor.action_date1,rapor.action_date2,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;
		if(document.rapor.is_excel.checked==false)
		{
			document.rapor.action="<cfoutput>#request.self#?fuseaction=report.collacted_make_age_report</cfoutput>";
			return true;
			
		}
		else
		{
			document.rapor.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_collacted_make_age_report</cfoutput>";
		}
		
	}
	function kontrol_display()
	{
		if(rapor.action_type[0].checked)
		{
			comp_cat.style.display='';
			ch_type_.style.display='none';
			cons_cat.style.display='none';
			cat_.style.display='';
			ch_type3_.style.display='none';
			department_sec.style.display='none';
			department_sec3.style.display='none';
		}
		else if(rapor.action_type[1].checked)
		{
			comp_cat.style.display='none';
			ch_type_.style.display='none';
			cons_cat.style.display='';
			cat_.style.display='';
			ch_type3_.style.display='none';
			department_sec.style.display='none';
			department_sec3.style.display='none';	
		}
		else
		{
			comp_cat.style.display='none';
			ch_type_.style.display='';
			cons_cat.style.display='none';
			cat_.style.display='none';
			ch_type3_.style.display='';
			department_sec.style.display='';
			department_sec3.style.display='';	
			
			
		}			
	}
	function check_detail(type)
	{
		
		if(type == 1)
		{
			if(document.rapor.is_detail.checked && document.rapor.detail_type.value != 4)
				document.rapor.is_excel.value = 0;
			
				
		}
		else if(type == 2)
		{
			if(document.rapor.is_detail.checked && document.rapor.detail_type.value != 4)
				document.rapor.is_detail.checked = false;
				
		}
		if(rapor.is_detail.checked)
		{
			document.getElementById('detail_type_td1').style.display='';
			document.getElementById('detail_type_td1_label').style.display='';
			document.getElementById('file_type').style.display='none';
			document.getElementById('file_type_label').style.display='none';
			document.getElementById('is_excel_display').style.display='none';
		}
		else
		{
			document.getElementById('detail_type_td1').style.display='none';
			document.getElementById('detail_type_td1_label').style.display='none';
			document.getElementById('file_type').style.display='';
			document.getElementById('file_type_label').style.display='';
			document.getElementById('is_excel_display').style.display='';
		}
	}
	function sayfa_getir(no,company_id,is_doviz_group,other_money,project_id,is_project_group,bakiye_kontrol,add_bank_order,acc_type_id)
	{
		gizle_goster(eval("document.getElementById('dsp_make_age_" + no + "')"));
		if (acc_type_id == undefined)	acc_type_id = '';
		if(eval("document.getElementById('dsp_make_age_" + no + "')").style.display=='none')//Eğer satırlar gizlenmiş ise..Normalde sadece tr'nin style'i none yapıldığı için aslında checkboxlar seçili halde duruyordu,buda kullanıcı checkox'u seçmese bile hesaplamaya katılmasına sebebiyet veriyordu.Kesinlikle Kaldırılmasın bu blok.
			document.getElementById('show_dsp_make'+no).innerHTML ='';
		if (eval("document.getElementById('dsp_make_age_" + no + "')").style.display=='')
		{
			<cfif not isdefined("attributes.is_manuel")>
				<cfif isdefined("is_make_age_date") and is_make_age_date eq 1>
					is_make_age_date = 1;
					if(document.rapor.is_pay_cheques.checked == true)
						is_pay_cheque = 1;
					else
						is_pay_cheque = 0;
				<cfelse>
					is_make_age_date = 0;
					is_pay_cheque = 0;
				</cfif>
				if(is_doviz_group == 1)
				{
					if(rapor.action_type[0].checked)
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report.emptypopup_dsp_make_age&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&</cfoutput>&is_pay_cheque='+is_pay_cheque+'&is_make_age_date='+is_make_age_date+'&bakiye_kontrol='+bakiye_kontrol+'&add_bank_order='+add_bank_order+'&row_id='+no+'&is_ajax_popup&is_doviz_group='+is_doviz_group+'&other_money='+other_money+'&project_id='+project_id+'&project_head='+project_id+'&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date1='+document.rapor.action_date1.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&is_project_group='+is_project_group+'&acc_type_id='+acc_type_id+'&company_id='+company_id,'show_dsp_make'+no);
					else if(rapor.action_type[1].checked)
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report.emptypopup_dsp_make_age&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&</cfoutput>is_pay_cheque='+is_pay_cheque+'&is_make_age_date='+is_make_age_date+'&bakiye_kontrol='+bakiye_kontrol+'&add_bank_order='+add_bank_order+'&row_id='+no+'&is_ajax_popup&is_doviz_group='+is_doviz_group+'&other_money='+other_money+'&project_id='+project_id+'&project_head='+project_id+'&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date1='+document.rapor.action_date1.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&is_project_group='+is_project_group+'&acc_type_id='+acc_type_id+'&consumer_id='+company_id,'show_dsp_make'+no);
					else
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report.emptypopup_dsp_make_age&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&</cfoutput>is_pay_cheque='+is_pay_cheque+'&is_make_age_date='+is_make_age_date+'&bakiye_kontrol='+bakiye_kontrol+'&add_bank_order='+add_bank_order+'&row_id='+no+'&is_ajax_popup&is_doviz_group='+is_doviz_group+'&other_money='+other_money+'&project_id='+project_id+'&project_head='+project_id+'&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date1='+document.rapor.action_date1.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&is_project_group='+is_project_group+'&acc_type_id='+acc_type_id+'&employee_id='+company_id,'show_dsp_make'+no);
				}
				else
				{
					if(rapor.action_type[0].checked)
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report.emptypopup_dsp_make_age&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&</cfoutput>is_pay_cheque='+is_pay_cheque+'&is_make_age_date='+is_make_age_date+'&bakiye_kontrol='+bakiye_kontrol+'&add_bank_order='+add_bank_order+'&row_id='+no+'&is_ajax_popup&project_id='+project_id+'&project_head='+project_id+'&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date1='+document.rapor.action_date1.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&is_project_group='+is_project_group+'&acc_type_id='+acc_type_id+'&company_id='+company_id,'show_dsp_make'+no);
					else if(rapor.action_type[1].checked)
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report.emptypopup_dsp_make_age&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&</cfoutput>is_pay_cheque='+is_pay_cheque+'&is_make_age_date='+is_make_age_date+'&bakiye_kontrol='+bakiye_kontrol+'&add_bank_order='+add_bank_order+'&row_id='+no+'&is_ajax_popup&project_id='+project_id+'&project_head='+project_id+'&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date1='+document.rapor.action_date1.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&is_project_group='+is_project_group+'&acc_type_id='+acc_type_id+'&consumer_id='+company_id,'show_dsp_make'+no);
					else
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report.emptypopup_dsp_make_age&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&</cfoutput>is_pay_cheque='+is_pay_cheque+'&is_make_age_date='+is_make_age_date+'&bakiye_kontrol='+bakiye_kontrol+'&add_bank_order='+add_bank_order+'&row_id='+no+'&is_ajax_popup&project_id='+project_id+'&project_head='+project_id+'&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date1='+document.rapor.action_date1.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&is_project_group='+is_project_group+'&acc_type_id='+acc_type_id+'&employee_id='+company_id,'show_dsp_make'+no);
				}
			<cfelse>
				if(document.rapor.is_duedate_group.checked == true)
					due_control = 1;
				else
					due_control = 0;
				if(is_doviz_group == 1)
				{
					if(rapor.action_type[0].checked)
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report.emptypopup_dsp_make_age_manuel&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&</cfoutput>is_duedate_group='+due_control+'&bakiye_kontrol='+bakiye_kontrol+'&add_bank_order='+add_bank_order+'&row_id='+no+'&is_ajax_popup&is_doviz_group='+is_doviz_group+'&other_money='+other_money+'&project_id='+project_id+'&project_head='+project_id+'&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&is_project_group='+is_project_group+'&acc_type_id='+acc_type_id+'&company_id='+company_id,'show_dsp_make'+no);
					else if(rapor.action_type[1].checked)
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report.emptypopup_dsp_make_age_manuel&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&</cfoutput>is_duedate_group='+due_control+'&bakiye_kontrol='+bakiye_kontrol+'&add_bank_order='+add_bank_order+'&row_id='+no+'&is_ajax_popup&is_doviz_group='+is_doviz_group+'&other_money='+other_money+'&project_id='+project_id+'&project_head='+project_id+'&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&is_project_group='+is_project_group+'&acc_type_id='+acc_type_id+'&consumer_id='+company_id,'show_dsp_make'+no);
					else
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report.emptypopup_dsp_make_age_manuel&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&</cfoutput>is_duedate_group='+due_control+'&bakiye_kontrol='+bakiye_kontrol+'&add_bank_order='+add_bank_order+'&row_id='+no+'&is_ajax_popup&is_doviz_group='+is_doviz_group+'&other_money='+other_money+'&project_id='+project_id+'&project_head='+project_id+'&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&is_project_group='+is_project_group+'&acc_type_id='+acc_type_id+'&employee_id='+company_id,'show_dsp_make'+no);
				}
				else
				{
					if(rapor.action_type[0].checked)
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report.emptypopup_dsp_make_age_manuel&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&</cfoutput>is_duedate_group='+due_control+'&bakiye_kontrol='+bakiye_kontrol+'&add_bank_order='+add_bank_order+'&row_id='+no+'&is_ajax_popup&project_id='+project_id+'&project_head='+project_id+'&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&is_project_group='+is_project_group+'&acc_type_id='+acc_type_id+'&company_id='+company_id,'show_dsp_make'+no);
					else if(rapor.action_type[1].checked)
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report.emptypopup_dsp_make_age_manuel&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&</cfoutput>is_duedate_group='+due_control+'&bakiye_kontrol='+bakiye_kontrol+'&add_bank_order='+add_bank_order+'&row_id='+no+'&is_ajax_popup&project_id='+project_id+'&project_head='+project_id+'&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&is_project_group='+is_project_group+'&acc_type_id='+acc_type_id+'&consumer_id='+company_id,'show_dsp_make'+no);
					else
					{
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report.emptypopup_dsp_make_age_manuel&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&</cfoutput>is_duedate_group='+due_control+'&bakiye_kontrol='+bakiye_kontrol+'&add_bank_order='+add_bank_order+'&row_id='+no+'&is_ajax_popup&project_id='+project_id+'&project_head='+project_id+'&due_date_1='+document.rapor.due_date1.value+'&due_date_2='+document.rapor.due_date2.value+'&date2='+document.rapor.action_date2.value+'&is_finish_day='+document.rapor.is_finish_day.value+'&is_project_group='+is_project_group+'&acc_type_id='+acc_type_id+'&employee_id='+company_id,'show_dsp_make'+no);
					}
				}
			</cfif>
		}
		else
			AjaxPageLoad('','show_dsp_make'+no);
	}
	function bank_order_control()
	{	
		select_add_bank();
		deger1=document.add_bank_order.currency_id.value;
		if (!chk_process_cat('add_bank_order')) return false;
		if(!acc_control()) return false;
		if(document.getElementById('bank_order_list').value == "")
		{
			alert ("<cf_get_lang dictionary_id ='38840.Lütfen İşlem Seçiniz'>!");
			return false;
		}
	}
	function select_add_bank(get_value){
		var bank_order_list = '';
		document.getElementById('bank_order_list').value = '';
		document.getElementById('_all_form_objects_').innerHTML='';
		var	length =document.getElementsByName('_is_bank_order_').length;
		for(ci=0;ci<length;ci++){
			my_obj_val = (length != 1)?document.all._is_bank_order_[ci]:document.all._is_bank_order_;
				if(get_value != undefined)//seçim yapılmak isteniyorsa..
					my_obj_val.checked = get_value;
				else{
					if(my_obj_val.checked == true){//seçili ise.
						if(list_find(my_obj_val.value,6,'█'))
							member_type = list_getat(my_obj_val.value,6,'█');
						else
							member_type = "company"; 
						id = list_getat(my_obj_val.value,1,'█');//alt+987=█
						bank_order_list+=id+',';
						tutar = list_getat(my_obj_val.value,2,'█');
						comp_id_info = list_getat(my_obj_val.value,3,'█');
						inv_date_info_ = list_getat(my_obj_val.value,4,'█');
						due_date_info_ = list_getat(my_obj_val.value,5,'█');
					
					if(document.getElementById('acc_amount'+id) == null) // Sayfa post edildikten sonra tekrar post edilirse aynı isimli inputlar oluşuyordu. Kontrol eklendi. EY20140902
					{
						var new_inp_obj = document.createElement("input");
						new_inp_obj.setAttribute("type", "hidden");
						new_inp_obj.setAttribute("name", "acc_amount"+id);
						new_inp_obj.setAttribute("id", "acc_amount"+id);
						new_inp_obj.setAttribute("value", tutar);
						
						var comp_id_obj = document.createElement("input");
						comp_id_obj.setAttribute("type", "hidden");
						comp_id_obj.setAttribute("name", "bankorder_comp_id"+id);
						comp_id_obj.setAttribute("id", "bankorder_comp_id"+id);
						comp_id_obj.setAttribute("value", comp_id_info);
						
						var inv_date_obj = document.createElement("input");
						inv_date_obj.setAttribute("type", "hidden");
						inv_date_obj.setAttribute("name", "bankorder_act_date"+id);
						inv_date_obj.setAttribute("id", "bankorder_act_date"+id);
						inv_date_obj.setAttribute("value", inv_date_info_);
						
						var due_date_obj = document.createElement("input");
						due_date_obj.setAttribute("type", "hidden");
						due_date_obj.setAttribute("name", "bankorder_due_date"+id);
						due_date_obj.setAttribute("id", "bankorder_due_date"+id);
						due_date_obj.setAttribute("value", due_date_info_);

						var member_type_obj = document.createElement("input");
						member_type_obj.setAttribute("type", "hidden");
						member_type_obj.setAttribute("name", "bankorder_member_type"+id);
						member_type_obj.setAttribute("id", "bankorder_member_type"+id);
						member_type_obj.setAttribute("value", member_type);
						
						document.forms['add_bank_order'].appendChild(new_inp_obj);
						document.forms['add_bank_order'].appendChild(comp_id_obj);
						document.forms['add_bank_order'].appendChild(inv_date_obj);
						document.forms['add_bank_order'].appendChild(due_date_obj);
						document.forms['add_bank_order'].appendChild(member_type_obj);

					}
						/*document.getElementById('_all_form_objects_').style.display = '';
						document.getElementById('_all_form_objects_').appendChild(new_inp_obj);
						document.getElementById('_all_form_objects_').appendChild(comp_id_obj);
						document.getElementById('_all_form_objects_').appendChild(inv_date_obj);
						document.getElementById('_all_form_objects_').appendChild(due_date_obj);
						*/
					}
				}
	
		}
		bank_order_list = bank_order_list.substr(0,bank_order_list.length-1);//sondaki virgülden kurtarıyoruz.
		document.getElementById('bank_order_list').value = bank_order_list;
	}
	function show_money_type()
	{
		if(document.getElementById('is_other_money_transfer').checked == true)//işlem dövizi seçilmişse
		{
			document.getElementById('_money_type_').style.display = '';
			document.getElementById('_money_type_label_').style.display = '';
		}	
		else
		{
			document.getElementById('_money_type_').style.display = 'none';
			document.getElementById('_money_type_label_').style.display = 'none';
		}
	}
</script>

