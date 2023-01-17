<cfquery name="GET_COUNTRY" datasource="#DSN#">
	SELECT
		COUNTRY_ID,
		COUNTRY_NAME,
		COUNTRY_PHONE_CODE,
		IS_DEFAULT
	FROM
		SETUP_COUNTRY
	ORDER BY
		COUNTRY_NAME
</cfquery>
<cfquery name="GET_HEAD" datasource="#DSN#">
	SELECT HEADQUARTERS_ID, NAME FROM SETUP_HEADQUARTERS
</cfquery>
<cfif not(isdefined("attributes.callAjax") and len("attributes.callAjax"))>
	<div class="row col col-3 col-md-3 col-sm-12 col-xs-12" type="row">
		<cfsavecontent variable = "company_title"><cf_get_lang dictionary_id="29531.Şirketler"></cfsavecontent>
		<cf_box title="#company_title#" closable="0" collapsed="0">	
			<cfinclude template="../display/list_our_companies.cfm">
		</cf_box>
	</div>
</cfif>
<cfif not(isdefined("attributes.callAjax") and len("attributes.callAjax"))>
	<div class="col col-9 col-md-9 col-sm-12 col-xs-12" id="detail_div">
<cfelse>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">	
</cfif>
<cf_box title="#getLang('settings',207)#" closable="0" collapsed="0" >
	<cfform name="add_company" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_our_company"  enctype="multipart/form-data">
		<cfif isdefined("attributes.isAjax") and len(attributes.isAjax)><!--- Organizasyon Yönetimi sayfasından Ajax ile yüklendiyse --->
			<input type="hidden" name="callAjax" id="callAjax" value="1">		
		</cfif>
		<cf_box_elements>
			<cfoutput>
				<div class="col col-6 col-md-6 col-sm-12 col-xs-12">
					<div class="form-group" id="item-comp_status">
						<label class="col col-4 col-xs-12 font-blue-madison bold"><cf_get_lang_main no='81.Aktif'></label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="comp_status" id="comp_status" value="1" checked="checked" /><cf_get_lang_main no='81.Aktif'>
						</div>
					</div>
					<div class="form-group" id="item-company_name">
						<label class="col col-4 col-xs-12"><cf_get_lang no='402.Tam Adı'> *</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang no='728.Tam Adı girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="company_name" value="" required="Yes" message="#message#" maxlength="200">
						</div>
					</div>
					<div class="form-group" id="item-nick_name">
						<label class="col col-4 col-xs-12"><cf_get_lang no='403.Kısa Ünvanı'> *</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang no='729.Kısa Ünvan girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="nick_name" value="" required="yes" message="#message#" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-chamber">
						<label class="col col-4 col-xs-12"><cf_get_lang no='36.Oda'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="chamber" value="" maxlength="150">
						</div>
					</div>
					<div class="form-group" id="item-chamber2">
						<label class="col col-4 col-xs-12"><cf_get_lang no='36.Oda'> 2</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="chamber2" value="" maxlength="150">
						</div>
					</div>
					<div class="form-group" id="item-chamber_no">
						<label class="col col-4 col-xs-12"><cf_get_lang no='406.Oda Sicil No'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="chamber_no" value="" maxlength="50">
						</div>
					</div>	
					<div class="form-group" id="item-chamber2_no">
						<label class="col col-4 col-xs-12"><cf_get_lang no='406.Oda Sicil No'> 2</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="chamber2_no" value="" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-manager_name">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='1714.Yönetici'>1</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="manager_pos_code" id="manager_pos_code" value="">
								<cfinput type="text" name="manager_name" value="">
								<span class="input-group-addon icon-ellipsis btnPointer"  href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_company.manager_pos_code&field_name=add_company.manager_name&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.add_company.manager_name.value),'list');"><img border="0" align="absmiddle"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-manager_name2">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='1714.Yönetici'>2</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="manager_pos_code2" id="manager_pos_code2" value="">
								<cfinput type="text" name="manager_name2" value="">
								<span class="input-group-addon icon-ellipsis btnPointer"  href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_company.manager_pos_code2&field_name=add_company.manager_name2&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.add_company.manager_name2.value),'list');"><img border="0" align="absmiddle"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-tax_office">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='1350.Vergi Dairesi'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="tax_office" value="" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-tax_no">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='340.Vergi No'></label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang no='712.Vergi No girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="tax_no" value="" validate="integer" message="#message#" maxlength="10">
						</div>
					</div>
					<div class="form-group" id="item-admin_mail">
						<label class="col col-4 col-xs-12"><cf_get_lang no='504.Sistem Yönetici E-Mailleri'> <br/>(<cf_get_lang no='410.Mail Adreslerini Tırnak İle Ayırarak Yazınız'>)*</label>
						<div class="col col-8 col-xs-12">	
							<textarea name="admin_mail" id="admin_mail" rows="1"></textarea>
						</div>
					</div>
					<div class="form-group" id="item-t_no">
						<label class="col col-4 col-xs-12"><cf_get_lang no='408.Ticaret Sicil No'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="t_no" id="t_no" value="" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-head_id">
						<label class="col col-4 col-xs-12"><cf_get_lang no='951.Üst Düzey Birimler'></label>
						<div class="col col-8 col-xs-12">
							<select name="head_id" id="head_id">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfloop query="get_head">
								<option value="#headquarters_id#" <cfif isdefined("attributes.head_id") and len(attributes.head_id)>selected</cfif>>#name#</option>
							</cfloop>
							</select>
						</div>
					</div>	
					<div class="form-group" id="item-mersis_no">
						<label class="col col-4 col-xs-12"><cf_get_lang no='1052.Mersis No'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="mersis_no" id="mersis_no" value="" maxlength="16">
						</div>
					</div>	
					<div class="form-group" id="item-is_organization">
						<label class="col col-4 col-xs-12"><cf_get_lang no='953.Org Şemada Göster'></label>
						<div class="col col-8 col-xs-12">
							<select name="is_organization" id="is_organization">
								<option value="1"><cf_get_lang dictionary_id='57495.Evet'></option>
								<option value="0"><cf_get_lang dictionary_id='57496.Hayır'></option>
							</select>
						</div>
					</div>
					<!---Nace kodu Alanı için ekleme --->
					<div class="form-group" id="item-NACE_CODE">
						<label class="col col-4 col-xs-12"><cf_get_lang no='1051.Nace Kodu'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="NACE_CODE" id="NACE_CODE" value="" maxlength="16">
						</div>
					</div>	
					<div class="form-group" id="item-sermaye">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='998.Sermaye'></label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang no='709.Sermaye girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="sermaye" value="" validate="integer" message="#message#" maxlength="25">
						</div>
					</div>
					<div class="form-group" id="item-manager">
						<label class="col col-4 col-xs-12"><cf_get_lang no='1205.Sistem Yöneticisi'></label>
						<div class="col col-8 col-xs-12">	
							<cfinput type="text" name="manager" value="" maxlength="40">
						</div>	
					</div>
					<div class="txtboldblue"><cf_get_lang no='415.İletişim Bilgileri'></div>
					<div class="form-group" id="item-tel_code">
						<label class="col col-4 col-xs-12"><cf_get_lang no='416.Telefon Kodu'></label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang no='708.Telefon Kodu girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="tel_code" value="" maxlength="5" validate="integer" message="#message#">
						</div>
					</div>
					<div class="form-group" id="item-tel">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='87.Telefon'></label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang no='707.Telefon girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="tel" value="" validate="integer" message="#message#" maxlength="10">
						</div>
					</div>	
					<div class="form-group" id="item-tel2">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='87.Telefon'> 2</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang no='707.Telefon girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="tel2" value="" validate="integer" message="#message#" maxlength="10">
						</div>
					</div>
					<div class="form-group" id="item-tel3">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='87.Telefon'> 3</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang no='707.Telefon girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="tel3" value="" validate="integer" message="#message#" maxlength="10">
						</div>
					</div>
					<div class="form-group" id="item-tel4">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='87.Telefon'> 4</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang no='707.Telefon girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="tel4" value="" validate="integer" message="#message#" maxlength="10">
						</div>
					</div>
					<div class="form-group" id="item-FAX">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='76.Faks'></label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang no='706.Faks girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="FAX" value="" validate="integer" message="#message#" maxlength="10">
						</div>
					</div>
					<div class="form-group" id="item-FAX2">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='76.Faks'> 2</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang no='706.Faks girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="FAX2" value="" validate="integer" message="#message#" maxlength="10">
						</div>
					</div>
					<div class="form-group" id="item-email">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='16.E-mail'>*</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang_main no='1910.Lütfen e-mail adresinizi giriniz'>!</cfsavecontent>
							<cfinput type="text" name="email" value="" validate="email" required="yes" message="#message#" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-kep">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59876.Kep Adresi'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="kep_adress" value="" validate="email" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-web">
						<label class="col col-4 col-xs-12"><cf_get_lang no='113.İnternet'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="web" id="web" value="" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-hierarchy">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='349.Hiyerarşi'></label>
						<div class="col col-4 col-xs-6">	
							<input type="text" name="hierarchy" id="hierarchy" value="" maxlength="75">
						</div>	
						<div class="col col-4 col-xs-6" id="item-hierarchy2">		
							<input type="text" name="hierarchy2" id="hierarchy2" value="" maxlength="75">
						</div>
					</div>
					<div class="form-group" id="item-postal_code">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='60.Posta Kodu'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="postal_code" id="postal_code" onKeyUp="isNumber(this)"/>
						</div>
					</div>
					<div class="form-group" id="item-country_id">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='807.Ülke'></label>
						<div class="col col-8 col-xs-12">
							<select name="country_id" id="country_id" tabindex="4" onChange="LoadCity(this.value,'city_id','county_id');">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
									<cfloop query="get_country">
								<option value="#country_id#"  <cfif get_country.is_default eq 1>selected="selected"</cfif>>#country_name#</option>
									</cfloop>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-city_id">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='559.Sehir'></label>
						<div class="col col-8 col-xs-12">
							<select name="city_id" id="city_id"  onChange="LoadCounty(this.value,'county_id','telcode','0');">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-county_id">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='1226.İlçe'></label>
						<div class="col col-8 col-xs-12">
							<select name="county_id" id="county_id"  tabindex="6">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							</select>
						</div>
					</div>	
					<div class="form-group" id="item-city_subdivision_name">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='720.Semt'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="city_subdivision_name" id="city_subdivision_name"/>
						</div>
					</div>	
					<!---Nace kodu Alanı için ekleme --->
					<div class="form-group" id="item-district_name">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='1323.Mahalle'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="district_name" id="district_name"/>
						</div>
					</div>
					<div class="form-group" id="item-street_name">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='2751.Sokak Adı'></label>
						<div class="col col-8 col-xs-12">	
							<input type="text" name="street_name" id="street_name"/>
						</div>	
					</div>
					<div class="form-group" id="item-building_number">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='75.No'></label>
						<div class="col col-8 col-xs-12">	
							<input type="text" name="building_number" id="building_number"/>
						</div>	
					</div>
					<div class="form-group" id="item-address">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='1311.Adres'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="address" id="address"></textarea>
						</div>
					</div>
					<div class="form-group" id="item-accounter_key">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64157.Mükellef Domain Doğrulama Kodu'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<div class="input-group_tooltip"><cf_get_lang dictionary_id='64159.Mükellefinizden Gerçek Zamanlı Muhasebe Verisi Alıyorsanız Bu Kodu Mükellefinize Verin'></div>
								<input type="text" name="accounter_key" id="accounter_key" value="">
								<span class="input-group-addon btn_Pointer" style="cursor:pointer;" onclick="createCode();"><cf_get_lang dictionary_id='61695.Üret'></span>	
								<span class="input-group-addon icon-question input-group-tooltip"></span>	
							</div>
						</div>
					</div>
					<div class="form-group" id="item-asset1">
						<label class="col col-4 col-xs-12 txtbold"><cf_get_lang no='412.Büyük Logo'></label>
						<div class="col col-8 col-xs-12">
							<input type="FILE" name="asset1" id="asset1">
						</div>
					</div>
					<div class="form-group" id="item-asset2">
						<label class="col col-4 col-xs-12 txtbold"><cf_get_lang no='413.OrtaLogo'></label>
						<div class="col col-8 col-xs-12">
							<input type="FILE" name="asset2" id="asset2">
						</div>
					</div>
					<div class="form-group" id="item-asset3">
						<label class="col col-4 col-xs-12 txtbold"><cf_get_lang no='414.Küçük Logo'></label>
						<div class="col col-8 col-xs-12">
							<input type="FILE" name="asset3" id="asset3">
						</div>
					</div>
				</div>
			</cfoutput>
			<div class="col col-6 col-md-6 col-sm-12 col-xs-12">
				<cfif fusebox.use_period>
					<div class="txtboldblue"><cfoutput>#getLang('settings',232)# #getLang('product',11)#</cfoutput></div>
					<div class="form-group" id="item-is_windows_auth">
						<label class="col col-4 col-xs-12 font-blue-madison bold"><cfoutput>#getLang('objects',1120)#</cfoutput></label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="is_windows_auth" id="is_windows_auth" value="1" onchange="check_win_auth()" />
						</div>
					</div>
					<div class="form-group" id="tr_db_username">
						<label class="col col-4 col-xs-12 txtbold"><cfoutput>#getLang('objects',1121)#</cfoutput>*</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='38747.Veritabanı'> <cf_get_lang dictionary_id='34327.Kullanıcı Adı Girmelisiniz'> !</cfsavecontent>
							<cfinput type="text" name="db_username" value=""  message="#message#">
						</div>
					</div>
					<div class="form-group" id="tr_db_password">
						<label class="col col-4 col-xs-12 txtbold"><cfoutput>#getLang('objects',1125)#</cfoutput>*</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='38747.Veritabanı'> <cf_get_lang dictionary_id='52603.Şifre Girmelisiniz!'> !</cfsavecontent>
							<cfinput type="password" name="db_password" value=""  message="#message#">
						</div>
					</div>
					<div class="form-group" id="tr_db_password">
						<label class="col col-4 col-xs-12 txtbold"><cfoutput>#getLang('objects',1126)#</cfoutput>*</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='61079.Coldfusion Admin Şifresi Girmelisiniz'> !</cfsavecontent>
							<cfinput type="password" name="cf_admin_password" value="" required="yes" message="#message#">
						</div>
					</div>
				</cfif>
			</div>
		</cf_box_elements>
		<div class="ui-form-list-btn">
			<cf_workcube_buttons is_upd='0' add_function='control()'>	
		</div>
		
	</cfform>	
</cf_box>
</div>

<script type="text/javascript">
	LoadCity(document.getElementById('country_id').value,'city_id','county_id');
	function control()
	{
		if(document.getElementById("tax_no").value.length !=10)
		{
			alert("Vergi No On Haneli Olmalıdır !");
			return false;
		}
		
		if(document.add_company.admin_mail.value == '')
		{
			alert ("Lütfen Sistem Yönetici E-mailleri Alanını Doldurunuz!");
			return false;
		}
		if(document.add_company.head_id.value == '')
		{
			alert ("Lütfen Üst Düzey Birimi Seçimini Yapınız!");
			return false;
		}
		
		if(document.getElementById('is_windows_auth').checked  == false )
		{
			if(document.getElementById('db_password').value=='')
			{
				alert("Veritabanı Şifre Hanesi boş geçilemez");
				return false;
			}
			
			if(document.getElementById('db_username').value=='')
			{
				alert("Veritabanı Kullanıcı Adı Hanesi boş geçilemez");
				return false ;
			}
		}

	}
	function  check_win_auth()
	{
			if(document.getElementById('is_windows_auth').checked  == true )
			{
				document.getElementById('tr_db_password').style.display = "none";
				document.getElementById('tr_db_username').style.display = "none";
			}
			else
			{
				document.getElementById('tr_db_password').style.display = "";
				document.getElementById('tr_db_username').style.display = "";
			}	
	}

	$(".input-group-tooltip").mouseover(function() {
		$( this ).closest("div.input-group").css("position","relative");
		$( this ).closest("div.input-group").find( ".input-group_tooltip" ).stop().show();
	}).mouseout(function() {
		$( this ).closest("div.input-group").css("position","initial");
		$( this ).closest("div.input-group").find( ".input-group_tooltip" ).stop().hide();
	});

	function createCode(){
		var rnd1 = Math.floor((Math.random() * 8999) + 1000);
		var rnd2 = Math.floor((Math.random() * 8999) + 1000);
		var rnd3 = Math.floor((Math.random() * 8999) + 1000);
		var rnd4 = Math.floor((Math.random() * 8999) + 1000);
		$("#accounter_key").val(rnd1 + "_" + rnd2 + "_" + rnd3 + "_" + rnd4);
	}
</script>
