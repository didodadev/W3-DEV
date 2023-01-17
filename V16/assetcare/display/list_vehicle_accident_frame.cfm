<cfsetting showdebugoutput="no">
<cfinclude template="../../assetcare/form/vehicle_detail_top.cfm">
<cfquery name="GET_ACCS" datasource="#DSN#">
    SELECT
        ASSET_P_ACCIDENT.ACCIDENT_ID,
        ASSET_P.ASSETP,
        ASSET_P_ACCIDENT.INSURANCE_PAYMENT,
        SETUP_ACCIDENT_TYPE.ACCIDENT_TYPE_NAME,
        ASSET_P_ACCIDENT.EMPLOYEE_ID,
        ASSET_P_ACCIDENT.ACCIDENT_DATE,
        EMPLOYEES.EMPLOYEE_NAME,
        EMPLOYEES.EMPLOYEE_SURNAME,
        DEPARTMENT.DEPARTMENT_HEAD,
        ASSET_P_ACCIDENT.DOCUMENT_NUM, (SELECT FAULT_RATIO_NAME FROM SETUP_FAULT_RATIO WHERE FAULT_RATIO_ID = ASSET_P_ACCIDENT.FAULT_RATIO_ID) FAULT_RATIO_NAME,
        BRANCH_NAME,
        ZONE_NAME
    FROM
        ASSET_P,
        ASSET_P_ACCIDENT,
        SETUP_ACCIDENT_TYPE,
        EMPLOYEES,
        DEPARTMENT,
        BRANCH,
        ZONE
    WHERE
        ASSET_P_ACCIDENT.ASSETP_ID = #attributes.assetp_id# AND
        ASSET_P.ASSETP_ID = ASSET_P_ACCIDENT.ASSETP_ID AND
        EMPLOYEES.EMPLOYEE_ID = ASSET_P_ACCIDENT.EMPLOYEE_ID AND
        DEPARTMENT.DEPARTMENT_ID = ASSET_P.DEPARTMENT_ID2 AND
        DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
        BRANCH.ZONE_ID = ZONE.ZONE_ID AND
        SETUP_ACCIDENT_TYPE.ACCIDENT_TYPE_ID = ASSET_P_ACCIDENT.ACCIDENT_TYPE_ID
    ORDER BY
   		ASSET_P_ACCIDENT.ACCIDENT_ID DESC
</cfquery>
<cfset pageHead = "#getLang('assetcare',456)# : #getLang('main',1656)# : #get_assetp.assetp#">
<cf_catalystHeader>
<div id="accident_div">
<cf_box>
<cf_grid_list>
	<thead>
		<tr>
        	<th><cf_get_lang_main no="1165. Sıra"></th>
			<th><cf_get_lang_main no='330.Tarih'></th>
			<th><cf_get_lang_main no='1656.Plaka'></th>
			<th><cf_get_lang_main no='41.Şube'></th>
			<th><cf_get_lang_main no='132.Sorumlu'></th>
			<th><cf_get_lang no='397.Kaza Tipi'></th>
			<th><cf_get_lang_main no='468.Belge No'></th>
			<th><cf_get_lang no='398.Kusur Oranı'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_accs.recordcount>
			<cfoutput query="get_accs" maxrows="20">
				<tr>
                	<td>#currentrow#</td>
					<td>#dateformat(accident_date,dateformat_style)#</td>
					<td>#assetp#</td>
					<td>#zone_name# - #branch_name# - #department_head#</td>	
					<td>#employee_name# #employee_surname#</td>
					<td>#accident_type_name#</td>
					<td>#document_num#</td>
					<td>#fault_ratio_name#</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="10" height="20"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>
	</tbody>
</cf_grid_list>
</cf_box>
</div>
