<cfquery name="GET_ROL" datasource="#DSN#">
	SELECT 
		PROJECT_ROLES_ID,
        #dsn#.Get_Dynamic_Language(SETUP_PROJECT_ROLES.PROJECT_ROLES_ID,'#session.ep.language#','SETUP_PROJECT_ROLES','PROJECT_ROLES',NULL,NULL,SETUP_PROJECT_ROLES.PROJECT_ROLES) AS PROJECT_ROLES,
        DETAIL,
        RECORD_DATE,
        RECORD_EMP,
        RECORD_IP,
        UPDATE_DATE,
        UPDATE_EMP,
        UPDATE_IP
	FROM 
		SETUP_PROJECT_ROLES
	ORDER BY
		PROJECT_ROLES
</cfquery>
<cf_box title="#getLang('','Satış Bölgesi Ekibi',41545)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="worker" method="post" action="#request.self#?fuseaction=salesplan.emptypopup_member_add&sz_id=#url.sz_id#">	  
		<cf_box_elements vertical="1">
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12 text-center">
				<cf_get_lang dictionary_id='57576.Çalışan'>
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12 text-center">
				<cf_get_lang dictionary_id='55478.Rol'>
			</div>
			<cfloop index="i" from="1" to="10">
				<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" align="center">
					<div>
						<div class="input-group">
							<cfoutput>
								<input type="hidden" name="POSITION_CODE#i#" id="POSITION_CODE#i#" value="">
								<input type="hidden" name="PARTNER_ID#i#" id="PARTNER_ID#i#" value="">
								<input type="text" name="emp_par_name#i#" id="emp_par_name#i#" value="" style="width:150px;">
							</cfoutput>
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_partner=worker.PARTNER_ID#i#&field_code=worker.POSITION_CODE#i#&field_name=worker.emp_par_name#i#&select_list=1,2,6</cfoutput>');"></span>	
						</div> 
					</div>
					
					
				</div>
				<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" align="center">
					<div>
						<select name="get_rol<cfoutput>#i#</cfoutput>" id="get_rol<cfoutput>#i#</cfoutput>">
							<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfif get_rol.recordcount>
								<cfoutput query="get_rol">
									<option value="#project_roles_id#">#project_roles#</option>
								</cfoutput>
							</cfif>
						</select>
					</div>
					
				</div>
			</cfloop>
		</cf_box_elements>
		<cf_box_footer><cf_workcube_buttons type_format='1' is_upd='0'></cf_box_footer>
	</cfform>
</cf_box>