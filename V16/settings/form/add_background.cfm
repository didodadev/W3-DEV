<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no='320.Background Ekle'></td>
  </tr>
</table>
      <table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
        <tr>
          <td width="200" valign="top" class="color-row">
            <cfinclude template="../display/list_backgrounds.cfm">
          </td>
          <td valign="top" class="color-row">
            <table>
              <cfform action="#request.self#?fuseaction=settings.emptypopup_add_background" method="post" name="background" enctype="multipart/form-data">
                <tr>
                  <td width="75"><cf_get_lang no='321.İmaj Adı'>*</td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no='725.İmaj Adı girmelisiniz'></cfsavecontent>
				  <cfinput type="Text" name="background_name" maxlength="50" required="Yes" message="#message#" style="width:200;">
                  </td>
                </tr>
                <tr>
                  <td><cf_get_lang_main no='1965.İmaj'></td>
                  <td><input type="file" name="background_file" id="background_file"  style="width:200;">
                  </td>
                </tr>
                <tr>
                  <td><cf_get_lang no='323.Portal'></td>
                  <td><input type="radio" name="portal" id="portal" value="1" checked> EP
                    <input type="radio" name="portal" id="portal" value="2"> PP
                    <input type="radio" name="portal" id="portal" value="3"> WW 
				</td>
                </tr>
                <tr>
                  <td><cf_get_lang no='324.Konum'></td>
                  <td>
                    <select name="page" id="page" style="width:200;">
                      <option value="1"> 1</option>
                      <option value="2"> 2</option>
                      <option value="3"> 3</option>
                      <option value="4"> 4</option>
                      <option value="5"> 5</option>
                      <option value="6"> 6</option>
                      <option value="7"> 7</option>
                      <option value="8"> 8</option>
                      <option value="9"> 9</option>
                      <option value="10"> 10</option>
                      <option value="11"> 11</option>
                      <option value="12"> 12</option>
                      <option value="13"> 13</option>
                      <option value="14"> 14</option>
                      <option value="15"> 15</option>
                      <option value="16"> 16</option>
                      <option value="17"> 17</option>
                      <option value="18"> 18</option>
                      <option value="19"> 19</option>
                      <option value="20"> 20</option>
                      <option value="21"> 21</option>
                      <option value="22"> 22</option>
                      <option value="23"> 23</option>
                      <option value="24"> 24</option>
                      <option value="25"> 25</option>
                    </select>
                  </td>
                </tr>
                <tr>
                  <td height="35" colspan="2" align="right" style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
                </tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>

