<!---Select ifadeleri düzenlendi.30.07.2012--->
<cfquery name="GET_BRANCH_DETAIL" datasource="#DSN#">
	SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID=#URL.ID#
</cfquery>
<cfquery name="GET_HISTORY_DETAIL" datasource="#DSN#">
	SELECT
		BRANCH_HIST_ID,
		BRANCH_STATUS,
		ZONE_ID,
		COMPANY_ID,
		BRANCH_ID,
		ADMIN1_POSITION_CODE,
		ADMIN2_POSITION_CODE,
		BRANCH_NAME,
		BRANCH_FULLNAME,
		BRANCH_EMAIL,
		BRANCH_TELCODE,
		BRANCH_TEL1,
		BRANCH_TEL2,
		BRANCH_TEL3,
		BRANCH_FAX,
		BRANCH_ADDRESS,
		BRANCH_POSTCODE,
		BRANCH_COUNTY,
		BRANCH_CITY,
		BRANCH_COUNTRY,
		BRANCH_WORK,
		SSK_OFFICE,
		SSK_NO,
		SSK_M,
		SSK_JOB,
		SSK_BRANCH,
		SSK_BRANCH_OLD,
		SSK_CITY,
		SSK_COUNTRY,
		SSK_CD,
		SSK_AGENT,
		WORK_ZONE_M,
		WORK_ZONE_JOB,
		WORK_ZONE_FILE,
		WORK_ZONE_CITY,
		DANGER_DEGREE,
		DANGER_DEGREE_NO,
		ASSET_FILE_NAME1,
		ASSET_FILE_NAME1_SERVER_ID,
		ASSET_FILE_NAME2,
		ASSET_FILE_NAME2_SERVER_ID,
		FOUNDATION_DATE,
		ISKUR_BRANCH_NAME,
		ISKUR_BRANCH_NO,
		CAL_BOL_MUD_NAME,
		REAL_WORK,
		CAL_BOL_MUD_NO,
		IS_INTERNET,
		HIERARCHY,
		HIERARCHY2,
		KANUN_5084_ORAN,
		IS_SAKAT_KONTROL,
		RELATED_COMPANY,
		OZEL_KOD,
		IS_PRODUCTION,
		IS_ORGANIZATION,
		RELATED_COMPANY_BRANCH_ID,
		OPEN_DATE,
		TCKIMLIK_NO,
		USER_NAME,
		SYSTEM_PASSWORD,
		COMPANY_PASSWORD,
		SSK_EMPLOYEE_ID,
		SSK_POSITION_CODE,
		EMPLOYEE_SYSTEM_NAME,
		POSITION_NAME,
		BRANCH_PDKS_CODE,
		IS_5615,
		BRANCH_PDKS_IP_NUMBERS,
		IS_PDKS_WORK,
		RELATED_BRANCH_ID,
		BRANCH_CAT_ID,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP,
		UPDATE_DATE,
		UPDATE_EMP,
		UPDATE_IP,
		IS_5615_TAX_OFF
	FROM
		BRANCH_HISTORY
	WHERE
		BRANCH_ID=#URL.ID#
	ORDER BY
		BRANCH_HIST_ID DESC
</cfquery>
<cf_get_lang_set module_name="settings">
	<cf_box title="#getLang('settings',1652)# : #GET_BRANCH_DETAIL.BRANCH_NAME#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<div class="row">
	<div class="col col-12 uniqueRow">
		<div class="row formContent">
			<div class="row">
				<cf_medium_list>
					<thead>
						<tr>
							<th><cf_get_lang_main no='75.No'></th>
							<th><cf_get_lang_main no='1735.Şube Adı'></th>
							<th><cf_get_lang no='372.SSK Şube'></th>
							<th><cf_get_lang no='948.SSK No'></th>
							<th><cf_get_lang_main no='613.TC Kimlik No'> - <cf_get_lang_main no='139.Kullanıcı Adı'></th>
							<th><cf_get_lang no='1650.Sistem Şifresi'></th>
							<th><cf_get_lang no='1651.Şirket Şifresi'></th>
							<th><cf_get_lang no='1180.Güncelleme Tarihi'></th>
							<th><cf_get_lang_main no='479.Güncelleyen'></th>
						</tr>
					</thead>
					<cfoutput query="GET_HISTORY_DETAIL">
						<tbody>
							<tr>
								<td>#currentrow#</td>
								<td>#branch_name#</td>
								<td>#ssk_office#</td>
								<td>#ssk_no#</td>
								<td>#tckimlik_no#&nbsp;#user_name#</td>
								<td>#system_password#</td>
								<td>#company_password#</td>
								<td>
									<cfif len(update_date)>
										#dateformat(update_date,dateformat_style)# ( #timeformat(date_add('h',session.ep.time_zone,update_date),timeformat_style)# )
									<cfelse>
										#dateformat(record_date,dateformat_style)# ( #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)# )
									</cfif>
								</td>
								<td><cfif len(update_emp)>#get_emp_info(update_emp,0,0)#</cfif></td>
							</tr>
						</tbody>
					</cfoutput>
				</cf_medium_list>
			</div>
		</div>
	</div>
</div>    
</cf_box>
<cf_get_lang_set module_name="#fusebox.circuit#">
