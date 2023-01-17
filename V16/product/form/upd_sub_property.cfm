<cfinclude template="../query/get_sub_property_detail.cfm">
<cfparam name="attributes.related_variation_id" default="">
<cfparam name="attributes.related_variation" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent  variable="message"><cf_get_lang dictionary_id='37407.Varyasyon Güncelle'>
	</cfsavecontent>
	<cf_box title="#message#" popup_box="1">
		<cfform name="upd_prpt" method="post" action="#request.self#?fuseaction=product.emptypopup_upd_sub_property">
			<input type="hidden" name="property_detail_id" id="property_detail_id" value="<cfoutput>#url.property_detail_id#</cfoutput>">
			<cf_box_elements vertical="0">
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-is_active">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
							<input type="checkbox" value="1" name="is_active" id="is_active" <cfif get_property_detail.is_active eq 1>checked</cfif>>
						</div>
					</div>
					<div class="form-group" id="item-property_detail">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37249.Varyasyon'> *</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='29741.Özellik girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="property_detail" value="#HTMLEditFormat(get_property_detail.property_detail)#" required="yes" message="#message#" maxlength="1000">
								<span class="input-group-addon">
									<cf_language_info 
									table_name="PRODUCT_PROPERTY_DETAIL" 
									column_name="PROPERTY_DETAIL" 
									column_id_value="#url.property_detail_id#" 
									maxlength="1000" 
									datasource="#dsn1#" 
									column_id="PROPERTY_DETAIL_ID" 
									control_type="0">
								</span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-property_detail_code">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37209.Varyasyon Kodu'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
							<cfinput type="text" name="property_detail_code" value="#get_property_detail.property_detail_code#" maxlength="20">
						</div>
					</div>
					<div class="form-group" id="item-related_variation">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57986.Alt'><cf_get_lang dictionary_id='37249.Varyasyon'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
							<div class="input-group">
								<cfoutput>
									<input type="hidden" name="related_variation_id" id="related_variation_id" value="#get_property_detail.related_variation_id#">
									<input type="text" name="related_variation" id="related_variation" value="">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=product.popup_list_variations&variation_id=related_variation_id&variation=related_variation&related_variation_id=#get_property_detail.related_variation_id#','','ui-draggable-box-small');"></span>
								</cfoutput>
							</div>
						</div>
					</div>
					<cfif session.ep.our_company_info.workcube_sector is 'it'>
						<div class="form-group" id="item-property_values">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37388.Değerler'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
								<cfinput type="text" name="property_values" value="#get_property_detail.property_values#" maxlength="500">
							</div>
						</div>
						<div class="form-group" id="item-unit">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57636.Birim'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
								<cfinput type="text" name="unit" value="#get_property_detail.unit#" maxlength="20">
							</div>
						</div>
					<cfelse>
						<input type="hidden" name="property_values" id="property_values" value="">
						<input type="hidden" name="unit" id="unit" value="">
					</cfif>
					<div class="form-group"  id="item-icon_patch">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='65438.İcon Patch'></label>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="icon_patch" id="icon_patch" value="#get_property_detail.icon_patch#" />
								<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_icons&is_popup=1&field_name=upd_prpt.icon_patch');"></span>
							</div>
						</div>
						<div class="col col-2 col-md-2 col-sm-2 col-xs-12">
							<cfif len(get_property_detail.icon_patch)>
								<cfoutput><img src="css/assets/icons/catalyst-icon-svg/#get_property_detail.icon_patch#.svg" align="absmiddle" border="0" height="15px"></cfoutput>
							</cfif>
						</div>
					</div>
				</div>
			
			</cf_box_elements>
			<div class="ui-form-list-btn">
				<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
					<cf_record_info query_name="get_property_detail">
				</div>
				<div class="col col-6 col-md-4 col-sm-4 col-xs-12">
					<cf_workcube_buttons is_upd='1' is_delete='0' add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('upd_prpt' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</div>
		</cfform>
	</cf_box>
</div>
