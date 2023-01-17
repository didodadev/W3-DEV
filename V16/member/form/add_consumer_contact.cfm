<cf_xml_page_edit fuseact="member.add_consumer_contact" is_multi_page="1">
<cf_get_lang_set module_name="member">
<cfinclude template="../query/get_country.cfm">
<cfquery name="GET_CONSUMER" datasource="#DSN#">
	SELECT
		CONSUMER_ID,
		CONSUMER_NAME,
		CONSUMER_SURNAME
	FROM 
		CONSUMER
	WHERE 
		CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id="30510.Diğer Adres Ekle"></cfsavecontent>
	<cf_box title="#head# : #get_consumer.consumer_name# #get_consumer.consumer_surname#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_consumer_contact" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_contact">
			<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.cid#</cfoutput>">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
					<div class="form-group" id="item-contact-name">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30508.Adres Adı'> *</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='30508.Adres Adı'>!</cfsavecontent>
							<cfinput type="text" name="contact_name" maxlength="50" required="yes" message="#message#">
						</div>
					</div>
					<div class="form-group" id="item-contact-tel">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'> *</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-4 col-md-4 col-sm-5 col-xs-12">
								<cfinput type="text" name="contact_telcode" maxlength="5" onKeyUp="isNumber(this);"> 
							</div>
							<div class="col col-8 col-md-8 col-sm-7 col-xs-12">
								<cfinput type="text" name="contact_tel1" maxlength="10" onKeyUp="isNumber(this);"> 
							</div>
						</div>
					</div>
					<div class="form-group" id="item-contact-tel2">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'> 2</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="contact_tel2" id="contact_tel2" maxlength="10" onKeyUp="isNumber(this);">
						</div>
					</div>
					<div class="form-group" id="item-contact-tel3">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'> 3</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="contact_tel3" id"contact_tel3" value="" maxlength="10" onKeyUp="isNumber(this);">
						</div>
					</div>
					<div class="form-group" id="item-contact-fax">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57488.Fax'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="contact_fax" id="contact_fax" maxlength="10" onKeyUp="isNumber(this);">
						</div>
					</div>
					<div class="form-group" id="item-contact-email">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-mail'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="contact_email" id="contact_email" maxlength="100">
						</div>
					</div>
					<div class="form-group" id="item-contact-delivery-name">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57775.Teslim Alan'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="contact_delivery_name" id="contact_delivery_name" maxlength="100">
						</div>
					</div>
					<div class="form-group" id="item-contact-semt">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58132.Semt'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="contact_semt" id="contact_semt" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-contact-company-name">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58485.Şirket Adı'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfinput type="text" name="company_name"  id="company_name" maxlength="200">
						</div>
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="2" type="column" sort="true">
					<div class="form-group" id="item-checkbox">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-6 col-md-6 col-sm-12 col-xs-12">
								<label><cf_get_lang dictionary_id='57493.Aktif'><input type="checkbox" name="contact_status" id="contact_status" value="1" checked="checked"></label>
							</div>
							<div class="col col-6 col-md-6 col-sm-12 col-xs-12">
								<label><cf_get_lang dictionary_id='30266.Kurumsal'><input type="checkbox" name="is_company" id="is_company" value="1" onClick="dis_buttons();"></label>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-contact-tax-office">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58762.Vergi Dairesi'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfsavecontent variable="alert"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>: <cf_get_lang dictionary_id="58762.Vergi Dairesi"></cfsavecontent>
							<cfinput type="text" name="tax_office" id="tax_office" maxlength="50" tabindex="8" message="#alert#">
						</div>
					</div>
					<div class="form-group" id="item-contact-tax-no">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57752.Vergi No'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57752.Vergi No!'>*</cfsavecontent>
							<cfinput type="text" name="tax_no" id="tax_no" validate="integer" message="#message#" tabindex="8" maxlength="11" onKeyUp="isNumber(this);" value=""> 
						</div>
					</div>
					<div class="form-group" id="item-contact-country-name">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="country" id="country" onChange="LoadCity(this.value,'city_id','county_id',0<cfif is_residence_select eq 1>,'district_id'</cfif>)">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_country">
									<cfset is_load_country = 1>
									<option value="#country_id#" <cfif is_default eq 1>selected</cfif>>#country_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-contact-city-name">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'><cfif xml_adres_detail_required eq 1>*</cfif></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="city_id" id="city_id" onChange="LoadCounty(this.value,'county_id','contact_telcode'<cfif is_residence_select eq 1>,'district_id'</cfif>)">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-contact-county-name">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58638.ilçe'><cfif xml_adres_detail_required eq 1>*</cfif></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="county_id" id="county_id" <cfif is_residence_select eq 1>onChange="LoadDistrict(this.value,'district_id');"</cfif>>
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-contact-postcode">
						<cfif is_adres_detail eq 0>
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58723.Adres'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<textarea name="contact_address" id="contact_address"></textarea>
							</div>
						<cfelse>
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="text" name="contact_postcode" id="contact_postcode" maxlength="5" onKeyUp="isNumber(this);">
							</div>
						</cfif>
					</div>
					<div class="form-group" id="item-contact-detail">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<textarea name="contact_detail" id="contact_detail"></textarea>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>

<script type="text/javascript">
	var country_ = document.add_consumer_contact.country.value;
	if(country_.length)
		LoadCity(country_,'city_id','county_id',0);
		
	function dis_buttons()
	{
		if(document.getElementById('is_company').checked == false)
		{
			document.getElementById('company_name').disabled = true;
			document.getElementById('tax_office').disabled = true;
			document.getElementById('tax_no').disabled = true;
		}
		else
		{
			document.getElementById('company_name').disabled = false;
			document.getElementById('tax_office').disabled = false;
			document.getElementById('tax_no').disabled = false;
		}
	}
	
	function kontrol()
	{   
		if(document.getElementById('is_company').checked == true)
		{
			if(document.getElementById('company_name').value ==  '')
			{
				alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> :<cf_get_lang dictionary_id='58485.Şirket Adı'>");
				return false;
			}
			if(document.getElementById('tax_office').value ==  '')
			{
				alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='58762.Vergi Dairesi'>");
				return false;
			}
			if(document.getElementById('tax_no').value ==  '')
			{
				alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='57752.Vergi No'>'");
				return false;
			}
		}
		
		if(document.add_consumer_contact.contact_address != undefined)
		{
			z = (200 - document.add_consumer_contact.contact_address.value.length);
			if ( z < 0 )
			{ 
				alert ("<cf_get_lang dictionary_id='58723.Adres'><cf_get_lang dictionary_id='58210.Alanindaki Fazla Karakter Sayisi'>"+ ((-1) * z));
				return false;
			}
		}
		
		z = (100 - document.add_consumer_contact.contact_detail.value.length);
		if ( z < 0 )
		{ 
			alert ("<cf_get_lang dictionary_id='57629.Açıklama'>"+ ((-1) * z) +"<cf_get_lang dictionary_id='29538.Karakter Uzun'>!");
			return false;
		}
		return true;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
