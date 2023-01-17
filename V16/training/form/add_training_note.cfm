<cf_get_lang_set module_name="training">
<cf_popup_box title="#getLang('main',53)#">
<cfform name="employe_detail" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_training_note">
	<cfif isdefined("attributes.training_id")>
		<input type="hidden" name="training_id" id="training_id" value="<cfoutput>#attributes.training_id#</cfoutput>">
	<cfelseif isdefined("attributes.class_id")>
		<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
	</cfif>
	<table>
		<tr>
			<td><cf_get_lang_main no='68.Başlık'>*</td>
			<td>
				<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1408.başlık'></cfsavecontent>
				<cfinput type="text" name="note_head" style="width:510px;" maxlength="100" value="" required="yes" message="#message#">
			</td>
		</tr>
		<tr>
			<td></td>
			<td> 
				<cfmodule
				template="/fckeditor/fckeditor.cfm"
				toolbarSet="WRKContent"
				basePath="/fckeditor/"
				instanceName="NOTE_DETAIL"
				value=""
				width="500"
				height="250">
			</td>
		</tr>
	</table>
	<cf_popup_box_footer>
		<cf_workcube_buttons is_upd='0'>
	</cf_popup_box_footer>
</cfform>
</cf_popup_box>
