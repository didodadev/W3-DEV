<cfinclude template="../query/get_consumer_analysis_s.cfm">
      <table cellspacing="0" cellpadding="0" width="98%" border="0">
        <tr class="color-border">
          <td>
            <table cellspacing="1" cellpadding="2" width="100%" border="0">
              <tr class="color-header"  height="22">
                <td class="form-title" style="cursor:pointer;" onClick="gizle_goster(perform);"><cf_get_lang_main no ='1387.Analizler'></td>
              </tr>
              <tr class="color-row" style="display:none;" id="perform" height="20">
                <td>
                  <table border="0">
                    <cfif get_consumer_analysis_s.recordcount>
                      <cfoutput query="get_consumer_analysis_s">
                        <cfinclude template="../query/get_consumer_analysis_result.cfm">
                        <cfif ListFind(ANALYSIS_CONSUMERS, get_consumer.CONSUMER_CAT_ID)>
                          <tr height="20">
                            <td><a href="#request.self#?fuseaction=crm.analysis_results&analysis_id=#analysis_id#" class="tableyazi">#ANALYSIS_HEAD#</a></td>
                            <!--- <td>#DateFormat(now(),"yyyy")#</td> --->
                            <td align="center">
                              <cfif get_consumer_analysis_result.RecordCount>
                                <cfif  not listfindnocase(denied_pages,'crm.popup_user_analysis_result')>
                                  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_user_analysis_result&analysis_id=#analysis_id#&result_id=#get_consumer_analysis_result.result_id#&member_type=consumer&consumer_id=#attributes.cid#','medium');"> <img src="/images/update_list.gif" alt="<cf_get_lang_main no='354.Formu Güncelle'>" border="0" title="<cf_get_lang_main no='354.Formu Güncelle'>"> </a>
                                </cfif>
                                <cfelse>
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=crm.popup_make_analysis&analysis_id=#analysis_id#&member_type=consumer&member_id=#attributes.cid#','list');"> <img src="/images/plus_list.gif" alt="<cf_get_lang_main no='350.Formu Doldur'>" title="<cf_get_lang_main no='350.Formu Doldur'>" border="0"> </a>
                              </cfif><!--- popup_add_analysis_user consumer_id--->
                            </td>
                          </tr>
                        </cfif>
                      </cfoutput>
                      <cfelse>
                      <tr class="color-row">
                        <td height="20" colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                      </tr>
                    </cfif>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
