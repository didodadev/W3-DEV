<cfparam name="attributes.cpid" default="#session.pp.company_id#">
<cfinclude template="../query/get_country.cfm">
<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT 
		C.COMPANY_ID
	FROM 
		COMPANY C, 
		COMPANY_CAT CC
	WHERE 
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#"> AND 
		C.COMPANYCAT_ID = CC.COMPANYCAT_ID
</cfquery>
<table cellpadding="0" cellspacing="0" border="0" style="width:100%; height:100%;">
  	<tr class="color-border">
		<td> 
			<cfform name="add_company_branch" method="post" action="#request.self#?fuseaction=objects2.emptypopup_add_branch_address">
			<table cellpadding="2" cellspacing="1" border="0" style="width:100%; height:100%;">
	  			<tr class="color-list" style="height:35px;">
					<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_company.company_id#</cfoutput>">
					<td class="headbold"><cf_get_lang no='1004.Adres Ekle'></td>
	 			</tr>
	  			<tr>
					<td class="color-row" style="vertical-align:top;"> 
						<table>
		  					<tr> 
								<td><cf_get_lang no='1001.Adres Tanımı'> *</td>
								<td style="width:185px;">
                                	<cfsavecontent variable="message"><cf_get_lang_main no ='1167.Şube Seçmediniz'> !</cfsavecontent>
			  						<cfinput type="text" name="compbranch__name" id="compbranch__name" maxlength="50" required="yes" message="#message#" style="width:150px;"></td>
		  					</tr>
		  					<tr>
                                <td><cf_get_lang_main no='807.Ülke'></td>
                                <td>
                                  	<select name="country" id="country" onChange="remove_adress('1');" style="width:150px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfoutput query="get_country">
                                            <option value="#get_country.country_id#" <cfif get_country.country_id eq 1>selected</cfif>>#get_country.country_name#</option>
                                        </cfoutput>
                                  	</select>			
                                </td>
                        	</tr>
                            <tr>
                                <cfquery name="GET_CITY" datasource="#DSN#">
                                    SELECT CITY_ID,CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
                                </cfquery>
                                <td><cf_get_lang_main no='559.İl'></td>
                                <td>
                                    <select name="city" id="city" style="width:150px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfoutput query="get_city">
                                        	<option value="#city_id#">#city_name#</option>
                                        </cfoutput>
                                    </select>
                                </td>
                          	</tr>
                          	<tr> 
                                <td><cf_get_lang_main no='1226.İlçe'></td>
                                <td>
                                	<input type="hidden" name="county_id" id="county_id" readonly="">
                                  	<input type="text" name="county" id="county" value="" maxlength="30" style="width:150px;" readonly>
			  						<a href="javascript://" onClick="pencere_ac();"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
								</td>
                          	</tr>
                          	<tr>
                                <td><cf_get_lang_main no='720.Semt'></td>
                                <td><input type="text" name="semt" id="semt" value="" maxlength="50" style="width:150px;"></td>
                          	</tr>
                            <tr>
                                <td><cf_get_lang_main no='60.Posta Kodu'></td>
                                <td><input type="text" name="postcode" id="postcode" value="" style="width:150px;" maxlength="5"></td>
                          	</tr>
                          	<tr> 
                                <td style="vertical-align:top;"><cf_get_lang_main no='1311.Adres'> *</td>
                                <td><textarea name="compbranch_address" id="compbranch_address" style="width:200px;height:50px;"></textarea></td>
                          	</tr>
                           	<tr> 
                                <td><cf_get_lang_main no='1173.Kod'>/ <cf_get_lang_main no='87.Telefon'> *</td>
                                <td><cfsavecontent variable="message"><cf_get_lang no='21.Geçerli Bir Telefon Kodu Giriniz'> !</cfsavecontent>
                                  <cfinput type="text" name="compbranch_telcode" id="compbranch_telcode" required="yes" maxlength="5" message="#message#" style="width:52px;"> 
                                  <cfinput type="text" name="compbranch_tel1" id="compbranch_tel1" maxlength="10" required="yes" message="#message#" style="width:95px;"> 
                                </td>
                          	</tr>
                          	<tr>
                                <td></td>
                                <td><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
                              </tr>
        				</table>	
    				</td>
	  			</tr>
			</table>
            </cfform>
		</td>
  	</tr>
</table>

<script type="text/javascript">
	function remove_adress(parametre)
	{
		if(parametre==1)
		{
			document.getElementById('city').value = '';
			document.getElementById('county_id').value = '';
			document.getElementById('county').value = '';
			document.getElementById('compbranch_telcode').value = '';
		}
		else
		{
			document.getElementById('county_id').value = '';
			document.getElementById('county').value = '';
		}	
	}
	
	function pencere_ac(no)
	{
		if(document.getElementById('compbranch_address').value == '')
		{
			alert('Lütfen adres alanını giriniz!');
			return false;	
		}
		x = document.add_company_branch.country.selectedIndex;
		if (document.add_company_branch.country[x].value == "")
		{
			alert("<cf_get_lang no ='31.İlk Olarak Ülke Seçiniz'>.");
		}	
		else if(document.getElementById('city').value == "")
		{
			alert("<cf_get_lang no ='32.İl Seçiniz'> !");
		}
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_dsp_county&field_id=add_company_branch.county_id&field_name=add_company_branch.county&city_id=' + document.getElementById('city').value,'small');
			return remove_adress();
		}
	}
	
	function kontrol()
	{
		x = (100 - document.getElementById('compbranch_address').value.length);
		if ( x < 0 )
		{ 
			alert ("<cf_get_lang_main no='1311.Adres'><cf_get_lang_main no='798.Alanindaki Fazla Karakter Sayisi'>"+ ((-1) * x));
			return false;
		}
		
		y = (50 - document.getElementById('compbranch__name').value.length);
		if ( y < 0 )
		{ 
			alert ("<cf_get_lang_main no ='217.Açıklama'> "+ ((-1) * y) +" <cf_get_lang_main no='1741.Karakter Uzun'> !");
			return false;
		}
		return true;
	}
</script>
