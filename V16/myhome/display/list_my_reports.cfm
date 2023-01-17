<cfquery name="GET_MY_REPORTS" datasource="#dsn#">
SELECT * FROM REPORT_VIEW WHERE POSITION_CODE = #SESSION.EP.POSITION_CODE#
</cfquery>
<table width="250" border="0">
  <tr height="22">
    <td class="txtboldblue"><cf_get_lang dictionary_id='30764.Raporlarım'></td>
    <td align="center"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_list_reports&position_code=#session.ep.position_code#'</cfoutput>,'list')"><img src="/images/plus_list.gif"  border="0" align="absmiddle" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a></td>
  </tr>
</table>
<table width="250" border="0">
  <cfif GET_MY_REPORTS.RECORDCOUNT GT 0>
    <cfoutput query="GET_MY_REPORTS">
      <tr height="20">
        <td>
          <cfquery name="GET_NAME" datasource="#DSN#">
          SELECT REPORT_NAME FROM REPORTS WHERE REPORT_ID = #REPORT_ID#
          </cfquery>
          #GET_NAME.REPORT_NAME# </td>
		  <cfsavecontent variable="delete_report"><cf_get_lang dictionary_id ='31967.Kayıtlı Raporu Siliyorsunuz Emin misiniz'></cfsavecontent>
        <td align="center"> <a href="##" onClick="javascript:if (confirm('#delete_report#')) windowopen('#request.self#?fuseaction=myhome.emptypopup_del_my_report&&report_id=#report_id#','small');else return false;"><img src="/images/delete_list.gif" border="0"></a> </td>
      </tr>
    </cfoutput>
    <cfelse>
    <tr height="20">
      <td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
    </tr>
  </cfif>
</table>

