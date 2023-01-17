<cfquery name="get_rol" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		SETUP_PROJECT_ROLES
	ORDER BY
		PROJECT_ROLES	
</cfquery>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
        <tr height="35" class="color-list">
          <td class="headbold">&nbsp;<cf_get_lang no='61.Kurumsal Üye Ekibi'></td>
        </tr>
        <tr class="color-row">
          <td valign="top">
            <table border="0">
              <tr class="txtboldblue" height="25">
                <td></td>
                <td><cf_get_lang_main no='164.Çalışan'></td>
                <td><cf_get_lang no='257.Rol'></td>
              </tr>
              <cfform action="#request.self#?fuseaction=crm.emptypopup_member_add&cp_id=#url.c_id#" method="post" name="worker">
                <cfloop index="i" from="1" to="10">
                  <tr>
                    <td></td>
                    <td width="185"> 
					<cfoutput>
                        <input type="hidden" name="POSITION_CODE#i#" id="POSITION_CODE#i#" value="">
                        <input type="hidden" name="PARTNER_ID#i#" id="PARTNER_ID#i#" value="">
                        <input type="text" name="emp_par_name#i#" id="emp_par_name#i#" value="" style="width:150px;">
                      </cfoutput> 
					  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1,2,6&field_partner=worker.PARTNER_ID#i#&field_code=worker.POSITION_CODE#i#&field_name=worker.emp_par_name#i#</cfoutput>','list');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a> </td>
                    <td><!---<cf_wrk_combo
							name=""
							query_name=""
							option_name=""
							option_value=""--->
                      <select name="get_rol<cfoutput>#i#</cfoutput>" id="get_rol<cfoutput>#i#</cfoutput>">
                        <option value="0"><cf_get_lang no='180.Seçiniz'></option>
                        <cfif get_rol.recordcount>
                          <cfoutput query="get_rol">
                            <option value="#PROJECT_ROLES_ID#">#PROJECT_ROLES#</option>
                          </cfoutput>
                        </cfif>
                      </select>
                    </td>
                  </tr>
                </cfloop>
                <tr>
                  <td style="text-align:right;" colspan="3" height="35">
				  <cf_workcube_buttons is_upd='0'>
				  </td>
                </tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

