<cfinclude template="../query/get_event_cats.cfm">
<cfinclude template="../query/get_event.cfm">

<cfquery datasource="#DSN3#" name="GET_OPPORTUNITY">
	SELECT 
		O.OPP_HEAD, 
		O.OPP_ID
	FROM
		OPPORTUNITIES O,
		#dsn_alias#.EVENTS_RELATED E
	WHERE
		O.OPP_ID = E.ACTION_ID AND
		E.ACTION_SECTION = 'OPPORTUNITY_ID' AND
		E.EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#"> AND
		E.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#">
</cfquery>

<cfparam name="attributes.view_to_all" default="">
<cfscript>
	if(len(get_event.startdate))
		startdate = get_event.startdate;
	else
		startdate = "";
	if(len(get_event.finishdate))
		finishdate = get_event.finishdate;
	else
		finishdate = "";
</cfscript>
<cfset startdate = date_add('h', session.pda.time_zone, get_event.startdate)>
<cfset finishdate = date_add('h', session.pda.time_zone, get_event.finishdate)>
<cfinclude template="../display/agenda_tr.cfm">
<cfform name="add_event" method="post" action="#request.self#?fuseaction=pda.emptypopup_upd_event">
	<table cellpadding="0" cellspacing="0" align="center" style="width:98%">
		<tr style="height:35px;">
			<td class="headbold">Olay Güncelle</td>
		</tr>
	</table>
	<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%">	
		<tr>
			<td class="color-row" style="width:65%">
				<table align="center" style="width:99%">	
					<input type="hidden" name="event_id" id="event_id" value="<cfoutput>#url.event_id#</cfoutput>">
					<input type="hidden" name="link_id" id="link_id" value="<cfoutput>#get_event.link_id#</cfoutput>">
					<cfif get_opportunity.recordcount>
						<tr style="height:22px;">
							<td style="width:30%"><cf_get_lang_main no='200.Firsat'></td>
							<td><cfoutput query="get_opportunity">#get_opportunity.opp_head#</cfoutput></td>
						</tr>
					</cfif>
					<tr>
						<td class="infotag" style="width:30%"><cf_get_lang_main no="1408.Başlık">*</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="1408.Başlık"></cfsavecontent>
							<cfinput type="text" name="event_head" id="event_head" value="#get_event.event_head#" style="width:193px;" required="yes" message="#message#">
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no="74.Kategori">*</td>
						<td>
							<select name="eventcat_id" id="eventcat_id" style="width:200px;">
								<option value="0" selected><cf_get_lang_main no="322.Seçiniz"></option>
								<cfoutput query="get_event_cats">
									<option value="#eventcat_id#" <cfif eventcat_id eq get_event.eventcat_id>selected</cfif>>#eventcat#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no="1055.Başlama"></td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no="243.Başlama Tarihi"></cfsavecontent>
							<cfinput type="text" name="startdate" id="startdate" value="#dateformat(startdate,'dd/mm/yyyy')#" maxlength="10" required="yes" validate="eurodate" message="#message#" style="width:80px; vertical-align:top">
							<cf_wrk_date_image date_field="startdate">
							<select name="event_start_clock" id="event_start_clock" style="width:42px;">
								<option value="0" selected><cf_get_lang_main no="79.Saat"></option>
								<cfloop from="7" to="30" index="i">
									<cfset saat=i mod 24>
									<option value="<cfoutput>#saat#</cfoutput>" <cfif timeformat(startdate,"HH") eq saat>selected</cfif> ><cfoutput>#saat#</cfoutput></option>
								</cfloop>
							</select>
							<select name="event_start_minute" id="event_start_minute" style="width:42px;">
								<option value="00" <cfif timeformat(startdate,"MM") eq 00>selected</cfif>>00</option>
								<option value="05" <cfif timeformat(startdate,"MM") eq 05>selected</cfif>>05</option>
								<option value="10" <cfif timeformat(startdate,"MM") eq 10>selected</cfif>>10</option>
								<option value="15" <cfif timeformat(startdate,"MM") eq 15>selected</cfif>>15</option>
								<option value="20" <cfif timeformat(startdate,"MM") eq 20>selected</cfif>>20</option>
								<option value="25" <cfif timeformat(startdate,"MM") eq 25>selected</cfif>>25</option>
								<option value="30" <cfif timeformat(startdate,"MM") eq 30>selected</cfif>>30</option>
								<option value="35" <cfif timeformat(startdate,"MM") eq 35>selected</cfif>>35</option>
								<option value="40" <cfif timeformat(startdate,"MM") eq 40>selected</cfif>>40</option>
								<option value="45" <cfif timeformat(startdate,"MM") eq 45>selected</cfif>>45</option>
								<option value="50" <cfif timeformat(startdate,"MM") eq 50>selected</cfif>>50</option>
								<option value="55" <cfif timeformat(startdate,"MM") eq 55>selected</cfif>>55</option>
							</select>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang_main no="90.Bitiş"></td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no="288.Bitiş Tarihi"></cfsavecontent>
							<cfinput type="text" name="finishdate" id="finishdate" value="#dateformat(finishdate,'dd/mm/yyyy')#" maxlength="10" required="yes" message="#message#" validate="eurodate" style="width:80px; vertical-align:top">
							<cf_wrk_date_image date_field="finishdate">
							<select name="event_finish_clock" id="event_finish_clock" style="width:42px;">
								<option value="0" selected><cf_get_lang_main no="79.Saat"></option>
								<cfloop from="7" to="30" index="i">
									<cfset saat=i mod 24>
									<option value="<cfoutput>#saat#</cfoutput>" <cfif timeformat(finishdate,"HH") eq saat>selected</cfif> ><cfoutput>#saat#</cfoutput></option>
								</cfloop>
							</select>
							<select name="event_finish_minute" id="event_finish_minute" style="width:42px;">
								<option value="00" <cfif timeformat(finishdate,"MM") eq 00>selected</cfif>>00</option>
								<option value="05" <cfif timeformat(finishdate,"MM") eq 05>selected</cfif>>05</option>
								<option value="10" <cfif timeformat(finishdate,"MM") eq 10>selected</cfif>>10</option>
								<option value="15" <cfif timeformat(finishdate,"MM") eq 15>selected</cfif>>15</option>
								<option value="20" <cfif timeformat(finishdate,"MM") eq 20>selected</cfif>>20</option>
								<option value="25" <cfif timeformat(finishdate,"MM") eq 25>selected</cfif>>25</option>
								<option value="30" <cfif timeformat(finishdate,"MM") eq 30>selected</cfif>>30</option>
								<option value="35" <cfif timeformat(finishdate,"MM") eq 35>selected</cfif>>35</option>
								<option value="40" <cfif timeformat(finishdate,"MM") eq 40>selected</cfif>>40</option>
								<option value="45" <cfif timeformat(finishdate,"MM") eq 45>selected</cfif>>45</option>
								<option value="50" <cfif timeformat(finishdate,"MM") eq 50>selected</cfif>>50</option>
								<option value="55" <cfif timeformat(finishdate,"MM") eq 55>selected</cfif>>55</option>
							</select>
						</td>
					</tr>
					<tr>
						<td style="vertical-align:top"><cf_get_lang_main no="217.Açıklama"></td>
						<td><textarea name="event_detail" id="event_detail" style="width:194px;height:60px;"><cfoutput>#get_event.event_detail#</cfoutput></textarea></td>
					</tr>
					<tr>
						<td colspan="2"><input type="checkbox" name="view_to_all" id="view_to_all" <cfif get_event.view_to_all eq 1>checked</cfif> value="1" style="height:15px;">&nbsp;&nbsp;Bu olayı herkes görsün</td>
					</tr>
					<tr>
						<td colspan="2" align="right"><cf_workcube_buttons is_upd='1' add_function='check()' delete_page_url='#request.self#?fuseaction=pda.emptypopup_del_event&event_id=#url.event_id#&link_id=#get_event.link_id#'> </td>
					</tr>
					<tr>
						<td colspan="2">
							<cf_get_lang_main no="71.Kayıt">:
							<cfif len(get_event.record_emp)>
								<cfoutput>#get_emp_info(get_event.record_emp,0,0)#</cfoutput>
							<cfelseif len(get_event.record_par)>
								<cfoutput>#get_par_info(get_event.record_par,0,0,0)#</cfoutput>
							</cfif> - <cfoutput>#dateformat(date_add('h',session.pda.time_zone,get_event.record_date),'dd/mm/yyyy')# - #timeformat(date_add('h',session.pda.time_zone,get_event.record_date),'HH:MM')#</cfoutput> 
						</td>
					</tr>
					<cfif len(get_event.update_emp)>
						<tr>
							<td colspan="2">
								<cf_get_lang_main no="291.Güncelleme">:
								<cfoutput>#get_emp_info(get_event.update_emp,0,0)#</cfoutput>
								- <cfoutput>#dateformat(date_add('h',session.pda.time_zone,get_event.update_date),'dd/mm/yyyy')# - #timeformat(date_add('h',session.pda.time_zone,get_event.update_date),'HH:MM')#</cfoutput> 
							</td>
						</tr>
					</cfif>
				</table>
			</td>
			<td class="color-row" style="vertical-align:top; width:35%">
				<cfsavecontent variable="txt_1">Bilgi Verilecekler</cfsavecontent>
				<cfsavecontent variable="txt_2"><cf_get_lang_main no='178.Katılımcılar'></cfsavecontent>
                <cfoutput></cfoutput>
				<cfif isdefined("attributes.partner_id")>
					<cf_workcube_to_cc 
						is_update="1" 
						to_dsp_name="#txt_2#" 
						cc_dsp_name="#txt_1#" 
						form_name="add_event" 
						str_list_param="1,7,8" 
						action_dsn="#DSN#"
						str_action_names="PARTNER_ID AS TO_PAR"
						action_table="COMPANY_PARTNER"
						action_id_name="PARTNER_ID"
						action_id="#attributes.partner_id#"
						data_type="1"
						str_alias_names="">
				<cfelseif isdefined('attributes.consumer_id')>
					<cf_workcube_to_cc 
						is_update="1" 
						to_dsp_name="#txt_2#" 
						cc_dsp_name="#txt_1#" 
						form_name="add_event" 
						str_list_param="1,7,8" 
						action_dsn="#DSN#"
						str_action_names="CONSUMER_ID AS TO_CON"
						action_table="CONSUMER"
						action_id_name="CONSUMER_ID"
						action_id="#attributes.consumer_id#"
						data_type="1"
						str_alias_names="">
				<cfelseif isdefined("attributes.EVENT_ID") and len(attributes.EVENT_ID)>
					<cf_workcube_to_cc 
						is_update="1" 
						to_dsp_name="#txt_2#" 
						cc_dsp_name="#txt_1#" 
						form_name="upd_event" 
						str_list_param="1,7,8" 
						action_dsn="#DSN#"
						str_action_names="EVENT_TO_POS AS TO_EMP,EVENT_TO_PAR AS TO_PAR,EVENT_TO_CON TO_CON,EVENT_TO_GRP AS TO_GRP,EVENT_TO_WRKGROUP AS TO_WRKGROUP ,EVENT_CC_POS AS CC_EMP,EVENT_CC_PAR AS CC_PAR,EVENT_CC_CON AS CC_CON,EVENT_CC_GRP AS CC_GRP,EVENT_CC_WRKGROUP AS CC_WRKGROUP"
						action_table="EVENT"
						action_id_name="EVENT_ID"
						action_id="#attributes.EVENT_ID#"
						data_type="1"
						str_alias_names="">
				<cfelse>
					<cf_workcube_to_cc 
						is_update="0" 
						to_dsp_name="#txt_2#" 
						cc_dsp_name="#txt_1#" 
						form_name="add_event" 
						str_list_param="1,7,8" 
						data_type="1"> 		
				</cfif> 
			</td>
		</tr>
	</table>
	<br/>
</cfform>

<script type="text/javascript">
	function check()
	{
		if (document.getElementById('eventcat_id').value == 0)
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='26.Olay Kategorisi'>");
			return false;
		}
			
		if((document.getElementById('startdate').value != "") && (document.getElementById('finishdate').value != ""))
			return time_check(add_event.startdate, add_event.event_start_clock, add_event.event_start_minute, add_event.finishdate, add_event.event_finish_clock, add_event.event_finish_minute, "Olay Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır !");
	
		if((document.getElementById('warning_start').value != "") && (document.getElementById('startdate').value != ""))
			return date_check(add_event.warning_start,add_event.startdate,"<cf_get_lang no='39.Uyarı Tarihi Olay Başlama Tarihinden Önce Olmalıdır'>!");
		return true;
	}
</script>
