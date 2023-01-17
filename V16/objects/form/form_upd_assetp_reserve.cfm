<cf_xml_page_edit fuseact="objects.form_assetp_reserve">
<cfquery name="GET_ASSETP_RESERVE" datasource="#dsn#">
	SELECT 
		ASSET_P.ASSETP_ID,
		ASSET_P_RESERVE.ASSETP_ID,
		ASSET_P_RESERVE.ASSETP_RESID,
		ASSET_P_RESERVE.EVENT_ID,
		ASSET_P_RESERVE.STARTDATE,
		ASSET_P_RESERVE.FINISHDATE,
		ASSET_P_RESERVE.UPDATE_EMP,
		ASSET_P_RESERVE.STAGE_ID,
        ASSET_P_RESERVE.MULTIPLE
	FROM 
		ASSET_P,
		ASSET_P_RESERVE
	WHERE
		<cfif isDefined("attributes.ASSETP_RESID")>
		ASSET_P_RESERVE.ASSETP_RESID = #attributes.ASSETP_RESID# AND
		</cfif>
		ASSET_P.ASSETP_ID = #attributes.ASSETP_ID# AND
		ASSET_P.ASSETP_ID = ASSET_P_RESERVE.ASSETP_ID
</cfquery>

<cfif len(get_assetp_reserve.startdate)>
	<cfset startdate_temp = date_add('h',session.ep.time_zone,get_assetp_reserve.startdate)>
	<cfset startdate = dateformat(startdate_temp,dateformat_style)>
	<cfset starthour = timeformat(startdate_temp,"HH")>
	<cfset startmin = timeformat(startdate_temp,"MM")>
<cfelse>
	<cfset startdate_temp = ''>
	<cfset startdate = ''>
	<cfset starthour = ''>
	<cfset startmin = ''>
</cfif>
<cfif len(get_assetp_reserve.finishdate)>
	<cfset finishdate_temp = date_add('h',session.ep.time_zone,get_assetp_reserve.finishdate)>
	<cfset finishdate = dateformat(finishdate_temp,dateformat_style)>
	<cfset finishhour = timeformat(finishdate_temp,"HH")>
	<cfset finishmin = timeformat(finishdate_temp,"MM")>
<cfelse>
	<cfset finishdate_temp = ''>
	<cfset finishdate = "">
	<cfset finishhour = "">
	<cfset finishmin = "">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Kaynak Rezervasyonu','33513')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="upd_assetp_reserve" method="post" action="#request.self#?fuseaction=objects.emptypopup_upd_assetp_reserve&draggable=#iif(isdefined("attributes.draggable"),1,0)#">
			<input type="hidden" name="assetp_resid" id="assetp_resid" value="<cfoutput>#attributes.assetp_resid#</cfoutput>">
			<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#get_assetp_reserve.assetp_id#</cfoutput>">
			<cf_box_elements vertical="1">
				<div class="col col-12 col-sm-12 col-xs-12 col-md-12">
					<div class="form-group">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="multiple" id="multiple" disabled="disabled" <cfif get_assetp_reserve.multiple eq 1>checked</cfif> value="1"><cf_get_lang dictionary_id='56706.Çoklu Giriş Çıkış'></label>
						
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cf_workcube_process is_upd='0' select_value='#GET_ASSETP_RESERVE.STAGE_ID#' process_cat_width='100' is_detail='1'>
						</div>
					</div>
					<cfif x_is_show_startdate>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'></label>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz !'></cfsavecontent>
									<cfinput type="text" name="startdate" style="width:80px;" required="Yes" validate="#validate_style#" message="#message#" value="#startdate#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
								</div>
							</div>		
							<div class="col col-2 col-md-2 col-sm-2 col-xs-12">	
								<cf_wrkTimeFormat name="event_start_clock" value="#starthour#">
							</div>
							<div class="col col-2 col-md-2 col-sm-2 col-xs-12">
								<select name="event_start_minute" id="event_start_minute" style="width:50px;">
									<option value="00" selected><cf_get_lang dictionary_id='58827.dk'></option>
									<cfloop from="05" to="55" index="i" step="5">
										<cfoutput>
											<option value="#i#" <cfif startmin eq i>selected</cfif>>#i#</option>
										</cfoutput>
									</cfloop>
								</select>
							</div>
						</div>
					</cfif>
					<cfif x_is_show_finishdate>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'></label>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz !'></cfsavecontent>
									<cfinput type="text" name="finishdate" style="width:80px;" required="Yes" validate="#validate_style#" message="#message#" value="#finishdate#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
								</div>
							</div>
							<div class="col col-2 col-md-2 col-sm-2 col-xs-12">	
								<cf_wrkTimeFormat name="event_finish_clock" value="#finishhour#">
							</div>
							<div class="col col-2 col-md-2 col-sm-2 col-xs-12">	
								<select name="event_finish_minute" id="event_finish_minute" style="width:50px;">
									<option value="00" selected><cf_get_lang dictionary_id='58827.dk'></option>
									<cfloop from="05" to="55" index="i" step="5">
										<cfoutput>
											<option value="#i#" <cfif finishmin eq i>selected</cfif>>#i#</option>
										</cfoutput>
									</cfloop>
								</select>
							</div>
						</div>
					</cfif>
				</div>	
			</cf_box_elements>
			<cf_box_footer>
				<a class="ui-wrk-btn ui-wrk-btn-extra" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=assetcare.popup_list_assetp_reservations&assetp_id=#get_assetp_reserve.assetp_id#</cfoutput>');"><cf_get_lang dictionary_id='33512.Rezervasyonlar'></a>
				<cf_workcube_buttons type_format="1" is_upd='1' add_function='form_check()' delete_page_url='#request.self#?fuseaction=objects.del_assetp_reserve&assetp_resid=#attributes.assetp_resid#'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function form_check()
{
	<cfif x_is_show_finishdate eq 1 and x_is_show_startdate eq 1>
		if ( (upd_assetp_reserve.startdate.value != "") && (upd_assetp_reserve.finishdate.value != "") )
			time_check(upd_assetp_reserve.startdate, upd_assetp_reserve.event_start_clock, upd_assetp_reserve.event_start_minute, upd_assetp_reserve.finishdate,  upd_assetp_reserve.event_finish_clock, upd_assetp_reserve.event_finish_minute, "<cf_get_lang dictionary_id='33514.Başlangıç Tarihi Bitiş Tarihinden Önce Olmalıdır !'>");
	</cfif>
	return process_cat_control();
}
</script>
