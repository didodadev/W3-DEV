<cfquery name="get_licence" datasource="#dsn#">
	SELECT WORKCUBE_ID,COMPANY FROM LICENSE
</cfquery>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no='4.WorkCube Sorun Bildir'></td>
  </tr>
</table>
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr class="color-border">
    <td valign="top">
      <table width="100%" height="100%" cellpadding="2" cellspacing="1" border="0">
        <tr class="color-row">
          <td valign="top">
            <cfform name="add_bug" method="post" action="#request.self#?fuseaction=help.emptypopup_add_bug">
              <table  border="0">
                <tr>
                  <td><cf_get_lang no='27.Workcube ID'></td>
                  <td><input type="text" name="workcube_id" id="workcube_id" style="width:300px;" maxlength="50" value="<cfoutput>#get_licence.WORKCUBE_ID#</cfoutput>" readonly></td>
                </tr>
				 <tr>
                  <td><cf_get_lang_main no='162.Şirket'></td>
                  <td><input type="text" name="WORKCUBE_COMPANY" id="WORKCUBE_COMPANY" style="width:300px;"  maxlength="50" value="<cfoutput>#get_licence.company#</cfoutput>" readonly></td>
                </tr>
				<tr>
                  <td><cf_get_lang no='18.Modül'></td>
                  <td><input type="text" name="BUG_CIRCUIT" id="BUG_CIRCUIT" style="width:300px;"  maxlength="50" <cfif isdefined("attributes.help")>value="<cfoutput>#listfirst(attributes.help,".")#</cfoutput>"</cfif>></td>
                </tr>
                <tr>
                  <td><cf_get_lang_main no='169.Sayfa'></td>
                  <td><input type="text" name="BUG_FUSEACTION" id="BUG_FUSEACTION"  style="width:300px;" maxlength="50" <cfif isdefined("attributes.help")>value="<cfoutput>#listLAST(attributes.help,".")#</cfoutput>"</cfif>></td>
                </tr>
                <tr>
                  <td width="65"><cf_get_lang_main no='68.Başlık'>*</td>
                  <td width="220">
				  	<cfsavecontent variable="message"><cf_get_lang_main no='647.Hata Başlığı Girmelisiniz'>!</cfsavecontent>
				  	<cfinput type="text" name="bug_head" style="width:300px;" maxlength="100" required="yes" message="#message#"></td>
                </tr>
                <tr>
                  <td><cf_get_lang_main no='217.Açıklama'></td>
                  <td><textarea name="BUG_BODY" id="BUG_BODY" cols="" rows="" style="width:300px;height:100px;"></textarea></td>
                </tr>
                <tr>
                  <td></td>
                  <td height="35"><cf_workcube_buttons is_upd='0'></td>
                </tr>
                <cfif isdefined("attributes.ok")>
                  <tr>
                    <td colspan="4" height="22"><font color="red"><cf_get_lang no='14.Bug Kaydedildi'></font></td>
                  </tr>
                </cfif>
              </table>
            </cfform>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
