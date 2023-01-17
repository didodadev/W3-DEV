<cfset attributes.TYPE_ID=-6>
<cfinclude template="../query/get_info_plus_detail.cfm">

<cfif GET_LABELS.RECORDCOUNT>
  <table border="0" cellspacing="0" cellpadding="0" width="100%" align="center" height="100%">
    <tr>
      <td class="color-border">
        <table border="0" cellspacing="1" cellpadding="2" width="100%" height="100%">
          <tr height="35" class="color-list">
            <td class="headbold">&nbsp;<cf_get_lang dictionary_id='36513.Ürün Ağacı Ek Bilgileri'></td>
          </tr>
          <tr>
            <td class="color-row" valign="top">
              <cfif GET_VALUES.recordcount>
                <cfset send_par="emptypopup_upd_info_plus">
                <cfelse>
                <cfset send_par="emptypopup_add_info_plus">
              </cfif>
              <cfform action="#request.self#?fuseaction=prod.#send_par#" method="post">
                <table>
                  <input type="hidden" name="STOCK_ID" id="STOCK_ID" value="<cfoutput>#attributes.ID#</cfoutput>">
                  <cfloop index="i" from="1" to="5">
                    <tr>
                      <td width="100">
                        <cfif LEN(Evaluate("GET_LABELS.PROPERTY#i#_NAME"))>
                          <cfoutput>#Evaluate("GET_LABELS.PROPERTY#i#_NAME")#</cfoutput>
                        </cfif>
                      </td>
                      <td width="175">
                        <cfif LEN(Evaluate("GET_LABELS.PROPERTY#i#_NAME"))>
                          <input type="text" name="<cfoutput>PROPERTY#i#</cfoutput>" id="<cfoutput>PROPERTY#i#</cfoutput>"  <cfif GET_VALUES.recordcount >value="<cfoutput>#Evaluate("GET_VALUES.PROPERTY#i#")#</cfoutput>"</cfif> style="width=150;">
                        </cfif>
                      </td>
                      <td width="100">
                        <cfset j=i+5>
                        <cfif LEN(Evaluate("GET_LABELS.PROPERTY#j#_NAME"))>
                          <cfoutput>#Evaluate("GET_LABELS.PROPERTY#j#_NAME")#</cfoutput>
                        </cfif>
                      </td>
                      <td>
                        <cfif LEN(Evaluate("GET_LABELS.PROPERTY#j#_NAME"))>
                          <input type="text" name="<cfoutput>PROPERTY#j#</cfoutput>" id="<cfoutput>PROPERTY#j#</cfoutput>" <cfif GET_VALUES.recordcount >value="<cfoutput>#Evaluate("GET_VALUES.PROPERTY#j#")#</cfoutput>"</cfif>  style="width=150;"  >
                        </cfif>
                      </td>
                    </tr>
                  </cfloop>
                  <cfloop index="i" from="1" to="3">
                    <tr>
                      <td>
                        <cfset st=(2*i-1)+10>
                        <cfif LEN(Evaluate("GET_LABELS.PROPERTY#st#_NAME"))>
                          <cfoutput>#Evaluate("GET_LABELS.PROPERTY#st#_NAME")#</cfoutput>
                        </cfif>
                      </td>
                      <td>
                        <cfif LEN(Evaluate("GET_LABELS.PROPERTY#st#_NAME"))>
                          <textarea  name="<cfoutput>PROPERTY#st#</cfoutput>" id="<cfoutput>PROPERTY#st#</cfoutput>"  style="width=150;height=50;"><cfif GET_VALUES.recordcount ><cfoutput>#Evaluate("GET_VALUES.PROPERTY#st#")#</cfoutput></cfif></textarea>
                        </cfif>
                      </td>
                      <td>
                        <cfset j=st+1>
                        <cfif  (i neq 3)  and LEN(Evaluate("GET_LABELS.PROPERTY#j#_NAME")) >
                          <cfoutput>#Evaluate("GET_LABELS.PROPERTY#j#_NAME")#</cfoutput>
                        </cfif>
                      </td>
                      <td>
                        <cfif (i neq 3)  and LEN(Evaluate("GET_LABELS.PROPERTY#j#_NAME")) >
                          <textarea  name="<cfoutput>PROPERTY#j#</cfoutput>" id="<cfoutput>PROPERTY#j#</cfoutput>"  style="width=150;height=50;"><cfif GET_VALUES.recordcount ><cfoutput>#Evaluate("GET_VALUES.PROPERTY#j#")#</cfoutput></cfif></textarea>
                        </cfif>
                      </td>
                    </tr>
                  </cfloop>
                  <tr>
                    <td colspan="4" align="right" style="text-align:right;"> <cf_workcube_buttons is_upd='0'> </td>
                  </tr>
                </table>
              </cfform>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
  <cfelse>
  <table border="0" cellspacing="0" cellpadding="0" width="100%" align="center" height="100%">
    <tr>
      <td class="color-border">
        <table border="0" cellspacing="1" cellpadding="2" width="100%" height="100%">
          <tr height="35" class="color-list">
            <td class="headbold">&nbsp;<cf_get_lang dictionary_id='36513.Ürün Ağacı Ek Bilgileri'></td>
          </tr>
          <tr>
            <td class="color-row" valign="top">
              <table>
                <tr>
                  <td><cf_get_lang dictionary_id='36693.Ayarlar Modulunden Ek Bilgi Detaylarını Doldurunuz'></td>
                </tr>
                <tr>
                  <td>
                    <input type="button" value="<cf_get_lang dictionary_id='57553.Kapat'>" onClick="window.close();" style="width:65px;">
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</cfif>

