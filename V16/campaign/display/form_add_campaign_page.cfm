<cfform name="add_page" method="POST" action="#request.self#?fuseaction=#xfa.add#">
<input type="Hidden" name="offer_id" id="offer_id" value="<cfoutput>#offer_id#</cfoutput>">
<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
  <tr class="color-border"> 
    <td valign="middle"> 
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
        <tr class="color-list" valign="middle"> 
          <td height="35"> 
            <table width="98%" align="center">
              <tr> 
                <td valign="bottom" width="150"><cf_get_lang_main no='657.Sayfa Tipi'></td>
                <td valign="bottom" width="60"><cf_get_lang no='168.Sayfa No'></td>
                <td valign="bottom" width="150"><cf_get_lang_main no='169.Sayfa Adı'></td>
                <td  valign="bottom" class="txtbold" style="text-align:right;">&nbsp;</td>
              </tr>
              <tr> 
                <td valign="bottom"> 
                  <select name="page_type" id="page_type" style="width:150px;">
                    <option value="1" <cfif page_type eq 1>selected</cfif>><cf_get_lang no='76.Kapak'></option>
                    <option value="2" <cfif page_type eq 2>selected</cfif>><cf_get_lang no='40.İçindekiler'></option>
                    <option value="3" <cfif page_type eq 3>selected</cfif>><cf_get_lang_main no='142.Giriş'></option>
                    <option value="4" <cfif page_type eq 4>selected</cfif>><cf_get_lang no='18.Yöneticiye Özet'></option>
					<!--- özel sayfa türü --->
                    <option value="6" <cfif page_type eq 6>selected</cfif>><cf_get_lang no='188.Koşullar'></option>
                    <option value="7" <cfif page_type eq 7>selected</cfif>><cf_get_lang no='209.Proje Metod'></option>
                    <option value="8" <cfif page_type eq 8>selected</cfif>><cf_get_lang no='124.Yatırım'></option>
					<!--- özel sayfa tipi --->
                    <option value="12" <cfif page_type eq 10>selected</cfif>><cf_get_lang_main no='272.Sonuç'></option>
                    <option value="11" <cfif page_type eq 11>selected</cfif>><cf_get_lang no='69.Ek Sayfa'></option>
                  </select>
                </td>
                <td valign="bottom"> 
                  <cfsavecontent variable="message"><cf_get_lang no='137.Sayfa No Girmelisiniz !'></cfsavecontent>
				  <cfinput type="text" name="page_no" style="width:60px;" required="Yes" validate="integer" message="#message#">
                </td>
                <td valign="bottom"> 
                  <cfsavecontent variable="message"><cf_get_lang no='37.Sayfa Adı Girmelisiniz !'></cfsavecontent>
				  <cfinput type="text" name="page_name" style="width:150px;" required="Yes" message="#message#">
                </td>
                <td  valign="bottom" class="txtbold" style="text-align:right;"><cfoutput>#get_offer_head.offer_head#/#get_offer_head.offer_number#</cfoutput>&nbsp;&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row" valign="middle"> 
          <td> 
            <table align="center">
              <tr> 
                <td colspan="2">
					<cfmodule
						template="/fckeditor/fckeditor.cfm"
						toolbarSet="WRKContent"
						basePath="/fckeditor/"
						instanceName="page_content"
						value=""
						width="550"
						height="300">
                </td>
              </tr>
              <tr> 
                <td colspan="2"  style="text-align:right;"> 
				   <cf_workcube_buttons is_upd='0'>
                  &nbsp;&nbsp; </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</cfform>
