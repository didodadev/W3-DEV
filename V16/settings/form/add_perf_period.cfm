<cfquery name="PERF_PERIOD" datasource="#dsn#">
SELECT * FROM SETUP_PERF_PERIOD
</cfquery>

<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
  <tr>
    <td class="headbold"><cf_get_lang no='238.Performans Ölçüm Periyodu'></td>
  </tr>
</table>
<table   width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" align="center" cellpadding="2" cellspacing="1">
        <tr class="color-row">
          <td width="200" valign="top">
            <cfinclude template="../display/list_perf_period.cfm">
          </td>
          <cfif PERF_PERIOD.RecordCount EQ 0>
            <td>
              <table>
                <cfform action="#request.self#?fuseaction=settings.popup_add_perf_period" method="post" name="perf_period">
                  <tr>
                    <td width="120">
                      <cf_get_lang no='489.Ölçüm Periyodu'></td>
                    <td>
                      <select name="PERF_PERIOD" id="PERF_PERIOD" style="width:125px;">
                        <option value="1"><cf_get_lang_main no='1603.Yıllık'></option>
                        <option value="2">6
                        <cf_get_lang_main no='1520.Aylık'></option>
                      </select>
                    </td>
                  </tr>
                  <tr>
                    <td align="right" colspan="2" height="35"><cf_workcube_buttons is_upd='0'></td>
                  </tr>
                </cfform>
              </table>
            </td>
          </cfif>
        </tr>
      </table>
    </td>
  </tr>
</table>		


