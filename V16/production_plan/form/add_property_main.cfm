<cfparam name="attributes.modal_id" default="#url.modal_id#">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='36639.Özellik Ekle'></cfsavecontent>
<cf_box title="#title#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform action="#request.self#?fuseaction=prod.emptypopup_add_property_main" method="post" name="add_property_main">
		<cfinput type="hidden" name="modal_id" id="modal_id" value="#attributes.modal_id#">			
		<cf_box_elements>
			<div class="col col-6" type="column" index="1" sort="true">
				<div class="form-group" id="item-PROPERTY">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57632.Özellik'>*</label>
					<div class="col col-8 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='29741.Özellik girmelisiniz'>!</cfsavecontent>
						<cfinput type="Text" name="PROPERTY" id="property_add" value="" maxlength="50" required="yes" message="#message#">
					</div>
				</div>
				<div class="form-group" id="item-detail">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
					<div class="col col-8 col-xs-12">
						<textarea name="detail" id="detail"  maxlength="150" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" style="width:200px;" value=""></textarea>
					</div>
				</div>
				<div class="form-group" id="item-size_colors">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36589.Beden'></label>
					<div class="col col-8 col-xs-12">						
						<input type="radio" name="size_color" id="size_color" value="1" checked>
					</div>
				</div>
				<div class="form-group" id="item-size_colors">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36554.Renk'></label>
					<div class="col col-8 col-xs-12">
						<input type="radio" name="size_color" id="size_color" value="0">
					</div>
				</div>
			</div>
		</cf_box_elements>					
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function="kontrol()">
		</cf_box_footer> 
	</cfform>
</cf_box>
<script>
	function kontrol() {		
		if($('#property_add').val() != '') {
			loadPopupBox('add_property_main' , <cfoutput>#attributes.modal_id#</cfoutput>);
			return false;
			}
		else{
			alert("<cf_get_lang dictionary_id='29741.Özellik girmelisiniz'>");
			return false;
			}		
	}
</script>
