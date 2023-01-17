<cf_xml_page_edit fuseact="settings.form_upd_our_company" is_multi_page="1">
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
	<cfquery name="check" datasource="#dsn#">
		SELECT 
			COMP_ID, 
			COMPANY_NAME, 
			NICK_NAME, 
			OUR_COMPANY.TAX_OFFICE, 
			OUR_COMPANY.TAX_NO, 
			TEL_CODE, 
			TEL, 
			FAX, 
			MANAGER, 
			MANAGER_POSITION_CODE, 
			MANAGER_POSITION_CODE2, 
			WEB, 
			OUR_COMPANY.EMAIL, 
			ADDRESS, 
			ADMIN_MAIL, 
			TEL2, 
			TEL3, 
			TEL4, 
			FAX2, 
			T_NO, 
			SERMAYE, 
			CHAMBER, 
			CHAMBER_NO, 
			CHAMBER2, 
			CHAMBER2_NO, 
			OUR_COMPANY.ASSET_FILE_NAME1, 
			OUR_COMPANY.ASSET_FILE_NAME1_SERVER_ID, 
			OUR_COMPANY.ASSET_FILE_NAME2, 
			OUR_COMPANY.ASSET_FILE_NAME2_SERVER_ID, 
			OUR_COMPANY.ASSET_FILE_NAME3, 
			OUR_COMPANY.ASSET_FILE_NAME3_SERVER_ID, 
			HEADQUARTERS_ID, 
			IS_ORGANIZATION, 
			HIERARCHY, 
			HIERARCHY2, 
			COMP_STATUS, 
			OUR_COMPANY.RECORD_EMP, 
			OUR_COMPANY.RECORD_DATE, 
			OUR_COMPANY.RECORD_IP,
			OUR_COMPANY.UPDATE_EMP, 
			OUR_COMPANY.UPDATE_DATE, 
			OUR_COMPANY.UPDATE_IP, 
			AUTHORITY_DOC_FINISH, 
			AUTHORITY_DOC_START, 
			AUTHORITY_DOC_NUMBER, 
			AUTHORITY_DOC_TYPE, 
			AUTHORITY_DOC_WARNING, 
			OUR_COMPANY.COORDINATE_1, 
			OUR_COMPANY.COORDINATE_2,
			COUNTRY_ID,
			POSTAL_CODE,
			CITY_ID,
			CITY_SUBDIVISION_NAME,
			BUILDING_NUMBER,
			STREET_NAME,
			DISTRICT_NAME,
			COUNTY_ID,
			MERSIS_NO,
			OUR_COMPANY.NACE_CODE,
			KEP_ADRESS,
			ACCOUNTER_KEY
		FROM 
			  OUR_COMPANY
		WHERE 
			   COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ourcompany_id#">
	</cfquery>
	
	<cfquery name="GET_EFATURA_CONTROL" datasource="#DSN#">
		SELECT COMP_ID FROM OUR_COMPANY_INFO WHERE IS_EFATURA = 1 AND COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ourcompany_id#">
	</cfquery>
	
	<cfif len(check.country_id)>
		<cfquery name="GET_CITYS" datasource="#DSN#">
			SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = #check.country_id# ORDER BY CITY_NAME
		</cfquery>
	</cfif>
	<cfif len(check.city_id)>
		<cfquery name="get_county" datasource="#DSN#">
			SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = #check.city_id# ORDER BY COUNTY_NAME
		</cfquery>
	</cfif>
	<cfquery name="get_head" datasource="#dsn#">
		SELECT HEADQUARTERS_ID, NAME FROM SETUP_HEADQUARTERS
	</cfquery>
		<cfsavecontent variable="img_">
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_our_company" title="<cf_get_lang_main no='170.Ekle'>"><img border="0" align="absbottom"></a>
		</cfsavecontent>
		<cfif not(isdefined("attributes.callAjax") and len("attributes.callAjax"))>
			<cfsavecontent variable = "company_title"><cf_get_lang dictionary_id="29531.Şirkeler"></cfsavecontent>
			<div class="row col col-3 col-md-3 col-sm-12 col-xs-12" type="row">	
				<cf_box title="#company_title#" add_href="#request.self#?fuseaction=settings.form_add_our_company" closable="0" collapsed="0">			
					<div  type="column" index="1" sort="true">
						<cfif not isdefined("attributes.hr")>
							<cfinclude template="../display/list_our_companies.cfm">
						</cfif>
					</div>
				</cf_box>
			</div>
		</cfif>
		<cfform name="upd_our_company" action="#request.self#?fuseaction=settings.emptypopup_upd_our_company"  method="post" enctype="multipart/form-data">
			<cfif isdefined("attributes.isAjax") and len(attributes.isAjax)><!--- Organizasyon Yönetimi sayfasından Ajax ile yüklendiyse --->
				<input type="hidden" name="callAjax" id="callAjax" value="1">
				<input type="hidden" name="ourcompany_id" id="ourcompany_id" value="<cfoutput>#attributes.ourcompany_id#</cfoutput>">			
			</cfif>
		
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="detail_div">	
			<cf_box title="#check.company_name#" add_href="#request.self#?fuseaction=settings.form_add_our_company" closable="0" collapsed="0">
				<cf_box_elements>
				<cfoutput>
					<input type="hidden" name="comp_id" id="comp_id" value="#check.comp_id#">
					<div class="col col-8 col-md-8 col-sm-12 col-xs-12" type="column " index="2" sort="true">
						<div class="form-group" id="item-comp_status">
							<label class="col col-4 col-xs-12 font-blue-madison bold"><cf_get_lang_main no='81.Aktif'></label>
							<div class="col col-8 col-xs-12">
								<input type="Checkbox" name="comp_status" id="comp_status" value="1" <cfif check.comp_status eq 1>checked</cfif>><cf_get_lang_main no='81.Aktif'>
							</div>
						</div>
						<div class="form-group" id="item-company_name">
							<label class="col col-4 col-xs-12"><cf_get_lang no='402.Tam Adı'> *</label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang no='728.Tam Adı girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="company_name" value="#check.company_name#" required="Yes" message="#message#" maxlength="200" style="width:150px;">
							</div>
						</div>
						<div class="form-group" id="item-nick_name">
							<label class="col col-4 col-xs-12"><cf_get_lang no='403.Kısa Ünvanı'> *</label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang no='729.Kısa Ünvan girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="nick_name" value="#check.nick_name#" required="yes" message="#message#" maxlength="50" style="width:150px;">
							</div>
						</div>
						<div class="form-group" id="item-chamber">
							<label class="col col-4 col-xs-12"><cf_get_lang no='36.Oda'></label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="chamber" value="#check.chamber#" style="width:150px;">
							</div>
						</div>
						<div class="form-group" id="item-chamber2">
							<label class="col col-4 col-xs-12"><cf_get_lang no='36.Oda'> 2</label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="chamber2" value="#check.chamber2#" style="width:150px;">
							</div>
						</div>
						<div class="form-group" id="item-chamber_no">
							<label class="col col-4 col-xs-12"><cf_get_lang no='406.Oda Sicil No'></label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="chamber_no" value="#check.chamber_no#" style="width:150px;">
							</div>
						</div>	
						<div class="form-group" id="item-chamber2_no">
							<label class="col col-4 col-xs-12"><cf_get_lang no='406.Oda Sicil No'> 2</label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="chamber2_no" value="#check.chamber2_no#" style="width:150px;">
							</div>
						</div>
						<div class="form-group" id="item-manager_name">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='1714.Yönetici'>1</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="manager_pos_code" id="manager_pos_code" value="#check.manager_position_code#">
									<cfinput type="text" name="manager_name" value="#get_emp_info(check.manager_position_code,1,0)#" style="width:150px;">
									<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_code=upd_our_company.manager_pos_code&field_name=upd_our_company.manager_name&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.upd_our_company.manager_name.value),'list');"><img border="0" align="absbottom"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-manager_name2">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='1714.Yönetici'>2</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="manager_pos_code2" id="manager_pos_code2" value="#check.manager_position_code2#">
									<cfinput type="text" name="manager_name2" value="#get_emp_info(check.manager_position_code2,1,0)#" style="width:150px;">
									<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_code=upd_our_company.manager_pos_code2&field_name=upd_our_company.manager_name2&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.upd_our_company.manager_name2.value),'list');"><img border="0" align="absbottom"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-tax_office">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='1350.Vergi Dairesi'></label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="tax_office" value="#check.tax_office#" style="width:150px;">
							</div>
						</div>
						<div class="form-group" id="item-tax_no">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='340.Vergi No'></label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang no='712.Vergi No girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="tax_no" value="#check.tax_no#" validate="integer" message="#message#" maxlength="10" style="width:150px;">
							</div>
						</div>
						<div class="form-group" id="item-admin_mail">
							<label class="col col-4 col-xs-12"><cf_get_lang no='504.Sistem Yönetici E-Mailleri'> <br/>(<cf_get_lang no='410.Mail Adreslerini Tırnak İle Ayırarak Yazınız'>)*</label>
							<div class="col col-8 col-xs-12">	
								<textarea name="admin_mail" id="admin_mail" rows="1" style="width:150px;height:50px;">#check.admin_mail#</textarea>
							</div>
						</div>
						<div class="form-group" id="item-t_no">
							<label class="col col-4 col-xs-12"><cf_get_lang no='408.Ticaret Sicil No'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="t_no" id="t_no" value="#check.t_no#" style="width:150px;">
							</div>
						</div>
						<div class="form-group" id="item-head_id">
							<label class="col col-4 col-xs-12"><cf_get_lang no='951.Üst Düzey Birimler'></label>
							<div class="col col-8 col-xs-12">
								<select name="head_id" id="head_id" style="width:150px;">
									<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
										<cfloop query="get_head">
									<option value="#headquarters_id#" <cfif headquarters_id eq check.headquarters_id>selected</cfif>>#get_head.name#</option>
										</cfloop>
								</select>
							</div>
						</div>	
						<div class="form-group" id="item-mersis_no">
							<label class="col col-4 col-xs-12"><cf_get_lang no='1052.Mersis No'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="mersis_no" id="mersis_no" value="#check.mersis_no#" maxlength="16" style="width:150px;">
							</div>
						</div>	
						<div class="form-group" id="item-is_organization">
							<label class="col col-4 col-xs-12"><cf_get_lang no='953.Org Şemada Göster'></label>
							<div class="col col-8 col-xs-12">
								<select name="is_organization" id="is_organization">
									<option value="1" <cfif check.is_organization eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
									<option value="0" <cfif check.is_organization eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
								</select>
							</div>
						</div>
						<!---Nace kodu Alanı için ekleme --->
						<div class="form-group" id="item-NACE_CODE">
							<label class="col col-4 col-xs-12"><cf_get_lang no='1051.Nace Kodu'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="NACE_CODE" id="NACE_CODE" value="#check.NACE_CODE#" maxlength="16" style="width:150px;">
							</div>
						</div>	
						<div class="form-group" id="item-sermaye">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='998.Sermaye'></label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang no='709.Sermaye girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="sermaye" value="#check.sermaye#" validate="integer" message="#message#" maxlength="25" style="width:150px;">
							</div>
						</div>
						<div class="form-group" id="item-manager">
							<label class="col col-4 col-xs-12"><cf_get_lang no='1205.Sistem Yöneticisi'></label>
							<div class="col col-8 col-xs-12">	
								<cfinput type="text" name="manager" value="#check.manager#" maxlength="40" style="width:150px;">
							</div>	
						</div>
					
						<div class="txtboldblue"><cf_get_lang no='415.İletişim Bilgileri'></div>
						<div class="form-group" id="item-tel_code">
							<label class="col col-4 col-xs-12"><cf_get_lang no='416.Telefon Kodu'></label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang no='708.Telefon Kodu girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="tel_code" value="#check.tel_code#" maxlength="5" validate="integer" message="#message#" style="width:150px;">
							</div>
						</div>
						<div class="form-group" id="item-tel">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='87.Telefon'></label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang no='707.Telefon girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="tel" value="#check.tel#" validate="integer" message="#message#" maxlength="10" style="width:150px;">
							</div>
						</div>	
						<div class="form-group" id="item-tel2">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='87.Telefon'> 2</label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang no='707.Telefon girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="tel2" value="#check.tel2#" validate="integer" message="#message#" maxlength="10" style="width:150px;">
							</div>
						</div>
						<div class="form-group" id="item-tel3">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='87.Telefon'> 3</label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang no='707.Telefon girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="tel3" value="#check.tel3#" validate="integer" message="#message#" maxlength="10" style="width:150px;">
							</div>
						</div>
						<div class="form-group" id="item-tel4">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='87.Telefon'> 4</label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang no='707.Telefon girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="tel4" value="#check.tel4#" style="width:150px;" validate="integer" message="#message#" maxlength="10">
							</div>
						</div>
						<div class="form-group" id="item-FAX">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='76.Faks'></label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang no='706.Faks girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="FAX" value="#check.FAX#" validate="integer" message="#message#" maxlength="10" style="width:150px;">
							</div>
						</div>
						<div class="form-group" id="item-FAX2">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='76.Faks'> 2</label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang no='706.Faks girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="FAX2" value="#check.FAX2#" validate="integer" message="#message#" maxlength="10" style="width:150px;">
							</div>
						</div>
						<div class="form-group" id="item-email">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='16.E-mail'>*</label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang_main no='1910.Lütfen e-mail adresinizi giriniz'>!</cfsavecontent>
								<cfinput type="text" name="email" value="#check.email#" validate="email" required="yes" message="#message#" maxlength="50" style="width:150px;">
							</div>
						</div>
						<div class="form-group" id="item-kep">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59876.Kep Adresi'></label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="kep_adress" value="#check.kep_adress#" validate="email" maxlength="50">
							</div>
						</div>
						<div class="form-group" id="item-web">
							<label class="col col-4 col-xs-12"><cf_get_lang no='113.İnternet'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="web" id="web" value="#check.web#" maxlength="50" style="width:150px;">
							</div>
						</div>
						<div class="form-group" id="item-hierarchy">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='349.Hiyerarşi'></label>
							<div class="col col-4 col-xs-6">	
								<input type="text" name="hierarchy" id="hierarchy" value="#check.hierarchy#" maxlength="75" style="width:75px;">
							</div>	
							<div class="col col-4 col-xs-6" id="item-hierarchy2">		
								<input type="text" name="hierarchy2" id="hierarchy2" value="#check.hierarchy2#" maxlength="75" style="width:75px;">
							</div>
						</div>
						<div class="form-group" id="item-postal_code">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='60.Posta Kodu'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="postal_code" id="postal_code" value="#check.postal_code#"  onKeyUp="isNumber(this)" style="width:150px;"/>
							</div>
						</div>
						<div class="form-group" id="item-country_id">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='807.Ülke'><cfif get_efatura_control.recordcount> *</cfif></label>
							<div class="col col-8 col-xs-12">
								<select name="country_id" id="country_id" style="width:150px;" tabindex="4" onchange="LoadCity(this.value,'city_id','county_id');">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfloop query="get_country">
									<option value="#country_id#"  <cfif check.country_id eq get_country.country_id>selected="selected"</cfif>>#country_name#</option>
								</cfloop>
							</select>
							</div>
						</div>
						<div class="form-group" id="item-city_id">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='559.Sehir'><cfif get_efatura_control.recordcount> *</cfif></label>
							<div class="col col-8 col-xs-12">
								<select name="city_id" id="city_id"  onchange="LoadCounty(this.value,'county_id','','0');" style="width:150px;">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfif isdefined ('GET_CITYS')>
								<cfloop query="get_citys">
									<option value="#city_id#" <cfif check.city_id eq get_citys.city_id>selected="selected"</cfif>>#city_name#</option>
								</cfloop>
								</cfif>
							</select>
							</div>
						</div>
						<div class="form-group" id="item-county_id">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='1226.İlçe'><cfif get_efatura_control.recordcount> *</cfif></label>
							<div class="col col-8 col-xs-12">
								<select name="county_id" id="county_id"  style="width:150px;" tabindex="6">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfif isdefined('get_county')>
								<cfloop query="get_county">
								<option value="#county_id#" <cfif check.county_id eq get_county.county_id>selected="selected"</cfif>>#county_name#</option>
								</cfloop>
								</cfif>
							</select>
							</div>
						</div>	
						<div class="form-group" id="item-city_subdivision_name">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='720.Semt'><cfif get_efatura_control.recordcount> *</cfif></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="city_subdivision_name" id="city_subdivision_name" value="#check.city_subdivision_name#" style="width:150px;"/>
							</div>
						</div>	
						<!---Nace kodu Alanı için ekleme --->
						<div class="form-group" id="item-district_name">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='1323.Mahalle'><cfif get_efatura_control.recordcount> *</cfif></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="district_name" id="district_name" value="#check.district_name#" style="width:150px;"/>
							</div>
						</div>
						<div class="form-group" id="item-street_name">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='2751.Sokak Adı'><cfif get_efatura_control.recordcount> *</cfif></label>
							<div class="col col-8 col-xs-12">	
								<input type="text" name="street_name" id="street_name" value="#check.street_name#" style="width:150px;"/>
							</div>	
						</div>
						<div class="form-group" id="item-building_number">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='75.No'><cfif get_efatura_control.recordcount> *</cfif></label>
							<div class="col col-8 col-xs-12">	
								<input type="text" name="building_number" id="building_number" value="#check.building_number#"  style="width:150px;"/>
							</div>	
						</div>
						<div class="form-group" id="item-building_number">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='1137.Koordinatlar'> <cf_get_lang_main no='1141.E'>/<cf_get_lang_main no='1179.B'></label>
							<div class="col col-4 col-xs-6">	
								<cfinput type="text" maxlength="10" range="-90,90" message="Lütfen enlem değerini -90 ile 90 arasında giriniz!" value="#check.coordinate_1#" name="coordinate_1" style="width:65px;"> 
							</div>
							<div class="col col-3 col-xs-5">
								<cfinput type="text" maxlength="10" range="-180,180" message="Lütfen boylam değerini -180 ile 180 arasında giriniz!" value="#check.coordinate_2#" name="coordinate_2" style="width:64px;">
							</div>
							<div class="col col-1 col-xs-1">
								<cfif len(check.coordinate_1) and len(check.coordinate_2)>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_view_map&coordinate_1=#check.coordinate_1#&coordinate_2=#check.coordinate_2#&title=#check.company_name#','list')"><img src="/images/branch.gif" border="0" alt="Haritada Göster" align="absbottom"></a>
								</cfif>
							</div>	
						</div>
						<div class="form-group" id="item-address">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='1311.Adres'></label>
							<div class="col col-8 col-xs-12">
								<textarea name="address" id="address" style="width:150px;height:90px;">#check.address#</textarea>
							</div>
						</div>
						<div class="form-group" id="item-accounter_key">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64157.Mükellef Domain Doğrulama Kodu'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='64159.Mükellefinizden Gerçek Zamanlı Muhasebe Verisi Alıyorsanız Bu Kodu Mükellefinize Verin'></div>
									<input type="text" name="accounter_key" id="accounter_key" value="<cfif check.recordCount and len(check.ACCOUNTER_KEY)>#check.ACCOUNTER_KEY#</cfif>">
									<span class="input-group-addon btn_Pointer" style="cursor:pointer;" onclick="createCode();"><cf_get_lang dictionary_id='61695.Üret'></span>	
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-asset1">
							<label class="col col-4 col-xs-12 txtbold"><cf_get_lang no='412.Büyük Logo'></label>
							<div class="col col-8 col-xs-12">
								<input type="FILE" name="asset1" id="asset1" style="width:220px;">
							</div>
						</div>        
						<cfif len(check.asset_file_name1)>
						<div class="form-group">
							<div class="col col-4 col-xs-12">
								<a href="javascript://" onclick="windowopen('<cfoutput>#file_web_path#settings/#check.asset_file_name1#</cfoutput>','medium')" class="tableyazi">
								<cf_get_server_file output_file="settings/#check.asset_file_name1#" output_server="#check.asset_file_name1_server_id#" output_type="0"></a>
							</div>
							<div class="col col-8 col-xs-12"><label><cf_get_lang dictionary_id="30161.Logo Sil"></br><input type="checkbox" name="del_logo1" id="del_logo1" /></label></div>
						</div>
						</cfif>
						<div class="form-group" id="item-asset2">
							<label class="col col-4 col-xs-12 txtbold"><cf_get_lang no='413.Orta Logo'></label>
							<div class="col col-8 col-xs-12">
								<input type="FILE" name="asset2" id="asset2" style="width:220px;">
							</div>
						</div>     
						<cfif len(check.asset_file_name2)>
						<div class="form-group">
							<div class="col col-4 col-xs-12">
								<a href="javascript://" onclick="windowopen('<cfoutput>#file_web_path#settings/#check.asset_file_name2#</cfoutput>','medium')" class="tableyazi">
								<cf_get_server_file output_file="settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="0"></a>
							</div>
							<div class="col col-8 col-xs-12"><label><cf_get_lang dictionary_id="30161.Logo Sil"></br><input type="checkbox" name="del_logo2" id="del_logo2" /></label></div>
						</div>
						</cfif>
						<div class="form-group" id="item-asset3">
							<label class="col col-4 col-xs-12 txtbold"><cf_get_lang no='414.Küçük Logo'></label>
							<div class="col col-8 col-xs-12">
								<input type="FILE" name="asset3" id="asset3" style="width:220px;">
							</div>
						</div>    
						<cfif len(check.asset_file_name3)>
						<div class="form-group">
							<div class="col col-4 col-xs-12">
								<a href="javascript://" onclick="windowopen('<cfoutput>#file_web_path#settings/#check.asset_file_name3#</cfoutput>','medium')" class="tableyazi">
								<cf_get_server_file output_file="settings/#check.asset_file_name3#" output_server="#check.asset_file_name3_server_id#" output_type="0"></a>
							</div>
							<div class="col col-8 col-xs-12"><label><cf_get_lang dictionary_id="30161.Logo Sil"></br><input type="checkbox" name="del_logo3" id="del_logo3" /></label></div>
						</div> 
						</cfif>
					</div>
				</cfoutput>
					<div class="col col-3 col-md-3 col-sm-12 col-xs-12" type="column" index="4" sort="true">
						<cfif is_letter_authority eq 1>
							<div class="txtboldblue"><cf_get_lang no='2882.Yetki Belgesi'></div>
							<div class="form-group" id="item-AUTHORITY_DOC_TYPE">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='1121.Belge Tipi'></label>
								<div class="col col-6 col-xs-12">
									<cfinput type="text" name="AUTHORITY_DOC_TYPE" value="#check.AUTHORITY_DOC_TYPE#" maxlength="50" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-AUTHORITY_DOC_START">
								<label class="col col-3 col-xs-12"><cf_get_lang no='2883.Veriliş Tarihi'></label>
								<div class="col col-6 col-xs-12">
									<div class="input-group">
										<cfif len(check.AUTHORITY_DOC_START)>
											<cfsavecontent variable="message"><cf_get_lang no='2899.Belge Başlangıç Tarihi Hatalı!'></cfsavecontent>
											<cfinput type="text" name="AUTHORITY_DOC_START" value="#dateformat(check.AUTHORITY_DOC_START,dateformat_style)#" validate="#validate_style#" style="width:130px;" message="#message#">
										<cfelse>
											<cfsavecontent variable="message"><cf_get_lang no='2899.Belge Başlangıç Tarihi Hatalı!'></cfsavecontent>
											<cfinput type="text" name="AUTHORITY_DOC_START" value="" validate="#validate_style#" style="width:130px;" message="#message#">
										</cfif>
										<span class="input-group-addon"><cf_wrk_date_image date_field="AUTHORITY_DOC_START"></span>
									</div>
								</div>
							</div> 
							<div class="form-group" id="item-AUTHORITY_DOC_FINISH">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='1212.Geçerlilik Tarihi'></label>
								<div class="col col-6 col-xs-12">
									<div class="input-group">
										<cfif len(check.AUTHORITY_DOC_FINISH)>
											<cfsavecontent variable="message"><cf_get_lang no='2902.Belge Bitiş Tarihi Hatalı!'></cfsavecontent>
											<cfinput type="text" name="AUTHORITY_DOC_FINISH" value="#dateformat(check.AUTHORITY_DOC_FINISH,dateformat_style)#" validate="#validate_style#" style="width:130px;" message="#message#">
										<cfelse>
											<cfsavecontent variable="message"><cf_get_lang no='2902.Belge Bitiş Tarihi Hatalı!'></cfsavecontent>
											<cfinput type="text" name="AUTHORITY_DOC_FINISH" value="" validate="#validate_style#" style="width:130px;" message="#message#">
										</cfif>
										<span class="input-group-addon"><cf_wrk_date_image date_field="AUTHORITY_DOC_FINISH"></span>
									</div>
								</div>
							</div> 
							<div class="form-group" id="item-AUTHORITY_DOC_NUMBER">
								<label class="col col-3 col-xs-12"><cf_get_lang no='2884.Numarası'></label>
								<div class="col col-6 col-xs-12">
									<cfinput type="text" name="AUTHORITY_DOC_NUMBER" value="#check.AUTHORITY_DOC_NUMBER#" maxlength="100" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-AUTHORITY_DOC_NUMBER">
								<label class="col col-3 col-xs-12"><cf_get_lang no='2885.Kontrol Zamanı'></label>
								<div class="col col-6 col-xs-12">
									<select name="AUTHORITY_DOC_WARNING" id="AUTHORITY_DOC_WARNING" style="width:150px;">
										<option value=""><cf_get_lang no='2887.Uyarı Zamanı'></option>
										<option value="1" <cfif check.AUTHORITY_DOC_WARNING eq 1>selected</cfif>><cf_get_lang no='2886.Bir Ay Kala Uyar'></option>
										<option value="2" <cfif check.AUTHORITY_DOC_WARNING eq 2>selected</cfif>><cf_get_lang no='2889.İki Ay Kala Uyar'></option>
										<option value="3" <cfif check.AUTHORITY_DOC_WARNING eq 3>selected</cfif>><cf_get_lang no='2891.Üç Ay Kala Uyar'></option>
										<option value="4" <cfif check.AUTHORITY_DOC_WARNING eq 4>selected</cfif>><cf_get_lang no='2892.Dört Ay Kala Uyar'></option>
										<option value="5" <cfif check.AUTHORITY_DOC_WARNING eq 5>selected</cfif>><cf_get_lang no='2894.Beş Ay Kala Uyar'></option>
										<option value="6" <cfif check.AUTHORITY_DOC_WARNING eq 6>selected</cfif>><cf_get_lang no='2895.Altı Ay Kala Uyar'></option>
									</select>
								</div>
							</div>
						</cfif>
					</div>
				</cf_box_elements>
				<div class="ui-form-list-btn">
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
					<cf_record_info 
						query_name="check"
						record_emp="record_emp" 
						record_date="record_date"
						update_emp="update_emp"
						update_date="update_date">
					</div>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
					<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
					</div>
				</div> 
			</cf_box>
			</div>
	</cfform>
	<script type="text/javascript">
	//LoadCity(document.getElementById('country_id').value,'city_id','county_id');
	
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

	function kontrol()
	{
		if(document.getElementById('admin_mail').value == "")
		{
			alert ("Lütfen Sistem Yönetici E-mailleri Alanını Doldurunuz!");
			return false;
		}
		if((document.getElementById('coordinate_1').value.length != "" && document.getElementById('coordinate_2').value.length == "") || (document.getElementById('coordinate_1').value.length == "" && document.getElementById('coordinate_2').value.length != ""))
		{
			alert ("Lütfen koordinat değerlerini eksiksiz giriniz!");
			return false;
		}
		if(document.getElementById('head_id').value == "")
		{
			alert ("Lütfen Üst Düzey Birimi Seçimini Yapınız!");
			return false;
		}
		
		<cfif get_efatura_control.recordcount>
			if(document.getElementById('tax_office').value == "")
			{
				alert("Vergi Dairesi Girmelisiniz !");
				return false;	
			}
			if(document.getElementById('tax_no').value == "")
			{
				alert("Vergi No Girmelisiniz !");
				return false;	
			}
			if(document.getElementById('country_id').value == "")
			{
				alert("Ülke Seçmelisiniz !");
				return false;
			}
	
			if(document.getElementById('city_id').value == "")
			{
				alert("Şehir Seçmelisiniz !");
				return false;
			}	
		
			if(document.getElementById('county_id').value == "")
			{
				alert("Şehir Seçmelisiniz !");
				return false;
			}		
	
			if(document.getElementById('city_subdivision_name').value == "")
			{
				alert("Semt Giriniz !");
				return false;
			}
			
			if(document.getElementById('district_name').value == "")
			{
				alert("Mahalle Giriniz !");
				return false;
			}
			
			if(document.getElementById('postal_code').value == "")
			{
				alert("Posta Kodu Giriniz !");
				return false;
			}
			
			if(document.getElementById('street_name').value == "")
			{
				alert("Cadde Sokak Giriniz !");
				return false;
			}		
			
			if(document.getElementById('building_number').value == "")
			{
				alert("No Giriniz !");
				return false;
			}
			if(document.getElementById('t_no').value=='')
			{
				alert('Ticaret Sicil No Alanı Boş Geçilemez');
				return false;
			}
		</cfif>
		return true;
	}
	</script>