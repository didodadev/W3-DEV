<cfquery name="get_branchs" datasource="#DSN#">
		SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
	</cfquery>
<cfquery name="get_safe" datasource="#dsn#">
	SELECT 
    	EMPLOYEE_ID, 
        SAFEGUARD_FILE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP,
        UPDATE_IP, 
        BRANCH_ID, 
        SAFEGUARD_FILE_SERVER_ID 
    FROM 
	    EMPLOYEES_SAFEGUARD 
    WHERE 
    	EMPLOYEE_ID = #attributes.employee_id#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55292.Teminat Bilgileri"></cfsavecontent>
<cf_box title="#message#: <cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput>" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform action="#request.self#?fuseaction=hr.emptypopup_form_upd_emp_safeguard" method="post" name="employe_personal" enctype="multipart/form-data">
	<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
		<cf_box_elements>
			<div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
					<label><cf_get_lang dictionary_id="57453.Sube"></label>
				</div>
				<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
					<select name="branch_id" id="branch_id">
						<cfoutput query="get_branchs">
							<option value="#BRANCH_ID#" <cfif get_safe.recordcount and get_safe.branch_id eq branch_id>selected</cfif>>#BRANCH_NAME#</option>
						</cfoutput>
					</select>
				</div>
			</div>
			<div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
					<label><cf_get_lang dictionary_id="55293.Teminat Dosyası"></label>
				</div>
				<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
					<input type="file" name="safeguard_file" id="safeguard_file" style="width:275px;">
					<input type="hidden" name="old_safeguard_file" id="old_safeguard_file" value="<cfif get_safe.recordcount and len(get_safe.safeguard_file)><cfoutput>#get_safe.safeguard_file#</cfoutput></cfif>">
					<input type="hidden" name="old_safeguard_file_server_id" id="old_safeguard_file_server_id" value="<cfif get_safe.recordcount and len(get_safe.safeguard_file)><cfoutput>#get_safe.safeguard_file_server_id#</cfoutput></cfif>">
					<cfif get_safe.recordcount and len(get_safe.safeguard_file)><a href="javascript://" onclick="windowopen('<cfoutput>/documents/hr/#get_safe.safeguard_file#</cfoutput>','list');"><img src="/images/asset.gif" border="0" align="absmiddle"></a></cfif>
				</div>
			</div>
			<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
					<label>&nbsp;</label>
				</div>
				<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
					<cfif get_safe.recordcount and len(get_safe.safeguard_file)><input type="Checkbox" name="del_file" id="del_file" value="1"></cfif>
					<cfif get_safe.recordcount and len(get_safe.safeguard_file)><cf_get_lang dictionary_id='48973.Belge Sil'></cfif>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cfif get_safe.recordcount><cf_record_info query_name="get_safe"></cfif>
			<cf_workcube_buttons is_upd='0' add_function='#iif(isdefined("attributes.draggable"),DE("loadPopupBox('employe_personal' , #attributes.modal_id#)"),DE(""))#'>
		</cf_box_footer>
	</cfform>
</cf_box>