<cfinclude template="../query/get_identycard_cat.cfm">
<cfquery name="KNOW_LEVELS" datasource="#dsn#">
	SELECT 
    	KNOWLEVEL_ID, 
        KNOWLEVEL, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP 
    FROM 
    	SETUP_KNOWLEVEL
</cfquery>
<cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
	SELECT 
        PARTNER_ID, 
        EDUCATION, 
        HOMETELCODE, 
        HOMETEL, 
        IDENTYCAT_ID, 
        IDENTYCARD_NO, 
        HOMEADDRESS, 
        HOMEPOSTCODE, 
        BIRTHPLACE, 
        BIRTHDATE, 
        MARRIED, 
        HOMECOUNTY, 
        HOMECITY, 
        CHILD, 
        EDU1, 
        EDU1_FINISH, 
        EDU2, 
        EDU2_FINISH, 
        EDU3, 
        EDU3_FINISH, 
        EDU4, 
        EDU4_FINISH, 
        EDU4_FACULTY, 
        EDU4_PART, 
        EDU4_CITY, 
        EDU5, 
        EDU5_FINISH, 
        EDU5_PART, 
        LANG1, 
        LANG1_LEVEL, 
        LANG2, 
        LANG2_LEVEL, 
        FACULTY, 
        TRAINING_LEVEL
	FROM 
		COMPANY_PARTNER_DETAIL
	WHERE 
		PARTNER_ID=#ATTRIBUTES.PID# 
</cfquery>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
<cfform name="form_upd_partner" method="post" action="#request.self#?fuseaction=crm.emptypopup_upd_partner_detail">
<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#ATTRIBUTES.PID#</cfoutput>">
<tr class="color-border">
  <td>
	<table width="100%" cellpadding="2" cellspacing="1" border="0" height="100%">
	 <tr class="color-list" height="35">
		<td class="headbold">&nbsp;<cf_get_lang no='334.Üye Kişisel Bilgileri'></td>
	</tr>		         
	  <tr class="color-row">
		<td valign="top">
			<table>
					<tr height="25">
                      <td colspan="2" class="formbold"><cf_get_lang no='264.Kişisel Bilgiler'></td>
                      <td colspan="2" class="formbold"><cf_get_lang no='335.Ev Adres Bilgileri'></td>
                    </tr>
                    <tr>
                      <td width="100"><cf_get_lang no='336.Eğitim Durumu'></td>
                      <td width="185"><cfinput type="text" name="education" style="width:150px;" value="#get_partner_detail.education#"  maxlength="100">
                      </td>
                      <td width="100"><cf_get_lang no='337.Kod- Telefon'></td>
                      <td>
						<cfinput maxlength="5" name="HOMETELCODE" style="width:65px;" value="#get_partner_detail.HOMETELCODE#">
                        <cfinput maxlength="9" type="text" name="HOMETEL" value="#get_partner_detail.HOMETEL#" style="width:81px;">
                      </td>
                    </tr>
                    <tr>
                      <td><cf_get_lang no='338.Kimlik Kart/No'></td>
                      <td>
                        <select name="IDENTYCAT_ID" id="IDENTYCAT_ID"  style="width:90px;">
                          <option value="0"><cf_get_lang_main no='322.Seçiniz'> 
                          <cfoutput query="get_identycard_cat">
                            <cfif get_partner_detail.IDENTYCAT_ID is IDENTYCAT_ID>
                              <option value="#IDENTYCAT_ID#" selected>#identycat#
                              <cfelse>
                              <option value="#IDENTYCAT_ID#">#identycat#
                            </cfif>
                          </cfoutput>
                        </select> 
                        <cfinput type="text" name="IDENTYCARD_NO" style="width:56px;" value="#get_partner_detail.HOMETEL#" maxlength="50">
                      </td>
                      <td><cf_get_lang_main no='1311.Adres'></td>
                      <td rowspan="2">
                        <textarea name="HOMEADDRESS" id="HOMEADDRESS" style="width:150px;height:50px;"><cfoutput>#get_partner_detail.HOMEADDRESS#</cfoutput></textarea>
                      </td>
                    </tr>
                    <tr>
                      <td><cf_get_lang_main no='378.Doğum Yeri'></td>
                      <td><input type="text" name="birthplace" id="birthplace" style="width:150px;" value="<cfoutput>#get_partner_detail.birthplace#</cfoutput>">
                      </td>
                      <td>&nbsp;</td>
                    </tr>
                    <tr>
                      <td><cf_get_lang_main no='1315.Doğum Tarihi'></td>
                      <td>
					  <cfsavecontent variable="message"><cf_get_lang no='339.Doğum Tarihi Girmelisiniz '>!</cfsavecontent>
					  <cfinput validate="#validate_style#" message="#message#" type="text" name="birthdate" value="#dateformat(get_partner_detail.birthdate,dateformat_style)#" style="width:150px;">
						<cf_wrk_date_image date_field="birthdate">
					  </td>
                      <td><cf_get_lang_main no='60.Posta Kodu'></td>
                      <td>
                        <input type="text" name="HOMEPOSTCODE" id="HOMEPOSTCODE" style="width:150px;" maxlength="10"  value="<cfoutput>#get_partner_detail.HOMEPOSTCODE#</cfoutput>" >
                      </td>
                    </tr>
                    <tr>
                      <td><cf_get_lang no='340.Evlilik Durumu'></td>
                      <td>
                        <input type="checkbox" name="married" id="married" value="checkbox" <cfif get_partner_detail.MARRIED is 1>checked</cfif>>
                      </td>
                      <td><cf_get_lang_main no='1226.ilçe'></td>
                      <td>
                        <input type="text" name="homecounty" id="homecounty" style="width:150px;" maxlength="30"  value="<cfoutput>#get_partner_detail.homecounty#</cfoutput>" >
                      </td>
                    </tr>
                    <tr>
                      <td><cf_get_lang no='76.Çocuk Sayısı'></td>
                      <td>  
					   <cfsavecontent variable="message"><cf_get_lang no='341.Çocuk Sayısı Girmelisiniz !'></cfsavecontent>
						<cfinput validate="integer" message="#message#" maxlength="2" type="text" name="child" value="#get_partner_detail.child#" style="width:150px;">
                      </td>
                      <td><cf_get_lang_main no='1196.Şehir'></td>
                      <td>
                        <input type="text" name="homecity" id="homecity" style="width:150px;" maxlength="30"  value="<cfoutput>#get_partner_detail.homecity#</cfoutput>">
                      </td>
                    </tr>
                    <tr>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                    </tr>
					<tr>
					<td colspan="2" class="formbold"><cf_get_lang no='342.Okul Adı / Mezuniyet Yılı'></td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					</tr>
					<tr>
					<td><cf_get_lang no='343.İlkokul'></td>
					<td><cfinput name="edu1" type="text" value="#get_partner_detail.edu1#" maxlength="75" style="width:120px;">
					<cfsavecontent variable="message"><cf_get_lang no='344.Okul Mezuniyet Yılı Hatalı'> !</cfsavecontent>
					<cfinput type="text" name="edu1_finish" style="width:40px;" maxlength="4" value="#get_partner_detail.edu1_finish#" validate="integer" message="#message#" range="1900,2500">
					</td>
					<td><cf_get_lang_main no='1584.Dil'> 1</td>
					<td><cfinput type="text" name="lang1" style="width:75px;" maxlength="15" value="#get_partner_detail.lang1#">
                        <select name="lang1_level" id="lang1_level">
                          <cfoutput query="know_levels">
                          <option value="#knowlevel_id#" <cfif get_partner_detail.lang1_level EQ knowlevel_id>selected</cfif>>#knowlevel# </cfoutput>
                        </select>
						</td>
					</tr>
					<tr>
					<td><cf_get_lang no='345.Ortaokul'></td>
					<td><cfinput name="edu2" type="text" value="#get_partner_detail.edu2#" maxlength="75" style="width:120px;">
					<cfsavecontent variable="message"><cf_get_lang no='344.Okul Mezuniyet Yılı Hatalı'> !</cfsavecontent>
					<cfinput type="text" name="edu2_finish" style="width:40px;" maxlength="4" value="#get_partner_detail.edu2_finish#" validate="integer" message="#message#" range="1900,2500"></td>
					<td><cf_get_lang_main no='1584.Dil'> 2</td>
					<td><cfinput type="text" name="lang2" style="width:75px;" maxlength="15"  value="#get_partner_detail.lang2#">
                        <select name="lang2_level" id="lang2_level">
                          <cfoutput query="know_levels">
                          <option value="#knowlevel_id#" <cfif get_partner_detail.lang2_level EQ knowlevel_id>selected</cfif>>#knowlevel# </cfoutput>
                        </select></td>
					</tr>
					<tr>
					<td><cf_get_lang no='346.Lise'></td>
					<td><cfinput name="edu3" type="text" value="#get_partner_detail.edu3#" maxlength="75" style="width:120px;">
					<cfsavecontent variable="message"><cf_get_lang no='344.Okul Mezuniyet Yılı Hatalı'> !</cfsavecontent>
					<cfinput type="text" name="edu3_finish" style="width:40px;" maxlength="4" value="#get_partner_detail.edu3_finish#" validate="integer" message="#message#" range="1900,2500">
					</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					</tr>
					<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					</tr>
					<tr>
					<td><cf_get_lang_main no='1958.Üniversite'></td>
					<td>
						<cfinput type="text" name="edu4" style="width:120px;" maxlength="75" value="#get_partner_detail.edu4#">
                        <cfsavecontent variable="message"><cf_get_lang no='344.Okul Mezuniyet Yılı Hatalı'> !</cfsavecontent>
                        <cfinput type="text" name="edu4_finish" style="width:40px;" maxlength="4" value="#get_partner_detail.edu4_finish#" validate="integer" message="#message#" range="1900,2500">
					</td>
					<td><cf_get_lang_main no='1196.Şehir'></td>
					<td><input type="text" name="edu4_city" id="edu4_city" style="width:150px;" maxlength="50" value="<cfoutput>#get_partner_detail.edu4_city#</cfoutput>"></td>
					</tr>
					<tr>
					<td><cf_get_lang no='348.Fakülte'></td>
					<td><cfinput type="text" name="edu4_faculty" style="width:163px;" maxlength="75" value="#get_partner_detail.edu4_faculty#"></td>
					<td><cf_get_lang_main no='583.Bölüm'></td>
					<td><cfinput   type="text" name="edu4_part" style="width:150px;" maxlength="40" value="#get_partner_detail.edu4_part#"></td>
					</tr>
					<tr>
					<td><cf_get_lang_main no='1958.Üniversite'></td>
					<td>
						<cfinput type="text" name="edu5" style="width:120px;" maxlength="75" value="#get_partner_detail.edu5#">
                        <cfsavecontent variable="message"><cf_get_lang no='344.Okul Mezuniyet Yılı Hatalı'> !</cfsavecontent>
                        <cfinput type="text" name="edu5_finish" style="width:40px;" maxlength="4" value="#get_partner_detail.edu5_finish#" validate="integer" message="#message#"range="1900,2500">
					</td>
					<td><cf_get_lang_main no='583.Bölüm'></td>
					<td><cfinput type="text" name="edu5_part" style="width:150px;" maxlength="40" value="#get_partner_detail.edu5_part#"></td>
					</tr>
					<tr>
					<td height="35" colspan="4"  style="text-align:right;"><cf_workcube_buttons is_upd='0'>
					</tr>
				</table>
	  </td>
	</tr>
</table>
	  </td>
	</tr>
	</cfform>
</table>

