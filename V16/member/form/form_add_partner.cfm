<!--- File: form_add_partner.cfm
    Author: Canan Ebret <cananebret@workcube.com>
    Date: 11.10.2019
    Controller: -
    Description: Kurumsal üye çalışan ekleme sayfası, sorguları member_company.cfc dosyasına taşındı .​
 --->
<cf_xml_page_edit fuseact="member.detail_partner">
<cf_get_lang_set module_name="member"><!--- sayfanin en altinda kapanisi var --->
<cfif isdefined("url.compid")>
	<cfset attributes.cpid = url.compid>
</cfif>
<cfset company_cmp = createObject("component","V16.member.cfc.member_company")> 
<cfset GET_IM = company_cmp.GET_IM()> 
<cfset GET_LANGUAGE = company_cmp.GET_LANGUAGE()>
<cfset GET_PARTNER_POSITIONS = company_cmp.GET_PARTNER_POSITIONS()>  
<cfset GET_PARTNER_DEPARTMENTS = company_cmp.GET_PARTNER_DEPARTMENTS()>
<cfset GET_COUNTRY = company_cmp.GET_COUNTRY_()> 
<cfset GET_COMPANY_BRANCH = company_cmp.GET_COMPANY_BRANCH(compid:attributes.compid)>
<cfset password_style = createObject('component','V16.hr.cfc.add_rapid_emp')><!--- Şifre standartları çekiliyor. --->
<cfset get_password_style = password_style.pass_control()>
<cfset GET_HIER_PARTNER = company_cmp.GET_HIER_PARTNER(GET_PARTNER : 1, cpid :attributes.cpid)> 
<cfset GET_COMPANY = company_cmp.GET_COMP_ADDRESS(GET_COMPANY : 1, cpid :attributes.cpid)> 
<cfif len(get_company.county)>
	<cfset GET_COUNTY = company_cmp.GET_COMP_COUNTY(county:get_company.county)>
</cfif>
<cfif len(get_company.city)>
	<cfset GET_CITY = company_cmp.GET_COMP_CITY(city:get_company.city)>
</cfif>
<cfsavecontent variable="txt">
	<cf_get_lang dictionary_id='30190.Kişi Ekle'>:
	<cfif isdefined("url.comp_cat")>
		<cfoutput query="get_company">
			<cfif isdefined("url.compid")>
				<cfif company_id is url.compid><a href="#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#url.compid#">#fullname#</a></cfif>
			</cfif>
		</cfoutput>
	<cfelse>
		<cf_get_lang dictionary_id='30396.Şirket Yok'>
	</cfif>
</cfsavecontent>

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_partner" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_partner">
			<cfoutput>
				<input type="hidden" name="companycat_id" id="companycat_id" value="#get_company.companycat_id#">
				<input type="hidden" name="company_id" id="company_id" value="#url.compid#">
				<cfif isdefined("attributes.is_popup")><input type="hidden" name="is_popup" id="is_popup" value="1"></cfif>
			</cfoutput>
			<cf_box_elements>
				<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<cfif x_system_consumer_import eq 1>
					<div class="form-group" id="item-related_consumer_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57586.Bireysel Üye'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" id="related_consumer_id" name="related_consumer_id" value="">
								<input type="text" id="related_consumer_name" name="related_consumer_name" value="" autocomplete="off">
								<cfset popup_link="&field_consumer=add_partner.related_consumer_id&field_member_name=add_partner.related_consumer_name&field_cons_name=add_partner.name&field_cons_surname=add_partner.soyad&field_mail=add_partner.email&field_tel_code=add_partner.telcod&field_tel_number=add_partner.tel&field_address=add_partner.adres&field_country_id=add_partner.country&field_city_id=add_partner.city_id&field_county_id=add_partner.county_id&func_LoadCity=1&func_LoadCounty=1&field_postcode=add_partner.postcod&field_semt=add_partner.semt&field_tc_identy_no=add_partner.tc_identity&field_cons_username=add_partner.username&field_mobile_tel=add_partner.mobiltel&field_mobile_tel_code=add_partner.mobilcat_id&field_imcat_id=add_partner.imcat_id&field_im=add_partner.im&field_title_name=add_partner.title&field_mission=add_partner.mission&field_department=add_partner.department&field_sex=add_partner.sex&field_work_tel_ext=add_partner.tel_local&field_work_fax=add_partner.fax&field_homepage=add_partner.homepage">
								<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_cons#popup_link#</cfoutput><cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=8&keyword='+encodeURIComponent(document.add_partner.related_consumer_name.value),'list');"></span>
							</div>
						</div>
					</div>
					</cfif>
					<div class="form-group" id="item-name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'> *</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="name" id="name" required="yes" maxlength="20" onKeyDown="cons_control();">
						</div>
					</div>
					<div class="form-group" id="item-soyad">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58726.Soyad'>*</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="soyad" id="soyad" required="yes" maxlength="20" onKeyDown="cons_control();">
						</div>
					</div>
					<div class="form-group" id="item-birthdate">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="birthdate" id="birthdate" maxlength="10" validate="#validate_style#" tabindex="5">
								<span class="input-group-addon"><cf_wrk_date_image date_field="birthdate"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-username">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57551.Kullanıcı Ad'></label>
						<div class="col col-8 col-xs-12">
							<cfinput  type="text" name="username" id="username">
						</div>
					</div>
					<div class="form-group" id="item-password">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">	
								<cfinput type="text" class="input-type-password" name="password" id="password" maxlength="16">
								<span class="input-group-addon showPassword" onclick="showPasswordClass('password')"><i class="fa fa-eye"></i></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-tc_identity">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58025.TC Kimlik No'><cfif is_tc_number eq 1> *</cfif></label>
						<div class="col col-8 col-xs-12">
							<cf_wrkTcNumber fieldId="tc_identity" tc_identity_required="#is_tc_number#" width_info='150' is_verify='1' consumer_name='name' consumer_surname='soyad' birth_date='birthdate'>
						</div>
					</div>
					<div class="form-group" id="item-mobilcat_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30254.Kod /Mobil Tel'></label>
						<div class="col col-4 col-xs-12">
							<cfinput type="text" name="mobilcat_id" id="mobilcat_id" value="" validate="integer" maxlength="7">
						</div>
						<div class="col col-4 col-xs-12">
							<cfinput type="text" name="mobiltel" id="mobiltel" value="" validate="integer" maxlength="10">
						</div>
					</div>
					<div class="form-group" id="item-title">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="title" id="title" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-mission">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57573.Görev'> <cfif isDefined('is_mission_required') and is_mission_required eq 1>*</cfif></label>
						<div class="col col-8 col-xs-12">
							<select name="mission" id="mission">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_partner_positions">
									<option value="#partner_position_id#">#partner_position#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-compbranch_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-8 col-xs-12">
							<select name="compbranch_id" id="compbranch_id" onchange="kontrol_et(this.value);">
								<option value="0"><cf_get_lang dictionary_id='30319.Merkez Ofis'> 
								<cfoutput query="get_company_branch">
									<option value="#compbranch_id#" <cfif isdefined("attributes.compbranch_id") and attributes.compbranch_id eq compbranch_id>selected</cfif>>#compbranch__name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-department">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
						<div class="col col-8 col-xs-12">
							<select name="department" id="department">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_partner_departments">
										<option value="#partner_department_id#">#partner_department#</option>
									</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-language_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58996.Dil'> *</label>
						<div class="col col-8 col-xs-12">
							<select name="language_id" id="language_id">
								<cfoutput query="get_language">
									<option value="#language_short#">#language_set#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-photo">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30263.Fotoğraf Ekle'></label>
						<div class="col col-8 col-xs-12">
							<input type="file" name="photo" id="photo">
						</div>
					</div>
					<div class="form-group" id="item-sex">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
						<div class="col col-8 col-xs-12">
							<select name="sex" id="sex">
								<option value="1"><cf_get_lang dictionary_id='58959.Erkek'>
								<option value="2"><cf_get_lang dictionary_id='58958.Kadın'>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-hier_partner_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30732.Bağlı Çalışan'></label>
						<div class="col col-8 col-xs-12">
							<select name="hier_partner_id" id="hier_partner_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_hier_partner">
									<option value="#partner_id#">#company_partner_name# #company_partner_surname#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-pdks_type_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29489.Pdks tipi'></label>
						<div class="col col-8 col-xs-12">
							<cfquery name="get_pdks_types" datasource="#dsn#">
								SELECT PDKS_TYPE_ID,PDKS_TYPE FROM SETUP_PDKS_TYPES
							</cfquery>
							<select name="pdks_type_id" id="pdks_type_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_pdks_types">
									<option value="#PDKS_TYPE_ID#">#PDKS_TYPE#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-pdks_number">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29488.Pdks numarası'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="pdks_number" id="pdks_number" maxlength="8" value="" />
						</div>
					</div>
					<div class="form-group" id="item-start_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57628.Giriş Tarihi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="start_date" id="start_date" maxlength="10" validate="#validate_style#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-send_finance_mail">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30734.Finans Mailleri Gönderilsin'></label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="send_finance_mail" id="send_finance_mail" value="1">
						</div>
					</div>
					<div class="form-group" id="item-send_earchive_mail">
						<label class="col col-4 col-xs-12" for="send_earchive_mail"><cf_get_lang dictionary_id='60086.E-Arşiv Mailleri Gönderilsin'></label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="send_earchive_mail" id="send_earchive_mail" value="1">
						</div>
					</div>
					<div class="form-group" id="item-cf_wrk_add_info">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
						<div class="col col-8 col-xs-12">
							<cf_wrk_add_info info_type_id="-3" upd_page = "0">
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-imcat_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30340.Instant Message'></label>
						<div class="col col-4 col-xs-12">
							<select name="imcat_id" id="imcat_id">
								<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_im">
									<option value="#imcat_id#">#imcat#</option> 
								</cfoutput>
							</select>
						</div>
						<div class="col col-4 col-xs-12">
							<input type="text" name="im" id="im" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-imcat2_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30340.Instant Message'> 2</label>
						<div class="col col-4 col-xs-12">
							<select name="imcat2_id" id="imcat2_id">
								<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_im">
									<option value="#imcat_id#">#imcat#</option> 
								</cfoutput>
							</select>
						</div>
						<div class="col col-4 col-xs-12">
							<input type="text" name="im2" id="im2" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-telcod">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30174.Kod/ Telefon'></label>
						<div class="col col-4 col-xs-12">
							<cfinput type="text" name="telcod" id="telcod" value="#get_company.company_telcode#" validate="integer" maxlength="6">
						</div>
						<div class="col col-4 col-xs-12">
							<cfinput type="text" name="tel" id="tel" value="#get_company.company_tel1#" validate="integer" maxlength="10">
						</div>
					</div>
					<div class="form-group" id="item-tel_local">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30259.Dahili'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="tel_local" id="tel_local" validate="integer" maxlength="5" >
						</div>
					</div>
					<div class="form-group" id="item-fax">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57488.Fax'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="fax" id="fax" value="#get_company.company_fax#" validate="integer" maxlength="10">
						</div>
					</div>
					<div class="form-group" id="item-email">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57428.e-mail'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="email" id="email" maxlength="100" validate="email">
						</div>
					</div>
					<div class="form-group" id="item-partner_kep_adress">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59876.kep adresi'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="partner_kep_adress" id="partner_kep_adress" maxlength="100" validate="email">
						</div>
					</div>
					<div class="form-group" id="item-homepage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30179.İnternet'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="homepage" id="homepage" value="#get_company.homepage#" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-partner_kep_adress">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59876.kep adresi'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="partner_kep_adress" id="partner_kep_adress" maxlength="100" validate="email">
						</div>
					</div>
					<div class="form-group" id="item-adres">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58723.Adres'></label>
						<div class="col col-8 col-xs-12">
							<input type="hidden" name="counter" id="counter">
							<textarea name="adres" id="adres" style="width:150px;height:50px;"><cfoutput>#get_company.company_address#</cfoutput></textarea>
						</div>
					</div>
					<div class="form-group" id="item-country">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
						<div class="col col-8 col-xs-12">
							<select name="country" id="country" onchange="LoadCity(this.value,'city_id','county_id',0)">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_country">
									<option value="#country_id#" <cfif get_company.country eq country_id>selected</cfif>>#country_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-city_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
						<div class="col col-8 col-xs-12">
							<select name="city_id" id="city_id" onchange="LoadCounty(this.value,'county_id','telcod')">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfquery name="GET_CITY" datasource="#DSN#">
									SELECT CITY_ID,CITY_NAME FROM SETUP_CITY <cfif len(get_company.country)>WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.country#"></cfif>
								</cfquery>
								<cfoutput query="GET_CITY">
									<option value="#city_id#" <cfif get_company.city eq city_id>selected</cfif>>#city_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-county_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.Ilce'></label>
						<div class="col col-8 col-xs-12">
							<select name="county_id" id="county_id" <cfif x_district_address_info eq 1>onChange="LoadDistrict(this.value,'district_id');"</cfif>>
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfquery name="GET_COUNTY" datasource="#DSN#">
									SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY <cfif len(get_company.city)>WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.city#"></cfif>
								</cfquery>
								<cfoutput query="get_county">
									<option value="#county_id#" <cfif get_company.county eq county_id>selected</cfif>>#county_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<cfif x_district_address_info eq 1>
					<div class="form-group" id="item-district_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'></label>
						<div class="col col-8 col-xs-12">
							<select name="district_id" id="district_id" onchange="get_ims_code();">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							</select>
						</div>
					</div>
					</cfif>
					<div class="form-group" id="item-semt">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58132.Semt'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="semt" id="semt" value="#get_company.semt#" maxlength="45">
						</div>
					</div>
					<div class="form-group" id="item-postcod">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="postcod" id="postcod" maxlength="15" value="#get_company.company_postcode#">
						</div>
					</div>
					<div class="form-group" id="item-resource">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58830.İlişki Şekli'></label>
						<div class="col col-8 col-sm-12">
							<cf_wrk_combo 
								name="resource"
								query_name="GET_PARTNER_RESOURCE"
								value=""
								option_name="resource"
								option_value="resource_id"
								width="150">
						</div>                
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>

<script type="text/javascript">
	<cfif isdefined("is_tc_number")>
		var is_tc_number = '<cfoutput>#is_tc_number#</cfoutput>';
	<cfelse>
		var is_tc_number = 0;
	</cfif>
	function remove_adress(parametre)
	{
		if(parametre==1)
		{
			document.add_partner.city_id.value = '';
			document.add_partner.county_id.value = '';
			document.add_partner.telcod.value = '';
		}
		else
		{
			document.add_partner.county_id.value = '';
		}	
	}
	function get_ims_code()
	{
		get_ims_code_ = wrk_safe_query("mr_get_ims_code","dsn",0,document.getElementById('district_id').value);
		get_district_ = wrk_safe_query("mr_get_district","dsn",0,document.getElementById('district_id').value);
		if(get_ims_code_.IMS_CODE !=undefined && get_ims_code_.PART_NAME!=undefined)
		{		
			document.getElementById('semt').value=get_ims_code_.PART_NAME;
			document.getElementById('postcod').value=get_ims_code_.POST_CODE;
		}
		else if (get_district_.PART_NAME != undefined || get_district_.POST_CODE != undefined)
		{
			document.getElementById('semt').value = get_district_.PART_NAME;
			document.getElementById('company_partner_postcode').value = get_district_.POST_CODE;
		}
		else
		{
			document.getElementById('semt').value = '';
			document.getElementById('postcod').value = '';
		}
	}
	function cons_control()
	{
		if(document.getElementById('related_consumer_id') != undefined && document.getElementById('related_consumer_id').value != '' && document.getElementById('related_consumer_name') != undefined && document.getElementById('related_consumer_name').value != '')
		{
			document.getElementById('name').disabled = true;
			document.getElementById('soyad').disabled = true;
		}
	}
	/*function pencere_ac_city()
	{
		
		x = document.add_partner.country.selectedIndex;
		if (document.add_partner.country[x].value == "")
		{
			alert("<cf_get_lang no ='360.İlk Olarak Ülke Seçiniz'>");
		}	
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=add_partner.city_id&field_name=add_partner.city&field_phone_code=add_partner.telcod&country_id=' + document.add_partner.country.value,'small','popup_dsp_city');
		}
		return remove_adress('2');
	}
	
	function pencere_ac(no)
	{
		x = document.add_partner.country.selectedIndex;
		if (document.add_partner.country[x].value == "")
		{
			alert("<cf_get_lang no ='360.İlk Olarak Ülke Seçiniz'>");
		}	
		else if(document.add_partner.city_id.value == "")
		{
			alert("<cf_get_lang no ='361.İl Seçiniz'> !");
		}
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=add_partner.county_id&field_name=add_partner.county&city_id=' + document.add_partner.city_id.value,'small','popup_dsp_county');
			return remove_adress();
		}
	}
	*/
	function reset_level()
	{
		if (td_group.style.display == "none") add_partner.group_id.selectedIndex = 0;
	}
	
	function kontrol_et(compbranch_id)
	{
		if(compbranch_id == 0)
		{
			get_comp_branch = wrk_safe_query("mr_get_comp_branch","dsn",0,document.add_partner.company_id.value);
			if(get_comp_branch.COUNTRY != '')
			{
				document.add_partner.country.value = get_comp_branch.COUNTRY;
				LoadCity(get_comp_branch.COUNTRY,'city_id','county_id',0);
			}
			else
				document.add_partner.country.value = '';
			if(get_comp_branch.CITY != '')
			{
				document.add_partner.city_id.value = get_comp_branch.CITY;
				LoadCounty(get_comp_branch.CITY,'county_id');
			}
			else
				document.add_partner.city_id.value = '';
			if(get_comp_branch.COUNTY != '')
				document.add_partner.county_id.value = get_comp_branch.COUNTY;
			else
				document.add_partner.county_id.value = '';	
			if(get_comp_branch.COMPANY_ADDRESS != '')
				document.add_partner.adres.value = get_comp_branch.COMPANY_ADDRESS;
			else
				document.add_partner.adres.value = '';
			if(get_comp_branch.COMPANY_POSTCODE != '')
				document.add_partner.postcod.value = get_comp_branch.COMPANY_POSTCODE;
			else
				document.add_partner.postcod.value = '';
			if(get_comp_branch.SEMT != '')
				document.add_partner.semt.value = get_comp_branch.SEMT;
			else
				document.add_partner.semt.value = '';
			if(get_comp_branch.COMPANY_TELCODE != '')
				document.add_partner.telcod.value = get_comp_branch.COMPANY_TELCODE;
			else
				document.add_partner.telcod.value = '';
			if(get_comp_branch.COMPANY_TEL1 != '')
				document.add_partner.tel.value = get_comp_branch.COMPANY_TEL1;
			else
				document.add_partner.tel.value = '';
			if(get_comp_branch.COMPANY_FAX != '')
				document.add_partner.fax.value = get_comp_branch.COMPANY_FAX;
			else
				document.add_partner.fax.value = '';
		}
		else
		{
			get_company_branch = wrk_safe_query("mr_get_company_branch","dsn",0,compbranch_id);
			if(get_company_branch.COUNTRY_ID != '')
			{
				document.add_partner.country.value = get_company_branch.COUNTRY_ID;
				LoadCity(get_company_branch.COUNTRY_ID,'city_id','county_id',0);
			}
			else
				document.add_partner.country.value = '';
			if(get_company_branch.CITY_ID != '')
			{
				document.add_partner.city_id.value = get_company_branch.CITY_ID;
				LoadCounty(get_company_branch.CITY_ID,'county_id',0);
			}
			else
				document.add_partner.city_id.value = '';
			if(get_company_branch.COUNTY_ID != '')
				document.add_partner.county_id.value = get_company_branch.COUNTY_ID;
			else
				document.add_partner.county_id.value = '';	
			if(get_company_branch.COMPBRANCH_ADDRESS != '')
				document.add_partner.adres.value = get_company_branch.COMPBRANCH_ADDRESS;
			else
				document.add_partner.adres.value = '';
			if(get_company_branch.COMPBRANCH_POSTCODE != '')
				document.add_partner.postcod.value = get_company_branch.COMPBRANCH_POSTCODE;
			else
				document.add_partner.postcod.value = '';
			if(get_company_branch.SEMT != '')
				document.add_partner.semt.value = get_company_branch.SEMT;
			else
				document.add_partner.semt.value = get_company_branch.SEMT;
			if(get_company_branch.COMPBRANCH_TELCODE != '')
				document.add_partner.telcod.value = get_company_branch.COMPBRANCH_TELCODE;
			else
				document.add_partner.telcod.value = '';
			if(get_company_branch.COMPBRANCH_TEL1 != '')
				document.add_partner.tel.value = get_company_branch.COMPBRANCH_TEL1;
			else
				document.add_partner.tel.value = '';
			if(get_company_branch.COMPBRANCH_FAX != '')
				document.add_partner.fax.value = get_company_branch.COMPBRANCH_FAX;
			else
				document.add_partner.fax.value = '';
		}
	}	
	
	function kontrol()
	{	
		if(!$("#name").val().length)
		{
			alert('<cf_get_lang dictionary_id="58194.Girilmesi Zorunlu Alan"> : <cf_get_lang dictionary_id ="57631.Ad">'); 
			return false;
		}
		if(!$("#soyad").val().length)
		{
			alert('<cf_get_lang dictionary_id="58194.Girilmesi Zorunlu Alan"> : <cf_get_lang dictionary_id ="58726.Soyad">');
			return false;
		}
		if(!$("#telcod").val().length)
		{
			alert('<cf_get_lang dictionary_id="58194.Girilmesi Zorunlu Alan"> : <cf_get_lang dictionary_id ="55932.Kod/Telefon">');   
			return false;
		}
		control_ifade_ = $('#password').val();
		if ($('#password').val().indexOf(" ") != -1)
		{
			alert("<cf_get_lang dictionary_id='38682.Şifre boşluk karakterini içeremez.'>");
			$('#password').focus();
			return false;
		}
		if(($('#username').val() != "") && ($('#password').val() != "") && ($('#username').val() == $('#password').val()))
		{
			alert("<cf_get_lang dictionary_id='30952.Şifre Kullanıcı Adıyla Aynı Olamaz !'>s");
			$('#password').focus();
			return false;
		}
		if ($('#password').val() != "")
		{
			<cfif get_password_style.recordcount>
			
				var number="0123456789";
				var lowercase = "abcdefghijklmnopqrstuvwxyz";
				var uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
				var ozel="!]'^%&([=?_<£)#$½{\|.:,;/*-+}>";
				var containsNumberCase = contains(control_ifade_,number);
				var containsLowerCase = contains(control_ifade_,lowercase);
				var containsUpperCase = contains(control_ifade_,uppercase);
				var ozl = contains(control_ifade_,ozel);
				
				<cfoutput>
					if(control_ifade_.length < #get_password_style.password_length#)
					{
						alert("<cf_get_lang dictionary_id='30949.Şifre Karakter Sayısı Az'>! <cf_get_lang dictionary_id='30951.Şifrede Olması Gereken Karakter Sayısı'> : #get_password_style.password_length#");
						document.getElementById('password').focus();				
						return false;
					}
					
					if(#get_password_style.password_number_length# > containsNumberCase)
					{
						alert("<cf_get_lang dictionary_id = '30948.Şifrede Olması Gereken Rakam Sayısı'> : #get_password_style.password_number_length#");
						document.getElementById('password').focus();
						return false;
					}
					
					if(#get_password_style.password_lowercase_length# > containsLowerCase)
					{
						alert("<cf_get_lang dictionary_id = '30947.Şifrede Olması Gereken Küçük Harf Sayısı'> :#get_password_style.password_lowercase_length#");
						document.getElementById('password').focus();				
						return false;
					}
					
					if(#get_password_style.password_uppercase_length# > containsUpperCase)
					{
						alert("<cf_get_lang dictionary_id = '30946.Şifrede Olması Gereken Büyük Harf Sayısı'> : #get_password_style.password_uppercase_length#");
						document.getElementById('password').focus();
						return false;
					}
					
					if(#get_password_style.password_special_length# > ozl)
					{
						alert("<cf_get_lang dictionary_id = '30945.Şifrede Olması Gereken Özel Karakter Sayısı'> : #get_password_style.password_special_length#");
						document.getElementById('password').focus();
						return false;
					}
				</cfoutput>
			</cfif>
		}

		<cfif isDefined('is_mission_required') and is_mission_required eq 1>
			if(document.getElementById('mission').value == '')
			{
				alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57573.Görev'>");
				document.getElementById('mission').focus();
				return false;	
			}
		</cfif>
		if(document.getElementById('name').disabled == true)
		{
			document.getElementById('name').disabled = false;
			document.getElementById('soyad').disabled = false;
		}
		if(document.getElementById('related_consumer_id') != undefined && document.getElementById('related_consumer_id').value != '' &&document.getElementById('related_consumer_name') != undefined && document.getElementById('related_consumer_name').value != '')
		{
			get_consumer =  wrk_query("SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID = "+document.getElementById("company_id").value+" AND RELATED_CONSUMER_ID = "+document.getElementById('related_consumer_id').value,"dsn","1");
			if(get_consumer.recordcount != 0)
			{
				alert("<cf_get_lang dictionary_id='59905.Eklenen Bireysel Üye Çalışanlarda Mevcut'>!");
				return false;
			}
		}
		if(is_tc_number == 1)
		{
			if(!isTCNUMBER(document.add_partner.tc_identity)) return false;
		}
		if(document.add_partner.tc_identity.value != "")
		{
			if(document.add_partner.tc_identity.value.length != 11)
				{
					alert("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='30574.TC Kimlik Numarası - 11 Hane'> !");
					return false;
				}
		}		
		if (document.add_partner.imcat_id.selectedIndex != -1)
			var imcat = document.add_partner.imcat_id.selectedIndex;
		else
			var imcat = 0;
		if(document.add_partner.imcat_id[imcat].value != 0)
		{
			if(document.add_partner.im.value.length == 0)
				{
					alert("<cf_get_lang dictionary_id='57425.uyarı'>: <cf_get_lang dictionary_id='30738.IMessege 1 Kategorisi seçilmiş fakat Instant Mesaj 1 adresi girilmemiş'> !");
					document.add_partner.im.focus();
					return false;
				}
		}
		var imcat2 = document.add_partner.imcat2_id.selectedIndex;
		if(document.add_partner.imcat2_id[imcat2].value != 0)
		{
			if(document.add_partner.im2.value.length == 0)
				{
					alert("<cf_get_lang dictionary_id='57425.uyarı'>: <cf_get_lang dictionary_id='30739.IMessege 2 Kategorisi seçilmiş fakat Instant Mesaj 2 adresi girilmemiş'> !");
					document.add_partner.im2.focus();
					return false;
				}
		}
		x = document.add_partner.language_id.selectedIndex;
		if (document.add_partner.language_id[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='30333.Kullanıcı İçin Dil Seçmediniz !'>");
			return false;
		}
	
		x = (200 - document.add_partner.adres.value.length);
		if ( x < 0)
		{ 
			alert ("<cf_get_lang dictionary_id='58723.Adres'><cf_get_lang dictionary_id='58210.Alanindaki Fazla Karakter Sayisi'>"+ ((-1) * x));
			return false;
		}
		
		y = (document.add_partner.password.value.length);
		if ((document.add_partner.password.value != '')  && ( y < 4 ))
		{ 
			alert ("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='30334.Şifre-En Az Dört Karakter'>");
			return false;
		}
		
		var obj =  document.add_partner.photo.value;
		if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4) == 'gif').toLowerCase() || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png')))
		{
			alert("<cf_get_lang dictionary_id='30335.Lütfen bir resim dosyası(gif,jpg veya png) giriniz!!'>");        
			return false;
		}	
		
			 if(confirm("<cf_get_lang dictionary_id='30313.Girdiğiniz bilgileri kaydetmek üzeresiniz, lütfen değişiklikleri onaylayın'> !")) return true; else return false;	
	}
	function contains(deger,validChars)						
	{
		var sayac=0;				             
		for (i = 0; i < deger.length; i++)
		{
			var char = deger.charAt(i);
			if (validChars.indexOf(char) > -1)    
				sayac++;
		}
		return(sayac);				
    }
	document.getElementById('name').focus();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

