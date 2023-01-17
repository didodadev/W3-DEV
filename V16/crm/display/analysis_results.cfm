<cfinclude template="../query/get_analysis.cfm">
<cfinclude template="../query/get_analysis_questions.cfm">
<cfinclude template="../query/get_analysis_results.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_analysis_results.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="98%" cellpadding="0" cellspacing="0" border="0" height="35" align="center">
  <tr>
    <td class="headbold"><cf_get_lang_main no='1982.Analiz Sonucu'>: <cfoutput>
      <a href="#request.self#?fuseaction=crm.add_analysis&analysis_id=#get_analysis.analysis_id#">#get_analysis.analysis_head#</a></td>
    <td style="text-align:right;">
	  <cfif isdefined("attributes.analysis_id") and len(attributes.analysis_id)><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=crm.popup_dsp_analyse_result&analysis_id=#attributes.analysis_id#','page');"><img src="/images/grafi.gif" alt="Sonuçlar"  title="Sonuçlar" border="0"></a></cfif>
      <cfif not listfindnocase(denied_pages,'crm.analysis') and isdefined("attributes.analysis_id") and len(attributes.analysis_id)><a href="#request.self#?fuseaction=crm.analysis&analysis_id=#attributes.analysis_id#"><img src="/images/refer.gif" alt="" border="0"></a></cfif>
    </cfoutput> 
    <cfif isdefined("attributes.analysis_id") and len(attributes.analysis_id)>
      <CF_NP tablename="member_analysis" primary_key="analysis_ID" pointer="analysis_ID=#analysis_ID#"> 
    </cfif>
    </td>
  </tr>
</table>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
  <tr class="color-border">
    <td>
      <table width="100%" align="center" cellpadding="2" cellspacing="1" border="0">
        <tr height="20" class="color-row">
          <td colspan="6">
            <table>
              <tr>
                <td class="txtbold"><cf_get_lang no ='519.Toplam Soru'>:</td>
                <td width="50"><cfoutput>#get_analysis_questions.recordCount#</cfoutput></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-header" height="22">
          <td width="30" class="form-title"><cf_get_lang_main no='75.no'></td>
          <td class="form-title"><cf_get_lang_main no='1983.Katılımcı'></td>
          <td width="50"  class="form-title" style="text-align:right;"><cf_get_lang_main no='1572.Puan'></td>
          <td width="30"  style="text-align:right;"></td>
        </tr>
        <cfif get_analysis_results.recordcount>
          <cfoutput query="get_analysis_results" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <cfif len(get_analysis_results.CONSUMER_ID)>
              <cfset attributes.CONSUMER_ID = CONSUMER_ID>
              <cfelseif len(get_analysis_results.PARTNER_ID)>
              <cfset attributes.partner_id = partner_id>
              <cfset url.pid = partner_id>
            </cfif>
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td>#currentrow#</td>
              <td>
                <cfif len(get_analysis_results.CONSUMER_ID)>
                  <cfinclude template="../query/get_consumer.cfm">
                  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#attributes.CONSUMER_ID#','medium');" class="tableyazi">#get_CONSUMER.CONSUMER_NAME# #get_CONSUMER.CONSUMER_SURNAME#</a>
                  <cfelseif len(get_analysis_results.PARTNER_ID)>
                  <cfinclude template="../query/get_partner.cfm">
                  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#attributes.partner_id#','medium');" class="tableyazi">#GET_PARTNER.COMPANY_PARTNER_NAME# #GET_PARTNER.COMPANY_PARTNER_SURNAME#</a> (#GET_PAR_INFO(get_analysis_results.PARTNER_ID,0,1,1)#)
                </cfif>
              </td>
              <td  style="text-align:right;">#user_point# / #get_analysis.total_points#</td>
              <cfif not listfindnocase(denied_pages,'crm.popup_user_analysis_result')>
                <td align="center" width="30"> 
				<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_user_analysis_result&analysis_id=#get_analysis.analysis_id#&result_id=#result_id#<cfif len(get_analysis_results.CONSUMER_ID)>&consumer_id=#attributes.consumer_id#&member_type=consumer<cfelseif len(get_analysis_results.PARTNER_ID)>&partner_id=#attributes.partner_id#&member_type=partner</cfif>','page');"><img src="/images/quiz.gif" alt="<cf_get_lang_main no='52.Analiz Güncelle'>" border="0" title="<cf_get_lang_main no='52.Analiz Güncelle'>"></a></td>
              </cfif>
            </tr>
          </cfoutput>
          <cfelse>
          <tr height="20" class="color-row">
            <td colspan="8"><cf_get_lang_main no='72.Kayıt bulunamadı'>!</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<cfif get_analysis_results.recordcount>
  <cfif attributes.totalrecords gt attributes.maxrows>
    <table width="98%" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td> <cf_pages
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="crm.analysis_results&analysis_id=#attributes.analysis_id#"> </td>
        <!-- sil --><td width="275"  style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
      </tr>
    </table>
    <br/>
    </td>
    </tr>
  </cfif>
</cfif>

