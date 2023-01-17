<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.status" default="-1">
<cfparam name="attributes.empty_position" default="">
<cfquery name="pos_req_types" datasource="#dsn#">
	SELECT 
		PRQ.*,
		PR.*
	FROM 
		POSITION_REQ_TYPE PRQ,
		POSITION_REQUIREMENTS PR
	WHERE
		PR.POSITION_ID = #attributes.POSITION_ID#
		AND PR.REQ_TYPE_ID = PRQ.REQ_TYPE_ID
</cfquery>

<cfset type_list = valuelist(pos_req_types.req_type)>
<cfset EMLOYEE_LIST = "">
<cfset counter = 1>
<cfoutput query="pos_req_types">
	<cfif len(COEFFICIENT)>
		<cfquery name="get_fit_employees" datasource="#dsn#">
			SELECT
				EMPLOYEE_ID
			FROM
				EMPLOYEE_REQUIREMENTS
			WHERE
				REQ_TYPE_ID = #REQ_TYPE_ID# 
				AND COEFFICIENT >= #COEFFICIENT#
		</cfquery>
	</cfif>
	<cfif isdefined('get_fit_employees') and get_fit_employees.RECORDCOUNT>
		<cfloop query="get_fit_employees">
			<cfset EMLOYEE_LIST = LISTAPPEND(EMLOYEE_LIST,EMPLOYEE_ID)>
		</cfloop>
	</cfif>
</cfoutput>

<cfif LEN(EMLOYEE_LIST)>
	<cfquery name="GET_EMPLOYEES" datasource="#DSN#">
		SELECT
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME,
			EMPLOYEE_ID 
		FROM
			EMPLOYEES
		WHERE
			EMPLOYEE_ID IN (#EMLOYEE_LIST#)
			<cfif len(attributes.keyword)>
				AND
				(
				EMPLOYEE_NAME LIKE '%#attributes.keyword#%'
				OR
				EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
				)
		</cfif>
	</cfquery>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfif isdefined("GET_EMPLOYEES")>
  <cfparam name="attributes.totalrecords" default=#GET_EMPLOYEES.recordcount#>
<cfelse>
  <cfparam name="attributes.totalrecords" default=0> 
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif fuseaction contains "popup">
	<cfset is_popup=1>
<cfelse>
	<cfset is_popup=0>
</cfif>

<cf_box title="#getLang('','Yeterliliklere Uygun Çalışanlar',55210)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="list_pos_fit_employees" action="#request.self#?fuseaction=hr.popup_pos_fit_employees" method="post">
        <cf_box_search more="0">
            <cfif isdefined("attributes.POSITION_ID") and len(attributes.POSITION_ID)>
                <input type="hidden" name="position_id" id="position_id" value="<cfoutput>#attributes.POSITION_ID#</cfoutput>">
            </cfif>
            <div class="form-group">
                <cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#getLang('','Filtre',57460)#">
            </div>
            <div class="form-group small">
                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt sayısı Hatalı',57537)#" maxlength="3">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_pos_fit_employees' , #attributes.modal_id#)"),DE(""))#">
                <!--- <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> --->
            </div>
        </cf_box_search>
    </cfform>
    <cf_grid_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id='55471.Yeterlilikler'></th>
                <th colspan="3">
                    <cfif len(type_list)>
                        <cfloop list="#type_list#" index="i">
                            <cfoutput>#i#</cfoutput>,
                        </cfloop>
                    </cfif> 
                </th>
            </tr>
            <tr> 
                <th><cf_get_lang dictionary_id='57487.No'></th>
                <th><cf_get_lang dictionary_id='57570.Adı Soyadı'></th>
                <th><cf_get_lang dictionary_id='57572.Departman'></th>
                <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
            </tr>
        </thead>
        <tbody>
            <cfif isdefined("GET_EMPLOYEES") and GET_EMPLOYEES.recordcount>
                <cfoutput query="GET_EMPLOYEES" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 			 
                <tr>
                    <td>#currentrow#</td>
                    <td><a href="javascript://" onClick="opener.location.href='#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#';window.close();">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
                        <cfset attributes.employee_id = employee_id>
                        <cfset attributes.position_code = "">
                        <cfinclude template="../query/get_position.cfm">
                        <cfif get_position.recordcount>
                            <cfset attributes.department_id = get_position.department_id>
                            <cfinclude template="../query/get_department.cfm">
                        </cfif>
                    <td><cfif get_position.recordcount>#get_department.department_head#<cfelse>-</cfif></td>
                    <td><cfif get_position.recordcount>#get_position.position_name#<cfelse>-</cfif></td>
                </tr>
                </cfoutput> 
            <cfelse>
                <tr>
                    <td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                </tr>
            </cfif>
        </tbody>
    </cf_grid_list>
    <cfif attributes.totalrecords gt attributes.maxrows>
        <cf_paging 
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="hr.popup_pos_fit_employees&keyword=#attributes.keyword#&position_id=#attributes.position_id#"
            isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
    </cfif>
</cf_box>
