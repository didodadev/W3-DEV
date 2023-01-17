<cfinclude template="../query/get_service_reply.cfm">
<cfinclude template="../query/get_reply_basket.cfm">
<cf_ajax_list>
    <tbody>
        <cfloop from="1" to="#arraylen(session.service_reply)#" index="i">
        <cfoutput> 
             <tr> 
                <td>:#session.service_reply[i][9]#</td>
                <td width="15" align="right" style="text-align:right;">
                    <cfif not listfindnocase(denied_pages,'service.emptypopup_del_reply_row')>
                        <a href="#request.self#?fuseaction=service.emptypopup_del_reply_row&var_=service_reply&row=#i#&ID=#URL.ID#"><img src="/images/delete_list.gif" align="absmiddle" border="0"></a>
                    </cfif>
                </td>
              </tr>
              <tr> 
                <td><cf_get_lang_main no='330.Tarih'></td>
                <td>:#dateformat(session.service_reply[i][4],dateformat_style)#</td>
              </tr>
              <tr> 
                <td><cf_get_lang no='51.Cevap V.'></td>
                <td>:#session.service_reply[i][6]#</td>
              </tr>
              <tr> 
                <td><cf_get_lang_main no='68.Başlık'></td>
                <td>:#session.service_reply[i][5]#</td>
              </tr>
              <tr> 
                <td><cf_get_lang_main no='217.Açıklama'></td>
                <td>:#session.service_reply[i][1]# </td>
              </tr>
        </cfoutput> 
        </cfloop>
    </tbody>
</cf_ajax_list>
