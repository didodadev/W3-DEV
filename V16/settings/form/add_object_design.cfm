<div class="col col-2 col-md-2 col-sm-2 col-xs-12" type="column" index="1" sort="true">
	<cfinclude template="../display/list_object_design.cfm">
</div>
<div class="col col-10 col-md-10 col-sm-10 col-xs-12">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='31076.Tasarım Ayarları'></cfsavecontent>
	<cf_box title="#title#" is_blank="0">
		<cfform name="object_design" action="#request.self#?fuseaction=settings.emptypopup_add_object_design" method="post">
			<cf_box_elements>	
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-offtime">
						<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43440.Tasarım Adı'>*</label>
						<div class="col col-8 col-md-6 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='43441.Tasarım Adı Girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="design_name" value="" maxlength="50" required="Yes" message="#message#">								
						</div>
					</div>
					
					<div class="form-group" id="item-offtime">
						<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43398.Tasarım Path'>*</label>
						<div class="col col-8 col-md-6 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='43428.Path Girmelisiniz'>!</cfsavecontent>
							<cfinput type="text" name="design_path" value="" maxlength="250" required="Yes" message="#message#">
						</div>
					</div>
					
					<div class="form-group" id="item-offtime">
						<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<textarea name="design_detail" id="design_detail" style="height:75px;" value=""></textarea>
						</div>
					</div>				
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>