<cfquery name="PERF_PERIOD" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_PERF_PERIOD 
	WHERE	
		PERF_PERIOD_ID = #ID#
</cfquery>
<cfif perf_period.recordcount>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
	  <td class="headbold"><cf_get_lang no='640.Performans Ölçüm Peryodu Güncelle'></td>
	</tr>
</table>
  <table   width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr class="color-border">
      <td>
        <table width="100%" border="0" align="center" cellpadding="2" cellspacing="1">
          <tr class="color-row">
            <td width="200" valign="top"><cfinclude template="../display/list_perf_period.cfm"></td>
            <td>
              <table>
                <cfform action="#request.self#?fuseaction=settings.popup_upd_perf_period" method="post" name="perf_period">
                  <tr>
                    <td width="150"><cf_get_lang no='238.Performans Ölçüm Periyodu'></td>
                    <td>
                      <select name="perf_period" id="perf_period">
                        <option value="1" <cfif perf_period.perf_period is 1>selected</cfif>><cf_get_lang_main no='1603.Yıllık'></option>
                        <option value="2" <cfif perf_period.perf_period is 2>selected</cfif>>6 <cf_get_lang_main no='1520.Aylık'></option>
                      </select>
                    </td>
                  </tr>
				  <tr>
				  <td colspan="2" class="txtboldblue"><cf_get_lang_main no='71.Kayıt'> :
				  <cfoutput>
				  	<cfif len(perf_period.record_emp)>#get_emp_info(perf_period.record_emp,0,0)#</cfif>
					<cfif len(perf_period.record_date)> - #dateformat(perf_period.record_date,dateformat_style)#</cfif>
				  </cfoutput>
				  </td>
				  </tr>
                  <tr>
                    <td align="right" colspan="2" height="35"><cf_workcube_buttons is_upd='0'></td>
                  </tr>
                </cfform>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</cfif>

