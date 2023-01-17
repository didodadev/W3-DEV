<cfform name="employe_detail1" method="post" action="#request.self#?fuseaction=hr.add_salesparam" enctype="multipart/form-data">
<cfif fuseaction contains "popup_">
	<input type="hidden" name="comes_popup" id="comes_popup" value="1">
</cfif>
  <table width="98%" height="30" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr>
      <td class="headbold"><cf_get_lang dictionary_id='55233.Satış Primi'></td>
      <td></td>
    </tr>
  </table>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr class="color-border">
      <td valign="top">
        <table width="100%" align="center" cellpadding="2" cellspacing="1" border="0">
          <tr>
            <td valign="top" class="color-row">
              <table>
                <tr class="txtboldblue">
                  <td width="115"><cf_get_lang dictionary_id='57655.Başlangıç Tarihi'><cfoutput>
                      <input type="hidden" name="emp_id" id="emp_id" value="#url.employee_id#">
                      <input type="hidden" name="name" id="name" value="#EMP_DET.EMPLOYEE_NAME#&nbsp;#EMP_DET.EMPLOYEE_SURNAME#" disabled>
                    </cfoutput></td>
                  <td width="115"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></td>
                  <td width="80"><cf_get_lang dictionary_id='29472.Yöntem'></td>
                  <td width="150"><cf_get_lang dictionary_id='55237.dan Fazla'></td>
                  <td width="150"><cf_get_lang dictionary_id='55238.Periyod'></td>
                  <td width="80">%</td>
                </tr>
                <tr> <cfoutput>
                    <td>
                      <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></cfsavecontent>
					  <cfinput type="text" required="yes" message="#message#" validate="#validate_style#" name="start" style="width:90px;">
                      <cf_wrk_date_image date_field="start"> </td>
                    <td>
                      <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
					  <cfinput type="text" required="yes"  message="#message#" validate="#validate_style#" name="finish" style="width:90px;">
                      <cf_wrk_date_image date_field="finish"> </td>
                  </cfoutput>
                  <td><select name="ciro" id="ciro" style="width:80px;">
                      <option value="1"><cf_get_lang dictionary_id='55482.Cirodan'></option>
                      <option value="2"><cf_get_lang dictionary_id='55466.Kardan'></option>
                    </select>
                  </td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang dictionary_id='55634.dan Fazla girmelisiniz'></cfsavecontent>
                  <cfinput type="text" name="money"  required="yes" message="#message#" validate="integer" style="width:150px;">
				  </td>
                  <td><select name="term" id="term" style="width:150px;">
                      <option value="1"><cf_get_lang dictionary_id='55936.Ayda'> 1</option>
                      <option value="2">3 <cf_get_lang dictionary_id='55936.Ayda'> 1</option>
                      <option value="3">6 <cf_get_lang dictionary_id='55936.Ayda'> 1</option>
                      <option value="4"><cf_get_lang dictionary_id='53312.Yılda'> 1</option>
                    </select>
                  </td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang dictionary_id="38589.girmelisiniz"></cfsavecontent>
				  <cfinput type="text" name="percentage" required="yes" message="#message#" validate="float" style="width:80px;">
                  </td>
                </tr>
                <tr>
                  <td colspan="6">
					<cf_workcube_buttons is_upd='0' > 
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</cfform>
<br/>
