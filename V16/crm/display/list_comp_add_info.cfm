<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no='276.Firma Ek Bilgileri'></td>
  </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center">
  <tr>
    <td class="color-border">
      <table border="0" cellspacing="1" cellpadding="2" width="100%">
        <tr>
          <td class="color-row" valign="top">
            <cfform action="#request.self#?fuseaction=onjects.add_info_plus" method="post">
              <table>
                <tr>
                  <td><cf_get_lang no='277.Özellik Sahibi'></td>
                  <td>
                    <input type="hidden" name="OWNER_TYPE_ID" id="OWNER_TYPE_ID" value="<cfoutput>#TYPE_ID#</cfoutput>">
                    <input type="hidden" name="COMPANY_ID_ID" id="COMPANY_ID_ID" value="<cfoutput>#attributes.cp_id#</cfoutput>">
                  </td>
                </tr>
                <cfloop index="i" from="1" to="5">
                  <tr>
                    <td><cf_get_lang_main no='220.Özellik'><cfoutput>#i#</cfoutput></td>
                    <td>
                      <input type="text" name="<cfoutput>PROPERTY#i#</cfoutput>" id="<cfoutput>PROPERTY#i#</cfoutput>" style="width=175;"  >
                    </td>
                    <td>
                      <cfset j=1+5>
                      <cfoutput>#j#</cfoutput> </td>
                    <td>
                      <input type="text" name="<cfoutput>PROPERTY#j#</cfoutput>" id="<cfoutput>PROPERTY#j#</cfoutput>" style="width=175;"  >
                    </td>
                  </tr>
                </cfloop>
                <tr>
                  <td colspan="2"  style="text-align:right;">
				  <cf_workcube_buttons is_upd='0'>
				  </td>
                </tr>
              </table>
            </cfform>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
