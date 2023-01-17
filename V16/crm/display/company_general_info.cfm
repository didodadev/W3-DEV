<cfsetting showdebugoutput="no">
<cfquery name="GET_MONEY_RATE" datasource="#DSN#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT CITY_ID, CITY_NAME,PHONE_CODE,COUNTRY_ID FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
<cfquery name="GET_COUNTRY" datasource="#DSN#">
	SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY ORDER BY COUNTRY_ID
</cfquery>
<cfquery name="GET_CUSTS" datasource="#DSN#">
	SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT WHERE COMPANYCAT_TYPE = 0
</cfquery>
<cfquery name="GET_COMP" datasource="#DSN#">
	SELECT * FROM COMPANY WHERE COMPANY_ID = #attributes.cpid#
</cfquery>
<cfquery name="GET_COMP_PARTNER" datasource="#DSN#">
	SELECT 
		COMPANY_PARTNER.PARTNER_ID,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME, 
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME 
	FROM 
		COMPANY_PARTNER, 
		COMPANY 
	WHERE 
		COMPANY.COMPANY_ID = #attributes.cpid# AND 
		COMPANY.MANAGER_PARTNER_ID = COMPANY_PARTNER.PARTNER_ID
</cfquery>
<cfquery name="GET_INFO" datasource="#DSN#">
	SELECT 
		ENDORSE_PERIOD, 
		ENDORSE_PAYMENT, 
		ENDORSE_CURRENCY
	FROM 
		COMPANY 
	WHERE 
		COMPANY_ID = #attributes.cpid#
</cfquery>
<cfquery name="GET_RELATED" datasource="#DSN#">
	SELECT TOTAL_POSTPONE,DEPO_STATUS FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND COMPANY_ID = #attributes.cpid#
</cfquery>
<cfset totalvaluex = 0>
<cfloop query="get_related">
	<cfif len(total_postpone)>
		<cfset totalvaluex = totalvaluex + total_postpone>
	</cfif>
</cfloop>
<cfif not GET_COMP.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='54931.Girmiş Olduğunuz Hedef Kodu İçin Müşteri Bulunamadı'>");
		history.back();
	</script>
</cfif>
<cfinclude template="../query/get_sales_zones.cfm">
<cfsavecontent variable="title"><cf_get_lang_main no='568.Genel Bilgiler'></cfsavecontent>
<cf_box title="#title#">
    <cfform name="form_add_company" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_general_info">
		<input type="hidden" name="frame_fuseaction" id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)><cfoutput>#attributes.frame_fuseaction#</cfoutput></cfif>">
		<!--- Kontroller icin surec eklenmesi gerekiyor, kaldirmayin fbs --->
		<div style="display:none;"><cf_workcube_process is_upd='0' select_value="#GET_RELATED.DEPO_STATUS#" process_cat_width='150' is_detail='1'></div>
		<cf_box_elements vertical="1">
			<cfoutput>
				<input type="hidden" name="cpid" id="cpid" value="#attributes.cpid#">
				<input type="hidden" name="company_partner_id" id="company_partner_id" value="#get_comp_partner.partner_id#">
				<input type="hidden" name="old_taxnum" id="old_taxnum" value="#get_comp.taxno#">
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<div class="form-group">
						<label><cf_get_lang_main no='338.İşyeri Adı'>*</label>
						<cfsavecontent variable="message"><cf_get_lang no='34.İş Yeri Adı Girmelisiniz'> !</cfsavecontent>
						<cfinput required="Yes" message="#message#" type="text" name="fullname" style="width:410px;" maxlength="75" value="#get_comp.fullname#" tabindex="1">
					</div>
					<div class="form-group">
						<label><cf_get_lang_main no='74.Kategori'>*</label>
						<select name="companycat_id" id="companycat_id" style="width:140px;" tabindex="2">
							<cfloop query="get_custs">
								<option value="#companycat_id#" <cfif companycat_id eq get_comp.companycat_id>selected</cfif>>#companycat#</option>
							</cfloop>
						</select>
					</div>
					<div class="form-group">
						<label><cf_get_lang no='663.Şirket Tipi'>*</label>
						<select name="company_work_type" id="company_work_type" style="width:150px;" tabindex="4">
							<option value="1" <cfif get_comp.company_work_type eq 1>selected</cfif>><cf_get_lang no='664.Gerçek'></option>
							<option value="2" <cfif get_comp.company_work_type eq 2>selected</cfif>><cf_get_lang no='665.Tüzel'></option>
						</select>
					</div>
					<div class="form-group">
						<label><cf_get_lang_main no='780.Müşteri Adı'>*</label>
						
						<cfsavecontent variable="message"><cf_get_lang no='67.Müşteri Adı Girmelisiniz !'></cfsavecontent>
						<cfinput type="text" name="company_partner_name" style="width:140px;" maxlength="20" required="yes" message="#message#" value="#get_comp_partner.company_partner_name#" tabindex="3">
					</div>
					
					<div class="form-group">
						<label><cf_get_lang no='37.Müşteri Soyadı'> *</label>
						<cfsavecontent variable="message"><cf_get_lang no='55.Müşteri Soyadı Girmelisiniz !'></cfsavecontent>
						<cfinput type="text" name="company_partner_surname" style="width:140px;" maxlength="20" required="yes" message="#message#" value="#get_comp_partner.company_partner_surname#" tabindex="5">
						
					</div>
					<div class="form-group">
						<label><cf_get_lang_main no='613.TC Kimlik No'>/<cf_get_lang_main no='340.Vergi No'> *</label>
						<input type="text" name="tax_num" id="tax_num" value="#get_comp.taxno#" onkeyup="isNumber(this);" onblur='isNumber(this);' maxlength="11" style="width:140px;" tabindex="9">
					</div>
					<div class="form-group">
						<label><cf_get_lang_main no='1350.Vergi Dairesi'> *</label>
						<cfsavecontent variable="message"><cf_get_lang no='56.Vergi Dairesi Girmelisiniz !'></cfsavecontent>
						<cfinput type="text" name="tax_office" style="width:140px;" maxlength="30" required="yes" message="#message#" value="#get_comp.taxoffice#" tabindex="7">
						
					</div>
					<div class="form-group">
						<label><span class="cursor-pointer" onClick="mail_control();"><i class="fa fa-plus"></i></span><cf_get_lang_main no='16.e-mail'></label>
						<cfinput type="text" name="email" style="width:140px;" maxlength="50" value="#get_comp.company_email#" tabindex="20">
					</div>
					<div class="form-group">						
						<label><input type="checkbox" name="ekstre" id="ekstre" value="1" <cfif get_comp.ekstre eq 1>checked</cfif>><cf_get_lang no='750.E-Ekstre'></label>
					</div>
					<div class="form-group">
						<label><cf_get_lang_main no='1173.Kod'>/<cf_get_lang_main no='87.Telefon'> *</label>
						<div class="col col-3 pl-0">
							<cfsavecontent variable="message"><cf_get_lang no='58.Telefon No Girmelisiniz'> !</cfsavecontent>
							<input type="text" name="telcod" id="telcod" value="#get_comp.company_telcode#" style="width:50px;" readonly="yes">
						</div>
						<div class="col col-9 pr-0">
							<cfinput validate="integer" maxlength="7" required="yes" message="#message#" type="text" name="tel1" style="width:87px;" value="#get_comp.company_tel1#" tabindex="11">
						</div>
					</div>					
					<div class="form-group">
						<label><cf_get_lang_main no='87.Tel'> 2</label>						
						<cfinput validate="integer" maxlength="7" message="#message#" type="text" name="tel2" style="width:87px;" value="#get_comp.company_tel2#" tabindex="13">
					</div>					
					<div class="form-group">
						<label><cf_get_lang_main no='87.Tel'> 3</label>						
						<cfinput validate="integer" maxlength="7"  message="#message#" type="text" name="tel3" style="width:87px;" value="#get_comp.company_tel3#" tabindex="15">
					</div>
					<div class="form-group">
						<label><cf_get_lang_main no='1173.Kod'>/<cf_get_lang_main no='76.Fax'></label>
						<div class="col col-3 pl-0">
							<cfsavecontent variable="message"><cf_get_lang no='193.Fax Girmelisiniz !'> !</cfsavecontent>
							<input type="text" name="faxcode" id="faxcode" value="#get_comp.company_fax_code#" readonly="yes" maxlength="5" style="width:50px;" >
						</div>
						<div class="col col-9 pr-0">
							<cfinput validate="integer" message="#message#" maxlength="7" type="text" name="fax" style="width:86px;" value="#get_comp.company_fax#" tabindex="17">
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">				
					<div class="form-group">
						<label><cf_get_lang_main no='807.Ülke'> *</label>					
						<cfif len(get_comp.country)>
							<cfquery name="GET_COUNTRY" datasource="#DSN#">
								SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #get_comp.country#
							</cfquery>
							<input name="country" id="country" value="#get_country.country_name#" readonly style="width:150px;" tabindex="23" type="text">
							<input name="country_id" id="country_id" type="hidden" value="#get_comp.country#">
						<cfelse>
							<input name="country" id="country" style="width:150px;" value="" readonly type="text">
							<input name="country_id" id="country_id" type="hidden" value="">
						</cfif>						
					</div>
					<div class="form-group">
						<label><cf_get_lang_main no='722.IMS Bölge Kodu'>*</label>
						<div class="input-group">
							<cfif len(get_comp.ims_code_id)>
								<cfquery name="GET_IMS_CODE" datasource="#dsn#">
									SELECT IMS_CODE, IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = #get_comp.ims_code_id#
								</cfquery>
								<input type="hidden" name="old_ims_code" id="old_ims_code" value="#get_comp.ims_code_id#">
								<input type="hidden" name="ims_code_id" id="ims_code_id" value="#get_comp.ims_code_id#">
								<cfsavecontent variable="message"><cf_get_lang no='68.IMS Bölge Kodu Giriniz !'></cfsavecontent>
								<cfinput type="text" name="ims_code_name" style="width:150px;" readonly="yes" required="yes" message="#message#" value="#GET_ims_code.ims_code# #GET_ims_code.ims_code_name#" tabindex="4">
							<cfelse>
								<input type="hidden" name="old_ims_code" id="old_ims_code" value="">
								<input type="hidden" name="ims_code_id" id="ims_code_id" value="">
								<cfsavecontent variable="message"><cf_get_lang no='68.IMS Bölge Kodu Giriniz !'></cfsavecontent>
								<cfinput type="text" name="ims_code_name" style="width:150px;" readonly="yes" required="yes" message="#message#" value="">
							</cfif>
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_ims_code&field_name=form_add_company.ims_code_name&field_id=form_add_company.ims_code_id','list');return false" tabindex="4"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='722.IMS Bölge Kodu'>" border="0" align="absmiddle"></span>
						</div>
					</div>
					<div class="form-group">
						<label><cf_get_lang_main no='1196.İl'> *</label>
						<input type="hidden" name="old_city" id="old_city" value="#get_comp.city#">
						<select name="city" id="city" onChange="get_phone_code()" style="width:150px;" tabindex="21">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfloop query="get_city">
								<option value="#city_id#" <cfif city_id eq get_comp.city>selected</cfif>>#city_name#</option>
							</cfloop>
						</select>						
					</div>
					<div class="form-group">
						<label><cf_get_lang_main no='1226.İlçe'> *</label>
						<div class="input-group">
							<cfif len(get_comp.county)>
								<cfquery name="GET_ILCE" datasource="#dsn#">
									SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_comp.county#
								</cfquery>
								<input type="hidden" name="county_id" id="county_id" readonly="" value="#get_comp.county#">
								<cfsavecontent variable="message"><cf_get_lang no='65.ilçe Girmelisiniz !'></cfsavecontent>
								<cfinput type="text" name="county" value="#get_ilce.county_name#" maxlength="30" style="width:150px;" required="yes" message="#message#" readonly="yes" tabindex="18">
							<cfelse>
								<input type="hidden" name="county_id" id="county_id" readonly="" value="">
								<cfsavecontent variable="message"><cf_get_lang no='65.ilçe Girmelisiniz !'></cfsavecontent>
								<cfinput type="text" name="county" value="" maxlength="30" style="width:150px;" required="yes" message="#message#" readonly="yes">
							</cfif>
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_ac();"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='1226.İlçe'>" border="0" align="absmiddle" tabindex="19"></span>
						</div>
					</div>
					<div class="form-group">
						<label><cf_get_lang_main no='720.Semt'> *</label>						
						<cfsavecontent variable="message"><cf_get_lang no='64.semt Girmelisiniz !'></cfsavecontent>
						<cfinput type="text" name="semt" maxlength="30" style="width:150px;" required="yes" message="#message#" value="#get_comp.semt#" tabindex="16">
					</div>
					<div class="form-group">
						<label><cf_get_lang no='45.Cadde '> *</label>
						<cfsavecontent variable="message"><cf_get_lang no='61.Cadde Giriniz !!'> !</cfsavecontent>
						<cfinput type="text" name="main_street" style="width:150px;" maxlength="50" required="yes" message="#message#" value="#get_comp.main_street#" tabindex="8">						
					</div>
					<div class="form-group">
						<label><cf_get_lang_main no='1323.Mahalle'>*</label>					
						<cfsavecontent variable="message"><cf_get_lang no='60.Mahalle Girmelisiniz !'> !</cfsavecontent>
						<cfinput type="text" name="district" style="width:150px;" maxlength="50" required="yes" message="#message#" value="#get_comp.district#" tabindex="6">
					</div>
					<div class="form-group">
						<label><cf_get_lang no='46.Sokak'> *</label>
						<cfsavecontent variable="message"><cf_get_lang no='62.Lütfen Sokak Giriniz !'> !</cfsavecontent>
						<cfinput type="text" name="street" style="width:150px;" maxlength="50" required="yes" message="#message#" value="#get_comp.street#" tabindex="10">
					</div>
					<div class="form-group">
						<label><cf_get_lang_main no='75.No'> *</label>
						<cfsavecontent variable="message"><cf_get_lang no='781.Lütfen No Giriniz'> !</cfsavecontent>
						<cfinput type="text" name="dukkan_no" style="width:150px;" required="yes" message="#message#" maxlength="50" value="#get_comp.dukkan_no#" tabindex="12">						
					</div>
					<div class="form-group">
						<label><cf_get_lang_main no='60.Posta Kodu'></label>
						<input type="text" name="post_code" id="post_code" style="width:150px;" maxlength="5" value="<cfif len(get_comp.COMPANY_POSTCODE)>#get_comp.COMPANY_POSTCODE#</cfif>" tabindex="14">
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<div class="form-group">
						<label><span class="cursor-pointer" onClick="total_control('risk_limit');"><i class="fa fa-plus"></i></span><cf_get_lang no='331.Grup Risk Limiti'></label>
						<cfsavecontent variable="message"><cf_get_lang no='486.Grup Risk Limitini Kontrol Ediniz'> !</cfsavecontent>
						<div class="input-group">
							<cfinput type="text" name="group_risk_limit" message="#message#" validate="float" range="0,100" style="width:85px;" value="#tlformat(get_comp.grup_risk_limit)#" class="moneybox" onkeyup="return(FormatCurrency(this,event));">
							<span class="input-group-addon width">
								<select name="money_cat_expense" id="money_cat_expense" style="width:52px;">
									<cfloop query="get_money_rate">
										<option value="#money#" <cfif get_comp.money_currency eq money>selected</cfif>>#money#</option>
									</cfloop>
								</select>
							</span>
						</div>
					</div>
					<div class="form-group">
						<label>
							<span class="cursor-pointer" onClick="total_control('guess_endor');"><i class="fa fa-plus"></i></span><cf_get_lang no='151.Tahmini Ciro'>	
						</label>
						<cfsavecontent variable="message"><cf_get_lang no='487.Tahmini Ciro Değerini Kontrol Ediniz'> !</cfsavecontent>	
						<div class="input-group">
							<cfinput type="text" name="guess_endorsement" message="#message#" validate="float" style="width:85px;" value="#tlformat(get_comp.guess_endorsement)#" class="moneybox" onkeyup="return(FormatCurrency(this,event));">
							<span class="input-group-addon width">
								<select name="guess_endorsement_money" id="guess_endorsement_money" style="width:52px;">
									<cfloop query="get_money_rate">
										<option value="#money#" <cfif get_comp.guess_endorsement_money eq money>selected</cfif>>#money#</option>
									</cfloop>
								</select>
							</span>
						</div>
					</div>
					<div class="form-group">
						<label><cf_get_lang_main no='667.İnternet'></label>
						<input type="text" name="homepage" id="homepage" style="width:150px;" maxlength="50" value="#get_comp.homepage#" tabindex="22">
					</div>
					<div class="form-group">
						<label><cf_get_lang dictionary_id='30725.GLN Kodu'></label>
						<input type="text" name="glncode" id="glncode" style="width:150px;" maxlength="13" value="#get_comp.glncode#" tabindex="23" onkeyup="isNumber(this);">
					</div>
					<div class="form-group">
						<label class="bold"><cf_get_lang no='52.Grup Kodu'>: <cfoutput>#get_comp.member_code#</cfoutput></label>
					</div>
					<div class="form-group">
						<label class="bold"><cf_get_lang no='53.Açılış Tarihi'>: <cfoutput>#dateformat(get_comp.con_open_date,dateformat_style)# #timeformat(get_comp.con_open_date,timeformat_style)#</cfoutput></label>
					</div>
					<div class="form-group">     
						<label class="bold"><cf_get_lang no='54.Kapanış Tarihi'>:<cfif len(get_comp.record_emp)>: <cfoutput>#timeformat(get_comp.con_close_date,timeformat_style)#</cfoutput><br/></cfif></label>					
					</div>
					<div class="form-group">     
						<label class="bold"><cf_get_lang no='660.Erteleme Sayısı'>: <cfoutput>#totalvaluex#</cfoutput></label>					 
					</div>
				</div>
			</cfoutput>
		</cf_box_elements>
		<div class="col col-12 ui-info-bottom">
			<cftry>	
				<cfquery name="GET_FINANCE_INFO" datasource="hedef_crm">
					SELECT 
						SUM(RISK_TOPLAM) AS COMPANY_RISK_TOPLAM,
						SUM(RISK_LIMIT) AS COMPANY_RISK_LIMIT
					FROM 
						HEDEF.HEDEF_MUSTERI_DURUM 
					WHERE 
						HEDEFKODU = #attributes.cpid# AND 
						TO_CHAR(AKTARIM_TARIH,'yyyy-mm-dd') = '#dateformat(now(),'yyyy-mm-dd')#' 
					ORDER BY 
						AKTARIM_TARIH DESC
				</cfquery>
				<cfoutput>
				<div class="form-group col col-3">
					<label><span class="bold"><cf_get_lang_main no='460.Toplam Risk'>:</span>
					 <cfoutput>#tlformat(get_finance_info.company_risk_toplam)# #session.ep.money#</cfoutput>
					</label>
				</div>
				<div class="form-group col col-3">
					<label><span class="bold"><cf_get_lang no='151.Tahmini Ciro'>:</span>
					 
						<cfif get_info.endorse_period eq 1><cf_get_lang_main no='1520.Aylık'></cfif>
						<cfif get_info.endorse_period eq 2>2 <cf_get_lang_main no='1520.Aylık'></cfif>
						<cfif get_info.endorse_period eq 3>3 <cf_get_lang_main no='1520.Aylık'></cfif>
						<cfif get_info.endorse_period eq 4>4 <cf_get_lang_main no='1520.Aylık'></cfif>
						<cfif get_info.endorse_period eq 5>6 <cf_get_lang_main no='1520.Aylık'></cfif>
						<cfif get_info.endorse_period eq 6><cf_get_lang_main no='1603.Yıllık'><cfelse>-</cfif>
						<cfif len(get_info.endorse_payment)>/ #tlformat(get_info.endorse_payment)# #get_info.endorse_currency#</cfif>
					</label>
					
				</div>
				<div class="form-group col col-3">
					<label><span class="bold"><cf_get_lang no='135. Risk Limiti'>:</span>  #tlformat(get_finance_info.company_risk_limit)# #session.ep.money#</label>
					
				</div>
				</cfoutput>
				<cfcatch>
					<div class="form-group">
					<cf_get_lang no='568.Oracle DB sinden Data Çekildiği İçin Production Ortamında Hata Verebilir'> !
					</div>
				</cfcatch>
			</cftry>
		</div>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cf_box_footer>
				<cf_record_info query_name="get_comp">
				<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
			</cf_box_footer>
		</div>
   </cfform>
   <cfoutput>#dateformat(get_comp.con_close_date,dateformat_style)#</cfoutput>
</cf_box>
<script type="text/javascript">
function pencere_ac(no)
{
	x = document.form_add_company.city.selectedIndex;
	if (document.form_add_company.city[x].value == "")
		alert("<cf_get_lang no='283.İlk Olarak İl Seçiniz'>");
	else
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=form_add_company.county_id&field_name=form_add_company.county&city_id=' + document.form_add_company.city.value,'small');
}
phone_code_list = new Array(<cfoutput>#valuelist(get_city.phone_code)#</cfoutput>);
country_list = new Array(<cfoutput><cfloop query=get_country>"#get_country.country_name#"<cfif not currentrow eq recordcount>,</cfif></cfloop></cfoutput>);
country_ids = new Array(<cfoutput>#valuelist(get_city.country_id)#</cfoutput>);
function get_phone_code()
{	
	document.form_add_company.county_id.value = '';
	document.form_add_company.county.value = '';
	if(document.form_add_company.city.selectedIndex>0)
	{
		document.form_add_company.telcod.value = phone_code_list[document.form_add_company.city.selectedIndex-1];
		document.form_add_company.faxcode.value = phone_code_list[document.form_add_company.city.selectedIndex-1];
		document.form_add_company.country.value = country_list[country_ids[document.form_add_company.city.selectedIndex-1]-1];
		document.form_add_company.country_id.value = country_ids[document.form_add_company.city.selectedIndex-1];
	}
	else
	{
		document.form_add_company.telcod.value = '';
		document.form_add_company.faxcode.value = '';
	}
}

function kontrol()
{
	//Bu hedefe özgü eklendi. Müşteri Tipi Eczane şeçili ise Şirket Tipi Gerçek olmalı.
	x = document.form_add_company.companycat_id.selectedIndex;
	if (document.form_add_company.companycat_id[x].value == 4)
	{
		y =  document.form_add_company.company_work_type.selectedIndex;
		if (document.form_add_company.company_work_type[y].value != 1 )
		{
			alert("<cf_get_lang no='485.Müşteri Tipi Eczane Olan Kayıtların Şirket Tipi Gerçek Olmalıdır'> !");
			return false;
		}
	}
	x = document.form_add_company.company_work_type.selectedIndex;
	if(document.form_add_company.company_work_type[x].value == 1)
	{
		if(document.form_add_company.old_taxnum.value != document.form_add_company.tax_num.value)
		{
			if(document.form_add_company.tax_num.value.length != 11)
			{
				alert("<cf_get_lang no='489.Vergi Numarası 11 Hane Olmalıdır'> !");
				return false;
			}
		}
	}
	else
	{
		if(document.form_add_company.tax_num.value.length != 10)
		{
			alert("<cf_get_lang no='490.Vergi Numarası 10 Hane Olmalıdır'> !");
			return false;
		}
	}
	if(document.form_add_company.glncode.value != '' && document.form_add_company.glncode.value.length != 13)
	{
		alert("<cf_get_lang dictionary_id='30293.GLN Kod Alanı 13 Hane Olmalıdır'>");
		document.form_add_company.glncode.focus();
		return false;
	}

	form_add_company.group_risk_limit.value = filterNum(form_add_company.group_risk_limit.value);
	form_add_company.guess_endorsement.value = filterNum(form_add_company.guess_endorsement.value);
	
	return process_cat_control();
}

function mail_control(email_value)
{
	if (document.form_add_company.email.value == "")
	{
		alert("<cf_get_lang no='492.Mail Adresi Girmelisiniz'> !");
		return false;
	}
	
	var email = document.form_add_company.email.value;	
	var main_host = "";
	var host = "";		 
	var host2 = "";		 
	var username = "";
	var mail_error = "";
	
	if(email.indexOf(" ") != -1)
		mail_error = 1;

	if(mail_error == "")
	{
		if(email.indexOf("@") != -1)
			username = email.substring(0,email.indexOf("@"));
		
		if(email.indexOf("@") != -1)
			main_host = email.substring(email.indexOf("@") + 1,email.length);
		
		if(main_host.indexOf(".") != -1)
			host = main_host.substring(0,main_host.indexOf("."));
		
		if(main_host.indexOf(".") != -1)
			host2 = main_host.substring(main_host.indexOf(".") + 1,main_host.length);
	}
	
	if((username == "") || (host == "") || (host2 == "") || (mail_error != ""))
	{
		alert("<cf_get_lang no='484.Mail Adresini Kontrol Ediniz'> !");
		return false;
	}
	else
	{
		document.form_add_company.action="<cfoutput>#request.self#?fuseaction=crm.emptypopup_upd_general_info_mail</cfoutput>";
		document.form_add_company.submit();
	}
}

function total_control(deger)
{
	if(deger == 'risk_limit')
	{
		form_add_company.group_risk_limit.value = filterNum(form_add_company.group_risk_limit.value);
	}
	if(deger == 'guess_endor')
	{
		form_add_company.guess_endorsement.value = filterNum(form_add_company.guess_endorsement.value);
	}
		
	document.form_add_company.action="<cfoutput>#request.self#?fuseaction=crm.emptypopup_upd_general_info_moneys&deger=</cfoutput>"+ deger;
	document.form_add_company.submit();
}
</script>
