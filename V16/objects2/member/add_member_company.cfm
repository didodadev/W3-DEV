<cfquery name="GET_OPPORTUNITY_TYPE" datasource="#DSN3#">
	SELECT OPPORTUNITY_TYPE_ID, OPPORTUNITY_TYPE FROM SETUP_OPPORTUNITY_TYPE WHERE IS_INTERNET = 1 ORDER BY OPPORTUNITY_TYPE
</cfquery>
<cfinclude template="../query/get_partner_departments.cfm">
<cfinclude template="../query/get_language.cfm">
<cfinclude template="../query/get_mobilcat.cfm">
<cfinclude template="../query/get_company_size.cfm">
<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_company_sector.cfm">
<cfinclude template="../query/get_country.cfm">
<cfform class="mb-0" name="form_add_member" method="post" action="#request.self#?fuseaction=objects2.emptypopup_add_comp_member">
	<input type="hidden" name="interaction_cat" id="interaction_cat" value="<cfif isDefined('attributes.interaction_cat') and len(attributes.interaction_cat)><cfoutput>#attributes.interaction_cat#</cfoutput></cfif>" />
	<input type="hidden" name="is_security" id="is_security" value="<cfif isdefined('attributes.is_security') and attributes.is_security eq 1>1<cfelse>0</cfif>" />
	<cfoutput>
		<cfif isdefined("attributes.is_member_mail") and attributes.is_member_mail eq 1>
			<input type="hidden" name="is_member_mail" id="is_member_mail" value="#attributes.is_member_mail#">
		</cfif>
		<input type="hidden" name="is_potantial" id="is_potantial" value="<cfif isdefined("attributes.is_member_potantial")>#attributes.is_member_potantial#<cfelse>0</cfif>">
		<!--- site xml lerden geliyor,action da kullanılacağı için burda set edildi --->
		<cfif isDefined("attributes.acc_code_start") and len(attributes.acc_code_start)><input type="hidden" name="acc_code_start" id="acc_code_start" value="#attributes.acc_code_start#"></cfif>
		<cfif isDefined("attributes.acc_num_count") and len(attributes.acc_num_count)><input type="hidden" name="acc_num_count" id="acc_num_count" value="#attributes.acc_num_count#"></cfif>
		<cfif isDefined("attributes.installment_process_info") and len(attributes.installment_process_info)><input type="hidden" name="installment_process_info" id="installment_process_info" value="#attributes.installment_process_info#"></cfif>
		<cfif isdefined('attributes.is_member_hierarchy')><input type="hidden" name="is_member_hierarchy" id="is_member_hierarchy" value="#attributes.is_member_hierarchy#" /></cfif>
		<!--- //site xml lerden geliyor,action da kullanılacağı için burda set edildi --->
	</cfoutput>
			<h5 class="mb-3 header-color" style="background-color:none"><cf_get_lang dictionary_id='34518.Kişisel Bilgiler'></h5>
			<div class="row  mt-3">
				<div class="col-md-6">
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57631.Ad'> *</label>
						<input class="form-control" type="text" name="company_partner_name" id="company_partner_name" value="" maxlength="20">
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58726.Soyad'> *</label>
						<input class="form-control" type="text" name="company_partner_surname" id="company_partner_surname" value="" maxlength="20">
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57572.Çalıştığınız Departman'></label>
						<select class="form-control" name="department" id="department">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_partner_departments">
								<option value="#partner_department_id#">#partner_department#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58219.Ülke'></label>
						<select class="form-control" name="part_country" id="part_country" onchange="LoadCity(this.value,'part_city_id','part_county_id');remove_adress('1');">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_country">
								<option value="#get_country.country_id#" <cfif is_default eq 1>selected</cfif>>#get_country.country_name#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58638.İlçe'></label>
						<select class="form-control" name="part_county_id" id="part_county_id">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						</select>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58723.Adres'></label>
						<textarea class="form-control" name="part_address" id="part_address"></textarea>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58079.İnternet'></label>
						<input class="form-control" type="text" name="part_homepage" id="part_homepage" value="" maxlength="50" value="http://">
					</div>
				</div>
				<div class="col-md-6">
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
						<select name="sex" id="sex" class="form-control">
							<option value="1"><cf_get_lang dictionary_id='58959.Erkek'></option>
							<option value="2"><cf_get_lang dictionary_id='58958.Kadin'></option>
						</select>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57428.e-mail'> *</label>
						<input class="form-control" type="text" name="email" id="email" value="" maxlength="50">
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57571.Ünvan'></label>
						<input class="form-control" type="Text" name="company_partner_title" id="company_partner_title">
					</div>
					<div class="form-group">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57971.Şehir'></label>
						<select class="form-control" name="part_city_id" id="part_city_id" onchange="LoadCounty(this.value,'part_county_id')">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						</select>
					</div>
					<label class="font-weight-bold"><cf_get_lang dictionary_id='58585.Kod'>/<cf_get_lang dictionary_id='57499.Telefon'></label>
					<div class="form-row">
						<div class="form-group mb-3 col-md-3">
							<input class="form-control" type="text" name="part_telcode" id="part_telcode"  maxlength="3" onkeyup="isNumber(this);">
						</div>
						<div class="form-group mb-3 col-md-9">
							<input class="form-control" type="text" name="part_tel1" id="part_tel1" maxlength="7" onkeyup="isNumber(this);">
						</div>
					</div>
					<label class="font-weight-bold"><cf_get_lang dictionary_id='58585.Kod'> / <cf_get_lang dictionary_id='58473.Mobil'></label>
					<div class="form-row">
						<div class="form-group mb-3 col-md-3">
							<select class="form-control" name="part_mobilcat_id" id="part_mobilcat_id">
								<option value=""><cf_get_lang dictionary_id='58585.Kod'></option>
								<cfoutput query="get_mobilcat">
									<option value="#mobilcat#">#mobilcat#</option>
								</cfoutput>
							</select>
						</div>
						<div class="form-group mb-3 col-md-9">
							<input class="form-control" type="text" name="part_mobiltel" id="part_mobiltel" value="" maxlength="10" onkeyup="isNumber(this);">
						</div>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57488.Fax'></label>
						<input class="form-control" type="text" name="part_fax" id="part_fax"  value="" onkeyup="isNumber(this);" maxlength="7">
					</div>
				</div>
			</div>
			<h5 class="mb-3 header-color" style="background-color:none"><cf_get_lang dictionary_id='34854.Firma Bilgileri'></h5>
			<div class="row  mt-3">
				<div class="col-md-6">
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57751.Kısa Ad'> *</label>
						<input class="form-control" type="text" name="nickname" id="nickname" value="" maxlength="50">
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57574.Şirket'> *</label>
						<input class="form-control" type="text" name="fullname" id="fullname" value="" maxlength="75">
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58609.Üye Kategorisi'> *</label>
						<select class="form-control" name="companycat_id" id="companycat_id">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_companycat">
								<option value="#companycat_id#">#companycat#
							</cfoutput>
						</select>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57579.Sektör'></label>
						<select class="form-control" name="company_sector" id="company_sector">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_company_sector">
								<option value="#sector_cat_id#">#sector_cat# 
							</cfoutput>
						</select>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='34856.Çalışan Sayısı'></label>
						<select class="form-control" name="company_size_cat_id" id="company_size_cat_id">
							<cfoutput query="get_company_size">
								<option value="#company_size_cat_id#">#company_size_Cat# 
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="col-md-6">
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57752.Vergi Numarası'></label>
						<input class="form-control" type="text" name="tax_no" id="tax_no" onkeyup="isNumber(this);" value="" maxlength="12">
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58762.Vergi Dairesi'></label>
						<input class="form-control" type="text" name="tax_office" id="tax_office" maxlength="30" tabindex="9">
					</div>
					<label class="font-weight-bold"><cf_get_lang dictionary_id='58585.Kod'> / <cf_get_lang dictionary_id='58473.Mobil'></label>
					<div class="form-row">
						<div class="form-group mb-3 col-md-3">
							<select class="form-control" name="mobilcat_id" id="mobilcat_id">
								<option value=""><cf_get_lang dictionary_id='58585.Kod'></option>
								<cfoutput query="get_mobilcat">
									<option value="#mobilcat#">#mobilcat#</option>
								</cfoutput>
							</select>
						</div>
						<div class="form-group mb-3 col-md-9">
							<input class="form-control" type="text" name="mobiltel" id="mobiltel" value="" maxlength="10" onkeyup="isNumber(this);">
						</div>
					</div>
				</div>
			</div>
			<h5 class="mb-3 header-color" style="background-color:none"><cf_get_lang dictionary_id='34556.İletişim Bilgisi'></h5>
			<div class="row  mt-3">
				<div class="col-md-6"> 
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58219.Ülke'> *</label>
						<select class="form-control" name="country" id="country" onchange="LoadCity(this.value,'city_id','county_id',0);remove_adress('1');">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_country">
								<option value="#get_country.country_id#" <cfif is_default eq 1>selected</cfif>>#get_country.country_name#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57971.Şehir'> *</label>
						<select class="form-control" name="city_id" id="city_id" onchange="LoadCounty(this.value,'county_id','telcode')">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						</select>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58638.İlçe'> *</label>
						<select class="form-control" name="county_id" id="county_id">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						</select>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58723.Adres'></label>
						<textarea class="form-control" name="address" id="address"></textarea>
					</div>
					<cfif isdefined('attributes.is_member_help') and attributes.is_member_help eq 1>
						<div class="form-group mb-3">
							<label class="font-weight-bold"><cf_get_lang dictionary_id='57422.Notlar'> *</label>
							<textarea class="form-control" name="app_subject" id="app_subject"></textarea>
						</div>
					</cfif>
					<cfif (isdefined("attributes.is_member_rules") and attributes.is_member_rules eq 1) and (isdefined("attributes.is_member_content") and len(attributes.is_member_content))>
						<cfquery name="GET_ASSET_MEMBER" datasource="#DSN#" maxrows="1">
							SELECT
								ASSET_FILE_NAME
							FROM
								ASSET,
								CONTENT_PROPERTY AS CP
							WHERE
								ASSET.ACTION_SECTION = 'CONTENT_ID' AND
								ASSET.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_member_content#"> AND
								ASSET.PROPERTY_ID = CP.CONTENT_PROPERTY_ID
							ORDER BY 
								ASSET.ACTION_ID
						</cfquery>
						<cfif get_asset_member.recordcount>
							<div class="form-group mb-3">
								<input class="form-control" type="checkbox" name="member_rules" id="member_rules" value="1" />
								<cfoutput><a href="javascript://" onclick="windowopen('#file_web_path#/content/#get_asset_member.asset_file_name#','medium');"></cfoutput>
									<u><cf_get_lang dictionary_id='34858.Kurumsal Üyelik Sozlesmesi'></u>
								</a>
							</div>
						</cfif>
					</cfif>
				</div>
				<div class="col-md-6">
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
						<input class="form-control" type="text" name="postcode" id="postcode" maxlength="5">
					</div>
					<label class="font-weight-bold"><cf_get_lang dictionary_id='58585.Kod'>/<cf_get_lang dictionary_id='57499.Telefon'> *</label>
					<div class="form-row">
						<div class="form-group mb-3 col-md-3">
							<input class="form-control" type="text" name="telcode" id="telcode" value="" maxlength="3" onkeyup="isNumber(this);">
						</div>
						<div class="form-group mb-3 col-md-9">
							<input class="form-control" type="text" name="tel1" id="tel1" value="" maxlength="7" onkeyup="isNumber(this);">
						</div>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57488.Fax'></label>
						<input class="form-control" type="text" name="fax" id="fax" onkeyup="isNumber(this);" maxlength="7">
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58079.İnternet'></label>
						<input class="form-control" type="text" name="homepage" id="homepage" maxlength="50" value="http://">
					</div>
					<cfif isdefined('attributes.is_member_opp') and attributes.is_member_opp eq 1>
						<div class="form-group mb-3">
							<label class="font-weight-bold"><cf_get_lang dictionary_id='34868.İletişime Geçme Nedeniniz'>*</label>
							<select class="form-control" name="opportunity_type_id" id="opportunity_type_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_opportunity_type">
									<option value="#opportunity_type_id#">#opportunity_type#</option>
								</cfoutput>
							</select>
						</div>
						<div class="form-group mb-3">
							<label class="font-weight-bold"><cf_get_lang dictionary_id='57422.Notlar'> *</label>
							<textarea class="form-control" name="opportunity_detail" id="opportunity_detail"></textarea>
						</div>
					</cfif>
				</div>
			</div>
			<cfif isdefined('attributes.is_security') and attributes.is_security eq 1>
				<script type="text/javascript">
					AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.security_capcha_page</cfoutput>','security_capcha_code');
				</script>
				<div id="security_capcha_code" style="display:none;"></div>
			</cfif>
			<div class="draggable-footer">
				<cf_workcube_buttons is_upd='0' add_function="kontrol()" is_insert="1" data_action="V16/objects2/member/cfc/add_member_company:add_company" next_page="javascript:closeBoxDraggable(#attributes.modal_id#)">
			</div>
		
</cfform>
<!--- Üye Giriş Bölümü --->
<script type="text/javascript">
	var cntry_ = document.getElementById('part_country').value;
	if(cntry_.length)
		LoadCity(cntry_,'part_city_id','part_county_id');

	var country_ = document.getElementById('country').value;
		if(country_.length)
		LoadCity(country_,'city_id','county_id',0);
		
	function remove_adress(parametre)
	{
		if(parametre==1)
		{
			document.getElementById('city_id').value = '';
			document.getElementById('county_id').value = '';
			document.getElementById('telcod').value = '';
		}
		else
		{
			document.getElementById('county_id').value = '';
			document.getElementById('county').value = ''; 
		}	
	}
	
	
	function kontrol()
	{		
		if(document.getElementById('company_partner_name').value == "")
		{
			alert("<cf_get_lang dictionary_id ='35611.Lütfen isminizi giriniz!'>");	
			document.getElementById('company_partner_name').focus();
			return false;
		}
		if(document.getElementById('company_partner_surname').value == "")
		{
			alert("<cf_get_lang dictionary_id ='34558.Lütfen soyadınızı giriniz!'>");	
			document.getElementById('company_partner_surname').focus();
			return false;
		}	
		/* var e_mail = document.getElementById('email').value;
		if (((e_mail == '') || (e_mail.indexOf('@') == -1) || (e_mail.indexOf('.') == -1) || (e_mail.length < 6)))
		{ 
			alert("<cf_get_lang dictionary_id='34350.Lütfen geçerli bir e-posta adresi giriniz!'>!");
			document.getElementById('email').focus();
			return false;
		} */				
		if(document.getElementById('nickname').value == "")
		{
			alert("<cf_get_lang dictionary_id ='34860.Lütfen şirketin kısa adını giriniz!'>");	
			document.getElementById('nickname').focus();
			return false;
		}	
		if(document.getElementById('fullname').value == "")
		{
			alert("<cf_get_lang dictionary_id ='34859.Lütfen şirketin adını giriniz!'>");	
			document.getElementById('fullname').focus();
			return false;
		}
		if(document.getElementById('telcode').value == "")
		{
			alert("<cf_get_lang dictionary_id='34342.Lütfen telefon kodu giriniz'>");	
			document.getElementById('telcode').focus();
			return false;
		}	
		if(document.getElementById('tel1').value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='57574.Şirket'> <cf_get_lang dictionary_id='57499.Telefon'> <cf_get_lang dictionary_id='57487.No'>");	
			document.getElementById('tel1').focus();
			return false;
		}						
		x = document.getElementById('companycat_id').selectedIndex;
		if (document.getElementById('companycat_id')[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='34351.Lütfen bir üye kategorisi seçiniz!'>");
			document.getElementById('companycat_id').focus();
			return false;
		}

		<cfif isdefined('attributes.is_member_help') and attributes.is_member_help eq 1>
			if(document.getElementById('app_subject').value == "")
			{
				alert("<cf_get_lang dictionary_id='87.Lütfen üye olma nedenlerinizi yazınız!'>");
				return false;
			}
		</cfif>
		<cfif isdefined('attributes.is_member_opp') and attributes.is_member_opp eq 1>
			if (document.getElementById('opportunity_type_id')[document.getElementById('opportunity_type_id').selectedIndex].value == '')
			{
				alert ("<cf_get_lang dictionary_id='34853.Lütfen fırsat kategorisi seçiniz!'>");
				return false;
			}
			if(document.getElementById('opportunity_detail').value == "")
			{
				alert("<cf_get_lang dictionary_id='87.Lütfen üye olma nedenlerinizi yazınız!'>");
				return false;
			}
		</cfif>
		
		if(document.getElementById('member_rules') != undefined && document.getElementById('member_rules').checked!=true)
		{
			alert ('<cf_get_lang dictionary_id="34857.Üyelik koşullarını kabul ediyorum seçeneğini seçmelisiniz!">');
			return false;
		}
		<cfif isdefined('attributes.is_member_prerecords') and attributes.is_member_prerecords eq 1>
			if(confirm("<cf_get_lang dictionary_id='34807.Girdiğiniz bilgileri kaydetmek üzeresiniz, lütfen değişiklikleri onaylayın!'>")) 
			{
				kontrol_prerecord();
				return false;
			} 
			else 
				return false;
		<cfelse>
			return true;
		</cfif>
	}
	<cfif isdefined('attributes.is_member_prerecords') and attributes.is_member_prerecords eq 1>
		function kontrol_prerecord()
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_check_company_prerecords&tax_no='+ document.getElementById('tax_no').value +'&fullname='+ document.getElementById('fullname').value.replace("'","") +'&nickname=' + document.getElementById('nickname').value.replace("'","") +'&name='+ document.getElementById('company_partner_name').value.replace("'","") +'&surname='+ document.getElementById('company_partner_surname').value.replace("'",""),'project');
			return false;
		}
	</cfif>
</script>
