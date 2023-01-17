<cfscript>
	cmp_department = createObject("component","V16.hr.cfc.get_departments");
	cmp_department.dsn = dsn;
	get_department = cmp_department.get_department();
</cfscript>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform action="#request.self#?fuseaction=hr.emptypopup_add_content" method="post" name="position">
			<cfquery name="POSITIONCATEGORIES" datasource="#dsn#">
				SELECT 
					* 
				FROM 
					SETUP_POSITION_CAT 
				ORDER BY 
					POSITION_CAT
			</cfquery>
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-STATUS">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
						<div class="col col-8 col-xs-12"> 
							<input type="checkbox" name="STATUS" id="STATUS" value="" checked>
						</div>
					</div>
					<div class="form-group" id="item-position_name">
						<label class="col col-4"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
						<div class="col col-8">
							<div class="input-group">
								<input maxlength="50"  type="hidden" name="position_name_id" id="position_name_id" value="">
								<input maxlength="50"  type="Text" name="position_name" id="position_name" value="">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_names&field_id=position.position_name_id&field_name=position.position_name','list');"></span>              
							</div>
						</div>                
					</div>
					<div class="form-group" id="item-position_cat">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
						<div class="col col-8 col-xs-12"> 
							<cf_multiselect_check
								name="position_cat"
								table_name="SETUP_POSITION_CAT"
								option_name="position_cat"
								option_value="POSITION_CAT_ID">
						</div>
					</div>
					<div class="form-group">										  
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
						<div class="col col-8 col-xs-12">
							<div id="DEPARTMENT_PLACE" class="multiselect-z4">
								<cf_multiselect_check 
									query_name="get_department"  
									name="department_id"
									width="140" 
									option_value="DEPARTMENT_ID"
									option_name="DEPARTMENT_HEAD"
									option_text="#getLang('main',322)#">
							</div>
						</div>
					</div>
					<div class="form-group" id="item-CONTENT_HEAD">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'></label>
						<div class="col col-8 col-xs-12">  
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'></cfsavecontent>
							<cfinput type="text" name="CONTENT_HEAD" id="CONTENT_HEAD" value="" required="Yes" message="#message#" maxlength="100" style="width:420px;">
						</div>
					</div>
					<div class="form-group" id="item-editor">	
						<cfmodule
							template="/fckeditor/fckeditor.cfm"
							toolbarSet="WRKContent"
							basePath="/fckeditor/"
							instanceName="CONTENT_DETAIL"
							valign="top"
							value=""
							width="500"
							height="300">
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>	
				<div class="col col-12"><cf_workcube_buttons is_upd='0'><!---  add_function='OnFormSubmit()' ---></div> 
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>