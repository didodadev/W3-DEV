<!-- sil -->
<cfinclude template="../query/get_reports.cfm">
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" height="35">
  <tr>
    <td class="headbold"><cf_get_lang dictionary_id='57626.Raporlar'></td>
	<!-- sil -->
	 <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
	 <!-- sil -->
  </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2">
        <tr height="22" class="color-header">
          <td width="50" class="form-title"><cf_get_lang dictionary_id='57630.Tip'></td>
          <td class="form-title" width="250"><cf_get_lang dictionary_id='57631.Ad'></td>
          <td class="form-title"><cf_get_lang dictionary_id='57629.Açıklama'></td>
          <td class="form-title" width="150"><cf_get_lang dictionary_id='57899.Kaydeden'></td>
          <td class="form-title" width="65"><cf_get_lang dictionary_id='57742.Tarih'></td>
        </tr>
        <cfif get_reports.recordcount>
          <cfoutput query="get_reports">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td><cf_get_lang dictionary_id='57434.rapor'></td>
              <td><A class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_report&report_id=#get_reports.report_id#','list')">#report_name#</a></td><!--- excel olarak kaydedilmesini engelliyor. aselam 20041119 popupflush_dsp_report --->
              <td>#REPORT_DETAIL#</td>
              <td>#EMPLOYEE_NAME#&nbsp;#EMPLOYEE_SURNAME#</td>
              <td>#dateformat(RECORD_DATE,dateformat_style)#</td>
            </tr>
          </cfoutput>
        </cfif>
        <cfinclude template="../query/get_queries.cfm">
        <cfif get_queries.recordcount>
          <cfoutput query="get_queries">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <!--- objects.popup_dsp_report --->
              <td><cf_get_lang dictionary_id='59083.Sorgu'></td>
              <td><A class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=report.popup_query_result&report_id=#report_id#','list')">#report_name#</a></td>
              <td>#REPORT_DETAIL#</td>
              <td><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#EMPLOYEE_ID#','medium');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
              <td>#dateformat(RECORD_DATE,dateformat_style)#</td>
            </tr>
          </cfoutput>
        </cfif>
        <cfif (get_reports.recordcount eq 0) and (get_queries.recordcount eq 0)>
          <tr  class="color-row" height="20">
            <td colspan="5"> <cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<br/>
<!-- sil -->
