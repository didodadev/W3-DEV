<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='43622.Vitrin Tipleri'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_vision_type" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_vision_type.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform name="form_add_vision_type" method="post" action="#request.self#?fuseaction=settings.add_vision_type" enctype="multipart/form-data">
        		<cf_box_elements>
          			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="vision_type_name">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='51929.Lütfen Konu Giriniz'>!</cfsavecontent>
								<cfinput type="text" name="vision_type_name" id="vision_type_name" value="" maxlength="50" required="Yes" message="#message#">
								</div>	
						</div>
						<div class="form-group" id="account-name">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12" style="valign:top;"><cf_get_lang dictionary_id='57629.Açıklama'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<textarea name="vision_type_detail" id="vision_type_detail" maxlength="250" onBlur="return ismaxlength(this);" onkeyup="return ismaxlength(this);" onkeydown="return ismaxlength(this);"></textarea>
								</div>
						</div>
						<div class="form-group" id="account-detail">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43829.Vitrin İkonu'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<input  type="file" name="vision_type_image" id="vision_type_image">
								</div>
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

