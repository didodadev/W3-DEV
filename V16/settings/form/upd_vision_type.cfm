<cfquery name="GET_VISION_TYPE" datasource="#DSN#">
	SELECT
		VISION_TYPE_ID,
		#dsn#.Get_Dynamic_Language(VISION_TYPE_ID,'#session.ep.language#','SETUP_VISION_TYPE','VISION_TYPE_NAME',NULL,NULL,VISION_TYPE_NAME) AS VISION_TYPE_NAME,
		#dsn#.Get_Dynamic_Language(VISION_TYPE_ID,'#session.ep.language#','SETUP_VISION_TYPE','VISION_TYPE_DETAIL',NULL,NULL,VISION_TYPE_DETAIL) AS VISION_TYPE_DETAIL,
		VISION_TYPE_IMAGE,
		VISION_TYPE_IMAGE_SERVER_ID
	FROM
		SETUP_VISION_TYPE
	WHERE
		VISION_TYPE_ID = #attributes.vision_type_id#
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='43622.Vitrin Tipleri'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_vision_type" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_vision_type.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform name="frm_upd_vision_type" method="post" action="#request.self#?fuseaction=settings.upd_vision_type&vision_type_id=#attributes.vision_type_id#" enctype="multipart/form-data">
        		<cf_box_elements>
          			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="vision_type_name">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='51929.Lütfen Konu Giriniz'>!</cfsavecontent>
									<cfinput type="text" name="vision_type_name" value="#get_vision_type.vision_type_name#" maxlength="50" required="Yes" message="#message#">
									<span class="input-group-addon">
										<cf_language_info 
										table_name="SETUP_VISION_TYPE" 
										column_name="VISION_TYPE_NAME" 
										column_id_value="#url.vision_type_id#" 
										maxlength="500" 
										datasource="#dsn#" 
										column_id="VISION_TYPE_ID" 
										control_type="0">
									</span>
								</div>	
							</div>
						</div>
						<div class="form-group" id="account-name">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12" style="valign:top;"><cf_get_lang dictionary_id='57629.Açıklama'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfinput type="text" id="vision_type_detail" name="vision_type_detail" value="#get_vision_type.vision_type_detail#" maxlength="50" required="Yes" message="#message#" onBlur="return ismaxlength(this);">
										<span class="input-group-addon">
											<cf_language_info 
											table_name="SETUP_VISION_TYPE" 
											column_name="VISION_TYPE_DETAIL" 
											column_id_value="#url.vision_type_id#" 
											maxlength="500" 
											datasource="#dsn#" 
											column_id="VISION_TYPE_ID" 
											control_type="0">
										</span>
									</div>
								</div>
						</div>
						<div class="form-group" id="account-detail">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43829.Vitrin İkonu'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<input type="file" name="vision_type_image" id="vision_type_image">
									<input type="hidden" name="old_vision_type_image" id="old_vision_type_image" value="<cfoutput>#get_vision_type.vision_type_image#</cfoutput>">
									<input type="hidden" name="old_vision_type_image_server_id" id="old_vision_type_image_server_id" value="<cfoutput>#get_vision_type.vision_type_image_server_id#</cfoutput>">
									<cfif len(get_vision_type.vision_type_image)>
										<a href="javascript://" onclick="gizle_goster(kart_resim);"><img src="/images/content_plus.gif" border="0" alt="<cf_get_lang no ='1848.Vitrin İkonunu Göster'>" align="absmiddle"></a>
									  <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=settings.emptypopup_del_vision_type_image&vision_type_id=#attributes.vision_type_id#</cfoutput>','small')"><img src="/images/delete_list.gif" border="0" alt="<cf_get_lang no ='1847.Vitrin İkonunu Sil'>" align="absmiddle"></a>
								  </cfif>
								</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_record_info query_name="get_vision_type">
					<cf_workcube_buttons is_upd='1' add_function="kontrol()" delete_page_url='#request.self#?fuseaction=settings.del_vision_type&vision_type_id=#attributes.vision_type_id#'>
				</cf_box_footer>
			</cfform>
				
    	</div>
  	</cf_box>
</div>