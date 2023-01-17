<cfinclude template="../query/get_tra_quiz.cfm">
<cfinclude template="../query/get_quiz_result.cfm">
		
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_quiz_results.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="100%" class="txtbold">
  <tr>
    <td>
      <table width="100%" class="txt" cellspacing="0">
        <tr class="txtbold">
          <td width="50"><cf_get_lang_main no='1512.sıralama'></td>
          <td align="left"><cf_get_lang_main no='164.Çalışan'></td>
          <td width="100" style="text-align:right;"><cf_get_lang no='60.toplam soru'></td>
          <td width="100" style="text-align:right;"><cf_get_lang no='61.doğru cevap'></td>
          <td width="100" style="text-align:right;"><cf_get_lang no='62.yanlış cevap'></td>
          <td width="100" style="text-align:right;"><cf_get_lang_main no='1572.puan'></td>
        </tr>
        <cfif get_quiz_results.recordcount>
          <cfoutput query="get_quiz_results" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <cfset attributes.employee_id = emp_id>
            <cfinclude template="../query/get_employee.cfm">
           <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td style="text-align:right;">#currentrow#</td>
              <td align="left">#get_employee.employee_name# #get_employee.employee_surname#</td>
              <td style="text-align:right;">#question_count#</td>
              <td style="text-align:right;">#user_right_count#</td>
              <td style="text-align:right;">#user_wrong_count#</td>
              <td style="text-align:right;">#user_point#</td>
            </tr>
          </cfoutput>
          <cfelse>
          <tr>
            <td colspan="6"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
  <cfif get_quiz_results.recordcount>
    <cfif attributes.totalrecords gt attributes.maxrows>
      <tr>
        <td>
          <table width="100%">
            <tr>
              <td> <cf_pages
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="training_management.quiz_results&quiz_id=#attributes.quiz_id#"> </td>
              <td width="275">
                <p class="txt"><cfoutput><cf_get_lang_main no='80.Toplam'> #attributes.totalrecords# <cf_get_lang no='65.kayıt var Şu anda'> #lastpage# <cf_get_lang no='66.sayfadan'> #attributes.page#. <cf_get_lang no='67.sayfa görüntüleniyor'></cfoutput></p>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </cfif>
  </cfif>
</table>

