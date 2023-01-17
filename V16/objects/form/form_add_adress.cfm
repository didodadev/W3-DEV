<cfquery name="GET_COUNTRY" datasource="#DSN#">
	SELECT COUNTRY_ID, COUNTRY_NAME, IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfquery name="GET_CONSUMER" datasource="#dsn#">
	SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = #attributes.cid#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32887.Diğer Adres Ekle'></cfsavecontent>
<cf_popup_box title="#message# : #get_consumer.consumer_name# #get_consumer.consumer_surname#">
	<cfform name="form_add_partner" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_adress">
	<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.cid#</cfoutput>">
		<table>
		<tr>
			<td><cf_get_lang dictionary_id='32554.Adres Adı *'></td>
			<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='32661.Adres Adı Girmelisiniz'> ! </cfsavecontent>
			<cfinput type="text" name="contact_name" maxlength="50" required="yes" message="#message#" style="width:150px;"></td>
			<td><cf_get_lang dictionary_id='57493.Aktif'></td>
			<td><input type="checkbox" name="contact_status" id="contact_status" value="1"></td>
		</tr>
		<tr> 
			<td><cf_get_lang dictionary_id='32851.Kod/Telefon'> *</td>
			<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='33053.Geçerli Bir Telefon Kodu Giriniz'> !</cfsavecontent>
			<cfinput type="text" name="contact_telcode" maxlength="5" required="yes" message="#message#" style="width:52px;"> 
			<cfinput type="text" name="contact_tel1" maxlength="10" required="yes" message="#message#" style="width:95px;"></td>
			<td rowspan="3" valign="top"><cf_get_lang dictionary_id='58723.Adres'></td>
			<td rowspan="3" valign="top"><textarea name="contact_address" id="contact_address" style="width:150px;height:65px;"></textarea></td>
		</tr>
		<tr> 
			<td><cf_get_lang dictionary_id='57499.Telefon'> 2</td>
			<td style="text-align:right;"><input type="text" name="contact_tel2" id="contact_tel2" maxlength="10" style="width:150px;"></td>
		</tr>
		<tr> 
			<td><cf_get_lang dictionary_id='57499.Telefon'> 3</td>
			<td style="text-align:right;"><input type="text" name="contact_tel3" id="contact_tel3" value="" maxlength="10" style="width:150px;"></td>
		</tr>
		<tr> 
			<td><cf_get_lang dictionary_id='57488.Fax'></td>
			<td style="text-align:right;"><input type="text" name="contact_fax" id="contact_fax" maxlength="10" style="width:150px;"></td>
			<td><cf_get_lang dictionary_id='57472.Posta Kodu'></td>
			<td><input type="text" name="contact_postcode" id="contact_postcode" maxlength="5" style="width:150px;"></td>
		</tr>
		<tr> 
			<td><cf_get_lang dictionary_id='57428.E-mail'></td>
			<td style="text-align:right;"><input type="text" name="contact_email" id="contact_email" maxlength="50" style="width:150px;"></td>
			<td><cf_get_lang dictionary_id='58132.Semt'></td>
			<td><input type="text" name="contact_semt" id="contact_semt" maxlength="30" style="width:150px;"></td>
		</tr>
		<tr>
			<td rowspan="3" valign="top"><cf_get_lang dictionary_id='57629.Açıklama'></td>
			<td rowspan="3" valign="top"><textarea name="contact_detail" id="contact_detail" style="width:150px;height:60px;"></textarea></td>
			<td><cf_get_lang dictionary_id='58638.ilçe'></td>
			<td><input type="hidden" name="county_id" id="county_id" readonly="">
			<input type="text" name="county" id="county" value="" style="width:150px;" readonly>
			<a href="javascript://" onClick="pencere_ac();"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='57971.Şehir'></td>
			<td><input type="hidden" name="city_id" id="city_id" value="">          
			<input type="text" name="city" id="city" value="" readonly style="width:150px;">
			<a href="javascript://" onClick="pencere_ac_city();"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='58219.Ülke'></td>
			<td>
			<select name="country" id="country" onChange="remove_adress('1');" style="width:150px;">
			  <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
			  <cfoutput query="get_country">
				<option value="#get_country.country_id#" <cfif get_country.country_id eq 1>selected</cfif>>#get_country.country_name#</option>
			  </cfoutput>
			</select></td>
		</tr>
		</table>
		<cf_popup_box_footer>
		<cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
		</cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<script type="text/javascript">
function remove_adress(parametre)
{
	if(parametre==1)
	{
		document.form_add_partner.city_id.value = '';
		document.form_add_partner.city.value = '';
		document.form_add_partner.county_id.value = '';
		document.form_add_partner.county.value = '';
		document.form_add_partner.contact_telcode.value = '';
	}
	else
	{
		document.form_add_partner.county_id.value = '';
		document.form_add_partner.county.value = '';
	}	
}

function pencere_ac_city()
{
	x = document.form_add_partner.country.selectedIndex;
	if (document.form_add_partner.country[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='33069.İlk Olarak Ülke Seçiniz.'> !");
	}	
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=form_add_partner.city_id&field_name=form_add_partner.city&field_phone_code=form_add_partner.contact_telcode&country_id=' + document.form_add_partner.country.value,'small');
	}
	return remove_adress('2');
}

function pencere_ac(no)
{
	x = document.form_add_partner.country.selectedIndex;
	if (document.form_add_partner.country[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='33069.İlk Olarak Ülke Seçiniz.'> !");
	}	
	else if(document.form_add_partner.city_id.value == "")
	{
		alert("<cf_get_lang dictionary_id='33176.İl Seçiniz !'> !");
	}
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=form_add_partner.county_id&field_name=form_add_partner.county&city_id=' + document.form_add_partner.city_id.value,'small');
		return remove_adress();
	}
}

function kontrol()
{
	z = (200 - document.form_add_partner.contact_address.value.length);
	if ( z < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id='58723.Adres'><cf_get_lang dictionary_id='58210.Alanindaki Fazla Karakter Sayisi'>"+ ((-1) * z));
		return false;
	}
	z = (100 - document.form_add_partner.contact_detail.value.length);
	if ( z < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id='57629.Açıklama'>"+ ((-1) * z) +" <cf_get_lang dictionary_id='29538.Karakter Uzun'> !");
		return false;
	}
	return true;
}
</script>
