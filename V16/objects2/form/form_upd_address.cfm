<cfparam name="attributes.cpid" default="#session.pp.company_id#">
<!--- <cfinclude template="../query/get_partner.cfm"> --->
<cfinclude template="../query/get_country.cfm">
<cfquery name="GET_COMPANY" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		COMPANY_BRANCH
	WHERE 
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#"> AND
		COMPBRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brid#">
</cfquery>
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
  <tr class="color-border">
	<td> 
	<table width="100%" height="100%" cellpadding="2" cellspacing="1" border="0">
	  <tr class="color-list">
	<cfform name="upd_company_branch" method="post" action="#request.self#?fuseaction=objects2.emptypopup_upd_branch_address">
	<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.cpid#</cfoutput>">
	<input type="hidden" name="company_branch_id" id="company_branch_id" value="<cfoutput>#attributes.brid#</cfoutput>">
		<td height="35" class="headbold"><cf_get_lang no='1000.Adres Güncelle'></td>
	  </tr>
	  <tr>
		<td class="color-row" valign="top"> 
		<table>
		  <tr> 
			<td><cf_get_lang no='1001.Adres Tanımı'> *</td>
			<td width="185"><cfsavecontent variable="message"><cf_get_lang_main no ='1167.Şube Seçmediniz'></cfsavecontent>
			  <cfinput type="text" name="compbranch_name" value="#GET_COMPANY.COMPBRANCH__NAME#" maxlength="50" required="yes" message="#message#" style="width:150px;"></td>
		  </tr>
		  <tr>
			<td><cf_get_lang_main no='807.Ülke'></td>
			<td>
			  <select name="country" id="country" onChange="remove_adress('1');" style="width:150px;">
			  <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
			  <cfoutput query="get_country">
				<option value="#get_country.country_id#" <cfif get_country.country_id eq GET_COMPANY.COUNTRY_ID>selected</cfif>>#get_country.country_name#</option>
			  </cfoutput>
			  </select>			
			</td>
		  </tr>
		  <tr>
			<cfquery name="get_city" datasource="#dsn#">
				SELECT CITY_ID,CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
			</cfquery>
			<td><cf_get_lang_main no='559.İl'></td>
			<td>
			<select name="city" id="city" style="width:150px;" onChange="remove_adress();">
				<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
				<cfoutput query="get_city">
				<option value="#CITY_ID#" <cfif CITY_ID eq GET_COMPANY.CITY_ID>selected</cfif>>#CITY_NAME#</option>
				</cfoutput>
			</select>
			</td>
		  </tr>
		  <tr> 
			<td><cf_get_lang_main no='1226.İlçe'></td>
			<td>
			<cfif len(GET_COMPANY.COUNTY_ID)>
			<cfquery name="get_county" datasource="#dsn#">
				SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.county_id#">
			</cfquery>
			  <input type="hidden" name="county_id" id="county_id" value="<cfoutput>#GET_COMPANY.COUNTY_ID#</cfoutput>" readonly>
			  <input type="text" name="county" id="county" value="<cfoutput>#get_county.COUNTY_NAME#</cfoutput>" maxlength="30" style="width:150px;" readonly tabindex="12">
			  <a href="javascript://" onClick="pencere_ac();"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
			<cfelse>
			  <input type="hidden" name="county_id" id="county_id" value="">
			  <input type="text" name="county" id="county" value="" maxlength="30" style="width:150px;" tabindex="12">
			  <a href="javascript://" onClick="pencere_ac();"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
			</cfif>
			</td>
		  </tr>
		  <tr>
			<td><cf_get_lang_main no='720.Semt'></td>
			<td><input type="text" name="semt" id="semt" value="<cfoutput>#GET_COMPANY.SEMT#</cfoutput>" maxlength="50" style="width:150px;"></td>
		  </tr>
		  <tr>
			<td><cf_get_lang_main no='60.Posta Kodu'></td>
			<td><input type="text" name="postcode" id="postcode" value="<cfoutput>#GET_COMPANY.COMPBRANCH_POSTCODE#</cfoutput>" style="width:150px;" maxlength="5"></td>
		  </tr>
		  <tr> 
			<td valign="top"><cf_get_lang_main no='1311.Adres'></td>
			<td><textarea name="compbranch_address" id="compbranch_address" style="width:200px;height:50px;"><cfoutput>#GET_COMPANY.COMPBRANCH_ADDRESS#</cfoutput></textarea></td>
		  </tr>
		  <tr> 
			<td><cf_get_lang_main no='1173.Kod'>/ <cf_get_lang_main no='87.Telefon'> *</td>
			<td><cfsavecontent variable="message"><cf_get_lang no='21.Geçerli Bir Telefon Kodu Giriniz'> !</cfsavecontent>
			  <cfinput type="text" name="compbranch_telcode" value="#GET_COMPANY.COMPBRANCH_TELCODE#" required="yes" maxlength="5" message="#message#" style="width:52px;"> 
			  <cfinput type="text" name="compbranch_tel1" value="#GET_COMPANY.COMPBRANCH_TEL1#" maxlength="10" required="yes" message="#message#" style="width:95px;"> 
			</td>
		  </tr>
		  <tr>
		  	<td></td>
			<td><cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='0'></td>
		  </tr>
        </table>
    	</td>
	  </tr>
	</table>
	</td>
  </tr>
</cfform>
</table>
<script type="text/javascript">
function remove_adress(parametre)
{
	if(parametre==1)
	{
		document.upd_company_branch.city.value = '';
		document.upd_company_branch.county_id.value = '';
		document.upd_company_branch.county.value = '';
		document.upd_company_branch.compbranch_telcode.value = '';
	}
	else
	{
		document.upd_company_branch.county_id.value = '';
		document.upd_company_branch.county.value = '';
	}	
}

function pencere_ac(no)
{
	x = document.upd_company_branch.country.selectedIndex;
	if (document.upd_company_branch.country[x].value == "")
	{
		alert("<cf_get_lang no ='31.İlk Olarak Ülke Seçiniz'>.");
	}	
	else if(document.upd_company_branch.city.value == "")
	{
		alert("<cf_get_lang no ='32.İl Seçiniz'> !");
	}
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_dsp_county&field_id=upd_company_branch.county_id&field_name=upd_company_branch.county&city_id=' + document.upd_company_branch.city.value,'small');
		return remove_adress();
	}
}

function kontrol()
{
	x = (100 - document.upd_company_branch.compbranch_address.value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang_main no='1311.Adres'><cf_get_lang_main no='798.Alanindaki Fazla Karakter Sayisi'>"+ ((-1) * x));
		return false;
	}
	
	y = (50 - document.upd_company_branch.compbranch_name.value.length);
	if ( y < 0 )
	{ 
		alert ("<cf_get_lang_main no ='217.Açıklama'> "+ ((-1) * y) +"<cf_get_lang_main no='1741.Karakter Uzun'>!");
		return false;
	}
	return true;
}
</script>
