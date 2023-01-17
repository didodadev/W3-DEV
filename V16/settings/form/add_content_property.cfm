<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='42243.İçerik ve Belge Tipleri'></cfsavecontent>
	<cf_box title="#message#" add_href="#request.self#?fuseaction=settings.form_add_content_property" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_content_property.cfm">
		</div>
		<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform name="add_content_property" method="post" action="#request.self#?fuseaction=settings.emptypopup_content_property_add">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="item-header">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'> *</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'> !</cfsavecontent>
								<cfinput type="Text" name="name" value="" maxlength="50" required="Yes" message="#message#">
							</div>
						</div>
						<div class="form-group" id="item-description">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<textarea name="description" id="description"></textarea>
							</div>
						</div>
						<div class="form-group" id="gizli1">
                            <cfsavecontent variable="txt_1"><cf_get_lang no='700.Yetkili Pozisyonlar'></cfsavecontent>
                            <cf_workcube_to_cc is_update="0" to_dsp_name="#txt_1#" form_name="add_digital_asset_group" str_list_param="1">					
                       </div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function="kontrol()">
				</cf_box_footer>
			</cfform>
		</div>
	</cf_box>
</div>
