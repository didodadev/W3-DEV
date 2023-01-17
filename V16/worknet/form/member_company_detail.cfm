<cf_box id="formUpd" closable="0" collapsable="0" title="#getLang(dictionary_id:30366)# #getLang('main',5)# : #getCompany.fullname#">
	<cfform name="form_upd_company" method="post" action="" enctype="multipart/form-data"><!---#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_member_company--->
		<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#attributes.cpid#</cfoutput>">
		<div class="row" type="row">
			<!--- Left --->
			<div class="col col-5 col-md-6 col-sm-8 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-member_code">
					<label class="col col-3 col-xs-12 control-label"><cf_get_lang dictionary_id='30366.Watalogy'> <cf_get_lang dictionary_id='30707.Member Code'></label>
					<div class='col col-6 col-xs-12'>
						<input type='text' name='wat_code' id="wat_code" value="<cfoutput>#getCompany.WATALOGY_MEMBER_CODE#</cfoutput>" readonly/>
					</div>
				</div>
				<div class="form-group" id="item-member_name">
					<label class="col col-3 col-xs-12 control-label"><cf_get_lang dictionary_id='57199.Üye Adı'> *</label>
					<div class='col col-6 col-xs-12'>
						<input type='text' name='fullname' id="fullname" value="<cfoutput>#getCompany.fullname#</cfoutput>"/>
						<input type="hidden" name="is_status" id="is_status" value="1">
						<input type="hidden" name="process_stage" id="process_stage" value="1">
					</div>
				</div>
				<div class="form-group" id="item-member_nickname">
					<label class="col col-3 col-xs-12 control-label"><cf_get_lang dictionary_id='38744.Nickname'> *</label>
					<div class='col col-6 col-xs-12'>
						<input type='text' name='nickname' id="nickname" value="<cfoutput>#getCompany.nickname#</cfoutput>"/>
					</div>
				</div>
				<div class="form-group" id="item-tax_office">
					<label class="col col-3 col-xs-12 control-label"><cf_get_lang dictionary_id='58762.Vergi Dairesi'> *</label>
					<div class='col col-6 col-xs-12'>
						<input type='text' name='taxoffice' id="taxoffice" maxlength="30" value="<cfoutput>#getCompany.TAXOFFICE#</cfoutput>"/>
					</div>
				</div>
				<div class="form-group" id="item-tax_no">
					<label class="col col-3 col-xs-12 control-label">VKN-<cf_get_lang dictionary_id='57752.Vergi No'> *</label>
					<div class='col col-6 col-xs-12'>
						<input type='text' name='taxno' id="taxno" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfoutput>#getCompany.TAXNO#</cfoutput>" maxlength="12">
					</div>
				</div>
				<div class="form-group" id="item-company_partner">
					<label class="col col-3 col-xs-12 control-label"><cf_get_lang_main dictionary_id='57578.Yetkili'><cf_get_lang_main dictionary_id='57570.Ad Soyad'> *</label>
					<div class='col col-6 col-xs-12'>
						<!--- <input type="text" name="partner_name" id="partner_name" value=""> --->
						<select name="manager_partner_id" id="manager_partner_id" style="width:150px;">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="getPartner">
								<option value="#getPartner.partner_id#" <cfif getPartner.partner_id is getCompany.manager_partner_id>selected</cfif>>#getPartner.company_partner_name# #getPartner.company_partner_surname#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-partner_email">
				<label class="col col-3 col-xs-12 control-label"><cf_get_lang dictionary_id='33152.Email'> *</label>
				<div class='col col-6 col-xs-12'>
					<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='16.E-mail'></cfsavecontent>
					<cfinput type="text" name="email" id="email" value="#getCompany.COMPANY_EMAIL#" validate="email" message="#message#" maxlength="100">
				</div>
				</div>
				<div class="form-group" id="item-phone1">
					<label class="col col-3 col-xs-12 control-label"><cf_get_lang_main dictionary_id='49272.Tel'> 1 *</label>
					<div class='col col-2 col-xs-4'>
						<input maxlength="5" type="text" name="telcod1" id="telcod1" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfoutput>#getCompany.COMPANY_TELCODE#</cfoutput>">
					</div>
					<div class='col col-4 col-xs-8'>
						<input maxlength="20" type="text" name="tel1" id="tel1" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfoutput>#getCompany.COMPANY_TEL1#</cfoutput>">
					</div>
				</div>
				<div class="form-group" id="item-phone2">
					<label class="col col-3 col-xs-12 control-label"><cf_get_lang_main dictionary_id='49272.Tel'> 2 *</label>
					<div class='col col-2 col-xs-4'>
						<input maxlength="5" type="text" name="telcod2" id="telcod2" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfoutput>#getCompany.COMPANY_TELCODE#</cfoutput>">
					</div>
					<div class='col col-4 col-xs-8'>
						<input maxlength="20" type="text" name="tel2" id="tel2" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfoutput>#getCompany.COMPANY_TEL2#</cfoutput>">
					</div>
				</div>
				<div class="form-group" id="item-country">
					<label class="col col-3 col-xs-12 control-label"><cf_get_lang_main no='807.Ulke'> *</label>
					<div class='col col-6 col-xs-12'>
						<select name="country" id="country" onchange="LoadCity(this.value,'city_id','county_id',0)"> 
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="getCountry">
								<option value="#country_id#" <cfif getCompany.country eq country_id>selected</cfif>>#country_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-city">
					<label class="col col-3 col-xs-12 control-label"><cf_get_lang_main no='559.Sehir'> *</label>
					<div class='col col-6 col-xs-12'>
						<select name="city_id" id="city_id" onChange="LoadCounty(this.value,'county_id','telcod')">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="getCity">
								<option value="#city_id#" <cfif getCompany.city eq city_id>selected</cfif>>#city_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-county">
					<label class="col col-3 col-xs-12 control-label"><cf_get_lang_main no='1226.Ilce'> *</label>
					<div class='col col-6 col-xs-12'>
						<select name="county_id" id="county_id">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>	
							<cfoutput query="getCounty">
								<option value="#county_id#" <cfif getCompany.county eq county_id>selected</cfif>>#county_name#</option>
							</cfoutput>					
						</select>
					</div>
				</div>
				<div class="form-group" id="item-post_code">
					<label class="col col-3 col-xs-12 control-label"><cf_get_lang_main no='60.Posta Kodu'> *</label>
					<div class='col col-6 col-xs-12'>
						<input type="text" name="postcod" id="postcod" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfoutput>#getCompany.company_postcode#</cfoutput>" maxlength="5">
					</div>
				</div>
				<div class="form-group" id="item-adress">
					<label class="col col-3 col-xs-12 control-label"><cf_get_lang_main no='1311.Adres'> *</label>
					<div class='col col-6 col-xs-12'>
						<cfsavecontent variable="message"><cf_get_lang no ='611.Adres Uzunluğu 200 Karakteri Geçemez'></cfsavecontent>
						<textarea name="address" id="address" style="height:65px;" message="<cfoutput>#message#</cfoutput>" maxlength="200" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"><cfoutput>#getCompany.COMPANY_ADDRESS#</cfoutput></textarea>
					</div>
				</div>
			</div>
			<div class="col col-5 col-md-6 col-sm-8 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group" id="item-member_code">
					<label class="col col-3 col-xs-12 control-label"><cf_get_lang dictionary_id='58783.Workcube'> <cf_get_lang dictionary_id='57892.Domain'> *</label>
					<div class='col col-6 col-xs-12'>
						<input type='text' name='domain' id="domain" value="<cfoutput>#getCompany.DOMAIN#</cfoutput>"/>
					</div>
				</div>
			</div>
		</div>
		<div class="row formContentFooter">
			<div class="col col-12">
				<cf_workcube_buttons is_upd='1' add_function='kontrol()'>
				<cf_record_info query_name="getCompany">
			</div>
		</div>
	</cfform>
</cf_box>