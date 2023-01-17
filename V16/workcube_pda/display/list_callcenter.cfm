<cfparam name="attributes.name" default="">
<cfquery name="GET_MOBILCAT" datasource="#DSN#">
	SELECT MOBILCAT_ID,MOBILCAT FROM SETUP_MOBILCAT ORDER BY MOBILCAT ASC
</cfquery>
<cfif isdefined("attributes.form_submitted")>
<cfquery name="search" datasource="#dsn#">
	SELECT 
		1 TYPE,
		COMPANY_PARTNER.COMPANY_ID,
		COMPANY_PARTNER.PARTNER_ID,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY_PARTNER.COMPANY_PARTNER_POSTCODE,
		COMPANY_PARTNER.COMPANY_PARTNER_ADDRESS,
		COMPANY_PARTNER.COMPANY_PARTNER_EMAIL,
		COMPANY_PARTNER.COMPANY_PARTNER_TELCODE,
		COMPANY_PARTNER.COMPANY_PARTNER_TEL,
		COMPANY_PARTNER.COMPANY_PARTNER_FAX,
		COMPANY_PARTNER.MOBIL_CODE,
		COMPANY_PARTNER.MOBILTEL,
		COMPANY.TAXNO,
		COMPANY.MEMBER_CODE,
		COMPANY_PARTNER.CITY,
		COMPANY_PARTNER.COUNTY,
		COMPANY_PARTNER.SEMT,
		COMPANY.FULLNAME
	FROM
		COMPANY_PARTNER,
		COMPANY
	WHERE
		1=1
		AND COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID
		<cfif len(attributes.name)>AND COMPANY_PARTNER.COMPANY_PARTNER_NAME = '#attributes.name#'</cfif>
		<cfif len(attributes.surname)>AND COMPANY_PARTNER.COMPANY_PARTNER_SURNAME = '#attributes.surname#'</cfif>
		<cfif len(attributes.firm)>AND( COMPANY.FULLNAME LIKE '%#attributes.firm#%' OR COMPANY.NICKNAME LIKE '%#attributes.firm#%')</cfif>
		<cfif len(attributes.tel)><cfif len(attributes.telcode)>AND COMPANY_PARTNER.COMPANY_PARTNER_TEL = '#attributes.tel#' AND COMPANY_PARTNER.COMPANY_PARTNER_TELCODE = '#attributes.telcode#'<cfelse>AND COMPANY_PARTNER.COMPANY_PARTNER_TEL = '#attributes.tel#'</cfif></cfif>
		<cfif len(attributes.mobiltel)><cfif len(attributes.mobilcat_id)>AND COMPANY_PARTNER.MOBILTEL = '#attributes.mobiltel#' AND COMPANY_PARTNER.MOBIL_CODE = '#attributes.mobilcat_id#'<cfelse>AND COMPANY_PARTNER.MOBILTEL = '#attributes.mobiltel#'</cfif></cfif>		
		<cfif len(attributes.email)>AND COMPANY_PARTNER.COMPANY_PARTNER_EMAIL = '#attributes.email#'</cfif>
		<cfif len(attributes.fax)>AND COMPANY_PARTNER.COMPANY_PARTNER_FAX = '#attributes.fax#'</cfif>
		<cfif len(attributes.city_id)>AND COMPANY_PARTNER.CITY = '#attributes.city_id#'</cfif>
		<cfif len(attributes.county_id)>AND COMPANY_PARTNER.COUNTY = '#attributes.county_id#'</cfif>
		<cfif len(attributes.semt)>AND COMPANY_PARTNER.SEMT = '#attributes.semt#'</cfif>
		<cfif len(attributes.post_code)>AND COMPANY_PARTNER.COMPANY_PARTNER_POSTCODE = '#attributes.post_code#'</cfif>
		<cfif len(attributes.address)>AND COMPANY_PARTNER.COMPANY_PARTNER_ADDRESS = '#attributes.address#'</cfif>
		<cfif len(attributes.tax_no)>AND COMPANY.TAXNO = '#attributes.tax_no#'</cfif>
		<cfif len(attributes.uye_no)>AND COMPANY.MEMBER_CODE = '#attributes.uye_no#'</cfif>
	UNION ALL
	SELECT
		2 TYPE,
		CONSUMER_ID,
		0,
		CONSUMER_NAME,
		CONSUMER_SURNAME,
		HOMEPOSTCODE,
		HOMEADDRESS,
		CONSUMER_EMAIL,
		CONSUMER_HOMETELCODE,
		CONSUMER_HOMETEL,
		CONSUMER_FAX,
		MOBIL_CODE,
		MOBILTEL,
		TAX_NO,
		MEMBER_CODE,
		HOME_CITY_ID,
		HOME_COUNTY_ID,
		HOMESEMT,
		COMPANY	
	FROM
		CONSUMER
	WHERE
		1=1
		<cfif len(attributes.name)>AND CONSUMER_NAME = '#attributes.name#'</cfif>
		<cfif len(attributes.surname)>AND CONSUMER_SURNAME = '#attributes.surname#'</cfif>
		<cfif len(attributes.firm)>AND COMPANY = '#attributes.firm#'</cfif>
		<cfif len(attributes.tel)><cfif len(attributes.telcode)>AND CONSUMER_HOMETEL = '#attributes.tel#' AND CONSUMER_HOMETELCODE = '#attributes.telcode#'<cfelse>AND CONSUMER_HOMETEL = '#attributes.tel#'</cfif></cfif>
		<cfif len(attributes.mobiltel)><cfif len(attributes.mobilcat_id)>AND MOBILTEL = '#attributes.mobiltel#' AND MOBIL_CODE = '#attributes.mobilcat_id#'<cfelse>AND MOBILTEL = '#attributes.mobiltel#'</cfif></cfif>		
		<cfif len(attributes.email)>AND CONSUMER_EMAIL = '#attributes.email#'</cfif>
		<cfif len(attributes.fax)>AND CONSUMER_FAX = '#attributes.fax#'</cfif>
		<cfif len(attributes.city_id)>AND HOME_CITY_ID = '#attributes.city_id#'</cfif>
		<cfif len(attributes.county_id)>AND HOME_COUNTY_ID = '#attributes.county_id#'</cfif>
		<cfif len(attributes.semt)>AND HOMESEMT = '#attributes.semt#'</cfif>
		<cfif len(attributes.post_code)>AND HOMEPOSTCODE = '#attributes.post_code#'</cfif>
		<cfif len(attributes.address)>AND HOMEADDRESS = '#attributes.address#'</cfif>
		<cfif len(attributes.tax_no)>AND TAX_NO = '#attributes.tax_no#'</cfif>
		<cfif len(attributes.uye_no)>AND MEMBER_CODE = '#attributes.uye_no#'</cfif>
</cfquery>
<cfelse>
	<cfset search.recordcount = 0>
</cfif>
<cfform name="get_part" action="#request.self#?fuseaction=pda.popup_list_callcenter" method="post">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
<table cellpadding="0" cellspacing="0" border="0" style="width:58mm;">
<cfoutput>
	<tr class="color-row" height="25">
		<td >
			<a href="#request.self#?fuseaction=pda.popup_list_callcenter" class="txtsubmenu"><b>Üye Ara</b></a> :
		</td>
	</tr>
</cfoutput>
</table>
<table>
	<tr>
		<td>Ad Soyad</td>
		<td><input type="text" name="name" id="name" value="<cfif isdefined("attributes.name")><cfoutput>#attributes.name#</cfoutput></cfif>" style="width:64px;">
			<input type="text" name="surname" id="surname" value="<cfif isdefined("attributes.surname")><cfoutput>#attributes.surname#</cfoutput></cfif>" style="width:64px;">
		</td>
	</tr>
	<tr>
		<td>Firma</td>	
		<td><input type="text" name="firm" id="firm" value="<cfif isdefined("attributes.firm")><cfoutput>#attributes.firm#</cfoutput></cfif>" style="width:130px;"></td>
	</tr>
	<tr>
		<td>Üye No</td>
		<td><input type="text" name="uye_no" id="uye_no" value="<cfif isdefined("attributes.uye_no")><cfoutput>#attributes.uye_no#</cfoutput></cfif>" style="width:130px;"></td>
	</tr>
	<tr>
		<td>Vergi No</td>
		<td><input type="text" name="tax_no" id="tax_no" value="<cfif isdefined("attributes.tax_no")><cfoutput>#attributes.tax_no#</cfoutput></cfif>" style="width:130px;"></td>
	</tr>
	<tr>
		<td>E-Mail</td>
		<td><input type="text" name="email" id="email" value="<cfif isdefined("attributes.email")><cfoutput>#attributes.email#</cfoutput></cfif>" style="width:130px;"></td>
	</tr>
	<tr>
		<td>Tel</td>
		<td>
		<input maxlength="4" type="text" name="telcode" id="telcode" value="<cfif isdefined("attributes.telcode")><cfoutput>#attributes.telcode#</cfoutput></cfif>" style="width:48px;">
		<input maxlength="7" type="text" name="tel" id="tel" value="<cfif isdefined("attributes.tel")><cfoutput>#attributes.tel#</cfoutput></cfif>" style="width:79px;"></td> 
	</tr>
	<tr>
		<td>Fax</td>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="text" name="fax" id="fax" value="<cfif isdefined("attributes.fax")><cfoutput>#attributes.fax#</cfoutput></cfif>" style="width:79px;"></td>
	</tr>
	<tr>
		<td>Cep Tel</td>
		<td>
		<select name="mobilcat_id" value="" style="width:49px;">
		  <option value="">Kod</option>
		  <cfoutput query="GET_MOBILCAT">
			<option value="#mobilcat#" <cfif isdefined("attributes.mobilcat_id") and attributes.mobilcat_id eq mobilcat>selected</cfif>>#mobilcat#</option>
		  </cfoutput>
		  </select>
		  <cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no="2186.Mobil Kod"></cfsavecontent>
		  <cfif isdefined("attributes.mobiltel")>
		  	<cfinput type="text" name="mobiltel" maxlength="7" validate="integer" message="#message#" style="width:79px;" value="#attributes.mobiltel#">
		  <cfelse>
		  	<cfinput type="text" name="mobiltel" maxlength="7" validate="integer" message="#message#" style="width:79px;" value="">
		  </cfif>
		</td>
	</tr>
	<tr>
		<td>İl</td>
		<td><input type="hidden" name="city_id" id="city_id" value="<cfif isdefined("attributes.city_id")><cfoutput>#attributes.city_id#</cfoutput></cfif>">
			<input type="text" name="city" id="city" value="<cfif isdefined("attributes.city")><cfoutput>#attributes.city#</cfoutput></cfif>" readonly style="width:115px;">
			<a href="javascript://" onClick="pencere_ac_city();"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
		</td>
	</tr>
	<tr>
		<td>İlçe</td>
		<td><input type="hidden" name="county_id" id="county_id" value="<cfif isdefined("attributes.county_id")><cfoutput>#attributes.county_id#</cfoutput></cfif>" readonly="">
			<input type="text" name="county" id="county" value="<cfif isdefined("attributes.county")><cfoutput>#attributes.county#</cfoutput></cfif>" style="width:115px;" readonly>
			<a href="javascript://" onClick="pencere_ac();"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
		</td>
	</tr>
	<tr>
		<td>Semt</td>
		<td><input type="text" name="semt" id="semt" value="<cfif isdefined("attributes.semt")><cfoutput>#attributes.semt#</cfoutput></cfif>" style="width:130px;"></td>
	</tr>
	<tr>
		<td>Posta Kod</td>
		<td><input type="text" name="post_code" id="post_code" value="<cfif isdefined("attributes.post_code")><cfoutput>#attributes.post_code#</cfoutput></cfif>" style="width:130px;"></td>
	</tr>
	<tr>
		<td>Adres</td>
		<td><textarea name="address" style="height:50px; width:130px;"><cfif isdefined("attributes.address")><cfoutput>#attributes.address#</cfoutput></cfif></textarea></td>
	</tr>
	<tr>
		<td align="right" colspan="2"><cf_workcube_buttons is_cancel='0' insert_info='Ara' insert_alert = '' add_function='control()'></td>
	</tr>
</cfform>
</table>
<cfif search.recordcount>
<table cellspacing="1" cellpadding="1" width="98%" border="0" align="center">
	<cfoutput query="search">
	<tr>
		<td><b>Üye No</b> : #MEMBER_CODE#</td>
	</tr>
	<tr>
		<td><b>Ad Soyad</b> : <cfif #type# eq 1> <a href="##" onClick="type_('#company_id#','#partner_id#','partner');" class="tableyazi">#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#</a><cfelse><a href="##" onClick="type__('#company_id#','consumer');" class="tableyazi">#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#</a></cfif></td>
	</tr>
	<tr>
		<td><b>Firma</b> : #FULLNAME#</td>
	</tr>
	<tr>
		<td><b>Tel</b> : #COMPANY_PARTNER_TELCODE# #COMPANY_PARTNER_TEL#</td>
	</tr>
	<tr>
		<td><b>Cep Tel</b> : #MOBIL_CODE# #MOBILTEL#</td>
	</tr>
	<tr>
		<td><b>Vergi No</b> : #TAXNO#</td>
	<tr>
		<td><b>E-Mail</b> : #COMPANY_PARTNER_EMAIL#</td>
	</tr>
	<tr>
		<td><hr></td>
	</tr>
	</cfoutput>
</table>
<cfelse>
	<cfif isdefined("attributes.form_submitted")>
	<br/>
<table cellspacing="1" cellpadding="1" width="98%" border="0" align="center">
	<tr>
		<td colspan="2" height="22">Benzer kriterlerde kayıt bulunamadı!</td>
	</tr>
	<tr>
		<td align="center">
			<br/>
			<a href="javascript://" onClick="bireysel();"><input type="button" value="Bireysel Üye Olarak Kaydet" name="bireysel" id="bireysel" style="width:150;"></a>
			<a href="javascript://" onClick="kurumsal();"><input type="button" value="Kurumsal Üye Olarak Kaydet" name="kurumsal" id="kurumsal" style="width:150;"></a>
			<br/>
		</td>
	</tr>
</table>
	</cfif>
</cfif>
<script type="text/javascript">
document.getElementById('name').focus();
function pencere_ac_city()
{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=pda.popup_dsp_city&field_id=get_part.city_id&field_name=get_part.city','small');
}
function pencere_ac()
{
	if(document.get_part.city_id.value == "")
	{
		alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1196.İl'>");
	}
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=pda.popup_dsp_county&field_id=get_part.county_id&field_name=get_part.county&city_id=' + document.get_part.city_id.value,'small');
	}
}
function bireysel()
{
	window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=pda.popup_add_consumer&consumer_name=' + document.get_part.name.value + '&consumer_surname=' + document.get_part.surname.value + '&home_telcode=' + document.get_part.telcode.value + '&home_tel=' + document.get_part.tel.value + '&mobilcat_id=' + document.get_part.mobilcat_id.value + '&mobiltel=' + document.get_part.mobiltel.value + '&work_faxcode=' + document.get_part.telcode.value + '&work_fax=' + document.get_part.fax.value + '&consumer_email=' + document.get_part.email.value + '&tax_no=' + document.get_part.tax_no.value + '&home_city=' + document.get_part.city.value + '&home_county=' + document.get_part.county.value + '&home_city_id=' + document.get_part.city_id.value + '&home_county_id=' + document.get_part.county_id.value + '&home_semt=' + document.get_part.semt.value + '&home_postcode=' + document.get_part.post_code.value + '&home_address=' + document.get_part.address.value + '&company=' + document.get_part.firm.value;
}
function kurumsal()
{
	window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=member.form_add_company&name=' + document.get_part.name.value + '&soyad=' + document.get_part.surname.value + '&telcod=' + document.get_part.telcode.value + '&tel1=' + document.get_part.tel.value + '&mobiltel=' + document.get_part.mobiltel.value + '&fax=' + document.get_part.fax.value + '&email=' + document.get_part.email.value + '&vno=' + document.get_part.tax_no.value + '&city=' + document.get_part.city.value + '&county=' + document.get_part.county.value + '&city_id=' + document.get_part.city_id.value + '&county_id=' + document.get_part.county_id.value + '&semt=' + document.get_part.semt.value + '&postcod=' + document.get_part.post_code.value + '&adres=' + document.get_part.address.value + '&fullname=' + document.get_part.firm.value + '&nickname=' + document.get_part.firm.value;
}
function control()
{
	if(document.get_part.name.value == ""  && document.get_part.surname.value == "" && document.get_part.tel.value == ""  && document.get_part.post_code.value == "" && document.get_part.city_id.value == "" && document.get_part.county_id.value == "" && document.get_part.firm.value == "" && document.get_part.mobiltel.value == "" && document.get_part.semt.value == "" && document.get_part.uye_no.value == "" && document.get_part.address.value == "" && document.get_part.tax_no.value == "" && document.get_part.email.value == "" && document.get_part.fax.value == "")
	{
	alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='74.Kategori'>");
	return false;
	}
	var numberformat = "1234567890";
	for (var i = 1; i < get_part.tel.value.length; i++)
	{
		check_tel_code_number = numberformat.indexOf(get_part.tel.value.charAt(i));
		if (check_tel_code_number < 0)
		{
			alert("Telefon Kodu Sayısal Olmalıdır !");
			get_part.tel.focus();
			return false;
		}
	}
	for (var i = 1; i < get_part.mobiltel.value.length; i++)
	{
		check_mobiltel = numberformat.indexOf(get_part.mobiltel.value.charAt(i));
		if (check_mobiltel < 0)
		{
			alert("Telefon No Sayısal Olmalıdır !");
			get_part.mobiltel.focus();
			return false;
		}
	}
	for (var i = 1; i < get_part.fax.value.length; i++)
	{
		check_fax = numberformat.indexOf(get_part.fax.value.charAt(i));
		if (check_fax < 0)
		{
			alert("Telefon No Sayısal Olmalıdır !");
			get_part.fax.focus();
			return false;
		}
	}
	for (var i = 1; i < get_part.uye_no.value.length; i++)
	{
		check_uye_no = numberformat.indexOf(get_part.uye_no.value.charAt(i));
		if (check_uye_no < 0)
		{
			alert("Üye No Sayısal Olmalıdır !");
			get_part.uye_no.focus();
			return false;
		}
	}
	for (var i = 1; i < get_part.tax_no.value.length; i++)
	{
		check_tax_no = numberformat.indexOf(get_part.tax_no.value.charAt(i));
		if (check_tax_no < 0)
		{
			alert("Vergi No Sayısal Olmalıdır !");
			get_part.tax_no.focus();
			return false;
		}
	}
	for (var i = 1; i < get_part.telcode.value.length; i++)
	{
		check_telcode = numberformat.indexOf(get_part.telcode.value.charAt(i));
		if (check_telcode < 0)
		{
			alert("Tel Code Sayısal Olmalıdır !");
			get_part.telcode.focus();
			return false;
		}
	}
	for (var i = 1; i < get_part.post_code.value.length; i++)
	{
		check_post_code = numberformat.indexOf(get_part.post_code.value.charAt(i));
		if (check_post_code < 0)
		{
			alert("Posta Kodu Sayısal Olmalıdır !");
			get_part.post_code.focus();
			return false;
		}
	}
}
function type_(company_id,partner_id,type)
{	
	window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_company_details&cpid=' + company_id + '&member_type=' + type;
	windowopen(<cfoutput>'#request.self#?fuseaction=call.popup_add_helpdesk&company_id=' + company_id + '&member_type=' + type + '&partner_id=' + partner_id,'medium'</cfoutput>);
}

function type__(company_id,type)
{
	window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_consumer_details&cid=' + company_id + '&member_type=' + type;
	windowopen(<cfoutput>'#request.self#?fuseaction=call.popup_add_helpdesk&member_type=' + type + '&cid=' + company_id,'medium'</cfoutput>);
}
</script>
