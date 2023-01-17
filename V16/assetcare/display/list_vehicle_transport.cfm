<!---BU SAYFA HEM BASKET, HEM POPUP SAYFA OLARAK KULLANILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<cfsetting showdebugoutput="no">
<cfquery name="GET_TRANSPORT" datasource="#DSN#" maxrows="20">
	SELECT 
		ASSET_P_TRANSPORT.SHIP_ID,
		ASSET_P_TRANSPORT.SHIP_NUM,
		ASSET_P_TRANSPORT.SHIP_DATE,
		ASSET_P_TRANSPORT.SENDER_DEPOT,
		ASSET_P_TRANSPORT.RECEIVER_DEPOT,
		ASSET_P_TRANSPORT.PLATE,
		ASSET_P_TRANSPORT.PACK_QUANTITY,
		ASSET_P_TRANSPORT.PACK_DESI,
		ASSET_P_TRANSPORT.STUFF_TYPE,
		ASSET_P_TRANSPORT.SHIP_STATUS,
		SHIP_METHOD.SHIP_METHOD,
		DEPARTMENT1.DEPARTMENT_HEAD,
		BRANCH1.BRANCH_NAME,
		ZONE1.ZONE_NAME,
		DEPARTMENT2.DEPARTMENT_HEAD AS DEPARTMENT_HEAD2,
		BRANCH2.BRANCH_NAME AS BRANCH_NAME2,
		ZONE2.ZONE_NAME AS ZONE_NAME2,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		COMPANY.FULLNAME
	FROM
		ASSET_P_TRANSPORT,
		SHIP_METHOD,
		DEPARTMENT AS DEPARTMENT1,
		DEPARTMENT AS DEPARTMENT2,
		BRANCH AS BRANCH1,
		BRANCH AS BRANCH2,
		ZONE AS ZONE1,
		ZONE AS ZONE2,
		EMPLOYEES,
		COMPANY
	WHERE  
		SHIP_METHOD.SHIP_METHOD_ID = ASSET_P_TRANSPORT.SHIP_METHOD AND
		ASSET_P_TRANSPORT.SENDER_DEPOT = DEPARTMENT1.DEPARTMENT_ID
		AND ASSET_P_TRANSPORT.RECEIVER_DEPOT = DEPARTMENT2.DEPARTMENT_ID AND 
		(BRANCH1.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)) AND
		DEPARTMENT1.BRANCH_ID = BRANCH1.BRANCH_ID AND
		DEPARTMENT2.BRANCH_ID = BRANCH2.BRANCH_ID AND
		BRANCH1.ZONE_ID = ZONE1.ZONE_ID AND
		BRANCH2.ZONE_ID = ZONE2.ZONE_ID AND
		EMPLOYEES.EMPLOYEE_ID = ASSET_P_TRANSPORT.SENDER_EMP_ID AND
		COMPANY.COMPANY_ID = ASSET_P_TRANSPORT.SHIP_FIRM
	ORDER BY 
		ASSET_P_TRANSPORT.SHIP_DATE DESC 
</cfquery> 

<cf_grid_list>
	<thead>
		<tr>
			<th><cf_get_lang no='319.Sevk No'></th>
			<th width="100"><cf_get_lang no='411.Sevk Tarihi'></th>
			<th><cf_get_lang no='410.Gönderen Şube'></th>
			<th><cf_get_lang no='409.Gönderen Kişi'></th>
			<th><cf_get_lang no='408.Alıcı Şube'></th>
			<th width="100"><cf_get_lang_main no='670.Adet'></th>
			<th width="100"><cf_get_lang no='442.Desi'></th>
			<th><cf_get_lang no='443.Gönderi Tipi'></th>
			<th><cf_get_lang_main no='70.Asama'></th>
			<th width="15"><a href="<cfoutput>#request.self#?fuseaction=assetcare.list_vehicles&event=add_tr</cfoutput>"><i class="fa fa-plus" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>"></a></th>
		</tr>
    </thead>
    <tbody>
		<cfif get_transport.recordcount>
			<cfoutput query="get_transport" maxrows="20">
				<tr>
					<td>#ship_num#</td>
					<td>#dateformat(ship_date,dateformat_style)#</td>
					<td>#zone_name# - #branch_name# - #department_head#</td>
					<td>#employee_name# #employee_surname#</td>
					<td>#zone_name2# - #branch_name2# - #department_head2#</td>
					<td style="text-align:right;">#pack_quantity#</td>
					<td style="text-align:right;">#pack_desi#</td>
					<td><cfif stuff_type eq 1><cf_get_lang no='441.Koli'><cfelseif stuff_type eq 2><cf_get_lang_main no='279.Dosya'><cfelseif stuff_type eq 3><cf_get_lang_main no='1068.Arac'></cfif></td>
					<td><cfif ship_status eq 0><cf_get_lang no='435.Gönderildi'><cfelse><cf_get_lang no='659.Alındı'></cfif></td>
					<td width="15"><a href="#request.self#?fuseaction=assetcare.list_vehicles&event=upd_tr&ship_id=#ship_id#"><i class="fa fa-pencil" alt="<cf_get_lang_main no='52.Güncelle'>" title="<cf_get_lang_main no='52.Güncelle'>" border="0" align="absmiddle"></a></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="10" class="color-row"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>
	</tbody>
</cf_grid_list>
