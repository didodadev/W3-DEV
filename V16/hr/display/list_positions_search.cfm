<cfsavecontent variable="header_"><cf_get_lang dictionary_id='55162.Pozisyonlar'></cfsavecontent>
	<cf_box style="width:98%;" id="list_positions_search_div" body_style="text-align:left;" title_style="font-size:12px;" title="#header_#">
			<cfform name="search" action="#request.self#?fuseaction=hr.list_positions" method="post">
			<div style="float:left;">
				<div id="search_div"><cfinput type="text" name="keyword" value="#attributes.keyword#"></div>
				<div id="search_div"><cf_get_lang dictionary_id='57789.Özel Kod'></div>
				<div id="search_div"><cfinput type="text" name="hierarchy" value="#attributes.hierarchy#" maxlength="50"></div>
				<div id="search_div">
					<select name="unit_id" id="unit_id">
						<option value=""><cf_get_lang dictionary_id ='55217.Birimler'></option>
						<cfoutput query="get_fonc_units">
							<option value="#unit_id#" <cfif attributes.unit_id eq unit_id>selected</cfif>>#unit_name#</option>
						</cfoutput>
					</select>
				</div>
				<!---    <cf_wrk_select table_name="SETUP_CV_UNIT" name="func_id" value="UNIT_ID" field="UNIT_NAME" datasource="#dsn#" width="100">   --->
				<div id="search_div">
					<select name="organization_step_id" id="organization_step_id">
						<option value=""><cf_get_lang dictionary_id='58710.Kademe'></option>
						<cfoutput query="get_organization_steps">
							<option value="#organization_step_id#" <cfif attributes.organization_step_id eq organization_step_id>selected</cfif>>#ORGANIZATION_STEP_NAME#</option>
						</cfoutput>
					</select>
				</div>
				<div id="search_div">
					<select name="status" id="status">
						<option value="-1"<cfif isdefined("attributes.status") and (attributes.status eq -1)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1"<cfif isdefined("attributes.status") and (attributes.status eq 1)>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0"<cfif isdefined("attributes.status") and (attributes.status eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>
				</div>
				<div id="search_div">
					<select name="collar_type" id="collar_type">
						<option value=""><cf_get_lang dictionary_id='56063.Yaka Tipi'></option>
						<option value="1"<cfif attributes.collar_type eq 1> selected</cfif>><cf_get_lang dictionary_id='56065.Mavi Yaka'></option> 
						<option value="2"<cfif attributes.collar_type eq 2> selected</cfif>><cf_get_lang dictionary_id='56066.Beyaz Yaka'></option>
					</select>
				</div>
				<div id="search_div">
					<select name="position_cat_id" id="position_cat_id" style="width:150px;">
						<option value=""><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></option>
						<cfoutput query="GET_POSITION_CATS">
							<option value="#POSITION_CAT_ID#"<cfif attributes.position_cat_id eq position_cat_id> selected</cfif>>#POSITION_CAT#
						</cfoutput>
					</select>
				</div>
				<div id="search_div">
					<select name="title_id" id="title_id" style="width:125px;">
						<option value=""><cf_get_lang dictionary_id ='55168.Ünvanlar'></option>
						<cfoutput query="titles">
							<option value="#title_id#" <cfif attributes.title_id EQ title_id>selected</cfif>>#title#</option>
						</cfoutput>
					</select>
				</div>
				<div id="search_div">
					<select name="empty_position" id="empty_position">
						<option value=""<cfif isdefined("attributes.empty_position") and not len(attributes.empty_position)> selected</cfif>><cf_get_lang_main no='669.Hepsi'></option>
						<option value="1"<cfif isdefined("attributes.empty_position") and (attributes.empty_position eq 1)> selected</cfif>><cf_get_lang no='456.Dolu'></option>
						<option value="0"<cfif isdefined("attributes.empty_position") and (attributes.empty_position eq 0)> selected</cfif>><cf_get_lang no='467.Boş'></option>
					</select>
				</div>
			</div>
			<div style="float:left;">
			   <div id="search_div">
				<select name="comp_id" id="comp_id" style="width:150px;">
					<option value=""><cf_get_lang dictionary_id ='29531.Şirketler'></option>
					<cfoutput query="get_our_company"><option value="#comp_id#"<cfif attributes.comp_id eq comp_id>selected</cfif>>#company_name#</option></cfoutput>
				</select>
				</div>
				<div id="search_div">
					<select name="branch_id" id="branch_id" style="width:150;" onChange="showDepartment(this.value)">
						<option value="0"><cf_get_lang dictionary_id='29434.Şubeler'></option>
						<cfquery name="get_branch" datasource="#dsn#">
							SELECT * FROM BRANCH  WHERE BRANCH_STATUS =1 ORDER BY BRANCH_NAME
						</cfquery>
						<cfoutput query="get_branch"><option value="#branch_id#"<cfif attributes.branch_id eq get_branch.branch_id>selected</cfif>>#branch_name#</option></cfoutput>
					</select>
				</div>
				<div id="search_div">
				<div width="125" id="DEPARTMENT_PLACE">
					<select name="department" id="department" style="width:150px;">
						<!--- <cfif attributes.branch_id eq 0 or attributes.branch_id eq ''> --->
						<option value=""><cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'></option>
						<!--- </cfif> --->
						<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
							<cfquery name="get_department" datasource="#dsn#">
								SELECT * FROM DEPARTMENT WHERE BRANCH_ID = #attributes.branch_id# AND DEPARTMENT_STATUS =1 AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
							</cfquery>
								<cfoutput query="get_department"><option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department') and attributes.department eq get_department.department_id>selected</cfif>>#DEPARTMENT_HEAD#</option></cfoutput>
						</cfif>
					</select>
				</div>
				</div>
				<div id="search_div">
					<select name="process_stage" id="process_stage" style="width:60px;">
						<option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
						<cfoutput query="get_process_stage">
							<option value="#PROCESS_ROW_ID#" <cfif isdefined("attributes.process_stage") and (attributes.process_stage eq PROCESS_ROW_ID)>selected</cfif>>#stage#</option>
						</cfoutput>
					</select>
				</div>
				<div id="search_div"><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<cf_wrk_search_button>
				<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
			</div>
		</cfform>
	</cf_box>
