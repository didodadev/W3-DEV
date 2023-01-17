<!---BU SAYFA HEM POPUP HEM BASKET OLARAK ÇAĞRILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<cfsetting showdebugoutput="no">
<cfquery name="GET_ALLOCATE" datasource="#DSN#" maxrows="20">
	SELECT
			ASSET_P_KM_CONTROL.KM_CONTROL_ID,
			ASSET_P_KM_CONTROL.ASSETP_ID,
			ASSET_P_KM_CONTROL.EMPLOYEE_ID,
			ASSET_P.ASSETP,
			ASSET_P_KM_CONTROL.START_DATE,
			ASSET_P_KM_CONTROL.FINISH_DATE,
			ASSET_P_KM_CONTROL.IS_OFFTIME,
			BRANCH.BRANCH_NAME,
			ASSET_P_KM_CONTROL.DEPARTMENT_ID
	FROM 
			ASSET_P_KM_CONTROL,
			ASSET_P,
			DEPARTMENT,
			BRANCH
	WHERE
			ASSET_P_KM_CONTROL.IS_ALLOCATE = 1 AND
			ASSET_P_KM_CONTROL.IS_RESIDUAL <> 1 AND
			<!--- Sadece yetkili olunan şubeler gözüksün. --->
			BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
			ASSET_P.ASSETP_ID = ASSET_P_KM_CONTROL.ASSETP_ID AND
			DEPARTMENT.DEPARTMENT_ID = ASSET_P.DEPARTMENT_ID2 AND
			DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
	ORDER BY
			ASSET_P_KM_CONTROL.KM_CONTROL_ID DESC
</cfquery>
<cfquery name="get_deps" datasource="#dsn#">
	SELECT 
		DEPARTMENT_HEAD,
		DEPARTMENT_ID,
		BRANCH.BRANCH_NAME,
		ZONE.ZONE_NAME
	FROM 
		DEPARTMENT,
		BRANCH,
		ZONE
	WHERE 
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
		BRANCH.ZONE_ID = ZONE.ZONE_ID 
		<cfif len(GET_ALLOCATE.DEPARTMENT_ID)>
		AND DEPARTMENT_ID IN (#ValueList(GET_ALLOCATE.DEPARTMENT_ID)#)
		</cfif>
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_flat_list>
        <thead>
            <tr>
            <th><cf_get_lang dictionary_id='29453.Plaka'></th>
            <th><cf_get_lang dictionary_id='48350.Tahsis Edilen Şube'></th>
            <th><cf_get_lang dictionary_id='48351.Tahsis Edilen'></th>
            <th><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
            <th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
            <th><cf_get_lang dictionary_id='48229.Mesai Dışı'></th>
            <th></th>
            </tr>
        </thead>
        <tbody>
        <cfif get_allocate.recordcount>
        <cfset employee_list=''>
        <cfoutput query="get_allocate" maxrows="20">
            <cfif len(employee_id) and not listfind(employee_list,employee_id)>
                <cfset employee_list = Listappend(employee_list,employee_id)>
            </cfif>
        </cfoutput>
        <cfif len(employee_list)>
            <cfset employee_list=listsort(employee_list,"numeric","ASC",",")>			
            <cfquery name="GET_EMPLOYEE" datasource="#DSN#">
                SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_list#) ORDER BY EMPLOYEE_ID
            </cfquery>
        </cfif>
        <cfoutput query="get_allocate" maxrows="20">
            <cfquery name="get_dep" dbtype="query">
                SELECT DEPARTMENT_HEAD,BRANCH_NAME,ZONE_NAME FROM get_deps WHERE DEPARTMENT_ID= #DEPARTMENT_ID#
            </cfquery>
            <tr>
            <td>#assetp#</td>
            <td>#get_dep.zone_name# / #get_dep.branch_name# / #get_dep.department_head#</td>
            <td><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#GET_ALLOCATE.employee_id#','medium','popup_emp_det');">#get_employee.employee_name[listfind(employee_list,get_allocate.employee_id,',')]# #get_employee.employee_surname[listfind(employee_list,get_allocate.employee_id,',')]#</a></td>
            <td><cfif len(start_date)>#dateformat(start_date,dateformat_style)# #timeFormat(start_date,timeformat_style)#</cfif></td>
            <td><cfif len(finish_date)>#dateformat(finish_date,dateformat_style)# #timeFormat(finish_date,timeformat_style)#</cfif></td>
            <td><cfif is_offtime eq 1><font color="red"><cf_get_lang dictionary_id='48229.Mesai Dışı'></cfif></td>
            <td><a href="#request.self#?fuseaction=assetcare.vehicle_allocate&event=upd&km_control_id=#km_control_id#" target="_blank"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
            </tr>
        </cfoutput>		
        <cfelse>
            <tr>
            <td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
            </tr>
        </cfif>
        </tbody>
    </cf_flat_list>
</div>
