<cfinclude template="../query/get_related_assets.cfm">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='42243.İçerik ve Belge Tipleri'></cfsavecontent>
	<cf_box title="#message#" add_href="#request.self#?fuseaction=settings.form_add_content_property" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_content_property.cfm">
		</div>
		<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform name="content_property" method="post" action="#request.self#?fuseaction=settings.emptypopup_content_property_upd">
				<cfquery name="CONTENT_PROPERTYS" datasource="#dsn#">
					SELECT 
						#dsn#.Get_Dynamic_Language(CONTENT_PROPERTY_ID,'#session.ep.language#','CONTENT_PROPERTY','NAME',NULL,NULL,NAME) AS CONTENT_NAME,
						* 
					FROM 
						CONTENT_PROPERTY 
					WHERE 
						CONTENT_PROPERTY_ID=#URL.CONTENT_PROPERTY_ID#
				</cfquery>
				<input type="Hidden" name="CONTENT_property_ID" id="CONTENT_property_ID" value="<cfoutput>#URL.CONTENT_property_ID#</cfoutput>">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="item-header">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'> *</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'> !</cfsavecontent>
									<cfinput type="Text" name="name"  value="#CONTENT_propertys.CONTENT_NAME#" maxlength="50" required="Yes" message="#message#">
									<span class="input-group-addon">
										<cf_language_info	
											table_name="CONTENT_PROPERTY"
											column_name="NAME" 
											column_id_value="#URL.CONTENT_PROPERTY_ID#" 
											maxlength="500" 
											datasource="#dsn#" 
											column_id="CONTENT_PROPERTY_ID" 
											control_type="0">
									</span>
								</div>
							</div>
						</div>
						<div class="form-group" id="gizli1">
								<cfsavecontent variable="txt_1"><cf_get_lang no='700.Yetkili Pozisyonlar'></cfsavecontent>
								<cf_workcube_to_cc 
									is_update="1" 
									to_dsp_name="#txt_1#" 
									form_name="upd_digital_asset_group" 
									str_list_param="1" 
									action_dsn="#DSN#"
									str_action_names = "POSITION_CODE TO_POS_CODE"
									str_alias_names = "TO_POS_CODE"
									action_table="CONTENT_PROPERTY_PERM"
									action_id_name="CONTENT_PROPERTY_ID"
									data_type="2"
									action_id="#attributes.CONTENT_PROPERTY_ID#">
						</div>
						<div class="form-group" id="item-description">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<textarea name="description" id="description"  maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 250"><cfoutput>#content_propertys.description#</cfoutput></textarea>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_record_info query_name="content_propertys">
					<cfif GET_ASSETS.RecordCount>
						<cf_workcube_buttons is_upd='1' is_delete='0' add_function="kontrol()">
					<cfelse>
						<cf_workcube_buttons is_upd='1' add_function="kontrol()" delete_page_url='#request.self#?fuseaction=settings.emptypopup_content_property_del&content_property_id=#URL.CONTENT_PROPERTY_ID#'>
					</cfif>
				</cf_box_footer>
			</cfform>
		</div>
	</cf_box>
</div>