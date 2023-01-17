<cfinclude template="../query/get_assetp_reserve.cfm">

    <cfscript>
		if(Len(get_assetp_reserve.startdate))
			STARTDATE_TEMP = date_add('h',session.ep.time_zone,get_assetp_reserve.startdate);
		if(Len(get_assetp_reserve.finishdate))
			FINISHDATE_TEMP = date_add('h',session.ep.time_zone,get_assetp_reserve.finishdate);
		if(Len(get_assetp_reserve.startdate)){
			startdate = dateformat(STARTDATE_TEMP,dateformat_style);
			starthour = timeformat(STARTDATE_TEMP,"HH");
			startmin = timeformat(STARTDATE_TEMP,"MM");
		}
		else{
			startdate = "";
			starthour = "";
			startmin = "";		
		}			
		if(Len(get_assetp_reserve.finishdate)){
			finishdate = dateformat(FINISHDATE_TEMP,dateformat_style);
			finishhour = timeformat(FINISHDATE_TEMP,"HH");
			finishmin = timeformat(FINISHDATE_TEMP,"MM");		
		}
		else{
			finishdate = "";
			finishhour = "";
			finishmin = "";		
		}	
	</cfscript>
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border" align="center">
        <tr class="color-list" valign="middle">
          <td height="35">
            <table width="98%" align="center">
              <tr>
                <td valign="bottom" class="headbold"><cf_get_lang no='26.Kaynak Rezervasyonu'> </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row" valign="middle">
          <td>
            <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0" height="100%">
              <tr>
                <td colspan="2" valign="top">
                  <cfform  name="upd_assetp_reserve" method="post" action="#xfa.upd#">
                    <table cellspacing="0" cellpadding="0" width="95%">
                      <tr>
                        <td valign="top">
                         <br/>
						  <input type="hidden" name="assetp_resid" id="assetp_resid" value="<cfoutput>#attributes.assetp_resid#</cfoutput>">
                          <input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#attributes.assetp_id#</cfoutput>">
                          <table>
                            <tr>
                              <td colspan="2" height="25"><cf_get_lang_main no='89.Başlangıç'></td>
                              <td height="25" align="center">
                                <cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik veri'>:<cf_get_lang_main no='641.Başlangıç tarihi'></cfsavecontent>
								<cfinput type="text" name="startdate" style="width:80px;" required="Yes" validate="#validate_style#" message="#message#" value="#startdate#">
                                <cf_wrk_date_image date_field="startdate">
                                <select name="event_start_clock" id="event_start_clock" style="width:50px;">
                                  <option value="00" selected><cf_get_lang_main no='79.Saat'></option>
                                  <cfloop from="1" to="23" index="i">
                                    <cfoutput>
                                      <option value="#i#" <cfif starthour eq i>selected</cfif>>#i#</option>
                                    </cfoutput>
                                  </cfloop>
                                </select>
                                <select name="event_start_minute" id="event_start_minute" style="width:50px;">
                                  <option value="00" selected><cf_get_lang_main no='1415.dk'></option>
                                  <cfloop from="05" to="55" index="i" step="5">
                                    <cfoutput>
                                      <option value="#i#" <cfif startmin eq i>selected</cfif>>#i#</option>
                                    </cfoutput>
                                  </cfloop>
                                </select>
                              </td>
                            </tr>
                            <tr>
                              <td colspan="2" height="25"><cf_get_lang_main no='90.Bitiş'> </td>
                              <td height="25" align="center">
                                <cfsavecontent variable="message"><cf_get_lang_main no='97.Bitiş girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="finishdate" style="width:80px;" required="Yes" validate="#validate_style#" message="#message#" value="#finishdate#">
                                <cf_wrk_date_image date_field="finishdate">
                                <select name="event_finish_clock" id="event_finish_clock" style="width:50px;">
                                  <option value="00" selected><cf_get_lang_main no='79.Saat'></option>
                                  <cfloop from="1" to="23" index="i">
                                    <cfoutput>
                                      <option value="#i#"  <cfif finishhour eq i>selected</cfif>>#i#</option>
                                    </cfoutput>
                                  </cfloop>
                                </select>
                                <select name="event_finish_minute" id="event_finish_minute" style="width:50px;">
                                  <option value="00" selected><cf_get_lang_main no='1415.dk'></option>
                                  <cfloop from="05" to="55" index="i" step="5">
                                    <cfoutput>
                                      <option value="#i#"  <cfif finishmin eq i>selected</cfif>>#i#</option>
                                    </cfoutput>
                                  </cfloop>
                                </select>
                              </td>
                            </tr>
							<tr><td height="35" colspan="3"  style="text-align:right;">
						<input type="button" value="<cf_get_lang no='7.Rezervasyonlar'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=asset.popup_list_assetp_reservations&assetp_id=#assetp_id#</cfoutput>','list');">
                         <cf_workcube_buttons is_upd='1'  delete_page_url='#xfa.del#&assetp_resid=#attributes.assetp_resid#' add_function='check()'> 
						 </td> 
						 </tr>
						    <!--- hata varsa göster --->
                          </table>
                        </td>
                      </tr>              
                    </table>
                  </cfform>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>

<script type="text/javascript">
function check()
{
	if ( (upd_assetp_reserve.startdate.value != "") && (upd_assetp_reserve.finishdate.value != "") )
		return time_check(upd_assetp_reserve.startdate, upd_assetp_reserve.event_start_clock, upd_assetp_reserve.event_start_minute, upd_assetp_reserve.finishdate,  upd_assetp_reserve.event_finish_clock, upd_assetp_reserve.event_finish_minute, "<cf_get_lang no='96.Başlangıç Tarihi Bitiş Tarihinden Önce Olmalıdır !'>");
}
</script>
