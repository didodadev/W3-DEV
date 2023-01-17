<!---<cfquery name="GET_BRANCH_PARTNER" datasource="#DSN#">
	SELECT * FROM COMPANY_PARTNER WHERE COMPBRANCH_ID = #url.brid# ORDER BY COMPANY_PARTNER_NAME
</cfquery>--->
<cfscript>
	einvoice_control= createObject("component","V16.e_government.cfc.einvoice");
	einvoice_control.dsn = dsn;
	get_einvoice = einvoice_control.get_einvoice_fnc();
</cfscript>
<cfquery name="GET_COUNTRY" datasource="#DSN#">
	SELECT COUNTRY_ID, COUNTRY_NAME, IS_DEFAULT FROM SETUP_COUNTRY ORDER BY	COUNTRY_NAME
</cfquery>
<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT
		CB.*,
		C.FULLNAME,
		C.MANAGER_PARTNER_ID,
        C.TAXNO
	FROM
		COMPANY C,
		COMPANY_CAT CC,
		COMPANY_BRANCH CB
	WHERE 
		C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
		CB.COMPANY_ID = C.COMPANY_ID AND
		CB.COMPBRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.brid#">
</cfquery>

<cfquery name="GET_PARTNER_BRANCH" datasource="#DSN#">
	SELECT
		C.*,
		CP.PARTNER_ID,
		CP.COMPANY_PARTNER_NAME,
		CP.COMPANY_PARTNER_SURNAME
	FROM
		COMPANY_PARTNER AS CP,
		COMPANY AS C
	WHERE
		CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cpid#"> AND
		CP.COMPANY_ID = C.COMPANY_ID
	ORDER BY
		CP.COMPANY_PARTNER_NAME
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32898.Şube Güncelle'></cfsavecontent>
<cf_popup_box title="#message# : #get_company.fullname#">
<cfform name="upd_company_branch" method="post" action="#request.self#?fuseaction=objects.emptypopup_upd_branch">
    <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#url.cpid#</cfoutput>">
	<input type="hidden" name="compbranch_id" id="compbranch_id" value="<cfoutput>#url.brid#</cfoutput>">
    <table>
    	<tr>
        	<td valign="top">
                <table>
                    <tr>
                        <td width="100"><cf_get_lang dictionary_id='29532.Şube Adı'> *</td>
                        <td width="150">
                        	<cfsavecontent variable="message"><cf_get_lang dictionary_id='30356.Şube Adı Girmediniz !'></cfsavecontent>
                            <cfinput type="text" name="compbranch__name" value="#get_company.compbranch__name#" required="yes" message="#message#" maxlength="50" style="width:150px;">
                        </td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='59005.Şube Kodu'></td>
                        <td><input type="text" name="compbranch_code" id="compbranch_code" value="<cfoutput>#get_company.compbranch_code#</cfoutput>" maxlength="10" style="width:150px;"></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='30221.Şube Alias Tanımı'></td>
                        <td nowrap="nowrap">
                            <input type="text" name="compbranch_alias" id="compbranch_alias" value="<cfoutput>#get_company.compbranch_alias#</cfoutput>" style="width:152px;" readonly="readonly">
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_branch_alias&field_alias=upd_company_branch.compbranch_alias<cfif len(get_company.taxno)>&taxno=#get_company.taxno#</cfif></cfoutput>','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                        </td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='32851.Kod/ Telefon'> 1 *</td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='51606.Geçerli Bir Telefon Kodu Giriniz !'></cfsavecontent>
                            <cfinput type="text" name="compbranch_telcode" value="#get_company.compbranch_telcode#" required="yes" maxlength="5" message="#message#" style="width:55px;">
                            <cfsavecontent variable="message1"><cf_get_lang dictionary_id='30230.Telefon Girmelisiniz !'></cfsavecontent>
                            <cfinput type="text" name="compbranch_tel1" value="#get_company.compbranch_tel1#" required="yes" maxlength="10" message="#message1#" style="width:93px;">
                        </td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='57499.Telefon'> 2</td>
                        <td style="float:right; width:100px;"><input type="text" name="compbranch_tel2" id="compbranch_tel2" value="<cfoutput>#get_company.compbranch_tel2#</cfoutput>" maxlength="10" style="width:88px;"></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='57499.Telefon'> 3</td>
                        <td style="float:right; width:100px;">
                          <input type="text" name="compbranch_tel3" id="compbranch_tel3" value="<cfoutput>#get_company.compbranch_tel3#</cfoutput>" maxlength="10" style="width:88px;">
                        </td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='57428.E-mail'></td>
                        <td><input type="text" name="compbranch_email" id="compbranch_email" value="<cfoutput>#get_company.compbranch_email#</cfoutput>" maxlength="50" style="width:153px;"></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='32481.Internet'></td>
                        <td><input type="text" name="homepage" id="homepage" value="<cfoutput>#get_company.homepage#</cfoutput>" maxlength="50" style="width:153px;"></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='57629.Açıklama'></td>
                        <td valign="top"><textarea name="compbranch__nickname" id="compbranch__nickname" style="width:153px;height:70px;"><cfoutput>#get_company.compbranch__nickname#</cfoutput></textarea></td>
                    </tr>
                </table>
             </td>
    		 <td valign="top">
                <table>
                    <tr> 
                        <td><cf_get_lang dictionary_id='57493.Aktif'></td>
                        <td><input type="checkbox" name="compbranch_status" id="compbranch_status" <cfif get_company.compbranch_status eq 1>checked</cfif>></td>
                    </tr>
                    <tr> 
                        <td width="100"><cf_get_lang dictionary_id='29511.Yönetici'></td>
                        <td>
                        <select name="manager_partner_id" id="manager_partner_id" style="width:150px;">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'> </option>
                            <cfoutput query="get_partner_branch"> 
                                <option value="#partner_id#" <cfif get_partner_branch.partner_id is get_company.manager_partner_id>selected</cfif>>#company_partner_name# #company_partner_surname#</option>
                            </cfoutput> 
                        </select>
                        </td>
                    </tr>
                    <tr> 
                        <td><cf_get_lang dictionary_id='57908.Temsilci'></td>
                        <td>
                            <cfif len(get_company.pos_code)>
                            <input type="hidden" name="pos_code" id="pos_code" value="<cfoutput>#get_company.pos_code#</cfoutput>">
                            <input type="text" name="pos_code_text" id="pos_code_text" value="<cfoutput>#get_emp_info(get_company.pos_code,1,0)#</cfoutput>" readonly style="width:150px;">
                            <cfelse>
                            <input type="hidden" name="pos_code" id="pos_code" value="">
                            <input type="text" name="pos_code_text" id="pos_code_text" value="" readonly style="width:150px;">
                            </cfif>
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_company_branch.pos_code&field_name=upd_company_branch.pos_code_text&select_list=1','list');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                        </td>
                    </tr>
                    <tr> 
                        <td valign="top"><cf_get_lang dictionary_id='58723.Adres'></td>
                        <td>
                          <textarea name="compbranch_address" id="compbranch_address" style="width:150px;height:50px;"><cfoutput>#get_company.compbranch_address#</cfoutput></textarea>
                        </td>
                    </tr>
                    <tr> 
                        <td><cf_get_lang dictionary_id='57488.Fax'></td>
                        <td><input type="text" name="compbranch_fax" id="compbranch_fax" value="<cfoutput>#get_company.compbranch_fax#</cfoutput>" maxlength="10" style="width:150px;"></td>
                    </tr>
                    <tr> 
                        <td><cf_get_lang dictionary_id='57472.Posta Kodu'></td>
                        <td><input type="text" name="compbranch_postcode" id="compbranch_postcode" value="<cfoutput>#get_company.compbranch_postcode#</cfoutput>" maxlength="5" style="width:150px;"></td>
                    </tr>
                    <tr> 
                        <td><cf_get_lang dictionary_id='58132.Semt'></td>
                        <td><input type="text" name="semt" id="semt" value="<cfoutput>#get_company.semt#</cfoutput>" maxlength="50" style="width:150px;"></td>
                    </tr>
                    <tr> 
                        <td><cf_get_lang dictionary_id='58638.Ilce'><cfif get_einvoice.recordcount> *</cfif></td>
                        <td>
                            <cfif len(get_company.county_id)>
                                <cfquery name="GET_COUNTY" datasource="#DSN#">
                                    SELECT * FROM SETUP_COUNTY WHERE COUNTY_ID = #get_company.county_id#
                                </cfquery>		
                            	<input type="hidden" name="county_id" id="county_id" value="<cfoutput>#get_company.county_id#</cfoutput>">
                            	<input type="text" name="county" id="county" value="<cfoutput>#get_county.county_name#</cfoutput>" readonly style="width:150px;">				  
                            <cfelse>
                            	<input type="hidden" name="county_id" id="county_id" value="">
                            	<input type="text" name="county" id="county" value=""readonly style="width:150px;">
                            </cfif>
                        <a href="javascript://" onclick="pencere_ac();"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
                    </tr>	
                    <tr>
                        <td><cf_get_lang dictionary_id='57971.Şehir'><cfif get_einvoice.recordcount> *</cfif></td>
                        <td>
                            <cfif len(get_company.city_id)>
                                <cfquery name="GET_CITY" datasource="#DSN#">
                                	SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_company.city_id#
                                </cfquery>
                            	<input type="hidden" name="city_id" id="city_id" value="<cfoutput>#get_company.city_id#</cfoutput>">
                            	<input type="text" name="city" id="city" value="<cfoutput>#get_city.city_name#</cfoutput>" readonly style="width:150px;">
                            <cfelse>
                            	<input type="hidden" name="city_id" id="city_id" value="">
                            	<input type="text" name="city" id="city" value="" readonly style="width:150px;">
                            </cfif>
                            <a href="javascript://" onclick="pencere_ac_city();"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
                    </tr>
                    <tr>				
                        <td><cf_get_lang dictionary_id='58219.Ülke'></td>
                        <td>
                            <select name="country" id="country" onchange="remove_adress('1');" style="width:150px;">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_country">
                                    <option value="#get_country.country_id#" <cfif get_company.country_id eq get_country.country_id>selected</cfif>>#get_country.country_name#</option>
                                </cfoutput>
                            </select>
                        </td>
                    </tr>
                     <tr>
                        <td><cf_get_lang dictionary_id='57659.Satış Bölgesi'></td>
                        <td>
                            <cfquery name="GET_SALES_ZONES" datasource="#dsn#">
                                SELECT IS_ACTIVE,SZ_ID,SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
                            </cfquery>
                            <select name="sales_zone_id" id="sales_zone_id" style="width:150px;">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="GET_SALES_ZONES">
                                    <option value="#SZ_ID#" <cfif get_company.sz_id eq sz_id>selected</cfif>>#SZ_NAME# <cfif is_active eq 0>(Pasif)</cfif></option>
                                </cfoutput>
                            </select>   
                        </td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='58549.Koordinatlar'></td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='59875.Lütfen enlem değerini -90 ile 90 arasında giriniz'></cfsavecontent>
                            <cf_get_lang dictionary_id='58553.E'><cfinput type="text" maxlength="10" range="-90,90" message="#message#" value="#get_company.coordinate_1#" name="coordinate_1" style="width:63px;"> 
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='59894.Lütfen boylam değerini -180 ile 180 arasında giriniz'></cfsavecontent>
                            <cf_get_lang dictionary_id='58591.B'><cfinput type="text" maxlength="10" range="-180,180" message="#message#" value="#get_company.coordinate_2#" name="coordinate_2" style="width:63px;">
                        </td>
                    </tr>
                </table>
             </td>
         </tr>
    </table>
	<cf_popup_box_footer>
    	<cf_record_info query_name="get_company" record_emp="record_member" update_emp="update_member">
    	<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
    </cf_popup_box_footer>
</cfform>
</cf_popup_box>
<script type="text/javascript">
function remove_adress(parametre)
{
	if(parametre==1)
	{
		document.upd_company_branch.city_id.value = '';
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

function pencere_ac_city()
{
	
	x = document.upd_company_branch.country.selectedIndex;
	if (document.upd_company_branch.country[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='56176.İlk Olarak Ülke Seçiniz'>.");
	}	
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=upd_company_branch.city_id&field_name=upd_company_branch.city&field_phone_code=upd_company_branch.compbranch_telcode&country_id=' + document.upd_company_branch.country.value,'small');
	}
	return remove_adress('2');
}

function pencere_ac(no)
{
	x = document.upd_company_branch.country.selectedIndex;
	if (document.upd_company_branch.country[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='56176.İlk Olarak Ülke Seçiniz'>.");
	}	
	else if(document.upd_company_branch.city_id.value == "")
	{
		alert("<cf_get_lang dictionary_id='56490.İl Seçiniz'> !");
	}
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=upd_company_branch.county_id&field_name=upd_company_branch.county&city_id=' + document.upd_company_branch.city_id.value,'small');
		return remove_adress();
	}
}


function kontrol()
{
	<cfif get_einvoice.recordcount eq 1>
		if(document.getElementById('city_id').value.length < 1)
		{
			alert("<cf_get_lang dictionary_id='32876.Lütfen Şehir Seçiniz'>!");
			return false;
		}
		
		if(document.getElementById('county_id').value.length < 1)
		{
			alert("<cf_get_lang dictionary_id='52665.Lütfen İlçe Seçiniz'>!");
			return false;
		}
	</cfif>
		
	x = (100 - document.upd_company_branch.compbranch_address.value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id='58723.Adres'><cf_get_lang dictionary_id='58210.Alanindaki Fazla Karakter Sayisi'>"+ ((-1) * x));
		return false;
	}

	x = (100 - document.upd_company_branch.compbranch__nickname.value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id='57453.Sube'><cf_get_lang dictionary_id='57629.Aciklama'><cf_get_lang dictionary_id='58210.Alanindaki Fazla Karakter Sayisi'>"+ ((-1) * x));
		return false;
	}
	return true;
}
</script>
