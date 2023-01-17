<!--- 
	url parameters :
	max_item_id=6&
	max_element_no=6&
	strlan=TR&
	strmodule=project
 --->
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border" align="center">
        <tr class="color-list" valign="middle">
          <td height="35">
            <table width="98%" align="center">
              <tr>
                <td valign="bottom" class="headbold"><cf_get_lang_main no='1729.Add Word/Kelime Ekle'></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row" valign="top">
          <td>
            <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
              <tr>
                <td colspan="2"> <br/>
                  <table>
                    <cfform action="#request.self#?fuseaction=settings.emptypopup_add_module_item_act" method="post" name="add_sub_name">
                      <tr>
                        <td><cf_get_lang no='354.Kelime (TR)'></td>
                      </tr>
                      <tr>
                        <td>
                          <input type="hidden" name="module_name" id="module_name" value="<cfoutput>#attributes.strmodule#</cfoutput>">
                          <cfsavecontent variable="message"><cf_get_lang no='724.Kelime (TR) girmelisiniz'></cfsavecontent>
						  <cfinput TYPE="text"  required="yes" NAME="sub_modulename_1" message="#message#" STYLE="width:305px;"  MAXLENGTH="75"  >
                        </td>
                      </tr>
                      <tr>
                        <td><cf_get_lang no='355.Word (ENG)'></td>
                      </tr>
                      <tr>
                        <td>
<!---                           <cfinput type="text"  required="yes" name="sub_modulename_2"  message="Kelime ekleyin" STYLE="width:305px;"  MAXLENGTH="75"   > --->
                        </td>
                      </tr>
                      <tr align="center">
                        <td height="35" colspan="2" align="right" style="text-align:right;">
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
    </td>
  </tr>
</table>
