<cfscript>
	get_imcat = createObject("component","V16.hr.cfc.get_im");
	get_imcat.dsn = dsn;
	get_ims = get_imcat.get_im(
		employee_id : attributes.employee_id
	);
</cfscript>
<cfif not isdefined("get_hr_detail")>
  <cfinclude template="../query/get_hr_detail.cfm">
</cfif>
<cfif len(get_hr_detail.homecity)>
	<cfquery name="get_county" datasource="#dsn#">
		SELECT COUNTY_NAME,COUNTY_ID,CITY FROM SETUP_COUNTY WHERE CITY=#get_hr_detail.homecity# ORDER BY COUNTY_NAME
	</cfquery>
</cfif>
<cfif len(get_hr_detail.homecountry)>
	<cfquery name="get_city" datasource="#dsn#">
		SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID FROM SETUP_CITY WHERE COUNTRY_ID=#get_hr_detail.homecountry#
	</cfquery>
</cfif>
<cfquery name="get_country" datasource="#dsn#">
	SELECT COUNTRY_ID,COUNTRY_NAME,IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfquery name="get_reference_type" datasource="#dsn#">
	SELECT REFERENCE_TYPE_ID,REFERENCE_TYPE FROM SETUP_REFERENCE_TYPE
</cfquery>
<cfquery name="get_im_cats" datasource="#dsn#">
	SELECT IMCAT_ID, IMCAT FROM SETUP_IM
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55450.İletişim-Referans"></cfsavecontent>
<div class="col col-12">
	<cf_box title="#message# : #get_emp_info(attributes.employee_id,0,0)#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="employe_com" action="#request.self#?fuseaction=hr.emptypopup_upd_emp_com" method="post">
		<input type="Hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="1" type="column" sort="true">
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='58219.Ülke'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<select name="homecountry" id="homecountry" style="width:150px;" onChange="LoadCity(this.value,'select_city','select_county',0)">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_country">
									<option value="#get_country.country_id#" <cfif (not len(get_hr_detail.homecountry) and get_country.is_default eq 1) or (get_hr_detail.homecountry eq get_country.country_id)>selected</cfif>>#get_country.country_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='57971.Şehir'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<select style="width:150px;" name="select_city"  id="select_city" onChange="LoadCounty(this.value,'select_county');">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfif len(get_hr_detail.homecountry)>
									<cfoutput query="get_city">
										<option value="#get_city.CITY_ID#"<cfif get_hr_detail.homecity eq get_city.CITY_ID> selected</cfif>>#get_city.CITY_NAME#</option>	
									</cfoutput>
								</cfif>
							</select>
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='58638.İlçe'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<select style="width:150px;" name="select_county" id="select_county">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfif len(get_hr_detail.homecity)>
										<cfoutput query="get_county">
											<option value="#COUNTY_ID#"<cfif get_hr_detail.homecounty eq COUNTY_ID> selected</cfif>>#COUNTY_NAME#</option>
										</cfoutput>
									</cfif>
							</select>
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='58735.Mahalle'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<cfinput type="text" id="neighborhood" name="neighborhood" style="width:150px;" maxlength="100" value="#get_hr_detail.neighborhood#">
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='59268.Bulvar'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<cfinput type="text" id="boulevard" name="boulevard" style="width:150px;" maxlength="100" value="#get_hr_detail.BOULEVARD#">
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='59266.Cadde'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<cfinput type="text" id="avenue" name="avenue" style="width:150px;" value="#get_hr_detail.avenue#">
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='59267.Sokak'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<cfinput type="text" id="street" name="street" style="width:150px;" value="#get_hr_detail.street#">
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='55987.Dış Kapı'></label>
						</div>
						<div class="col small">
							<cfinput type="text" id="external_door_number" name="external_door_number" style="width:150px;" value="#get_hr_detail.external_door_number#">
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='55988.İç Kapı'></label>
						</div>
						<div class="col small">
							<cfinput type="text" id="internal_door_number" name="internal_door_number" style="width:150px;" value="#get_hr_detail.internal_door_number#">
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="2" type="column" sort="true">
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='55595.Posta Kod'></label>
						</div>
						<div class="col small">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='55611.Posta Kod girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="homepostcode" style="width:150px;" maxlength="10" onKeyUp="isNumber(this);" value="#get_hr_detail.homepostcode#" message="#message#">
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='55593.Ev Tel'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='55601.Ev Tel girmelisiniz'></cfsavecontent>
								<cfinput value="#get_hr_detail.hometel_code#" type="text" name="hometel_code" style="width:48px;" maxlength="5" onKeyUp="isNumber(this);" message="#message#">
							</div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput value="#get_hr_detail.hometel#" type="text" name="hometel" style="width:99px;" maxlength="9" onKeyUp="isNumber(this);" message="#message#">
							</div>
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='55445.Direkt Tel'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='55443.Direkt Telefon girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="directTelCode" value="#get_hr_detail.DIRECT_TELCODE_SPC#" style="width:48px;" maxlength="3" onKeyUp="isNumber(this);" message="#message#">
							</div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="text" name="directTel" value="#get_hr_detail.DIRECT_TEL_SPC#" style="width:99px;" maxlength="7" onKeyUp="isNumber(this);" message="#message#">
							</div>
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='55446.Dahili Tel'></label>
						</div>
						<div class="col small">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='55453.Dahili Telefon girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="extension" value="#get_hr_detail.EXTENSION_SPC#" style="width:150px;" maxlength="5" onKeyUp="isNumber(this);" message="#message#">
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='58482.Mobil Tel'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='55454.Mobil Telefon girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="mobilcode" value="#get_hr_detail.MOBILCODE_SPC#" style="width:40px;" maxlength="3" onKeyUp="isNumber(this);" message="#message#">
							</div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="text" name="mobilTel" style="width:107px;" value="#get_hr_detail.MOBILTEL_SPC#" maxlength="7" onKeyUp="isNumber(this);" message="#message#">
							</div>
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='58482.Mobil Tel'> 2</label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='55454.Mobil Telefon girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="mobilcode2" value="#get_hr_detail.MOBILCODE2_SPC#" maxlength="3" onKeyUp="isNumber(this);" message="#message#">
							</div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="text" name="mobilTel2" value="#get_hr_detail.MOBILTEL2_SPC#" maxlength="7" onKeyUp="isNumber(this);" message="#message#">
							</div>
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id="58723.Adres"></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<textarea name="homeaddress" id="homeaddress" maxlength="500"><cfoutput>#get_hr_detail.homeaddress#</cfoutput></textarea>
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='57428.e-mail'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<cfinput type="text" name="email" value="#get_hr_detail.EMAIL_SPC#" style="width:150px;" maxlength="100" validate="email" message="E-mail adresini giriniz!">
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="3" type="column" sort="true">
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<cf_get_lang dictionary_id='55597.Bağlantı Kurulacak Kişi'>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='57570.Ad Soyad'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<cfinput type="text" name="contact1" style="width:150px;" maxlength="40" value="#get_hr_detail.contact1#">
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='57499.Tel'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='55107.Telefon no'></cfsavecontent>
								<cfinput value="#get_hr_detail.contact1_telcode#" type="text" name="contact1_telcode" onKeyUp="isNumber(this);" maxlength="5" style="width:48px;" validate="integer" message="#message#">
							</div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput value="#get_hr_detail.contact1_tel#" type="text" name="contact1_tel" maxlength="9" style="width:99px;" validate="integer" message="#message#">
							</div>
						</div>
					</div>
					
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='55693.Yakınlık'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<cfinput type="text" name="contact1_relation" style="width:100px;" maxlength="40" value="#get_hr_detail.contact1_relation#">
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='57428.Email'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<cfinput type="text" name="contact1_email" style="width:100px;" maxlength="50" value="#get_hr_detail.contact1_email#">
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">&nbsp;</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<cf_get_lang dictionary_id='55597.Bağlantı Kurulacak Kişi'>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='57570.Ad Soyad'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<cfinput type="text" name="contact2" style="width:150px;" maxlength="40" value="#get_hr_detail.contact2#">
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='57499.Tel'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='55107.Telefon no'></cfsavecontent>
							<cfinput value="#get_hr_detail.contact2_telcode#" type="text" name="contact2_telcode" onKeyUp="isNumber(this);" maxlength="5" style="width:48px;" validate="integer" message="#message#">
							</div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput value="#get_hr_detail.contact2_tel#" type="text" name="contact2_tel" maxlength="9" style="width:99px;" validate="integer" message="#message#">
							</div>
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='55693.Yakınlık'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<cfinput type="text" name="contact2_relation" style="width:100px;" maxlength="40" value="#get_hr_detail.contact2_relation#">
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='57428.Email'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<cfinput type="text" name="contact2_email" style="width:100px;" maxlength="50" value="#get_hr_detail.contact2_email#">
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_elements>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id="56167.Grup İçi Referans"></cfsavecontent>
			<cf_seperator title="#message#" id="ref_info_table" no_line="1">
				<cf_grid_list id="ref_info_table">
					<cfquery name="get_referance" datasource="#dsn#">
						SELECT 
							REFERENCE_ID,
							REFERENCE_TYPE,
							REFERENCE_NAME,
							REFERENCE_COMPANY,
							REFERENCE_POSITION,
							REFERENCE_TELCODE,
							REFERENCE_TEL,
							REFERENCE_EMAIL
						FROM 
							EMPLOYEES_REFERENCE 
						WHERE 
							<cfif len(get_hr_detail.EMPAPP_ID)>
							EMPAPP_ID= #get_hr_detail.EMPAPP_ID#
							<cfelseif len(attributes.employee_id)>
							EMPLOYEE_ID= #attributes.employee_id#
							</cfif>
					</cfquery>
					<input type="hidden" name="add_ref_info" id="add_ref_info" value="<cfoutput>#get_referance.recordcount#</cfoutput>">
					<thead>
						<tr>
							<th width="15"><a href="javascript://" onClick="add_ref_info_();" title="Ekle"><i class="fa fa-plus"></i></a></th>
							<th><cf_get_lang dictionary_id='55240.Referans Tipi'></th>
							<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
							<th><cf_get_lang dictionary_id='57574.Sirket'></th>
							<th><cf_get_lang dictionary_id='29429.Tel Kodu'></th>
							<th><cf_get_lang dictionary_id='57499.Telefon'></th>
							<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
							<th><cf_get_lang dictionary_id='57428.E mail'></th>
						</tr>
					</thead>
					<input type="hidden" name="referance_info" id="referance_info" value="">
					<tbody id="ref_info">
						<cfoutput query="get_referance">
							<tr id="ref_info_#currentrow#">
								<td><a style="cursor:pointer" onClick="del_ref('#currentrow#');"><i class="fa fa-minus"></i></a></td>
								<td>
									<select name="ref_type#currentrow#" id="ref_type#currentrow#" style="width:100px;">
										<option value=""><cf_get_lang dictionary_id='55240.Referans Tipi'></option>
										<cfloop query="get_reference_type">
											<option value="#reference_type_id#"<cfif len(get_referance.REFERENCE_TYPE) and (get_referance.REFERENCE_TYPE eq reference_type_id)>selected</cfif>>#reference_type#</option>
										</cfloop>
										<!---
										<option value="1"<cfif len(get_referance.REFERENCE_TYPE) and (get_referance.REFERENCE_TYPE eq 1)>selected</cfif>><cf_get_lang no='1791.Grup İçi'></option>
										<option value="2"<cfif len(get_referance.REFERENCE_TYPE) and (get_referance.REFERENCE_TYPE eq 2)>selected</cfif>><cf_get_lang_main no='744.Diğer'></option>
										--->
									</select>
								</td>
								<td><input type="text" name="ref_name#currentrow#" id="ref_name#currentrow#" value="#REFERENCE_NAME#" style="width:90px;"></td>
								<td><input type="text" name="ref_company#currentrow#" id="ref_company#currentrow#" value="#REFERENCE_COMPANY#" style="width:90px;"></td>
								<td><input type="text" name="ref_telcode#currentrow#" id="ref_telcode#currentrow#" value="#REFERENCE_TELCODE#" style="width:50px;"> </td>
								<td><input type="text" name="ref_tel#currentrow#" id="ref_tel#currentrow#" value="#REFERENCE_TEL#" style="width:75px;"></td>
								<td><input type="text" name="ref_position#currentrow#" id="ref_position#currentrow#" value="#REFERENCE_POSITION#" style="width:75px;"></td>
								<td>
									<input type="text" name="ref_mail#currentrow#" id="ref_mail#currentrow#" value="#REFERENCE_EMAIL#" style="width:75px;">
									<input type="hidden" name="del_ref_info#currentrow#" id="del_ref_info#currentrow#" value="1">
								</td>
							</tr>
						</cfoutput>
					</tbody>
				</cf_grid_list>

				<cfsavecontent variable="message"><cf_get_lang dictionary_id="55444.Instant Mesaj"></cfsavecontent>
				<cf_seperator title="#message#" id="im_info_table" no_line="1">
				<cf_grid_list id="im_info_table">
					<input type="hidden" name="add_im_info" id="add_im_info" value="<cfoutput>#get_ims.recordcount#</cfoutput>">
					<thead>
						<tr>
							<th width="15"><a href="javascript://" onClick="add_im_info_();" title="Ekle"><i class="fa fa-plus"></i></a></th>
							<th><cf_get_lang dictionary_id='57630.Tip'></th>
							<th><cf_get_lang dictionary_id='55686.Mail Adresi'></th>
						</tr>
					</thead>
					<input type="hidden" name="instant_info" id="instant_info" value="">
					<tbody id="im_info">
						<cfoutput query="get_ims">
							<tr id="im_info_#currentrow#">
								<td><input type="hidden" name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#" value="1"><a style="cursor:pointer" onClick="del_im('#currentrow#');"><i class="fa fa-minus"></i></a></td>
								<td>
									<select name="imcat_id#currentrow#" id="imcat_id#currentrow#" style="width:112px;">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="get_im_cats">
											<option value="#imcat_id#" <cfif get_ims.IMCAT_ID eq imcat_id> selected </cfif>>#imcat#</option>
										</cfloop>
									</select>
								</td>
								<td><cfinput type="text" name="im_address#currentrow#" id="im_address#currentrow#" value="#IM_ADDRESS#" style="width:120px;">
									<input type="hidden" name="del_im_info#currentrow#" id="del_im_info#currentrow#" value="1"></td>
							</tr>
						</cfoutput>
					</tbody>
				</cf_grid_list>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="get_hr_detail">
				<cf_workcube_buttons is_upd='0' add_function="loadPopupBox('employe_com')"> 
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	var add_ref_info=<cfif isdefined("get_referance")><cfoutput>#get_referance.recordcount#</cfoutput><cfelse>0</cfif>;
	var add_im_info=<cfif isdefined("get_ims")><cfoutput>#get_ims.recordcount#</cfoutput><cfelse>0</cfif>;

	function del_ref(dell){
			var my_element1=eval("employe_com.del_ref_info"+dell);
			my_element1.value=0;
			var my_element2=eval("ref_info_"+dell);
			my_element2.style.display="none";
	}
	function del_im(dell){
			var my_element3=eval("employe_com.del_im_info"+dell);
			my_element3.value=0;
			var my_element4=eval("im_info_"+dell);
			my_element4.style.display="none";
	}
	function add_ref_info_(){
		add_ref_info++;
		employe_com.add_ref_info.value=add_ref_info;
		var newRow;
		var newCell;
		newRow = document.getElementById("ref_info").insertRow(document.getElementById("ref_info").rows.length);
		newRow.setAttribute("name","ref_info_" + add_ref_info);
		newRow.setAttribute("id","ref_info_" + add_ref_info);
		document.employe_com.referance_info.value=add_ref_info;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="hidden" value="1" name="del_ref_info'+ add_ref_info +'"><a style="cursor:pointer" onclick="del_ref(' + add_ref_info + '); title="<cf_get_lang_main no ="51.sil">"><i class="fa fa-minus"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="ref_type' + add_ref_info +'" style="width:100px;"><option value="">Referans Tipi</option><cfoutput query="get_reference_type"><option value="#reference_type_id#">#reference_type#</option></cfoutput></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="text" name="ref_name' + add_ref_info +'" style=" width:90px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="text" name="ref_company' + add_ref_info +'" style=" width:90px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="text" name="ref_telcode' + add_ref_info +'" style=" width:50px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="text" name="ref_tel' + add_ref_info +'" style=" width:75px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="text" name="ref_position' + add_ref_info +'" style=" width:75px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="text" name="ref_mail' + add_ref_info +'" style=" width:75px;">';
	}
	function add_im_info_(){
		add_im_info++;
		employe_com.add_im_info.value=add_im_info;
		var newRow;
		var newCell;
		newRow = document.getElementById("im_info").insertRow(document.getElementById("im_info").rows.length);
		newRow.setAttribute("name","im_info_" + add_im_info);
		newRow.setAttribute("id","im_info_" + add_im_info);
		document.employe_com.instant_info.value=add_im_info;
		
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="hidden" value="1" name="del_im_info'+ add_im_info +'"><a style="cursor:pointer" onclick="del_im(' + add_im_info + ');" title="<cf_get_lang_main no ="51.sil">"><i class="fa fa-minus"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="imcat_id' + add_im_info +'" style="width:112px;"><option value="">Seçiniz</option><cfoutput query="get_im_cats"><option value="#imcat_id#">#imcat#</option></cfoutput></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="text" name="im_address' + add_im_info +'" style=" width:120px;">';
	}
	<cfif not len(get_hr_detail.homecity)>
		var country_ = document.employe_com.homecountry.value;
		if(country_.length)
			LoadCity(country_,'select_city','select_county',0);	
	</cfif>
</script>
