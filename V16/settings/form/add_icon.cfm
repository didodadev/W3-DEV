<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
	<cfinclude template="../display/list_icon.cfm">
</div>
<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang no='362.İmaj Ekle'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_icon" is_blank="0">	
		<form enctype="multipart/form-data" action="<cfoutput>#request.self#?fuseaction=settings.emptypopup_icon_add</cfoutput>" method="post" name="icon2">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-checkbox">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label></label></div>
						<div class="col col-4 col-md-4 col-sm-12 col-xs-12"><label><input type="checkbox" name="is_vision" id="is_vision" value="1"><cf_get_lang no='1501.Vitrinde Kullanılsın'></label></div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-file_type1">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang_main no='1965.İmaj'>*</label></div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<div class="col col-8 col-md-8 col-sm-12 col-xs-12">
								<cfsavecontent variable="msg"><cf_get_lang no='1735.image seçmelisiniz'>!</cfsavecontent>
								<input type="File" name="icon" id="icon">
							</div>
						</div>
					</div>					
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0'>
			</cf_box_footer>
		</form>		
	</cf_box>
</div>