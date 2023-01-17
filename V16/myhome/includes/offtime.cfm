<cfinclude template="get_offtime_requests.cfm">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2">
        <tr class="color-list" height="22">
          <td class="txtboldblue"> 
		  <a href="javascript://" onClick="gizle_goster_img('offline1','offline2','off_line');"><img src="/images/listele_down.gif" title="<cf_get_lang no='116.Ayrıntıları Gizle'>" width="12" height="7" border="0" align="absmiddle" id="offline1" style="display:;cursor:pointer;"></a>
		  <a href="javascript://" onClick="gizle_goster_img('offline1','offline2','off_line');"><img src="/images/listele.gif" title="<cf_get_lang no='337.Ayrıntıları Göster'>" width="7" height="12" border="0" align="absmiddle" id="offline2" style="display:none;cursor:pointer;"></a>
		  <cf_get_lang no='142.İzin İstekleri'></td>
        </tr>
        <tr class="color-row" id="off_line">
          <td>
            <table width="100%" cellpadding="0" cellspacing="0" border="0">
              <cfif get_offtime_requests.recordcount>
                <cfoutput query="get_offtime_requests">
                  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td width="10"> </td>
                    <td width="30%"><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#">#employee_name# #employee_surname#</a></td>
                    <td width="30%"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.form_upd_offtime_popup&offtime_id=#OFFTIME_ID#','small');">#dateformat(startdate,dateformat_style)# (#timeformat(startdate,timeformat_style)#) - #dateformat(finishdate,dateformat_style)# (#timeformat(finishdate,timeformat_style)#)</a></td>
                    <td></td>
                  </tr>
                </cfoutput>
                <cfelse>
                <tr>
                  <td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                </tr>
              </cfif>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<br/>

