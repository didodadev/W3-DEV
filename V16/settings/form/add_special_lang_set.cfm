<cf_box title="#getLang('','Özel Dilleri Yükle',43535)#">
	  <cfform method="POST" action="#request.self#?fuseaction=settings.emptypopup_add_special_lang" name="lang_import">
	  	<cf_box_elements>
			<div class="form-group">
				<label><cf_get_lang dictionary_id='43542.Bu İşlem önceden tanımlanmış olan özel kelimeleri geri yükler'></label>
			</div>		
		</cf_box_elements>
		<cf_box_footer>		
			<cf_workcube_buttons is_upd='0'>
		</cf_box_footer>
		</cfform>
</cf_box>
