<!---Create:20060915 Ayşenur--->
<!---	attributes.report_type 1 : Müşteri Bazında
	attributes.report_type 2 : Satis Bolgesi Bazında
	attributes.report_type 3 : Mikro Bolge Kodu Bazında
	attributes.report_type 4 : Musteri Degeri Bazında
	attributes.report_type 5 : Müşteri Temsilcisi Bazında
	attributes.report_type 7 : Müşteri Kategorisi Bazında
	attributes.report_type 8 : İl Bazında--->
<!---Rapor yukarıdaki tiplerde seçilerek satışları ciroyu, bakiyeleri, 
limitleri ödenmemiş/karşılıksız çek-senet toplamlarını, riskleri ve bunlarla ilişkili oranları hesaplar..
Bakiyesi 0 dan büyük yani borçlu üyelerle ilgili kayıtları getirir.--->
<cfparam name="attributes.module_id_control" default="16">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.customer_value_id" default="">
<cfparam name="attributes.max_rows" default='#session.ep.maxrows#'>
<cfparam name="attributes.resource_id" default="">
<cfparam name="attributes.cost_price" default="">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.date1" default="#now()#">
<cfparam name="attributes.date2" default="#now()#">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.pos_code_text" default="">
<cfparam name="attributes.report_sort" default="1">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.ims_code_id" default=""> 
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.report_dsp_type" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.member_cat_value" default="">
<cfparam name="attributes.member_status" default="">
<cfquery name="check_company_risk_type" datasource="#dsn#"><!--- şirkette detaylı risk takibi yapılıyor mu kontrol ediliyor --->
	SELECT ISNULL(IS_DETAILED_RISK_INFO,0) IS_DETAILED_RISK_INFO  FROM OUR_COMPANY_INFO WHERE COMP_ID=#session.ep.company_id#
</cfquery>
<cfquery name="get_sec_type" datasource="#dsn#">
	SELECT * FROM SETUP_SECUREFUND
</cfquery>
<cfquery name="SZ" datasource="#DSN#">
	SELECT * FROM SALES_ZONES ORDER BY SZ_NAME
</cfquery>
<cfif attributes.report_type eq 2>
	<cfquery name="SZ_2" datasource="#DSN#">
		SELECT * FROM SALES_ZONES ORDER BY SZ_ID
	</cfquery>
	<cfset list_zone_ids = valuelist(SZ_2.SZ_ID,',')>
</cfif>
<cfquery name="GET_CUSTOMER_VALUE" datasource="#DSN#">
	SELECT CUSTOMER_VALUE_ID, CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
</cfquery>
<cfif attributes.report_type eq 4>
	<cfquery name="GET_CUSTOMER_VALUE_2" datasource="#DSN#">
		SELECT CUSTOMER_VALUE_ID, CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE_ID
	</cfquery>
	<cfset list_customer_val_ids = valuelist(GET_CUSTOMER_VALUE.CUSTOMER_VALUE_ID,',')>
</cfif>
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
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
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
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
<cfif not len(attributes.member_status)>
	<cfset attributes.member_status = 1>
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfparam name="attributes.page" default=1>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfif isdate(attributes.date1)><cf_date tarih = "attributes.date1"></cfif>
	<cfif isdate(attributes.date2)><cf_date tarih = "attributes.date2"></cfif>
	<cfquery name="get_money" datasource="#dsn2#">
		SELECT MONEY FROM SETUP_MONEY
	</cfquery>
	<cfscript>
		ciro_toplam = 0;
		ciro_toplam_money2 = 0;
		toplam_borc = 0;
		toplam_borc_vade = 0;
		toplam_borc2 = 0;
		toplam_alacak = 0;
		toplam_alacak_vade = 0;
		toplam_alacak2 = 0;
		acik_hesap_bakiye = 0;
		acik_hesap_bakiye_money2 = 0;
		acik_hesap_limit = 0;
		acik_hesap_limit_money2 = 0;
		vadeli_limit = 0;
		vadeli_limit_money2 = 0;
		toplam_limit = 0;
		toplam_limit_money2 = 0;
		kars_cek_senet = 0;
		kars_cek_senet2 = 0;
		odenmemis_cek_senet = 0;
		odenmemis_cek_senet2 = 0;
		risk_toplam = 0;
		risk_toplam2 = 0;
		kullanilabilir_risk = 0;
		verilen_teminat = 0;
		kullanilabilir_risk2 = 0;
		alinan_teminat = 0;
		verilen_teminat2 = 0;
		alinan_teminat2= 0;
		toplam_siparis = 0;
		toplam_siparis2 = 0;
		toplam_irsaliye = 0;
		toplam_irsaliye2 = 0;
	</cfscript>
	<cfif isdefined("attributes.is_money3")>
		<cfoutput query="get_money">
			<cfscript>
				"ciro_toplam#get_money.money#" = 0;
				"ciro_toplam_money#get_money.money#" = 0;
				"toplam_borc#get_money.money#" = 0;
				"toplam_borc_vade#get_money.money#" = 0;
				"toplam_borc#get_money.money#" = 0;
				"toplam_alacak#get_money.money#" = 0;
				"toplam_alacak_vade#get_money.money#" = 0;
				"toplam_alacak#get_money.money#" = 0;
				"acik_hesap_bakiye#get_money.money#" = 0;
				"acik_hesap_bakiye_money#get_money.money#" = 0;
				"acik_hesap_limit#get_money.money#" = 0;
				"acik_hesap_limit_money#get_money.money#" = 0;
				"vadeli_limit#get_money.money#" = 0;
				"vadeli_limit_money#get_money.money#" = 0;
				"toplam_limit#get_money.money#" = 0;
				"toplam_limit_money#get_money.money#" = 0;
				"kars_cek_senet#get_money.money#" = 0;
				"odenmemis_cek_senet#get_money.money#" = 0;
				"risk_toplam#get_money.money#" = 0;
				"kullanilabilir_risk#get_money.money#" = 0;
				"verilen_teminat#get_money.money#" = 0;
				"alinan_teminat#get_money.money#" = 0;
				"toplam_siparis#get_money.money#" = 0;
				"toplam_irsaliye#get_money.money#" = 0;
			</cfscript>	
		</cfoutput>
		<cfscript>
			"verilen_teminatYTL" = 0;
			"alinan_teminatYTL" = 0;
		</cfscript>	
	</cfif>
</cfif>

<cfform name="rapor" id="rapor" action="#request.self#?fuseaction=report.risc_analys" method="post">
<cf_report_list_search title="#getLang('','Risk Analiz Raporu',63691)#">
	<cf_report_list_search_area>
		<div class="row">
			<div class="col col-12 col-xs-12">
				<div class="row formContent">
					<div class="row" type="row">		   
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
							<div class="col col-12 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
											<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(attributes.company)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
											<input type="text" name="company" id="company"  value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>"onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','\'1,2\',0,0,0','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','rapor','3','250');" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=rapor.company&field_comp_id=rapor.company_id&field_consumer=rapor.consumer_id&field_member_name=rapor.company&select_list=2,3','list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58795.Müşteri Temsilcisi'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="pos_code" id="pos_code" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
											<input type="text" name="pos_code_text" id="pos_code_text" value="<cfif len(attributes.pos_code)><cfoutput>#attributes.pos_code_text#</cfoutput></cfif>" onFocus="AutoComplete_Create('pos_code_text','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','pos_code','','3','130');" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_pos_code=rapor.pos_code&field_code=rapor.pos_code&field_name=rapor.pos_code_text&select_list=1,9','list')"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58134.Mikro Bölge Kodu'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
												<cfquery name="GET_IMS" datasource="#dsn#">
													SELECT * FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = #attributes.ims_code_id#
												</cfquery>
												<input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#attributes.ims_code_id#</cfoutput>">
												<cfinput type="text" name="ims_code_name" value="#get_ims.ims_code# #get_ims.ims_code_name#" onFocus="AutoComplete_Create('ims_code_name','IMS_CODE,IMS_CODE_NAME','IMS_NAME','get_ims_code','','IMS_CODE_ID','ims_code_id','','3','200');" autocomplete="off">
											<cfelse>
												<input type="hidden" name="ims_code_id" id="ims_code_id">
												<cfinput type="text" name="ims_code_name" value="" onFocus="AutoComplete_Create('ims_code_name','IMS_CODE,IMS_CODE_NAME','IMS_NAME','get_ims_code','','IMS_CODE_ID','ims_code_id','','3','200');" autocomplete="off">
											</cfif>
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=rapor.ims_code_name&field_id=rapor.ims_code_id','list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58552.Müşteri Değeri'></label>
									<div class="col col-12 col-xs-12">
										<select name="customer_value_id" id="customer_value_id">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="get_customer_value">
													<option value="#customer_value_id#" <cfif customer_value_id eq attributes.customer_value_id>selected</cfif>>#customer_value#</option>
												</cfoutput>
										</select>
									</div>
								</div>
							</div>								
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
							<div class="col col-12 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></label>
									<div class="col col-12 col-xs-12">
										<select name="zone_id" id="zone_id">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfoutput query="sz">
												<option value="#sz_id#" <cfif attributes.zone_id eq sz_id>selected</cfif>>#sz_name#</option>
											</cfoutput>
										</select>	
									</div>
								</div>									
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='35363.İlişki Tipi'></label>
										<div class="col col-12 col-xs-12">
											<cf_wrk_combo
											name="resource_id"
											query_name="GET_PARTNER_RESOURCE"
											option_name="resource"
											option_value="resource_id"
											value="#attributes.resource_id#"
											width="150">
										</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
									<div class="col col-12 col-xs-12">
										<select name="report_type" id="report_type">
											<option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='39257.Müşteri Bazında'></option>
											<option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id='39262.Satış Bölgesi Bazında'></option>
											<option value="3" <cfif attributes.report_type eq 3>selected</cfif>><cf_get_lang dictionary_id='58134.Mikro Bölge Kodu'><cf_get_lang dictionary_id='58601.Bazında'></option>
											<option value="4" <cfif attributes.report_type eq 4>selected</cfif>><cf_get_lang dictionary_id='39259.Müşteri Değeri Bazında'></option>
											<option value="5" <cfif attributes.report_type eq 5>selected</cfif>><cf_get_lang dictionary_id='58795.Müşteri Temsilcisi'> <cf_get_lang dictionary_id='58601.Bazında'></option>
											<option value="7" <cfif attributes.report_type eq 7>selected</cfif>><cf_get_lang dictionary_id='40312.Müşteri Kategorisi Bazında'></option>
											<option value="8" <cfif attributes.report_type eq 8>selected</cfif>><cf_get_lang dictionary_id='39475.İl Bazında'></option>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
										<div class="col col-12 col-xs-12">
											<select name="member_status" id="member_status"> 
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<option value="-1" <cfif isDefined('attributes.member_status') and attributes.member_status is -1> selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
												<option value="1" <cfif isDefined('attributes.member_status') and attributes.member_status is 1> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'><cf_get_lang dictionary_id='57658.Üye'></option>
												<option value="0" <cfif isDefined('attributes.member_status') and attributes.member_status is 0> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'><cf_get_lang dictionary_id='57658.Üye'></option>	  
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
											<option value="1-0" <cfif listfind(attributes.member_cat_type,'1-0',',')>selected</cfif>><cf_get_lang dictionary_id='42123.Kurumsal Üye Kategorileri'></option>
											<cfoutput query="get_company_cat">
												<option value="1-#COMPANYCAT_ID#" <cfif listfind(attributes.member_cat_type,'1-#COMPANYCAT_ID#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#COMPANYCAT#</option></cfoutput>
											<option value="2-0" <cfif listfind(attributes.member_cat_type,'2-0',',')>selected</cfif>><cf_get_lang dictionary_id='58040.Bireysel Üye Kategorileri'></option>
											<cfoutput query="get_consumer_cat">
												<option value="2-#CONSCAT_ID#" <cfif listfind(attributes.member_cat_type,'2-#CONSCAT_ID#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#CONSCAT#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57509.Liste'></label>
									<div class="col col-12 col-xs-12">
										<select name="report_dsp_type" id="report_dsp_type" multiple>
											<option value="1" <cfif listfind(attributes.report_dsp_type,1)>selected</cfif>><cf_get_lang dictionary_id='30010.Ciro'></option>
											<option value="2" <cfif listfind(attributes.report_dsp_type,2)>selected</cfif>><cf_get_lang dictionary_id='57589.Bakiye'></option>
											<option value="5" <cfif listfind(attributes.report_dsp_type,5)>selected</cfif>><cf_get_lang dictionary_id='57689.Risk'></option>
											<option value="3" <cfif listfind(attributes.report_dsp_type,3)>selected</cfif>><cf_get_lang dictionary_id='39480.Limit'></option>
											<option value="4" <cfif listfind(attributes.report_dsp_type,4)>selected</cfif>><cf_get_lang dictionary_id='58689.Teminat'></option>
											<option value="6" <cfif listfind(attributes.report_dsp_type,6)>selected</cfif>><cf_get_lang dictionary_id='58622.Açık Siparişler'></option>
											<option value="7" <cfif listfind(attributes.report_dsp_type,7)>selected</cfif>><cf_get_lang dictionary_id='58955.Faturalanmamış İrsaliyeler'></option>
										</select>
									</div>
								</div>
							</div>								
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
							<div class="col col-12 col-xs-12">
								<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
												<cfinput value="#dateformat(attributes.date1,dateformat_style)#" type="text" name="date1" maxlength="15" required="yes" message="#message#" validate="#validate_style#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
												<span class="input-group-addon no-bg"></span>
												<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>  : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
												<cfinput  value="#dateformat(attributes.date2,dateformat_style)#"  type="text" name="date2" maxlength="154" required="yes" message="#message#" validate="#validate_style#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
											</div>

										</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39055.Rapor Sıra'></label> 
									<div class="col col-12 col-xs-12">
											<label><cf_get_lang dictionary_id='34763.Ciro ya Göre'><input type="radio" name="report_sort" id="report_sort" value="1"  <cfif attributes.report_sort eq 1>checked</cfif>></label>
											<label><cf_get_lang dictionary_id="39479.Bakiye'ye Göre"><input type="radio" name="report_sort" id="report_sort" value="2"  <cfif attributes.report_sort eq 2>checked</cfif>></label>
											<label><cf_get_lang dictionary_id='40313.Vade Performansına Göre'><input type="radio" name="report_sort" id="report_sort" value="3"  <cfif attributes.report_sort eq 3>checked</cfif>></label>
									</div>
								</div>
								<div  class="form-group">
									<div class="col col-12 col-xs-12">
										<cfif isdefined("session.ep.money2") and len(session.ep.money2)>
											<label><input name="is_money2" id="is_money2" value="1" type="checkbox" onClick="kontrol_money(1);" <cfif isdefined("attributes.is_money2")>checked</cfif>><cfoutput>#session.ep.money2#</cfoutput> <cf_get_lang dictionary_id='58596.Göster'></label>
											<label><input name="is_money3" id="is_money3" value="1" type="checkbox" onClick="kontrol_money(2);" <cfif isdefined("attributes.is_money3")>checked</cfif>><cf_get_lang dictionary_id='58121.İşlem Dövizi'> <cf_get_lang dictionary_id='58596.Göster'></label>
										</cfif>
										<label><cf_get_lang dictionary_id='40639.Teminatları Detaylı Göster'><input type="checkbox" name="is_tem_detail" id="is_tem_detail" value="1" <cfif isdefined("attributes.is_tem_detail")>checked</cfif>></label>
										<label><cf_get_lang dictionary_id='40638.Tüm Üyeleri Göster'><input type="checkbox" name="is_all_member" id="is_all_member" value="1" <cfif isdefined("attributes.is_all_member")>checked</cfif>></label>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="row ReportContentBorder">
					<div class="ReportContentFooter">
						<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" value="1" name="is_excel" id="is_excel"<cfif attributes.is_excel eq 1>checked</cfif>></label>
						<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#getLang('','Kayıt Sayısı Hatalı',43958)#" maxlength="3" style="width:25px;">
						<cfelse>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">
						</cfif>
							<input type="hidden" name="form_submitted" id="form_submitted" value="">
						<input type="hidden" name="member_cat_value" id="member_cat_value" value="">
						<cf_wrk_report_search_button search_function='kontrol_form()' insert_info='#getLang('','Çalıştır',57911)#' button_type='1' is_excel='1'>
					</div>
				</div>
			</div>
		</div>
	</cf_report_list_search_area>
</cf_report_list_search>
</cfform>
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_risc_analyse.cfm">
	<cfif get_total_purchase.recordCount gt 0>
	<cfquery name="get_total_purchase" dbtype="query">
		SELECT 
			* 
		FROM 
			get_total_purchase 
		ORDER BY 
			PROCESS_ID
			<cfif attributes.report_type eq 1>
			,MEMBER_CODE ASC
			</cfif>
			<cfif attributes.report_type eq 3>
			,IMS_CODE_NAME ASC
			</cfif>
			<cfif attributes.report_sort eq 1>
				,NETTOTAL DESC
			<cfelseif attributes.report_sort eq 2>
				,BAKIYE DESC
			<cfelseif attributes.report_sort eq 3>
				,VADE_PER DESC
			</cfif>
			<cfif isdefined("attributes.is_money3")>
				,OTHER_MONEY DESC
			</cfif>
	</cfquery>
	<cfelse>
		<cfset attributes.totalrecords = 0>
	</cfif>
<cfelse>
	<cfset get_total_purchase.recordcount = 0>
	<cfset attributes.totalrecords = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_total_purchase.recordcount#">
	<cfif isdefined("attributes.form_submitted")>
	 	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		 	<cfset filename = "#createuuid()#">
			<cfheader name="Expires" value="#Now()#">
			<cfcontent type="application/vnd.msexcel;charset=utf-8">
			<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
				<cfset type_ = 1>
                <cfset attributes.startrow=1>
                <cfset attributes.maxrows = #get_total_purchase.recordcount#>
            <cfelse>
                <cfset type_ = 0>
            </cfif>
		<cfif isDefined("attributes.is_money3")>
			<cfset company_list = ''>
			<cfset consumer_list = ''>
			<cfset company_count_list = ''>
			<cfset consumer_count_list = ''>
          
			<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif listfindnocase(company_list,process_id) and kontrol eq 1>
					<cfset sira_ = listfindnocase(company_list,process_id)>
					<cfset sayi_ = listgetat(company_count_list,sira_)>
					<cfset sayi_ = sayi_ + 1>
					<cfset company_count_list = listsetat(company_count_list,sira_,sayi_)>
				<cfelseif listfindnocase(consumer_list,process_id) and kontrol eq 0>
					<cfset sira_ = listfindnocase(consumer_list,process_id)>
					<cfset sayi_ = listgetat(consumer_count_list,sira_)>
					<cfset sayi_ = sayi_ + 1>
					<cfset consumer_count_list = listsetat(consumer_count_list,sira_,sayi_)>
				<cfelseif not listfindnocase(company_list,process_id) and kontrol eq 1>
					<cfset company_list = listappend(company_list,process_id)>
					<cfset company_count_list = listappend(company_count_list,1)>
				<cfelseif not listfindnocase(consumer_list,process_id) and kontrol eq 0>
					<cfset consumer_list = listappend(consumer_list,process_id)>
					<cfset consumer_count_list = listappend(consumer_count_list,1)>
				</cfif>
			</cfoutput>
		</cfif>		
        <cf_report_list>
				<thead>
				<cfoutput>
                    <tr>
						<cfif attributes.report_type eq 1>
							<th colspan="3">&nbsp;</th>
						<cfelse>
							<th colspan="2">&nbsp;</th>
						</cfif>						
						<cfif isdefined("attributes.is_money3")>
							<th align="center"></th>							
						</cfif>
						<cfif listfind(attributes.report_dsp_type,1)>
							<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
								<cfset colspan_= 3>
							<cfelse>
								<cfset colspan_= 2>
							</cfif>
							<th colspan="#colspan_#" align="center"><cf_get_lang dictionary_id='30010.Ciro'></th>	
						</cfif>
						<cfif listfind(attributes.report_dsp_type,2)>
							<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
								<cfset colspan_= 10>
							<cfelse>
								<cfset colspan_= 7>
							</cfif>
							<th colspan="#colspan_#" align="center"><cf_get_lang dictionary_id='57589.Bakiye'></th>		
						</cfif>
						<cfif listfind(attributes.report_dsp_type,5)>
							<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
								<cfset colspan_= 10>
							<cfelse>
								<cfset colspan_= 5>
							</cfif>
							<th colspan="#colspan_#" align="center"><cf_get_lang dictionary_id='57689.Risk'></th>		
						</cfif>
						<cfif listfind(attributes.report_dsp_type,3)>
							<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
								<cfset colspan_= 6>
							<cfelse>
								<cfset colspan_= 3>
							</cfif>
							<th colspan="#colspan_#" align="center"><cf_get_lang dictionary_id='39480.Limit'></th>
							
						</cfif>
						
						<cfif listfind(attributes.report_dsp_type,4)>
							<cfif isdefined("attributes.is_tem_detail")>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<cfset colspan_info = 4*(get_sec_type.recordcount+2)-3>
								<cfelse>
									<cfset colspan_info = 2*(get_sec_type.recordcount+2)-1>
								</cfif>
							<cfelse>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<cfset colspan_info = 4>
								<cfelse>
									<cfset colspan_info = 2>
								</cfif>
							</cfif>
							<th colspan="#colspan_info#" align="center"><cf_get_lang dictionary_id='58689.Teminat'></th>
							
						</cfif>
						<cfif listfind(attributes.report_dsp_type,6)>
							<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
								<cfset colspan_= 2>
							<cfelse>
								<cfset colspan_= 1>
							</cfif>
							<th colspan="#colspan_#" align="center"><cf_get_lang dictionary_id='58622.Açık Siparişler'></th>
							
						</cfif>
						<cfif listfind(attributes.report_dsp_type,7)>
							<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
								<cfset colspan_= 2>
							<cfelse>
								<cfset colspan_= 1>
							</cfif>
							<th colspan="#colspan_#" align="center"><cf_get_lang dictionary_id='58986.Faturalaşmamış İrsaliyeler'></th>
							
						</cfif>
					</tr>	
					<cfif listfind(attributes.report_dsp_type,4) and isdefined("attributes.is_tem_detail")>			
						<tr>
							<th colspan="3">&nbsp;</th>
							
							<cfif isdefined("attributes.is_money3")>
								<th align="center"></th>
								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,1)>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<cfset colspan_= 3>
								<cfelse>
									<cfset colspan_= 2>
								</cfif>
								<th colspan="#colspan_#" align="center"></th>
								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,2)>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<cfset colspan_= 10>
								<cfelse>
									<cfset colspan_= 7>
								</cfif>
								<th colspan="#colspan_#" align="center"></th>
								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,5)>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<cfset colspan_= 10>
								<cfelse>
									<cfset colspan_= 5>
								</cfif>
								<th colspan="#colspan_#" align="center"></th>
								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,3)>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<cfset colspan_= 6>
								<cfelse>
									<cfset colspan_= 3>
								</cfif>
								<th colspan="#colspan_#" align="center"></th>
								
							</cfif>
							<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
								<cfset colspan_info = 2*(get_sec_type.recordcount+1)>
							<cfelse>
								<cfset colspan_info = get_sec_type.recordcount+1>
							</cfif>
							<cfif listfind(attributes.report_dsp_type,4)>
								<th colspan="#colspan_info#" align="center"><cf_get_lang dictionary_id='33044.Verilen Teminatlar'></th>
								
								<th colspan="#colspan_info#" align="center"><cf_get_lang dictionary_id='33043.Alınan Teminatlar'></th>
								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,6)>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<cfset colspan_= 2>
								<cfelse>
									<cfset colspan_= 1>
								</cfif>
								<th colspan="#colspan_#" align="center"></th>
								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,7)>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<cfset colspan_= 2>
								<cfelse>
									<cfset colspan_= 1>
								</cfif>
								<th colspan="#colspan_#" align="center"></th>
								
							</cfif>
						</tr>				
					</cfif>		
					<tr>
						<th align="center"><cf_get_lang dictionary_id='57487.No'></th>
						<cfif attributes.report_type eq 1>
							<th align="center"><cf_get_lang dictionary_id='40314.Cari Kodu'></th>
							<th nowrap align="center"><cf_get_lang dictionary_id='57457.Müşteri'></th>
						<cfelseif attributes.report_type eq 2>
							<th nowrap align="center"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></th>
						<cfelseif attributes.report_type eq 3>
							<th nowrap align="center"><cf_get_lang dictionary_id='58134.Mikro Bölge Kodu'></th>
						<cfelseif attributes.report_type eq 4>
							<th nowrap align="center"><cf_get_lang dictionary_id='58552.Müşteri Değeri'></th>
						<cfelseif attributes.report_type eq 5>
							<th nowrap align="center"><cf_get_lang dictionary_id='58795.Müşteri Temsilcisi'></th>
						<cfelseif attributes.report_type eq 7>
							<th nowrap align="center"><cf_get_lang dictionary_id='39242.Müşteri Kategorisi'></th>
						<cfelseif attributes.report_type eq 8>
							<th nowrap align="center"><cf_get_lang dictionary_id='58608.İl'></th>
						</cfif>
						
						<cfif isdefined("attributes.is_money3")>
							<th align="center" nowrap><cf_get_lang dictionary_id='58121.İşlem Dövizi'></th>
							
						</cfif>
						<cfif listfind(attributes.report_dsp_type,1)>
							<th align="center" nowrap><cf_get_lang dictionary_id='30010.Ciro'><cfoutput>#session.ep.money#</cfoutput></th>
							<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
								<th align="center" nowrap><cf_get_lang dictionary_id='30010.Ciro'><cfif isDefined("attributes.is_money2")><cfoutput>#session.ep.money2#</cfoutput></cfif></th>
							</cfif>
							<th align="center" nowrap><cf_get_lang dictionary_id='30010.Ciro'>%</th>
							
						</cfif>
						<cfif listfind(attributes.report_dsp_type,2)>
							<th width="200" align="center"><cf_get_lang dictionary_id='57587.Borç'> <cfoutput>#session.ep.money#</cfoutput></th>
							<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
								<th width="200" align="center"><cf_get_lang dictionary_id='57587.Borç'><cfif isDefined("attributes.is_money2")><cfoutput>#session.ep.money2#</cfoutput></cfif></th>
							</cfif>
							<th width="200" align="center"><cf_get_lang dictionary_id='57587.Borç'><cf_get_lang dictionary_id='57861.Ortalama Vade'></th>
							<th width="200" align="center"><cf_get_lang dictionary_id='57588.Alacak'> <cfoutput>#session.ep.money#</cfoutput></th>
							<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
								<th width="200" align="center"><cf_get_lang dictionary_id='57588.Alacak'><cfif isDefined("attributes.is_money2")><cfoutput>#session.ep.money2#</cfoutput></cfif></th>
							</cfif>
							<th width="200" align="center"><cf_get_lang dictionary_id='57588.Alacak'><cf_get_lang dictionary_id='57861.Ortalama Vade'></th>
							<th width="200" align="center"><cf_get_lang dictionary_id='32737.Açık Hesap'> <cf_get_lang dictionary_id='57589.Bakiye'><cfoutput>#session.ep.money#</cfoutput></th>
							<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
								<th width="200" align="center"><cf_get_lang dictionary_id='32737.Açık Hesap'><cf_get_lang dictionary_id='57589.Bakiye'> <cfif isDefined("attributes.is_money2")><cfoutput>#session.ep.money2#</cfoutput></cfif></th>
							</cfif>
							<th width="200" align="center"><cf_get_lang dictionary_id='57589.Bakiye'><cf_get_lang dictionary_id='57861.Ortalama Vade'></th>
							<th width="100" align="center">Adet</th>
							
						</cfif>
						<cfif listfind(attributes.report_dsp_type,5)>
							<th width="160" align="center"><cf_get_lang dictionary_id='32861.Karşılıksız'> <cf_get_lang dictionary_id='57522.Çek / Senet'> <cfoutput>#session.ep.money#</cfoutput></th>
							<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
								<th width="160" align="center"><cf_get_lang dictionary_id='32861.Karşılıksız'> <cf_get_lang dictionary_id='57522.Çek / Senet'> <cfif isDefined("attributes.is_money2")><cfoutput>#session.ep.money2#</cfoutput></cfif></th>
							</cfif>
							<th width="160" align="center"><cf_get_lang dictionary_id='39483.Ödenmemiş'> <cf_get_lang dictionary_id='57522.Çek / Senet'> <cfoutput>#session.ep.money#</cfoutput></th>
							<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
								<th width="160" align="center"><cf_get_lang dictionary_id='39483.Ödenmemiş'> <cf_get_lang dictionary_id='57522.Çek / Senet'> <cfif isDefined("attributes.is_money2")><cfoutput>#session.ep.money2#</cfoutput></cfif></th>
							</cfif>
							<th width="160" align="center"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='57689.Risk'> <cfoutput>#session.ep.money#</cfoutput></th>
							<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
								<th width="160" align="center"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='57689.Risk'> <cfif isDefined("attributes.is_money2")><cfoutput>#session.ep.money2#</cfoutput></cfif></th>
							</cfif>
							<th width="160" align="center"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='57689.Risk'>/<cf_get_lang dictionary_id='30010.Ciro'><cfoutput>#session.ep.money#</cfoutput></th>
							<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
								<th width="160" align="center"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='57689.Risk'>/<cf_get_lang dictionary_id='30010.Ciro'><cfif isDefined("attributes.is_money2")><cfoutput>#session.ep.money2#</cfoutput></cfif></th>
							</cfif>
							<th width="160" align="center"><cf_get_lang dictionary_id='39484.Serbest/Kullanılabilir'> <cf_get_lang dictionary_id='57689.Risk'> <cfoutput>#session.ep.money#</cfoutput></th>
							<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
								<th width="160" align="center"><cf_get_lang dictionary_id='39484.Serbest/Kullanılabilir'> <cf_get_lang dictionary_id='57689.Risk'> <cfif isDefined("attributes.is_money2")><cfoutput>#session.ep.money2#</cfoutput></cfif></th>
							</cfif>
							
						</cfif>
						<cfif listfind(attributes.report_dsp_type,3)>
							<th width="100" align="center"><cf_get_lang dictionary_id='32737.Açık Hesap'> <cf_get_lang dictionary_id='39480.Limit'> <cfoutput>#session.ep.money#</cfoutput></th>
							<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
								<th width="100" align="center"><cf_get_lang dictionary_id='32737.Açık Hesap'> <cf_get_lang dictionary_id='39480.Limit'> <cfif isDefined("attributes.is_money2")><cfoutput>#session.ep.money2#</cfoutput></cfif></th>
							</cfif>
							<th width="100" align="center"><cf_get_lang dictionary_id='57798.Vadeli'> <cf_get_lang dictionary_id='39480.Limit'> <cfoutput>#session.ep.money#</cfoutput></th>
							<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
								<th width="100" align="center"><cf_get_lang dictionary_id='57798.Vadeli'> <cf_get_lang dictionary_id='39480.Limit'> <cfif isDefined("attributes.is_money2")><cfoutput>#session.ep.money2#</cfoutput></cfif></th>
							</cfif>
							<th width="100" align="center"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='39480.Limit'> <cfoutput>#session.ep.money#</cfoutput></th>
							<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
								<th width="100" align="center"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='39480.Limit'> <cfif isDefined("attributes.is_money2")><cfoutput>#session.ep.money2#</cfoutput></cfif></th>
							</cfif>
							
						</cfif>
						<cfif listfind(attributes.report_dsp_type,4)>
							<cfif not isdefined("attributes.is_tem_detail")>
								<th width="100" align="center"><cf_get_lang dictionary_id='40315.Verilen Teminat'><cfoutput>#session.ep.money#</cfoutput></th>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<th width="125" align="center"><cf_get_lang dictionary_id='40315.Verilen Teminat'><cfif isDefined("attributes.is_money2")><cfoutput>#session.ep.money2#</cfoutput></cfif></th>
								</cfif>
								<th width="100" align="center"><cf_get_lang dictionary_id='40316.Alınan Teminat'><cfoutput>#session.ep.money#</cfoutput></th>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<th width="125" align="center"><cf_get_lang dictionary_id='40316.Alınan Teminat'><cfif isDefined("attributes.is_money2")><cfoutput>#session.ep.money2#</cfoutput></cfif></th>
								</cfif>
							<cfelse>
								<cfloop query="get_sec_type">
									<cfset "all_total_take_#securefund_cat_id#" = 0>
									<cfset "all_total_give_#securefund_cat_id#" = 0>
									<cfif isdefined("attributes.is_money3")>
										<cfoutput query="get_money">
											<cfset "all_total_take_2_#get_sec_type.securefund_cat_id#_#money#" = 0>
											<cfset "all_total_give_2_#get_sec_type.securefund_cat_id#_#money#" = 0>
										</cfoutput>
									<cfelse>
										<cfset "all_total_take_2_#securefund_cat_id#" = 0>
										<cfset "all_total_give_2_#securefund_cat_id#" = 0>
									</cfif>
									<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
										<cfset colspan=2>
									<cfelse>
										<cfset colspan=1>
									</cfif>
									<th nowrap align="center" colspan="#colspan#">#securefund_cat#</th>
								</cfloop>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<cfset colspan=2>
								<cfelse>
									<cfset colspan=1>									
								</cfif>
								<th width="100" align="center" colspan="#colspan#"><cf_get_lang dictionary_id='57492.Toplam'></th>
								<cfloop query="get_sec_type">
									 <cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									 	<cfset colspan= 2>
									<cfelse>
										<cfset colspan= 1>											
									</cfif>
									<th nowrap align="center" colspan="#colspan#">#securefund_cat#</th>
								</cfloop>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<cfset colspan= 2>
								<cfelse>
									<cfset colspan= 1>
								</cfif>
								<th width="100" align="center" colspan="#colspan#"><cf_get_lang dictionary_id='57492.Toplam'></th>
							</cfif>
						</cfif>
						<cfif listfind(attributes.report_dsp_type,6)>
							<th width="100" align="center"><cf_get_lang dictionary_id='57611.Sipariş'> <cfoutput>#session.ep.money#</cfoutput></th>
							<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
								<th width="100" align="center"><cf_get_lang dictionary_id='57611.Sipariş'> <cfif isDefined("attributes.is_money2")><cfoutput>#session.ep.money2#</cfoutput></cfif></th>
							</cfif>
						</cfif>
						<cfif listfind(attributes.report_dsp_type,7)>
							<th width="100" align="center"><cf_get_lang dictionary_id='34090.İrsaliyeler'> <cfoutput>#session.ep.money#</cfoutput></th>
							<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
								<th width="100" align="center"><cf_get_lang dictionary_id='34090.İrsaliyeler'> <cfif isDefined("attributes.is_money2")><cfoutput>#session.ep.money2#</cfoutput></cfif></th>
							</cfif>
						</cfif>
					</tr>			
					<cfif listfind(attributes.report_dsp_type,4) and isdefined("attributes.is_tem_detail") and (isDefined("attributes.is_money2") or isDefined("attributes.is_money3"))>						
						<tr>
							<th colspan="3">&nbsp;</th>
							
							<cfif isdefined("attributes.is_money3")>
								<th align="center"></th>
								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,1)>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<cfset colspan= 3>
								<cfelse>
									<cfset colspan= 3>
								</cfif>
								<th colspan="#colspan#" align="center"></th>
								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,2)>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<cfset colspan= 10>
								<cfelse>
									<cfset colspan= 7>
								</cfif>
								<th colspan="#colspan#" align="center"></th>
								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,5)>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<cfset colspan= 10>
								<cfelse>
									<cfset colspan= 5>
								</cfif>
								<th colspan="#colspan#" align="center"></th>
								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,3)>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<cfset colspan= 6>
								<cfelse>
									<cfset colspan= 3>
								</cfif>
								<th colspan="#colspan#" align="center"></th>
								
							</cfif>
							<cfoutput query="get_sec_type">
								<th align="center">#session.ep.money#</th>
								<th align="center"><cfif isDefined("attributes.is_money2")>#session.ep.money2#<cfelse><cf_get_lang dictionary_id='58121.İşlem Dövizi'></cfif></th>
							</cfoutput>
							<cfoutput>
							<th align="center">#session.ep.money#</th>
							<th align="center"><cfif isDefined("attributes.is_money2")>#session.ep.money2#<cfelse><cf_get_lang dictionary_id='58121.İşlem Dövizi'></cfif></th>
							</cfoutput>
							
							<cfoutput query="get_sec_type">
								<th align="center">#session.ep.money#</th>
								<th align="center"><cfif isDefined("attributes.is_money2")>#session.ep.money2#<cfelse><cf_get_lang dictionary_id='58121.İşlem Dövizi'></cfif></th>
							</cfoutput>
							<cfoutput>
							<th align="center">#session.ep.money#</th>
							<th align="center"><cfif isDefined("attributes.is_money2")>#session.ep.money2#<cfelse><cf_get_lang dictionary_id='58121.İşlem Dövizi'></cfif></th>
							</cfoutput>
							
							<cfif listfind(attributes.report_dsp_type,6)>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<cfset colspan= 2>
								<cfelse>
									<cfset colspan= 1>
								</cfif>
								<th colspan="#colspan#" align="center"></th>
								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,7)>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<cfset colspan= 2>
								<cfelse>
									<cfset colspan= 1>
								</cfif>
								<th colspan="#colspan#" align="center"></th>
								
							</cfif>
						</tr>	
					</cfif>
				</cfoutput>
                </thead>
                <tbody>
                    <cfif get_total_purchase.recordcount>
					<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif isdefined("attributes.is_money3")>
							<cfscript>
									if(kontrol eq 1)
									{
										this_sira_ = listfindnocase(company_list,process_id);
										if(this_sira_ gt 0)
											this_rows_ = listgetat(company_count_list,this_sira_);
										else
											this_rows_ = 1;
									}
									else if(kontrol eq 0)
									{	
										this_sira_ = listfindnocase(consumer_list,process_id);
										if(this_sira_ gt 0)
											this_rows_ = listgetat(consumer_count_list,this_sira_);
										else
											this_rows_ = 1;
									}
								else
									this_rows_ = 1;
							</cfscript>
						<cfelse>
							<cfset this_rows_ = 1>
						</cfif>
						<cfset row_order = 0>
						<cfset row_order2 = 0>
						<cfset row_ship = 0>
						<cfset row_ship2 = 0>
						<cfif isdefined("attributes.is_money3")>
							<cfif isdefined("total_order_#get_total_purchase.kontrol#_#get_total_purchase.process_id#_#other_money#")>
								<cfset row_order = evaluate("total_order_#get_total_purchase.kontrol#_#get_total_purchase.process_id#_#other_money#")>
								<cfset row_order2 = evaluate("total_order_2_#get_total_purchase.kontrol#_#get_total_purchase.process_id#_#other_money#")>
							</cfif>
							<cfif isdefined("total_ship_#get_total_purchase.kontrol#_#get_total_purchase.process_id#_#other_money#")>
								<cfset row_ship = evaluate("total_ship_#get_total_purchase.kontrol#_#get_total_purchase.process_id#_#other_money#")>
								<cfset row_ship2 = evaluate("total_ship_2_#get_total_purchase.kontrol#_#get_total_purchase.process_id#_#other_money#")>
							</cfif>
						<cfelse>
							<cfif isdefined("total_order_#get_total_purchase.kontrol#_#get_total_purchase.process_id#")>
								<cfset row_order = evaluate("total_order_#get_total_purchase.kontrol#_#get_total_purchase.process_id#")>
								<cfset row_order2 = evaluate("total_order_2_#get_total_purchase.kontrol#_#get_total_purchase.process_id#")>
							</cfif>
							<cfif isdefined("total_ship_#get_total_purchase.kontrol#_#get_total_purchase.process_id#")>
								<cfset row_ship = evaluate("total_ship_#get_total_purchase.kontrol#_#get_total_purchase.process_id#")>
								<cfset row_ship2 = evaluate("total_ship_2_#get_total_purchase.kontrol#_#get_total_purchase.process_id#")>
							</cfif>
						</cfif>
						<tr>
							<cfif len(NETTOTAL)><cfset ciro_toplam = ciro_toplam + NETTOTAL></cfif>
							<cfif len(BAKIYE)>
								<cfset acik_hesap_bakiye = acik_hesap_bakiye + BAKIYE>
							</cfif>
							<cfif len(OPEN_ACCOUNT_RISK_LIMIT)><cfset acik_hesap_limit = acik_hesap_limit + OPEN_ACCOUNT_RISK_LIMIT></cfif>
							<cfif len(FORWARD_SALE_LIMIT)><cfset vadeli_limit = vadeli_limit + FORWARD_SALE_LIMIT></cfif>
							<cfif len(TOTAL_RISK_LIMIT)><cfset toplam_limit =  toplam_limit + TOTAL_RISK_LIMIT></cfif>
							<cfif listfind(attributes.report_dsp_type,1) or listfind(attributes.report_dsp_type,2) or listfind(attributes.report_dsp_type,3)>
								<cfif len(NETTOTAL_DOVIZ)><cfset ciro_toplam_money2 = ciro_toplam_money2 + NETTOTAL_DOVIZ></cfif>
								<cfif len(BAKIYE2)>
									<cfif isDefined("attributes.is_money3")>
										<cfset "acik_hesap_bakiye_money#other_money#" = evaluate("acik_hesap_bakiye_money#other_money#") + BAKIYE2>
									<cfelse>
										<cfset acik_hesap_bakiye_money2 = acik_hesap_bakiye_money2 + BAKIYE2>
									</cfif>
								</cfif>
							</cfif>
							<cfif (attributes.page neq 1 and currentrow eq (maxrows+attributes.page-1)) or (PROCESS_ID[currentrow] neq PROCESS_ID[currentrow-1]) or (currentrow mod attributes.maxrows eq 1) or kontrol[currentrow] neq kontrol[currentrow-1]>
								<td rowspan="#this_rows_#">#currentrow#</td>
								<cfif attributes.report_type eq 1>
									<td rowspan="#this_rows_#">#member_code#</td>
									<td rowspan="#this_rows_#"> 
										<cfif kontrol eq 1>
											<cfif type_ eq 1>
												#FULLNAME#
											<cfelse>
												<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#PROCESS_ID#','medium');" class="tableyazi">#FULLNAME#</a>
											</cfif>
										<cfelse>
											<cfif type_ eq 1>
												#FULLNAME#
											<cfelse>																		
												<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#PROCESS_ID#','medium');" class="tableyazi">#FULLNAME#</a>
											</cfif>
										</cfif>
										<cfset title = fullname>
									</td>
								<cfelseif attributes.report_type eq 2>
									<td rowspan="#this_rows_#">
										#sz_2.sz_name[listfind(list_zone_ids,process_id,',')]#
										<cfset title = sz_2.sz_name[listfind(list_zone_ids,process_id,',')]>
									</td>
								<cfelseif attributes.report_type eq 3>
									<td rowspan="#this_rows_#">
										#ims_code_name#
										<cfset title = ims_code_name>
									</td>
								<cfelseif attributes.report_type eq 4>
									<td rowspan="#this_rows_#">
										#get_customer_value_2.customer_value[listfind(list_customer_val_ids,process_id,',')]#
										<cfset title = get_customer_value_2.customer_value[listfind(list_customer_val_ids,process_id,',')]>
									</td>
								<cfelseif attributes.report_type eq 5>
									<td rowspan="#this_rows_#">
										<cfset employee_id=get_emp_info.employee_id[listfind(process_id_list,process_id,',')]>
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#get_emp_info.EMPLOYEE_NAME[listfind(process_id_list,PROCESS_ID,',')]# #get_emp_info.EMPLOYEE_SURNAME[listfind(process_id_list,PROCESS_ID,',')]#</a>
										<cfset title =get_emp_info.EMPLOYEE_NAME[listfind(process_id_list,PROCESS_ID,',')]&' '&get_emp_info.EMPLOYEE_SURNAME[listfind(process_id_list,PROCESS_ID,',')]>
									</td>
								<cfelseif attributes.report_type eq 7>
									<td rowspan="#this_rows_#">
										#get_comp_cat.companycat[listfind(process_id_list,process_id,',')]#
										<cfset title = get_comp_cat.companycat[listfind(process_id_list,process_id,',')]>
									</td>
								<cfelseif attributes.report_type eq 8>
									<td rowspan="#this_rows_#">
										#get_city.city_name[listfind(process_id_list,process_id,',')]#
										<cfset title = get_city.city_name[listfind(process_id_list,process_id,',')]>
									</td>
								</cfif>
							</cfif>							
							<cfif isdefined("attributes.is_money3")>
								<cfset title = "#title# #other_money#">
								<td title="#title#">#other_money#</td>								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,1)>
								<td align="right" style="text-align:right;" title="#title#">#TLFormat(nettotal)#</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" style="text-align:right;" title="#title#">#TLFormat(nettotal_doviz)#</td>
								</cfif>
								<td align="right" style="text-align:right;" title="#title#"><cfif butun_toplam neq 0>#Replace(NumberFormat(nettotal*100/butun_toplam,"00.00"),".",",")#</cfif></td>	
							</cfif>
							<cfif listfind(attributes.report_dsp_type,2)>
								<td align="right" style="text-align:right;" title="#title#">#TLFormat(BORC)#</td>
								<cfif len(BORC)>
									<cfset toplam_borc = toplam_borc + BORC>
									<cfset toplam_borc_vade = toplam_borc_vade + BORC*vade_borc_new>
								</cfif>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" style="text-align:right;" title="#title#">#TLFormat(BORC2)#</td>
									<cfif len(BORC2)>
										<cfif isDefined("attributes.is_money3")>
											<cfset "toplam_borc#other_money#" = evaluate("toplam_borc#other_money#") + BORC2>
										<cfelse>
											<cfset toplam_borc2 = toplam_borc2 + BORC2>
										</cfif>
									</cfif>
								</cfif>
								<td align="right" style="text-align:right;" title="#title#">#dateformat(date_add('d',-1*vade_borc_new,now()),dateformat_style)#</td>
								<td align="right" style="text-align:right;" title="#title#">#TLFormat(ALACAK)#</td>
								<cfif len(ALACAK)>
									<cfset toplam_alacak = toplam_alacak + ALACAK>
									<cfset toplam_alacak_vade = toplam_alacak_vade + ALACAK*vade_alacak_new>
								</cfif>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" style="text-align:right;" title="#title#">#TLFormat(ALACAK2)#</td>
									<cfif len(ALACAK2)>
										<cfif isDefined("attributes.is_money3")>
											<cfset "toplam_alacak#other_money#" = evaluate("toplam_alacak#other_money#") + ALACAK2>
										<cfelse>
											<cfset toplam_alacak2 = toplam_alacak2 + ALACAK2>
										</cfif>
									</cfif>
								</cfif>
								<td align="right" style="text-align:right;" title="#title#">#dateformat(date_add('d',-1*vade_alacak_new,now()),dateformat_style)#</td>
								<td align="right" style="text-align:right;" nowrap="nowrap" title="#title#">#TLFormat(BAKIYE)#</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" style="text-align:right;" nowrap="nowrap" title="#title#">#TLFormat(BAKIYE2)#</td>
								</cfif>
								<td align="right" style="text-align:right;" title="#title#">
									<cfif borc+alacak gt 0>
										#TLFormat(((abs(vade_borc_new) * abs(borc)) + (abs(vade_alacak_new) * abs(alacak)))/(abs(borc)+abs(alacak)),0)#
									<cfelse>
										0
									</cfif>
								</td>
								<td align="right" nowrap="nowrap" title="#title#">#TLFormat(VADE_PER)#</td>
								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,5)>
								<td align="right" style="text-align:right;" title="#title#">
									<cfif len(SENET_KARSILIKSIZ) and len(CEK_KARSILIKSIZ)>
										#TLFormat(CEK_KARSILIKSIZ + SENET_KARSILIKSIZ)#
										<cfset kars_cek_senet = kars_cek_senet + (CEK_KARSILIKSIZ + SENET_KARSILIKSIZ)>
									</cfif>
								</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" style="text-align:right;" title="#title#">
										<cfif len(SENET_KARSILIKSIZ2) and len(CEK_KARSILIKSIZ2)>
											#TLFormat(CEK_KARSILIKSIZ2 + SENET_KARSILIKSIZ2)#
											<cfif isDefined("attributes.is_money3")>
												<cfset "kars_cek_senet#other_money#" = evaluate("kars_cek_senet#other_money#") + (CEK_KARSILIKSIZ2 + SENET_KARSILIKSIZ2)>
											<cfelse>
												<cfset kars_cek_senet2 = kars_cek_senet2 + (CEK_KARSILIKSIZ2 + SENET_KARSILIKSIZ2)>
											</cfif>
										</cfif>
									</td>
								</cfif>
								<td align="right" title="#title#">
									<cfif len(CEK_ODENMEDI) and len(SENET_ODENMEDI)>
										#TLFormat(CEK_ODENMEDI + SENET_ODENMEDI)#
										<cfset odenmemis_cek_senet = odenmemis_cek_senet + CEK_ODENMEDI + SENET_ODENMEDI>
									</cfif>
								</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" style="text-align:right;" title="#title#">
										<cfif len(CEK_ODENMEDI2) and len(SENET_ODENMEDI2)>
											#TLFormat(CEK_ODENMEDI2 + SENET_ODENMEDI2)#
											<cfif isDefined("attributes.is_money3")>
												<cfset "odenmemis_cek_senet#other_money#" = evaluate("odenmemis_cek_senet#other_money#") + (CEK_ODENMEDI2 + SENET_ODENMEDI2)>
											<cfelse>
												<cfset odenmemis_cek_senet2 = odenmemis_cek_senet2 + CEK_ODENMEDI2 + SENET_ODENMEDI2>
											</cfif>
										</cfif>
									</td>
								</cfif>
								<td align="right" nowrap="nowrap" style="text-align:right;" title="#title#">
									<cfif len(BAKIYE) and len(SENET_KARSILIKSIZ) and len(CEK_KARSILIKSIZ) and len(CEK_ODENMEDI) and len(SENET_ODENMEDI)>
										<cfset toplam_risk = BAKIYE + SENET_KARSILIKSIZ + CEK_KARSILIKSIZ + CEK_ODENMEDI + SENET_ODENMEDI + row_order + row_ship>
										#TLFormat(toplam_risk)#
										<cfif len(toplam_risk)><cfset risk_toplam = risk_toplam + toplam_risk></cfif>
									<cfelse>
										<cfset toplam_risk = 0>
									</cfif>
								</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" nowrap="nowrap" style="text-align:right;" title="#title#">
										<cfif len(BAKIYE2) and len(SENET_KARSILIKSIZ2) and len(CEK_KARSILIKSIZ2) and len(CEK_ODENMEDI2) and len(SENET_ODENMEDI2)>
											<cfset toplam_risk2 = BAKIYE2 + SENET_KARSILIKSIZ2 + CEK_KARSILIKSIZ2 + CEK_ODENMEDI2 + SENET_ODENMEDI2 + row_order2 + row_ship2>
											#TLFormat(toplam_risk2)#
											<cfif len(toplam_risk2)>
												<cfif isDefined("attributes.is_money3")>
													<cfset "risk_toplam#other_money#" = evaluate("risk_toplam#other_money#") + toplam_risk2>
												<cfelse>
													<cfset risk_toplam2 = risk_toplam2 + toplam_risk2>
												</cfif>
											</cfif>
										</cfif>
									</td>
								</cfif>
								<td align="right" style="text-align:right;" title="#title#"><cfif isDefined("toplam_risk") and NETTOTAL gt 0>#TLFormat(toplam_risk/NETTOTAL)#<cfelse>#TLFormat(0)#</cfif></td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" style="text-align:right;" title="#title#"><cfif isDefined("toplam_risk2") and nettotal_doviz gt 0>#TLFormat(toplam_risk2/nettotal_doviz)#<cfelse>#TLFormat(0)#</cfif></td>
								</cfif>
								<td align="right" nowrap="nowrap" title="#title#">
									<cfif len(TOTAL_RISK_LIMIT)>
										#TLFormat(TOTAL_RISK_LIMIT - toplam_risk)#
										<cfset kullanilabilir_risk = kullanilabilir_risk + TOTAL_RISK_LIMIT - toplam_risk>
									</cfif>
								</td>						
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" nowrap="nowrap" style="text-align:right;" title="#title#">
										<cfif isDefined("attributes.is_money3")>
											<cfif not len(OPEN_ACCOUNT_RISK_LIMIT3)>
												<cfset OPEN_ACCOUNT_RISK_LIMIT3_ = 0>
											<cfelse>
												<cfset OPEN_ACCOUNT_RISK_LIMIT3_ = OPEN_ACCOUNT_RISK_LIMIT3>
											</cfif>
											<cfif not len(FORWARD_SALE_LIMIT3)>
												<cfset FORWARD_SALE_LIMIT3_ = 0>
											<cfelse>
												<cfset FORWARD_SALE_LIMIT3_ = FORWARD_SALE_LIMIT3>
											</cfif>
											#TLFormat(FORWARD_SALE_LIMIT3_ + OPEN_ACCOUNT_RISK_LIMIT3_ - toplam_risk2)#
											<cfset "kullanilabilir_risk#other_money#" = evaluate("kullanilabilir_risk#other_money#") + (FORWARD_SALE_LIMIT3_ + OPEN_ACCOUNT_RISK_LIMIT3_ - toplam_risk2)>
										<cfelse>
											<cfif not len(OPEN_ACCOUNT_RISK_LIMIT)>
												<cfset OPEN_ACCOUNT_RISK_LIMIT_ = 0>
											<cfelse>
												<cfset OPEN_ACCOUNT_RISK_LIMIT_ = OPEN_ACCOUNT_RISK_LIMIT>
											</cfif>
											<cfif not len(FORWARD_SALE_LIMIT)>
												<cfset FORWARD_SALE_LIMIT_ = 0>
											<cfelse>
												<cfset FORWARD_SALE_LIMIT_ = FORWARD_SALE_LIMIT>
											</cfif>
											#TLFormat(FORWARD_SALE_LIMIT_ + (OPEN_ACCOUNT_RISK_LIMIT_*GET_MONEY_INFO.RATE) - toplam_risk2)#
											<cfset kullanilabilir_risk2 = kullanilabilir_risk2 + (FORWARD_SALE_LIMIT_ + (OPEN_ACCOUNT_RISK_LIMIT_*GET_MONEY_INFO.RATE) - toplam_risk2)>
										</cfif>
									</td>
								</cfif>
							
							</cfif>
							<cfif listfind(attributes.report_dsp_type,3)>
								<td align="right" style="text-align:right;" title="#title#">
									<cfif not len(OPEN_ACCOUNT_RISK_LIMIT)>
										<cfset OPEN_ACCOUNT_RISK_LIMIT_ = 0>
									<cfelse>
										<cfset OPEN_ACCOUNT_RISK_LIMIT_ = OPEN_ACCOUNT_RISK_LIMIT>
									</cfif>
									#TLFormat(OPEN_ACCOUNT_RISK_LIMIT_)#
								</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" style="text-align:right;" title="#title#">
										<cfif GET_MONEY_INFO.recordcount and len(OPEN_ACCOUNT_RISK_LIMIT) and isDefined("attributes.is_money3")>
											<cfif not len(OPEN_ACCOUNT_RISK_LIMIT3)>
												<cfset OPEN_ACCOUNT_RISK_LIMIT3_ = 0>
											<cfelse>
												<cfset OPEN_ACCOUNT_RISK_LIMIT3_ = OPEN_ACCOUNT_RISK_LIMIT>
											</cfif>
											#TLFormat(OPEN_ACCOUNT_RISK_LIMIT3_)#
											<cfset "acik_hesap_limit_money#other_money#" = evaluate("acik_hesap_limit_money#other_money#") + OPEN_ACCOUNT_RISK_LIMIT3_>
										<cfelse>
											<cfif not len(OPEN_ACCOUNT_RISK_LIMIT)>
												<cfset OPEN_ACCOUNT_RISK_LIMIT_ = 0>
											<cfelse>
												<cfset OPEN_ACCOUNT_RISK_LIMIT_ = OPEN_ACCOUNT_RISK_LIMIT>
											</cfif>
											#TLFormat(OPEN_ACCOUNT_RISK_LIMIT_*GET_MONEY_INFO.RATE)#
											<cfset acik_hesap_limit_money2 = acik_hesap_limit_money2 + (OPEN_ACCOUNT_RISK_LIMIT_*GET_MONEY_INFO.RATE)>
										</cfif>
									</td>
								</cfif>
								<td align="right" style="text-align:right;" title="#title#">
									<cfif not len(FORWARD_SALE_LIMIT)>
										<cfset FORWARD_SALE_LIMIT_ = 0>
									<cfelse>
										<cfset FORWARD_SALE_LIMIT_ = FORWARD_SALE_LIMIT>
									</cfif>
									#TLFormat(FORWARD_SALE_LIMIT_)#
								</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" style="text-align:right;" title="#title#">
										<cfif GET_MONEY_INFO.recordcount and len(FORWARD_SALE_LIMIT) and isDefined("attributes.is_money3")>
											<cfif not len(FORWARD_SALE_LIMIT3)>
												<cfset FORWARD_SALE_LIMIT3_ = 0>
											<cfelse>
												<cfset FORWARD_SALE_LIMIT3_ = FORWARD_SALE_LIMIT>
											</cfif>
											<cfif isDefined("attributes.is_money3")>
												#TLFormat(FORWARD_SALE_LIMIT3_)#
												<cfset "vadeli_limit_money#other_money#" = evaluate("vadeli_limit_money#other_money#") + FORWARD_SALE_LIMIT3_>
											<cfelse>
												<cfif not len(FORWARD_SALE_LIMIT)>
													<cfset FORWARD_SALE_LIMIT_ = 0>
												<cfelse>
													<cfset FORWARD_SALE_LIMIT_ = FORWARD_SALE_LIMIT>
												</cfif>
												#TLFormat(FORWARD_SALE_LIMIT_*GET_MONEY_INFO.RATE)#
												<cfset vadeli_limit_money2 = vadeli_limit_money2 + (FORWARD_SALE_LIMIT_)*GET_MONEY_INFO.RATE>
											</cfif>
										</cfif>
									</td>
								</cfif>
								<td align="right" style="text-align:right;" title="#title#">#TLFormat(TOTAL_RISK_LIMIT)#</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" style="text-align:right;" title="#title#">
										<cfif GET_MONEY_INFO.recordcount and len(TOTAL_RISK_LIMIT)>
											<cfif isDefined("attributes.is_money3")>
												<cfif not len(FORWARD_SALE_LIMIT3)>
													<cfset FORWARD_SALE_LIMIT3_ = 0>
												<cfelse>
													<cfset FORWARD_SALE_LIMIT3_ = FORWARD_SALE_LIMIT3>
												</cfif>
												<cfif not len(OPEN_ACCOUNT_RISK_LIMIT3)>
													<cfset OPEN_ACCOUNT_RISK_LIMIT3_ = 0>
												<cfelse>
													<cfset OPEN_ACCOUNT_RISK_LIMIT3_ = OPEN_ACCOUNT_RISK_LIMIT3>
												</cfif>
												#TLFormat(OPEN_ACCOUNT_RISK_LIMIT3_+FORWARD_SALE_LIMIT3_)#
												<cfset "toplam_limit_money#other_money#" = evaluate("toplam_limit_money#other_money#") + (OPEN_ACCOUNT_RISK_LIMIT3_+FORWARD_SALE_LIMIT3_)>
											<cfelse>
												#TLFormat((TOTAL_RISK_LIMIT)*GET_MONEY_INFO.RATE)#
												<cfset toplam_limit_money2 = toplam_limit_money2 + (TOTAL_RISK_LIMIT)*GET_MONEY_INFO.RATE>
											</cfif>
										</cfif>
									</td>
								</cfif>
								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,4)>
								<cfif not isdefined("attributes.is_tem_detail")>
									<td align="right" style="text-align:right;" title="#title#">
										<cfif len(SECURE_TOTAL_GIVE)>
											#TLFormat(SECURE_TOTAL_GIVE)#
											<cfset verilen_teminat = verilen_teminat + SECURE_TOTAL_GIVE> 
										<cfelse>
											#TLFormat(0)#
										</cfif>
									</td>
									<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
										<td align="right" style="text-align:right;" title="#title#">
											<cfif len(SECURE_TOTAL_GIVE2)>
												#TLFormat(SECURE_TOTAL_GIVE2)#
												<cfif isDefined("attributes.is_money3")>
													<cfset "verilen_teminat#other_money#" = evaluate("verilen_teminat#other_money#") +SECURE_TOTAL_GIVE2>
												<cfelse>
													<cfset verilen_teminat2 = verilen_teminat2 + SECURE_TOTAL_GIVE2> 
												</cfif>
											<cfelse>
												#TLFormat(0)#
											</cfif>
										</td>
									</cfif>
									<td align="right" style="text-align:right;" title="#title#">
										<cfif len(SECURE_TOTAL_TAKE)>
											#TLFormat(SECURE_TOTAL_TAKE)#
											<cfset alinan_teminat = alinan_teminat + SECURE_TOTAL_TAKE> 
										<cfelse>
											#TLFormat(0)#
										</cfif>
									</td>
									<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
										<td align="right" style="text-align:right;" title="#title#">
											<cfif len(SECURE_TOTAL_TAKE2)>
												#TLFormat(SECURE_TOTAL_TAKE2)#
												<cfif isDefined("attributes.is_money3")>
													<cfset "alinan_teminat#other_money#" = evaluate("alinan_teminat#other_money#") +SECURE_TOTAL_TAKE2>
												<cfelse>
													<cfset alinan_teminat2 = alinan_teminat2 + SECURE_TOTAL_TAKE2> 
												</cfif>
											<cfelse>
												#TLFormat(0)#
											</cfif>
										</td>
									</cfif>
								<cfelse>
									<cfset row_tem_total_take=0>
									<cfset row_tem_total_take2=0>
									<cfset row_tem_total_give=0>
									<cfset row_tem_total_give2=0>
									<cfloop query="get_sec_type">
										<cfif isDefined("attributes.is_money3")>
											<td align="right" style="text-align:right;" title="#title#">
												<cfif isdefined("total_give_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#_#get_total_purchase.other_money#")>
													#TLFormat(evaluate("total_give_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#_#get_total_purchase.other_money#"))#	
													<cfset row_tem_total_give=row_tem_total_give+evaluate("total_give_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#_#get_total_purchase.other_money#")>									 
													<cfset "all_total_give_#securefund_cat_id#" =evaluate("all_total_give_#securefund_cat_id#")+evaluate("total_give_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#_#get_total_purchase.other_money#")>
												<cfelse>
													#TLFormat(0)#
												</cfif>
											</td>
											<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
												<td align="right" style="text-align:right;" title="#title#">
													<cfif isdefined("total_give_2_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#_#get_total_purchase.other_money#")>
														#TLFormat(evaluate("total_give_2_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#_#get_total_purchase.other_money#"))#	
														<cfset row_tem_total_give2=row_tem_total_give2+evaluate("total_give_2_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#_#get_total_purchase.other_money#")>									 
														<cfif isDefined("attributes.is_money3")>
															<cfset "all_total_give_2_#securefund_cat_id#_#get_total_purchase.other_money#" = evaluate("all_total_give_2_#securefund_cat_id#_#get_total_purchase.other_money#") +evaluate("total_give_2_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#_#get_total_purchase.other_money#")>
														<cfelse>
															<cfset "all_total_give_2_#securefund_cat_id#" =evaluate("all_total_give_2_#securefund_cat_id#")+evaluate("total_give_2_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#_#get_total_purchase.other_money#")>
														</cfif>
													<cfelse>
														#TLFormat(0)#
													</cfif>
												</td>
											</cfif>
										<cfelse>
											<td align="right" style="text-align:right;" title="#title#">
												<cfif isdefined("total_give_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#")>
													#TLFormat(evaluate("total_give_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#"))#	
													<cfset row_tem_total_give=row_tem_total_give+evaluate("total_give_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#")>									 
													<cfset "all_total_give_#securefund_cat_id#" =evaluate("all_total_give_#securefund_cat_id#")+evaluate("total_give_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#")>
												<cfelse>
													#TLFormat(0)#
												</cfif>
											</td>
											<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
												<td align="right" style="text-align:right;" title="#title#">
													<cfif isdefined("total_give_2_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#")>
														#TLFormat(evaluate("total_give_2_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#"))#	
														<cfset row_tem_total_give2=row_tem_total_give2+evaluate("total_give_2_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#")>									 
														<cfif isDefined("attributes.is_money3")>
															<cfset "all_total_give_2_#securefund_cat_id#_#get_total_purchase.other_money#" = evaluate("all_total_give_2_#securefund_cat_id#_#get_total_purchase.other_money#") +evaluate("total_give_2_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#")>
														<cfelse>
															<cfset "all_total_give_2_#securefund_cat_id#" =evaluate("all_total_give_2_#securefund_cat_id#")+evaluate("total_give_2_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#")>
														</cfif>
													<cfelse>
														#TLFormat(0)#
													</cfif>
												</td>
											</cfif>
										</cfif>
									</cfloop>
									<td align="right" style="text-align:right;" title="#title#">
										#TLFormat(row_tem_total_give)#
										<cfset verilen_teminat = verilen_teminat + row_tem_total_give> 
									</td>
									<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
										<td align="right" style="text-align:right;" title="#title#">
											#TLFormat(row_tem_total_give2)#
											<cfif isDefined("attributes.is_money3")>
												<cfset "verilen_teminat#other_money#" = evaluate("verilen_teminat#other_money#") + row_tem_total_give2>
											<cfelse>
												<cfset verilen_teminat2 = verilen_teminat2 + row_tem_total_give2> 
											</cfif>
										</td>
									</cfif>
									
									<cfloop query="get_sec_type">
										<cfif isDefined("attributes.is_money3")>
											<td align="right" style="text-align:right;" title="#title#">
												<cfif isdefined("total_take_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#_#get_total_purchase.other_money#")>
													#TLFormat(evaluate("total_take_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#_#get_total_purchase.other_money#"))#										 
													<cfset row_tem_total_take=row_tem_total_take+evaluate("total_take_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#_#get_total_purchase.other_money#")>									 
													<cfset "all_total_take_#securefund_cat_id#" =evaluate("all_total_take_#securefund_cat_id#")+evaluate("total_take_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#_#get_total_purchase.other_money#")>
												<cfelse>
													#TLFormat(0)#
												</cfif>
											</td>
											<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
												<td align="right" style="text-align:right;" title="#title#">
													<cfif isdefined("total_take_2_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#_#get_total_purchase.other_money#")>
														#TLFormat(evaluate("total_take_2_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#_#get_total_purchase.other_money#"))#										 
														<cfset row_tem_total_take2=row_tem_total_take2+evaluate("total_take_2_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#_#get_total_purchase.other_money#")>									 
														<cfif isDefined("attributes.is_money3")>
															<cfset "all_total_take_2_#securefund_cat_id#_#get_total_purchase.other_money#" = evaluate("all_total_take_2_#securefund_cat_id#_#get_total_purchase.other_money#") + evaluate("total_take_2_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#_#get_total_purchase.other_money#")>
														<cfelse>
															<cfset "all_total_take_2_#securefund_cat_id#" =evaluate("all_total_take_2_#securefund_cat_id#")+evaluate("total_take_2_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#_#get_total_purchase.other_money#")>
														</cfif>
													<cfelse>
														#TLFormat(0)#
													</cfif>
												</td>
											</cfif>
										<cfelse>
											<td align="right" style="text-align:right;" title="#title#">
												<cfif isdefined("total_take_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#")>
													#TLFormat(evaluate("total_take_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#"))#										 
													<cfset row_tem_total_take=row_tem_total_take+evaluate("total_take_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#")>									 
													<cfset "all_total_take_#securefund_cat_id#" =evaluate("all_total_take_#securefund_cat_id#")+evaluate("total_take_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#")>
												<cfelse>
													#TLFormat(0)#
												</cfif>
											</td>
											<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
												<td align="right" style="text-align:right;" title="#title#">
													<cfif isdefined("total_take_2_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#")>
														#TLFormat(evaluate("total_take_2_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#"))#										 
														<cfset row_tem_total_take2=row_tem_total_take2+evaluate("total_take_2_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#")>									 
														<cfif isDefined("attributes.is_money3")>
															<cfset "all_total_take_2_#securefund_cat_id#_#other_money#" = evaluate("all_total_take_2_#securefund_cat_id#_#other_money#") + evaluate("total_take_2_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#")>
														<cfelse>
															<cfset "all_total_take_2_#securefund_cat_id#" =evaluate("all_total_take_2_#securefund_cat_id#")+evaluate("total_take_2_#get_total_purchase.kontrol#_#securefund_cat_id#_#get_total_purchase.process_id#")>
														</cfif>
													<cfelse>
														#TLFormat(0)#
													</cfif>
												</td>
											</cfif>
										</cfif>
									</cfloop>
									<td align="right" style="text-align:right;" title="#title#">
										#TLFormat(row_tem_total_take)#
										<cfset alinan_teminat = alinan_teminat + row_tem_total_take> 
									</td>
									<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
										<td align="right" style="text-align:right;" title="#title#">
											#TLFormat(row_tem_total_take2)#
											<cfif isDefined("attributes.is_money3")>
												<cfset "alinan_teminat#other_money#" = evaluate("alinan_teminat#other_money#") + row_tem_total_take2>
											<cfelse>
												<cfset alinan_teminat2 = alinan_teminat2 + row_tem_total_take2> 
											</cfif>
										</td>
									</cfif>
								</cfif>
								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,6)>
								<cfset toplam_siparis = toplam_siparis + row_order>
								<td align="right" style="text-align:right;" title="#title#">#TLFormat(row_order)#</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" style="text-align:right;" title="#title#">#TLFormat(row_order2)#</td>
									<cfif isDefined("attributes.is_money3")>
										<cfset "toplam_siparis#other_money#" = evaluate("toplam_siparis#other_money#") + row_order2>
									<cfelse>
										<cfset toplam_siparis2 = toplam_siparis2 + row_order2>
									</cfif>
								</cfif>
								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,7)>
								<cfset toplam_irsaliye = toplam_irsaliye + row_ship>
								<td align="right" style="text-align:right;" title="#title#">#TLFormat(row_ship)#</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" style="text-align:right;" title="#title#">#TLFormat(row_ship2)#</td>
									<cfif isDefined("attributes.is_money3")>
										<cfset "toplam_irsaliye#other_money#" = evaluate("toplam_irsaliye#other_money#") + row_ship2>
									<cfelse>
										<cfset toplam_irsaliye2 = toplam_irsaliye2 + row_ship2>
									</cfif>
								</cfif>
								
							</cfif>
						</tr>
					</cfoutput>
					<cfoutput>
					<cfif len(attributes.report_dsp_type)>
					<tfoot>
						<tr>
							<cfif attributes.report_type eq 1>
								<td colspan="3" align="right" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'>:</td>
							<cfelse>
								<td colspan="2" align="right" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'>:</td>
							</cfif>
							
							<cfif isDefined("attributes.is_money3")>
								<td>
									<cfloop query="get_money">
										#money#<br/>
									</cfloop>
								</td>
								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,1)>
								<td align="right" style="text-align:right;">#TLFormat(ciro_toplam)#</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" style="text-align:right;">
										<cfif isDefined("attributes.is_money2")>
											#TLFormat(ciro_toplam_money2)#
										<cfelse>
											<cfloop query="get_money">
												<cfif isdefined("ciro_toplam_money#money#")>
													#tlformat(evaluate("ciro_toplam_money#money#"))#
												<cfelse>
													#tlformat(0)#
												</cfif>
												<br/>
											</cfloop>
										</cfif>
									</td>
								</cfif>
								<td align="right" style="text-align:right;"></td>
								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,2)>
								<td align="right" style="text-align:right;">#TLFormat(toplam_borc)#</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" style="text-align:right;">
										<cfif isDefined("attributes.is_money2")>
											#TLFormat(toplam_borc2)#
										<cfelse>
											<cfloop query="get_money">
												<cfif isdefined("toplam_borc#money#")>
													#tlformat(evaluate("toplam_borc#money#"))#
												<cfelse>
													#tlformat(0)#
												</cfif>
												<br/>
											</cfloop>
										</cfif>
									</td>
								</cfif>
								<td align="right" style="text-align:right;"><cfif toplam_borc neq 0>#dateformat(date_add('d',-1*(toplam_borc_vade/toplam_borc),now()),dateformat_style)#<cfelse>#dateformat(now(),dateformat_style)#</cfif></td>
								<td align="right" style="text-align:right;">#TLFormat(toplam_alacak)#</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" style="text-align:right;">
										<cfif isDefined("attributes.is_money2")>
											#TLFormat(toplam_alacak2)#
										<cfelse>
											<cfloop query="get_money">
												<cfif isdefined("toplam_alacak#money#")>
													#tlformat(evaluate("toplam_alacak#money#"))#
												<cfelse>
													#tlformat(0)#
												</cfif>
												<br/>
											</cfloop>
										</cfif>
									</td>
								</cfif>
								<td align="right" style="text-align:right;"><cfif toplam_alacak neq 0>#dateformat(date_add('d',-1*(toplam_alacak_vade/toplam_alacak),now()),dateformat_style)#<cfelse>#dateformat(now(),dateformat_style)#</cfif></td>
								<td align="right" nowrap="nowrap" style="text-align:right;">#TLFormat(acik_hesap_bakiye)#</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" nowrap="nowrap" style="text-align:right;">
										<cfif isDefined("attributes.is_money2")>
											#TLFormat(acik_hesap_bakiye_money2)#
										<cfelse>
											<cfloop query="get_money">
												<cfif isdefined("acik_hesap_bakiye_money#money#")>
													#tlformat(evaluate("acik_hesap_bakiye_money#money#"))#
												<cfelse>
													#tlformat(0)#
												</cfif>
												<br/>
											</cfloop>
										</cfif>
									</td>
								</cfif>
								<td align="right" style="text-align:right;">
									<cfif toplam_borc eq 0><cfset toplam_borc_date = 1><cfelse><cfset toplam_borc_date = toplam_borc></cfif>
									<cfif toplam_alacak eq 0><cfset toplam_alacak_date = 1><cfelse><cfset toplam_alacak_date = toplam_alacak></cfif>
									<cfif (abs(toplam_borc)+abs(toplam_alacak)) neq 0>
										#dateformat(date_add('d',(-1*(((toplam_borc_vade/toplam_borc_date) * abs(toplam_borc)) + ((toplam_alacak_vade/toplam_alacak_date) * abs(toplam_alacak)))/(abs(toplam_borc)+abs(toplam_alacak))),now()),dateformat_style)#
									<cfelse>
										#dateformat(date_add('d',(-1*(((toplam_borc_vade/toplam_borc_date) * abs(toplam_borc)) + ((toplam_alacak_vade/toplam_alacak_date) * abs(toplam_alacak)))/1),now()),dateformat_style)#
									</cfif>
								</td>
								<td></td>
								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,5)>
								<td align="right" style="text-align:right;">#TLFormat(kars_cek_senet)#</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" style="text-align:right;">
										<cfif isDefined("attributes.is_money2")>
											#TLFormat(kars_cek_senet2)#
										<cfelse>
											<cfloop query="get_money">
												<cfif isdefined("kars_cek_senet#money#")>
													#tlformat(evaluate("kars_cek_senet#money#"))#
												<cfelse>
													#tlformat(0)#
												</cfif>
												<br/>
											</cfloop>
										</cfif>
									</td>
								</cfif>
								<td align="right" style="text-align:right;">#TLFormat(odenmemis_cek_senet)#</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" style="text-align:right;">
										<cfif isDefined("attributes.is_money2")>
											#TLFormat(odenmemis_cek_senet2)#
										<cfelse>
											<cfloop query="get_money">
												<cfif isdefined("odenmemis_cek_senet#money#")>
													#tlformat(evaluate("odenmemis_cek_senet#money#"))#
												<cfelse>
													#tlformat(0)#
												</cfif>
												<br/>
											</cfloop>
										</cfif>
									</td>
								</cfif>
								<td align="right" style="text-align:right;">#TLFormat(risk_toplam)#</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" nowrap style="text-align:right;">
										<cfif isDefined("attributes.is_money2")>
											#TLFormat(risk_toplam2)#
										<cfelse>
											<cfloop query="get_money">
												<cfif isdefined("risk_toplam#money#")>
													#tlformat(evaluate("risk_toplam#money#"))#
												<cfelse>
													#tlformat(0)#
												</cfif>
												<br/>
											</cfloop>
										</cfif>
									</td>
								</cfif>
								<td></td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td></td>
								</cfif>
								<td align="right" nowrap="nowrap">#TLFormat(kullanilabilir_risk)#</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" nowrap="nowrap" style="text-align:right;">
										<cfif isDefined("attributes.is_money2")>
											#TLFormat(kullanilabilir_risk2)#
										<cfelse>
											<cfloop query="get_money">
												<cfif isdefined("kullanilabilir_risk#money#")>
													#tlformat(evaluate("kullanilabilir_risk#money#"))#
												<cfelse>
													#tlformat(0)#
												</cfif>
                                                <br />
											</cfloop>
										</cfif>
									</td>
								</cfif>
								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,3)>
								<td align="right" style="text-align:right;">#TLFormat(acik_hesap_limit)#</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" nowrap style="text-align:right;">
										<cfif isDefined("attributes.is_money2")>
											#TLFormat(acik_hesap_limit_money2)#
										<cfelse>
											<cfloop query="get_money">
												<cfif isdefined("acik_hesap_limit_money#money#")>
													#tlformat(evaluate("acik_hesap_limit_money#money#"))#
												<cfelse>
													#tlformat(0)#
												</cfif>
												<br/>
											</cfloop>
										</cfif>
									</td>
								</cfif>
								<td align="right" style="text-align:right;">#TLFormat(vadeli_limit)#</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>	
									<td align="right" nowrap style="text-align:right;">
										<cfif isDefined("attributes.is_money2")>
											#TLFormat(vadeli_limit_money2)#
										<cfelse>
											<cfloop query="get_money">
												<cfif isdefined("vadeli_limit_money#money#")>
													#tlformat(evaluate("vadeli_limit_money#money#"))#
												<cfelse>
													#tlformat(0)#
												</cfif>
												<br/>
											</cfloop>
										</cfif>
									</td>
								</cfif>
								<td align="right">#TLFormat(toplam_limit)#</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" nowrap>
										<cfif isDefined("attributes.is_money2")>
											#TLFormat(toplam_limit_money2)#
										<cfelse>
											<cfloop query="get_money">
												<cfif isdefined("toplam_limit_money#money#")>
													#tlformat(evaluate("toplam_limit_money#money#"))#
												<cfelse>
													#tlformat(0)#
												</cfif>
												<br/>
											</cfloop>
										</cfif>
									</td>
								</cfif>
								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,4)>
								<cfif not isdefined("attributes.is_tem_detail")>
									<td align="right" style="text-align:right;">#TLFormat(verilen_teminat)#</td>
									<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
										<td align="right" style="text-align:right;">
											<cfif isDefined("attributes.is_money2")>
												#TLFormat(verilen_teminat2)#
											<cfelse>
												<cfloop query="get_money">
													<cfif isdefined("verilen_teminat#money#")>
														#tlformat(evaluate("verilen_teminat#money#"))#
													<cfelse>
														#tlformat(0)#
													</cfif>
													<br/>
												</cfloop>
											</cfif>
										</td>
									</cfif>
									<td align="right" style="text-align:right;">#TLFormat(alinan_teminat)#</td>
									<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
										<td align="right" style="text-align:right;">
											<cfif isDefined("attributes.is_money2")>
												#TLFormat(alinan_teminat2)#
											<cfelse>
												<cfloop query="get_money">
													<cfif isdefined("alinan_teminat#money#")>
														#tlformat(evaluate("alinan_teminat#money#"))#
													<cfelse>
														#tlformat(0)#
													</cfif>
													<br/>
												</cfloop>
											</cfif>
										</td>
									</cfif>
								<cfelse>
									<cfloop query="get_sec_type">
										<td align="right" style="text-align:right;">
											<cfif isdefined("all_total_give_#securefund_cat_id#")>
												#TLFormat(evaluate("all_total_give_#securefund_cat_id#"))#	
											<cfelse>
												#TLFormat(0)#
											</cfif>
										</td>
										<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
											<td align="right" style="text-align:right;">
												<cfif isDefined("attributes.is_money2")>
													<cfif isdefined("all_total_give_2_#securefund_cat_id#")>
														#TLFormat(evaluate("all_total_give_2_#securefund_cat_id#"))#	
													<cfelse>
														#TLFormat(0)#
													</cfif>
												<cfelse>
													<cfloop query="get_money">
														<cfif isdefined("all_total_give_2_#get_sec_type.securefund_cat_id#_#money#")>
															#tlformat(evaluate("all_total_give_2_#get_sec_type.securefund_cat_id#_#money#"))#
														<cfelse>
															#tlformat(0)#
														</cfif>
														<br/>
													</cfloop>
												</cfif>
											</td>
										</cfif>
									</cfloop>
									<td align="right" style="text-align:right;">
										#TLFormat(verilen_teminat)#
									</td>
									
									<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
										<td align="right" style="text-align:right;">
											<cfif isDefined("attributes.is_money2")>
												#TLFormat(verilen_teminat2)#
											<cfelse>
												<cfloop query="get_money">
													<cfif isdefined("verilen_teminat#money#")>
														#tlformat(evaluate("verilen_teminat#money#"))#
													<cfelse>
														#tlformat(0)#
													</cfif>
													<br/>
												</cfloop>
											</cfif>
										</td>
									</cfif>
									
									<cfloop query="get_sec_type">
										<td align="right" style="text-align:right;">
											<cfif isDefined("attributes.is_money2")>
												<cfif isdefined("all_total_take_#securefund_cat_id#")>
													#TLFormat(evaluate("all_total_take_#securefund_cat_id#"))#	
												<cfelse>
													#TLFormat(0)#
												</cfif>
											</cfif>
										</td>
										<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
											<td align="right" style="text-align:right;">
												<cfif isDefined("attributes.is_money2")>
													<cfif isdefined("all_total_take_2_#securefund_cat_id#")>
														#TLFormat(evaluate("all_total_take_2_#securefund_cat_id#"))#	
													<cfelse>
														#TLFormat(0)#
													</cfif>
												<cfelse>
													<cfloop query="get_money">
														<cfif isdefined("all_total_take_2_#get_sec_type.securefund_cat_id#_#money#")>
															#tlformat(evaluate("all_total_take_2_#get_sec_type.securefund_cat_id#_#money#"))#
														<cfelse>
															#tlformat(0)#
														</cfif>
														<br/>
													</cfloop>
												</cfif>
											</td>
										</cfif>
									</cfloop>
									<td align="right" style="text-align:right;">
										#TLFormat(alinan_teminat)#
									</td>
									<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
										<td align="right" style="text-align:right;">
											<cfif isDefined("attributes.is_money2")>
												#TLFormat(alinan_teminat2)#
											<cfelse>
												<cfloop query="get_money">
													<cfif isdefined("alinan_teminat#money#")>
														#tlformat(evaluate("alinan_teminat#money#"))#
													<cfelse>
														#tlformat(0)#
													</cfif>
													<br/>
												</cfloop>
											</cfif>
										</td>
									</cfif>								
								</cfif>
								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,6)>
								<td align="right" style="text-align:right;">#TLFormat(toplam_siparis)#</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" nowrap style="text-align:right;">
										<cfif isDefined("attributes.is_money2")>
											#TLFormat(toplam_siparis2)#
										<cfelse>
											<cfloop query="get_money">
												<cfif isdefined("toplam_siparis#money#")>
													#tlformat(evaluate("toplam_siparis#money#"))#
												<cfelse>
													#tlformat(0)#
												</cfif>
												<br/>
											</cfloop>
										</cfif>
									</td>
								</cfif>								
								
							</cfif>
							<cfif listfind(attributes.report_dsp_type,7)>
								<td align="right">#TLFormat(toplam_irsaliye)#</td>
								<cfif isDefined("attributes.is_money2") or isDefined("attributes.is_money3")>
									<td align="right" style="text-align:right;">
										<cfif isDefined("attributes.is_money2")>
											#TLFormat(toplam_irsaliye2)#
										<cfelse>
											<cfloop query="get_money">
												<cfif isdefined("toplam_irsaliye#money#")>
													#tlformat(evaluate("toplam_irsaliye#money#"))#
												<cfelse>
													#tlformat(0)#
												</cfif>
												<br/>
											</cfloop>
										</cfif>
									</td>
								</cfif>								
								
							</cfif>
						</tr>
                    </tfoot>
					</cfif>
					</cfoutput>
                    <cfelse>
                    	<tr>    
							<td colspan="23"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
                        </tr>
					</cfif>
				</tbody>
            </cf_report_list>
			<cfset adres = "">
			<cfif isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.maxrows>
				<cfset adres = "report.risc_analys&form_submitted=1">	
				<cfif len(attributes.report_sort)>
					<cfset adres = "#adres#&report_sort=#attributes.report_sort#">
				</cfif>
				<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
					<cfset adres = "#adres#&company_id=#attributes.company_id#&company=#attributes.company#">
				</cfif>
				<cfif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
					<cfset adres = "#adres#&consumer_id=#attributes.consumer_id#&company=#attributes.company#">
				</cfif>
				<cfif len(attributes.pos_code)>
					<cfset adres = "#adres#&pos_code=#attributes.pos_code#&pos_code_text=#attributes.pos_code_text#">
				</cfif>
				<cfif len(attributes.date1)>
					<cfset adres = "#adres#&date1=#dateformat(attributes.date1,dateformat_style)#">
				</cfif>
				<cfif len(attributes.date2)>
					<cfset adres = "#adres#&date2=#dateformat(attributes.date2,dateformat_style)#">
				</cfif>
				<cfif len(attributes.report_type)>
					<cfset adres = "#adres#&report_type=#attributes.report_type#">
				</cfif>
				<cfif len(attributes.zone_id)>
					<cfset adres = "#adres#&zone_id=#attributes.zone_id#">
				</cfif>
				<cfif len(attributes.resource_id)>
					<cfset adres = "#adres#&resource_id=#attributes.resource_id#">
				</cfif>
				<cfif len(attributes.ims_code_id)>
					<cfset adres = "#adres#&ims_code_id=#attributes.ims_code_id#">
				</cfif>
				<cfif len(attributes.customer_value_id)>
					<cfset adres = "#adres#&customer_value_id=#attributes.customer_value_id#">
				</cfif>
				<cfif isDefined("attributes.member_cat_type") and len(attributes.member_cat_type)>
					<cfset adres = "#adres#&member_cat_type=#attributes.member_cat_type#">
				</cfif>
				<cfif isdefined('attributes.member_cat_value') and len(attributes.member_cat_value)>
					<cfset adres=adres&"&member_cat_value=#attributes.member_cat_value#">
				</cfif>
				<cfif isDefined("attributes.report_dsp_type") and len(attributes.report_dsp_type)>
					<cfset adres = "#adres#&report_dsp_type=#attributes.report_dsp_type#">
				</cfif>
				<cfif isDefined("attributes.is_money2")>
					<cfset adres = "#adres#&is_money2=#attributes.is_money2#">
				</cfif>
				<cfif isDefined("attributes.is_money3")>
					<cfset adres = "#adres#&is_money3=#attributes.is_money3#">
				</cfif>
				<cfif isDefined("attributes.is_tem_detail")>
					<cfset adres = "#adres#&is_tem_detail=#attributes.is_tem_detail#">
				</cfif>
				<cfif isDefined("attributes.is_all_member")>
					<cfset adres = "#adres#&is_all_member=#attributes.is_all_member#">
				</cfif>
				<cfif isDefined("attributes.member_status")>
					<cfset adres = "#adres#&member_status=#attributes.member_status#">
				</cfif>
				<cf_paging
						page="#attributes.page#" 
						maxrows="#attributes.maxrows#"
						totalrecords="#attributes.totalrecords#"
						startrow="#attributes.startrow#"
						adres="#adres#">
					
			</cfif>
	</cfif>
<script type="text/javascript">
	function kontrol_form()
	{
		if ((document.rapor.date1.value != '') && (document.rapor.date2.value != '') &&
	    !date_check(rapor.date1,rapor.date2,"<cf_get_lang dictionary_id='31924.Başlangıç tarihi bitiş tarihinden küçük olmalıdır'>!"))
	         return false;
		if(document.rapor.company.value != "")
		{
			if (document.rapor.company_id.value != '')
				document.rapor.member_cat_value.value=1;
			else if (document.rapor.consumer_id.value != '')
				document.rapor.member_cat_value.value=2;
		}

		if(document.rapor.is_excel.checked==false)
			{
				document.rapor.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.risc_analys"
				return true;
			}
			else
				document.rapor.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_risc_analys</cfoutput>"

	}
	function kontrol_money(type)
	{
		if(type == 1)
		{
			if(document.rapor.is_money2.checked)
				document.rapor.is_money3.checked = false;
		}
		else
		{
			if(document.rapor.is_money3.checked)
				document.rapor.is_money2.checked = false;
		}
	}
</script>