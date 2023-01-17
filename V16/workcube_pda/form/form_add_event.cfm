<cfinclude template="../query/get_event_cats.cfm">
<cfif isdefined("attributes.action_id") and len(attributes.action_id) and isdefined("attributes.action_section") and len(attributes.action_section) and attributes.action_section is 'OPPORTUNITY_ID'>
	<cfquery name="GET_OPPORTUNITY" datasource="#DSN3#">
		SELECT 
			O.OPP_HEAD, 
			O.OPP_ID,
			C.FULLNAME
		FROM
			OPPORTUNITIES O,
			#dsn_alias#.COMPANY C
		WHERE
			O.COMPANY_ID = C.COMPANY_ID AND
			O.OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
	</cfquery>
</cfif>
<cfif isDefined("attributes.date")>
  <cf_date tarih="attributes.date">
</cfif>
<cfset url_string="">
<cfif isdefined("attributes.action_id") and len(attributes.action_id)>
	<cfset url_string="#url_string#&action_id=#attributes.action_id#">
</cfif>
<cfif isdefined("attributes.action_section") and len(attributes.action_section)>
	<cfset url_string="#url_string#&action_section=#attributes.action_section#">
</cfif>
<cfinclude template="../display/agenda_tr.cfm">
<cfform name="add_event" method="post" action="#request.self#?fuseaction=pda.add_event#url_string#">
	<table cellpadding="0" cellspacing="0" align="center" style="width:98%">
		<tr style="height:35px;">
			<td class="headbold">Olay Ekle</td>
		</tr>
	</table>
	<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%">	
		<tr>
			<td class="color-row">
				<table style="width:99%" align="center">
					<tr>
						<td class="infotag" style="width:30%"><cf_get_lang_main no="1408.Başlık">*</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="1408.Başlık"></cfsavecontent>
							<cfinput type="text" name="event_head" id="event_head" value="" style="width:193px;" required="yes" message="#message#">
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no="74.Kategori">*</td>
						<td>
							<select name="eventcat_id" id="eventcat_id" style="width:200px;">
								<option value="0" selected><cf_get_lang_main no="322.Seçiniz"></option>
								<cfoutput query="get_event_cats">
									<option value="#eventcat_id#">#eventcat#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no="1055.Başlama"></td>
						<td>
							<cfif isDefined("attributes.date")>
								<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='243.başlama tarihi'></cfsavecontent>
								<cfinput type="text" name="startdate" id="startdate" maxlength="10" required="Yes" validate="eurodate" message="#message#" value="#dateformat(attributes.date,'dd/mm/yyyy')#" style="width:80px; vertical-align:top">
							<cfelse>
								<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='243.başlama tarihi'></cfsavecontent>
								<cfinput type="text" name="startdate" id="startdate" maxlength="10" required="Yes" validate="eurodate" message="#message#" value="#dateformat(now(),'dd/mm/yyyy')#" style="width:80px; vertical-align:top">
							</cfif>
							<cf_wrk_date_image date_field="startdate">
							<select name="event_start_clock" id="event_start_clock" style="width:42px;">
								<option value="0" selected></option>
								<cfloop from="7" to="30" index="i">
									<cfset saat=i mod 24>
									<option value="<cfoutput>#saat#" <cfif isDefined("attributes.hour") and attributes.hour eq saat>selected</cfif>>#saat#</cfoutput></option>
								</cfloop>
							</select>
							<select name="event_start_minute" id="event_start_minute" style="width:42px;">
								<option value="00" selected>00</option>
								<option value="05">05</option>
								<option value="10">10</option>
								<option value="15">15</option>
								<option value="20">20</option>
								<option value="25">25</option>
								<option value="30">30</option>
								<option value="35">35</option>
								<option value="40">40</option>
								<option value="45">45</option>
								<option value="50">50</option>
								<option value="55">55</option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no="90.Bitiş"></td>
						<td>
							<cfif isDefined("attributes.date")>
								<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no="288.Bitiş Tarihi"></cfsavecontent>
								<cfinput type="text" name="finishdate" id="finishdate" maxlength="10" required="yes" message="#message#" validate="eurodate" value="#dateformat(attributes.date,'dd/mm/yyyy')#" style="width:80px; vertical-align:top">
							<cfelse>
								<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no="288.Bitiş Tarihi"></cfsavecontent>
								<cfinput type="text" name="finishdate" id="finishdate" maxlength="10" required="yes" message="#message#" validate="eurodate" value="#dateformat(NOW(),'DD/MM/YYYY')#" style="width:80px; vertical-align:top">
							</cfif>
							<cf_wrk_date_image date_field="finishdate">
							<select name="event_finish_clock" id="event_finish_clock" style="width:42px;">
								<option value="0" selected></option>
								<cfloop from="7" to="30" index="i">
									<cfset saat=i mod 24>
									<option value="<cfoutput>#saat#</cfoutput>" <cfif isDefined("attributes.hour")><cfif attributes.hour eq saat>selected</cfif></cfif>><cfoutput>#saat#</cfoutput></option>
								</cfloop>
							</select>
							<select name="event_finish_minute" id="event_finish_minute" style="width:42px;">
								<option value="00" selected>00</option>
								<option value="05">05</option>
								<option value="10">10</option>
								<option value="15">15</option>
								<option value="20">20</option>
								<option value="25">25</option>
								<option value="30" <cfif isDefined("attributes.hour")>selected</cfif>>30</option>
								<option value="35">35</option>
								<option value="40">40</option>
								<option value="45">45</option>
								<option value="50">50</option>
								<option value="55">55</option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="infotag" style="vertical-align:top"><cf_get_lang_main no="217.Açıklama"></td>
						<td><textarea name="event_detail" id="event_detail" class="input" style="width:194px;height:60px;"></textarea></td>
					</tr>
					<tr>
						<td colspan="2" class="infotag">
							<input type="checkbox" name="view_to_all" id="view_to_all" value="1" style="height:15px;">&nbsp;&nbsp;<cf_get_lang no="21.Bu olayı herkes görsün">
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td><cf_workcube_buttons is_upd='0' add_function='check()'> </td>
					</tr>
				</table>
			</td>
            <td class="color-row" style="vertical-align:top; width:35%">
				<cfsavecontent variable="txt_1"><cf_get_lang_main no="1361.Bilgi Verilecekler"></cfsavecontent>
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
	
		if((document.getElementById('startdate').value != "") && (document.getElementById('finishdate').value != ""))
			return date_check(add_event.warning_start,add_event.startdate,"<cf_get_lang no='39.Uyarı Tarihi Olay Başlama Tarihinden Önce Olmalıdır'>!");
		return true;
	}
</script>
