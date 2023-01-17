<cfparam name="attributes.assetp_catid" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.is_active" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.order_type" default="1">
<cfparam name="attributes.branch" default="">
<cfparam name="attributes.asset_p_space_id" default="">
<cfparam name="attributes.assetp_space_code" default="">
<cfparam name="attributes.asset_p_space_name" default="">
<cfparam name="attributes.page" default=1>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfif isdefined("attributes.form_submitted")>
		<cfquery name="GET_ASSETP_SPACE" datasource="#dsn#">
            SELECT 
				ASSET_P_DESKS_GROUP_ID, 
				ASSET_P_SPACE.SPACE_CODE, 
				#dsn#.Get_Dynamic_Language(ASSET_P_DESKS_GROUP_ID,'#session.ep.language#','ASSET_P_SPACE','SPACE_NAME',NULL,NULL,SPACE_NAME) AS SPACE_NAME, 
				ASSET_P_DESKS_GROUP.DEPARTMENT_ID,
				ASSET_P_DESKS_GROUP.EMPLOYEE_ID,
				ASSET_P_DESKS_GROUP.ASSETP_CATID,
				DEPARTMENT.DEPARTMENT_HEAD,
				BRANCH.BRANCH_NAME,
				EMP.EMPLOYEE_NAME +' '+ EMP.EMPLOYEE_SURNAME EMP_NAME,
				ISNULL((SELECT SUM(DESK_CHAIR) FROM ASSET_P WHERE RELATION_DESKS_ASSETP_ID = ASSET_P_DESKS_GROUP.ASSET_P_DESKS_GROUP_ID),0) CHAIR_COUNT,
				(SELECT COUNT(*) FROM ASSET_P WHERE RELATION_DESKS_ASSETP_ID = ASSET_P_DESKS_GROUP.ASSET_P_DESKS_GROUP_ID) DESK_COUNT
			FROM 
				ASSET_P_DESKS_GROUP
				LEFT JOIN EMPLOYEES EMP ON ASSET_P_DESKS_GROUP.EMPLOYEE_ID = EMP.EMPLOYEE_ID,
				BRANCH,
				DEPARTMENT,
				ASSET_P_SPACE
				
			WHERE
				BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) AND
                ASSET_P_DESKS_GROUP.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
                DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
				ASSET_P_SPACE.ASSET_P_SPACE_ID=ASSET_P_DESKS_GROUP.ASSET_P_SPACE_ID
				<cfif isDefined("attributes.branch_id") and len(attributes.branch_id) and len(attributes.branch)>
					AND BRANCH.BRANCH_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
				</cfif>
				<cfif isDefined("attributes.asset_p_space_id") and len(attributes.asset_p_space_id) and len(attributes.asset_p_space_name)>
					AND ASSET_P_SPACE.ASSET_P_SPACE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_p_space_id#">
				</cfif>
        </cfquery>
		<cfparam name="attributes.totalrecords" default='#GET_ASSETP_SPACE.recordcount#'>
	<cfelse>
		<cfset GET_ASSETP_SPACE.recordcount = 0>
		<cfparam name="attributes.totalrecords" default='0'>
	</cfif>
	<!-- sil -->
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box>
			<cfform name="search_asset" method="post" action="#request.self#?fuseaction=assetcare.desks">
				<input type="hidden" name="form_submitted" id="form_submitted" value="0">
				<cf_box_search><!-- sil -->
					<div class="form-group" id="item-branch">
						<div class="input-group">
							<input type="hidden" name="branch_id" maxlength="50" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>"> 
							<input type="text" placeholder="<cf_get_lang dictionary_id='57453.Şube'>" name="branch" maxlength="50" id="branch" value="<cfoutput>#attributes.branch#</cfoutput>">
							<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=search_asset.branch&field_branch_id=search_asset.branch_id','list','popup_list_branches')"></span>
						</div>
					</div>
					<div class="form-group" id="item_assetp_space_id">
						<div class="input-group">
							<input type="hidden" name="asset_p_space_id" id="asset_p_space_id" value="<cfoutput>#attributes.asset_p_space_id#</cfoutput>">
							<input type="hidden" name="assetp_space_code" id="assetp_space_code" value="<cfoutput>#attributes.assetp_space_code#</cfoutput>">
							<input type="text" placeholder="<cf_get_lang dictionary_id="60371.Mekan">" name="asset_p_space_name" id="asset_p_space_name" value="<cfoutput>#attributes.assetp_space_code#<cfif len(attributes.asset_p_space_name)>/#attributes.asset_p_space_name#</cfif></cfoutput>" onFocus="AutoComplete_Create('asset_p_space_name','SPACE_NAME','SPACE_NAME','get_assetp_space','3','asset_p_space_id','assetp_space_id','','3','135')">
							<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_assetp_space&field_name=asset_p_space_name&field_code=assetp_space_code&field_id=asset_p_space_id&horeca=1</cfoutput>','list');"></span>
						</div>
					</div>
						<div class="form-group" id="item-is_active">
							<select name="is_active" id="is_active">
								<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
								<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
								<option value="2" <cfif attributes.is_active eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
							</select>
						</div>	
						<div class="form-group small" id="item-maxrows">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)">
						</div>
						<div class="form-group">
							<cf_wrk_search_button button_type="4">
						</div>
				</cf_box_search><!-- sil -->
			</cfform>
		</cf_box>
		<cf_box title="#getLang(2207,'Mekanlar Ve Masalar',36328)#" uidrop="1" hide_table_column="1">
			<cf_grid_list>
				<thead> 
					<tr>
						<th><cf_get_lang dictionary_id='58577.Sıra'></th>
							<th><cf_get_lang dictionary_id='57453.Şube'></th>
							<th><cf_get_lang dictionary_id="57572.Departman"></th>
							<th><cf_get_lang dictionary_id="60371.Mekan"></th>
							<th width="90"><cf_get_lang dictionary_id="47291.Masa Sayısı"></th>
							<th width="90"><cf_get_lang dictionary_id="51104.Sandalye Sayısı"></th>
							<th><cf_get_lang dictionary_id='57544.Sorumlu'></th>
						<!-- sil --><th width="20" class="header_icn_none text-center"><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.desks&event=add')"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
					</tr>
				</thead>
				<tbody>
					<cfif GET_ASSETP_SPACE.recordcount>
						<cfoutput query="GET_ASSETP_SPACE">
							<tr>
								<td>#currentrow#</td>
								<td>#branch_name#</td>
								<td>#department_head#</td>
								<td>#space_code# #space_name#</td>
								<td>#desk_count#</td>
								<td>#chair_count#</td>
								<td><cfif len(employee_id)><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');">#EMP_NAME#</a></cfif></td>
								<!-- sil --><td><a  href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=assetcare.desks&event=upd&asset_p_space_id=#asset_p_desks_group_id#')"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
							</tr>
						</cfoutput>
					<cfelse>
						<tr>
							<td height="22" colspan="10"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
						</tr>
					</cfif>
				</tbody>
			</cf_grid_list>
			<cfset url_str = "">
			<cfif len(attributes.branch_id)>
				<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
			</cfif>
			<cfif len(attributes.branch)>
				<cfset url_str = "#url_str#&branch=#attributes.branch#">
			</cfif>
			<cfif len(attributes.department)>
				<cfset url_str = "#url_str#&department_id=#attributes.department_id#">
				<cfset url_str = "#url_str#&department=#attributes.department#">
			</cfif>
			<cfif len(attributes.emp_id)>
				<cfset url_str = "#url_str#&emp_id=#attributes.emp_id#">
			</cfif>
			<cfif len(attributes.employee_name)>
				<cfset url_str = "#url_str#&employee_name=#attributes.employee_name#">
			</cfif>	
			<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
				<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
			</cfif>
			<cfif len(attributes.is_active)>
				<cfset url_str = "#url_str#&is_active=#attributes.is_active#">
			</cfif>
			<cfif len(attributes.asset_p_space_id)>
				<cfset url_str = "#url_str#&keyword=#attributes.asset_p_space_id#">
			</cfif>
			<!-- sil -->
			<cf_paging
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="assetcare.desks#url_str#">
			<!-- sil -->
		</cf_box>
	</div>
	