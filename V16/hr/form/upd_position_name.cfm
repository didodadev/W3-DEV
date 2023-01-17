<cfinclude template="../query/get_position_names.cfm">
<cfform name="add_pos_name" action="#request.self#?fuseaction=hr.emptypopup_upd_position_name">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55163.Pozisyon Ekle"></cfsavecontent>
<cf_popup_box title="#message#">

	<div class="row">
		<div class="col col-12 uniqeRow">
			<div class="row">
				<div class="row" type="row">
					<div class="col col-4 col-md-4 col-sm-6 col-xs-6" type="column" index="1" sort="true">
						<div class="form-group" id="position_name">
							<label class="col col-4 col-xs-4"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
							<div class="col col-8 col-xs-8">
							<input type="hidden" name="id" value="<cfoutput>#attributes.id#</cfoutput>">	
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58497.Pozisyon'></cfsavecontent>
								<cfinput type="Text" name="position_name" required="yes" maxlength="100" value="#get_pos_name.POSITION_NAME#" message="#message#">
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<cf_popup_box_footer>
		<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_position_name&id=#attributes.id#&head=#get_pos_name.POSITION_NAME#'>
	</cf_popup_box_footer>
	</cf_popup_box>
</cfform>

