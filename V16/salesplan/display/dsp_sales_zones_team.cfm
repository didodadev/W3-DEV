<cf_xml_page_edit fuseact="salesplan.popup_add_sales_zones_team" is_multi_page="1">
<cfparam name="attributes.upper_filter" default="">
<cfif xml_select_upper_team>
    <cfquery name="GET_SALES_ZONES_TEAM" datasource="#DSN#">
        SELECT DISTINCT
            UST_TAKIM.TEAM_ID, 
            UST_TAKIM.TEAM_NAME, 
            UST_TAKIM.SALES_ZONES, 
            UST_TAKIM.OZEL_KOD, 
            UST_TAKIM.RESPONSIBLE_BRANCH_ID, 
            UST_TAKIM.LEADER_POSITION_CODE, 
            UST_TAKIM.LEADER_POSITION_ROLE_ID, 
            UST_TAKIM.COUNTRY_ID, 
            UST_TAKIM.CITY_ID,
            UST_TAKIM.COUNTY_ID, 
            UST_TAKIM.DISTRICT_ID, 
            UST_TAKIM.RECORD_DATE, 
            UST_TAKIM.RECORD_EMP, 
            UST_TAKIM.RECORD_IP, 
            UST_TAKIM.UPDATE_DATE, 
            UST_TAKIM.UPDATE_EMP, 
            UST_TAKIM.UPDATE_IP, 
            UST_TAKIM.COMPANY_CAT_IDS, 
            UST_TAKIM.CONSUMER_CAT_IDS,
            UST_TAKIM.UPPER_TEAM_ID
            <cfif isdefined("attributes.upper_filter") and attributes.upper_filter neq 1>
            ,ALT_TAKIM.TEAM_ID AS TEAM_ID2, 
            ALT_TAKIM.TEAM_NAME AS TEAM_NAME2, 
            ALT_TAKIM.SALES_ZONES AS SALES_ZONES2, 
            ALT_TAKIM.OZEL_KOD AS OZEL_KOD2, 
            ALT_TAKIM.RESPONSIBLE_BRANCH_ID AS RESPONSIBLE_BRANCH_ID2, 
            ALT_TAKIM.LEADER_POSITION_CODE AS LEADER_POSITION_CODE2, 
            ALT_TAKIM.LEADER_POSITION_ROLE_ID AS LEADER_POSITION_ROLE_ID2, 
            ALT_TAKIM.COUNTRY_ID AS COUNTRY_ID2, 
            ALT_TAKIM.CITY_ID AS CITY_ID2,
            ALT_TAKIM.COUNTY_ID AS COUNTY_ID2, 
            ALT_TAKIM.DISTRICT_ID AS DISTRICT_ID2, 
            ALT_TAKIM.RECORD_DATE AS RECORD_DATE2, 
            ALT_TAKIM.RECORD_EMP AS RECORD_EMP2, 
            ALT_TAKIM.RECORD_IP AS RECORD_IP2, 
            ALT_TAKIM.UPDATE_DATE AS UPDATE_DATE2, 
            ALT_TAKIM.UPDATE_EMP AS UPDATE_EMP2, 
            ALT_TAKIM.UPDATE_IP AS UPDATE_IP2, 
            ALT_TAKIM.COMPANY_CAT_IDS AS COMPANY_CAT_IDS2, 
            ALT_TAKIM.CONSUMER_CAT_IDS AS CONSUMER_CAT_IDS2,
            ALT_TAKIM.UPPER_TEAM_ID AS UPPER_TEAM_ID2
            </cfif> 
         FROM 
            SALES_ZONES_TEAM ALT_TAKIM RIGHT JOIN
            SALES_ZONES_TEAM UST_TAKIM
        ON
            ALT_TAKIM.UPPER_TEAM_ID = UST_TAKIM.TEAM_ID
        WHERE 
            UST_TAKIM.SALES_ZONES = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sz_id#"><cfif isdefined("attributes.upper_filter") and attributes.upper_filter eq 1>AND UST_TAKIM.UPPER_TEAM_ID IS NULL </cfif>
        ORDER BY 
            UST_TAKIM.TEAM_NAME
    </cfquery>
<cfelse>
    <cfquery name="GET_SALES_ZONES_TEAM" datasource="#DSN#">
        SELECT
            TEAM_ID, 
            TEAM_NAME, 
            SALES_ZONES, 
            OZEL_KOD, 
            RESPONSIBLE_BRANCH_ID, 
            LEADER_POSITION_CODE, 
            LEADER_POSITION_ROLE_ID, 
            COUNTRY_ID, 
            CITY_ID,
            <!---COUNTY_ID, 
            DISTRICT_ID, --->
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP, 
            UPDATE_DATE, 
            UPDATE_EMP, 
            UPDATE_IP, 
            COMPANY_CAT_IDS, 
            CONSUMER_CAT_IDS,
            UPPER_TEAM_ID
        FROM 
            SALES_ZONES_TEAM
        WHERE 
            SALES_ZONES = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sz_id#"> 
        ORDER BY 
            TEAM_NAME
    </cfquery>
</cfif>
<cfif xml_select_upper_team>
    <cf_box_search>
        <cfform name="myform" method="post" action="#request.self#?fuseaction=salesplan.list_plan&event=upd&sz_id=#attributes.sz_id#">
            <div class="form-group">
                <select name="upper_filter" id="upper_filter">
                    <option value="1" <cfif isdefined("attributes.upper_filter") and attributes.upper_filter eq 1>selected</cfif>><cf_get_lang dictionary_id='60874.Üst Takımlar Gelsin'></option>
                    <option value="2" <cfif isdefined("attributes.upper_filter") and attributes.upper_filter eq 2>selected</cfif>><cf_get_lang dictionary_id='58081.Hepsi'></option>
                </select>
                <cf_wrk_search_button is_excel='0' button_type="4">
            </div>  
        </cfform>
    </cf_box_search>
</cfif>
<cf_grid_list>
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='58511.Takım'></th>
            <th><cf_get_lang dictionary_id='41474.Ekip Lideri'></th>
            <th><cf_get_lang dictionary_id='41475.Ekip'></th>
            <th><cf_get_lang dictionary_id='42014.Rol'></th>
            <th><cf_get_lang dictionary_id='41477.IMS Kodları'></th>
            <th width="20"></th>
        </tr>
    </thead>
    <tbody>
        <cfset upper_id_ = "">
        <cfif get_sales_zones_team.recordcount>
            <cfif isdefined("attributes.upper_filter") and attributes.upper_filter eq 2>
                <cfoutput query="get_sales_zones_team"> 
                <cfif isdefined("team_id2") and len(team_id2)>
                    <cfquery name="GET_ROLES" datasource="#DSN#">
                        SELECT 
                            ROLE_ID, 
                            POSITION_CODE 
                        FROM 
                            SALES_ZONES_TEAM_ROLES
                        WHERE 
                            TEAM_ID = #team_id2#
                    </cfquery>
                    <cfquery name="GET_IMS_CODES" datasource="#DSN#">
                        SELECT 
                            SETUP_IMS_CODE.IMS_CODE_ID,
                            SETUP_IMS_CODE.IMS_CODE, 
                            SETUP_IMS_CODE.IMS_CODE_NAME 
                        FROM 
                            SETUP_IMS_CODE,
                            SALES_ZONES_TEAM_IMS_CODE AS SALES_ZONES_TEAM_IMS_CODE
                        WHERE 
                            SALES_ZONES_TEAM_IMS_CODE.TEAM_ID = #team_id2# AND
                            SALES_ZONES_TEAM_IMS_CODE.IMS_ID = SETUP_IMS_CODE.IMS_CODE_ID 
                    </cfquery>
                 </cfif>
                    <cfif not listfind(upper_id_,upper_team_id2)>
                        <cfset upper_id_ = listappend(upper_id_,upper_team_id2)>
                        <cfquery name="GET_ROLES" datasource="#DSN#">
                            SELECT 
                                ROLE_ID, 
                                POSITION_CODE 
                            FROM 
                                SALES_ZONES_TEAM_ROLES
                            WHERE 
                                TEAM_ID = #team_id#
                        </cfquery>
                        <cfquery name="GET_IMS_CODES" datasource="#DSN#">
                            SELECT 
                                SETUP_IMS_CODE.IMS_CODE_ID,
                                SETUP_IMS_CODE.IMS_CODE, 
                                SETUP_IMS_CODE.IMS_CODE_NAME 
                            FROM 
                                SETUP_IMS_CODE,
                                SALES_ZONES_TEAM_IMS_CODE AS SALES_ZONES_TEAM_IMS_CODE
                            WHERE 
                                SALES_ZONES_TEAM_IMS_CODE.TEAM_ID = #team_id# AND
                                SALES_ZONES_TEAM_IMS_CODE.IMS_ID = SETUP_IMS_CODE.IMS_CODE_ID 
                        </cfquery>                
                        <tr>
                           <!--- <td>#currentrow#</td>--->
                            <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_company_info&team_id=#team_id#','list');" class="tableyazi">#team_name#</a></td>
                            <td><cfif len(leader_position_code)>#get_emp_info(leader_position_code,1,1)#</cfif></td>
                            <td>
                            <cfloop query="get_roles">
                                <cfquery name="GET_EMP_NAME" datasource="#DSN#">
                                SELECT 
                                    EMPLOYEE_NAME,
                                    EMPLOYEE_SURNAME,
                                    EMPLOYEE_ID,
                                    POSITION_CODE
                                FROM				
                                    EMPLOYEE_POSITIONS
                                WHERE
                                    POSITION_CODE = #get_roles.position_code#
                                </cfquery>		
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#GET_EMP_NAME.EMPLOYEE_ID#','list');" class="tableyazi">#get_emp_name.employee_name# #get_emp_name.employee_surname#</a><br/>
                            </cfloop></td>
                            <td>
                                <cfloop query="get_roles">
                                    <cfif len(get_roles.role_id)>
                                        <cfquery name="GET_SETUP_ROLES" datasource="#DSN#">
                                            SELECT PROJECT_ROLES FROM SETUP_PROJECT_ROLES WHERE PROJECT_ROLES_ID = #get_roles.role_id#
                                        </cfquery>
                                        <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_company_info&position_code=#get_roles.position_code#'');" class="tableyazi">#get_setup_roles.project_roles#</a><br/>
                                    </cfif>
                                </cfloop>
                            </td>
                            <td><cfloop query="get_ims_codes"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_company_info&ims_id=#get_ims_codes.ims_code_id#');" class="tableyazi">#get_ims_codes.ims_code# #get_ims_codes.ims_code_name#<br/></a></cfloop></td>
                            <td width="15"><cfif not listfindnocase(denied_pages,'list_sales_team&event=upd')><a href="javascript:windowopen('#request.self#?fuseaction=salesplan.list_sales_team&event=upd&team_id=#team_id#&sz_id=#sz_id#','wide');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></cfif></td>
                        </tr>
                    </cfif>
                    <cfif isdefined("team_id2") and len(team_id2)>
                    <tr>
                        <!---<td>#currentrow#</td>--->
                        <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_company_info&team_id=#team_id2#');" class="tableyazi">#team_name2#</a></td>
                        <td><cfif len(leader_position_code2)>#get_emp_info(leader_position_code2,1,1)#</cfif></td>
                        <td>
                        <cfloop query="get_roles">
                            <cfquery name="GET_EMP_NAME" datasource="#DSN#">
                            SELECT 
                                EMPLOYEE_NAME,
                                EMPLOYEE_SURNAME,
                                EMPLOYEE_ID,
                                POSITION_CODE
                            FROM				
                                EMPLOYEE_POSITIONS
                            WHERE
                                POSITION_CODE = #get_roles.position_code#
                            </cfquery>		
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#GET_EMP_NAME.EMPLOYEE_ID#','list');" class="tableyazi">#get_emp_name.employee_name# #get_emp_name.employee_surname#</a><br/>
                        </cfloop></td>
                        <td>
                            <cfloop query="get_roles">
                                <cfif len(get_roles.role_id)>
                                    <cfquery name="GET_SETUP_ROLES" datasource="#DSN#">
                                        SELECT PROJECT_ROLES FROM SETUP_PROJECT_ROLES WHERE PROJECT_ROLES_ID = #get_roles.role_id#
                                    </cfquery>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_company_info&position_code=#get_roles.position_code#','list');" class="tableyazi">#get_setup_roles.project_roles#</a><br/>
                                </cfif>
                            </cfloop>
                        </td>
                        <td><cfloop query="get_ims_codes"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_company_info&ims_id=#get_ims_codes.ims_code_id#','list');" class="tableyazi">#get_ims_codes.ims_code# #get_ims_codes.ims_code_name#<br/></a></cfloop></td>
                        <td><cfif not listfindnocase(denied_pages,'list_sales_team&event=upd')><a href="javascript:windowopen('#request.self#?fuseaction=salesplan.list_sales_team&event=upd&team_id=#team_id2#&sz_id=#sz_id#','wide');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></cfif></td>
                    </tr>
                    </cfif>
                </cfoutput>
            <cfelse>
                <cfoutput query="get_sales_zones_team">
                <cfquery name="GET_ROLES" datasource="#DSN#">
                    SELECT 
                        ROLE_ID, 
                        POSITION_CODE 
                    FROM 
                        SALES_ZONES_TEAM_ROLES
                    WHERE 
                        TEAM_ID = #team_id#
                </cfquery>
                <cfquery name="GET_IMS_CODES" datasource="#DSN#">
                    SELECT 
                        SETUP_IMS_CODE.IMS_CODE_ID,
                        SETUP_IMS_CODE.IMS_CODE, 
                        SETUP_IMS_CODE.IMS_CODE_NAME 
                    FROM 
                        SETUP_IMS_CODE,
                        SALES_ZONES_TEAM_IMS_CODE AS SALES_ZONES_TEAM_IMS_CODE
                    WHERE 
                        SALES_ZONES_TEAM_IMS_CODE.TEAM_ID = #team_id# AND
                        SALES_ZONES_TEAM_IMS_CODE.IMS_ID = SETUP_IMS_CODE.IMS_CODE_ID 
                </cfquery>                
                <tr>
                   <!--- <td>#currentrow#</td>--->
                    <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_company_info&team_id=#team_id#');" class="tableyazi">#team_name#</a></td>
                    <td><cfif len(leader_position_code)>#get_emp_info(leader_position_code,1,1)#</cfif></td>
                    <td>
                    <cfloop query="get_roles">
                        <cfquery name="GET_EMP_NAME" datasource="#DSN#">
                        SELECT 
                            EMPLOYEE_NAME,
                            EMPLOYEE_SURNAME,
                            EMPLOYEE_ID,
                            POSITION_CODE
                        FROM				
                            EMPLOYEE_POSITIONS
                        WHERE
                            POSITION_CODE = #get_roles.position_code#
                        </cfquery>		
                        <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#GET_EMP_NAME.EMPLOYEE_ID#');" class="tableyazi">#get_emp_name.employee_name# #get_emp_name.employee_surname#</a><br/>
                    </cfloop></td>
                    <td>
                        <cfloop query="get_roles">
                            <cfif len(get_roles.role_id)>
                                <cfquery name="GET_SETUP_ROLES" datasource="#DSN#">
                                    SELECT PROJECT_ROLES FROM SETUP_PROJECT_ROLES WHERE PROJECT_ROLES_ID = #get_roles.role_id#
                                </cfquery>
                                <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_company_info&position_code=#get_roles.position_code#');" class="tableyazi">#get_setup_roles.project_roles#</a><br/>
                            </cfif>
                        </cfloop>
                    </td>
                    <td><cfloop query="get_ims_codes"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_company_info&ims_id=#get_ims_codes.ims_code_id#');" class="tableyazi">#get_ims_codes.ims_code# #get_ims_codes.ims_code_name#<br/></a></cfloop></td>
                    <td width="15"><cfif not listfindnocase(denied_pages,'salesplan.list_sales_team&event=upd')><a href="javascript:windowopen('#request.self#?fuseaction=salesplan.list_sales_team&event=upd&team_id=#team_id#&sz_id=#sz_id#','wide');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></cfif></td>
                </tr>  
                </cfoutput>          
            </cfif>
        <cfelse>
        <tr>
            <td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
        </tr>
        </cfif>
    </tbody>
</cf_grid_list>
