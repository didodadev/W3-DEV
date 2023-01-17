<cfif not isdefined("attributes.department_id")>
	<cfset arama_yapilmali = 1>
<cfelse>
	<cfset arama_yapilmali = 0>
</cfif>
<cfparam name="attributes.empty_position" default="1">
<cfparam name="attributes.hierarchy" default="">
<cfif len(session.ep.authority_code_hr)>
	<cfset emp_code_list = ListChangeDelims(session.ep.authority_code_hr, "+", ".")>
	<cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy)>
		<cfset emp_code_list = ListAppend(emp_code_list, ListChangeDelims(attributes.hierarchy, "+", "."), "+")>
	</cfif>
<cfelseif isdefined("attributes.hierarchy") and len(attributes.hierarchy)>
	<cfset emp_code_list = ListChangeDelims(attributes.hierarchy, "+", ".")>
<cfelse>
	<cfset emp_code_list = "">
</cfif>
<cfquery name="ALL_BRANCHES" datasource="#DSN#">
    SELECT 
        B.BRANCH_NAME,
        B.BRANCH_ID,
        D.DEPARTMENT_HEAD,
        D.DEPARTMENT_ID
    FROM
        BRANCH B,
        DEPARTMENT D
    WHERE
        D.BRANCH_ID = B.BRANCH_ID AND
        B.SSK_NO IS NOT NULL AND
        B.SSK_OFFICE IS NOT NULL AND
        B.SSK_BRANCH IS NOT NULL AND
        B.SSK_NO <> '' AND
        B.SSK_OFFICE <> '' AND
        B.SSK_BRANCH <> '' AND
        B.BRANCH_STATUS = 1 AND
        D.DEPARTMENT_STATUS=1 AND
		D.IS_STORE <> 1
    <cfif not session.ep.ehesap>
        AND B.BRANCH_ID IN 
        (
            SELECT
                BRANCH_ID
            FROM
                EMPLOYEE_POSITION_BRANCHES
            WHERE
                POSITION_CODE = #SESSION.EP.POSITION_CODE# AND
                DEPARTMENT_ID IS NULL
        )
    </cfif>
	ORDER BY
		B.BRANCH_NAME
</cfquery>

<cfif arama_yapilmali neq 1>
	<cfquery name="get_standby" datasource="#dsn#">
		SELECT * FROM EMPLOYEE_POSITIONS_STANDBY
	</cfquery>
	<cfset my_position_codes = valuelist(get_standby.position_code,',')>
	<cfquery name="GET_POSITIONS" datasource="#dsn#">
		SELECT DISTINCT
			EMPLOYEE_POSITIONS.EMPLOYEE_ID,
			EMPLOYEE_POSITIONS.POSITION_ID,
			EMPLOYEE_POSITIONS.POSITION_CODE,
			EMPLOYEE_POSITIONS.POSITION_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_EMAIL,
			EMPLOYEE_POSITIONS.IS_VEKALETEN,
			EMPLOYEE_POSITIONS.VEKALETEN_DATE,
			DEPARTMENT.DEPARTMENT_ID,
			DEPARTMENT.HIERARCHY_DEP_ID,
			DEPARTMENT.ADMIN1_POSITION_CODE,
			DEPARTMENT.ADMIN2_POSITION_CODE,
			DEPARTMENT.DEPARTMENT_HEAD,
			BRANCH.COMPANY_ID,
			BRANCH.BRANCH_NAME,
			ZONE.ZONE_NAME
		FROM
		<cfif isdefined("attributes.empty_position") and (attributes.empty_position eq 1) and (not session.ep.ehesap)>
			EMPLOYEES_IN_OUT,
		</cfif>
			EMPLOYEE_POSITIONS,
			DEPARTMENT,
			BRANCH,		
			ZONE
		WHERE
			<cfif get_standby.recordcount>EMPLOYEE_POSITIONS.POSITION_CODE NOT IN (#my_position_codes#) AND</cfif>
			EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND
			DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID AND
		<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
			DEPARTMENT.DEPARTMENT_ID = #attributes.department_id# AND
		</cfif>
			BRANCH.ZONE_ID=ZONE.ZONE_ID		  
		<cfif isdefined("attributes.empty_position") and (attributes.empty_position eq 0)>
			AND EMPLOYEE_POSITIONS.EMPLOYEE_ID = 0
		<cfelseif isdefined("attributes.empty_position") and (attributes.empty_position eq 1)>
			AND EMPLOYEE_POSITIONS.EMPLOYEE_ID <> 0
			AND EMPLOYEE_POSITIONS.EMPLOYEE_ID IS NOT NULL
			<cfif not session.ep.ehesap>
				AND EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
				AND EMPLOYEES_IN_OUT.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #SESSION.EP.POSITION_CODE# )
			</cfif>
		</cfif> 
			AND EMPLOYEE_POSITIONS.POSITION_STATUS = 1
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				AND
				(
				EMPLOYEE_POSITIONS.POSITION_NAME LIKE '%#attributes.keyword#%' OR
				EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE '%#attributes.keyword#%' OR
				EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
				)
		</cfif>	
		<cfif fusebox.dynamic_hierarchy>
		<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
			<cfif database_type is "MSSQL">
				AND 
				('.' + EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY + '.' + EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
			<cfelseif database_type is "DB2">
				AND 
				('.' || EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY || '.' || EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
			</cfif>
		</cfloop>
	<cfelse>
		<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
			<cfif database_type is "MSSQL">
				AND ('.' + EMPLOYEE_POSITIONS.HIERARCHY + '.') LIKE '%.#code_i#.%'
			<cfelseif database_type is "DB2">
				AND ('.' || EMPLOYEE_POSITIONS.HIERARCHY || '.') LIKE '%.#code_i#.%'
			</cfif>
		</cfloop>
	</cfif>
		ORDER BY 
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME,
			EMPLOYEE_POSITIONS.POSITION_NAME
	</cfquery>	
<cfelse>
	<cfset GET_POSITIONS.recordcount=0>
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_positions.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfscript>
url_string = '';
if (isdefined('attributes.show_empty_pos')) url_string = '#url_string#&show_empty_pos=#show_empty_pos#';
if (isdefined("attributes.url_param")) url_string = "#url_string#&url_param=#url_param#";
</cfscript>
<cf_medium_list_search title="#getLang('hr',1306)#">
  <cfform action="#request.self#?fuseaction=hr.popup_add_all_amir#url_string#" method="post" name="search">
    <cf_medium_list_search_area>
       <table>
            <tr>
              <td><cf_get_lang dictionary_id="57460.Filtre">:</td>
              <td>
                <select name="department_id" id="department_id">
                    <cfoutput query="ALL_BRANCHES">
                        <option value="#department_id#"<cfif isdefined("attributes.department_id") and (department_id eq attributes.department_id)> selected</cfif>>#BRANCH_NAME# - #department_head#</option>
                    </cfoutput>
                </select>
              <td nowrap><cf_get_lang dictionary_id="57789.Özel Kod"></td>
              <td><cfinput type="text" name="hierarchy" style="width:100px;" value="#attributes.hierarchy#" maxlength="50"></td>
              </td>
              <td><cf_wrk_search_button></td>          
           </tr>
       </table>
    </cf_medium_list_search_area>
  </cfform>
</cf_medium_list_search>
  <cf_medium_list>
  	<thead>
          <tr>
            <th width="120"><cf_get_lang dictionary_id="57570.Ad Soyad"></th>
            <th><cf_get_lang dictionary_id="58497.Pozisyon"></th>
            <th width="130"><cf_get_lang dictionary_id="29666.Amir">1</th>
            <th width="130"><cf_get_lang dictionary_id="29666.Amir">2</th>
            <th width="130"><cf_get_lang dictionary_id="56094.Görüş Bildirecek"></th>
          </tr>	
   </thead> 
		<cfif get_positions.recordcount>
            <cfform action="#request.self#?fuseaction=hr.emptypopup_add_all_amir" method="post" name="add_">
                <input type="hidden" name="loop_count" id="loop_count" value="<cfoutput>#get_positions.recordcount#</cfoutput>">
             <tbody>
                <cfoutput>
                <tr>
                    <td colspan="2"><cf_get_lang dictionary_id="56095.Toplu olarak seçmek istiyorsanız bu satırdaki amir ve görüş bildirecekleri seçmeniz yeterlidir">!</td>
                    <td nowrap="nowrap">
                        <input name="chief1_code" id="chief1_code" type="hidden" value="">
                        <input name="chief1_emp" id="chief1_emp" type="text" style="width:120px;" readonly value="">
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_positions&field_code=add_.chief1_code&field_emp_name=add_.chief1_emp&field_pos_name=add_.chief1_name','list','popup_list_positions');"><img src="/images/plus_thin.gif" border="0"></a>
                        <input name="chief1_name" id="chief1_name" type="text" style="width:120px;" readonly value=""> 
                    </td>
                    <td nowrap="nowrap">
                        <input name="chief2_code" id="chief2_code" type="hidden" value="">
                        <input name="chief2_emp" id="chief2_emp" type="text" style="width:120px;" readonly value="">
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_positions&field_code=add_.chief2_code&field_emp_name=add_.chief2_emp&field_pos_name=add_.chief2_name','list','popup_list_positions');"><img src="/images/plus_thin.gif" border="0"></a>
                        <input name="chief2_name" id="chief2_name" type="text" style="width:120px;" readonly value=""> 
                    </td>
                    <td nowrap="nowrap">
                        <input name="chief3_code" id="chief3_code" type="hidden" value="">
                        <input name="chief3_emp" id="chief3_emp" type="text" style="width:120px;" readonly value="">
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_positions&field_code=add_.chief3_code&field_emp_name=add_.chief3_emp&field_pos_name=add_.chief3_name','list','popup_list_positions');"><img src="/images/plus_thin.gif" border="0"></a>
                        <input name="chief3_name" id="chief3_name" type="text" style="width:120px;" readonly value=""> 
                    </td>
                 </tr>
                 </cfoutput>
                <cfoutput query="get_positions">
                     <input type="hidden" name="position_code_#currentrow#" id="position_code_#currentrow#" value="#POSITION_CODE#">
                     <tr>
                        <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                        <td>#POSITION_NAME#</td>
                        <td nowrap="nowrap">
                            <input name="chief1_code_#currentrow#" id="chief1_code_#currentrow#" type="hidden" value="">
                            <input name="chief1_emp_#currentrow#" id="chief1_emp_#currentrow#" type="text" style="width:120px;" readonly value="">
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_positions&field_code=add_.chief1_code_#currentrow#&field_emp_name=add_.chief1_emp_#currentrow#&field_pos_name=add_.chief1_name_#currentrow#','list','popup_list_positions');"><img src="/images/plus_thin.gif" border="0"></a>
                            <input name="chief1_name_#currentrow#" id="chief1_name_#currentrow#" type="text" style="width:120px;" readonly value=""> 
                        </td>
                        <td nowrap="nowrap">
                            <input name="chief2_code_#currentrow#" id="chief2_code_#currentrow#" type="hidden" value="">
                            <input name="chief2_emp_#currentrow#" id="chief2_emp_#currentrow#" type="text" style="width:120px;" readonly value="">
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_positions&field_code=add_.chief2_code_#currentrow#&field_emp_name=add_.chief2_emp_#currentrow#&field_pos_name=add_.chief2_name_#currentrow#','list','popup_list_positions');"><img src="/images/plus_thin.gif" border="0"></a>
                            <input name="chief2_name_#currentrow#" id="chief2_name_#currentrow#" type="text" style="width:120px;" readonly value=""> 
                        </td>
                        <td nowrap="nowrap">
                            <input name="chief3_code_#currentrow#" id="chief3_code_#currentrow#" type="hidden" value="">
                            <input name="chief3_emp_#currentrow#" id="chief3_emp_#currentrow#" type="text" style="width:120px; vertical-align:bottom" readonly value="">
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_positions&field_code=add_.chief3_code_#currentrow#&field_emp_name=add_.chief3_emp_#currentrow#&field_pos_name=add_.chief3_name_#currentrow#','list','popup_list_positions');"><img src="/images/plus_thin.gif" border="0"></a>
                            <input name="chief3_name_#currentrow#" id="chief3_name_#currentrow#" type="text" style="width:120px;" readonly value=""> 
                        </td>
                      </tr>
                </cfoutput>
             </tbody>
             <tfoot>
                <tr>
                    <td colspan="7"style="text-align:right;"><cf_workcube_buttons is_upd='0' type_format="1"></td>
                </tr>
             </tfoot>
            </cfform>
        <cfelse>
        	<tbody>
                <tr>
                    <td colspan="7"><cf_get_lang dictionary_id="57701.Filtre Ediniz">!</td>
                </tr>
            </tbody>
        </cfif>
	</tbody>
</cf_medium_list>
