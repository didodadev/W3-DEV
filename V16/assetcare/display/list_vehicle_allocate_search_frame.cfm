<cfsetting showdebugoutput="no">
<cfparam name="attributes.branch" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.is_offtime" default="">
<cfparam name="attributes.assetp" default="">
<cfparam name="attributes.start_date2" default="">
<cfparam name="attributes.finish_date2" default="">
<cfparam name="attributes.is_submitted" default="">
<!---
<cfif len(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
	<cfset attributes.start_date = date_add("h",attributes.start_hour,attributes.start_date)>
	<cfset attributes.start_date = date_add("n",attributes.start_min,attributes.start_date)>
</cfif>
<cfif len(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
	<cfset attributes.finish_date = date_add("h",attributes.finish_hour,attributes.finish_date)>
	<cfset attributes.finish_date = date_add("n",attributes.finish_min,attributes.finish_date)>
</cfif>--->
<cfquery name="GET_ALLOCATE" datasource="#DSN#">
	SELECT
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_NAME, 
		ZONE.ZONE_NAME,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		ASSET_P.ASSETP,
		ASSET_P_KM_CONTROL.START_DATE,
		ASSET_P_KM_CONTROL.FINISH_DATE,
		ASSET_P_KM_CONTROL.IS_OFFTIME,
		ASSET_P_KM_CONTROL.KM_CONTROL_ID,
		ASSET_P_KM_CONTROL.EMPLOYEE_ID		
	FROM 
		ASSET_P_KM_CONTROL, 
		DEPARTMENT,
		ZONE,
		BRANCH,
		EMPLOYEES,
		ASSET_P
	WHERE 
		ASSET_P_KM_CONTROL.IS_ALLOCATE = 1
		AND ASSET_P_KM_CONTROL.IS_RESIDUAL <> 1
		<cfif len(attributes.assetp)>AND ASSET_P_KM_CONTROL.ASSETP_ID = #attributes.assetp_id#</cfif>
		<cfif len(attributes.branch)>AND BRANCH.BRANCH_ID = #attributes.branch_id#</cfif>
		<cfif len(attributes.employee)>AND ASSET_P_KM_CONTROL.EMPLOYEE_ID = #attributes.employee_id#</cfif>
		<cfif len(attributes.start_date2)>AND ASSET_P_KM_CONTROL.START_DATE >= #attributes.start_date2#</cfif>
		<cfif len(attributes.finish_date2)>AND ASSET_P_KM_CONTROL.FINISH_DATE <= #attributes.finish_date2#</cfif>
		<cfif attributes.is_offtime eq 1>AND ASSET_P_KM_CONTROL.IS_OFFTIME = 1</cfif>
		<cfif attributes.is_offtime eq 0>AND ASSET_P_KM_CONTROL.IS_OFFTIME = 0</cfif>
		<!--- Sadece yetkili olunan şubeler gözüksün. --->
		AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
		AND DEPARTMENT.DEPARTMENT_ID = ASSET_P_KM_CONTROL.DEPARTMENT_ID 
		AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
		AND BRANCH.ZONE_ID = ZONE.ZONE_ID	
		AND EMPLOYEES.EMPLOYEE_ID = ASSET_P_KM_CONTROL.EMPLOYEE_ID
		AND ASSET_P.ASSETP_ID = ASSET_P_KM_CONTROL.ASSETP_ID
		
UNION
(
	SELECT
		DEPARTMENT2.DEPARTMENT_HEAD,
		BRANCH2.BRANCH_NAME, 
		ZONE2.ZONE_NAME,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		ASSET_P.ASSETP,
		ASSET_P_KM_CONTROL.START_DATE,
		ASSET_P_KM_CONTROL.FINISH_DATE,
		ASSET_P_KM_CONTROL.IS_OFFTIME,
		ASSET_P_KM_CONTROL.KM_CONTROL_ID,
		ASSET_P_KM_CONTROL.EMPLOYEE_ID		
	FROM 
		ASSET_P_KM_CONTROL, 
		DEPARTMENT,
		DEPARTMENT DEPARTMENT2,
		ZONE ZONE2,
		BRANCH,
		BRANCH BRANCH2,
		EMPLOYEES,
		ASSET_P
	WHERE 
		ASSET_P_KM_CONTROL.IS_ALLOCATE = 1
		AND ASSET_P_KM_CONTROL.IS_RESIDUAL <> 1
		<cfif len(attributes.assetp)>AND ASSET_P_KM_CONTROL.ASSETP_ID = #attributes.assetp_id#</cfif>
		<cfif len(attributes.branch)>AND BRANCH.BRANCH_ID = #attributes.branch_id#</cfif>
		<cfif len(attributes.employee)>AND ASSET_P_KM_CONTROL.EMPLOYEE_ID = #attributes.employee_id#</cfif>
		<cfif len(attributes.start_date2)>AND ASSET_P_KM_CONTROL.START_DATE >= #attributes.start_date2#</cfif>
		<cfif len(attributes.finish_date2)>AND ASSET_P_KM_CONTROL.FINISH_DATE <= #attributes.finish_date2#</cfif>
		<cfif attributes.is_offtime eq 1>AND ASSET_P_KM_CONTROL.IS_OFFTIME = 1</cfif>
		<cfif attributes.is_offtime eq 0>AND ASSET_P_KM_CONTROL.IS_OFFTIME = 0</cfif>
		<!--- Sadece yetkili olunan şubeler gözüksün. --->
		AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
		AND DEPARTMENT.DEPARTMENT_ID = ASSET_P.DEPARTMENT_ID2 
		AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
		AND DEPARTMENT2.DEPARTMENT_ID = ASSET_P_KM_CONTROL.DEPARTMENT_ID  
		AND DEPARTMENT2.BRANCH_ID = BRANCH2.BRANCH_ID
		AND BRANCH2.ZONE_ID = ZONE2.ZONE_ID
		AND EMPLOYEES.EMPLOYEE_ID = ASSET_P_KM_CONTROL.EMPLOYEE_ID
		AND ASSET_P.ASSETP_ID = ASSET_P_KM_CONTROL.ASSETP_ID
)
	ORDER BY 
		START_DATE DESC
		
</cfquery>
<cfif isdefined("attributes.is_submitted")>
<cfparam name="attributes.totalrecords" default='#GET_ALLOCATE.recordcount#'>
<cfelse>
	<cfset GET_ALLOCATE.recordcount = 0>
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GET_ALLOCATE.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

	<cf_flat_list>
		<thead>
			<tr>
				<th width="100"><cf_get_lang dictionary_id='29453.Plaka'></th>
				<th><cf_get_lang dictionary_id='48350.Tahsis Edilen Şube'></th>
				<th width="150"><cf_get_lang dictionary_id='48351.Tahsis Edilen'></th>
				<th width="150"><cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></th>
				<th width="150"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
				<th width="60"><cf_get_lang dictionary_id='48229.Mesai Dışı'></th>
				<th width="20"><a href="javascript://"  onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_add_allocate_detail');"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
			</tr>
		</thead>
		<tbody>
			<cfif len(attributes.is_submitted)>
				<cfif get_allocate.recordcount>
					<cfoutput query="get_allocate" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" height="20">
							<td>#assetp#</td>
							<td>#zone_name# / #branch_name# / #department_head#</td>
							<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');">#employee_name# #employee_surname#</a></td>
							<td>#dateFormat(get_allocate.start_date,dateformat_style)# #timeFormat(get_allocate.start_date,timeformat_style)#</td>
							<td>#dateFormat(get_allocate.finish_date,dateformat_style)# #timeFormat(get_allocate.finish_date,timeformat_style)#</td>
							<td><cfif is_offtime eq 1><font color="red"><cf_get_lang dictionary_id='48229.Mesai Dışı'></cfif></td>
							<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=assetcare.popup_upd_allocate_detail&km_control_id=#km_control_id#','medium','popup_upd_allocate_detail');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.güncelle'>" alt="<cf_get_lang dictionary_id='57464.güncelle'>"></a></td>
						</tr>
					</cfoutput>
				<cfelse>
						<tr class="color-row">
							<td colspan="7" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
						</tr>
				</cfif>
				<cfelse>
					<tr class="color-row">
						<td colspan="7" height="20"><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</td>
					</tr>
			</cfif>
		</tbody>
	</cf_flat_list>
	<cfif isdefined("attributes.is_submitted") and attributes.totalrecords gt attributes.maxrows>
		<cfset url_str = "">
		<cfif isdefined("attributes.branch_id")>
		<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
		</cfif>
		<cfif isdefined("attributes.branch")>
		<cfset url_str = "#url_str#&branch=#attributes.branch#">
		</cfif>
		<cfif isdefined("attributes.is_submitted")>
		<cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
		</cfif>
		<cfif isdefined("attributes.assetp_id")>
		<cfset url_str = "#url_str#&assetp_id=#attributes.assetp_id#">
		</cfif>
		<cfif isdefined("attributes.assetp")>
		<cfset url_str = "#url_str#&assetp=#attributes.assetp#">
		</cfif>
		<cfif isdefined("attributes.employee_id")>
		<cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
		</cfif>
		<cfif isdefined("attributes.employee_name")>
		<cfset url_str = "#url_str#&employee_name=#attributes.employee_name#">
		</cfif>
		<cfif isdefined("attributes.is_offtime")>
		<cfset url_str = "#url_str#&is_offtime=#attributes.is_offtime#">
		</cfif>
		<cfif isdefined("attributes.start_date2")>
		<cfset url_str = "#url_str#&start_date2=#dateformat(attributes.start_date2)#">
		</cfif>
		<cfif isdefined("attributes.finish_date2")>
		<cfset url_str = "#url_str#&finish_date2=#dateformat(attributes.finish_date2)#">
		</cfif>	
		<!---
		<cfif isdefined("attributes.start_hour")>
		<cfset url_str = "#url_str#&start_hour=#attributes.start_hour#">
		</cfif>	
		<cfif isdefined("attributes.finish_hour")>
		<cfset url_str = "#url_str#&finish_hour=#attributes.finish_hour#">
		</cfif>	
		--->
		<cfif isdefined("attributes.start_min")>
		<cfset url_str = "#url_str#&start_min=#attributes.start_min#">
		</cfif>	
		<cfif isdefined("attributes.finish_min")>
		<cfset url_str = "#url_str#&finish_min=#attributes.finish_min#">
		</cfif>	
		<!-- sil -->
		<cfif isdefined("attributes.is_submitted") and attributes.is_submitted eq 1>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="assetcare.popup_list_vehicle_allocate_search#url_str#">
		</cfif>
		<!-- sil -->
	</cfif>
	
