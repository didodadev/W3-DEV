<cfsetting showdebugoutput="no">
<cfquery name="GET_ASSETCARE" datasource="#dsn#">
	SELECT
		ASSET_CARE_REPORT.*,
		ASSET_P.ASSETP,
		ASSET_P_CAT.ASSETP_CAT,
		ASSET_P.ASSETP_CATID,
		ASSET_P.DEPARTMENT_ID,
		ZONE.ZONE_NAME,
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_NAME
	FROM
		ASSET_CARE_REPORT,
		ASSET_P,
		ASSET_P_CAT,
		DEPARTMENT,
		BRANCH,
		ZONE
	WHERE 
		DEPARTMENT.DEPARTMENT_ID = ASSET_P.DEPARTMENT_ID
		<!--- Sadece yetkili olunan şubeler gözüksün. Onur P. --->
		AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
		AND BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
		AND BRANCH.ZONE_ID = ZONE.ZONE_ID
		AND ASSET_P_CAT.ASSETP_CATID = ASSET_P.ASSETP_CATID
		AND ASSET_P.ASSETP_ID = ASSET_CARE_REPORT.ASSET_ID
		AND ASSET_CARE_REPORT.ASSET_TYPE = 'P'
		AND (ASSET_CARE_REPORT.RECORD_EMP = #session.ep.userid# OR ASSET_CARE_REPORT.UPDATE_EMP = #session.ep.userid#)
		ORDER BY CARE_REPORT_ID DESC
</cfquery>
<cf_grid_list class="detail_basket_list">
	<thead>
		<tr>
		  <th width="30"><cf_get_lang_main no='75.No'></th>
		  <th width="200"><cf_get_lang_main no='1655.Varlık'></th>
		  <th width="140"><cf_get_lang_main no='74.Kategori'></th>
		  <th width="200"><cf_get_lang_main no='2234.Lokasyon'></th>
		  <th width="70"><cf_get_lang no='35.Son Bakım'></th>
		  <th width="130"><cf_get_lang no='36.Bakım Yapan'></th>
		  <th><cf_get_lang_main no='721.Fatura No'></th>
		  <th width="15"><a href="javascript://" onClick="parent.add_form.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_add_assetcare&iframe=1';"><img src="/images/plus_square.gif"  alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>"></a></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_assetcare.recordcount>
			<cfoutput query="GET_ASSETCARE" maxrows="10">
			  <tr>
				<td>#currentrow#</td>
				<td>#assetp#</td>
				<td>#assetp_cat#</td>
				<td>#zone_name# / #branch_name# / #department_head#</td>
				<td>#dateformat(care_date,dateformat_style)#</td>
				<td><cfif len(company_id)>#get_par_info(company_id,1,0,1)#</cfif>
					<cfif len(company_partner_id)>- #get_par_info(company_partner_id,0,-1,1)#</cfif></td>
				<td><cfif len(bill_name)>#bill_name#</cfif></td>
				<td width="15"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=assetcare.popup_upd_assetcare&iframe=1&asset_id=#asset_id#&care_report_id=#care_report_id#&id=#expense_item_row_id#&draggable=1')";><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
			  </tr>
			</cfoutput>
		<cfelse>
			<tr>
			  <td colspan="9" height="20"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>
	</tbody>
</cf_grid_list>
