<cfinclude template="../query/get_lib_asset_name.cfm">
<cfset extra = "">
<cfif isDefined("attributes.status") and (attributes.status eq 2)>
	<cfset extra = "&status=2">
</cfif>                  

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Kütüphane Rezervasyonu','47683')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" info_title_3="#getLang('','Rezervasyonlar','49231')#" info_href="javascript:openBoxDraggable('#request.self#?fuseaction=asset.popup_list_lib_asset_reservations&lib_asset_id=#attributes.lib_asset_id#&listonly');">
		<cfform name="lib_assetp_reserve" method="post" action="#request.self#?fuseaction=asset.add_lib_asset_rezerve#extra#">
			<input type="hidden" name="lib_asset_id" id="lib_asset_id" value="<cfoutput>#url.lib_asset_id#</cfoutput>">
			<input type="hidden" name="minute" id="minute" value="0">
			<input type="hidden" name="draggable" id="draggable" value="#iif(isdefined("attributes.draggable"),1,0)#">
			<cfif isDefined("attributes.status") and (attributes.status eq 2)>
				<input type="hidden" name="status" id="status" value="2">
			</cfif>
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-lib_asset_name">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47684.Kitap'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfoutput>#get_lib_asset_name.lib_asset_name#</cfoutput>
						</div>
					</div>						  
					<div class="form-group" id="item-member_type">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47783.Okuyucu'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="member_type" id="member_type" value="">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='47783.Okuyucu'></cfsavecontent>
								<cfinput type="text" name="member" maxlength="200" required="yes" message="#message#">
								<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_type=lib_assetp_reserve.member_type&field_emp_id2=lib_assetp_reserve.member_id&field_name=lib_assetp_reserve.member&select_list=1');"></span>
								<input type="hidden" name="member_id" id="member_id" value="">
							</div>
						</div>
					</div>
					<div class="form-group" id="item-startdate">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfif isDefined("attributes.status") and (attributes.status eq 2)>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input type="text" name="startdate" id="startdate" value="<cfoutput>#dateformat(attributes.startdate,dateformat_style)#</cfoutput>">
										<span class="input-group-addon">
											<cf_wrk_date_image date_field="startdate">
										</span>
									</div>
								</div>
							<cfelse>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
										<cfinput type="text" name="startdate"  required="Yes" validate="#validate_style#" message="#message#" value="">
										<span class="input-group-addon">
											<cf_wrk_date_image date_field="startdate">
										</span>
									</div>
								</div>
							</cfif>	    
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<cf_wrkTimeFormat name="start_clock" value="#isDefined("attributes.status") and isDefined("i") and (attributes.status eq 2) and (timeformat(startdate,"HH") eq i)#">
							</div>
						</div>
					</div>
					<div class="form-group" id="item-finishdate">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message3"><cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
									<cfinput type="text" name="finishdate" required="Yes" validate="#validate_style#" message="#message3#" value="">
									<span class="input-group-addon">
										<cf_wrk_date_image date_field="finishdate">
									</span>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<cf_wrkTimeFormat name="finish_clock" value="#isDefined("attributes.status") and isDefined("i") and (attributes.status eq 2) and (timeformat(finishdate,"HH") eq i)#">
							</div>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<input type="button" class="ui-wrk-btn ui-wrk-btn-extra" value="<cf_get_lang dictionary_id='47678.Rezervasyonlar'>" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=asset.popup_list_lib_asset_reservations&lib_asset_id=#attributes.lib_asset_id#&listonly</cfoutput>');">
				<cf_workcube_buttons is_upd='0' type_format="1" add_function='form_check()'> 
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function form_check()
	{
		if ( (lib_assetp_reserve.startdate.value != "") && (lib_assetp_reserve.finishdate.value != "") )
			return time_check(lib_assetp_reserve.startdate, lib_assetp_reserve.start_clock, lib_assetp_reserve.minute, lib_assetp_reserve.finishdate, lib_assetp_reserve.finish_clock, lib_assetp_reserve.minute,"<cf_get_lang no='96.Başlangıç Tarihi Bitiş Tarihinden Önce Olmalıdır !'>");
	}
	
</script>
