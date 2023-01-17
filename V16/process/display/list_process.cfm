<cfparam name="attributes.author_id" default="">
<cfparam name="attributes.author_name" default="">
<cfparam name="attributes.authority_type" default="0">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.module" default="">
<cfparam name="attributes.company_id" default="#session.ep.company_id#">
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.record_name" default="">
<cfparam name="attributes.process" default="">
<cfparam name="list_comp" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.up_department_id" default="">
<cfparam name="attributes.up_department" default="">
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfquery name="get_modules" datasource="#DSN#">
  	SELECT 
	  	M.MODULE_ID, 
		M.MODULE_SHORT_NAME,
		ISNULL(Replace(SLT.ITEM_#UCASE(session.ep.language)#,'''',''),M.MODULE) AS MODULE
	FROM MODULES M
	JOIN SETUP_LANGUAGE_TR AS SLT ON M.MODULE_DICTIONARY_ID = SLT.DICTIONARY_ID
	WHERE 
		M.MODULE_SHORT_NAME <> '' 
	ORDER BY 
		MODULE
</cfquery>
<cfquery name="get_company" datasource="#dsn#">
	SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
</cfquery>
<cfquery name="get_process" datasource="#DSN#">
    SELECT
        PM.PROCESS_MAIN_ID,
        PM.PROCESS_MAIN_HEADER
    FROM
        PROCESS_MAIN PM
    WHERE
        PM.PROCESS_MAIN_ID IS NOT NULL
</cfquery>
<cfif isdefined("attributes.process") and len(attributes.process)>
    <cfquery name="get_process_id" datasource="#dsn#">
        SELECT PROCESS_ID FROM PROCESS_MAIN_ROWS WHERE PROCESS_MAIN_ID=#attributes.process# AND PROCESS_ID IS NOT NULL 
    </cfquery>
     <cfif len(get_process_id.process_id)>
		<cfset s_process_id=valuelist(get_process_id.process_id,',')>
    <cfelse>
    	<cfset s_process_id='Null'>
	</cfif>  
</cfif>
<cfif len(attributes.is_submitted)>
	<cfif len(attributes.author_id) and len(attributes.author_name)>
		<cfquery name="GET_ROWS" datasource="#DSN#">
			<cfif attributes.authority_type eq 1 or attributes.authority_type eq 0>
				SELECT
					PROCESS_ROW_ID
				FROM
					PROCESS_TYPE_ROWS_POSID
				WHERE
					PRO_POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.author_id#"> AND
					PROCESS_ROW_ID IS NOT NULL
			</cfif>
			<cfif attributes.authority_type eq 0>
				UNION
			</cfif>
			<cfif attributes.authority_type eq 2 or attributes.authority_type eq 0>
				SELECT
					PROCESS_ROW_ID
				FROM
					PROCESS_TYPE_ROWS_CAUID
				WHERE
					CAU_POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.author_id#"> AND
					PROCESS_ROW_ID IS NOT NULL
			</cfif>
			<cfif attributes.authority_type eq 0>
				UNION
			</cfif>
			<cfif attributes.authority_type eq 3 or attributes.authority_type eq 0>
				SELECT
					PROCESS_ROW_ID
				FROM
					PROCESS_TYPE_ROWS_INFID
				WHERE
					INF_POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.author_id#"> AND
					PROCESS_ROW_ID IS NOT NULL
			</cfif>
		</cfquery>
		<cfif get_rows.recordcount>
			<cfquery name="GET_PRO_ID" datasource="#DSN#">
				SELECT DISTINCT
					PROCESS_ID
				FROM 
					PROCESS_TYPE_ROWS
				WHERE
					PROCESS_ROW_ID IN (#valuelist(get_rows.process_row_id,',')#)
			</cfquery>
         <cfelse>
			<cfset get_pro_id.recordcount = 0>
		</cfif>
	<cfelse>
		<cfset get_pro_id.recordcount = 0>
	</cfif>
	<cfif len(attributes.author_id) and len(attributes.author_name) and get_pro_id.recordcount eq 0 and attributes.authority_type neq 0>
		<cfset GET_PROCESS_TYPE.recordcount = 0>
	<cfelse>
		<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
		 SELECT
				PROCESS_TYPE.PROCESS_ID,
				PROCESS_TYPE.PROCESS_NAME,
				PROCESS_TYPE.FACTION,
				PROCESS_TYPE.IS_ACTIVE,
				PROCESS_TYPE.UPPER_DEP_ID,
				PROCESS_TYPE.RESP_EMP_ID,
				EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME NAME,
				DEPARTMENT.DEPARTMENT_HEAD
			FROM
				PROCESS_TYPE
				LEFT JOIN DEPARTMENT ON PROCESS_TYPE.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
				LEFT JOIN EMPLOYEES ON PROCESS_TYPE.RESP_EMP_ID = EMPLOYEES.EMPLOYEE_ID
			WHERE
				PROCESS_TYPE.PROCESS_ID IS NOT NULL
				<cfif len(attributes.module)>
					AND PROCESS_TYPE.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.module#%">
				</cfif>
				<cfif len(attributes.up_department_id) and len(attributes.up_department)>
					AND PROCESS_TYPE.UPPER_DEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.up_department_id#">
				</cfif>
				<cfif len(attributes.department) and len(attributes.department_id)>
					AND PROCESS_TYPE.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> 
				</cfif>
				<cfif len(attributes.emp_id) and len(attributes.employee_name)>
					AND PROCESS_TYPE.RESP_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"> 
				</cfif>
					AND PROCESS_ID IN
						(
						SELECT 
							PTOC.PROCESS_ID
						FROM 
							PROCESS_TYPE_OUR_COMPANY PTOC
						WHERE 
							PTOC.PROCESS_ID = PROCESS_TYPE.PROCESS_ID 
							<cfif len(attributes.company_id)>
								AND PTOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> 
							<cfelseif len(attributes.c_id)>
								AND PTOC.OUR_COMPANY_ID IN(#attributes.c_id#)
							</cfif>
						)
				<cfif len(attributes.keyword)>
					AND 
					(
						(PROCESS_TYPE.PROCESS_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
						OR
						(PROCESS_TYPE.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
					)
				</cfif>
				<cfif isdefined("attributes.record_id") and len(attributes.record_id) and IsDefined("attributes.record_name") and len(attributes.record_name)>
					AND
						PROCESS_TYPE.RECORD_EMP=#attributes.record_id#
				</cfif>
				<cfif isdefined("attributes.process") and len(attributes.process)>
					AND
						PROCESS_TYPE.PROCESS_ID IN (#s_process_id#)
				</cfif>
				<cfif len(attributes.is_active)>AND PROCESS_TYPE.IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.is_active#"></cfif>
				<cfif GET_PRO_ID.recordcount>AND PROCESS_TYPE.PROCESS_ID IN (#Valuelist(GET_PRO_ID.PROCESS_ID,',')#)</cfif>
			ORDER BY
				PROCESS_NAME	
		</cfquery>
	</cfif>
    <cfif get_process_type.recordcount>
		<cfquery name="get_our_company" datasource="#dsn#">
			SELECT 
				PTOC.OUR_COMPANY_ID,
				PTOC.PROCESS_ID,
				OC.COMP_ID,
				OC.NICK_NAME  
			FROM 
				PROCESS_TYPE_OUR_COMPANY PTOC,
				OUR_COMPANY OC 
			WHERE 
				PTOC.OUR_COMPANY_ID = OC.COMP_ID AND
				PROCESS_ID IN (#ListSort(listDeleteDuplicates(Valuelist(GET_PROCESS_TYPE.PROCESS_ID,',')),"numeric","asc",",")#) 
			ORDER BY 
				OC.NICK_NAME
		</cfquery>
	</cfif>
<cfelse>
	<cfset get_process_type.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_process_type.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent  variable="header"><cf_get_lang dictionary_id="36187.Süreçler"></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_process" method="post" action="#request.self#?fuseaction=process.list_process">
			<input name="is_submitted" id="is_submitted" type="hidden" value="1">
			<cf_box_search>
				<div class="form-group" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group" id="item-process">
					<select name="process" id="process">
							<option value="" selected="selected"><cf_get_lang dictionary_id='36294.süreç'></option>
						<cfoutput query="get_process">
							<option value="#process_main_id#"<cfif attributes.process eq process_main_id>selected</cfif>>#process_main_header#</option>
						</cfoutput>
					</select>
				</div> 
				<div class="form-group" id="item-module">
					<select name="module" id="module">
							<option value="" selected><cf_get_lang dictionary_id ='55060.Modül'></option>
						<cfoutput query="get_modules">
							<option value="#module_short_name#" <cfif module_short_name eq attributes.module> selected</cfif>>#MODULE#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="item-is_active">
					<select name="is_active" id="is_active">
						<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="" <cfif attributes.is_active eq "">selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
					</select>
				</div>
				<div class="form-group" id="item-company_id">
					<select name="company_id" id="company_id">
						<option value="" selected><cf_get_lang dictionary_id='57574.Şirket'></option>
							<cfoutput query="get_company">
								<cfquery name="get_period" datasource="#dsn#">
									SELECT
										PERIOD_ID
									FROM
										SETUP_PERIOD SP,
										OUR_COMPANY OC
									WHERE
										OC.COMP_ID = SP.OUR_COMPANY_ID AND
										OC.COMP_ID = #comp_id#
								</cfquery>
								<cfif get_period.recordcount>
								<cfset temp_per_id=valuelist(get_period.period_id,',')>
								<cfquery name="get_position_id" datasource="#dsn#">
									SELECT EMPLOYEE_ID,EMPLOYEE_NAME,POSITION_ID  FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=#session.ep.userid#
								</cfquery>
								<cfquery name="get_position" datasource="#dsn#">
									SELECT PERIOD_ID FROM EMPLOYEE_POSITION_PERIODS WHERE POSITION_ID=#get_position_id.position_id# AND PERIOD_ID IN (#temp_per_id#)
								</cfquery>
									<cfif get_position.recordcount>
									<option value="#comp_id#" <cfif comp_id eq attributes.company_id>selected</cfif>>#nick_name#</option>
									<cfset list_comp=listappend(list_comp,get_company.comp_id,',')>
								</cfif>
							</cfif>
						</cfoutput>
					</select>
					<input type="hidden" name="c_id" id="c_id" value="<cfoutput>#list_comp#</cfoutput>"/>
				</div>
				<div class="form-group" id="item-authority_type">
					<select name="authority_type" id="authority_type">
						<option value="0" <cfif attributes.authority_type eq 0>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif attributes.authority_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57578.Yetkili'></option>
						<option value="2" <cfif attributes.authority_type eq 2>selected</cfif>><cf_get_lang dictionary_id='36200.Onay ve Uyarılacak'></option>
						<option value="3" <cfif attributes.authority_type eq 3>selected</cfif>><cf_get_lang dictionary_id='58773.Bilgi Verilecek'></option>
					</select>
				</div>
				<div class="form-group" id="item-record_id">
					<div class="input-group">
						<input type="hidden" name="record_id" id="record_id" value="<cfif len(attributes.record_name) and len(attributes.record_id)><cfoutput>#attributes.record_id#</cfoutput></cfif>" >					
						<input type="text" name="record_name" id="record_name" placeholder="<cf_get_lang dictionary_id='57899.Kaydeden'>" value="<cfif len(attributes.record_name) and len(attributes.record_id)><cfoutput>#attributes.record_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('record_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','MEMBER_ID','record_id','','3','125');"  autocomplete="off" >                    
						<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=search_process.record_name&field_emp_id=search_process.record_id&select_list=1')"></span>
					</div>
				</div> 
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" style="width:25px;" onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="#message#">
				</div> 
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<cfoutput>
					<div class="col col-3 col-md-3 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="item-author_id">
							<label><cf_get_lang dictionary_id='57576.Çalışan'></label>
							<div class="input-group">
								<input type="hidden" name="author_id" id="author_id" value="#attributes.author_id#" >
								<input type="text" name="author_name" id="author_name" placeholder="<cf_get_lang dictionary_id='57576.Çalışan'>" value="#attributes.author_name#"  onFocus="AutoComplete_Create('author_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_ID','author_id','','3','125');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_name=search_process.author_name&field_id=search_process.author_id&select_list=1')"></span>                           
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-3 col-sm-6 col-xs-12" index="2" type="column" sort="true">
						<div class="form-group" id="item-employee_name">
							<label><cf_get_lang dictionary_id='57544.Responsible'> </label>
							<div class="input-group">
								<input type="hidden" name="emp_id" id="emp_id" value="#attributes.emp_id#">
								<input type="text" name="employee_name" id="employee_name" value="#attributes.employee_name#" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','MEMBER_ID','emp_id','','3','125');">
								<span class="input-group-addon btn_Pointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_name=search_process.employee_name&field_emp_id=search_process.emp_id&function_name=fill_department&select_list=1')"></span>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-3 col-sm-6 col-xs-12" index="3" type="column" sort="true">
						<div class="form-group" id="item-up_department">
							<label><cf_get_lang dictionary_id='42335.Üst Departman'></label>
							<div class="input-group">
								<input type="hidden" name="up_department_id" id="up_department_id" value="#attributes.up_department_id#">
								<input type="text" name="up_department" id="up_department" value="#attributes.up_department#">
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('#request.self#?fuseaction=hr.popup_list_departments&field_id=search_process.up_department_id&field_name=search_process.up_department');"></span>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-3 col-sm-6 col-xs-12" index="4" type="column" sort="true">
						<div class="form-group" id="item-department">
							<label><cf_get_lang dictionary_id='57572.Departman'></label>
							<div class="input-group">
								<input type="hidden" id="department_id" name="department_id" value="#attributes.department_id#" />
								<input type="text" id="department" name="department" value="#attributes.department#" />
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('#request.self#?fuseaction=hr.popup_list_departments&field_id=search_process.department_id&field_name=search_process.department');"></span>
							</div>
						</div>
					</div>					
				</cfoutput>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#header#" hide_table_column="1" uidrop="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='58859.Süreç'></th>
					<th><cf_get_lang dictionary_id='36202.Aşamalar'></th>
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th>
					<th width="120"><cf_get_lang dictionary_id='42335.Üst Departman'></th>
					<th><cf_get_lang dictionary_id='57572.Departman'></th>
					<th><cf_get_lang dictionary_id='57544.Responsible'></th>
					<th width="20"><a href="javascript://"><i class="fa fa-list" alt="<cf_get_lang dictionary_id='31037.Workflow Designer'>" title="<cf_get_lang dictionary_id='31037.Workflow Designer'>"></i></a></th>
					<th width="20"><a href="<cfoutput>#request.self#?fuseaction=process.list_process&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				
				</tr>
			</thead>
			<tbody>
				<cfif get_process_type.recordcount>
					<cfoutput query="get_process_type" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#" >                 
						<tr>
							<td>#currentrow#</td>
							<td>
								<a href="#request.self#?fuseaction=process.list_process&event=upd&process_id=#process_id#">#process_name#</a>
								<cfquery name="GET_STAGES" datasource="#DSN#">
									SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ID = #PROCESS_ID# ORDER BY LINE_NUMBER
								</cfquery>
								<cfquery name="get_our_company_sub" dbtype="query">
									select our_company_id,nick_name from get_our_company WHERE PROCESS_ID = #get_process_type.process_id#
								</cfquery>
							</td>
							<td><cfloop query="get_stages">#stage#<cfif currentrow lt get_stages.recordcount> --> </cfif></cfloop></td>
							<td>
								<cfloop query="get_our_company_sub">
									#get_our_company_sub.nick_name#&nbsp;
									<cfif get_our_company_sub.currentrow neq get_our_company_sub.recordcount></cfif>
								</cfloop> 
							</td>
							<td ><cfif get_process_type.is_active is 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
							<td>
								<cfif len(upper_dep_id)>
									<cfquery name="departments" datasource="#dsn#">
										SELECT 
											DEPARTMENT_HEAD 
										FROM
											DEPARTMENT
										WHERE 
											DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#upper_dep_id#">
									</cfquery>
									#departments.department_head#
								</cfif>
							</td>
							<td>#department_head#</td>
							<td>#name#</td>
							<td><a href="#request.self#?fuseaction=process.visual_designer&process_id=#process_id#"><i class="fa fa-list" alt="<cf_get_lang dictionary_id='31037.Workflow Designer'>" title="<cf_get_lang dictionary_id='31037.Workflow Designer'>"></i></a></td>
							<td><a href="#request.self#?fuseaction=process.list_process&event=upd&process_id=#process_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<td colspan="10"><cfif len(attributes.is_submitted)><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
						</tr>
				</cfif>
			</tbody>
		</cf_grid_list>  
		<cfset adres='process.list_process'>
		<cfif isdefined("attributes.keyword")>
			<cfset adres = "#adres#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.module")>
			<cfset adres = "#adres#&module=#attributes.module#">
		</cfif>
		<cfif isdefined("attributes.author_name")>
			<cfset adres = "#adres#&author_name=#attributes.author_name#">
		</cfif>
		<cfif isdefined("attributes.authority_type")>
			<cfset adres = "#adres#&authority_type=#attributes.authority_type#">
		</cfif>
		<cfif len(attributes.is_submitted)> 
			<cfset adres = "#adres#&is_submitted=#attributes.is_submitted#">
		</cfif>
		<cfif len(attributes.author_id)> 
			<cfset adres = "#adres#&author_id=#attributes.author_id#">
		</cfif>
		<cfif isdefined("attributes.is_active")>
			<cfset adres = "#adres#&is_active=#attributes.is_active#">
		</cfif>	  
		<cfif isdefined("attributes.company_id")>
			<cfset adres = "#adres#&company_id=#attributes.company_id#">
		</cfif>
		<cfif isdefined("attributes.emp_id")>
			<cfset adres = "#adres#&emp_id=#attributes.emp_id#">
		</cfif>
		<cfif isdefined("attributes.department_id")>
			<cfset adres = "#adres#&department_id=#attributes.department_id#">
		</cfif>
		<cfif isdefined("attributes.up_department_id")>
			<cfset adres = "#adres#&up_department_id=#attributes.up_department_id#">
		</cfif>
		<cfif isdefined("attributes.c_id")><cfset adres = "#adres#&c_id=#attributes.c_id#"></cfif>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
