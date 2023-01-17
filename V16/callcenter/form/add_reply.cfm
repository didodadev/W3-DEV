<cfinclude template="../query/get_service_reply.cfm">
<cfinclude template="../query/get_reply_basket.cfm">
<table cellSpacing="0" cellpadding="0" width="98%"  border="0">
	<tr class="color-border">
		<td>            
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr class="color-header" height="22"> 
          <td> 
            <table width="100%" cellpadding="0" cellspacing="0" border="0">
              <tr class="color-header" > 
                <td class="form-title" width="100"><cf_get_lang dictionary_id="41702.SMS Cevaplar"></td>
                <td  style="text-align:right;">
				</td>
              </tr>
            </table>
          </td>
        </tr>
        <cfloop from="1" to="#arraylen(session.service_reply)#" index="i">
          <cfoutput> 
            <tr class="color-row" height="22"> 
              <td>
			    <table border="0">
                   <tr> 
					<td class="txtboldblue" width="50">SMS No</td>
					<td width="50%">:#session.service_reply[i][9]#</td>
                    <td width="50%"  style="text-align:right;">
						<cfif not listfindnocase(denied_pages,'call.emptypopup_del_reply_row')>
							<a href="#request.self#?fuseaction=call.emptypopup_del_reply_row&var_=service_reply&row=#i#&ID=#URL.ID#"><img src="/images/delete_list.gif" alt="Delete"  align="absmiddle" border="0"></a>
						</cfif>
					</td>
                  </tr>
                  <tr> 
                    <td class="txtboldblue" width="50"><cf_get_lang dictionary_id="57742.Tarih"></td>
                    <td width="100%" colspan="2">:#dateformat(session.service_reply[i][4],dateformat_style)#</td>
                  </tr>
                  <tr> 
                    <td class="txtboldblue" width="50"><cf_get_lang dictionary_id="58654.Cevap"></td>
                    <td width="100%" colspan="2">:#session.service_reply[i][6]#</td>
                  </tr>
                  <tr> 
                    <td class="txtboldblue" width="50"><cf_get_lang_main no='68.Başlık'></td>
                    <td width="100%" colspan="2">:#session.service_reply[i][5]#</td>
                  </tr>
                  <tr> 
                    <td class="txtboldblue"><cf_get_lang_main no='217.Açıklama'></td>
                    <td colspan="2">:#session.service_reply[i][1]# </td>
                  </tr>
                </table>
              </td>
            </tr>
          </cfoutput> 
        </cfloop>
      </table>
	  	</td>
	  </tr>
	</table>
