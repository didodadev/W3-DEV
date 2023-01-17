<cfif isDefined("attributes.event_id")>
  <cfinclude template="../query/get_event_dates.cfm">
  <cfset STARTDATE_TEMP = date_add('h',session.ep.time_zone,EVENT_DATES.startdate)>
  <cfset FINISHDATE_TEMP = date_add('h',session.ep.time_zone,EVENT_DATES.finishdate)>
  <cfset startdate = dateformat(STARTDATE_TEMP,dateformat_style)>
  <cfset starthour = timeformat(STARTDATE_TEMP,"HH")>
  <cfset startmin = timeformat(STARTDATE_TEMP,"MM")>
  <cfset finishdate = dateformat(FINISHDATE_TEMP,dateformat_style)>
  <cfset finishhour = timeformat(FINISHDATE_TEMP,"HH")>
  <cfset finishmin = timeformat(FINISHDATE_TEMP,"MM")>
<cfelseif isDefined("attributes.project_id")>
  <cfinclude template="../query/get_event_dates.cfm">
  <cfset STARTDATE_TEMP = date_add('h',session.ep.time_zone,attributes.STARTDATE_TEMP)>
  <cfset FINISHDATE_TEMP = date_add('h',session.ep.time_zone,attributes.FINISHDATE_TEMP)>
  <cfset startdate = dateformat(STARTDATE_TEMP,dateformat_style)>
  <cfset starthour = timeformat(STARTDATE_TEMP,"HH")>
  <cfset startmin = timeformat(STARTDATE_TEMP,"MM")>
  <cfset finishdate = dateformat(FINISHDATE_TEMP,dateformat_style)>
  <cfset finishhour = timeformat(FINISHDATE_TEMP,"HH")>
  <cfset finishmin = timeformat(FINISHDATE_TEMP,"MM")>
<cfelseif isDefined("attributes.class_id")>
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
	  <cfset STARTDATE_TEMP = "">
	  <cfset FINISHDATE_TEMP = "">
	  <cfset startdate = "">
	  <cfset starthour = 0>
	  <cfset startmin = 0>
	  <cfset finishdate = "">
	  <cfset finishhour = 0>
	  <cfset finishmin = 0>
  </cfif>
<cfelse>
  <cfset STARTDATE_TEMP = "">
  <cfset FINISHDATE_TEMP = "">
  <cfset startdate = "">
  <cfset starthour = 0>
  <cfset startmin = 0>
  <cfset finishdate = "">
  <cfset finishhour = 0>
  <cfset finishmin = 0>
</cfif>
<cfform name="assetp_reserve" method="post" action="#request.self#?fuseaction=assetcare.add_assetp_reserve">
	<cf_popup_box title="#getLang('assetcare',28)#">
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
				<td width="100"><cf_get_lang_main no='89.Başlangıç'></td>
				<td colspan="3" align="center">
					<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='641.Başlangıç Tarihi !'></cfsavecontent>
					<cfinput type="text" name="startdate" style="width:80px;" required="Yes" validate="#validate_style#" message="#message#" value="#startdate#">
					<cf_wrk_date_image date_field="startdate">
					<cf_wrkTimeFormat name="event_start_clock" value="">
					<select name="event_start_minute" id="event_start_minute" style="width:50px;">
						<option value="00" selected><cf_get_lang_main no='1415.dk'></option>
						<cfloop from="5" to="55" index="i" step="5">
							<cfoutput>
								<option value="#i#" <cfif startmin eq i>selected</cfif>>#i#</option>
							</cfoutput>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='90.Bitiş'>
				<td colspan="3" align="center">
					<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='288.Bitiş Tarihi !'></cfsavecontent>
					<cfinput type="text" name="finishdate" style="width:80px;" required="Yes" validate="#validate_style#" message="#message#" value="#finishdate#">
					<cf_wrk_date_image date_field="finishdate">
					<cf_wrkTimeFormat name="event_finish_clock" value="">
					<select name="event_finish_minute" id="event_finish_minute" style="width:50px;">
					<option value="00" selected><cf_get_lang_main no='1415.dk'></option>
						<cfloop from="5" to="55" index="i" step="5">
							<cfoutput>
								<option value="#i#" <cfif finishmin eq i>selected</cfif>>#i#</option>
							</cfoutput>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
				<td colspan="3">
					<textarea name="detail" id="detail" style="width:100%;height:52px;"></textarea>
				</td>
			</tr>
		</table>
		<cf_popup_box_footer>
			<table style="text-align:right;">
				<tr>
					<td>
						<input type="button" value="<cf_get_lang no='9.Rezervasyonlar'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=assetcare.popup_list_assetp_reservations&assetp_id=#assetp_id#</cfoutput>','list');">
						<cf_workcube_buttons is_upd='0' add_function='form_check()'>
					</td>
				</tr>
			</table>
		</cf_popup_box_footer>
	</cf_popup_box>
</cfform>
<script type="text/javascript">
	function form_check()
	{
		if ( (assetp_reserve.startdate.value != "") && (assetp_reserve.finishdate.value != "") )
			return time_check(assetp_reserve.startdate, assetp_reserve.event_start_clock, assetp_reserve.event_start_minute, assetp_reserve.finishdate,  assetp_reserve.event_finish_clock, assetp_reserve.event_finish_minute, "<cf_get_lang no='52.Başlangıç Tarihi Bitiş Tarihinden Önce Olmalıdır !'>");
	}
	function form_close()
	{
		 window.opener.reload();
	}
</script>

