<cfinclude template="../query/get_sector_cats.cfm">
<cfinclude template="../query/get_country.cfm">
<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr>
	<td>
	<table width="100%" height="100%" border="0" align="center" cellpadding="2" cellspacing="1">
	  <tr class="color-list">
		<td height="35" class="headbold"><cf_get_lang dictionary_id='30494.Çekilişe Katılan Üye'></td>
	  </tr>
	  <tr class="color-row">
		<td valign="top">
		<cfform name="form_add_draw" method="post" action="#request.self#?fuseaction=member.emptypopup_add_draw">
		<input type="hidden" name="consumer_cat_id" id="consumer_cat_id" value="1">
		<table>
		  <tr>
			<td width="80"><cf_get_lang dictionary_id='57631.Ad'> *</td>
			<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57631.Ad'></cfsavecontent>
			  <cfinput type="text" required="yes" message="#message#" name="consumer_name" style="width:150px;" maxlength="30"></td>
		  </tr>
		  <tr>
		  	<td><cf_get_lang dictionary_id='58726.Soyad'> *</td>
			<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58726.Soyad'></cfsavecontent>
			  <cfinput type="text" required="yes" message="#message#" name="consumer_surname" style="width:150px;" maxlength="30"></td>
		  </tr>
		  <tr>
			<td><cf_get_lang dictionary_id='30174.Kod/Tel'> *</td>
			<td><cfsavecontent variable="message1"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30316.Telefon kodu Giriniz !'></cfsavecontent>
		 	  <cfinput validate="integer" message="#message1#" maxlength="5" required="yes" name="consumer_hometelcode" onKeyUp="isNumber(this);" style="width:55px;">
			  <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57499.Telefon'></cfsavecontent>
			  <cfinput validate="integer" message="#message#" maxlength="9" required="yes" type="text" name="consumer_hometel" onKeyUp="isNumber(this);" style="width:92px;"></td>
		  </tr>
		  <tr>		  
		  <tr>
			<td rowspan="2" valign="top"><cf_get_lang dictionary_id='58723.Adres'></td>
			<td rowspan="2"><textarea name="homeaddress" id="homeaddress" style="width:150px;height:50px;"></textarea></td>
		  </tr>
		  <tr>
			<td></td>
		  </tr>
		  <tr>
			<td><cf_get_lang dictionary_id='57472.Posta Kodu'></td>
			<td><input type="text" name="postcode" id="postcode" value="" maxlength="15" onKeyUp="isNumber(this);" style="width:150px;"></td>
		  </tr>
		  <tr>
			<td><cf_get_lang dictionary_id='58132.Semt'></td>
			<td><cfinput type="text" name="semt" value="" maxlength="45" style="width:150px;"></td>
		  </tr>
		  <tr>
			<td><cf_get_lang dictionary_id='58638.ilçe'></td>
			<td><input type="hidden" name="county_id" id="county_id" readonly="">
			  <input type="text" name="county" id="county" value="" readonly style="width:150px;">
			  <a href="javascript://" onClick="pencere_ac('work');"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>				
			</td>
		  </tr>
		  <tr>
		  	<td><cf_get_lang dictionary_id='57971.Şehir'></td>
			<td>
			  <input type="hidden" name="city_id" id="city_id" value="">
			  <input type="text" name="city" id="city" value="" readonly style="width:150px;">
			  <a href="javascript://" onClick="pencere_ac_city('work');"><img src="/images/plus_list.gif" border="0" align="absmiddle">	</a>			
			</td>
		  </tr>
		  <tr>
			<td><cf_get_lang dictionary_id='58219.Ülke'></td>
			<td>
                <select name="country" id="country" onChange="remove_adress('1','work');" style="width:150px;">
                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfoutput query="get_country">
                    	<option value="#get_country.country_id#" <cfif get_country.country_id eq 1>selected</cfif>>#get_country.country_name#</option>
                    </cfoutput>
                </select>					
			</td>		  
		  </tr>
<!--- 		  <tr>
			<td>İlçe/İl</td>
			<td><input type="text" name="county" style="width:82px">
			  <input type="text" name="city" value="İstanbul" style="width:90px"></td>
		  </tr> --->
			<td><cf_get_lang dictionary_id='30495.Meslek'></td>
			<td>
			  <select name="sector_cat_id" id="sector_cat_id" style="width:90px;">
                  <option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
                  <cfoutput query="get_sector_cats">
                    <option value="#sector_cat_id#">#sector_cat#</option>
                  </cfoutput>
			  </select>&nbsp;<cf_get_lang dictionary_id='30496.Yaş'>
			  <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30496.Yaş'>!</cfsavecontent>
			  <cfinput type="text" name="age" message="#message#" style="width:30px;" maxlength="2" range="18,100" onKeyUp="isNumber(this);" required="yes">
			</td>
		  </tr>
		  <tr>
		  	<td></td>
			<td><cf_workcube_buttons is_upd='0'></td>
		  </tr>
		</table>
		</td>
	  </tr>
	</table>
    </td>
  </tr>
</table>
</cfform>
<script type="text/javascript">
function pencere_ac(no)
{
	x = document.form_add_draw.country.selectedIndex;
	if (document.form_add_draw.country[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='57485.öncelik'>-<cf_get_lang dictionary_id='58219.Ülke'>");
	}	
	else if(document.form_add_draw.city_id.value == "")
	{
		alert("<cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='58608.il'> !");
	}
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=form_add_draw.county_id&field_name=form_add_draw.county&city_id=' + document.form_add_draw.city_id.value,'small','popup_dsp_county');
		return remove_adress();
	}
}
function remove_adress(parametre)
{
	if(parametre==1)
	{
		document.form_add_draw.city_id.value = '';
		document.form_add_draw.city.value = '';
		document.form_add_draw.county_id.value = '';
		document.form_add_draw.county.value = '';
		document.form_add_draw.consumer_hometelcode.value = '';
	}
	else
	{
		document.form_add_draw.county_id.value = '';
		document.form_add_draw.county.value = '';
	}	
}

function pencere_ac_city()
{
	x = document.form_add_draw.country.selectedIndex;
	if (document.form_add_draw.country[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='57485.öncelik'>-<cf_get_lang dictionary_id='58219.Ülke'>");
	}	
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=form_add_draw.city_id&field_name=form_add_draw.city&field_phone_code=form_add_draw.consumer_hometelcode&country_id=' + document.form_add_draw.country.value,'small','popup_dsp_city');
	}
	return remove_adress('2');
}
</script>
