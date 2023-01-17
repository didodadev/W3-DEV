<cfinclude template="../query/get_private_lib_asset_reserve.cfm">
<div class="col col-12">
<cf_box title="#getLang('asset',12)# #getLang('main',52)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform name="lib_assetp_reserve" method="post" action="#request.self#?fuseaction=asset.add_lib_asset_rezerve&from_update=1">
<input type="hidden" name="reserve_id" id="reserve_id" value="<cfoutput>#attributes.reserve_id#</cfoutput>">
<input type="hidden" value="0" name="minute" id="minute">
<input type="hidden" name="status" id="status" value="<cfoutput>#attributes.status#</cfoutput>">
<cfif isDefined("attributes.fromlist")>
	<input type="hidden" name="fromlist" id="fromlist">
</cfif>
	<cf_box_elements>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47684.Kitap'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfoutput>#GET_LIB_ASSET_INFO.LIB_ASSET_NAME#</cfoutput>
				</div>
			</div>						  
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='58.Kitabi Alan'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfoutput>#GET_EMP_INFO(GET_LIB_ASSET_INFO.EMP_ID,0,1)#</cfoutput>
				</div>
			</div>
			<div class="form-group" id="item-startingdate">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<input type="text" name="startingdate" id="startingdate" value="<cfoutput>#dateformat(GET_LIB_ASSET_INFO.STARTDATE,dateformat_style)#</cfoutput>">
							<span class="input-group-addon">
								<cf_wrk_date_image date_field="startingdate">
							</span>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<cf_wrkTimeFormat name="start_clock" value="#TIMEFORMAT(GET_LIB_ASSET_INFO.STARTDATE,"HH")#">
					</div>
				</div>
			</div>
			<div class="form-group" id="item-finishingdate">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message3"><cf_get_lang_main no='59.Eksik veri'>:<cf_get_lang_main no='288.Bitiş Tarihi !'></cfsavecontent>
							<cfinput type="text" name="finishingdate" style="width:80px;" required="Yes" validate="#validate_style#" message="#message3#" value="#dateformat(GET_LIB_ASSET_INFO.FINISHDATE,dateformat_style)#">
							<span class="input-group-addon">
								<cf_wrk_date_image date_field="finishingdate">
							</span>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<cf_wrkTimeFormat name="finish_clock" value="#TIMEFORMAT(GET_LIB_ASSET_INFO.FINISHDATE,"HH")#">
					</div>
				</div>
			</div>
		</div>
	</cf_box_elements>
	<cf_box_footer>
		<cfif isDefined("attributes.fromlist")>
			<cfset upd_alert = 'Şu An Kitabın Onu Rezerve Eden Kişi Tarafından Alındığını Onaylıyorsunuz.\n\nEmin Misiniz?'>
		<cfelse>
			<cfset upd_alert = ''>	
		</cfif>
		<cf_workcube_buttons is_upd='1' type_format="1" delete_page_url='#request.self#?fuseaction=asset.emptypopup_del_lib_asset_reserve&reserve_id=#attributes.reserve_id#&lib_asset_id=#attributes.lib_asset_id#' insert_alert = '#upd_alert#' add_function='form_check()'> 
	</cf_box_footer>					
</cfform>
</div>
</cf_box>
<script type="text/javascript">
function form_check()
{
	if ( (lib_assetp_reserve.startdate.value != "") && (lib_assetp_reserve.finishdate.value != "") )
		return time_check(lib_assetp_reserve.startdate, lib_assetp_reserve.start_clock, lib_assetp_reserve.minute, lib_assetp_reserve.finishdate, lib_assetp_reserve.finish_clock, lib_assetp_reserve.minute,"<cf_get_lang no='96.Baslangiç Tarihi Bitis Tarihinden Önce Olmalidir !'>");
}
function form_close()
{
	 window.opener.reload();
}
</script>
