<cfif isDefined("attributes.EVENT_ID")>
	  <cfinclude template="../query/get_event_dates.cfm">
	  <cfset STARTDATE_TEMP = date_add('h',session.ep.time_zone,EVENT_DATES.startdate)>
	  <cfset FINISHDATE_TEMP = date_add('h',session.ep.time_zone,EVENT_DATES.finishdate)>
	  <cfset startdate = dateformat(STARTDATE_TEMP,dateformat_style)>
	  <cfset starthour = timeformat(STARTDATE_TEMP,"HH")>
	  <cfset startmin = timeformat(STARTDATE_TEMP,"MM")>
	  <cfset finishdate = dateformat(FINISHDATE_TEMP,dateformat_style)>
	  <cfset finishhour = timeformat(FINISHDATE_TEMP,"HH")>
	  <cfset finishmin = timeformat(FINISHDATE_TEMP,"MM")>
<cfelseif isDefined("attributes.CLASS_ID")>
	<cfinclude template="../query/get_class_dates.cfm">
	 	<cfif len(get_class_dates.start_date) and len(get_class_dates.finish_date)>
		  <cfset STARTDATE_TEMP = date_add('h',session.ep.time_zone,get_class_dates.start_date)>
		  <cfset FINISHDATE_TEMP = date_add('h',session.ep.time_zone,get_class_dates.finish_date)>
		  <cfset startdate = dateformat(STARTDATE_TEMP,dateformat_style)>
		  <cfset starthour = timeformat(STARTDATE_TEMP,"HH")>
		  <cfset startmin = timeformat(STARTDATE_TEMP,"MM")>
		  <cfset finishdate = dateformat(FINISHDATE_TEMP,dateformat_style)>
		  <cfset finishhour = timeformat(FINISHDATE_TEMP,"HH")>
		  <cfset finishmin = timeformat(FINISHDATE_TEMP,"MM")>
	  <cfelse>
	  	<cfset start_date = now()>
		<cfset finish_date = now()>
		<cfset STARTDATE_TEMP = date_add('h',session.ep.time_zone,start_date)>
		<cfset FINISHDATE_TEMP = date_add('h',session.ep.time_zone,finish_date)>
		<cfset startdate = dateformat(STARTDATE_TEMP,dateformat_style)>
		<cfset starthour = timeformat(STARTDATE_TEMP,"HH")>
		<cfset startmin = timeformat(STARTDATE_TEMP,"MM")>
		<cfset finishdate = dateformat(FINISHDATE_TEMP,dateformat_style)>
		<cfset finishhour = timeformat(FINISHDATE_TEMP,"HH")>
		<cfset finishmin = timeformat(FINISHDATE_TEMP,"MM")>
	  </cfif>
<cfelseif isDefined("attributes.PROJECT_ID")>
	  <cfinclude template="../query/get_project_dates.cfm">
	  <cfset STARTDATE_TEMP = date_add('h',session.ep.time_zone,attributes.STARTDATE_TEMP)>
	  <cfset FINISHDATE_TEMP = date_add('h',session.ep.time_zone,attributes.FINISHDATE_TEMP)>
	  <cfset startdate = dateformat(STARTDATE_TEMP,dateformat_style)>
	  <cfset starthour = timeformat(STARTDATE_TEMP,"HH")>
	  <cfset startmin = timeformat(STARTDATE_TEMP,"MM")>
	  <cfset finishdate = dateformat(FINISHDATE_TEMP,dateformat_style)>
	  <cfset finishhour = timeformat(FINISHDATE_TEMP,"HH")>
	  <cfset finishmin = timeformat(FINISHDATE_TEMP,"MM")>
	  <cfelseif isDefined("attributes.class_id")>

<cfelse>
	  <cfset FINISHDATE_TEMP = "">
	  <cfset STARTDATE_TEMP = "">
	  <cfset startdate = "">
	  <cfset starthour = 0>
	  <cfset startmin = 0>
	  <cfset finishdate = "">
	  <cfset finishhour = 0>
	  <cfset finishmin = 0>
</cfif>
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border" align="center">
        <tr class="color-list" valign="middle">
          <td height="35">
            <table width="98%" align="center">
              <tr>
                <td valign="bottom" class="headbold"><cf_get_lang no='26.Kaynak Rezervasyonu'></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row" valign="middle">
          <td>
            <table align="center" width="100%" cellpadding="0" cellspacing="0" border="0" height="100%">
              <tr>
                <td colspan="2" valign="top">
                  <cfform name="assetp_reserve" method="post" action="#xfa.add#">
                    <table cellspacing="0" cellpadding="0" width="95%">
                      <tr>
                        <td valign="top">
						<br/>
							<cfif isdefined("attributes.res_control")>
								<input type="hidden" name="res_control" id="res_control" value="1">
							</cfif>
                          <input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#attributes.assetp_id#</cfoutput>">
                          <cfif isDefined("attributes.event_id")>
                            <input type="hidden" name="event_id" id="event_id" value="<cfoutput>#attributes.event_id#</cfoutput>">
                          </cfif>
                          <cfif isDefined("attributes.class_id")>
                            <input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
                          </cfif>
						  <cfif isDefined("attributes.project_id")>
                            <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
                          </cfif>
                          <table>
						  	<tr>
							  <td><cf_get_lang dictionary_id="54669.Rezervasyon Yapan"></td>
							  <td><input type="hidden" name="res_emp" id="res_emp" value="<cfoutput>#session.ep.userid#</cfoutput>">
								<input type="text" name="res_emp_name" id="res_emp_name" value="<cfoutput>#get_emp_info(session.ep.userid,1,0)#</cfoutput>" style="width:201px;">
								<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_id=assetp_reserve.res_emp&field_name=assetp_reserve.res_emp_name</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="Rezervasyon Yapan" align="absmiddle" border="0"></a></td>
							</tr>
                            <tr>
                              <td width="100"><cf_get_lang_main no='89.Başlangıç'></td>
                              <td colspan="3">
                                <cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik veri'>:<cf_get_lang_main no='641.Başlangıç tarihi'></cfsavecontent>
								<cfinput type="text" name="startdate" style="width:70px;" required="Yes" validate="#validate_style#" message="#message#" value="#dateformat(STARTDATE_TEMP,dateformat_style)#">
                               <cf_wrk_date_image date_field="startdate">
								<select name="event_start_clock" id="event_start_clock" style="width:54px;">
                                  <option value="00" selected><cf_get_lang_main no='79.Saat'></option>
                                  <cfloop from="1" to="23" index="i">
                                    <cfoutput>
                                      <option value="#i#" <cfif  timeformat(STARTDATE_TEMP,"HH") eq i>selected</cfif>>#i#</option>
                                    </cfoutput>
                                  </cfloop>
                                </select>
                                <select name="event_start_minute" id="event_start_minute" style="width:50px;">
                                  <option value="00" selected><cf_get_lang_main no='1415.dk'></option>
                                  <cfloop from="0" to="55" index="i" step="5">
                                    <cfoutput>
                                      <option value="#i#" <cfif timeformat(STARTDATE_TEMP,"MM") eq i>selected</cfif>>#i#</option>
                                    </cfoutput>
                                  </cfloop>
                                </select>
                              </td>
                            </tr>
                            <tr>
                              <td><cf_get_lang_main no='90.Bitiş'>
                              <td colspan="3">
                                <cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik veri'>:<cf_get_lang_main no='288.Bitiş Tarihi !'></cfsavecontent>
								<cfinput type="text" name="finishdate" style="width:70px;" required="Yes" validate="#validate_style#" message="#message#" value="#dateformat(FINISHDATE_TEMP,dateformat_style)#">
                                <cf_wrk_date_image date_field="finishdate">
                                <select name="event_finish_clock" id="event_finish_clock" style="width:54px;">
                                  <option value="00" selected><cf_get_lang_main no='79.Saat'></option>
                                  <cfloop from="1" to="23" index="i">
                                    <cfoutput>
                                      <option value="#i#" <cfif timeformat(FINISHDATE_TEMP,"HH") eq i>selected</cfif>>#i#</option>
                                    </cfoutput>
                                  </cfloop>
                                </select>
                                <select name="event_finish_minute" id="event_finish_minute" style="width:50px;">
                                  <option value="00" selected><cf_get_lang_main no='1415.dk'></option>
                                  <cfloop from="0" to="55" index="i" step="5">
                                    <cfoutput>
                                      <option value="#i#" <cfif timeformat(FINISHDATE_TEMP,"MM") eq i>selected</cfif>>#i#</option>
                                    </cfoutput>
                                  </cfloop>
                                </select>
                              </td>
                            </tr>
							<tr>
								<td valign="top">Açıklama</td>
								<td>
									<textarea name="detail" id="detail" style="height:50px;width:200px;"></textarea>
								</td>
							</tr>
							<tr>
							<td height="35" colspan="4" style="text-align:right;"> 
							<input type="button" value="<cf_get_lang no='7.Rezervasyonlar'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=asset.popup_list_assetp_reservations&assetp_id=#assetp_id#</cfoutput>','list');">
							<cf_workcube_buttons is_upd='0' add_function='form_check()'> 
							</td>
							</tr>
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
function form_check(){
	if ( (assetp_reserve.startdate.value != "") && (assetp_reserve.finishdate.value != "") )
		return time_check(assetp_reserve.startdate, assetp_reserve.event_start_clock, assetp_reserve.event_start_minute, assetp_reserve.finishdate,  assetp_reserve.event_finish_clock, assetp_reserve.event_finish_minute, "<cf_get_lang no='96.Başlangıç Tarihi Bitiş Tarihinden Önce Olmalıdır !'>");
}
function form_close(){
	 window.opener.reload();
}
</script>
