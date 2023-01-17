<cfinclude template="../query/get_company_sector.cfm">
<cfquery name="get_country" datasource="#dsn#">
	SELECT COUNTRY_ID,COUNTRY_NAME,IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfif IsDefined("attributes.id")>
	 <cf_addressbook
		design		= "3"
		id			= "#attributes.id#"
		special_emp	= "#session.ep.userid#">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box  id="FormAddressBook" title="#getLang('','Adres defteri',57429)#" popup_box="1" add_href="openBoxDraggable('#request.self#?fuseaction=correspondence.popup_new_rec')">
		<cfform name="upd_address" id="upd_address" action="#request.self#?fuseaction=correspondence.emptypopup_upd_act&id=#attributes.id#" method="post">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
					<cf_duxi name="ab_name" type="text" value="#get_AddressBook.ab_name#"  hint="Ad"label="57631" > 
					<cf_duxi name="ab_surname" type="text" value="#get_AddressBook.ab_surname#"  hint="Soyad" label="58726" >
					<cf_duxi name="ab_web" type="text" value="#get_AddressBook.ab_web#"  hint=" webAdresi" label="51251" >
					<cf_duxi name="ab_address" type="textarea" value="#get_AddressBook.ab_address#"  hint="Adres"  label="58723" gdpr="1">
					<cf_duxi name="ab_company" type="text" value="#get_AddressBook.ab_company#"  hint="Şirket"  label="57574">
					<div class="form-group" id="item-ab_sector_id">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57579.Sektör'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="ab_sector_id" id="ab_sector_id" >
								<option value=""><cf_get_lang dictionary_id='30560.Sektör Seçiniz'></option> 
								<cfoutput query="get_company_sector">
									<cfif sector_cat_id eq get_AddressBook.ab_sector_id>
										<option value="#sector_cat_id#" selected>#SECTOR_CAT#
									<cfelse>
										<option value="#sector_cat_id#">#SECTOR_CAT#
									</cfif>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
				 	<cf_duxi name="ab_title" type="text" value="#get_AddressBook.ab_title#"  hint="Ünvan"  label="57571">
					<cf_duxi name="ab_email" type="text" value="#get_AddressBook.ab_email#"  hint="E-mail"  label="32508" gdpr="1">
					<div class="form-group" id="item-ab_tel1">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='49272.Tel'>1</label>
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<cfsavecontent variable="message3"><cf_get_lang_main no='13.uyarı'>:<cf_get_lang no='218.Telefon Kodu'>-<cf_get_lang_main no='786.sayısal'></cfsavecontent>
							<cfinput type="text" style="width:50px;" name="ab_telcode" id="ab_telcode" maxlength="8" value="#get_AddressBook.ab_telcode#" validate="integer" message="#message3#" onKeyUp="isNumber(this)">
						</div>
					<div class="col col-5 col-md-5 col-sm-5 col-xs-12">	
						<cfsavecontent variable="message4"><cf_get_lang_main no='13.uyarı'>:<cf_get_lang no='219.Telefon no'>-<cf_get_lang_main no='786.sayısal'></cfsavecontent>
						<cf_duxi name='ab_tel1' id='ab_tel1' class="tableyazi" type="text" value="#get_AddressBook.ab_tel1#" gdpr="1" maxlength="7" validate="integer" message="#message4#" data_control="isnumber">
					</div>
					</div>
					<div class="form-group" id="item-ab_tel2">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='49272.Tel'>2</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfinput type="text" name="ab_tel2" id="ab_tel2" style="width:105px;" maxlength="10" value="#get_AddressBook.ab_tel2#" onKeyUp="isNumber(this)"></td>
						</div>
					</div>
					<div class="form-group" id="item-ab_mobilcode">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58482.Mobil Tel'></label>
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<cfinput type="text" name="ab_mobilcode" id="ab_mobilcode" style="width:50px;" maxlength="8" size="3" value="#get_AddressBook.ab_mobilcode#" onKeyUp="isNumber(this)">
						</div>
						<div class="col col-5 col-md-5 col-sm-5 col-xs-12">	
							<cf_duxi name='ab_mobil' id='ab_mobil' class="tableyazi" type="text" value="#get_AddressBook.ab_mobil#" gdpr="1" maxlength="7" validate="integer"  data_control="isnumber">
						</div>
					</div>
					<div class="form-group" id="item-ab_fax">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57488.Fax'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfinput type="text" name="ab_fax" id="ab_fax" style="width:105px;" maxlength="10" size="10" value="#get_AddressBook.ab_fax#" onKeyUp="isNumber(this)"></td>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-country_id">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="country_id" id="country_id" onChange="remove_adress('1');" >
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_country">
									<option value="#get_country.country_id#" <cfif get_AddressBook.ab_country_id eq get_country.country_id>selected</cfif>>#get_country.country_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-city">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58608.İl'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfif len(get_AddressBook.ab_city_id)>
									<cfquery name="GET_CITY" datasource="#dsn#">
										SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_AddressBook.ab_city_id#
									</cfquery>
									<input type="hidden" name="city_id" id="city_id" value="<cfoutput>#get_AddressBook.ab_city_id#</cfoutput>">
									<input type="text" name="city" id="city" value="<cfoutput>#get_city.city_name#</cfoutput>" readonly style="width:160px;">
								<cfelse>
									<input type="hidden" name="city_id" id="city_id" value="">
									<input type="text" name="city" id="city" value=""readonly style="width:160px;">
								</cfif>
								<span class="input-group-addon icon-ellipsis" href="javascript://"  onClick="pencere_ac_city();"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-county_id">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfif len(get_AddressBook.ab_county_id) and isnumeric(get_AddressBook.ab_county_id)>
									<cfquery name="GET_COUNTY" datasource="#DSN#">
										SELECT * FROM SETUP_COUNTY WHERE COUNTY_ID = #get_AddressBook.ab_county_id#
									</cfquery> 
									<input type="hidden" name="county_id" id="county_id" value="<cfoutput>#get_AddressBook.ab_county_id#</cfoutput>">
									<input type="text" name="county" id="county" value="<cfoutput>#get_county.county_name#</cfoutput>" readonly style="width:160px;">				  
								<cfelse>
									<input type="hidden" name="county_id" id="county_id" value="">
									<input type="text" name="county" id="county" value=""readonly style="width:160px;">
								</cfif>
								<span class="input-group-addon icon-ellipsis" href="javascript://"  onClick="pencere_ac();"></span>
							</div>
						</div>
					</div>
					<cf_duxi name="ab_semt" type="text" value="#get_AddressBook.ab_semt#"  hint="Semt"  label="58132">
					<cf_duxi name="ab_postcode" type="text" value="#get_AddressBook.ab_postcode#"  hint="Posta Kodu"  label="57472">
					<cf_duxi name="ab_info" type="textarea" value="#get_AddressBook.ab_info#"  hint="Not"  label="57467">
					<div class="form-group" id="item-special_emp">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="checkbox" name="special_emp" id="special_emp" value="1" <cfif len(get_AddressBook.special_emp) and get_AddressBook.special_emp neq 0>checked</cfif>>&nbsp;<cf_get_lang no ='212.Kişiye Özel'>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
					<cf_record_info query_name="get_AddressBook">
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
					<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=correspondence.emptypopup_del_act&id=#get_AddressBook.ab_id#'>
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function remove_adress(parametre)
{
	if(parametre==1)
	{
		document.getElementById("city_id").value = '';
		document.getElementById("city").value = '';
		document.getElementById("county_id").value = '';
		document.getElementById("county").value = '';
	}
	else if(parametre==2)
	{
		document.getElementById("county_id").value = '';
		document.getElementById("county").value = '';
	}	
}
function pencere_ac_city()
{
	if (document.getElementById("country_id").value == "")
	{
		alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no='73.öncelik'>-<cf_get_lang_main no ='807.Ulke'>");
	}	
	else
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=upd_address.city_id&field_name=upd_address.city&country_id=' + document.getElementById("country_id").value);
		return remove_adress('2');
	}
}

function pencere_ac(no)
{
	if (document.getElementById("country_id").value == "")
	{
		alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no='73.öncelik'>-<cf_get_lang_main no ='807.Ulke'>");
	}	
	else if(document.getElementById("city_id").value == "")
	{
		alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no='73.öncelik'>-<cf_get_lang_main no ='1196.il'>!");
	}
	else
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=upd_address.county_id&field_name=upd_address.county&city_id=' + document.getElementById("city_id").value);
		return remove_adress();
	}
}
function kontrol()
{
	x = (250 - document.getElementById("ab_address").value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang no ='216.Adres çok uzun'>: "+ ((-1) * x));
		return false;
	}
	x = (250 - document.getElementById("ab_info").value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang no ='217.Not çok uzun'>: "+ ((-1) * x));
		return false;
	}

	if (document.upd_address.ab_title.value.length > 100) 
	  {	
			alert("<cf_get_lang dictionary_id='57571.Ünvan'>:<cf_get_lang dictionary_id='35601.100 karakterden fazla giremezsiniz'>"); 
				return false;
	   }
	   if (document.upd_address.ab_email.value.length > 100) 
	  {	
			alert("<cf_get_lang dictionary_id='38346.Lütfen 1000 karakterden fazla mail adresi girmeyiniz'>"); 
				return false;
	   }
	   if (document.upd_address.ab_semt.value.length > 45) 
	  {	
			alert("<cf_get_lang dictionary_id='58132.semt'>:<cf_get_lang dictionary_id='29725.Maksimum Karakter Sayısı'>"); 
				return false;
	   }
	   if (document.upd_address.ab_postcode.value.length > 15) 
	  {
			alert("<cf_get_lang dictionary_id='57472.Posta Kodu'>: 15 <cf_get_lang dictionary_id='58997.Karakterden Fazla Yazmayınız'>"); 
				return false;
	   }
	   if (document.upd_address.ab_web.value.length > 100) 
	  {
			alert("<cf_get_lang dictionary_id='51521.web adresi'>:<cf_get_lang dictionary_id='35601.100 karakterden fazla giremezsiniz'>"); 
				return false;
	   }
	   if (document.upd_address.ab_company.value.length > 100) 
	  {
			alert("<cf_get_lang dictionary_id='57574.şirket'>:<cf_get_lang dictionary_id='35601.100 karakterden fazla giremezsiniz'>"); 
				return false;
	   }
	if(ab_name.value == '')
        {
            alertObject({message: "<cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='57631.Ad'>"});
            return false;
        }
		if(ab_surname.value == '')
        {
            alertObject({message: "<cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='58726.Soyad'>"});
            return false;
        }
	return true;
}
</script>
