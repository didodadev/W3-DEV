<cf_get_lang_set module_name="member"><!--- sayfanin en altinda kapanisi var --->
<cfset cmp = createObject("component","V16.worknet.query.worknet_member") />
<!---<cfset getMobilcat = cmp.getMobilcat() />--->
<cfset getCountry = cmp.getCountry() />
<cfset getPartnerPositions = cmp.getPartnerPositions() />
<cfset getPartnerDepartments = cmp.getPartnerDepartments() />
<cfset getCompanyCat = createObject("component","worknet.objects.worknet_objects").getCompanyCat() />
<div class="haber_liste">
	<div class="haber_liste_1">
		<div class="haber_liste_11"><h1><cf_get_lang no='5.Uye Ol'></h1></div>
	</div>
	<cfif isdefined('attributes.content_head_id') and len(attributes.content_head_id)>
		<div class="forum_1">
			<samp style="width:900px;">
				<cfoutput>#createObject("component","worknet.objects.worknet_objects").getContent(content_id:attributes.content_head_id)#</cfoutput>
			</samp>
		</div>
	</cfif>
	<cfform name="form_add_company" id="form_add_company" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_member_company" enctype="multipart/form-data">
		<input type="hidden" name="is_potential" id="is_potential" value="1" />
		<input type="hidden" name="is_status" id="is_status" value="1" />
		<input type="hidden" name="type_" id="type_" value="1" />
		<div class="talep_detay" >
			<div class="talep_detay_1" style="width:905px;">
				<div class="talep_detay_11">
					<!---Şirket--->
					<div class="td_kutu">
						<div class="td_kutu_1"><h2><cf_get_lang_main no='162.Sirket'></h2></div>
						<div class="td_kutu_2">
							<div style="display:none;"><cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'></div>
							<table class="addMemberForm">
								<tr>
									<td><cf_get_lang no='421.Bağlı Üye'></td>
									<td><input type="checkbox" name="is_related_company" id="is_related_company" value="1" <cfif isdefined('attributes.is_related_company') and attributes.is_related_company eq 1>checked</cfif> style="float:left;"></td>
								</tr>
								<tr>
									<td width="110"><cf_get_lang_main no='159.Unvan'>*</td>
									<td colspan="5" style="width:395px;"><input type="text" name="fullname" id="fullname" value="" maxlength="250" style="width:710px;"></td>
									<!---<td width="85"><cf_get_lang_main no='339.Kisa Ad'>*</td>
									<td><input type="text" name="nickname" id="nickname" value="" maxlength="150" style="width:150px;"></td>--->
								</tr>
								<tr>
									<td valign="top" rowspan="4"><cf_get_lang_main no='155.Ürün Kategorileri'><!--- *---></td>
									<td colspan="3" valign="top" rowspan="4" style="width:420px;">
										<select name="product_category" id="product_category" style="width:380px; height:80px;" multiple></select>
										<a href="javascript://" style="margin-left: 10px;margin-top: 5px;" onClick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.popup_list_product_categories&field_name=document.form_add_company.product_category','medium');">
											<img src="../documents/templates/worknet/tasarim/icon_9.png" width="22" height="22" />
										</a>
										<a href="javascript://" style="margin-left: 5px;margin-top: 5px;margin-right: 7px;" onClick="remove_field('product_category');"><img src="../documents/templates/worknet/tasarim/icon_8.png" width="22" height="22" /></a>
									</td>
								</tr>
								<tr valign="top">
									<td><cf_get_lang_main no='74.Kategori'><!---*---></td>
									<td width="176"><cfsavecontent variable="text"><cf_get_lang_main no='322.Seciniz'></cfsavecontent>
										<select name="companycat_id" id="companycat_id" style="width:150px;">
											<!---<option value=""><cf_get_lang_main no='322.Seçiniz'></option>--->
											<cfoutput query="getCompanyCat">
												<option value="#COMPANYCAT_ID#" <cfif COMPANYCAT_ID eq 14>selected</cfif>>#companycat#
											</cfoutput>
										</select>
									</td>
								</tr>
								<tr valign="top">
									<td width="75"><cf_get_lang_main no='167.Sektör'></td>
									<td><cfsavecontent variable="text"><cf_get_lang_main no='322.Seçiniz'></cfsavecontent>
										<cf_wrk_selectlang 
											name="company_sector"
											option_name="sector_cat"
											option_value="sector_cat_id"
											width="150"
											table_name="SETUP_SECTOR_CATS"
											option_text="#text#">				
									</td>
								</tr>
								<tr valign="top">
									<td><cf_get_lang_main no='1350.Vergi Dairesi'> <!---*---></td>
									<td><input type="text" name="vd" id="vd" maxlength="30" style="width:150px;"></td>
								</tr>
								<tr>
									<td width="75"><cf_get_lang no='8.Firma Tipi'> <!---*---></td>
									<td colspan="3"> 
                                    <cf_multiselect_check 
											table_name="SETUP_FIRM_TYPE"  
											name="firm_type"
											width="380" 
											option_name="firm_type" 
											option_value="firm_type_id"> 
									</td>
									<td><cf_get_lang_main no='340.Vergi No'>/<cf_get_lang_main no='613.TC Kimlik No'> *</td>
									<td><input type="text" name="vno" id="vno" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfif isdefined('attributes.vno') and len(attributes.vno)><cfoutput>#attributes.vno#</cfoutput></cfif>" style="width:150px;"></td>
								</tr>
							</table>
						</div>
					</div>
				</div>
				<div class="talep_detay_12">
					<!---Yetkili--->
					<div class="td_kutu">
						<div class="td_kutu_1">
							<h2><cf_get_lang_main no='166.Yetkili'></h2>
						</div>
						<div class="td_kutu_2">
							<table class="addMemberForm">
								<tr>
									<td width="110"><cf_get_lang_main no='219.Ad'>*</td>
									<td width="175"><input type="text" name="name" id="name" value="<cfif isdefined("attributes.name")><cfoutput>#attributes.name#</cfoutput></cfif>" maxlength="50" style="width:150px;"><input type="hidden"></td>
									<td width="90"><cf_get_lang_main no='1314.Soyad'>*</td>
									<td width="185"><input type="text" name="soyad" id="soyad" value="<cfif isdefined("attributes.soyad")><cfoutput>#attributes.soyad#</cfoutput></cfif>" maxlength="50" style="width:150px;"></td>
									<td width="90"><cf_get_lang_main no='613.TC Kimlik No'> </td>
									<td><cf_wrkTcNumber fieldId="tc_identity" tc_identity_required="0" width_info='150' is_verify='0' consumer_name='name' consumer_surname='soyad' birth_date='birthdate'></td>
								</tr>
								<tr>
									<td><cf_get_lang_main no='16.e-mail'> *</td>
									<td><cfsavecontent variable="message"><cf_get_lang_main no='1072.Geçerli bir e-mail adresi girmelisiniz'> </cfsavecontent>
										<cfinput type="text" name="company_partner_email" id="company_partner_email" validate="email" required="yes" message="#message#" maxlength="100" style="width:150px;">
									</td>
									<td><cf_get_lang_main no='140.Şifre'> *</td>
									<td><input type="Password" name="password" id="password" style="width:150px;" maxlength="16"></td>
									<td><cf_get_lang_main no='159.Unvan'></td>
									<td><input  type="text" name="title" id="title" style="width:150px;" maxlength="50"></td>
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
									<td><cf_get_lang_main no='352.Cinsiyet'></td>
									<td><select name="sex" id="sex" style="width:150px;">
											<option value="1"><cf_get_lang_main no='1547.Erkek'></option>
											<option value="2"><cf_get_lang_main no='1546.Kadin'></option>
										</select>
									</td>
								</tr>
								<tr>
									<td><cf_get_lang no='116.Kod /Mobil Tel'></td>
									<td><!---<select name="mobilcat_id_partner" id="mobilcat_id_partner" style="width:55px; margin-right:5px;">
											<option value=""><cf_get_lang_main no='1173.Kod'></option>
											<cfoutput query="getMobilcat">
												<option value="#mobilcat#">#mobilcat#</option>
											</cfoutput>
										</select>--->
                                        <input maxlength="5" type="text" name="mobilcat_id_partner" id="mobilcat_id_partner" onKeyup="isNumber(this);" onblur="isNumber(this);" value="" style="width:50px;">
										<input maxlength="20" type="text" name="mobiltel_partner" id="mobiltel_partner" onKeyup="isNumber(this);" onblur="isNumber(this);" value="" style="width:90px;">
									</td>
									<td><cf_get_lang no='121.Dahili'><cf_get_lang_main no='87.Tel'></td>
									<td>
										<input type="text" onKeyup="isNumber(this);" onblur="isNumber(this);" name="tel_local" id="tel_local" maxlength="5" style="width:90px;">
									</td>
									
								</tr>
							</table>
						</div>
					</div>
				</div>
				<div class="talep_detay_12">
					<!---Adres--->
					<div class="td_kutu">
						<div class="td_kutu_1">
							<h2><cf_get_lang_main no='1311.Adres'><cf_get_lang_main no='577.ve'><cf_get_lang_main no='731.Iletisim'></h2>
						</div>
						<div class="td_kutu_2">
							<table class="addMemberForm">
								<tr>
									<td width="110"><cf_get_lang_main no='807.Ulke'> *</td>
									<td width="175">
										  <select name="country" id="country" style="width:150px;" onchange="LoadCity(this.value,'city_id','county_id',0)"> 
											<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
											<cfoutput query="getCountry">
											  <option value="#country_id#" <cfif is_default eq 1> selected</cfif>>#country_name#</option>
											</cfoutput>
										  </select>
									</td>
									<td width="90" rowspan="3" valign="top"><cf_get_lang_main no='1311.Adres'> *</td>
									<td width="185" rowspan="3">
										<cfsavecontent variable="message"><cf_get_lang no ='611.Adres Uzunluğu 200 Karakteri Geçemez'></cfsavecontent>
										<textarea name="adres" id="adres" style="width:150px; height:65px;" message="<cfoutput>#message#</cfoutput>" maxlength="200" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"></textarea>
									</td>
									<td width="90"><cf_get_lang no='36.Kod/Telefon'>*</td>
									<td width="150" align="right" style="text-align:right;">
										<input maxlength="5" type="text" name="telcod" id="telcod" onKeyup="isNumber(this);" onblur="isNumber(this);" value="" style="width:50px;">
										<input maxlength="20" type="text" name="tel1" id="tel1" onKeyup="isNumber(this);" onblur="isNumber(this);" value="" style="width:90px;">
									</td>
								</tr>
								<tr>
									<td><cf_get_lang_main no='559.Sehir'> *</td>
									<td><select name="city_id" id="city_id" style="width:150px;" onChange="LoadCounty(this.value,'county_id','telcod')">
											<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
										</select>
									</td>
									<td><cf_get_lang_main no='87.Telefon'> 2</td>
									<td width="150" align="right" style="text-align:right;"><input validate="integer" maxlength="20" type="text" name="tel2" id="tel2" onKeyup="isNumber(this);" onblur="isNumber(this);" style="width:90px;"></td>
								</tr>
								<tr>
									<td><cf_get_lang_main no='1226.Ilce'> *</td>
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
									<td align="right" style="text-align:right;"><input type="text" name="fax" id="fax" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfif isdefined("attributes.fax")><cfoutput>#attributes.fax#</cfoutput></cfif>" maxlength="10" style="width:90px;"></td>
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
										<!---<select name="mobilcat_id" id="mobilcat_id" style="width:55px;" >
											<option value=""><cf_get_lang_main no='1173.Kod'></option>
											<cfoutput query="getMobilcat">
												<option value="#mobilcat#">#mobilcat#</option>
											</cfoutput>
										</select>--->
                                        <input maxlength="5" type="text" name="mobilcat_id" id="mobilcat_id" onKeyup="isNumber(this);" onblur="isNumber(this);" value="" style="width:50px;">
                                        <cfinput type="text" name="mobiltel" id="mobiltel" maxlength="20" onKeyup="isNumber(this);" onblur="isNumber(this);" style="width:90px;" value="">
									</td>
								</tr>
							</table>
						</div>
					</div>
				</div>
				<div class="talep_detay_12">
					<!---ek Bilgiler--->
					<div class="td_kutu">
						<div class="td_kutu_1">
							<h2><cf_get_lang no='11.Profil Bilgileri'></h2>
						</div>
						<div class="td_kutu_2">
							<div class="ftd_kutu_23">
								<span style="width:100px;"><cf_get_lang_main no='1225.Logo '></span>
								<cfif isdefined('attributes.info_content_id') and len(attributes.info_content_id)>
									<a href="javascript://" data-width="500px" data-text="<cfoutput>#createObject('component','worknet.objects.worknet_objects').getContent(content_id:attributes.info_content_id)#</cfoutput>" class="tooltip">
										<input type="file" name="asset1" id="asset1" style="float:left; margin-right:5px;">
										<img src="../documents/templates/worknet/tasarim/tooltipIcon.png" />
									</a>
								<cfelse>
									<input type="file" name="asset1" id="asset1" style="float:left;">
								</cfif>
							</div>
							
							<div class="ftd_kutu_23">
								<span style="width:100px;"><cf_get_lang no='12.Tanıtım Videosu'></span>
								<cfif isdefined('attributes.info_content_id_2') and len(attributes.info_content_id_2)>
									<a href="javascript://" data-width="500px" data-text="<cfoutput>#createObject('component','worknet.objects.worknet_objects').getContent(content_id:attributes.info_content_id_2)#</cfoutput>" class="tooltip">
										<input type="file" name="company_video" id="company_video" value="" style="float:left; margin-right:5px;">
										<img src="../documents/templates/worknet/tasarim/tooltipIcon.png" />
									</a>
								<cfelse>
									<input type="file" name="company_video" id="company_video" value="" style="float:left;">
								</cfif>
							</div>
							
							<div class="ftd_kutu_23">
								<span style="width:100px;"><cf_get_lang no='119.Kuruluş Tarihi'></span>
								<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='119.Kuruluş Tarihi'>!</cfsavecontent>
								<cfinput type="text" name="organization_start_date" id="organization_start_date" value="" validate="#validate_style#" message="#message#" style="width:65px; float:left; margin-right:5px;">
								<cf_wrk_date_image date_field="organization_start_date">
							</div>
							<div class="ftd_kutu_23">
								<span style="width:100px;"><cf_get_lang_main no='1708.Şirket Profili'></span>
								<textarea class="kutu_txa_2"
									name="company_detail" id="company_detail" 
									style="width:500px; height:120px;" maxlenght="1500"
									onChange="counter();return ismaxlength(this);"
									onkeydown="counter();return ismaxlength(this);" 
									onkeyup="counter();return ismaxlength(this);" 
									onBlur="return ismaxlength(this);"	
									></textarea>
								<input type="text" name="detailLen"  id="detailLen" size="1"  style="width:35px;" value="1500" readonly />
							</div>
						</div>
					</div>
				</div>
				<div class="talep_detay_3">
                	<div class="sozlesme">
						<div class="sozlesme_1">
							<input type="checkbox" name="contract_rules" id="contract_rules" class="radio_frame" value="1" checked="checked" style="padding-bottom:6px; float:left; margin-right:5px;" />
							<a href="<cfoutput>#request.self#?fuseaction=worknet.detail_content&cid=#attributes.cid#</cfoutput>" target="_blank"><cf_get_lang no='20.Üyelik ve Gizlilik Sözleşmesini Kabul Ediyorum'>*</a>
						</div>
						<div class="sozlesme_1">
							<input type="checkbox" name="not_want_email" id="not_want_email" class="radio_frame" value="1" checked="checked" style="padding-bottom:6px; float:left; margin-right:5px;" />
							<cf_get_lang no='35.Style Turkish bülten ve epostalarını almak istiyorum'>
						</div>
					</div>
					<div class="talep_detay_31" style="float: right;margin-right: 5px;margin-top: 12px;">
						<cfsavecontent variable="message"><cf_get_lang_main no="49.Kaydet"></cfsavecontent>
						<input class="btn_1" type="submit" onclick="return kontrol()" value="<cfoutput>#message#</cfoutput>" />
					</div>
                </div>
			</div>
		</div>
	</cfform>
</div>

<script type="text/javascript">
var country_ = document.getElementById('country').value;
if(country_.length)
	LoadCity(country_,'city_id','county_id',0);

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
function select_all(selected_field)
{
	var m = eval("document.form_add_company." + selected_field + ".length");
	for(i=0;i<m;i++)
	{
		eval("document.form_add_company."+selected_field+"["+i+"].selected=true");
	}
}
function kontrol()
{
	select_all('product_category');
	if(document.getElementById('fullname').value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='159.Ünvan'>");
		document.getElementById('fullname').focus();
		return false;
	}
	
	/*if(document.getElementById('nickname').value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='339.Kisa Ad'>");
		document.getElementById('nickname').focus();
		return false;
	}*/
	
	x = document.getElementById('companycat_id').selectedIndex;
	if (document.form_add_company.companycat_id[x].value == "")
	{ 
		alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='131.Sirket Kategorisi'>");
		document.getElementById('companycat_id').focus();
		return false;
	}	
		
	/*if (document.getElementById('firm_type').value == "")
	{ 
		alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:Firma Tipi!");
		return false;
	}*/
	
	/*if(document.getElementById('product_category').value == '' )
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'> : <cf_get_lang_main no='155.Ürün Kategorileri'> !");
		document.getElementById('product_category').focus();
		return false;
	}*/
	
	/*if(document.getElementById('vd').value == '' )
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'> : <cf_get_lang_main no='1350.Vergi Dairesi'> !");
		document.getElementById('vd').focus();
		return false;
	}*/
	
	if(document.getElementById('vno').value == '' )
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'> : <cf_get_lang_main no='340.Vergi No'> / <cf_get_lang_main no='613.TC Kimlik No'> !");
		document.getElementById('vno').focus();
		return false;
	}
	else if(document.getElementById('companycat_id').value == 4 && document.getElementById('country').value == 1 && (document.getElementById('vno').value.length > 11 || document.getElementById('vno').value.length < 11))
	{
		alert("Vergi no 11 hane olmalıdır!");
		document.getElementById('vno').focus();
		return false;
	}
	else if(document.getElementById('companycat_id').value != 4 && document.getElementById('country').value == 1 && (document.getElementById('vno').value.length > 10 || document.getElementById('vno').value.length < 10))
	{
		alert("Vergi no 10 hane olmalıdır!");
		document.getElementById('vno').focus();
		return false;
	}
	else if(document.getElementById('country').value != 1 && document.getElementById('vno').value.length > 40)
	{
		alert("Vergi no Maksimum karakter sayısı 40 hane olmalıdır!");
		document.getElementById('vno').focus();
		return false;
	}
	
	if(document.getElementById('name').value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='166.yetkili '> <cf_get_lang_main no='485.adı '>!");
		document.getElementById('name').focus();
		return false;
	}
	
	if(document.getElementById('soyad').value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='166.yetkili '> <cf_get_lang_main no='1138.soyadı '>!");
		document.getElementById('soyad').focus();
		return false;
	}
	
	if(document.getElementById('tc_identity').value != "")
	{
		if(!isTCNUMBER(document.getElementById('tc_identity'))) return false;
		if(document.getElementById('tc_identity').value.length != 11)
			{
				alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang no='436.TC Kimlik Numarası - 11 Hane'> !");
				document.getElementById('tc_identity').focus();
				return false;
			}
	}
	if(document.getElementById('company_partner_email').value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='166.yetkili '> <cf_get_lang_main no='16.email '>!");
		document.getElementById('company_partner_email').focus();
		return false;
	}

	var  checkEmail = document.getElementById('company_partner_email').value;
	if (((checkEmail == '') || (checkEmail.indexOf('@') == -1) || (checkEmail.indexOf('.') == -1) || (checkEmail.length < 6)))
	{ 
		alert("<cf_get_lang_main no='1072.Geçerli bir e-mail adresi girmelisiniz'> !");
		document.getElementById('company_partner_email').focus();
		return false;
	}
	
	if(checkEmail != '')
	{
		getMemberEmailCheck = wrk_query("SELECT COMPANY_PARTNER_EMAIL FROM COMPANY_PARTNER WHERE COMPANY_PARTNER_EMAIL = '" + document.getElementById('company_partner_email').value +"'" ,"dsn");
		if(getMemberEmailCheck.COMPANY_PARTNER_EMAIL != undefined)
		{
			alert("Bu E-Posta ile bir kayıt bulunmaktadır. Şifrenizi unuttuysanız üye girişi ekranından şifre hatırlatma sayfasına ulaşabilirsiniz");
			document.getElementById('company_partner_email').focus();
			return false;
		}
	}
	
	y = (document.getElementById('password').value.length);
	if (document.getElementById('password').value == '' || (document.getElementById('password').value != '')  && ( y < 4 ))
	{ 
		alert ("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang no='196.Şifre-En Az Dört Karakter'>");
		document.getElementById('password').focus();
		return false;
	}
	
	if (document.getElementById('country').value == "")
	{ 
		alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>: <cf_get_lang_main no='807.Ulke'> !");
		document.getElementById('country').focus();
		return false;
	}
	if (document.getElementById('city_id').value == "" && document.getElementById('country').value == 1)
	{ 
		alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>: <cf_get_lang_main no='559.Sehir'> !");
		document.getElementById('city_id').focus();
		return false;
	}
	if (document.getElementById('county_id').value == "" && document.getElementById('country').value == 1)
	{ 
		alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>: <cf_get_lang_main no='1226.İlçe'> !");
		document.getElementById('county_id').focus();
		return false;
	}
	if (document.getElementById('adres').value == "")
	{ 
		alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>: <cf_get_lang_main no='1311.Adres'> !");
		document.getElementById('adres').focus();
		return false;
	}
	
	if(document.getElementById('telcod').value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='178.Telefon Kodu'> !");
		document.getElementById('telcod').focus();
		return false;
	}
	
	if(document.getElementById('tel1').value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='87.Telefon'> !");
		document.getElementById('tel1').focus();
		return false;
	}
	
	var obj =  document.getElementById('asset1').value;
	if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png')))
	{
		alert("<cf_get_lang no='197.Lütfen bir resim dosyası(gif,jpg veya png) giriniz!!'>");        
		return false;
	}	
	
	var obj2 =  document.getElementById('company_video').value;
	if ((obj2 != "") && !((obj2.substring(obj2.indexOf('.')+1,obj2.indexOf('.') + 4).toLowerCase() == 'flv')))
	{
		alert("Video flv uzantılı olmalıdır !");        
		return false;
	}
	
	if(document.getElementById('contract_rules').checked!=true)
	{
		alert ("<cf_get_lang no='22.Üyelik ve gizlilik sözleşmesini kabul etmelisiniz'>");
		return false;
	}
	
	if(process_cat_control())
		if(confirm("<cf_get_lang no='175.Girdiğiniz bilgileri kaydetmek üzeresiniz lütfen değişiklikleri onaylayın'>!"));
	else
		return false;
}

function counter()
 { 
	if (document.form_add_company.company_detail.value.length > 1500) 
	  {
			document.form_add_company.company_detail.value = document.form_add_company.company_detail.value.substring(0, 1500);
			alert("<cf_get_lang_main no='1324.Maksimum Mesaj Karekteri'>: 1500"); 
	   }
	else 
		document.getElementById('detailLen').value = 1500 - (document.form_add_company.company_detail.value.length); 
 } 

document.getElementById('fullname').focus();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

