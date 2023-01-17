<cfquery name="GET_COUNTRY" datasource="#DSN#">
	SELECT COUNTRY_ID, COUNTRY_NAME, IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfquery name="GET_CONTACT" datasource="#DSN#">
	SELECT 
		CONSUMER.CONSUMER_NAME,
		CONSUMER.CONSUMER_SURNAME,
		CONSUMER_BRANCH.*
	FROM
		CONSUMER,
		CONSUMER_BRANCH
	WHERE
		CONSUMER_BRANCH.CONSUMER_ID = CONSUMER.CONSUMER_ID AND
		CONSUMER_BRANCH.CONTACT_ID = #attributes.contactid#	
</cfquery>
<cfsavecontent variable="right_">
	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_form_add_adress&cid=#attributes.cid#</cfoutput>','page');"><img src="/images/plus1.gif" title="<cf_get_lang_main no='170.Ekle'>"></a>
</cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33229.Adres Güncelle'></cfsavecontent>
<cf_popup_box title="#message# : #get_contact.consumer_name# #get_contact.consumer_surname#" right_images="#right_#">
	<cfform name="upd_consumer_contact" method="post" action="#request.self#?fuseaction=objects.emptypopup_upd_adress">
	<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.cid#</cfoutput>">
	<input type="hidden" name="contact_id" id="contact_id" value="<cfoutput>#attributes.contactid#</cfoutput>">
		<table>
			<tr> 
				<td><cf_get_lang dictionary_id='35667.Adres Adı'> *</td>
				<td colspan="2"><cfsavecontent variable="message"><cf_get_lang dictionary_id='32661.Adres Adı Girmelisiniz'> !</cfsavecontent>
				<cfinput type="text" name="contact_name" value="#get_contact.contact_name#" required="yes" message="#message#" maxlength="50" style="width:151px;"></td>
				<td><cf_get_lang dictionary_id='57493.Aktif'></td>
				<td><input type="checkbox" name="contact_status" id="contact_status" <cfif get_contact.status eq 1>checked</cfif>></td>
			</tr>
			<tr> 
				<td><cf_get_lang dictionary_id='32851.Kod/ Telefon'> 1 *</td>
				<td>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='51606.Geçerli Bir Telefon Kodu Giriniz'> !</cfsavecontent>
				<cfinput type="text" name="contact_telcode" value="#get_contact.contact_telcode#" required="yes" message="#message#" style="width:55px;"></td>
				<td> 
				<cfsavecontent variable="message1"><cf_get_lang dictionary_id='53038.Telefon Girmelisiniz'> !</cfsavecontent>
				<cfinput type="text" name="contact_tel1" value="#get_contact.contact_tel1#" required="yes" maxlength="10" message="#message1#" style="width:90px;"></td>
				<td rowspan="3" valign="top"><cf_get_lang dictionary_id='58723.Adres'></td>
				<td rowspan="3" valign="top"><textarea name="contact_address" id="contact_address" style="width:150px;height:65px;"><cfoutput>#get_contact.contact_address#</cfoutput></textarea></td>
			</tr>
			<tr> 
				<td><cf_get_lang dictionary_id='57499.Telefon'> 2</td>
				<td></td>
				<td>
				<input type="text" name="contact_tel2" id="contact_tel2" value="<cfoutput>#get_contact.contact_tel2#</cfoutput>" maxlength="10" style="width:90px;"></td>
			</tr>
			<tr> 
				<td><cf_get_lang dictionary_id='57499.Telefon'> 3</td>
				<td></td>
				<td><input type="text" name="contact_tel3" id="contact_tel3" value="<cfoutput>#get_contact.contact_tel3#</cfoutput>" maxlength="10" style="width:90px;"></td>
			</tr>
			<tr> 
				<td><cf_get_lang dictionary_id='57488.Fax'></td>
				<td></td>
				<td><input type="text" name="contact_fax" id="contact_fax" value="<cfoutput>#get_contact.contact_fax#</cfoutput>" maxlength="10" style="width:90px;"></td>
				<td><cf_get_lang dictionary_id='57472.Posta Kodu'></td>
				<td><input type="text" name="contact_postcode" id="contact_postcode" value="<cfoutput>#get_contact.contact_postcode#</cfoutput>" maxlength="5" style="width:150px;"></td>
			</tr>
			<tr> 
				<td><cf_get_lang dictionary_id='57428.E-mail'></td>
				<td colspan="2"><input type="text" name="contact_email" id="contact_email" value="<cfoutput>#get_contact.contact_email#</cfoutput>" maxlength="50" style="width:151px;"></td>
				<td><cf_get_lang dictionary_id='58132.Semt'></td>
				<td><input type="text" name="contact_semt" id="contact_semt" value="<cfoutput>#get_contact.contact_semt#</cfoutput>" maxlength="50" style="width:150px;"></td>
			</tr>
			<tr> 
				<td rowspan="3" valign="top"><cf_get_lang dictionary_id='57629.Açıklama'></td>
				<td colspan="2" rowspan="3" valign="top"><textarea name="contact_detail" id="contact_detail" style="width:151px;height:60px;"><cfoutput>#get_contact.contact_detail#</cfoutput></textarea></td>
				<td><cf_get_lang dictionary_id='58638.Ilce'></td>
				<td>
					<cfif len(get_contact.contact_county_id)>
						<cfquery name="GET_COUNTY" datasource="#DSN#">
							SELECT * FROM SETUP_COUNTY WHERE COUNTY_ID = #get_contact.contact_county_id#
						</cfquery>		
						<input type="hidden" name="county_id" id="county_id" value="<cfoutput>#get_contact.contact_county_id#</cfoutput>">
						<input type="text" name="county" id="county" value="<cfoutput>#get_county.county_name#</cfoutput>" readonly style="width:150px;">				  
					<cfelse>
						<input type="hidden" name="county_id" id="county_id" value="">
						<input type="text" name="county" id="county" value=""readonly style="width:150px;">
					</cfif>
					<a href="javascript://" onClick="pencere_ac();"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
				</td>				
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57971.Şehir'></td>
				<td>
					<cfif len(get_contact.contact_city_id)>
						<cfquery name="GET_CITY" datasource="#DSN#">
							SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_contact.contact_city_id#
						</cfquery>
						<input type="hidden" name="city_id" id="city_id" value="<cfoutput>#get_contact.contact_city_id#</cfoutput>">
						<input type="text" name="city" id="city" value="<cfoutput>#get_city.city_name#</cfoutput>" readonly style="width:150px;">
					<cfelse>
						<input type="hidden" name="city_id" id="city_id" value="">
						<input type="text" name="city" id="city" value="" readonly style="width:150px;">
					</cfif>
					<a href="javascript://" onClick="pencere_ac_city();"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='58219.Ülke'></td>
				<td>
					<select name="country" id="country" onChange="remove_adress('1');" style="width:150px;">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfoutput query="get_country">
							<option value="#get_country.country_id#" <cfif get_contact.contact_country_id eq get_country.country_id>selected</cfif>>#get_country.country_name#</option>
						</cfoutput>
					</select>
				</td>
			</tr>
		</table>
		<cf_popup_box_footer>
			<cf_record_info query_name="get_contact">
			<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
		</cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<script type="text/javascript">
function remove_adress(parametre)
{
	if(parametre==1)
	{
		document.upd_consumer_contact.city_id.value = '';
		document.upd_consumer_contact.city.value = '';
		document.upd_consumer_contact.county_id.value = '';
		document.upd_consumer_contact.county.value = '';
		document.upd_consumer_contact.contact_telcode.value = '';
	}
	else
	{
		document.upd_consumer_contact.county_id.value = '';
		document.upd_consumer_contact.county.value = '';
	}	
}

function pencere_ac_city()
{
	
	x = document.upd_consumer_contact.country.selectedIndex;
	if (document.upd_consumer_contact.country[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='56176.İlk Olarak Ülke Seçiniz'>.");
	}	
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=upd_consumer_contact.city_id&field_name=upd_consumer_contact.city&field_phone_code=upd_consumer_contact.contact_telcode&country_id=' + document.upd_consumer_contact.country.value,'small');
	}
	return remove_adress('2');
}

function pencere_ac(no)
{
	x = document.upd_consumer_contact.country.selectedIndex;
	if (document.upd_consumer_contact.country[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='56176.İlk Olarak Ülke Seçiniz'>.");
	}	
	else if(document.upd_consumer_contact.city_id.value == "")
	{
		alert("<cf_get_lang dictionary_id='33176.İl Seçiniz'> !");
	}
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=upd_consumer_contact.county_id&field_name=upd_consumer_contact.county&city_id=' + document.upd_consumer_contact.city_id.value,'small');
		return remove_adress();
	}
}

function kontrol()
{
	z = (200 - document.upd_consumer_contact.contact_address.value.length);
	if ( z < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id='58723.Adres'> <cf_get_lang dictionary_id='58210.Alanindaki Fazla Karakter Sayisi'>"+ ((-1) * z));
		return false;
	}
	z = (100 - document.upd_consumer_contact.contact_detail.value.length);
	if ( z < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id='57629.Açıklama'> "+ ((-1) * z) + "<cf_get_lang dictionary_id='29538.Karakter Uzun'> !");
		return false;
	}
	return true;
}
</script>
