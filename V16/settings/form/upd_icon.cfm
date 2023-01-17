<cfquery name="GET_PROMOTION_ICON" datasource="#DSN3#">
	SELECT ICON_ID FROM PROMOTIONS WHERE ICON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
</cfquery>
<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
	<cfinclude template="../display/list_icon.cfm">
</div>
<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
	<cfsavecontent variable="title"><cf_get_lang no='624.İmaj Güncelle'></cfsavecontent>
		<cf_box title="#title#" add_href="#request.self#?fuseaction=settings.form_add_icon" is_blank="0">
			<form enctype="multipart/form-data" action="<cfoutput>#request.self#?fuseaction=settings.emptypopup_icon_upd</cfoutput>" method="post" name="icon" id="icon">
				<cf_box_elements> 
					<cfquery name="CATEGORY" datasource="#dsn3#">
						SELECT 
							* 
						FROM 
							SETUP_PROMO_ICON 
						WHERE 
							ICON_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
					</cfquery>
					<input type="Hidden" name="icon_ID" id="icon_ID" value="<cfoutput>#URL.ID#</cfoutput>">
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="item-checkbox">
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label></label></div>
								<cf_get_server_file output_file="sales/#category.icon#" output_server="#category.icon_server_id#" output_type="0" image_height="100" image_width="100">
						</div>
							<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-checkbox">
								<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label></label></div>
								<div class="col col-4 col-md-4 col-sm-12 col-xs-12"><label><input type="checkbox" name="is_vision" id="is_vision" value="1" <cfif category.is_vision eq 1>checked</cfif>><cf_get_lang no='1501.Vitrinde Kullanılsın'></label></div>
							</div>

							<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-file_type1">
								<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang_main no='1965.İmaj'>*</label></div>
								<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
									<div class="col col-8 col-md-8 col-sm-12 col-xs-12">										
										<input type="File" name="icon" id="icon" style="width:150px;">
									</div>
								</div>
							</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>									
					<cfif len(category.record_emp)>
						<cf_record_info 
							query_name="category"
							record_emp="record_emp" 
							record_date="record_date"
							update_emp="update_emp"
							update_date="update_date">
					</cfif>
					<cfif get_promotion_icon.recordcount>
						<cf_workcube_buttons is_upd='1' is_delete='0'>
					<cfelse>
						<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_icon_del&icon_id=#URL.ID#'>
					</cfif>						
				</cf_box_footer>
			</form>
		</cf_box>
</div>