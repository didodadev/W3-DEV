<cfif not isnumeric(attributes.cpid)>
	<cfset hata  = 10>
	<cfinclude template="../../dsp_hata.cfm">
	<cfabort>
</cfif>
<cfquery name="GET_CONTROL1" datasource="#DSN#">
	SELECT COMPANY_ID FROM COMPANY WHERE COMPANY_ID = #attributes.cpid#
</cfquery>
<cfif (get_control1.recordcount eq 0)>
	<cfset hata  = 10>
	<cfinclude template="../../dsp_hata.cfm">
	<cfabort>
</cfif>
<cfquery name="GET_KONTROL" datasource="#DSN#">
	SELECT BRANCH_ID FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND COMPANY_ID = #attributes.cpid#
</cfquery>
<cfif get_kontrol.recordcount gt 2>
  <cflocation url="#request.self#?fuseaction=crm.detail_company&cpid=#attributes.cpid#" addtoken="no">
</cfif>
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID, PLATE_CODE FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
<cfquery name="GET_UNIVERSTY" datasource="#DSN#">
	SELECT UNIVERSITY_ID, UNIVERSITY_NAME FROM SETUP_UNIVERSITY ORDER BY UNIVERSITY_NAME
</cfquery>
<cfquery name="GET_CUSTS" datasource="#DSN#">
	SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT WHERE COMPANYCAT_TYPE = 0 ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_COUNTRY" datasource="#DSN#">
	SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY ORDER BY COUNTRY_ID
</cfquery>
<cfquery name="GET_RESOURCE" datasource="#DSN#">
	SELECT RESOURCE_ID,RESOURCE FROM COMPANY_PARTNER_RESOURCE
</cfquery>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = #listgetat(session.ep.user_location,2, '-')#
</cfquery>
<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT 
		COMPANY.COMPANY_ID,
		COMPANY.FULLNAME,
		COMPANY.COMPANYCAT_ID,
		COMPANY.TAXNO,
		COMPANY.TAXOFFICE,
		COMPANY.DISTRICT,
		COMPANY.CITY,
		COMPANY.COMPANY_TELCODE,
		COMPANY.MAIN_STREET,
		COMPANY.COUNTY,
		COMPANY.COMPANY_TEL2,
		COMPANY.STREET,
		COMPANY.SEMT,
		COMPANY.COMPANY_TEL3,
		COMPANY.DUKKAN_NO,
		COMPANY.COUNTRY,
		COMPANY.COMPANY_FAX_CODE,
		COMPANY.COMPANY_FAX,
		COMPANY.COMPANY_POSTCODE,
		COMPANY.COMPANY_EMAIL,
		COMPANY.HOMEPAGE,
		COMPANY.ISPOTANTIAL,
		COMPANY.RECORD_EMP,
		COMPANY.RECORD_DATE,
		COMPANY.UPDATE_EMP,
		COMPANY.UPDATE_DATE,
		COMPANY.IMS_CODE_ID,
		COMPANY.MANAGER_PARTNER_ID,
		COMPANY.COMPANY_TEL1,
		COMPANY.COMPANY_WORK_TYPE,
		COMPANY.GLNCODE,
		COMPANY_PARTNER.PARTNER_ID, 
		COMPANY_PARTNER.COMPANY_PARTNER_NAME, 
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY_PARTNER.MOBIL_CODE, 
		COMPANY_PARTNER.MOBILTEL, 
		COMPANY_PARTNER.IS_SMS,
		COMPANY_PARTNER.SEX,
		COMPANY_PARTNER.TITLE,
		COMPANY_PARTNER.GRADUATE_YEAR, 
		COMPANY_PARTNER_DETAIL.CHILD,	
		COMPANY_PARTNER_DETAIL.BIRTHDATE, 
		COMPANY_PARTNER_DETAIL.BIRTHPLACE, 
		COMPANY_PARTNER_DETAIL.MARRIED,
		COMPANY_PARTNER_DETAIL.MARRIED_DATE, 
		COMPANY_PARTNER_DETAIL.FACULTY 
	FROM 
		COMPANY,
		COMPANY_PARTNER, 
		COMPANY_PARTNER_DETAIL 
	WHERE 
		COMPANY.COMPANY_ID = #attributes.cpid# AND 
		COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND 
		COMPANY_PARTNER.PARTNER_ID = COMPANY_PARTNER_DETAIL.PARTNER_ID
</cfquery>
<cfquery name="GET_BRANCH_RELATED" datasource="#DSN#">
	SELECT 
		BRANCH.BRANCH_ID, 
		BRANCH.BRANCH_NAME, 
		COMPANY_BRANCH_RELATED.RELATED_ID,
		COMPANY_BRANCH_RELATED.SALES_DIRECTOR, 
		COMPANY_BRANCH_RELATED.TEL_SALE_PREID,
		COMPANY_BRANCH_RELATED.PLASIYER_ID, 
		COMPANY_BRANCH_RELATED.CARIHESAPKOD, 
		COMPANY_BRANCH_RELATED.RELATION_START,
		COMPANY_BRANCH_RELATED.COMP_STATUS, 
		COMPANY_BRANCH_RELATED.DEPO_STATUS,
		COMPANY_BRANCH_RELATED.CARIHESAPKOD,
		COMPANY_BRANCH_RELATED.CEP_SIRA,
		COMPANY_BRANCH_RELATED.MUHASEBEKOD,
		COMPANY_BRANCH_RELATED.DEPOT_KM,
		COMPANY_BRANCH_RELATED.DEPOT_DAK,
		COMPANY_BRANCH_RELATED.BOLGE_KODU,
		COMPANY_BRANCH_RELATED.ALTBOLGE_KODU,
		COMPANY_BRANCH_RELATED.CALISMA_SEKLI,
		COMPANY_BRANCH_RELATED.PUAN,
		COMPANY_BRANCH_RELATED.TAHSILATCI,
		COMPANY_BRANCH_RELATED.ITRIYAT_GOREVLI,
		COMPANY_BRANCH_RELATED.BOYUT_TAHSILAT,
		COMPANY_BRANCH_RELATED.BOYUT_ITRIYAT,
		COMPANY_BRANCH_RELATED.BOYUT_TELEFON,
		COMPANY_BRANCH_RELATED.BOYUT_PLASIYER,
		COMPANY_BRANCH_RELATED.BOYUT_BSM,
		COMPANY_BRANCH_RELATED.AVERAGE_DUE_DATE,
		COMPANY_BRANCH_RELATED.OPENING_PERIOD,
		COMPANY_BRANCH_RELATED.MF_DAY
	FROM 
		COMPANY_BRANCH_RELATED,
		BRANCH 
	WHERE 
		COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
		COMPANY_BRANCH_RELATED.COMPANY_ID = #attributes.cpid# AND 
		BRANCH.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID
</cfquery>
<cfif get_branch_related.recordcount eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1019.Eczanenin Bu Depo İle Olan Bağlantısı Koparılmış Durumda'> !");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_SERVICE_INFO" datasource="#DSN#">
	SELECT COMPANY_ID, PC_NUMBER, NET_CONNECTION FROM COMPANY_SERVICE_INFO WHERE COMPANY_ID = #attributes.cpid#
</cfquery>
<cfquery name="GET_CUSTOMER_POSITION" datasource="#DSN#">
	SELECT 
		COMPANY_POSITION.POSITION_ID,
		SETUP_CUSTOMER_POSITION.POSITION_NAME 
	FROM 
		SETUP_CUSTOMER_POSITION, 
		COMPANY_POSITION
	WHERE 
		COMPANY_POSITION.POSITION_ID = SETUP_CUSTOMER_POSITION.POSITION_ID AND 
		COMPANY_POSITION.COMPANY_ID = #attributes.cpid#
	ORDER BY 
		SETUP_CUSTOMER_POSITION.POSITION_ID
</cfquery>
<cfif len(get_branch_related.related_id)>
	<cfquery name="GET_CREDIT" datasource="#DSN#">
		SELECT TOTAL_RISK_LIMIT, MONEY FROM COMPANY_CREDIT WHERE BRANCH_ID = #get_branch_related.related_id#
	</cfquery>
	<cfset total_risk_limit_value = get_credit.total_risk_limit>
	<cfset money_value = get_credit.money>
<cfelse>
	<cfset total_risk_limit_value = 0>
	<cfset money_value = 0>
</cfif>
<cfquery name="GET_HOBBY" datasource="#DSN#">
	SELECT 
		SETUP_HOBBY.HOBBY_NAME, 
		SETUP_HOBBY.HOBBY_ID 
	FROM 
		SETUP_HOBBY, 
		COMPANY_PARTNER_HOBBY 
	WHERE 
		COMPANY_PARTNER_HOBBY.COMPANY_ID = #attributes.cpid# AND 
		COMPANY_PARTNER_HOBBY.PARTNER_ID = #get_company.manager_partner_id# AND 
		COMPANY_PARTNER_HOBBY.HOBBY_ID = SETUP_HOBBY.HOBBY_ID
</cfquery>
<div class= "col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Müşteri',57457)#" scroll="1" collapsable="1" resize="1">
		<cfform name="form_add_company" method="post" action="#request.self#?fuseaction=crm.emptypopup_upd_company_info">
			<cfoutput>
				<input type="hidden" name="cpid" id="cpid" value="#attributes.cpid#">
				<input type="hidden" name="partner_id" id="partner_id" value="#get_company.partner_id#">
				<input type="hidden" name="related_id" id="related_id" value="#get_branch_related.related_id#">
			</cfoutput>
			<cf_box_elements>
				<cfoutput>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-plan">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57750.İşyeri Adı'>*</label>
							<div class="col col-8 col-xs-12"> 
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='51481.İş Yeri Adı Girmelisiniz'> !</cfsavecontent>
									<cfinput type="text" name="fullname" required="yes" message="#message#" maxlength="75" value="#get_company.fullname#" tabindex="1">
								</div>
							</div>
						</div>
						<div class="form-group" id="item-plan">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58192.Müşteri Adı'>*</label>
							<div class="col col-8 col-xs-12"> 
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='51514.Müşteri Adı Girmelisiniz'> !</cfsavecontent>
									<cfinput type="text" name="company_partner_name" required="yes" message="#message#"  maxlength="20" value="#get_company.company_partner_name#" tabindex="3">
							</div>
						</div>
						<div class="form-group" id="item-company">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51484.Müşteri Soyadı'>*</label>
							<div class="col col-8 col-xs-12"> 
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='51502.Müşteri Soyadı Girmelisiniz '> !</cfsavecontent>
								<cfinput type="text" name="company_partner_surname" maxlength="20" required="yes" message="#message#" value="#get_company.company_partner_surname#" tabindex="4">
							</div>
						</div>
						<div class="form-group" id="item-plan">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57752.Vergi No'>/<cf_get_lang dictionary_id='58025.TC Kimlik No'>*</label>
							<div class="col col-8 col-xs-12"> 
								<div class="input-group">
									<input type="text" name="tax_num" id="tax_num" value="#get_company.taxno#" onkeyup="isNumber(this);" onblur='isNumber(this);' maxlength="11" tabindex="6">
								</div>
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58762.Vergi Dairesi'>*</label>
							<div class="col col-8 col-xs-12"> 
								<input type="text" name="tax_office" id="tax_office" maxlength="30" value="#get_company.taxoffice#" tabindex="7">
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='52110.Şirket Tipi'>*</label>
							<div class="col col-8 col-xs-12"> 
								<select name="company_work_type" id="company_work_type" tabindex="4">
									<option value="1" <cfif get_company.company_work_type eq 1>selected</cfif>><cf_get_lang no ='664.Gerçek'></option>
									<option value="2" <cfif get_company.company_work_type eq 2>selected</cfif>><cf_get_lang no ='665.Tüzel'></option>
								</select>	
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51482.Müşteri Tipi'>*</label>
							<div class="col col-8 col-xs-12"> 
								<select name="companycat_id" id="companycat_id" tabindex="5">
									<cfloop query="get_custs">
										<option value="#companycat_id#" <cfif companycat_id eq get_company.companycat_id>selected</cfif>>#companycat#</option>
									</cfloop>
								</select>
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç">*</label>
							<div class="col col-8 col-xs-12" id="surec1"> 
								<cf_workcube_process is_upd='0' select_value = '#get_branch_related.depo_status#' process_cat_width='150' is_detail='1'>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-branch">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'>*</label>
							<div class="col col-8 col-xs-12"> 
								<cfif len(get_company.country)>
									<cfquery name="GET_COUNTRY" datasource="#DSN#">
										SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #get_company.country#
									</cfquery>
									<input type="hidden" name="country_id" id="country_id" value="#get_company.country#">
									<input type="text" name="country" id="country" readonly="" value="#get_country.country_name#" tabindex="34">
								<cfelse>
									<input type="hidden" name="country_id" id="country_id" value="">
									<input type="text" name="country" id="country" readonly="" value="">
								</cfif>
							</div>
						</div>
						<div class="form-group" id="item-country">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58608.İl'>*</label>
							<div class="col col-8 col-xs-12"> 
								<select name="city" id="city" onChange="get_phone_code()" tabindex="8">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfloop query="get_city">
										<option value="#city_id#" <cfif get_company.city eq city_id>selected</cfif>>#city_name#</option>
									</cfloop>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-city">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'>*</label>
							<div class="col col-8 col-xs-12"> 
								<div class="input-group">
									<cfif len(get_company.county)>
										<cfquery name="GET_COUNTY" datasource="#DSN#">
											SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_company.county#
										</cfquery>
										<input type="hidden" name="county_id" id="county_id" readonly="" value="#get_company.county#">
										<input type="text" name="county" id="county" maxlength="30" required="yes" value="#get_county.county_name#">
									<cfelse>
										<input type="hidden" name="county_id" id="county_id" readonly="" value="">
										<input type="text" name="county" id="county" maxlength="30" required="yes" value="">
									</cfif>
									<span class="input-group-addon btnPointer icon-ellipsis" onClick="pencere_ac();" tabindex="11"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-branch">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58132.Semt'>*</label>
							<div class="col col-8 col-xs-12"> 
								<input type="text" name="semt" id="semt" maxlength="30" value="#get_company.semt#" tabindex="14">
							</div>
						</div>
						<div class="form-group" id="item-plan">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'>*</label>
							<div class="col col-8 col-xs-12"> 
								<input type="text" name="district" id="district" value="#get_company.district#" tabindex="17">
							</div>
						</div>
						<div class="form-group" id="item-plan">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59266.Cadde'>*</label>
							<div class="col col-8 col-xs-12"> 
								<cfinput type="text" name="main_street" maxlength="50" value="#get_company.main_street#" tabindex="20">
							</div>
						</div>
						<div class="form-group" id="item-street">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59267.Sokak'>*</label>
							<div class="col col-8 col-xs-12"> 
								<input type="text" name="street" id="street" maxlength="50" value="#get_company.street#" tabindex="23">
							</div>
						</div>
						<div class="form-group" id="item-no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57487.No'>*</label>
							<div class="col col-8 col-xs-12"> 
								<input type="text" name="dukkan_no" id="dukkan_no" maxlength="50" value="#get_company.dukkan_no#" tabindex="27">
							</div>
						</div>
						<div class="form-group" id="item-postcode">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
							<div class="col col-8 col-xs-12"> 
								<input type="text" name="post_code" id="post_code" maxlength="5" value="#get_company.COMPANY_POSTCODE#" tabindex="31">
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-plan">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55484.e-mail'></label>
							<div class="col col-8 col-xs-12"> 
								<input type="text" name="email" id="email" maxlength="50" value="#get_company.company_email#" tabindex="21">
							</div>
						</div>
						<div class="form-group" id="item-plan">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58079.İnternet'></label>
							<div class="col col-8 col-xs-12"> 
								<input type="text" name="homepage" id="homepage" value="#get_company.homepage#" maxlength="50"  tabindex="24">
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58585.Kod'> / <cf_get_lang dictionary_id='57499. Telefon'>*</label>
							<div class="col col-8 col-xs-12"> 
								<div class="col col-6">
									<cfsavecontent variable="message"><cf_get_lang no='58.Telefon Kodu Sayısal Olmalıdır'> !</cfsavecontent>
										<cfinput type="text" name="telcod" style="width:50px;" maxlength="5" readonly="yes" validate="integer" message="#message#" value="#get_company.company_telcode#">
								</div>
								<div class="col col-6">
									<cfinput type="text" name="tel1"  style="width:97px;" maxlength="7"  validate="integer" message="#message#" value="#get_company.company_tel1#" tabindex="9">
								</div>
					
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'> 2</label>
							<div class="col col-8 col-xs-12"> 
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='51802.Telefon Sayısal Olmalıdır '>!</cfsavecontent>
								<cfinput type="text" name="tel2" validate="integer" message="#message#" maxlength="7" style="width:97px;" value="#get_company.company_tel2#" tabindex="12">
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'> 3</label>
							<div class="col col-8 col-xs-12"> 
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='51802.Telefon Sayısal Olmalıdır '>!</cfsavecontent>
								<cfinput type="text" name="tel3" style="width:97px;" maxlength="7" validate="integer" message="#message#" value="#get_company.company_tel3#" tabindex="15">
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53933.Cep Tel'></label>
							<div class="col col-8 col-xs-12"> 
								<div class="col col-6">
									<cfsavecontent variable="text"><cf_get_lang_main no='1173.Kod'></cfsavecontent>
										<cf_wrk_combo
											name="gsm_code"
											query_name="GET_SETUP_MOBILCAT"
											option_name="mobilcat"
											option_text="#text#"
											value="#get_company.mobil_code#"
											option_value="mobilcat_id"
											width="50">
								</div>
								<div class="col col-6">
									<cfsavecontent variable="mobile_message"><cf_get_lang dictionary_id='51804.cep tel Sayısal Olmalıdır '>!</cfsavecontent>
									<cfinput type="text" name="gsm_tel" style="width:97px;" maxlength="7" validate="integer"  message="#mobile_message#" value="#get_company.mobiltel#" tabindex="29">
								</div>
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57488.Fax'></label>
							<div class="col col-8 col-xs-12"> 
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='51802.Telefon Sayısal Olmalıdır '>! </cfsavecontent>
									<cfsavecontent variable="faxcode_message"><cf_get_lang no ='427.Fax Sayısal Olmalıdır'></cfsavecontent>
								<div class="col col-6">
									<cfinput type="text" name="faxcode" readonly="yes" maxlength="5" style="width:50px;" message="#faxcode_message#" value="#get_company.company_fax_code#">
								</div>
								<div class="col col-6">
									<cfinput name="fax" maxlength="7" type="text" style="width:97px;" validate="integer"  message="#faxcode_message#"value="#get_company.company_fax#" tabindex="18">
								</div>
							</div>
						</div>
						<div class="form-group" id="item-sms">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51571.SMS İstiyor mu'> ?</label>
							<div class="col col-8 col-xs-12"> 
								<input type="checkbox" name="is_sms" id="is_sms" <cfif get_company.is_sms eq 1>checked</cfif> tabindex="32">
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30725.GLN Kodu'></label>
							<div class="col col-8 col-xs-12"> 
								<input type="text" name="glncode" id="glncode" value="#get_company.glncode#" maxlength="13" tabindex="23" onkeyup="isNumber(this);">
							</div>
						</div>
					</div>
				</cfoutput>
			</cf_box_elements>
			<cf_seperator title="#getLang('','Şube Çalışma Bilgileri',51938)#" id="personal_info" is_closed="1">
			<cf_box_elements>
				<cfoutput>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58134.Mikro Bolge Kodu'>*</label>
							<div class="col col-8 col-xs-12"> 
								<div class="input-group">
									<cfquery name="GET_IMS_CODE" datasource="#DSN#">
										SELECT IMS_CODE, IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = #get_company.ims_code_id#
									</cfquery>
									<input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#get_company.ims_code_id#</cfoutput>">
									<cfsavecontent variable="side_message"><cf_get_lang dictionary_id='52468.IMS Bölge Kodu Giriniz'>!</cfsavecontent>
									<cfinput type="text" name="ims_code_name" readonly="yes" required="yes" message="#side_message#" value="#get_ims_code.ims_code# #get_ims_code.ims_code_name#">
									<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=form_add_company.ims_code_name&field_id=form_add_company.ims_code_id');" tabindex="10"></span>
								</div>
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51549.Bölge Satış Müdürü'>*</label>
							<div class="col col-8 col-xs-12"> 
								<div class="input-group">
									<input type="hidden" name="satis_muduru_id" id="satis_muduru_id" value="<cfoutput>#get_branch_related.sales_director#</cfoutput>">
									<input type="text" name="satis_muduru" id="satis_muduru" readonly="" value="<cfoutput>#get_emp_info(get_branch_related.sales_director,1,0)#</cfoutput>">
									<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.satis_muduru_id&field_name=form_add_company.satis_muduru&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>&branch_id='+document.form_add_company.branch_id.value);"></span>
									<a class="margin-left-10" onClick="del_gorevli('satis_muduru_id','satis_muduru');"><i class="fa fa-minus"></i></a>
								</div>
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51877.Telefonla Satış Görevlisi'>*</label>
							<div class="col col-8 col-xs-12"> 
								<div class="input-group">
									<input type="hidden" name="telefon_satis_id" id="telefon_satis_id" value="<cfoutput>#get_branch_related.tel_sale_preid#</cfoutput>">
									<input type="text" name="telefon_satis" id="telefon_satis" readonly="" value="<cfoutput>#get_emp_info(get_branch_related.tel_sale_preid,1,0)#</cfoutput>">
									<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.telefon_satis_id&field_name=form_add_company.telefon_satis&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>');" tabindex="22"></span>
									<a class="margin-left-10"  onClick="del_gorevli('telefon_satis_id','telefon_satis');"><i class="fa fa-minus"></i></a>
							</div>
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51548.Saha Satıs Gorevlisi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group"> 
									<input type="hidden" name="plasiyer_id" id="plasiyer_id" value="<cfoutput>#get_branch_related.plasiyer_id#</cfoutput>">
									<input type="text" name="plasiyer" id="plasiyer" readonly="" value="<cfoutput>#get_emp_info(get_branch_related.plasiyer_id,1,0)#</cfoutput>">
									<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.plasiyer_id&field_name=form_add_company.plasiyer&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>');" tabindex="19"></span>
									<a class="margin-left-10" onClick="del_gorevli('plasiyer_id','plasiyer');"><i class="fa fa-minus"></i></a>
								</div>
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='52093.Itriyat Satış Görevlisi'></label>
							<div class="col col-8 col-xs-12"> 
								<div class="input-group">
									<input type="hidden" name="itriyat_id" id="itriyat_id" value="<cfoutput>#get_branch_related.itriyat_gorevli#</cfoutput>">
									<input type="text" name="itriyat" id="itriyat" readonly="" value="<cfoutput>#get_emp_info(get_branch_related.itriyat_gorevli,1,0)#</cfoutput>">
									<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.itriyat_id&field_name=form_add_company.itriyat&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>')"></span>
									<a class="margin-left-10"  onClick="del_gorevli('itriyat_id','itriyat');"><i class="fa fa-minus"></i></a>
								</div>
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51652.Tahsilatçı'> *</label>
							<div class="col col-8 col-xs-12"> 
								<div class="input-group">
									<input type="hidden" name="tahsilatci_id" id="tahsilatci_id" value="<cfoutput>#get_branch_related.tahsilatci#</cfoutput>">
									<input type="text" name="tahsilatci" id="tahsilatci" readonly=""  value="<cfoutput>#get_emp_info(get_branch_related.tahsilatci,1,0)#</cfoutput>">
									<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.tahsilatci_id&field_name=form_add_company .tahsilatci&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>')"></span>
									<a class="margin-left-10" onClick="del_gorevli('tahsilatci_id','tahsilatci');"><i class="fa fa-minus"></i></a>
								</div>
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51924.Cep Sıra No'></label>
							<div class="col col-8 col-xs-12"> 
								<input type="text" name="cep_sira_no" id="cep_sira_no" maxlength="14" value="<cfoutput>#get_branch_related.cep_sira#</cfoutput>">
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='39355.Ödeme Yontemi'></label>
							<div class="col col-8 col-xs-12"> 
								<input type="text" name="calisma_sekli" id="calisma_sekli" maxlength="10" value="<cfoutput>#get_branch_related.calisma_sekli#</cfoutput>">
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34241.Cari Hesap Kodu'></label>
							<div class="col col-8 col-xs-12"> 
								<input  type="text" name="carihesapkod" id="carihesapkod" maxlength="10" value="<cfoutput>#get_branch_related.carihesapkod#</cfoutput>">
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kod'></label>
							<div class="col col-8 col-xs-12"> 
								<input type="text" name="muhasebekod" id="muhasebekod" maxlength="10" value="<cfoutput>#get_branch_related.muhasebekod#</cfoutput>">
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" >
							<label class="col col-4 col-xs-12"> <cf_get_lang dictionary_id='58763.Depo'>*</label>
							<div class="col col-8 col-xs-12"> 
								<div class="input-group">
									<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#get_branch_related.branch_id#</cfoutput>">
									<cfsavecontent variable="warehouse_message"><cf_get_lang dictionary_id='57734.Seçiniz'></cfsavecontent>
									<cfinput type="text" name="branch_name" required="yes" message="#warehouse_message#" value="#get_branch_related.branch_name#">
									<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=form_add_company.branch_name&field_branch_id=form_add_company.branch_id&is_special=1');" tabindex="13"></span>
								</div>
							</div>
						</div>
						<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51549.Bölge Satış Müdürü'> <cf_get_lang dictionary_id='52136.Boyut Kodu'>*</label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="boyut_satis" id="boyut_satis" style="width:30px;" maxlength="3" value="<cfoutput>#get_branch_related.boyut_bsm#</cfoutput>">
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51877.Telefonla Satış Görevlisi'> <cf_get_lang dictionary_id='52136.Boyut Kodu'>*</label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="boyut_telefon" id="boyut_telefon" style="width:30px;" maxlength="3" value="<cfoutput>#get_branch_related.boyut_telefon#</cfoutput>">
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51548.Saha Satıs Gorevlisi'> <cf_get_lang dictionary_id='52136.Boyut Kodu'>*</label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="boyut_plasiyer" id="boyut_plasiyer" style="width:30px;" maxlength="3" value="<cfoutput>#get_branch_related.boyut_plasiyer#</cfoutput>">
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51690.İtriyat Satış Görevlisi'> <cf_get_lang dictionary_id='52136.Boyut Kodu'>*</label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="boyut_itriyat" id="boyut_itriyat" style="width:30px;" maxlength="3" value="<cfoutput>#get_branch_related.boyut_itriyat#</cfoutput>">
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51652.Tahsilatçı'> <cf_get_lang dictionary_id='52136.Boyut Kodu'>*</label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="boyut_tahsilat" id="boyut_tahsilat" style="width:30px;" maxlength="3" value="<cfoutput>#get_branch_related.boyut_tahsilat#</cfoutput>">
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51679.Depoya Uzaklık (Km)'> *</label>
							<div class="col col-8 col-xs-12"> 
								<cfsavecontent variable="message1"><cf_get_lang dictionary_id='51680.Depoya Uzaklık Sayısal Olmalıdır'> !</cfsavecontent>
									<cfinput name="depot_km" style="width:150;" validate="float" message="#message1#" value="#get_branch_related.depot_km#">
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='715.Dakika'> *</label>
							<div class="col col-8 col-xs-12"> 
								<cfsavecontent variable="message1"><cf_get_lang dictionary_id='52034.Lütfen Dakika Cinsinden Depoya Uzaklık Giriniz'> !</cfsavecontent>
									<cfinput name="depot_dak" style="width:150;" validate="float" message="#message1#" value="#get_branch_related.depot_dak#">
							</div>
						</div>
						<div class="form-group" id="item-customer_position">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51567.Müşterinin Genel Konumu'><cfif not isdefined("attributes.transfer_branch_id")></cfif> *</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<select name="customer_position" id="customer_position" multiple>
										<cfloop query="get_customer_position">
											<option value="#position_id#">#position_name#</option>
										</cfloop>
									</select>
									<span class="input-group-addon">  
										<i class="icon-pluss btnPointer show" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_position_detail&field_name=form_add_company.customer_position');"  title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
										<i class="icon-minus btnPointer show" onClick="remove_field('customer_position');" title="<cf_get_lang dictionary_id='57463.Sil'>"></i>
									</span>
								</div>
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58984.Puan'></label>
							<div class="col col-8 col-xs-12"> 
								<cfsavecontent variable="point_massage"><cf_get_lang no ='575.Puan Değeri Sayısal Olmalıdır'></cfsavecontent>
								<cfinput type="text" name="puan" validate="float" message="#point_massage#" value="#get_branch_related.puan#">
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49667.Risk Limiti'>*</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="risc_message"><cf_get_lang dictionary_id='57689.risk'><cf_get_lang dictionary_id='61824.Giriniz'></cfsavecontent>
									<cfinput type="text" name="risk_limit" id="risk_limit" validate="float" message="#risc_message#" onKeyup="return(FormatCurrency(this,event));" value="#tlformat(total_risk_limit_value)#" class="moneybox" tabindex="25">
									<span class="input-group-addon width">
										<select name="money_type" id="money_type" tabindex="26">
											<cfloop query="get_money">
												<option value="#money#" <cfif money_value eq money>selected</cfif>>#money#</option>
											</cfloop>
										</select>
									</span>
								</div>
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang no='229.İlişki Başlangıcı'> *</label>
							<div class="col col-8 col-xs-12"> 
								<select name="resource" id="resource" tabindex="34">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfloop query="get_resource">
										<option value="#resource_id#" <cfif get_branch_related.relation_start eq resource_id>selected</cfif>>#resource#</option>
									</cfloop>
								</select>
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57057.Bölge Kodu'> *</label>
							<div class="col col-8 col-xs-12"> 
								<input type="text" name="bolge_kodu" id="bolge_kodu" maxlength="5" value="<cfoutput>#get_branch_related.bolge_kodu#</cfoutput>">
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51921.Alt Bölge Kodu'> *</label>
							<div class="col col-8 col-xs-12"> 
								<input type="text" name="altbolge_kodu" id="altbolge_kodu" value="<cfoutput>#get_branch_related.altbolge_kodu#</cfoutput>" maxlength="5">
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51683.Şube Açılış Tarihi'> *</label>
							<div class="col col-8 col-xs-12"> 
								<div class="input-group" >
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='51684.Şube Açılış Tarihi Girmelisiniz'> !</cfsavecontent>
									<cfinput type="text" name="open_date" value="#dateformat(now(),dateformat_style)#" required="yes" message="#message#" validate="#validate_style#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="open_date"></span>
								</div>
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang no='653.Ort Vade - Açılış Sür - MF Gün'></label>
							<div class="col col-8 col-xs-12"> 
								<div class="col col-4">
									<input type="text" name="average_due_date" id="average_due_date" value="<cfoutput>#get_branch_related.average_due_date#</cfoutput>" class="moneybox" onkeyup="return(FormatCurrency(this,event));" maxlength="3" tabindex="49" style="width:47px;">
								</div>
								<div class="col col-4">
									<input type="text" name="opening_period" id="opening_period" value="<cfoutput>#get_branch_related.opening_period#</cfoutput>" class="moneybox" onkeyup="return(FormatCurrency(this,event));" maxlength="2" tabindex="50" style="width:47px;">
								</div>
								<div class="col col-4">
									<input type="text" name="mf_day" id="mf_day" value="<cfoutput>#get_branch_related.mf_day#</cfoutput>" class="moneybox" onkeyup="return(FormatCurrency(this,event));" maxlength="3" tabindex="51" style="width:47px;">
								</div>
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51685.Satis Statusu Notlar'></label>
							<div class="col col-8 col-xs-12"> 
								<textarea type="text" name="status" id="status" style="width:150px;height:50px;" maxlength="100" tabindex="33"><cfoutput>#get_branch_related.comp_status#</cfoutput></textarea>
							</div>
						</div>
					</div>
				</cfoutput>
			</cf_box_elements>
			<cf_seperator title="#getLang('','Kişisel ve Diğer Bilgiler',51844)#" id="personal_info" is_closed="1">
			<cf_box_elements>
				<cfoutput>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group" > 
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='52364.Doğum Tarihi Formatını Doğru Giriniz'></cfsavecontent>
									<cfinput type="text" name="birthday" value="#dateformat(get_company.birthdate,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" style="width:140;" tabindex="35">
									<span class="input-group-addon"><cf_wrk_date_image date_field="birthday"></span>
								</div>
							</div>
						</div>

						<div class="form-group" >
							
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51527.Cinsiyeti'></label>
							<div class="col col-8 col-xs-12"> 
								<select name="sexuality" id="sexuality" style="width:140;" tabindex="39">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<option value="1" <cfif get_company.sex eq 1>selected</cfif>><cf_get_lang no='163.Bay'></option>
									<option value="2" <cfif get_company.sex eq 2>selected</cfif>><cf_get_lang no='164.Bayan'></option>
								</select>
							</div>
						</div>

						
						<div class="form-group" >
							
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51522.Evlenme Tarihi'></label>
							<div class="col col-8 col-xs-12"> 
								<div class="input-group" > 
									<cfsavecontent variable="message"><cf_get_lang no='354.Lütfen Evlenme Tarihi Formatini Dogru Giriniz !'></cfsavecontent>
										<cfinput type="text" name="marriage_date" value="#dateformat(get_company.married_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" style="width:140;" tabindex="42">
									<span class="input-group-addon"><cf_wrk_date_image date_field="marriage_date"></span>
								</div>
							</div>
						</div>

						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51525.Mez Olduğu Fakülte'></label>
							<div class="col col-8 col-xs-12"> 
								<select name="faculty" id="faculty" style="width:140;" tabindex="46">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfloop query="get_universty">
										<option value="#university_id#,#university_name#" <cfif get_company.faculty eq university_id>selected</cfif>>#university_name#</option>
									</cfloop>
								</select>
							</div>
						</div>

						<div class="form-group" >
							
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
							<div class="col col-8 col-xs-12"> 
								<input  type="text" name="title" id="title" style="width:140px;" maxlength="50" value="<cfoutput>#get_company.title#</cfoutput>">
							</div>
						</div>

					</div>

					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="birth_place" id="birth_place" maxlength="100" style="width:140;" value="<cfoutput>#get_company.birthplace#</cfoutput>" tabindex="37">
							</div>
						</div>

						<div class="form-group" >
							
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51521.Medeni Hali'></label>
							<div class="col col-8 col-xs-12"> 
								<select name="marital_status" id="marital_status" style="width:140;" tabindex="40">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<option value="1" <cfif get_company.married eq 1>selected</cfif>><cf_get_lang dictionary_id='46541.Bekar'></option>
									<option value="2" <cfif get_company.married eq 2>selected</cfif>><cf_get_lang dictionary_id='55743.Evli'></option>
									<option value="3" <cfif get_company.married eq 3>selected</cfif>><cf_get_lang dictionary_id='51555.Dul'></option>
								</select>
							</div>
						</div>

						
						<div class="form-group" >
							
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56137.Çocuk Sayısı'></label>
							<div class="col col-8 col-xs-12"> 
								<input type="text" name="child_number" id="child_number" style="width:140px;" maxlength="50" value="<cfoutput>#get_company.CHILD#</cfoutput>" tabindex="44">
							</div>
						</div>

						<div class="form-group" >
							
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55845.Mezuniyet Yılı'></label>
							<div class="col col-8 col-xs-12"> 
								<select name="graduate_year" id="graduate_year" tabindex="47">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfloop from="1920" to="2050" index="i">
										<cfoutput>
											<option value="#i#" <cfif get_company.graduate_year eq i>selected</cfif>>#i#</option>
										</cfoutput>
									</cfloop>
								</select>
							</div>
						</div>

					</div>

					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51597.Bilgisayar Sayısı'></label>
							<div class="col col-8 col-xs-12">
								<cf_wrk_combo
									name="pc_number"
									value="#get_service_info.pc_number#"
									query_name="GET_SETUP_PC_NUMBER"
									option_name="unit_name"
									option_value="unit_id">
							</div>
						</div>

						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51569.İnternet Bağlantısı'></label>
							<div class="col col-8 col-xs-12">
								<cf_wrk_combo
									name="net_connection"
									value="#get_service_info.net_connection#"
									query_name="GET_SETUP_NET_CONNECTION"
									option_name="connection_name"
									option_value="connection_id">
							</div>
						</div>
						<div class="form-group" id="item-hobby">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51524.Hobiler'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<select name="hobby" id="hobby" style="width:485px; height:80px;" multiple>
										<cfloop query="get_hobby">
										<option value="#hobby_id#">#hobby_name#</option>
									</cfloop>
									</select>
									<span class="input-group-addon">  
										<i class="icon-pluss btnPointer show" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_hobby_detail&field_name=form_add_company.hobby');"  title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
										<i class="icon-minus btnPointer show" onClick="kaldir();" title="<cf_get_lang dictionary_id='57463.Sil'>"></i>
									</span>
								</div>
							</div>
						</div>
					</div>
				</cfoutput>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="get_company">
					<cfif get_company.ispotantial eq 1>
						<cf_workcube_buttons is_upd='1' insert_info='#update_btn#' add_function="kontrol()" delete_page_url='#request.self#?fuseaction=crm.emptypopup_del_potential_company&cpid=#attributes.cpid#'>
					<cfelse>
						<cfsavecontent variable="update_btn"><cf_get_lang_main no ='52.Güncelle'></cfsavecontent>
						<cf_workcube_buttons is_upd='1' insert_info='#update_btn#' add_function="kontrol()" is_delete='0'>
					</cfif> 
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function remove_field(field_option_name)
{
	field_option_name_value = eval('document.form_add_company.' + field_option_name);
	for (i=field_option_name_value.options.length-1;i>-1;i--)
	{
		if (field_option_name_value.options[i].selected==true)
		{
			field_option_name_value.options.remove(i);
		}	
	}
}
plate_code_list=new Array("<cfoutput>#ListDeleteDuplicates(valuelist(get_city.plate_code))#</cfoutput>");
phone_code_list = new Array("<cfoutput>#ListDeleteDuplicates(valuelist(get_city.phone_code))#</cfoutput>");
country_list = new Array('<cfoutput><cfloop query=get_country>"#get_country.country_name#"<cfif not currentrow eq recordcount>,</cfif></cfloop></cfoutput>');
country_ids = new Array("<cfoutput>#ListDeleteDuplicates(valuelist(get_city.country_id))#</cfoutput>");
function get_phone_code()
{	
	if(document.form_add_company.city.selectedIndex > 0)
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
		document.form_add_company.county_id.value = '';
		document.form_add_company.county.value = '';
	}
}

/* Kullanilmiyorsa kaldirilsin 20120827
function pencere_pos()
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_dsp_company_prerecords&company_name='+ document.form_add_company.fullname.value +'&company_partner_name=' + document.form_add_company.company_partner_name.value +'&company_partner_surname='+ document.form_add_company.company_partner_surname.value +'&company_partner_tax_no='+ document.form_add_company.tax_num.value +'&company_partner_tel_code='+ document.form_add_company.telcod.value +'&company_partner_tel=' + document.form_add_company.tel1.value,'wide'); 
}
*/
function kaldir(){
	for (i=document.form_add_company.hobby.options.length-1;i>-1;i--){
		if (document.form_add_company.hobby.options[i].selected==true){
			document.form_add_company.hobby.options.remove(i);
		}	
	}
}
function pencere_ac(no)
{
	x = document.form_add_company.city.selectedIndex;
	if (document.form_add_company.city[x].value == "")
	{
		alert("<cf_get_lang no ='828.İlk Olarak İl Seçiniz'> !");
	}
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=form_add_company.county_id&field_name=form_add_company.county&city_id=' + document.form_add_company.city.value,'small');
	}
}

function il_secimi_kontrol()
{
	if(document.form_add_company.city.selectedIndex == '')
	{
		alert("<cf_get_lang no ='828.İlk Olarak İl Seçiniz'>!");
	}
	else
	{
		city_plate_code= plate_code_list[document.form_add_company.city.selectedIndex-1];
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=form_add_company.ims_code_name&field_id=form_add_company.ims_code_id&plate_code='+city_plate_code,'list');
	}
}

function select_all(selected_field)
{
	var m = eval("document.form_add_company." + selected_field + ".length");
	for(i=0;i<m;i++)
	{
		eval("document.form_add_company."+selected_field+"["+i+"].selected=true");
	}
}

function del_gorevli(field1,field2)
{
	var deger1 = eval("document.form_add_company." + field1);
	var deger2 = eval("document.form_add_company." + field2);
	deger1.value="";
	deger2.value="";
}

function kontrol()
{
	select_all('hobby');
	select_all('customer_position');

	if(document.form_add_company.company_partner_name.value.length == "")
	{
		alert("<cf_get_lang no='67.Lütfen Müşteri Adı Giriniz'> !");
		return false;
	}
	if(document.form_add_company.company_partner_surname.value.length == "")
	{
		alert("<cf_get_lang no='55.Lütfen Müşteri Soyadı Giriniz'> !");
		return false;
	}
	
	x = document.form_add_company.company_work_type.selectedIndex;
	if(document.form_add_company.company_work_type[x].value == 1)
	{
		if(document.form_add_company.tax_num.value.length != 11)
		{
			alert("<cf_get_lang no ='1022.TC Kimlik Numarası 11 Hane Olmalıdır'> !");
			return false;
		}
	}
	else
	{
		if(document.form_add_company.tax_num.value.length != 10)
		{
			alert("<cf_get_lang no ='506.Vergi Numarası 10 Hane Olmalıdır'> !");
			return false;
		}
	}	
	
	if(document.form_add_company.tax_office.value.length == "")
	{
		alert("<cf_get_lang no='56.Lütfen Vergi Dairesi Giriniz'> !");
		return false;
	}
	
	if(document.form_add_company.main_street.value.length == "")
	{
		alert("<cf_get_lang no='61.Lütfen Cadde Giriniz'> !");
		return false;
	}
	if(document.form_add_company.street.value.length == "")
	{
		alert("<cf_get_lang no='62.Lütfen Sokak Giriniz'> !");
		return false;
	}
	x = document.form_add_company.city.selectedIndex;
	if (document.form_add_company.city[x].value == "")
	{
		alert("<cf_get_lang no='283.Lütfen İl Seçiniz'> !");
	}
	if(document.form_add_company.dukkan_no.value.length == "")
	{
		alert("<cf_get_lang no='502.Lütfen İşyeri No Giriniz'> !");
		return false;
	}
	if(document.form_add_company.telcod.value.length == "")
	{
		alert("<cf_get_lang no='159.Lütfen Telefon Kodu Giriniz'> !");
		return false;
	}
	if(document.form_add_company.tel1.value.length == "")
	{
		alert("<cf_get_lang no='58.Lütfen Telefon No Giriniz'> !");
		return false;
	}
	if(document.form_add_company.district.value.length == "")
	{
		alert("<cf_get_lang no='503.Lütfen Mahalle Giriniz'> !");
		return false;
	}
	if(document.form_add_company.semt.value.length == "")
	{
		alert("<cf_get_lang no='64.Lütfen Semt Giriniz'> !");
		return false;
	}
	if(document.form_add_company.county.value.length == "")
	{
		alert("<cf_get_lang no='65.Lütfen İlçe Giriniz'> !");
		return false;
	}
	if(document.form_add_company.country_id.value.length == "")
	{
		alert("<cf_get_lang no='504.Lütfen Ülke Giriniz'> !");
		return false;
	}
	if(document.form_add_company.branch_id.value.length == "")
	{
		alert("<cf_get_lang no='234.Lütfen Şube Giriniz'> !");
		return false;
	}
	
	if(document.form_add_company.glncode.value != '' && document.form_add_company.glncode.value.length != 13)
	{
		alert("<cf_get_lang dictionary_id='30293.GLN Kod Alanı 13 Hane Olmalıdır'>!");
		document.form_add_company.glncode.focus();
		return false;
	}

	if(document.form_add_company.ims_code_id.value.length == "")
	{
		alert("<cf_get_lang no='68.Lütfen IMS Kodu Giriniz'> !");
		return false;
	}
	if(document.form_add_company.open_date.value.length == "")
	{
		alert("<cf_get_lang no='237.Lütfen Şube Açılış Tarihi Giriniz'> !");
		return false;
	}
	if(document.form_add_company.satis_muduru.value.length == "")
	{
		alert("<cf_get_lang no ='577.Lütfen Satış Müdürü Seçiniz'> !");
		return false;
	}
	if(document.form_add_company.boyut_satis.value.length == "")
	{
		alert("<cf_get_lang no ='578.Lütfen Satış Müdürü Boyut Kodu Seçiniz'> !");
		return false;
	}
	if(document.form_add_company.telefon_satis.value.length == "")
	{
		alert("<cf_get_lang no ='1023.Lütfen Satış Telefonla Satış Görevlisi Seçiniz'> !");
		return false;
	}
	if(document.form_add_company.tahsilatci.value.length == "")
	{
		alert("<cf_get_lang no ='580.Lütfen Tahsilat Görevlisi Seçiniz'> !");
		return false;
	}
	if(document.form_add_company.boyut_tahsilat.value.length == "")
	{
		alert("<cf_get_lang no ='581.Lütfen Tahsilat Görevlisi Boyut Kodu Giriniz'> !");
		return false;
	}
	if(document.form_add_company.boyut_telefon.value.length == "")
	{
		alert("<cf_get_lang no ='1024.Lütfen Satış Telefonla Satış Görevlisi Boyut Kodu Seçiniz'> !");
		return false;
	}
	if(document.form_add_company.bolge_kodu.value.length == "")
	{
		alert("<cf_get_lang no ='583.Lütfen Bölge Kodu Seçiniz '>!");
		return false;
	}
	if(document.form_add_company.altbolge_kodu.value.length == "")
	{
		alert("<cf_get_lang no ='584.Lütfen Alt Bölge Kodu Seçiniz'> !");
		return false;
	}
	if(document.form_add_company.risk_limit.value.length == "")
	{
		alert("<cf_get_lang no ='585.Lütfen Risk Limiti Giriniz'> !");
		return false;
	}
	if(document.form_add_company.depot_km.value.length == "")
	{
		alert("<cf_get_lang no ='586.Lütfen Km Cinsinden Depoya Uzaklık Giriniz'> !");
		return false;
	}
	if(document.form_add_company.depot_dak.value.length == "")
	{
		alert("<cf_get_lang no ='587.Lütfen Dakika Cinsinden Depoya Uzaklık Giriniz'> !");
		return false;
	}
	if(document.form_add_company.customer_position.length == 0)
	{
		alert("<cf_get_lang no ='588.Lütfen Müşterinin Genel Konumunu Giriniz'> !");
		return false;
	}
	if(document.form_add_company.is_sms.checked == true)
	{
		if(document.form_add_company.gsm_tel.value == "")
		{
			alert("<cf_get_lang no ='576.Sms İstiyor mu Seçeneğini İşaretlediniz Lütfen Eczacının Cep Telefonunu Giriniz'> !");
			return false;
		}
		x = document.form_add_company.gsm_code.selectedIndex;
		if (document.form_add_company.gsm_code[x].value == "")
		{ 
			alert ("<cf_get_lang no ='594.Sms İstiyor mu Seçeneğini İşaretlediniz Lütfen Eczacının Cep Telefonunu  Alan Kodunu Giriniz'> !");
			return false;
		}
	}
	/* Eğer Cari Hesap Kod Dolu İse */
	if(document.form_add_company.carihesapkod.value != "")
	{
		if(document.form_add_company.carihesapkod.value.length != 10)
		{
			alert("<cf_get_lang no ='589.Cari Hesap Kodu 10 Hane Olmalıdır'> !");
			return false;
		}
		var numberformat = "1234567890";
		for (var i = 1; i < form_add_company.carihesapkod.value.length; i++)
		{
			check_char = numberformat.indexOf(form_add_company.carihesapkod.value.charAt(i));
			if (check_char < 0)
			{
				alert("<cf_get_lang no ='590.Cari Hesap Kodu Sayısal Olmalıdır'> !");
				return false;
			}
		}
	}
	/* Eğer Muhasebe Kod Dolu İse */
	if(document.form_add_company.muhasebekod.value != "")
	{
		if(document.form_add_company.muhasebekod.value.length != 10)
		{
			alert("<cf_get_lang no ='591.Muhasebe Kodu 10 Hane Olmalıdır'> !");
			return false;
		}
		var numberformat = "1234567890";
		for (var i = 1; i < form_add_company.muhasebekod.value.length; i++)
		{
			check_char = numberformat.indexOf(form_add_company.muhasebekod.value.charAt(i));
			if (check_char < 0)
			{
				alert("<cf_get_lang no ='592.Muhasebe Kodu Sayısal Olmalıdır'> !");
				return false;
			}
		}
	}

	x = document.form_add_company.resource.selectedIndex;
	if (document.form_add_company.resource[x].value == "")
	{ 
		alert ("<cf_get_lang no ='593.İlişki Başlangıcı Giriniz'> !");
		return false;
	}
	var numberformat = "1234567890";
	for (var i = 1; i < form_add_company.boyut_satis.value.length; i++)
	{
		check_char = numberformat.indexOf(form_add_company.boyut_satis.value.charAt(i));
		if (check_char < 0)
		{
			alert("<cf_get_lang no='522.Bölge Satış Müdürü Boyut Kodu Sayısal Olmalıdır '>!");
			return false;
		}
	}	
	var numberformat = "1234567890";
	for (var i = 1; i < form_add_company.boyut_telefon.value.length; i++)
	{
		check_char = numberformat.indexOf(form_add_company.boyut_telefon.value.charAt(i));
		if (check_char < 0)
		{
			alert("<cf_get_lang no='523.Telefonla Satış Görevlisi Boyut Kodu Sayısal Olmalıdır'> !");
			return false;
		}
	}	
	var numberformat = "1234567890";
	for (var i = 1; i < form_add_company.boyut_plasiyer.value.length; i++)
	{
		check_char = numberformat.indexOf(form_add_company.boyut_plasiyer.value.charAt(i));
		if (check_char < 0)
		{
			alert("<cf_get_lang no='524.Saha Satış Görevlisi Boyut Kodu Sayısal Olmalıdır'> !");
			return false;
		}
	}	
	var numberformat = "1234567890";
	for (var i = 1; i < form_add_company.boyut_itriyat.value.length; i++)
	{
		check_char = numberformat.indexOf(form_add_company.boyut_itriyat.value.charAt(i));
		if (check_char < 0)
		{
			alert("<cf_get_lang no='525.Itriyat Satış Görevlisi Boyut Kodu Sayısal Olmalıdır'> !");
			return false;
		}
	}	
	var numberformat = "1234567890";
	for (var i = 1; i < form_add_company.boyut_tahsilat.value.length; i++)
	{
		check_char = numberformat.indexOf(form_add_company.boyut_tahsilat.value.charAt(i));
		if (check_char < 0)
		{
			alert("<cf_get_lang no='526.Tahsilat Satış Görevlisi Boyut Kodu Sayısal Olmalıdır'> !");
			return false;
		}
	}	
	form_add_company.risk_limit.value = filterNum(form_add_company.risk_limit.value);
	return process_cat_control();
}
</script>
