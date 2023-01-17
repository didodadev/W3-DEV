<cf_xml_page_edit fuseact="member.form_add_company" is_multi_page="1">
<cf_get_lang_set module_name="member"><!--- sayfanin en altinda kapanisi var --->
<cfset cmp = createObject("component","V16.worknet.cfc.worknet_add_member") />
<!---<cfset getMobilcat = cmp.getMobilcat() />--->
<cfset getCountry = cmp.getCountry() />
<cfset getPartnerPositions = cmp.getPartnerPositions() />
<cfset getPartnerDepartments = cmp.getPartnerDepartments() />


<cf_catalystHeader>
<cf_box id="formAdd" closable="0" collapsable="0" title="#getLang(dictionary_id:30366)# #getLang('main',5)# : #getLang('main',2352)#">
	<cfform name="form_add_company" method="post" action="" enctype="multipart/form-data"><!---#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_member_company--->
		<div class="row" type="row">
			<!--- Left --->
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-member_name">
				<label class="col col-3 col-xs-12 control-label"><cf_get_lang dictionary_id='57199.Üye Adı'> *</label>
				<div class='col col-6 col-xs-12'>
					<input type='text' name='fullname' id="fullname"/>
					<!--- <cfinput type="text" name="member_code"	id="member_code" value="#createUUID()#"> --->
					<input type="hidden" name="is_status" id="is_status" value="1">
					<input type="hidden" name="process_stage" id="process_stage" value="1">
				</div>
				</div>
				<div class="form-group" id="item-member_nickname">
				<label class="col col-3 col-xs-12 control-label"><cf_get_lang dictionary_id='38744.Nickname'> *</label>
				<div class='col col-6 col-xs-12'>
					<input type='text' name='nickname' id="nickname"/>
				</div>
				</div>
				<div class="form-group" id="item-tax_office">
				<label class="col col-3 col-xs-12 control-label"><cf_get_lang dictionary_id='58762.Vergi Dairesi'> *</label>
				<div class='col col-6 col-xs-12'>
					<input type='text' name='taxoffice' id="taxoffice" maxlength="30"/>
				</div>
				</div>
				<div class="form-group" id="item-tax_no">
				<label class="col col-3 col-xs-12 control-label">VKN-<cf_get_lang dictionary_id='57752.Vergi No'> *</label>
				<div class='col col-6 col-xs-12'>
					<input type='text' name='taxno' id="taxno" onKeyup="isNumber(this);" onblur="isNumber(this);" value="" maxlength="12">
				</div>
				</div>
				<div class="form-group" id="item-company_partner">
				<label class="col col-3 col-xs-12 control-label"><cf_get_lang_main dictionary_id='57578.Yetkili'><cf_get_lang_main dictionary_id='57570.Ad Soyad'> *</label>
				<div class='col col-6 col-xs-12'>
					<input type="text" name="partner_name" id="partner_name" value="">
				</div>
				</div>
				<div class="form-group" id="item-company_partner">
				<label class="col col-3 col-xs-12 control-label"></label>
				<div class='col col-6 col-xs-12'>
					<input type="text" name="partner_surname" id="partner_surname" value="">
				</div>
				</div>
				<div class="form-group" id="item-partner_email">
				<label class="col col-3 col-xs-12 control-label"><cf_get_lang dictionary_id='33152.Email'> *</label>
				<div class='col col-6 col-xs-12'>
					<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='16.E-mail'></cfsavecontent>
					<cfinput type="text" name="partner_email" id="partner_email" value="" validate="email" message="#message#" maxlength="100">
				</div>
				</div>
				<div class="form-group" id="item-phone1">
					<label class="col col-3 col-xs-12 control-label"><cf_get_lang_main dictionary_id='49272.Tel'> 1 *</label>
					<div class='col col-2 col-xs-4'>
						<input maxlength="5" type="text" name="telcod1" id="telcod1" onKeyup="isNumber(this);" onblur="isNumber(this);" value="">
					</div>
					<div class='col col-4 col-xs-8'>
						<input maxlength="20" type="text" name="tel1" id="tel1" onKeyup="isNumber(this);" onblur="isNumber(this);" value="">
					</div>
				</div>
				<div class="form-group" id="item-phone2">
					<label class="col col-3 col-xs-12 control-label"><cf_get_lang_main dictionary_id='49272.Tel'> 2 *</label>
					<div class='col col-2 col-xs-4'>
						<input maxlength="5" type="text" name="telcod2" id="telcod2" onKeyup="isNumber(this);" onblur="isNumber(this);" value="">
					</div>
					<div class='col col-4 col-xs-8'>
						<input maxlength="20" type="text" name="tel2" id="tel2" onKeyup="isNumber(this);" onblur="isNumber(this);" value="">
					</div>
				</div>
				<div class="form-group" id="item-country">
					<label class="col col-3 col-xs-12 control-label"><cf_get_lang_main no='807.Ulke'> *</label>
					<div class='col col-6 col-xs-12'>
						<select name="country" id="country" onchange="LoadCity(this.value,'city_id','county_id',0)"> 
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="getCountry">
								<option value="#country_id#">#country_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-city">
					<label class="col col-3 col-xs-12 control-label"><cf_get_lang_main no='559.Sehir'> *</label>
					<div class='col col-6 col-xs-12'>
						<select name="city_id" id="city_id" onChange="LoadCounty(this.value,'county_id','telcod')">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-county">
					<label class="col col-3 col-xs-12 control-label"><cf_get_lang_main no='1226.Ilce'> *</label>
					<div class='col col-6 col-xs-12'>
						<select name="county_id" id="county_id">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>						
						</select>
					</div>
				</div>
				<div class="form-group" id="item-post_code">
					<label class="col col-3 col-xs-12 control-label"><cf_get_lang_main no='60.Posta Kodu'> *</label>
					<div class='col col-6 col-xs-12'>
						<input type="text" name="postcod" id="postcod" onKeyup="isNumber(this);" onblur="isNumber(this);" value="" maxlength="5">
					</div>
				</div>
				<div class="form-group" id="item-adress">
					<label class="col col-3 col-xs-12 control-label"><cf_get_lang_main no='1311.Adres'> *</label>
					<div class='col col-6 col-xs-12'>
						<cfsavecontent variable="message"><cf_get_lang no ='611.Adres Uzunluğu 200 Karakteri Geçemez'></cfsavecontent>
						<textarea name="adress" id="adress" style="height:65px;"  message="<cfoutput>#message#</cfoutput>" maxlength="200" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"></textarea>
					</div>
				</div>
				<div class="form-group" id="item-licence">
					<div class="col col-3 col-xs-12"></div>
					<div class="col" style="padding-right:0 !important; margin-right:0 !important; position:right !important;">
						<input name="member_licence" id="member_licence" value="1" type="checkbox">
					</div>
					<label class="col col-8">* <cf_get_lang dictionary_id='34858.Sözleşme Kabul'></label>
				</div>
			</div>
			<div class="col col-4 col-md-6 col-sm-8 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group" id="item-member_code">
					<label class="col col-3 col-xs-12 control-label"><cf_get_lang dictionary_id='58783.Workcube'> <cf_get_lang dictionary_id='57892.Domain'> *</label>
					<div class='col col-6 col-xs-12'>
						<input type='text' name='domain' id="domain" value=""/>
					</div>
				</div>
			</div>
			<!--- --->
		</div>
		<div class="row formContentFooter">
			<div class="form-group" id="item-button">
				<div class='col col-6 col-xs-12'>
					<cf_workcube_buttons is_upd='0' add_function='kontrol()' insert_info="Üye Ol">
				</div>
			</div>
		</div>
	</cfform>
</cf_box>

<!--- 
<table border="0" width="98%" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td class="headbold" height="35"><cf_get_lang_main no='1612.Kurumsal Uye Ekle'></td>
	</tr>
</table>
<table cellpadding="2" cellspacing="1" border="0" width="98%" align="center">
	<tr>
		<td>
		<cfform name="form_add_company" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_member_company" enctype="multipart/form-data">
		<cf_box id="add_company_1" closable="0" collapsable="0">
			<table>
				<tr>
					<td class="txtboldblue" colspan="6" height="20"><cf_get_lang_main no='162.Şirket'></td>
				</tr>
				<tr>
					<td></td>
					<td colspan="2">
						<input type="checkbox" name="is_status" id="is_status" value="1" checked><cf_get_lang_main no='81.Aktif'>
						<input type="checkbox" name="is_potential" id="is_potential" value="1"><cf_get_lang_main no='165.Potansiyel'>
						<input type="checkbox" name="is_related_company" id="is_related_company" value="1"><cf_get_lang no='421.Bağlı Üye'>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='159.Unvan'>*</td>
					<td colspan="3"><input type="text" name="fullname" id="fullname" value="" maxlength="250" style="width:423px;"></td>
					<td><cf_get_lang_main no='339.Kisa Ad'>*</td>
					<td><input type="text" name="nickname" id="nickname" value="" maxlength="150" style="width:150px;"></td>
				</tr>
				<tr>
					<td width="80"><cf_get_lang_main no="1447.Süreç">*</td>
					<td width="175"><cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'></td>
					<td width="90"><cf_get_lang_main no='74.Kategori'>*</td>
					<td width="175"><cfsavecontent variable="text"><cf_get_lang_main no='322.Seciniz'></cfsavecontent>
						<cf_wrk_MemberCat
							name="companycat_id"
							option_text="#text#"
							comp_cons=1>
					</td>
					<td><cf_get_lang_main no='1350.Vergi Dairesi'></td>
					<td><input type="text" name="taxoffice" id="taxoffice" maxlength="30" style="width:150px;"></td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='167.Sektör'></td>
					<td><cfsavecontent variable="text"><cf_get_lang_main no='322.Seçiniz'></cfsavecontent>
						<cf_wrk_selectlang 
							name="company_sector"
							option_name="sector_cat"
							option_value="sector_cat_id"
							width="150"
							table_name="SETUP_SECTOR_CATS"
							option_text="#text#">				
					</td>
					<td><cf_get_lang no="8.Firma Tipi"> <!---*---></td>
					<td><cf_multiselect_check 
							table_name="SETUP_FIRM_TYPE"  
							name="firm_type"
							width="150" 
							option_name="firm_type" 
							option_value="firm_type_id"> 
					</td>
					<td><cf_get_lang_main no='340.Vergi No'></td>
					<td><input type="text" name="taxno" id="taxno" onKeyup="isNumber(this);" onblur="isNumber(this);" value="" maxlength="12" style="width:150px;"></td>
				</tr>
				<tr>
					<td valign="top"><cf_get_lang_main no='155.Ürün Kategorileri'> <!---*---></td>
					<td colspan="5" valign="top">
						<select name="product_category" id="product_category" style="width:430px; height:80px;" multiple></select>
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.popup_list_product_categories&field_name=document.form_add_company.product_category','medium');" title="<cf_get_lang_main no='170.Ekle'>"><img src="/images/plus_list.gif" border="0" align="top" title="<cf_get_lang_main no='170.Ekle'>"></a>
						<a href="javascript://" onClick="remove_field('product_category');" title="<cf_get_lang_main no='51.Ekle'>"><img src="/images/delete_list.gif" border="0" style="cursor=hand" align="top" title="<cf_get_lang_main no='51.Ekle'>"></a>
					</td>
				</tr>
                <tr>
                    <td colspan="9">
                        <cf_wrk_add_info info_type_id="-1" upd_page = "0" colspan="9">
                    </td>
                </tr>
			</table>
		</cf_box>
		<cf_box id="add_company_3" closable="0" collapsable="0">
			<table>
				<tr>
					<td class="txtboldblue" colspan="6" height="20"><cf_get_lang no='265.Adres ve Iletisim'></td>
				</tr>
				<tr>
					<td width="80"><cf_get_lang_main no='807.Ulke'></td>
					<td width="175">
						  <select name="country" id="country" style="width:150px;" onchange="LoadCity(this.value,'city_id','county_id',0)"> 
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="getCountry">
							  <option value="#country_id#" <cfif is_default eq 1> selected</cfif>>#country_name#</option>
							</cfoutput>
						  </select>
					</td>
					<td width="90" rowspan="3" valign="top"><cf_get_lang_main no='1311.Adres'></td>
					<td width="175" rowspan="3">
						<cfsavecontent variable="message"><cf_get_lang no ='611.Adres Uzunluğu 200 Karakteri Geçemez'></cfsavecontent>
						<textarea name="adres" id="adres" style="width:150px; height:65px;" message="<cfoutput>#message#</cfoutput>" maxlength="200" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"><cfif isdefined("attributes.adres")><cfoutput>#attributes.adres#</cfoutput></cfif></textarea>
					</td>
					<td><cf_get_lang no='36.Kod/Telefon'>*</td>
				  	<td width="150" align="right" style="text-align:right;">
						<input maxlength="5" type="text" name="telcod" id="telcod" onKeyup="isNumber(this);" onblur="isNumber(this);" value="" style="width:50px;">
						<input maxlength="20" type="text" name="tel1" id="tel1" onKeyup="isNumber(this);" onblur="isNumber(this);" value="" style="width:85px;">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='559.Sehir'></td>
					<td><select name="city_id" id="city_id" style="width:150px;" onChange="LoadCounty(this.value,'county_id','telcod')">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
						</select>
					</td>
					<td><cf_get_lang_main no='87.Telefon'> 2</td>
					<td width="150" align="right" style="text-align:right;"><input validate="integer" maxlength="20" type="text" name="tel2" id="tel2" onKeyup="isNumber(this);" onblur="isNumber(this);" style="width:90px;"></td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='1226.Ilce'></td>
					<td><select name="county_id" id="county_id" style="width:150px;">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>						
						</select>
					</td>
					<td><cf_get_lang_main no='87.Telefon'>3</td>
					<td width="150" align="right" style="text-align:right;"><input maxlength="20" type="text" name="tel3" id="tel3" onKeyup="isNumber(this);" onblur="isNumber(this);" style="width:90px;"></td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='720.Semt'></td>
					<td><input type="text" name="semt" id="semt" value="<cfif isdefined("attributes.semt")><cfoutput>#attributes.semt#</cfoutput></cfif>" maxlength="30" style="width:150px;" /></td>
					<td><cf_get_lang_main no='60.Posta Kodu'></td>
					<td><input type="text" name="postcod" id="postcod" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfif isdefined("attributes.postcod")><cfoutput>#attributes.postcod#</cfoutput></cfif>" maxlength="5" style="width:150px;"></td>
					<td><cf_get_lang_main no='76.Fax'></td>
					<td width="150" align="right" style="text-align:right;"><input type="text" name="fax" id="fax" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfif isdefined("attributes.fax")><cfoutput>#attributes.fax#</cfoutput></cfif>" maxlength="10" style="width:90px;"></td>
				</tr>
				<tr>
					<td><cf_get_lang no='41.Internet'></td>
					<td><input type="text" name="homepage" id="homepage" style="width:150px;" maxlength="50" value="http://"></td>
					<td><cf_get_lang_main no='16.e-mail'></td>
					<td><cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='16.E-mail'></cfsavecontent>
						<cfinput type="text" name="email" id="email" validate="email" message="#message#" maxlength="100" style="width:150px;" value="">
					</td>
					<td><cf_get_lang no='116.Kod / Mobil'></td>
					<td width="150" align="right" style="text-align:right;">
						<!---<select name="mobilcat_id" id="mobilcat_id" style="width:50px;" >
							<option value=""><cf_get_lang_main no='1173.Kod'></option>
							<cfoutput query="getMobilcat">
								<option value="#mobilcat#">#mobilcat#</option>
							</cfoutput>
						</select>--->
                        <input maxlength="5" type="text" name="mobilcat_id" id="mobilcat_id" onKeyup="isNumber(this);" onblur="isNumber(this);" value="" style="width:50px;">
						<cfinput type="text" name="mobiltel" id="mobiltel" maxlength="20" onKeyup="isNumber(this);" onblur="isNumber(this);" style="width:85px;" value="">
					</td>
				</tr>
			</table>
		</cf_box>
		<cf_box id="add_company_2" closable="0" collapsable="0">
			<table>
				<tr>
					<td class="txtboldblue" colspan="6" height="20"><cf_get_lang_main no='166.Yetkili'></td>
				</tr>
				<tr>
					<td width="80"><cf_get_lang_main no='219.Ad'>*</td>
					<td width="175"><input type="text" name="name" id="name" value="<cfif isdefined("attributes.name")><cfoutput>#attributes.name#</cfoutput></cfif>" maxlength="50" style="width:150px;"><input type="hidden"></td>
					<td width="90"><cf_get_lang_main no='1314.Soyad'>*</td>
					<td width="175"><input type="text" name="soyad" id="soyad" value="<cfif isdefined("attributes.soyad")><cfoutput>#attributes.soyad#</cfoutput></cfif>" maxlength="50" style="width:150px;"></td>
					<td><cf_get_lang_main no='613.TC Kimlik No'> </td>
					<td><cf_wrkTcNumber fieldId="tc_identity" tc_identity_required="0" width_info='145' is_verify='0' consumer_name='name' consumer_surname='soyad' birth_date='birthdate'></td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='159.Unvan'></td>
					<td><input  type="text" name="title" id="title" style="width:150px;" maxlength="50"></td>
					<td><cf_get_lang_main no='16.e-mail'> *</td>
					<td><cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='16.E-mail'></cfsavecontent>
						<cfinput type="text" name="company_partner_email" id="company_partner_email" validate="email" message="#message#" maxlength="100" style="width:150px;">
					</td>
					<td><cf_get_lang_main no='140.Şifre'></td>
					<td><input type="Password" name="password" id="password" style="width:145px;" maxlength="16"></td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='160.Departman'></td>
					<td><select name="department" id="department" style="width:150px;">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="getPartnerDepartments">
								<option value="#partner_department_id#">#partner_department#</option>
							</cfoutput>
						</select>
					</td>
					<td><cf_get_lang_main no='161.Gorev'></td>
					<td><select name="mission" id="mission" style="width:150px;">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="getPartnerPositions">
								<option value="#partner_position_id#">#partner_position#</option>
							</cfoutput>
						</select>
					</td>
					<td><cf_get_lang no='116.Kod /Mobil Tel'></td>
					<td><!---<select name="mobilcat_id_partner" id="mobilcat_id_partner" style="width:55px;">
							<option value=""><cf_get_lang_main no='1173.Kod'></option>
							<cfoutput query="getMobilcat">
								<option value="#mobilcat#">#mobilcat#</option>
							</cfoutput>
						</select>--->
                        <input maxlength="5" type="text" name="mobilcat_id_partner" id="mobilcat_id_partner" onKeyup="isNumber(this);" onblur="isNumber(this);" value="" style="width:55px;">
						<input maxlength="20" type="text" name="mobiltel_partner" id="mobiltel_partner" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfif isdefined("attributes.mobiltel")><cfoutput>#attributes.mobiltel#</cfoutput></cfif>" style="width:85px;">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='352.Cinsiyet'></td>
					<td><select name="sex" id="sex" style="width:150px;">
							<option value="1"><cf_get_lang_main no='1547.Erkek'></option>
							<option value="2"><cf_get_lang_main no='1546.Kadin'></option>
						</select>
					</td>
					<td colspan="2"></td>
					<td><cf_get_lang no='121.Dahili'><cf_get_lang_main no='87.Tel'></td>
					<td>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="text" onKeyup="isNumber(this);" onblur="isNumber(this);" name="tel_local" id="tel_local" maxlength="5" style="width:86px;">
					</td>
				</tr>
			</table>
		</cf_box>
		<cf_box id="add_company_4" closable="0" collapsable="0">
			<table>
				<tr>
					<td class="txtboldblue" colspan="6" height="20"><cf_get_lang no="11.Profil Bilgileri"></td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='1225.Logo'></td>
					<td><input type="file" name="ASSET1" id="ASSET1" style="width:150px;"></td>
				</tr>
				<tr>
					<td><cf_get_lang no='119.Kuruluş Tarihi'></td>
					<td><cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='119.Kuruluş Tarihi'>!</cfsavecontent>
						<cfinput type="text" name="organization_start_date" id="organization_start_date" value="" validate="#validate_style#" message="#message#" style="width:65px; float:left; margin-right:5px;">
						<cf_wrk_date_image date_field="organization_start_date">
					</td>
				</tr>
                <tr>
                    <td style="text-align:left; width:532px;" colspan="2" >
                        <img src="../documents/templates/worknet/tasarim/dil_icon_3.png" width="18" height="14" alt="TR" align="top" style="padding-right:200px; padding-left:84px;"  >
                        	<img src="../documents/templates/worknet/tasarim/dil_icon_1.png" width="18" height="14" alt="ENG" align="top" onclick="gizle_goster_detail('profile_eng')" >
                        <img src="../documents/templates/worknet/tasarim/dil_icon_2.png" width="18" height="14" alt="SPA" align="top" onclick="gizle_goster_detail('profile_spa')" >
                    </td>
            	</tr>
				<tr id="profile_tr">
                    <td width="80" valign="top"><cf_get_lang_main no="1708.Şirket Profili"></td>
					<td>
						<textarea 
							name="company_detail" id="company_detail" 
							style="width:500px; height:120px;" maxlenght="1500"
							onChange="counter(this.id,'detailLen');return ismaxlength(this);"
							onkeydown="counter(this.id,'detailLen');return ismaxlength(this);" 
							onkeyup="counter(this.id,'detailLen');return ismaxlength(this);" 
							onBlur="return ismaxlength(this);"	
							></textarea>
						<input type="text" name="detailLen"  id="detailLen" size="1"  style="width:40px;" value="1500" readonly />
					</td>
				</tr>
                <tr id="profile_eng" style="display:none">
                    <td width="80" valign="top"><cf_get_lang_main no="1708.Şirket Profili"> <img src="../documents/templates/worknet/tasarim/dil_icon_1.png" width="18" height="14" alt="TR" align="top" ></td>
                    <td>	
                        <textarea 
                            name="company_detail_eng" id="company_detail_eng" 
                            style="width:500px; height:120px;" maxlenght="1500"
                            onChange="counter(this.id,'detailLen_eng');return ismaxlength(this);"
                            onkeydown="counter(this.id,'detailLen_eng');return ismaxlength(this);" 
                            onkeyup="counter(this.id,'detailLen_eng');return ismaxlength(this);" 
                            onBlur="return ismaxlength(this);"	
                            ></textarea>
                        <input type="text" name="detailLen_eng"  id="detailLen_eng" size="1"  style="width:40px;" value="1500" readonly />
                    </td>
                </tr>
            <tr style="display:none" id="profile_spa">
				<td width="80" valign="top"><cf_get_lang_main no="1708.Şirket Profili"><img src="../documents/templates/worknet/tasarim/dil_icon_2.png" width="18" height="14" alt="TR" align="top" ></td>
                <td>	
					<textarea 
						name="company_detail_spa" id="company_detail_spa" 
						style="width:500px; height:120px;" maxlenght="1500"
						onChange="counter(this.id,'detailLen_spa');return ismaxlength(this);"
						onkeydown="counter(this.id,'detailLen_spa');return ismaxlength(this);" 
						onkeyup="counter(this.id,'detailLen_spa');return ismaxlength(this);" 
						onBlur="return ismaxlength(this);"	
						></textarea>
					<input type="text" name="detailLen_spa"  id="detailLen_spa" size="1"  style="width:40px;" value="1500" readonly />
				</td>
			</tr>
			</table>
		</cf_box>
		<table>
			<tr>
				<td width="600"></td>
				<td><cf_workcube_buttons is_upd='0' add_function="kontrol()"></td>
			</tr>
		</table>
		</cfform>
	  </td>
	</tr>
</table> --->

<script type="text/javascript">
	var country_ = document.form_add_company.country.value;
	if(country_.length)
		LoadCity(country_,'city_id','county_id',0);

/*function remove_field(field_option_name)
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
function select_all(selected_field)
{
	var m = eval("document.form_add_company." + selected_field + ".length");
	for(i=0;i<m;i++)
	{
		eval("document.form_add_company."+selected_field+"["+i+"].selected=true");
	}
}*/

/*function createCode(){
	var rnd1 = Math.floor((Math.random() * 8999) + 1000);
	var rnd2 = Math.floor((Math.random() * 8999) + 1000);
	var rnd3 = Math.floor((Math.random() * 8999) + 1000);
	var rnd4 = Math.floor((Math.random() * 8999) + 1000);
	$("#member_code").val(rnd1 + "" + rnd2 + "" + rnd3 + "" + rnd4);
}*/

function compControl() {
	var listParam = document.getElementById('fullname').value + "*" + document.getElementById('nickname').value;
	var get_comp = wrk_safe_query("get_comp_by_name",'dsn',0,listParam);
	if(get_comp.COMPANY_ID != undefined){
		return false;
	}
	else{
		return true;
	}
}
function compParControl() {
	var get_compPar = wrk_safe_query("get_cpar_by_email",'dsn',0,document.getElementById('partner_email').value);
	if(get_compPar.COMPANY_PARTNER_USERNAME != undefined){
		return false;
	}
	else{
		return true;
	}
}
function compDomainControl() {
	var get_compDomain = wrk_safe_query("get_comp_domain",'dsn',0,document.getElementById('domain').value);
	if(get_compDomain.COMPANY_ID != undefined){
		return false;
	}
	else{
		return true;
	}
}

function kontrol()
{
	//select_all('product_category');
	if(document.getElementById('fullname').value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57199.Üye Adı'>!");
		document.getElementById('fullname').focus();
		return false;
	}
	if(document.getElementById('nickname').value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='38744.Nickname'>!");
		document.getElementById('nickname').focus();
		return false;
	}
	if(document.getElementById('domain').value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57892.Domain'>!");
		document.getElementById('domain').focus();
		return false;
	}
	if(document.getElementById('taxoffice').value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58762.Vergi Dairesi'>!");
		document.getElementById('taxoffice').focus();
		return false;
	}
	if(document.getElementById('taxno').value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57752.Vergi No'>!");
		document.getElementById('taxno').focus();
		return false;
	}
	if(document.getElementById('partner_name').value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57578.Yetkili'>!");
		document.getElementById('partner_name').focus();
		return false;
	}
	if(document.getElementById('partner_surname').value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57578.Yetkili'>!");
		document.getElementById('partner_surname').focus();
		return false;
	}
	if(document.getElementById('partner_email').value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='33152.Email'>!");
		document.getElementById('partner_email').focus();
		return false;
	}
	if(document.getElementById('telcod1').value == "" || document.getElementById('tel1').value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='49272.Tel'>1!");
		document.getElementById('telcod1').focus();
		return false;
	}
	if(document.getElementById('telcod2').value == "" || document.getElementById('tel2').value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='49272.Tel'>2!");
		document.getElementById('telcod2').focus();
		return false;
	}
	if(document.getElementById('country').value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='807.Ulke'>!");
		document.getElementById('country').focus();
		return false;
	}
	if(document.getElementById('city_id').value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='559.Sehir'>!");
		document.getElementById('city_id').focus();
		return false;
	}
	if(document.getElementById('county_id').value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1226.Ilce'>!");
		document.getElementById('county_id').focus();
		return false;
	}
	if(document.getElementById('postcod').value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='60.Posta Kodu'>!");
		document.getElementById('postcod').focus();
		return false;
	}
	if(document.getElementById('adress').value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1311.Adres'>!");
		document.getElementById('adress').focus();
		return false;
	}	
	if(document.getElementById('member_licence').checked == false)
	{
		alert("<cf_get_lang dictionary_id='30160.Kabul'>!");
		document.getElementById('member_licence').focus();
		return false;
	}
	if(compParControl() == false){
		alert("Bu E-Posta ile bir kayıt bulunmaktadır. Şifrenizi unuttuysanız üye girişi ekranından şifre hatırlatma sayfasına ulaşabilirsiniz");
		document.getElementById('partner_email').focus();
		return false;
	}
	if(compControl() == false){
		alert("<cf_get_lang_main no='13.uyarı'>:Şirket ünvanı <cf_get_lang_main no='781.tekrarı'>!");
		document.getElementById('fullname').focus();
		return false;
	}
	if(compDomainControl() == false){
		alert("Bu Domain ile bir kayıt bulunmaktadır.");
		document.getElementById('domain').focus();
		return false;
	}
	//createCode();
	/*
	x = document.getElementById('companycat_id').selectedIndex;
	if (document.form_add_company.companycat_id[x].value == ""){ 
		alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='131.Sirket Kategorisi '>!");
		document.getElementById('companycat_id').focus();
		return false;
	}*/
	/*if (document.getElementById('firm_type').value == ""){ 
		alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:Firma Tipi!");
		return false;
	}
	if(document.getElementById('product_category').value == '' ){
		alert("Ürün Kategorisi Seçmelisiniz !");
		document.getElementById('product_category').focus();
		return false;
	}*/
	/*if(document.getElementById('name').value == ""){
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='166.yetkili '> <cf_get_lang_main no='485.adı '>!");
		document.getElementById('name').focus();
		return false;
	}
	if(document.getElementById('soyad').value == ""){
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='166.yetkili '> <cf_get_lang_main no='1138.soyadı '>!");
		document.getElementById('soyad').focus();
		return false;
	}
	if(document.getElementById('tc_identity').value != ""){
		if(!isTCNUMBER(document.getElementById('tc_identity'))) return false;
		if(document.getElementById('tc_identity').value.length != 11)
			{
				alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang no='436.TC Kimlik Numarası - 11 Hane'> !");
				document.getElementById('tc_identity').focus();
				return false;
			}
	}
	if(document.getElementById('company_partner_email').value == ""){
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='166.yetkili '> <cf_get_lang_main no='16.email '>!");
		document.getElementById('company_partner_email').focus();
		return false;
	}
	if(document.getElementById('company_partner_email').value != ''){
		getMemberEmailCheck = wrk_query("SELECT COMPANY_PARTNER_EMAIL FROM COMPANY_PARTNER WHERE COMPANY_PARTNER_EMAIL = '" + document.getElementById('company_partner_email').value +"'" ,"dsn");
		if(getMemberEmailCheck.COMPANY_PARTNER_EMAIL != undefined)
		{
			alert("Bu E-Posta ile bir kayıt bulunmaktadır. Lütfen yeni bir mail adresi giriniz !");
			document.getElementById('company_partner_email').focus();
			return false;
		}
	}
	if(document.getElementById('telcod').value == ""){
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='178.Telefon Kodu'> !");
		document.getElementById('telcod').focus();
		return false;
	}
	if(document.getElementById('tel1').value == ""){
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='87.Telefon'> !");
		document.getElementById('tel1').focus();
		return false;
	}
	if(document.form_add_company.process_stage.value == ""){
		alert("<cf_get_lang no='393.Lütfen Süreçlerinizi Tanımlayınız Yada Süreçler Üzerinde Yetkiniz Yok'>!");
		return false;
	}*/
	/*if(process_cat_control())
		if(confirm("<cf_get_lang no='175.Girdiğiniz bilgileri kaydetmek üzeresiniz lütfen değişiklikleri onaylayın'>!"));
	else
		return false;*/

return true;
}

/*function gizle_goster_detail(id)
	{
		if(document.getElementById(id).style.display == '' || document.getElementById(id).style.display == 'block' )
		{
			document.getElementById(id).style.display = 'none';
		} else {
			document.getElementById(id).style.display ='';
		}
	}*/

/*function counter(id1,id2)
	 { 
		if (document.getElementById(id1).value.length > 1500) 
		  {
				document.getElementById(id1).value = document.getElementById(id1).value.substring(0, 1500);
				alert("<cf_get_lang_main no='1324.Maksimum Mesaj Karekteri'>: 1500");  
		   }
		else 
			document.getElementById(id2).value = 1500 - (document.getElementById(id1).value.length); 
	 }*/


document.getElementById('fullname').focus();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
