<cfquery name="DEFECT_LOCATION" datasource="#dsn_ts#">
	SELECT DEFECT_LOCATION_ID, DEFECT_LOCATION FROM	SETUP_DEFECT_LOCATION
</cfquery>
<cfinclude template="../query/get_defect_location.cfm">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
        <tr class="color-list">
          <td height="35" class="headbold"><cf_get_lang dictionary_id='36518.Defo Yeri Düzenle'></td>
        </tr>
        <tr class="color-row">
          <td valign="top">
            <table border="0">
              <cfform action="#request.self#?fuseaction=prod.popup_upd_DEFECT_LOCATION&DEFECT_LOCATION_id=#DEFECT_LOCATION_id#" method="post" name="add_DEFECT_LOCATION">
                <input type="hidden" name="counter" id="counter" value="">
                <input type="hidden" name="DEFECT_LOCATION_id" id="DEFECT_LOCATION_id" value="<cfoutput>#DEFECT_LOCATION_id#</cfoutput>">
                <tr>
                  <td width="75"><cf_get_lang dictionary_id='57756.Durum'></td>
                  <td><input type="Checkbox" name="status" id="status" value="1" <cfif get_DEFECT_LOCATION.status eq 1>checked</cfif>>
                    <cf_get_lang dictionary_id='57493.Aktif'></td>
                </tr>
                <tr>
                  <td><cf_get_lang dictionary_id='36560.Defo Yeri Kodu'>*</td>
                  <td> <cfoutput query="DEFECT_LOCATION">
                      <cfif get_DEFECT_LOCATION.DEFECT_LOCATION_ID eq DEFECT_LOCATION_ID>
                        #DEFECT_LOCATION_ID#
                      </cfif>
                    </cfoutput>
                    </select>
                  </td>
                </tr>
                <tr>
                  <td><cf_get_lang dictionary_id='36559.Defo Yeri'>*</td>
                  <td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='36695.Defo Yeri girmelisiniz'></cfsavecontent>
					<cfinput type="Text" name="DEFECT_LOCATION" style="width:250;" value="#get_DEFECT_LOCATION.DEFECT_LOCATION#" maxlength="100" required="Yes" message="#message#">
                  </td>
                </tr>
                <tr>
                  <td valign="top"><cf_get_lang dictionary_id='57629.açıklama'></td>
                  <td>
				  	<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                    <TEXTAREA name="DEFECT_LOCATION_detail" id="DEFECT_LOCATION_detail" cols="60" rows="2" style="width:250;height:60;" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#get_DEFECT_LOCATION.DEFECT_LOCATION_detail#</cfoutput></TEXTAREA>
                  </td>
                </tr>
                <tr>
                  <td align="right" colspan="2" height="35"> 
				 	 <cf_workcube_buttons is_upd='0' delete_page_url='#request.self#?fuseaction=prod.popup_del_defect_location&defect_location_id=#defect_location_id#'> 
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
