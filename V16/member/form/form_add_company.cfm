<cfscript>
	einvoice_control= createObject("component","V16.e_government.cfc.einvoice");
	einvoice_control.dsn = dsn;
	get_einvoice = einvoice_control.get_einvoice_fnc();
</cfscript>
<cf_xml_page_edit fuseact="member.form_add_company" is_multi_page="1">
<cfset company_cmp = createObject("component","V16.member.cfc.member_company")>
<cfset GET_COMPANY_SECTOR = company_cmp.GET_COMPANY_SECTOR()>
<cfset GET_COMPANY_SIZE = company_cmp.GET_COMPANY_SIZE()>
<cfset GET_COUNTRY = company_cmp.GET_COUNTRY()>
<cfset GET_PARTNER_POSITIONS = company_cmp.GET_PARTNER_POSITIONS()>
<cfset GET_PARTNER_DEPARTMENTS = company_cmp.GET_PARTNER_DEPARTMENTS()>
<cfset PERIODS = company_cmp.PERIODS()>
<cfset GET_CUSTOMER_VALUE = company_cmp.GET_CUSTOMER_VALUE()>
<cfset GET_MEMBER_ADD_OPTIONS = company_cmp.GET_MEMBER_ADD_OPTIONS()>
<cfparam name="attributes.isPopup" default="0">
<cfset SZ = company_cmp.SZ()>
<cfif isdefined('attributes.isModule') and attributes.isModule is 'objects'>
	<cfset attributes.isModule = 'objects'>
<cfelse>
	<cfset attributes.isModule = 'member'>
</cfif>
<cfif not fusebox.circuit eq 'crm' >
	<cf_catalystHeader>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='46974.Üye Ekle'></cfsavecontent>
	<cf_box title="#title#">
		<cfform name="form_add_company" method="post" action="#request.self#?fuseaction=#attributes.isModule#.add_company" enctype="multipart/form-data">
			<cfif isdefined("attributes.type")><input type="hidden" name="type" id="type" value="<cfoutput>#attributes.type#</cfoutput>"></cfif>
			<input type="hidden" name="isModule" id="isModule" value="<cfoutput>#attributes.isModule#</cfoutput>">
			<input type="hidden" name="isPopup" id="isPopup" value="<cfoutput>#attributes.isPopup#</cfoutput>">
			<cfif isDefined("attributes.isClosed") and attributes.isClosed eq 0><input type="hidden" name="isClosed" id="isClosed" value="<cfoutput>#attributes.isClosed#</cfoutput>"></cfif>
					
			<cf_box_elements>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">  
					<div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="company_status">   
						<label class="col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'><input type="checkbox" name="company_status" id="company_status" value="1" tabindex="1"></label>
					</div>
					<div class="form-group col col-1 col-md-2 col-sm-6 col-xs-12" id="item-is_buyer">   
						<label class="col-xs-12"><cf_get_lang dictionary_id='58733.Alıcı'><input type="checkbox" name="is_buyer" id="is_buyer" value="1" tabindex="2"></label>
					</div>
					<div class="form-group col col-1 col-md-2 col-sm-6 col-xs-12" id="item-is_seller">    
						<label class="col-xs-12"><cf_get_lang dictionary_id='58873.Satıcı'><input type="checkbox" name="is_seller" id="is_seller" value="1" tabindex="3"></label>
					</div>
					<div class="form-group col col-1 col-md-2 col-sm-6 col-xs-12" id="item-ispotantial">   
						<label class="col-xs-12"><cf_get_lang dictionary_id='57577.Potansiyel'><input type="checkbox" name="ispotantial" id="ispotantial" value="1" tabindex="4"></label>
					</div>
					<div class="form-group col col-1 col-md-2 col-sm-6 col-xs-12" id="item-is_person">    
						<label class="col-xs-12"><cf_get_lang dictionary_id='30354.Şahıs'><input type="checkbox" name="is_person" id="is_person" value="1" tabindex="5"></label>
					</div>
					<div class="form-group col col-1 col-md-2 col-sm-6 col-xs-12" id="item-is_related_company">    
						<label class="col-xs-12"><cf_get_lang dictionary_id='30559.Bağlı Üye'><input type="checkbox" name="is_related_company" id="is_related_company" value="1" tabindex="6"></label>
					</div>
					<div class="form-group col col-1 col-md-2 col-sm-6 col-xs-12" id="item-is_civil_company">    
						<label class="col-xs-12"><cf_get_lang dictionary_id='41536.Kamu'> <input type="checkbox" name="is_civil" id="is_civil" value="1" tabindex="7"></label>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-fullname">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57571.Unvan'>*</label>
						<div class="col col-8 col-sm-12">
							<input type="text" name="fullname" id="fullname" value="<cfif isdefined("attributes.fullname")><cfoutput>#Left(attributes.fullname,250)#</cfoutput></cfif>" maxlength="250" tabindex="7"> 
						</div>
					</div>
					<div class="form-group" id="item-company_code">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57487.No'></label>
						<div class="col col-8 col-sm-12">
							<input type="text" name="company_code" id="company_code" value="<cfif isdefined("attributes.company_code")><cfoutput>#attributes.company_code#</cfoutput></cfif>" maxlength="50" tabindex="8">
						</div>
					</div>
					<div class="form-group" id="item-nickname">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57751.Kisa Ad'></label>
						<div class="col col-8 col-sm-12">
							<input type="text" name="nickname" id="nickname" value="<cfif isdefined("attributes.nickname")><cfoutput>#Left(attributes.nickname,150)#</cfoutput></cfif>" maxlength="60" tabindex="9">
						</div>
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
						<div class="col col-8 col-sm-12">
							<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0' tabindex="10">
						</div>
					</div>
					<div class="form-group" id="item-companycat_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
						<div class="col col-8 col-sm-12">
							<cfif isdefined("attributes.type")>
								<cf_wrk_selectlang
								name="companycat_id"
								option_name="companycat"
								option_value="companycat_id"
								width="150"
								condition="COMPANYCAT_TYPE = 1"
								sort_type="COMPANYCAT"
								table_name="COMPANY_CAT"
								tabindex="11">
							<cfelse>
								<cfsavecontent variable="text"><cf_get_lang dictionary_id='30269.Sirket Kategorisi Seciniz'></cfsavecontent>
								<cf_wrk_membercat
									name="companycat_id"
									option_text="#text#"
									comp_cons=1
									tabindex="12">
							</cfif>
						</div>
					</div>
					<div class="form-group" id="item-upper_sector_cat">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57579.Sektör'></label>
						<div class="col col-8 col-sm-12">
							<cfif x_is_upper_sector eq 1>
								<div class="input-group">
									<select name="upper_sector_cat" id="upper_sector_cat" tabindex="13" multiple></select>
									<span class="input-group-addon">                       
										<i class="icon-pluss btnPointer show" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=member.popup_list_sectors</cfoutput>&field_name=upper_sector_cat');" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
										<i class="icon-minus btnPointer show" onclick="remove_field('upper_sector_cat');" title="<cf_get_lang dictionary_id='57463.Sil'>"></i>
									</span>
								</div>
							<cfelse>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="57579.Sektör"></cfsavecontent>
								<cf_multiselect_check 
									name="company_sector"
									option_name="sector_cat"
									option_value="sector_cat_id"
									table_name="SETUP_SECTOR_CATS"
									option_text="#message#">
							</cfif>   
						</div>
					</div>
					<div class="form-group" id="item-country">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58219.Ulke'>*</label>
						<div class="col col-8 col-sm-12">
							<select name="country" id="country" tabindex="25" onchange="LoadCity(this.value,'city_id','county_id',0)"> 
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_country">
								<option value="#get_country.country_id#" <cfif get_country.is_default eq 1> selected</cfif>>#get_country.country_name#</option>
								</cfoutput>
							</select>
						</div>              
					</div>
					<div class="form-group" id="item-city_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57971.Sehir'><cfif get_einvoice.recordcount> *</cfif></label>
						<div class="col col-8 col-sm-12">
							<cfif isdefined('attributes.city_id') and len(attributes.city_id)>
								<cfset GET_CITY = company_cmp.GET_CITY()>
								<select name="city_id" id="city_id" tabindex="26" onchange="LoadCounty(this.value,'county_id','telcod')">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="GET_CITY">
										<option value="#city_id#" <cfif city_id eq attributes.city_id>selected</cfif>>#city_name#</option>
									</cfoutput>
								</select>
							<cfelse>
								<select name="city_id" id="city_id" tabindex="27" onchange="LoadCounty(this.value,'county_id','telcod')">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								</select>
							</cfif>
						</div>              
					</div>
					<div class="form-group" id="item-county_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58638.Ilce'><cfif get_einvoice.recordcount> *</cfif></label>
						<div class="col col-8 col-sm-12">
							<select name="county_id" id="county_id" tabindex="28" <cfif x_district_address_info eq 1>onChange="LoadDistrict(this.value,'district_id');"</cfif>>
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>						
								<cfif isdefined('attributes.county_id') and len(attributes.county_id)>
									<cfset GET_COUNTY = company_cmp.GET_COUNTY()>
									<cfoutput query="get_county">
										<option value="#county_id#" <cfif attributes.county_id eq county_id>selected</cfif>>#county_name#</option>
									</cfoutput>
								</cfif>
							</select>
						</div>              
					</div>
					<div class="form-group" id="item-semt">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58132.Semt'>*</label>
						<div class="col col-8 col-sm-12">
							<input type="text" name="semt" id="semt" tabindex="29" value="<cfif isdefined("attributes.semt")><cfoutput>#attributes.semt#</cfoutput></cfif>" maxlength="30"/>
						</div>              
					</div>
					<div class="form-group" id="item-district_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58735.Mahalle'></label>
						<div class="col col-8 col-sm-12">
							<select name="district_id" id="district_id" onchange="get_ims_code();" tabindex="30">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							</select>
						</div>              
					</div>
					<div class="form-group" id="item-postcod">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
						<div class="col col-8 col-sm-12">
							<cfif isDefined('is_postcode_alphanumeric') and is_postcode_alphanumeric eq 1>
								<input type="text" name="postcod" id="postcod" tabindex="31" value="<cfif isdefined("attributes.postcod")><cfoutput>#attributes.postcod#</cfoutput></cfif>" maxlength="8">
							<cfelse>
								<input type="text" name="postcod" id="postcod" onkeyup="isNumber(this);" onblur="isNumber(this);" tabindex="31" value="<cfif isdefined("attributes.postcod")><cfoutput>#attributes.postcod#</cfoutput></cfif>" maxlength="5">
							</cfif>
							
						</div>              
					</div>
					<div class="form-group" id="item-name_">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57631.Ad'>*</label>
						<div class="col col-8 col-sm-12">
							<input type="text" name="name_" id="name_" value="<cfif isdefined("attributes.name")><cfoutput>#attributes.name#</cfoutput></cfif>" maxlength="50" tabindex="46"><input type="hidden" name="company_partner_status" id="company_partner_status" value="1">
						</div>              
					</div>
					<div class="form-group" id="item-soyad">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58726.Soyad'>*</label>
						<div class="col col-8 col-sm-12">
							<input type="text" name="soyad" id="soyad" value="<cfif isdefined("attributes.soyad")><cfoutput>#attributes.soyad#</cfoutput></cfif>" maxlength="50" tabindex="47">
						</div>              
					</div>
					<div class="form-group" id="item-tc_identity">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58025.Tc Kimlik No'></label>
						<div class="col col-8 col-sm-12">
							<cf_wrktcnumber fieldid="tc_identity"  width_info='150' is_verify='1' consumer_name='name_' consumer_surname='soyad' birth_date='birthdate' tc_identity_number='' maxlength="50"> <!--- vergi daire-no girilirse zorunlu değil --->
						</div>              
					</div>
					<div class="form-group" id="item-sex">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
						<div class="col col-8 col-sm-12">
							<select name="sex" id="sex" tabindex="49">
								<option value="1"><cf_get_lang dictionary_id='58959.Erkek'></option>
								<option value="2"><cf_get_lang dictionary_id='58958.Kadin'></option>
							</select>
						</div>              
					</div>
					<div class="form-group" id="item-sales_county">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57659.Satis Bölgesi'> <cfif session.ep.our_company_info.sales_zone_followup eq 1> *</cfif></label>
						<div class="col col-8 col-sm-12">
							<cf_wrk_saleszone
								name="sales_county"
								width="150"
								is_active="1"
								tabindex="58">
						</div>              
					</div>
					<div class="form-group" id="item-customer_value">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58552.Müşteri Değeri'></label>
						<div class="col col-8 col-sm-12">
							<select name="customer_value" id="customer_value" tabindex="59">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_customer_value">
									<option value="#customer_value_id#">#customer_value#</option>
								</cfoutput>
							</select>
						</div>              
					</div>
					<div class="form-group" id="item-company_size_cat_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30170.Sirket Buyuklugu'></label>
						<div class="col col-8 col-sm-12">
							<select name="company_size_cat_id" id="company_size_cat_id" tabindex="60">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_company_size">
									<option value="#company_size_cat_id#">#company_size_cat#</option>
								</cfoutput>
							</select>
						</div>              
					</div>
					<div class="form-group" id="item-startdate">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30448.Uyelik Baslama Tarihi'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input type="text" name="startdate" id="startdate" maxlength="10" tabindex="61">
								<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
							</div>
						</div>              
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-taxoffice">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58762.Vergi Dairesi'></label>
						<div class="col col-8 col-sm-12">
							<input type="text" name="taxoffice" id="taxoffice" maxlength="30" tabindex="14">
						</div>                
					</div>
					<div class="form-group" id="item-taxno">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57752.Vergi No'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input type="text" name="taxno" id="taxno" onkeyup="country_vno(this);" onblur="country_vno(this);" value="<cfif isdefined("attributes.vno")><cfoutput>#attributes.vno#</cfoutput></cfif>"  tabindex="15">
								<cfinclude template="/WEX/gib/internalapi.cfm">
								<cfif is_gib_activate()>
									<span class="input-group-addon">
										<i class="icon-search btnPointer show" onclick="mukellefSorgula()"></i>
									</span>
								</cfif>
							</div>
						</div>                
					</div>
					<div class="form-group" id="item-period_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30172.Muhasebe Dönemi'></label>
						<div class="col col-8 col-sm-12">
							<select name="period_id" id="period_id" tabindex="16">
								<cfoutput query="periods">
									<option value="#periods.period_id#" <cfif session.ep.period_id eq period_id> selected</cfif>>#period#</option>
								</cfoutput>
							</select>
						</div>                
					</div>
					<cfif session.ep.our_company_info.is_efatura eq 1>
					<div class="form-group" id="item-profile_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='59321.Senaryo'></label>
						<div class="col col-8 col-sm-12">
							<select name="profile_id" id="profile_id" tabindex="17">
								<option value=""><cf_get_lang dictionary_id='59321.Senaryo'></option>
								<option value="TEMELFATURA"><cf_get_lang dictionary_id='57067.Temel Fatura'></option>
								<option value="TICARIFATURA"><cf_get_lang dictionary_id='59874.Ticari Fatura'></option>
							</select>
						</div>                
					</div>
					</cfif>
					<cfif xml_show_product_cat eq 1>
					<div class="form-group" id="item-product_category">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57567.Ürün Kategorileri'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<select name="product_category" id="product_category" tabindex="18" multiple></select>
								<span class="input-group-addon">                       
									<i class="icon-pluss btnPointer show" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.popup_list_product_categories&field_name=document.form_add_company.product_category','medium');" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
									<i class="icon-minus btnPointer show" onclick="remove_field('product_category');" title="<cf_get_lang dictionary_id='57463.Sil'>"></i>
								</span>
							</div>
						</div>                
					</div>
					</cfif>
					<div class="form-group" id="item-adres">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58723.Adres'></label>
						<div class="col col-8 col-sm-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30749.Adres Uzunluğu 200 Karakteri Geçemez'></cfsavecontent>
							<textarea name="adres" id="adres" tabindex="33" message="<cfoutput>#message#</cfoutput>" maxlength="200" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"><cfif isdefined("attributes.adres")><cfoutput>#attributes.adres#</cfoutput></cfif></textarea>
						</div>              
					</div>
					<div class="form-group" id="item-homepage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30179.Internet'></label>
						<div class="col col-8 col-sm-12">
							<input type="text" name="homepage" id="homepage" maxlength="50" value="http://" tabindex="34">
						</div>              
					</div>
					<div class="form-group" id="item-email">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57428.e-mail'></label>
						<div class="col col-8 col-sm-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='57428.E-mail'></cfsavecontent>
							<cfif isdefined("attributes.email")>
								<cfinput type="text" name="email" id="email" validate="email" message="#message#" maxlength="100" value="#attributes.email#" tabindex="27">
							<cfelse>
								<cfinput type="text" name="email" id="email" validate="email" message="#message#" maxlength="100" value="" tabindex="35">
							</cfif>
						</div>              
					</div>
					<div class="form-group" id="item-email">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='59876.Kep Adresi'></label>
						<div class="col col-8 col-sm-12">
							<cfif isdefined("attributes.kep_address")>
								<cfinput type="text" name="kep_address" id="kep_address" validate="email" message="#message#" maxlength="100" value="#attributes.kep_address#" tabindex="28">
							<cfelse>
								<cfinput type="text" name="kep_address" id="kep_address" validate="email" message="#message#" maxlength="100" value="" tabindex="35">
							</cfif>
						</div>              
					</div>
					<div class="form-group" id="item-asset2">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58637.Logo'></label>
						<div class="col col-8 col-sm-12">
							<input type="file" name="ASSET2" id="ASSET2" style="width:150px;" tabindex="32">
						</div>              
					</div>
					<div class="form-group" id="item-asset1">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30565.Dış Görünüm'></label>
						<div class="col col-8 col-sm-12">
							<input type="file" name="ASSET1" id="ASSET1" style="width:150px;" tabindex="36">
						</div>              
					</div>
					
					<div class="form-group" id="item-coordinate_1">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58549.Koordinatlar'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<span class="input-group-addon bold"><cf_get_lang dictionary_id='58553.Enlem'></span>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="59875.Lütfen enlem değerini -90 ile 90 arasında giriniz"></cfsavecontent>
								<cfinput type="text" name="coordinate_1" id="coordinate_1"  maxlength="10" range="-90,90" message="#message#" value="" style="width:20px;" tabindex="37">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="59894.Lütfen boylam değerini -180 ile 180 arasında giriniz"></cfsavecontent>
								<span class="input-group-addon bold"><cf_get_lang dictionary_id='58591.Boylam'></span><cfinput type="text" name="coordinate_2" id="coordinate_2" maxlength="10" range="-180,180" message="#message#" value="" style="width:20px;" tabindex="38">
							</div>
						</div>              
					</div>
					<div class="form-group" id="item-birthdate">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input  type="text" tabindex="50" name="birthdate" id="birthdate" maxlength="11">
								<span class="input-group-addon"><cf_wrk_date_image date_field="birthdate"></span>
							</div>
						</div>              
					</div>
					<div class="form-group" id="item-company_partner_email">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57428.e-mail'></label>
						<div class="col col-8 col-sm-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='57428.E-mail'></cfsavecontent>
							<cfinput type="text" name="company_partner_email" id="company_partner_email" validate="email" message="#message#" maxlength="100" tabindex="51">
						</div>              
					</div>
					<div class="form-group" id="item-mobilcat_id_partner">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30254.Kod /Mobil Tel'></label>
						<div class="col col-4 col-sm-12">
							<cfinput type="text" name="mobilcat_id_partner" id="mobilcat_id_partner" maxlength="7" validate="integer" message="#message#" tabindex="52" value="">
						</div>
						<div class="col col-4 col-sm-12">                            
							<input maxlength="20" type="text" name="mobiltel_partner" id="mobiltel_partner" onkeyup="isNumber(this);" onblur="isNumber(this);" tabindex="53" value="<cfif isdefined("attributes.mobiltel")><cfoutput>#attributes.mobiltel#</cfoutput></cfif>">
						</div>              
					</div>
					<div class="form-group" id="item-tel_local">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30259.Dahili'><cf_get_lang dictionary_id='57499.Tel'></label>
						<div class="col col-8 col-sm-12">
							<input type="text" onkeyup="isNumber(this);" onblur="isNumber(this);" name="tel_local" id="tel_local" maxlength="5" tabindex="54">
						</div>              
					</div>
					<div class="form-group" id="item-ims_code_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58134.Mikro Bolge Kodu'> <cfif session.ep.our_company_info.sales_zone_followup eq 1> *</cfif></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input type="hidden" name="ims_code_id" id="ims_code_id">
								<input type="text" name="ims_code_name" tabindex="62" id="ims_code_name" readonly="yes">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&is_form_submitted=1&field_name=form_add_company.ims_code_name&field_id=form_add_company.ims_code_id');"></span>                        
							</div>
						</div>              
					</div>
					<div class="form-group" id="item-resource">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58830.Iliski Sekli'></label>
						<div class="col col-8 col-sm-12">
							<cf_wrk_combo 
								name="resource"
								query_name="GET_PARTNER_RESOURCE"
								option_name="resource"
								option_value="resource_id"
								width="150">
						</div>              
					</div>
					<div class="form-group" id="item-member_add_option_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='30200.Üye Özel Tanımı'></label>
						<div class="col col-8 col-sm-12">
							<cf_wrk_selectlang
								name="member_add_option_id"
								option_name="member_add_option_name"
								option_value="member_add_option_id"
								table_name="SETUP_MEMBER_ADD_OPTIONS"
								width="150"
								sort_type="member_add_option_name"
								tabindex="63">
						</div>              
					</div>
					<div class="form-group" id="item-organization_start_date">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30257.Kuruluş Tarihi'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input type="text" tabindex="64" name="organization_start_date" id="organization_start_date" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="organization_start_date"></span>
							</div>
						</div>              
					</div>
						<div class="form-group" id="item-is_export">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="30348.İhracat Yapıyor"></label>
							<div class="col col-8 col-sm-12">
								<input type="checkbox" tabindex="65" name="is_export" id="is_export" value="1" onclick="gizle_goster(form_ul_is_ihracat_country);" />
							</div>              
						</div>


				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-firm_type">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="30146.Firma Tipi"></label>
						<div class="col col-8 col-sm-12">
							<cf_multiselect_check 
								table_name="SETUP_FIRM_TYPE"  
								name="firm_type"
								option_name="firm_type" 
								option_value="firm_type_id"
								tabindex="19">
						</div>                
					</div>
					<div class="form-group" id="item-ozel_kod">
						<label class="col col-4 col-sm-12"><cfif isdefined("attributes.type")><cf_get_lang dictionary_id='30155.Cari Hesap Kodu'>*<cfelse><cf_get_lang dictionary_id='30337.Ozel Kod 1'></cfif></label>
						<div class="col col-8 col-sm-12">
							<input type="text" name="ozel_kod" id="ozel_kod" tabindex="20" value="<cfif isdefined("attributes.ozel_kod")><cfoutput>#attributes.ozel_kod#</cfoutput></cfif>" <cfif isdefined("attributes.type")>maxlength="10" onKeyup="isNumber(this);"<cfelse> maxlength="75"</cfif>>
						</div>                
					</div>
					<div class="form-group" id="item-ozel_kod_1">
						<label class="col col-4 col-sm-12"><cfif isdefined("attributes.type")><cf_get_lang dictionary_id='58811.Muhasebe Kodu'>*<cfelse><cf_get_lang dictionary_id='30338.Özel Kod 2'></cfif></label>
						<div class="col col-8 col-sm-12">
							<input type="text" name="ozel_kod_1" id="ozel_kod_1" <cfif isdefined("attributes.type")>maxlength="10" onKeyup="isNumber(this);"<cfelse>maxlength="75"</cfif> tabindex="21">
						</div>                
					</div>
					<div class="form-group" id="item-ozel_kod_2">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30343.Özel Kod 3'></label>
						<div class="col col-8 col-sm-12">
							<input type="text" name="ozel_kod_2" id="ozel_kod_2" maxlength="75" tabindex="22">
						</div>                
					</div>
					<cfif x_is_related_brands eq 1>
					<div class="form-group" id="item-related_brand_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30182.İlişkili Markalar'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<select name="related_brand_id" id="related_brand_id" tabindex="23" multiple></select>
								<span class="input-group-addon">                       
									<i class="icon-pluss btnPointer show" onclick="windowopen('<cfoutput>#request.self#?</cfoutput>fuseaction=objects.popup_product_brands&brand_name=document.form_add_company.related_brand_id','medium');" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
									<i class="icon-minus btnPointer show" onclick="remove_field('related_brand_id');" title="<cf_get_lang dictionary_id='57463.Sil'>"></i>
								</span>
							</div>
						</div>                
					</div>
					</cfif>
					<cfif isdefined("attributes.type")>
						<div class="form-group" id="item-glncode">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30725.GLN Kodu'></label>
							<div class="col col-8 col-sm-12">
								<input type="text" name="glncode" id="glncode" tabindex="24" value="" maxlength="13" onkeyup="isNumber(this);">
							</div>                
						</div>
					</cfif>     
					<div class="form-group" id="item-telcod">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30174.Kod/Telefon'>*</label>
						<div class="col col-4 col-sm-12">
							<input maxlength="5" type="text" name="telcod" id="telcod" onkeyup="isNumber(this);" tabindex="38" onblur="isNumber(this);" value="<cfif isdefined("attributes.telcod")><cfoutput>#attributes.telcod#</cfoutput></cfif>">
						</div>
						<div class="col col-4 col-sm-12">                        
							<input maxlength="20" type="text" name="tel1" id="tel1" onkeyup="isNumber(this);" tabindex="39" onblur="isNumber(this);" value="<cfif isdefined("attributes.tel1")><cfoutput>#attributes.tel1#</cfoutput></cfif>">
						</div>              
					</div>
					<div class="form-group" id="item-tel2">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57499.Telefon'>2</label>
						<div class="col col-8 col-sm-12">
							<input validate="integer" maxlength="20" tabindex="40"  type="text" name="tel2" id="tel2" onkeyup="isNumber(this);" onblur="isNumber(this);">
						</div>              
					</div>
					<div class="form-group" id="item-tel3">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57499.Telefon'>3</label>
						<div class="col col-8 col-sm-12">
							<input maxlength="20" type="text" name="tel3" id="tel3" onkeyup="isNumber(this);" onblur="isNumber(this);" tabindex="41">
						</div>              
					</div>
					<div class="form-group" id="item-fax">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57488.Fax'></label>
						<div class="col col-8 col-sm-12">
							<input type="text" name="fax" id="fax" tabindex="42" onkeyup="isNumber(this);" onblur="isNumber(this);" value="<cfif isdefined("attributes.fax")><cfoutput>#attributes.fax#</cfoutput></cfif>" maxlength="10">
						</div>              
					</div>
					<div class="form-group" id="item-mobilcat_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30254.Kod / Mobil'></label>
						<div class="col col-4 col-sm-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='30223.Kod/ Mobil Girmelisiniz'>!</cfsavecontent>
							<cfinput type="text" name="mobilcat_id" tabindex="43" id="mobilcat_id" maxlength="7" validate="integer" message="#message#" value="">
						</div>
						<div class="col col-4 col-sm-12">                        
							<cfif isdefined("attributes.mobiltel")>
								<cfinput type="text" name="mobiltel" tabindex="44" id="mobiltel" maxlength="20" validate="integer" message="#message#" value="#attributes.mobiltel#">
							<cfelse>
								<cfinput type="text" name="mobiltel" tabindex="45" id="mobiltel" maxlength="20" validate="integer" message="#message#" value="">
							</cfif>
						</div>              
					</div> 
					<div class="form-group" id="item-department">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57572.Departman'></label>
						<div class="col col-8 col-sm-12">
							<select name="department" id="department" tabindex="55">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_partner_departments">
									<option value="#partner_department_id#">#partner_department#</option>
								</cfoutput>
							</select>
						</div>              
					</div>
					<div class="form-group" id="item-title">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57571.Unvan'>*</label>
						<div class="col col-8 col-sm-12">
							<input  type="text" name="title" id="title" maxlength="50" tabindex="56">
						</div>              
					</div>
					<div class="form-group" id="item-mission">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57573.Gorev'></label>
						<div class="col col-8 col-sm-12">
							<select name="mission" id="mission" tabindex="57">
								<option value=""><cf_get_lang dictionary_id='57573.Grev'></option>
								<cfoutput query="get_partner_positions">
									<option value="#partner_position_id#">#partner_position#</option>
								</cfoutput>
							</select>                    
						</div>              
					</div>  
					<div class="form-group" id="item-pos_code">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57908.Temsilci'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input type="hidden" name="pos_code" id="pos_code" value="">
								<input type="text" tabindex="66" name="pos_code_text" id="pos_code_text" onfocus="AutoComplete_Create('pos_code_text','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','pos_code','','3','130');" autocomplete="off">	
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&is_form_submitted=1&field_code=form_add_company.pos_code&field_name=form_add_company.pos_code_text<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1');return false"></span>                        
							</div>
						</div>              
					</div>
					<div class="form-group" id="item-hierarchy_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30171.ust Sirket'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input type="hidden" name="hierarchy_id" id="hierarchy_id"  value="">
								<input type="text" name="hierarchy_company" id="hierarchy_company" tabindex="67" onfocus="AutoComplete_Create('hierarchy_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','hierarchy_id','','3','150');" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_form_submitted=1&field_comp_id=form_add_company.hierarchy_id&field_comp_name=form_add_company.hierarchy_company<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=2');return false"></span>                        
							</div>
						</div>              
					</div>
					<div class="form-group" id="item-our_company_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30487.Grup Şirketi'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input type="hidden" name="our_company_id" id="our_company_id" value="">
								<input type="text" tabindex="68" name="our_company_name" id="our_company_name">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_our_companies&field_id=form_add_company.our_company_id&field_name=form_add_company.our_company_name');return false"></span>                        
							</div>
						</div>              
					</div>
					<div class="form-group" id="form_ul_is_ihracat_country" style="display:none;">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="30351.İhracat Yapılan Ülkeler"></label>
						<div class="col col-8 col-sm-12">
							<cf_multiselect_check 
								table_name="SETUP_COUNTRY"  
								name="export_countries"
								option_name="COUNTRY_NAME" 
								option_value="COUNTRY_ID"
								tabindex="69">
						</div>              
					</div>        
				</div>  
			</cf_box_elements>                               
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function="kontrol()">
			</cf_box_footer>        
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	<cfif not isdefined("attributes.city_id") or (isdefined("attributes.city_id") and not len(attributes.city_id))> <!--- CRM den Kurumsal üye ekle denildiğinde Sehir dolmuyordu --->
		var country_ = document.form_add_company.country.value;
		if(country_.length)
			LoadCity(country_,'city_id','county_id',0);
	</cfif>
	<cfif isdefined("attributes.city_id") and len(attributes.city_id)>
		var city_ = document.form_add_company.city_id.value;
			LoadCounty(city_,'county_id','telcod');
	</cfif>
	function country_vno(e){
	 if ($('#country').val()==1)isNumber(e);
	}
	function kontrol()
	{ 
		<cfif isDefined("is_vno_vd_required") and is_vno_vd_required eq 1>
				var get_charnumber = wrk_query("SELECT TC_CHARNUMBER,VKN_CHARNUMBER FROM SETUP_COUNTRY WHERE COUNTRY_ID = "+document.getElementById('country').value,"dsn");
				tc_charnumber=document.getElementById('tc_identity').value;
				vkn_charnumber=document.getElementById('taxno').value;
				if(tc_charnumber.length != get_charnumber.TC_CHARNUMBER && vkn_charnumber.length != get_charnumber.VKN_CHARNUMBER && (get_charnumber.VKN_CHARNUMBER !="" || get_charnumber.TC_CHARNUMBER !=""))
				{
					alert("<cf_get_lang dictionary_id='65102.Kimlik no veya Vergi kimlik No karakter sayısı hatalı'> !");
							return false;   
				}
				if(document.getElementById('tc_identity').value == "" && (document.getElementById('taxoffice').value == "" || document.getElementById('taxno').value == "") && document.getElementById("ispotantial").checked == false)
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58762.Vergi Dairesi'>, <cf_get_lang dictionary_id='57752.Vergi No'> <cf_get_lang dictionary_id='57989.ve'> <cf_get_lang dictionary_id='58025.TC Kimlik No'>!");
					return false;      
				}
			</cfif>
		<cfif get_einvoice.recordcount>
			if(document.getElementById("is_buyer").checked == true || document.getElementById("is_seller").checked == true || document.getElementById("ispotantial").checked == false)
			{
				if(document.getElementById("is_person").checked == true)
				{
					if(document.getElementById('taxno').value != "")
					{
						alert("<cf_get_lang dictionary_id='59878.Şahıs Firmasına Vergi No Giremezsiniz'>!");
						return false;	
					}
				}
				else 
				{
					if((document.getElementById("is_buyer").checked == false || document.getElementById("is_seller").checked == false) && document.getElementById("ispotantial").checked == false)
						{
							if(document.getElementById('taxoffice').value == "" && document.getElementById('country').value == 1)
							{
								alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58762.Vergi Dairesi'>");
								return false;
							}
						}
				}
			}
		</cfif>
		if((document.form_add_company.coordinate_1.value.length != "" && document.form_add_company.coordinate_2.value.length == "") || (document.form_add_company.coordinate_1.value.length == "" && document.form_add_company.coordinate_2.value.length != ""))
		{
			alert ("<cf_get_lang dictionary_id='30292.Lütfen koordinat değerlerini eksiksiz giriniz!'>");
			document.getElementById('wrk_submit_button').disabled = false;
			return false;
		}
		if(document.form_add_company.fullname.value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57571.Ünvan'>!");
			form_add_company.fullname.focus();
			document.getElementById('wrk_submit_button').disabled = false;
			return false;
		}
		x = document.form_add_company.companycat_id.selectedIndex;
		if (document.form_add_company.companycat_id[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30269.Sirket Kategorisi '>!");
			form_add_company.companycat_id.focus();
			document.getElementById('wrk_submit_button').disabled = false;
			return false;
		}
		if(document.getElementById('name_').value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57578.yetkili '> <cf_get_lang dictionary_id='57897.adı '>!");
			document.getElementById('name_').focus();
			document.getElementById('wrk_submit_button').disabled = false;
			return false;
		}
		if(document.form_add_company.soyad.value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57578.yetkili '> <cf_get_lang dictionary_id='58550.soyadı '>!");
			form_add_company.soyad.focus();
			document.getElementById('wrk_submit_button').disabled = false;
			return false;
		}
		<cfif session.ep.our_company_info.sales_zone_followup eq 1>	
			x = document.form_add_company.sales_county.selectedIndex;
			if(document.form_add_company.sales_county[x].value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57659.satış Bölgesi'>!");
				document.getElementById('wrk_submit_button').disabled = false;
				return false;
			}
			if(document.form_add_company.ims_code_id.value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58134.Micro Bölge Kodu'>!");
				document.getElementById('wrk_submit_button').disabled = false;
				return false;
			}		
		</cfif>
		if(document.form_add_company.process_stage.value == "")
		{
			alert("<cf_get_lang dictionary_id='30531.Lütfen Süreçlerinizi Tanımlayınız Ya da Süreçler Üzerinde Yetkiniz Yok'>!");
			document.getElementById('wrk_submit_button').disabled = false;
			return false;
		}
		<cfif isdefined("attributes.type")>
			if(document.form_add_company.glncode.value != '' && document.form_add_company.glncode.value.length != 13)
			{
				alert("<cf_get_lang dictionary_id='30293.GLN Kod Alanı 13 Hane Olmalıdır '>!");
				document.form_add_company.glncode.focus();
				document.getElementById('wrk_submit_button').disabled = false;
				return false;
			}
		
			if(document.form_add_company.telcod.value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30316.Telefon Kodu'> !");
				document.getElementById('wrk_submit_button').disabled = false;
				return false;
			}
			if(document.form_add_company.tel1.value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57499.Telefon'> !");
				document.getElementById('wrk_submit_button').disabled = false;
				return false;
			}
			x = document.form_add_company.country.selectedIndex;
			if (document.form_add_company.country[x].value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58219.Ülke'> !");
				document.getElementById('wrk_submit_button').disabled = false;
				return false;
			}
			if(form_add_company.city_id.value == "")
			{
				alert("<cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='58608.il'>!");
				document.getElementById('wrk_submit_button').disabled = false;
				return false;
			}
			if(form_add_company.county_id.value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58638.İlçe'>!");
				document.getElementById('wrk_submit_button').disabled = false;
				return false;
			}
			if(form_add_company.semt.value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58132.Semt'>!");
				document.getElementById('wrk_submit_button').disabled = false;
				return false;
			}
			if(form_add_company.semt.value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58132.Semt'>!");
				document.getElementById('wrk_submit_button').disabled = false;
				return false;
			}
			<cfif session.ep.our_company_info.sales_zone_followup eq 1>
				if(form_add_company.ims_code_id.value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58134.Micro Bölge Kodu'>!");
					document.getElementById('wrk_submit_button').disabled = false;
					return false;
				}
			</cfif>
			if(form_add_company.ozel_kod.value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30155.Cari Hesap Kodu'>!");
				document.getElementById('wrk_submit_button').disabled = false;
				return false;
			}
			else if(form_add_company.ozel_kod.value.length != 10)
			{
				alert("<cf_get_lang dictionary_id='30155.Cari Hesap Kodu'> <cf_get_lang dictionary_id ='30585.Alanı 10 Karakter Olmalıdır'>!");
				document.getElementById('wrk_submit_button').disabled = false;
				return false;
			}
			if(form_add_company.ozel_kod_1.value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58811.muhasebe Kodu'>!");
				document.getElementById('wrk_submit_button').disabled = false;
				return false;
			}
			else if(form_add_company.ozel_kod_1.value.length != 10)
			{
				alert("<cf_get_lang dictionary_id='57789.Özel Kod'><cf_get_lang dictionary_id ='30585.Alanı 10 Karakter Olmalıdır'>!");
				document.getElementById('wrk_submit_button').disabled = false;
				return false;
			}
			if(form_add_company.title.value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57571.ünvan'>-<cf_get_lang dictionary_id='57585.Kurumsal Üye'>!");
				document.getElementById('wrk_submit_button').disabled = false;
				return false;
			}
					
			if(document.form_add_company.companycat_id.value == 125) // 125 Hedefdeki Holding Urun Tedarikcisi kategorisi 
			{
				var GET_COMPANY = wrk_safe_query('mr_get_company','dsn',0,document.form_add_company.ozel_kod.value);
				if(GET_COMPANY.recordcount)
	
				{
					alert("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='57752.vergi No'> <cf_get_lang dictionary_id='58193.tekrarı'>!");
					document.getElementById('wrk_submit_button').disabled = false;
					return false;
				}
		
				var GET_COMPANY2 = wrk_safe_query('mr_get_company','dsn',0,document.form_add_company.taxno.value);
				if(GET_COMPANY2.recordcount)
				{
					alert("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id ='57752.vergi No'> <cf_get_lang dictionary_id='58193.tekrarı'>!");
					document.getElementById('wrk_submit_button').disabled = false;
					return false;
				}
				
			}
			
			form_add_company.action='<cfoutput>#request.self#?fuseaction=member.add_company_crm</cfoutput>';
		</cfif>	
		<cfif xml_show_product_cat eq 1>
			select_all('product_category');
		</cfif>
		<cfif x_is_related_brands eq 1>
			select_all('related_brand_id');
		</cfif>
		<cfif x_is_upper_sector eq 1>
			select_all('upper_sector_cat');
		</cfif>
		<cfif get_einvoice.recordcount>
			if(document.getElementById('country').value == 1 && document.getElementById('city_id').value == "")
			{
				alert("<cf_get_lang dictionary_id='30499.Lutfen Şehir Seciniz'> !");
				document.getElementById('wrk_submit_button').disabled = false;
				return false;
			}			
			if(document.getElementById('country').value == 1 && document.getElementById('county_id').value == "")
			{
				alert("<cf_get_lang dictionary_id='30538.Lutfen İlce Seciniz'> !");
				document.getElementById('wrk_submit_button').disabled = false;
				return false;
			}
		</cfif>	
		if(process_cat_control())
		{
			if(confirm("<cf_get_lang dictionary_id='30313.Girdiğiniz bilgileri kaydetmek üzeresiniz lütfen değişiklikleri onaylayın'>!")) 
			{
				kontrol_prerecord();
				document.getElementById('wrk_submit_button').disabled = false;
				return false;
			} 
			else 
			{
				document.getElementById('wrk_submit_button').disabled = false;
				return false;
			}
		}
		else 
		{
			document.getElementById('wrk_submit_button').disabled = false;
			return false;
		}
	}
	function kontrol_prerecord()
	{
		//Hedef icin eklendi
		var temp_fullname = form_add_company.fullname.value.replace(/'/g,"");
		var temp_nickname = form_add_company.nickname.value.replace(/'/g,"");
		<cfif isdefined("attributes.type")>
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_company_prerecords&tax_num='+ encodeURIComponent(form_add_company.taxno.value) +'&fullname='+ encodeURIComponent(temp_fullname) +'&nickname=' + encodeURIComponent(temp_nickname) +'&name='+ encodeURIComponent(form_add_company.name.value) +'&surname='+ encodeURIComponent(form_add_company.soyad.value) +'&tel_code='+ form_add_company.telcod.value +'&telefon=' + form_add_company.tel1.value +'&type=1','project');
		<cfelseif session.ep.isBranchAuthorization>
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_company_prerecords&is_store_module=1&tax_num='+ encodeURIComponent(form_add_company.taxno.value) +'&fullname='+ encodeURIComponent(temp_fullname) +'&nickname=' + encodeURIComponent(temp_nickname) +'&name='+ encodeURIComponent(form_add_company.name.value) +'&surname='+ encodeURIComponent(form_add_company.soyad.value) +'&tel_code='+ form_add_company.telcod.value +'&telefon=' + form_add_company.tel1.value,'project');
		<cfelse>
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_company_prerecords&tax_num='+ encodeURIComponent(form_add_company.taxno.value) +'&fullname='+ encodeURIComponent(temp_fullname) +'&nickname=' + encodeURIComponent(temp_nickname) +'&name='+ encodeURIComponent(form_add_company.name.value) +'&surname='+ encodeURIComponent(form_add_company.soyad.value) +'&tel_code='+ form_add_company.telcod.value +'&telefon=' + form_add_company.tel1.value,'project');
		</cfif>
		return false;
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
			document.getElementById('postcod').value = get_district_.POST_CODE;
		}
		else
		{
			document.getElementById('semt').value = '';
			document.getElementById('postcod').value = '';
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
	function remove_field(field_option_name)
	{
		field_option_name_value = document.getElementById(field_option_name);
		for (i=field_option_name_value.options.length-1;i>-1;i--)
		{
			if (field_option_name_value.options[i].selected==true)
			{
				field_option_name_value.options.remove(i);
			}	
		}
	}

	function mukellefSorgula() {
		$("#working_div_main").show();
		let vkn = $("#taxno").val();
		$.ajax("/wex.cfm/customerinfo/mukellefsorgulama",{ 
			method: "POST",
			contentType: "application/json",
			data: JSON.stringify({ mukkelleftip: "tuzel", vkn: vkn })
		}).done(function (d) {
			let jd = JSON.parse(d);
			console.log(jd);
			$("#working_div_main").hide();
			if (jd.status == 0) {
				$('.ui-cfmodal__alert .required_list li').remove();
				$('.ui-cfmodal__alert .required_list').append('<li class="required"><i class="fa fa-terminal"></i>'+jd.message+'</li>');
				$('.ui-cfmodal__alert').fadeIn();
			} else {
				$("#taxoffice").val(jd.result.VERGIDAIRESIADI);
				if ( typeof(jd.result.UNVAN) != "undefined" ) {
					$("#fullname").val(jd.result.UNVAN);
				}
				$("#country").find("option:contains(Türkiye)")[0].selected = true;
				$("#country").change();
				setTimeout(() => {
					let city = $("#city_id").find("option:contains("+jd.result.ISADRESI.ILADI+")");
					if (city.length > 0) {
						$(city)[0].selected = true;
						$("#city_id").change();
						setTimeout(() => {
							let county = $("#county_id").find("option:contains("+jd.result.ISADRESI.ILCEADI+")");
							if (county.length > 0) {
								$(county)[0].selected = true;
								$("#county_id").change();
								setTimeout(() => {
									let district = $("#district_id").find("option:contains("+jd.result.ISADRESI.MAHALLESEMT+")");
									if (district.length > 0) {
										$(district)[0].selected = true;
									}
								}, 1000);
							}
						}, 1000);
					}	
				}, 1000);
				$("#semt").val(jd.result.ISADRESI.MAHALLESEMT);
			}
		})
	}
	
	form_add_company.fullname.focus();

	$("input[name=tc_identity]").attr({"tabindex":"48"});
	$("select[name=resource]").attr({"tabindex":"63"});

</script>

