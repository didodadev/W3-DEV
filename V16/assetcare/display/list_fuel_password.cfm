<cfsetting showdebugoutput="no">
<cfquery name="GET_FUEL_PASSWORD" datasource="#dsn#">
	SELECT
		COMPANY.FULLNAME,
		ASSET_P_FUEL_PASSWORD.PASSWORD_ID,
		ASSET_P_FUEL_PASSWORD.BRANCH_ID,
		ASSET_P_FUEL_PASSWORD.COMPANY_ID,
		ASSET_P_FUEL_PASSWORD.STATUS,
		ASSET_P_FUEL_PASSWORD.USER_CODE,
		ASSET_P_FUEL_PASSWORD.PASSWORD1,
		ASSET_P_FUEL_PASSWORD.PASSWORD2,
		ASSET_P_FUEL_PASSWORD.START_DATE,
		ASSET_P_FUEL_PASSWORD.FINISH_DATE,
		ASSET_P_FUEL_PASSWORD.CARD_NO,
		ZONE.ZONE_NAME,
		BRANCH.BRANCH_NAME
	FROM
		ASSET_P_FUEL_PASSWORD,
		COMPANY,
		BRANCH,
		ZONE
	WHERE
		ASSET_P_FUEL_PASSWORD.COMPANY_ID = COMPANY.COMPANY_ID AND 
		ASSET_P_FUEL_PASSWORD.BRANCH_ID = BRANCH.BRANCH_ID AND
		<!--- Sadece yetkili olunan subeler gozuksun. --->
		ASSET_P_FUEL_PASSWORD.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND 
		BRANCH.ZONE_ID = ZONE.ZONE_ID
	ORDER BY
		PASSWORD_ID DESC
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_grid_list>
	<thead>
		<tr>
			<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='30031.Lokasyon'></th>
			<th><cf_get_lang dictionary_id='48341.Akaryakıt Şirketi'></th>
			<th><cf_get_lang dictionary_id='57482.Aşama'></th>
			<th><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
			<th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
			<cfif isDefined('attributes.iframe') and  attributes.iframe eq 1>
				<a class="ui-btn ui-btn-gray" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.form_search_full_password&event=add')"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='44630.Ekle'>" title="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a>
			<cfelse>
				<th width="30"></th>
			</cfif>
		</tr>
    </thead>
    <tbody>
		<cfoutput query="get_fuel_password">
			<tr>
				<td>#currentrow#</td>
				<td>#zone_name# / #branch_name#</td>
				<td><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');">#fullname#</a></td>
				<td><cfif status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
				<td>#dateformat(start_date,dateformat_style)#</td>
				<td>#dateformat(finish_date,dateformat_style)#</td>
				<cfif isDefined('attributes.iframe') and  attributes.iframe eq 1>
					<td><a href="javascript://" onClick="window.parent.frame_fuel_password.location.href='#request.self#?fuseaction=assetcare.popup_upd_fuel_password&password_id=#password_id#&iframe=1';"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
				<cfelse>
					<td width="30"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=assetcare.popup_upd_fuel_password&password_id=#password_id#')"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
				</cfif>
			</tr>
		</cfoutput>
    </tbody>
</cf_grid_list>
</div>

