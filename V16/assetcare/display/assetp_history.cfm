<cfquery name="GET_ASSETP_HISTORY" datasource="#DSN#">
	SELECT 
		ASSET_P_HISTORY.ASSETP_ID,
		ASSET_P_HISTORY.ASSETP,
		ASSET_P_HISTORY.DEPARTMENT_ID,			
		ASSET_P_HISTORY.DEPARTMENT_ID2,
		ASSET_P_HISTORY.POSITION_CODE,
		ASSET_P_HISTORY.PROPERTY,
		ASSET_P_HISTORY.STATUS,
		ASSET_P_HISTORY.IS_SALES,		
		ASSET_P_HISTORY.ASSETP_DETAIL,
        ISNULL(ASSET_P_HISTORY.UPDATE_DATE,ASSET_P_HISTORY.RECORD_DATE) UPDATE_DATE,
		ASSET_P_HISTORY.POSITION_CODE2,
          (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE  E.EMPLOYEE_ID=ISNULL(ASSET_P_HISTORY.UPDATE_EMP,ASSET_P_HISTORY.RECORD_EMP)) AS UPDATE_NAME,
        ASSET_P_HISTORY.TRANSFER_DATE,
		CASE 
			WHEN ASSET_P_HISTORY.MEMBER_TYPE_2='partner' then CP.COMPANY_PARTNER_NAME+' '+CP.COMPANY_PARTNER_SURNAME 
			WHEN ASSET_P_HISTORY.MEMBER_TYPE_2='consumer' then C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME 
			ELSE EP.EMPLOYEE_NAME+' '+EP.EMPLOYEE_SURNAME END
		PS2_NAME,
		EP.EMPLOYEE_ID PS2_EMPLOYEE_ID,
		SUP.USAGE_PURPOSE,
		ASSET_STATE.ASSET_STATE,
		ISNULL(ASSET_P_HISTORY.UPDATE_EMP,ASSET_P_HISTORY.RECORD_EMP) RECORD_EMP,
		ISNULL(ASSET_P_HISTORY.UPDATE_DATE,ASSET_P_HISTORY.RECORD_DATE)RECORD_DATE,
		CASE
			WHEN (SELECT TOP 1 EMPLOYEE_ID FROM EMPLOYEE_POSITIONS_HISTORY WHERE POSITION_CODE = ASSET_P_HISTORY.POSITION_CODE AND START_DATE <= ASSET_P_HISTORY.RECORD_DATE AND (FINISH_DATE >= ASSET_P_HISTORY.RECORD_DATE OR FINISH_DATE IS NULL)) IS NULL
			THEN (SELECT TOP 1 EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS EMPLOYEE_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = ASSET_P_HISTORY.POSITION_CODE)
			ELSE (SELECT TOP 1 EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS EMPLOYEE_NAME FROM EMPLOYEE_POSITIONS_HISTORY WHERE POSITION_CODE = ASSET_P_HISTORY.POSITION_CODE AND START_DATE <= ASSET_P_HISTORY.RECORD_DATE AND (FINISH_DATE >= ASSET_P_HISTORY.RECORD_DATE OR FINISH_DATE IS NULL))
		END AS PS1_EMP_NAME,
		CASE
			WHEN (SELECT TOP 1 EMPLOYEE_ID FROM EMPLOYEE_POSITIONS_HISTORY WHERE POSITION_CODE = ASSET_P_HISTORY.POSITION_CODE AND START_DATE <= ASSET_P_HISTORY.RECORD_DATE AND (FINISH_DATE >= ASSET_P_HISTORY.RECORD_DATE OR FINISH_DATE IS NULL)) IS NULL
			THEN (SELECT TOP 1 EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = ASSET_P_HISTORY.POSITION_CODE)
			ELSE (SELECT TOP 1 EMPLOYEE_ID FROM EMPLOYEE_POSITIONS_HISTORY WHERE POSITION_CODE = ASSET_P_HISTORY.POSITION_CODE AND START_DATE <= ASSET_P_HISTORY.RECORD_DATE AND (FINISH_DATE >= ASSET_P_HISTORY.RECORD_DATE OR FINISH_DATE IS NULL))
		END AS PS1_EMPLOYEE_ID,
		D.DEPARTMENT_HEAD,
		B.BRANCH_NAME,
		D2.DEPARTMENT_HEAD AS DEPARTMENT_HEAD2,
		B2.BRANCH_NAME AS BRANCH_NAME2
	 FROM
		ASSET_P_HISTORY
		LEFT JOIN EMPLOYEES EP ON ASSET_P_HISTORY.POSITION_CODE2=EP.EMPLOYEE_ID
		LEFT JOIN COMPANY_PARTNER CP ON  ASSET_P_HISTORY.POSITION_CODE2=CP.PARTNER_ID
		LEFT JOIN CONSUMER C ON ASSET_P_HISTORY.POSITION_CODE2=C.CONSUMER_ID
		LEFT JOIN SETUP_USAGE_PURPOSE SUP ON ASSET_P_HISTORY.USAGE_PURPOSE_ID=SUP.USAGE_PURPOSE_ID
		LEFT JOIN ASSET_STATE ON ASSET_P_HISTORY.ASSETP_STATUS =ASSET_STATE.ASSET_STATE_ID
		LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = ASSET_P_HISTORY.DEPARTMENT_ID
		LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
		LEFT JOIN DEPARTMENT D2 ON D2.DEPARTMENT_ID = ASSET_P_HISTORY.DEPARTMENT_ID2
		LEFT JOIN BRANCH B2 ON B2.BRANCH_ID = D2.BRANCH_ID
	WHERE 
		ASSET_P_HISTORY.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
	ORDER BY
		ASSET_P_HISTORY.HISTORY_ID DESC
</cfquery>
<cfquery name="get_asset_state" datasource="#DSN#">
	SELECT ASSET_STATE,ASSET_STATE_ID FROM ASSET_STATE 
</cfquery>
<cfif get_asset_state.recordcount>
	<cfset state_id_list = valuelist(get_asset_state.ASSET_STATE_ID)>
	<cfset state_list = valuelist(get_asset_state.ASSET_STATE)>
</cfif>
<cfinclude template="../query/get_assetp_cats.cfm">
<cfif get_assetp_cats.recordcount>
	<cfset cat_id_list = valuelist(get_assetp_cats.ASSETP_CATID)>
	<cfset cat_list = valuelist(get_assetp_cats.assetp_cat)>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('main',61)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" uidrop="1">
<!-- sil -->
		<cfif get_assetp_history.recordcount>
			<cfset temp_ = 0>
			<cfoutput query="get_assetp_history">
				<cfset temp_ = temp_ +1>
				<cf_seperator id="history_#temp_#" header="#dateformat(update_date,dateformat_style)# (#timeformat(dateadd('h',session.ep.time_zone,update_date),timeformat_style)#) - #UPDATE_NAME#" is_closed="1">
				<cf_flat_list id="history_#temp_#" style="display:none;">
					<tbody>
						<tr>
							<td class="text-bold"><cf_get_lang dictionary_id='57487.No'></td>
							<td>#currentrow#</td>
							<td class="text-bold"><cf_get_lang dictionary_id='29452.Varlık'></td>
							<td>#assetp#</td>
							<td class="text-bold"><cf_get_lang dictionary_id='48015.Kayıtlı Departman'></td>
							<td>#branch_name# - #department_head#</td>
							<td class="text-bold"><cf_get_lang dictionary_id='48016.Kullanıcı Departman'></td>
							<td>#branch_name2# - #department_head2#</td>
						</tr>
						<tr>
								<td class="text-bold"><cf_get_lang dictionary_id='57544.Sorumlu'> 1</td>
								<td>
										<cfif len(ps1_employee_id)>
											<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#ps1_employee_id#','medium');">#ps1_emp_name#</a>
										</cfif>
								</td>
								<td class="text-bold"><cf_get_lang dictionary_id='57544.Sorumlu'> 2</td>
								<td>
										<cfif len(position_code2)>
											<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#ps2_employee_id#','medium');">#ps2_name#</a>
										</cfif>
								</td>
								<td class="text-bold"><cf_get_lang dictionary_id='48014.Mülkiyet'></td>
								<td>
								<cfswitch expression="#property#">
											<cfcase value="1"><cf_get_lang dictionary_id='57449.Satın Alma'></cfcase>
											<cfcase value="2"><cf_get_lang dictionary_id='48065.Kiralama'></cfcase>
											<cfcase value="3"><cf_get_lang dictionary_id='48066.Leasing'></cfcase>
											<cfcase value="4"><cf_get_lang dictionary_id='48067.Sözleşmeli'></cfcase>
								</cfswitch>
								</td>
							</tr>
							<tr>
								<td class="text-bold"><cf_get_lang dictionary_id='58515.Aktif / Pasif'></td>
								<td><cfif status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif><cfif is_sales><font color="red"><cf_get_lang dictionary_id='48409.Satışı Yapıldı'></font></cfif></td>
								<td class="text-bold"><cf_get_lang dictionary_id='47901.Kullanım Amacı'></td>
								<td>#usage_purpose#</td>  
								<td class="text-bold"><cf_get_lang dictionary_id='57756.Durum'></td> 
								<td>#asset_state#</td>
								<td class="text-bold"><cf_get_lang dictionary_id='57629.Açıklama'></td> 
								<td>#assetp_detail#</td>
						</tr>
						<tr>
							<td class="text-bold"><cf_get_lang dictionary_id='57891.Güncelleyen'></td>	
							<td><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_assetp_history.record_emp#','medium');">#get_emp_info(get_assetp_history.record_emp,0,0)#</a></td>
							<td class="text-bold"><cf_get_lang dictionary_id='47990.Güncelleme Tarihi'></td>	
							<td>#dateformat(record_date,dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#)</td>
							<td class="text-bold"><cf_get_lang dictionary_id='48119.Transfer Tarihi'></td>	
							<td><cfif len(transfer_date)>#dateformat(transfer_date,dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#)</cfif></td>	
						</tr>
					</tbody>
				</cf_flat_list>	
			</cfoutput>		
		<cfelse>
			<tr> 
			<td colspan="13"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
			</tr>
		</cfif>
	</cf_box>
</div>

