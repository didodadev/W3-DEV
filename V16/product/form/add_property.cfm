<!--- <cfsetting showdebugoutput="true"> --->
<cfinclude template="../query/get_property_detail.cfm">
	<cfquery name="GET_PROPERTY_CAT" datasource="#dsn1#">
		SELECT
			*
		FROM
			PRODUCT_PROPERTY
		WHERE
			PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.prpt_id#">
	</cfquery>
<cfset related_variation_list = listdeleteduplicates(ValueList(get_property_detail.related_variation_id,','))>
<cfif listlen(related_variation_list)>
	<cfquery name="get_relations_variations_all" datasource="#dsn1#">
        SELECT 
            PROPERTY_DETAIL,PROPERTY_DETAIL_ID
        FROM 
            PRODUCT_PROPERTY_DETAIL 
        WHERE 
            PROPERTY_DETAIL_ID IN (#related_variation_list#)
    </cfquery>
</cfif>
	<cfquery name="GET_VARIATION" datasource="#DSN1#">
	SELECT 
		VARIATION_ID
	FROM 
		PRODUCT_DT_PROPERTIES
	WHERE
		PROPERTY_ID=#attributes.prpt_id# 
	</cfquery>
<cfparam name="attributes.related_variation_id" default="">
<cfparam name="attributes.related_variation" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Varyasyon',37249)#: #GET_PROPERTY_CAT.PROPERTY#" popup_box="1" closable="1" resize="0">
		<cfform name="add_prpt" method="post" action="#request.self#?fuseaction=product.emptypopup_add_property_act">
			<input type="hidden" name="prpt_id" id="prpt_id" value="<cfoutput>#attributes.prpt_id#</cfoutput>">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-is_active">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
							<input type="checkbox" value="1" name="is_active" id="is_active" checked>
						</div>
					</div>
					<div class="form-group" id="item-prop">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37249.Varyasyon'> *</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='29741.Özellik Girmelisiniz'> !</cfsavecontent>
							<cfinput type="text" name="prop" value="" required="yes" message="#message#" maxlength="1000">
						</div>
					</div>
					<div class="form-group" id="item-property_detail_code">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37209.Varyasyon Kodu'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
							<cfinput type="text" name="property_detail_code" maxlength="20">
						</div>
					</div>
					<div class="form-group" id="item-related_variation">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57986.Alt'><cf_get_lang dictionary_id='37249.Varyasyon'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
							<div class="input-group">
								<cfoutput>
									<input type="hidden" name="related_variation_id" id="related_variation_id" value="#attributes.related_variation_id#">
									<input type="text" name="related_variation" id="related_variation" value="#attributes.related_variation#">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="document.getElementById('related_variation').value='';document.getElementById('related_variation_id').value='';openBoxDraggable('#request.self#?fuseaction=product.popup_list_variations&variation_id=related_variation_id&variation=related_variation','','ui-draggable-box-small');"></span>
								</cfoutput>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group">
						&nbsp
					</div>
					<cfif session.ep.our_company_info.workcube_sector is 'it'>
						<div class="form-group" id="item-property_values">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37388.Değerler'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
								<cfinput type="text" name="property_values" value="" maxlength="500">
							</div>
						</div>
						<div class="form-group" id="item-unit">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57636.Birim'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
								<cfinput type="text" name="unit" value="" maxlength="20">
							</div>
						</div>
						<div class="form-group" id="item-icon_patch">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='65438.İcon Patch'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group"> 
									<input type="text" name="icon_patch" id="icon_patch" value=""/>
									<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_icons&is_popup=1&field_name=add_prpt.icon_patch');"></span>
								</div>
							</div>
						</div>
					<cfelse>
						<input type="hidden" name="property_values" id="property_values" value="">
						<input type="hidden" name="unit" id="unit" value="">
					</cfif>
				</div>
			
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_prpt' , #attributes.modal_id#)"),DE(""))#">
			</cf_box_footer>
			<cf_seperator id="variations" title="#getLang('','Varyasyon',37258)#">
			<div class="col col-12 col-xs-12" id="variations">
				<cf_grid_list>
					<thead>
						<tr>
							<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
							<th><cf_get_lang dictionary_id='37249.Varyasyon'></th>
							<th><cf_get_lang dictionary_id='60321.İlişkili Varyasyon'></th>
							<th><cf_get_lang dictionary_id='37388.Değerler'></th>
							<th><cf_get_lang dictionary_id='57636.Birim'></th>
							<th width="20"><i class="fa fa-pencil"></i></th>
							<th width="20"><i class="fa fa-minus"></i></th>
						</tr>
					</thead>
					<tbody>
						<cfoutput query="get_property_detail">
							<tr>
								<td>#currentrow#</td>
								<td>#property_detail#</td>
								<td>
									<cfif len(related_variation_id)>
										<cfquery name="get_relations_query" dbtype="query">	
											<cfset _RELATED_VARIATION_ID_ = listdeleteduplicates(related_variation_id)>
											SELECT PROPERTY_DETAIL FROM get_relations_variations_all WHERE  PROPERTY_DETAIL_ID IN(#_related_variation_id_#)
										</cfquery>
											#ValueList(get_relations_query.property_detail,'<br/>')#
									</cfif>
								</td>
								<td>#property_values#</td>
								<td>#unit#</td>
								
									<cfquery name="GET_VARIATION_SUBQUERY" dbtype="query" >
										SELECT
											VARIATION_ID
										FROM 
											get_variation
										WHERE 
											VARIATION_ID = #get_property_detail.property_detail_id#
									</cfquery>
									<td>
										<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.popup_upd_sub_property&property_detail_id=#property_detail_id#')"><i class="fa fa-pencil"></i></a>
									</td>
									<td>
										<cfif not get_variation_subquery.recordcount>
											<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=product.emptypopup_del_sub_property&property_detail_id=#property_detail_id#')";><i class="fa fa-minus"></i></a>
										</cfif>
									</td>
							</tr>
						</cfoutput>
					</tbody>
				</cf_grid_list>	
			</div>		
			
		</cfform>
	</cf_box>
</div>
<script>
	function refresh_variation_upd(){
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.list_property&event=add-sub-property&prpt_id=#attributes.prpt_id#</cfoutput>');
	}
</script>