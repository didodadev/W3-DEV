<cfsetting showdebugoutput="no">
<cfinclude template="../../assetcare/form/vehicle_detail_top.cfm">
<cfquery name="GET_PUNISHMENT" datasource="#dsn#">
	SELECT
		ASSET_P.ASSETP,
		ASSET_P_PUNISHMENT.EMPLOYEE_ID,
		ASSET_P_PUNISHMENT.PUNISHMENT_DATE,
		ASSET_P_PUNISHMENT.PUNISHMENT_AMOUNT,
		ASSET_P_PUNISHMENT.LAST_PAYMENT_DATE,
		ASSET_P_PUNISHMENT.PUNISHMENT_ID,
		ASSET_P_PUNISHMENT.PUNISHMENT_AMOUNT_CURRENCY,
		ASSET_P_PUNISHMENT.PAID_DATE,
		ASSET_P_PUNISHMENT.PAID_AMOUNT,
		ASSET_P_PUNISHMENT.PAID_AMOUNT_CURRENCY,
		ASSET_P_PUNISHMENT.DEPARTMENT_ID,
		ASSET_P_PUNISHMENT.RECEIPT_NUM,
		ASSET_P_PUNISHMENT.ACCIDENT_ID,
		SETUP_PUNISHMENT_TYPE.PUNISHMENT_TYPE_NAME,		
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_NAME,
		ZONE.ZONE_NAME,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	FROM 
		ASSET_P_PUNISHMENT,
		ASSET_P,
		BRANCH,
		ZONE,
		DEPARTMENT,
		EMPLOYEES,
		SETUP_PUNISHMENT_TYPE
	WHERE
		ASSET_P_PUNISHMENT.ASSETP_ID = #attributes.assetp_id# AND
		ASSET_P_PUNISHMENT.ASSETP_ID = ASSET_P.ASSETP_ID AND
		ASSET_P_PUNISHMENT.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
		BRANCH.ZONE_ID = ZONE.ZONE_ID AND 
		ASSET_P_PUNISHMENT.PUNISHMENT_TYPE_ID = SETUP_PUNISHMENT_TYPE.PUNISHMENT_TYPE_ID AND
		ASSET_P_PUNISHMENT.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
	ORDER BY 
		ASSET_P_PUNISHMENT.PUNISHMENT_ID DESC
</cfquery>
<cfset accident_id_list = ''>
<cfif get_punishment.recordcount>
	<cfoutput query="get_punishment">
		<cfif len(accident_id) and not listFind(accident_id_list,accident_id,',')>
			<cfset accident_id_list = listAppend(accident_id_list,accident_id)>
		</cfif>
	</cfoutput>
</cfif>
<cfif len(accident_id_list)>
	<cfquery name="get_accident" datasource="#dsn#">
		SELECT
			ASSET_P.ASSETP,
			ASSET_P_ACCIDENT.ACCIDENT_DATE,
			ASSET_P_ACCIDENT.ACCIDENT_ID
		FROM 
			ASSET_P_ACCIDENT,
			ASSET_P,
			BRANCH
		WHERE
		<!--- Sadece yetkili olunan şubeler gözüksün. Onur P. --->
		BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
		ASSET_P_ACCIDENT.ACCIDENT_ID IN (#accident_id_list#) AND
		ASSET_P.ASSETP_ID = ASSET_P_ACCIDENT.ASSETP_ID
	</cfquery>
</cfif>
<cfset pageHead = "#getLang('assetcare',455)# : #getLang('main',1656)# : #get_assetp.assetp#">
<cf_catalystHeader>
<div id="punishment_div">
<cf_box>
<cf_grid_list>
	<thead>
		<tr>
        	<th><cf_get_lang_main no="1165. Sıra"></th>
			<th><cf_get_lang_main no='330.Tarih'></th>
			<th><cf_get_lang_main no='1656.Plaka'></th>
			<th><cf_get_lang_main no='41.Şube'> / <cf_get_lang_main no='2234.Lokasyon'></th>
			<th><cf_get_lang_main no='132.Sorumlu'></th>
			<th><cf_get_lang no='414.Ceza Tipi'></th>
			<th><cf_get_lang no='415.Makbuz No'></th>
			<th style="text-align:right;"><cf_get_lang no='417.Ceza Tutarı'></th>
			<th style="text-align:right;"><cf_get_lang no='418.Ödenen Tutar'></th>
			<th style="text-align:left;"><cf_get_lang no='446.Kaza İlişkisi'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_punishment.recordcount>
		<cfoutput query="get_punishment">
			<tr>
            	<td>#currentrow#</td>
				<td>#dateformat(punishment_date,dateformat_style)#</td>
				<td>#assetp#</td>
				<td>#zone_name# - #branch_name# - #department_head#</td>
				<td>#employee_name# #employee_surname#</td>
				<td>#punishment_type_name#</td>
				<td>#receipt_num#</td>
				<td style="text-align:right;">#tlFormat(punishment_amount)# #paid_amount_currency#</td>
				<td style="text-align:right;">#tlformat(paid_amount)# #paid_amount_currency#</td>
				<td style="text-align:left;">
					<cfif len(accident_id)>
					  <cfquery name="get_accident_record" dbtype="query">
						SELECT * FROM get_accident WHERE ACCIDENT_ID = #accident_id#
					  </cfquery>
					  <cfquery name="get_total_punishment" dbtype="query">
							SELECT SUM(PUNISHMENT_AMOUNT) AS TOTAL_PUNISHMENT FROM get_punishment WHERE ACCIDENT_ID = #accident_id#
					  </cfquery>
						<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=assetcare.popup_accident_detail&accident_id=#get_accident_record.accident_id#','medium');">#get_accident_record.accident_id# Nolu #dateformat(get_accident_record.accident_date,dateformat_style)# <cf_get_lang no='450.tarihli kaza'></a>
					  <cfelse>&nbsp;
					</cfif>
				</td>
			</tr>
		</cfoutput>
		<cfelse>
			<tr>
				<td colspan="10"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>
	</tbody>
</cf_grid_list>
</cf_box>
</div>
