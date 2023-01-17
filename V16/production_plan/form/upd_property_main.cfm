<cfset attributes.property_id = url.prpt_id>
<cfinclude template="../query/get_property_cat.cfm">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='36457.Özellik Güncelle'></cfsavecontent>
<cf_box title="#title#"  scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform action="#request.self#?fuseaction=prod.emptypopup_upd_property_main" method="post" name="upd_property_main">		
		<cf_box_elements>
			<div class="col col-6" type="column" index="1" sort="true">
				<div class="form-group" id="item-PROPERTY">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57632.Özellik'>*</label>
					<div class="col col-8 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='29741.Özellik girmelisiniz'></cfsavecontent>
						<cfinput type="Text" name="property" id="property_upd" value="#get_property_cat.PROPERTY#" maxlength="50" required="yes" message="#message#">  
					</div>
				</div>
				<div class="form-group" id="item-detail">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
					<div class="col col-8 col-xs-12">
						<textarea name="DETAIL" id="DETAIL" cols="75"><cfoutput>#GET_PROPERTY_CAT.DETAIL#</cfoutput></textarea>
					</div>
				</div>
				<div class="form-group" id="item-size_colors">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36589.Beden'></label>
					<div class="col col-8 col-xs-12">
						<input type="radio" name="size_color" id="size_color" value="1" <cfif GET_PROPERTY_CAT.PROPERTY_SIZE eq 1>checked</cfif>>
					</div>
					<input type="hidden" name="property_id" id="property_id" value="<cfoutput query="get_property_cat">#PROPERTY_ID#</cfoutput>">
				</div>
				<div class="form-group" id="item-size_colors">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36554.Renk'></label>
					<div class="col col-8 col-xs-12">
						<input type="radio" name="size_color" id="size_color" value="0" <cfif GET_PROPERTY_CAT.PROPERTY_COLOR EQ 1>checked</cfif>>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_record_info query_name="get_property_cat">
			<cf_workcube_buttons is_upd='1' add_function="control_upd()&&loadPopupBox('upd_property_main')" delete_page_url='#request.self#?fuseaction=prod.emptypopup_del_property&property_id=#attributes.PRPT_ID#&head=#get_property_cat.PROPERTY#'>
		</cf_box_footer> 
	</cfform>
</cf_box>
<script>
	function control_upd() {		
		if($('#property_upd').val() != '') {
			loadPopupBox('upd_property_main' , <cfoutput>#attributes.modal_id#</cfoutput>);
			return false;
			}
		else{
			alert("<cf_get_lang dictionary_id='29741.Özellik girmelisiniz'>");
			return false;
			}	
	}		
</script>