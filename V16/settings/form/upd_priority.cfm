  <cf_box title="#getLang('','settings',42167)#"<!--- Öncelik Kategorileri ---> add_href="#request.self#?fuseaction=settings.form_add_priority" is_blank="0">
		<cfform name="priority" method="post" action="#request.self#?fuseaction=settings.emptypopup_priority_upd">
			<cf_box_elements>
			<cfquery name="CATEGORY" datasource="#dsn#">
				SELECT 
					#dsn#.Get_Dynamic_Language(PRIORITY_ID,'#session.ep.language#','SETUP_PRIORITY','PRIORITY',NULL,NULL,PRIORITY) AS PRIORITY,COLOR,RECORD_EMP,RECORD_DATE,UPDATE_DATE,UPDATE_EMP 
				FROM 
					SETUP_PRIORITY 
				WHERE 
					PRIORITY_ID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.ID#">
			</cfquery>
			<input type="Hidden" name="priority_ID" id="priority_ID" value="<cfoutput>#URL.ID#</cfoutput>">
			<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
				<cfinclude template="../display/list_priority.cfm">
			  </div>
		  <div class="col col-9 col-md-9 col-sm-9 col-xs-12" type="column" index="2" sort="true">
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			  <div class="form-group" id="item-priority">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='42457.Öncelik Tipi'>*</label>
				<div class="col col-8 col-md-6 col-xs-12">
				  <cfsavecontent variable="message"><cf_get_lang dictionary_id='42005.Öncelik Tipi girmelisiniz'></cfsavecontent>
					<div class="input-group">
						<cfinput type="Text" name="priority" id="priority" size="60" value="#category.priority#" maxlength="50" required="Yes">
							<span class="input-group-addon">
								<cf_language_info 
								table_name="SETUP_PRIORITY" 
								column_name="PRIORITY" 
								column_id_value="#url.id#" 
								maxlength="500" 
								datasource="#dsn#" 
								column_id="PRIORITY_ID" 
								control_type="0">
							</span>
					</div>
				</div>
			  </div>
			  <div class="form-group" id="item-colour">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='42324.Kategori Rengi'></label>
				<div class="col col-8 col-md-6 col-xs-12">
				  <cf_workcube_color_picker name="colourp" id="colourp" value="#category.color#" width="200">
				</div>
			  </div>
			</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_record_info query_name="category">
			<cfif not listfindnocase("1,2,3",attributes.id)>
				<cf_workcube_buttons add_function='kontrol()' is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_priority_del&priority_id=#url.id#'>
				<cfelse>
				<cf_workcube_buttons add_function='kontrol()' is_upd='1' is_delete='0'>
				</cfif>
	  </cf_box_footer>
	  </cfform>
</cf_box>

