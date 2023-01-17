<cfsetting showdebugoutput="no">
<cfinclude template="../../assetcare/form/vehicle_detail_top.cfm">

<cfquery name="get_assetp_history" datasource="#DSN#">
	SELECT 
		ASSET_P_HISTORY.ASSETP_ID,
		ASSET_P_HISTORY.ASSETP,
		ASSET_P_HISTORY.DEPARTMENT_ID,			
		ASSET_P_HISTORY.DEPARTMENT_ID2,
		ASSET_P_HISTORY.POSITION_CODE,
		ASSET_P_HISTORY.PROPERTY,
		ASSET_P_HISTORY.STATUS,
		ASSET_P_HISTORY.IS_SALES,		
		ASSET_P_HISTORY.RECORD_EMP,
		ASSET_P_HISTORY.RECORD_DATE,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	 FROM
		ASSET_P_HISTORY,
		EMPLOYEES
	WHERE
		ASSET_P_HISTORY.ASSETP_ID = #attributes.assetp_id# AND
		ASSET_P_HISTORY.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID
	ORDER BY
		ASSET_P_HISTORY.HISTORY_ID DESC
</cfquery>
<cfset pageHead ="#getLang('main',61)# : #getLang('main',1656)# : #get_assetp.assetp#">
<cf_catalystHeader>
<div id="history_div" class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cf_flat_list>
            <thead>
                <tr>
                    <th><cf_get_lang_main no="1165. Sıra"></th>
                    <th width="50"><cf_get_lang_main no='1656.Plaka'></th>
                    <th><cf_get_lang no='144.Kayıtlı Departman'></th>
                    <th><cf_get_lang no='145.Kullanıcı Departman'></th>
                    <th width="150"><cf_get_lang_main no='132.Sorumlu'> 1</th>
                    <th width="80"><cf_get_lang no='143.Mülkiyet'></th>
                    <th width="100"><cf_get_lang_main no='1103.Aktif Pasif'></th>  
                    <th width="100"><cf_get_lang no='73.Kayıt Yapan'></th>		  		  
                    <th width="100"><cf_get_lang_main no='215.Kayıt Tarihi'></th>		  		  		  	
                </tr>
            </thead>
            <tbody>
                <cfif get_assetp_history.recordcount>	  
                    <cfset department_id_list=''>
                    <cfset position_code_list=''>
                    <cfoutput query="get_assetp_history">
                        <cfif len(department_id) and not listfind(department_id_list,department_id)>
                            <cfset department_id_list = Listappend(department_id_list,department_id)>
                        </cfif>
                        <cfif len(department_id2) and not listfind(department_id_list,department_id2)>
                            <cfset department_id_list = Listappend(department_id_list,department_id2)>
                        </cfif>
                        <cfif len(position_code) and not listfind(position_code_list,position_code)>
                            <cfset position_code_list = Listappend(position_code_list,position_code)>
                        </cfif>
                    </cfoutput>
                    <cfif len(department_id_list)>
                        <cfset department_id_list=listsort(department_id_list,"numeric","ASC",",")>
                        <cfquery name="GET_DEPARTMENT" datasource="#dsn#">
                            SELECT
                                DEPARTMENT.DEPARTMENT_ID,
                                BRANCH.BRANCH_NAME,
                                DEPARTMENT.DEPARTMENT_HEAD	
                            FROM 
                                DEPARTMENT,
                                BRANCH
                            WHERE
                                DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
                                DEPARTMENT.DEPARTMENT_ID IN (#department_id_list#)						
                        </cfquery>
                        <cfset main_department_id_list = listsort(listdeleteduplicates(valuelist(GET_DEPARTMENT.DEPARTMENT_ID,',')),'numeric','ASC',',')>
                    </cfif>
                    <cfif len(position_code_list)>
                        <cfset position_code_list = listsort(position_code_list,"numeric","ASC",",")>
                        <cfquery name="get_position" datasource="#dsn#">
                            SELECT
                                EMPLOYEE_ID,
                                EMPLOYEE_NAME,
                                EMPLOYEE_SURNAME,
                                POSITION_CODE
                            FROM
                                EMPLOYEE_POSITIONS
                            WHERE
                                POSITION_CODE IN (#position_code_list#)
                            ORDER BY
                                EMPLOYEE_ID
                        </cfquery>
                        <cfset main_position_code_list = listsort(listdeleteduplicates(valuelist(get_position.position_code,',')),'numeric','ASC',',')>
                    </cfif>	
                    <cfoutput query="get_assetp_history">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#assetp#</td>
                            <td><cfif len(department_id)>#get_department.branch_name[listfind(main_department_id_list,department_id,',')]# - #get_department.department_head[listfind(main_department_id_list,department_id,',')]#</cfif></td>
                            <td><cfif len(department_id2)>#get_department.branch_name[listfind(main_department_id_list,department_id2,',')]# - #get_department.department_head[listfind(main_department_id_list,department_id2,',')]#</cfif></td>
                            <td><cfif len(position_code) and Len(get_position.employee_id[listfind(main_position_code_list,position_code,',')])>
                                    <a href="javascript://" class="tableyazi" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_position.employee_id[listfind(main_position_code_list,position_code,',')]#');">#get_position.employee_name[listfind(main_position_code_list,position_code,',')]# #get_position.employee_surname[listfind(main_position_code_list,position_code,',')]#</a>
                                <cfelseif Len(position_code)>
                                    #get_emp_info(position_code,1,1,1)#
                                </cfif>
                            </td>
                            <td><cfswitch expression="#property#">
                                    <cfcase value="1"><cf_get_lang_main no='37.Satın Alma'></cfcase>
                                    <cfcase value="2"><cf_get_lang no='194.Kiralama'></cfcase>
                                    <cfcase value="3"><cf_get_lang no='195.Leasing'></cfcase>
                                    <cfcase value="4"><cf_get_lang no='196.Sözleşmeli'></cfcase>
                                </cfswitch>
                            </td>
                            <td><cfif status><cf_get_lang_main no='81.Aktif'><cfelse><cf_get_lang_main no='82.Pasif'></cfif><cfif is_sales><font color="red"><cf_get_lang no='538.Satışı Yapıldı'></font></cfif></td>
                            <td><a href="javascript://" class="tableyazi" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_assetp_history.record_emp#');">#employee_name# #employee_surname#</a></td>
                            <td nowrap="nowrap">#dateformat(record_date,dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#)</td>
                        </tr>
                    </cfoutput> 
                <cfelse>
                    <tr> 
                        <td colspan="10"><cf_get_lang_main no='72.Kayıt Bulunamadı'></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
    </cf_box>
</div>
   
