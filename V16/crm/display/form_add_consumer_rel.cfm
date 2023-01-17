<cfquery name="get_rel" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		SETUP_CONSUMER_RELATION
	ORDER BY
		CONSUMER_RELATION
</cfquery>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
        <tr height="35" class="color-list">
          <td class="headbold">&nbsp;<cf_get_lang no='134.Bireysel Üye İlişki'>:</td>
        </tr>
        <tr class="color-row">
          <td valign="top">
            <table border="0">
              <tr class="txtboldblue" height="25">
                <td></td>
                <td><cf_get_lang_main no='174.Bireysel Üye'></td>
                <td><cf_get_lang_main no='1268.İlişki'></td>
              </tr>
              <cfform action="#request.self#?fuseaction=crm.emptypopup_consumer_relation_add&cid=#url.cid#" method="post" name="relation">
                <cfloop index="i" from="1" to="10">
                  <tr>
                    <td></td>
                    <td width="185"> <cfoutput>
                        <input type="hidden" name="CONSUMER_RELATION#i#" id="CONSUMER_RELATION#i#" value="">
                        <input type="hidden" name="CONSUMER_RELATION_ID#i#" id="CONSUMER_RELATION_ID#i#" value="">
                        <input type="hidden" name="TYPE#i#" id="TYPE#i#" value="">
                        <input type="text" name="con_name#i#" id="con_name#i#" value="" style="width:150px;">
                      </cfoutput> <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_cons&select_list=1,2,3&field_id=relation.CONSUMER_RELATION_ID#i#&field_type=relation.TYPE#i#&field_name=relation.con_name#i#</cfoutput>','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
					  </td>
                    <td>
                      <select name="CONSUMER_RELATION<cfoutput>#i#</cfoutput>" id="CONSUMER_RELATION<cfoutput>#i#</cfoutput>">
                        <option value="0"><cf_get_lang no='180.Seçiniz'></option>
                        <cfif get_rel.recordcount>
                          <cfoutput query="get_rel">
                            <option value="#CONSUMER_RELATION_ID#">#CONSUMER_RELATION#</option>
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

