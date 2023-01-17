<cfinclude template="../query/get_sms_cont.cfm">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('campaign',57)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="upd_sms_cont" method="post" action="#request.self#?fuseaction=campaign.emptypopup_upd_sms_content#iif(isdefined("attributes.draggable"),DE('&draggable=1'),DE(''))#">
			<input type="Hidden" name="sms_cont_id" id="sms_cont_id" value="<cfoutput>#sms_cont.sms_cont_id#</cfoutput>">
			<cf_box_elements>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
					<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'>*</label>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<cfinput type="text" id="sms_head" name="sms_head" maxlength="100" required value="#sms_cont.sms_head#">
					</div>
				</div>
				<div class="form-group col-12 col-md-12 col-sm-12 col-xs-12">
					<cfoutput>#wrk_form_sms_template(sms_body:'#sms_cont.sms_body#',is_camp:1, is_table:0)#</cfoutput>
				</div>
			</cf_box_elements>				
		</cfform>
		<cf_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='1' delete_page_url='#request.self#?fuseaction=campaign.emptypopup_del_sms_content&sms_cont_id=#attributes.sms_cont_id##iif(isdefined("attributes.draggable"),DE('&draggable=1'),DE(''))#' add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('upd_sms_cont')"),DE(""))#">
		</cf_box_footer>
	</cf_box>
</div>
