<cf_xml_page_edit fuseact="hr.form_upd_emp">
<cfscript>
	get_position_history = createObject("component","V16.hr.cfc.get_change_position_history");
	get_position_history.dsn = dsn;
	get_history = get_position_history.get_change_history_fnc
					(
						module_name : fusebox.circuit,
						employee_id : attributes.employee_id
					);
</cfscript>
<cf_ajax_list>
    <cfif get_history.recordcount>
        <cfset department_id_list = "">
        <cfset position_cat_id_list = "">
        <cfset title_id_list = "">
        <cfset func_id_list = "">
        <cfoutput query="get_history">
        <cfif len(department_id) and not listfind(department_id_list,department_id)>
            <cfset department_id_list=listappend(department_id_list,department_id)>
        </cfif>
        <cfif len(position_cat_id) and not listfind(position_cat_id_list,position_cat_id)>
            <cfset position_cat_id_list=listappend(position_cat_id_list,position_cat_id)>
        </cfif>
        <cfif len(title_id) and not listfind(title_id_list,title_id)>
            <cfset title_id_list=listappend(title_id_list,title_id)>
        </cfif>
        <cfif len(func_id) and not listfind(func_id_list,func_id)>
            <cfset func_id_list=listappend(func_id_list,func_id)>
        </cfif>
        </cfoutput>
        <cfif listlen(department_id_list)>
            <cfquery name="get_department" datasource="#dsn#">
                SELECT
                    D.DEPARTMENT_ID,
                    D.DEPARTMENT_HEAD,
                    B.BRANCH_NAME,
                    OC.NICK_NAME
                FROM
                    DEPARTMENT D,
                    BRANCH B,
                    OUR_COMPANY OC
                WHERE
                    D.BRANCH_ID = B.BRANCH_ID AND
                    B.COMPANY_ID = OC.COMP_ID AND
                    D.DEPARTMENT_ID IN(#department_id_list#)
                ORDER BY
                    D.DEPARTMENT_ID	
            </cfquery>
            <cfset department_id_list = listsort(listdeleteduplicates(valuelist(get_department.department_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif len(position_cat_id_list)>
            <cfquery name="get_position_cat" datasource="#dsn#">
                SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID IN(#position_cat_id_list#) ORDER BY POSITION_CAT_ID
            </cfquery>
            <cfset position_cat_id_list = listsort(listdeleteduplicates(valuelist(get_position_cat.position_cat_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif len(title_id_list)>
            <cfquery name="get_title" datasource="#dsn#">
                SELECT TITLE_ID,TITLE FROM SETUP_TITLE WHERE TITLE_ID IN(#title_id_list#) ORDER BY TITLE_ID
            </cfquery>
            <cfset title_id_list = listsort(listdeleteduplicates(valuelist(get_title.title_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif len(func_id_list)>
            <cfquery name="get_func" datasource="#dsn#">
                SELECT UNIT_ID,UNIT_NAME FROM SETUP_CV_UNIT WHERE UNIT_ID IN(#func_id_list#) ORDER BY UNIT_ID
            </cfquery>
            <cfset func_id_list = listsort(listdeleteduplicates(valuelist(get_func.unit_id,',')),'numeric','ASC',',')>
        </cfif>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id ='57574.Sirket'></th>
                <th><cf_get_lang dictionary_id ='57453.Şube'></th>
                <th><cf_get_lang dictionary_id ='57572.Departman'></th>
                <th><cf_get_lang dictionary_id ='58701.Fonksiyon'></th>
                <th><cfif xml_position_name eq 1><cf_get_lang dictionary_id ='58497.Pozisyon'><cfelse><cf_get_lang dictionary_id='59004.Pozisyon tipi'></cfif>/<cf_get_lang dictionary_id='57571.Ünvan'></th>
                <th><cf_get_lang dictionary_id='57554.Giriş'></th>
                <th><cf_get_lang dictionary_id='57431.Çıkış'></th>
                <th style="width:20;"><a href="javascript://"><i class="fa fa-pencil"></i></a></th>
            </tr>
        </thead>
        <tbody>
        <cfoutput query="get_history">
            <tr>
                <td>#get_department.nick_name[listfind(department_id_list,department_id,',')]#</td>
                <td>#get_department.branch_name[listfind(department_id_list,department_id,',')]#</td>
                <td>#get_department.department_head[listfind(department_id_list,department_id,',')]#</td>
                <td><cfif len(func_id_list)>#get_func.unit_name[listfind(func_id_list,func_id,',')]#</cfif></td>
                <td><cfif xml_position_name eq 1>#position_name#<cfelse><cfif len(position_cat_id)>#get_position_cat.position_cat[listfind(position_cat_id_list,position_cat_id,',')]#</cfif></cfif> <cfif len(title_id)>- #get_title.title[listfind(title_id_list,title_id,',')]#</cfif></td>
                <td>#dateformat(start_date,dateformat_style)#</td>
                <td>#dateformat(finish_date,dateformat_style)#</td>
                <td>
                    <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=hr.popup_upd_position_change_history&id=#id#');"><i class="fa fa-pencil"></i></a>
                </td>
            </tr>
        </cfoutput>
        </tbody>
    <cfelse>
        <tbody>
            <tr>
                <td colspan="10"><cf_get_lang dictionary_id ='57484.Kayıt Yok '>!</td>
            </tr>
        </tbody>
    </cfif>
</cf_ajax_list>
