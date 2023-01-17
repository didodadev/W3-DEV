<cfset XFA.submit_zone = "upd_company">
<cfinclude template="../query/upd_company.cfm">
<cfquery name="CHECK" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		OUR_COMPANY
</cfquery>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no='401.Şirket Genel Bilgileri'></td>
  </tr>
</table>
      <table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
        <tr>
          <td class="color-row">
            <cfform name="add_asset" action=""  method="post" enctype="multipart/form-data">
              <cfoutput>
                <input type="Hidden" name="comp_id" id="comp_id" value="#check.comp_id#">
                <table>
                  <tr height="22">
                    <td height="27" colspan="2" class="txtboldblue"><cf_get_lang_main no='568.Genel Bilgiler'></td>
                    <td colspan="2" class="txtboldblue"><cf_get_lang no='415.İletişim Bilgileri'></td>
                  </tr>
                  <tr>
                    <td width="85"><cf_get_lang no='402.Tam Adı'>*</td>
                    <td width="170">
                      <cfsavecontent variable="message"><cf_get_lang no='728.Tam Adı girmelisiniz'></cfsavecontent>
					  <cfinput type="text" name="company_name" value="#check.company_name#" required="Yes" message="#message#" style="width:150px;" maxlength="200">
                    </td>
                    <td width="85"><cf_get_lang no='416.Telefon Kodu'></td>
                    <td>
					<cfsavecontent variable="message"><cf_get_lang no='708.Telefon Kodu girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="tel_code" value="#check.tel_code#" maxlength="5" style="width:150px;" validate="integer" message="#message#">
                    </td>
                  </tr>
                  <tr>
                    <td><cf_get_lang no='403.Kısa Ünvanı'>*</td>
                    <td>
                      <cfsavecontent variable="message"><cf_get_lang no='729.Kısa Ünvanı girmelisiniz'></cfsavecontent>
					  <cfinput type="text" name="nick_name" value="#check.nick_name#" style="width:150px;" required="yes" message="#message#" maxlength="50">
                    </td>
                    <td><cf_get_lang_main no='87.Telefon'></td>
                    <td>
					<cfsavecontent variable="message"><cf_get_lang no='707.Telefon girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="tel" value="#check.tel#" style="width:150px;" validate="integer" message="#message#">
                    </td>
                  </tr>
                  <tr>
                    <td> <cf_get_lang_main no='1714.Yönetici'></td>
                    <td><cfinput type="text" name="manager" value="#check.manager#" style="width:150px;" maxlength="40">
                    </td>
                    <td><cf_get_lang_main no='87.Telefon'>2</td>
                    <td>
					<cfsavecontent variable="message"><cf_get_lang no='707.Telefon girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="tel2" value="#check.TEL2#" style="width:150px;" validate="integer" message="#message#">
                    </td>
                  </tr>
                  <tr>
                    <td><cf_get_lang_main no='1350.Vergi Dairesi'></td>
                    <td>
                      <cfinput type="text" name="tax_office" value="#check.tax_office#" style="width:150px;" maxlength="50">
                    </td>
                    <td><cf_get_lang_main no='87.Telefon'> 3</td>
                    <td>
					<cfsavecontent variable="message"><cf_get_lang no='707.Telefon girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="tel3" value="#check.TEL3#" style="width:150px;" validate="integer" message="#message#">
                    </td>
                  </tr>
                  <tr>
                    <td><cf_get_lang_main no='340.Vergi No'></td>
                    <td>
                      <cfsavecontent variable="message"><cf_get_lang no='712.Vergi No girmelisiniz'></cfsavecontent>
					  <cfinput type="text" name="tax_no" value="#check.tax_no#" style="width:150px;" validate="integer" message="#message#" maxlength="50">
                    </td>
                    <td><cf_get_lang_main no='87.Telefon'> 4</td>
                    <td>
					<cfsavecontent variable="message"><cf_get_lang no='707.Telefon girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="tel4" value="#check.TEL4#" style="width:150px;" validate="integer" message="#message#">
                    </td>
                  </tr>
                  <tr>
                    <!------->
                    <td height="41"><cf_get_lang no='36.Oda'></td>
                    <td><cfinput type="text" name="chamber" value="#check.chamber#" style="width:150px;">
                    </td>
                    <td><cf_get_lang_main no='76.Faks'></td>
                    <td>
					<cfsavecontent variable="message"><cf_get_lang no='706.Faks girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="fax" value="#check.fax#" style="width:150px;" validate="integer" message="#message#">
                    </td>
                  </tr>
                  <tr>
                    <td height="26"><cf_get_lang no='406.Oda Sicil No'></td>
                    <td><cfinput type="text" name="chamber_no" value="#check.chamber_no#" style="width:150px;">
                    </td>
                    <td><cf_get_lang_main no='76.Faks'> 2</td>
                    <td>
					<cfsavecontent variable="message"><cf_get_lang no='706.Faks girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="FAX2" value="#check.FAX2#" style="width:150px;" validate="integer" message="#message#">
                    </td>
                  </tr>
                  <tr>
                    <td><cf_get_lang no='36.Oda'> 2</td>
                    <td><cfinput type="text" name="chamber2" value="#check.chamber2#" style="width:150px;">
                    </td>
                    <td><cf_get_lang_main no='16.E-mail'></td>
                    <td><cfinput type="text" name="email" value="#check.email#"  style="width:150px;">
                    </td>
                  </tr>
                  <tr>
                    <td><cf_get_lang no='406.Oda Sicil No'> 2</td>
                    <td><cfinput type="text" name="chamber2_no" value="#check.chamber2_no#" style="width:150px;">
                    </td>
                    <td><cf_get_lang no='113.İnternet'></td>
                    <td><input type="text" name="web" id="web" value="#check.web#" style="width:150px;">
                    </td>
                  </tr>
                  <!------->
                  <tr>
                    <td><cf_get_lang_main no='998.Sermaye'></td>
                    <td>
					<cfsavecontent variable="message"><cf_get_lang no='709.Sermaye girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="sermaye" value="#check.SERMAYE#" style="width:150px;" validate="integer" message="#message#">
                    </td>
                  </tr>
                  <tr>
                    <td><cf_get_lang no='408.Ticaret Sicil No'></td>
                    <td><input type="text" name="T_NO" id="T_NO" value="#check.T_NO#" style="width:150px;">
                    </td>
                  </tr>
                  <!------>
                  <tr>
                    <td valign="top"><cf_get_lang no='409.Yönetici E-Mail'></td>
                     
                    <td><TEXTAREA name="admin_mail" id="admin_mail" rows="1" style="width:150px;height:60px;">#check.admin_mail#</TEXTAREA>
                    </td>
                    <td valign="top"><cf_get_lang_main no='1311.Adres'></td>
                    <td><TEXTAREA name="address" id="address" style="width:150px;height:60px;">#check.address#</TEXTAREA>
                    </td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                    <td>(<cf_get_lang no='410.Mail Adreslerini Tırnak İle Ayırarak Yazınız'>)</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td height="35" colspan="4" align="right" style="text-align:right;">
					<cf_workcube_buttons is_upd='0'>
                    </td>
                  </tr>
                </table>
                <table>
                  <tr>
                    <td colspan="2" height="22" class="txtboldblue"><cf_get_lang no='411.Logolar'></td>
                  </tr>
                  <tr>
                    <td width="125" class="txtbold"><cf_get_lang no='412.Büyük Logo'></td>
                    <td><input type="FILE" style="width:200px;" name="asset1" id="asset1">
                    </td>
                  </tr>
                  <tr>
                    <td colspan="2"><a href="javascript://" onClick="windowopen('#file_web_path#settings/#check.asset_file_name1#','medium')" class="tableyazi">
					<!--- <img src="#file_web_path#settings/#check.asset_file_name1#" border="0"> --->
					<cf_get_server_file output_file="settings/#check.asset_file_name1#" output_server="#check.asset_file_name1_server_id#" output_type="0" image_link="1" image_height="34" image_width="33">
					</a><br/>
                      <br/>
                    </td>
                  </tr>
                  <tr>
                    <td class="txtbold"><cf_get_lang no='413.Orta Logo'></td>
                     
                    <td><input type="FILE" style="width:200px;" name="asset2" id="asset2">
                    </td>
                  </tr>
                  <tr>
                    <td colspan="2"><a href="javascript://" onClick="windowopen('#file_web_path#settings/#check.asset_file_name2#','medium')" class="tableyazi">
					<!--- <img src="#file_web_path#settings/#check.asset_file_name2#" border="0"> --->
					<cf_get_server_file output_file="settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="0" image_link="1" image_height="34" image_width="33">
					</a><br/>
                      <br/>
                    </td>
                  </tr>
                  <tr>
                    <td class="txtbold"><cf_get_lang no='414.Küçük Logo'></td>
                      
                    <td><input type="FILE" style="width:200px;" name="asset3" id="asset3">
                    </td>
                  </tr>
                  <tr>
                    <td colspan="2"><a href="javascript://" onClick="windowopen('#file_web_path#settings/#check.asset_file_name3#','medium')" class="tableyazi">
					<!--- <img src="#file_web_path#settings/#check.asset_file_name3#" border="0"> --->
					<cf_get_server_file output_file="settings/#check.asset_file_name3#" output_server="#check.asset_file_name3_server_id#" output_type="0" image_link="1" image_height="34" image_width="33">
					</a></td>
                  </tr>
                  <tr>
                    <td height="35" colspan="2" align="right" style="text-align:right;">
					<cf_workcube_buttons is_upd='0'>
                    </td>
                  </tr>
                </table>
              </cfoutput>
            </cfform>
          </td>
        </tr>
      </table>
<br/>

