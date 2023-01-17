<cfinclude template="../query/get_zimmet_detail.cfm">
<cfform  action="#request.self#?fuseaction=ehesap.emptypopup_close_zimmet" method="post" name="close_zimmet">
  <input type="hidden"  name="zimmet_id" id="zimmet_id" value="<cfoutput>#attributes.zimmet_id#</cfoutput>">
  <input type="hidden"  name="zimmet_row_id" id="zimmet_row_id" <cfif isdefined("attributes.zimmet_row_id")>value="<cfoutput>#attributes.zimmet_row_id#</cfoutput>"</cfif>>
  <input type="hidden" name="give_emp_id" id="give_emp_id" value="<cfoutput>#attributes.emp_id#</cfoutput>">
  <table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
    <tr class="color-border">
      <td>
        <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
          <tr class="color-list">
            <td height="35" class="headbold">&nbsp;<cf_get_lang dictionary_id='52969.Demirbaş Teslim Alan'></td>
          </tr>
          <tr class="color-row">
            <td valign="top">
              <table>
                <tr class="color-row">
                  <td width="5"></td>
                  <td width="65"><cf_get_lang dictionary_id='57570.Adı Soyadı'></td>
                  <td>
                    <input type="hidden" name="employee_id" id="employee_id" value="">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='53168.ad soyad girmelisiniz'></cfsavecontent>
					<cfinput name="employee_name"  style="width:150px;" value=""  required="yes"   message="#message#" type="text">
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=close_zimmet.employee_id&field_emp_name=close_zimmet.employee_name','list');return false"> <img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a> </td>
                </tr>
                <tr>
                  <td width="5"></td>
                  <td width="65"><cf_get_lang dictionary_id='57742.Tarih'></td>
                  <td>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
					<cfinput  type="text"  validate="#validate_style#" name="tarih" required="yes" message="#message#" value="#dateformat(now(),dateformat_style)#" style="width:150px;" >
                    <cf_wrk_date_image date_field="tarih"></td>
                </tr>
                <tr>
                  <td height="35" colspan="3" style="text-align:right;" style="text-align:right;"> <cf_workcube_buttons is_upd='0'> </td>
                </tr>
              </table>
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

