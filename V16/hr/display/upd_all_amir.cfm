<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfinclude template="../query/get_position_cats2.cfm">
<cfif isdefined("attributes.is_form_submitted")>
	<cfset arama_yapilmali = 0>
<cfelse>
	<cfset arama_yapilmali = 1>
</cfif>
<cfparam name="attributes.empty_position" default="1">
<cfinclude template="../query/get_all_department_branches.cfm">
<cfif arama_yapilmali neq 1>
	<cfquery name="get_standby" datasource="#dsn#">
		SELECT POSITION_CODE,CHIEF1_CODE,CHIEF2_CODE,CHIEF3_CODE FROM EMPLOYEE_POSITIONS_STANDBY
	</cfquery>
	<cfset my_position_codes = valuelist(get_standby.position_code,',')>
	<cfquery name="GET_POSITIONS" datasource="#dsn#">
		SELECT DISTINCT
			EMPLOYEE_POSITIONS.EMPLOYEE_ID,
			EMPLOYEE_POSITIONS.POSITION_CODE,
			EMPLOYEE_POSITIONS.POSITION_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
			DEPARTMENT.DEPARTMENT_ID,
			DEPARTMENT.DEPARTMENT_HEAD,
			BRANCH.COMPANY_ID,
			BRANCH.BRANCH_NAME
		FROM
			EMPLOYEE_POSITIONS,
			DEPARTMENT,
			BRANCH
		WHERE
			EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND
			DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID AND
			<cfif len(attributes.position_cat_id) and attributes.position_cat_id gt 0>
				EMPLOYEE_POSITIONS.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#"> AND
			</cfif>
			<cfif len(attributes.branch_id) and len(attributes.branch_id) and attributes.branch_id is not "all">
				DEPARTMENT.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND
			</cfif>
			<cfif len(attributes.department) and attributes.department gt 0>
				DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#"> AND
			</cfif>
			EMPLOYEE_POSITIONS.POSITION_STATUS = 1
		ORDER BY 
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
			EMPLOYEE_POSITIONS.POSITION_NAME
	</cfquery>	
	<cfset position_code_list = valuelist(GET_POSITIONS.POSITION_CODE,',')>
<cfelse>
	<cfset GET_POSITIONS.recordcount=0>
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_positions.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfscript>
url_string = '';
if (isdefined("attributes.url_param")) url_string = "#url_string#&url_param=#url_param#";
</cfscript>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="58875.Çalışanlar"></cfsavecontent>
<cf_box >
    <cfform action="#request.self#?fuseaction=hr.popup_upd_all_amir#url_string#" method="post" name="search_">
        <cf_box_search>
    <input type="hidden" value="1" name="is_form_submitted" id="is_form_submitted" />
        <!-- sil -->
        <div class="form-group">
            <select name="branch_id" id="branch_id" onchange="showamirDepartment();">
                <option value="all"><cf_get_lang dictionary_id='57453.Şube'></option>
                <cfquery name="get_branch" datasource="#dsn#">
                    SELECT 
                        BRANCH_STATUS, 
                        COMPANY_ID, 
                        BRANCH_ID, 
                        BRANCH_NAME, 
                        USER_NAME, 
                        POSITION_NAME, 
                        RECORD_DATE, 
                        RECORD_EMP, 
                        RECORD_IP, 
                        UPDATE_DATE, 
                        UPDATE_EMP, 
                        UPDATE_IP 
                    FROM 
                        BRANCH 
                    WHERE 
                        BRANCH_STATUS =1 
                    ORDER BY 
                        BRANCH_NAME
                </cfquery>
                <cfoutput query="get_branch">
                    <option value="#branch_id#"<cfif attributes.branch_id eq get_branch.branch_id>selected</cfif>>#branch_name#</option>
                </cfoutput>
            </select>
        </div>
        <div class="form-group" id="DEPARTMENT_PLACE">
            <select name="department" id="department">
                <option value=""><cf_get_lang dictionary_id='57572.Departman'></option>
                <cfif isdefined('attributes.branch_id') and len(attributes.branch_id) and attributes.branch_id is not "all">
                    <cfquery name="get_department" datasource="#dsn#">
                        SELECT 
                            DEPARTMENT_STATUS, 
                            BRANCH_ID, 
                            DEPARTMENT_ID, 
                            DEPARTMENT_HEAD, 
                            RECORD_DATE, 
                            RECORD_EMP, 
                            RECORD_IP, 
                            UPDATE_DATE, 
                            UPDATE_EMP, 
                            UPDATE_IP
                        FROM 
                            DEPARTMENT 
                        WHERE 
                            BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND DEPARTMENT_STATUS =1 AND IS_STORE <> 1 
                        ORDER BY 
                            DEPARTMENT_HEAD
                    </cfquery>
                    <cfoutput query="get_department">
                        <option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department') and attributes.department eq get_department.department_id>selected</cfif>>#DEPARTMENT_HEAD#</option>
                    </cfoutput>
                </cfif>
            </select>
        </div>
        <div class="form-group">
        <select name="position_cat_id" id="position_cat_id" style="width:150px;">
            <option value=""><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></option>
            <cfoutput query="GET_POSITION_CATS">
                <option value="#POSITION_CAT_ID#"<cfif attributes.position_cat_id eq position_cat_id> selected</cfif>>#POSITION_CAT#
            </cfoutput>
        </select>
        </div>
        <div class="form-group">
            <cf_wrk_search_button button_type="4" search_function="kontrol_amir()">
        </div>
        <!-- sil -->
    </cf_box_search>
    </cfform>
</cf_box>
<cf_box title="#message#">
<cfform action="#request.self#?fuseaction=hr.emptypopup_upd_all_amir" method="post" name="add_">
<cf_grid_list>
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
            <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
            <th><cf_get_lang dictionary_id='29666.Amir'> 1</th>
            <th><cf_get_lang dictionary_id='29666.Amir'> 2</th>
            <th><cf_get_lang dictionary_id='56094.Görüş Bildirecek'></th>
        </tr>		
    </thead>
		<cfif get_positions.recordcount>
            <input type="hidden" name="loop_count" id="loop_count" value="<cfoutput>#get_positions.recordcount#</cfoutput>">
            <input type="hidden" name="branchid" id="branchid" value="<cfoutput>#attributes.branch_id#</cfoutput>">
            <input type="hidden" name="departmentid" id="departmentid" value="<cfoutput>#attributes.department#</cfoutput>">
            <input type="hidden" name="positioncatid" id="positioncatid" value="<cfoutput>#attributes.position_cat_id#</cfoutput>">
            <thead>
				<cfoutput>
                    <tr>
                        <th>&nbsp;</th>
                        <th>&nbsp;</th>
                        <th>
                            <div class="form-group">
                                <input name="chief1_code" id="chief1_code" type="hidden" value="">
                                <div class="col col-6">
                                <input name="chief1_emp" id="chief1_emp" type="text"  value="">
                                </div>
                                <div class="col col-6">
                            <div class="input-group">
							<input name="chief1_name" id="chief1_name" type="text" value=""> 
							<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_positions&field_code=add_.chief1_code&field_emp_name=add_.chief1_emp&field_pos_name=add_.chief1_name&call_function=set_amir_1()','list','popup_list_positions');"></span>
                            </div>
                        </div>
                        </div>
                        </th>
                        <th>
                            <div class="form-group">
							<input name="chief2_code" id="chief2_code" type="hidden" value="">
                            <div class="col col-6">
							<input name="chief2_emp" id="chief2_emp" type="text" value="">
                            </div>
                            <div class="col col-6">
                                <div class="input-group">
							<input name="chief2_name" id="chief2_name" type="text"  value=""> 
							<span class="input-group-addon icon-ellipsis btnPointer"  href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_positions&field_code=add_.chief2_code&field_emp_name=add_.chief2_emp&field_pos_name=add_.chief2_name&call_function=set_amir_2();','list','popup_list_positions');"></span>
                        </div>
                        </div>
                        </div>
                        </th>
                        <th>
                            <div class="form-group">
							<input name="chief3_code" id="chief3_code" type="hidden" value="">
                            <div class="col col-6">
							<input name="chief3_emp" id="chief3_emp" type="text"  value="">
                            </div>
                            <div class="col col-6">
                                <div class="input-group">
							<input name="chief3_name" id="chief3_name" type="text"  value=""> 
							<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_positions&field_code=add_.chief3_code&field_emp_name=add_.chief3_emp&field_pos_name=add_.chief3_name&call_function=set_amir_3();','list','popup_list_positions');"></span>
                        </div>
                        </div>
                        </div>
                        </th>
                     </tr>
                 </cfoutput>
             </thead>
            <cfoutput query="get_positions">
                <input type="hidden" name="position_code_#currentrow#" id="position_code_#currentrow#" value="#position_code#">
                <cfquery name="get_position_chiefs" dbtype="query">
                    SELECT CHIEF1_CODE,CHIEF2_CODE,CHIEF3_CODE FROM get_standby WHERE POSITION_CODE = #POSITION_CODE#
                </cfquery>
                <tbody>					 
                  <tr>
                    <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                    <td>#POSITION_NAME#</td>
                    <td>
                        <cfset c_code_ = ''>
                        <cfset c_name_ = ''>
                        <cfset c_position_ = ''>
                        <cfif len(get_position_chiefs.CHIEF1_CODE)>
                            <cfquery name="GET_EMP_INFO_" datasource="#dsn#">
                                SELECT
                                    POSITION_NAME,POSITION_CODE,EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID
                                FROM
                                    EMPLOYEE_POSITIONS
                                WHERE
                                    POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_position_chiefs.chief1_code#">
                            </cfquery>
                            <cfset c_code_ = '#GET_EMP_INFO_.POSITION_CODE#'>
                            <cfset c_name_ = '#GET_EMP_INFO_.EMPLOYEE_NAME# #GET_EMP_INFO_.EMPLOYEE_SURNAME#'>
                            <cfset c_position_ = '#GET_EMP_INFO_.POSITION_NAME#'>
                        </cfif>
                        <div class="form-group">
                        <input name="chief1_code_#currentrow#" id="chief1_code_#currentrow#" type="hidden" value="#c_code_#">
                        <div class="col col-6">
                        <input name="chief1_emp_#currentrow#" id="chief1_emp_#currentrow#" type="text"  value="#c_name_#">
                        </div>
                        <div class="col col-6">
                        <div class="input-group">
                        <input name="chief1_name_#currentrow#" id="chief1_name_#currentrow#" type="text"  value="#c_position_#">
                        <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_positions&field_code=add_.chief1_code_#currentrow#&field_emp_name=add_.chief1_emp_#currentrow#&field_pos_name=add_.chief1_name_#currentrow#','list','popup_list_positions');"></span>
                        </div>
                        </div>
                        </div>
                    </td>
                    <td><cfset c_code_ = ''>
                        <cfset c_name_ = ''>
                        <cfset c_position_ = ''>
                        <cfif len(get_position_chiefs.CHIEF2_CODE)>
                            <cfquery name="GET_EMP_INFO_" datasource="#dsn#">
                                SELECT
                                    POSITION_NAME,POSITION_CODE,EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID
                                FROM
                                    EMPLOYEE_POSITIONS
                                WHERE
                                    POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_position_chiefs.chief2_code#">
                            </cfquery>
                            <cfset c_code_ = '#GET_EMP_INFO_.POSITION_CODE#'>
                            <cfset c_name_ = '#GET_EMP_INFO_.EMPLOYEE_NAME# #GET_EMP_INFO_.EMPLOYEE_SURNAME#'>
                            <cfset c_position_ = '#GET_EMP_INFO_.POSITION_NAME#'>
                        </cfif>
                        <div class="form-group">
                        <input name="chief2_code_#currentrow#" id="chief2_code_#currentrow#" type="hidden" value="#c_code_#">
                        <div class="col col-6">
                        <input name="chief2_emp_#currentrow#" id="chief2_emp_#currentrow#" type="text" value="#c_name_#">
                        </div>
                        <div class="col col-6">
                        <div class="input-group">
                        <input name="chief2_name_#currentrow#" id="chief2_name_#currentrow#" type="text" value="#c_position_#">
                        <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_positions&field_code=add_.chief2_code_#currentrow#&field_emp_name=add_.chief2_emp_#currentrow#&field_pos_name=add_.chief2_name_#currentrow#','list','popup_list_positions');"></span>
                        </div>
                        </div>
                        </div>
                    </td>
                    <td><cfset c_code_ = ''>
                        <cfset c_name_ = ''>
                        <cfset c_position_ = ''>
                        <cfif len(get_position_chiefs.CHIEF3_CODE)>
                            <cfquery name="GET_EMP_INFO_" datasource="#dsn#">
                                SELECT
                                    POSITION_NAME,POSITION_CODE,EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID
                                FROM
                                    EMPLOYEE_POSITIONS
                                WHERE
                                    POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_position_chiefs.chief3_code#">
                            </cfquery>
                            <cfset c_code_ = '#GET_EMP_INFO_.POSITION_CODE#'>
                            <cfset c_name_ = '#GET_EMP_INFO_.EMPLOYEE_NAME# #GET_EMP_INFO_.EMPLOYEE_SURNAME#'>
                            <cfset c_position_ = '#GET_EMP_INFO_.POSITION_NAME#'>
                        </cfif>
                        <div class="form-group">
                        <input name="chief3_code_#currentrow#" id="chief3_code_#currentrow#" type="hidden" value="#c_code_#">
                        <div class="col col-6">
                        <input name="chief3_emp_#currentrow#" id="chief3_emp_#currentrow#" type="text" style="width:100px;" value="#c_name_#">
                        </div>
                        <div class="col col-6">
                        <div class="input-group">
                        <input name="chief3_name_#currentrow#" id="chief3_name_#currentrow#" type="text" style="width:100px;" value="#c_position_#">
                        <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_positions&field_code=add_.chief3_code_#currentrow#&field_emp_name=add_.chief3_emp_#currentrow#&field_pos_name=add_.chief3_name_#currentrow#','list','popup_list_positions');"></span>
                        </div>
                        </div>
                        </div>
                    </td>
                  </tr>
                </tbody>
            </cfoutput>
            <tfoot>
                <tr>
                    <td colspan="5"><cf_workcube_buttons is_upd='0' type_format="1"></td>
                </tr>
            </tfoot>
        <cfelse>
        	<tbody>
                <tr>
                    <td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                </tr>
            </tbody>
        </cfif>
    </cf_grid_list>
</cfform>
</cf_box>
<script>
	function set_amir_1()
	{
		for(yerel_i=1 ; yerel_i <= <cfoutput>#get_positions.recordcount#</cfoutput> ; yerel_i++)
		{
			eval("document.add_.chief1_code_"+yerel_i).value = document.getElementById('chief1_code').value;
			eval("document.add_.chief1_emp_"+yerel_i).value = document.getElementById('chief1_emp').value;
			eval("document.add_.chief1_name_"+yerel_i).value = document.getElementById('chief1_name').value;
		}
	}
	
	function set_amir_2()
	{
		for(yerel_i=1 ; yerel_i <= <cfoutput>#get_positions.recordcount#</cfoutput> ; yerel_i++)
		{
			eval("document.add_.chief2_code_"+yerel_i).value = document.getElementById('chief2_code').value;
			eval("document.add_.chief2_emp_"+yerel_i).value = document.getElementById('chief2_emp').value;
			eval("document.add_.chief2_name_"+yerel_i).value = document.getElementById('chief2_name').value;
		}
	}
	
	function set_amir_3()
	{
		for(yerel_i=1 ; yerel_i <= <cfoutput>#get_positions.recordcount#</cfoutput> ; yerel_i++)
		{
			eval("document.add_.chief3_code_"+yerel_i).value = document.getElementById('chief3_code').value;
			eval("document.add_.chief3_emp_"+yerel_i).value = document.getElementById('chief3_emp').value;
			eval("document.add_.chief3_name_"+yerel_i).value = document.getElementById('chief3_name').value;
		}
	}
	
	function kontrol_amir()
	{
		if((document.getElementById('branch_id').value == '' || document.getElementById('branch_id').value == '0') && document.getElementById('position_cat_id').value == '')
		{
			alert('<cf_get_lang dictionary_id="55637.Şube veya Pozisyon Tipi Seçmelisiniz">!');
			return false;
		}
		return true;
	}
	
	function showamirDepartment()	
		{
			var branch_id = document.getElementById('branch_id').value;
			if (branch_id != "" && branch_id != "0")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
			}
		}
</script>
