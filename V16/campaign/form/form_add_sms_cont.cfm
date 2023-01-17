<!--- TolgaS 20080905 kampanya için sms şablonu--->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('campaign',61)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">		
		<cfform name="add_sms_cont" method="post" action="#request.self#?fuseaction=campaign.emptypopup_add_sms_content#iif(isdefined("attributes.draggable"),DE('&draggable=1'),DE(''))#">
			<input type="hidden" name="camp_id" id="camp_id" value="<cfoutput>#camp_id#</cfoutput>">
			<cf_box_elements>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
					<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'>*</label>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<cfinput type="text" id="sms_head" name="sms_head" maxlength="100" required>
					</div>
				</div>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
					<cfoutput>#wrk_form_sms_template(sms_body:'',is_camp:1, is_table:0)#</cfoutput>
				</div>					
				<div class="form-group col col-12 col-md-12  col-sm-12 col-xs-12"><label><b><cf_get_lang_main no='13.uyarı'></b>:<cf_get_lang_main no='1198.sms içeriği'>-<cf_get_lang no ='294.en fazla 462 Karakter'>. <cf_get_lang no ='295.SMS Gönderim Esnasında karakter sayısını aşan SMSler gönderilmeyecektir'></label>(1043)</div>
			</cf_box_elements>					
		</cfform>	
		<cf_box_footer><cf_workcube_buttons type_format='1' add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_sms_cont')"),DE(""))#" is_upd='0'></cf_box_footer>
	</cf_box>
</div>

