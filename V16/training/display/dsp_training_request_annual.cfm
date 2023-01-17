<cfif isdefined('attributes.fbx') and attributes.fbx eq 'myhome'>
    <cfset attributes.train_req_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.train_req_id,accountKey:session.ep.userid)>
</cfif>
<cfquery name="get_training_request" datasource="#dsn#">
	SELECT * FROM TRAINING_REQUEST WHERE TRAIN_REQUEST_ID = #attributes.train_req_id# AND REQUEST_TYPE = 3 <!--- yıllık eğitim talebi--->
</cfquery>

<cf_popup_box title="Yıllık Eğitim Talebi">
	<cfoutput>
	<table>
		<tr height="20">
			<td class="txtbold"><cf_get_lang_main no='70.Aşama'></td>
			<td>:
				<cfquery name="get_stage" datasource="#dsn#">
					SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = #get_training_request.process_stage#
				</cfquery>
				#get_stage.stage#
			</td>
		</tr>
		<tr height="20">
			<td class="txtbold">Dönem</td>
			<td>: #get_training_request.request_year#</td>
		</tr>
		<tr>
			<td class="txtbold">Eğitimi Talep Eden</td>
			<td>: #get_emp_info(get_training_request.employee_id,0,0)#</td>
		</tr>
		<tr>
			<td class="txtbold">Onay1</td>
			<td>: <cfif len(get_training_request.FIRST_BOSS_CODE)>#get_emp_info(get_training_request.FIRST_BOSS_CODE,1,0)#</cfif></td>
		</tr>
		<tr>
			<td class="txtbold">Onay1 Açıklama</td>
			<td>: #get_training_request.first_boss_detail#</td>
		</tr>
		<tr>
			<td class="txtbold">Onay2</td>
			<td>: <cfif len(get_training_request.second_boss_code)>#get_emp_info(get_training_request.second_boss_code,1,0)#</cfif></td>
		</tr>
		<tr>
			<td class="txtbold">Onay2  Açıklama</td>
			<td>: #get_training_request.second_boss_detail#</td>
		</tr>
		<tr>
			<td class="txtbold">IK Onay</td>
			<td>: <cfif len(get_training_request.third_boss_id)>#get_emp_info(get_training_request.third_boss_id,0,0)#</cfif></td>
		</tr>
		<tr>
			<td class="txtbold">IK Onay Açıklama</td>
			<td>: #get_training_request.third_boss_detail#</td>
		</tr>
		<tr>
			<td class="txtbold">Yönetici Onay</td>
			<td>: <cfif len(get_training_request.fourth_boss_id)>#get_emp_info(get_training_request.fourth_boss_id,0,0)#</cfif></td>
		</tr>
		<tr>
			<td class="txtbold">Yönetici Açıklama</td>
			<td>: #get_training_request.fourth_boss_detail#</td>
		</tr>
	</table>
	</cfoutput>
	<br />
	<cf_form_list>
		<input type="hidden" name="add_row_info" id="add_row_info" value="">
		<thead>
			<tr>
				<td colspan="6" class="txtbold">Eğitimler</td>
			</tr>
			<tr>
				<th width="250">Konu</th>
				<th width="70">Öncelik</th>
				<th width="70">Onay1</th>
				<th width="70">Onay2</th>
				<th width="70">IK Onay</th>
				<th width="70">Yönetici Onay</th>
			</tr>
		</thead>
		<cfquery name="get_request_row" datasource="#dsn#">
			SELECT 
				T.TRAIN_HEAD,
				TRR.TRAINING_PRIORITY,
				TRR.IS_VALID,
				TRR.IS_VALID2,
				TRR.IS_VALID3,
				TRR.IS_VALID4
			FROM	
				TRAINING_REQUEST_ROWS TRR INNER JOIN TRAINING T
				ON TRR.TRAINING_ID = T.TRAIN_ID 
			WHERE
				TRR.TRAIN_REQUEST_ID = #attributes.train_req_id#
			ORDER BY
				TRR.TRAINING_PRIORITY
		</cfquery>
		<tbody>
			<cfoutput query="get_request_row">
				<tr>
					<td>#train_head#</td>
					<td>#training_priority#</td>
					<td>
						<cfif len(get_training_request.first_boss_code) and len(get_training_request.first_boss_valid_date)>
							<cfif is_valid eq 1>Onay<cfelse>Red</cfif>
						<cfelseif len(get_training_request.first_boss_code) and not len(get_training_request.first_boss_valid_date)>
							Onay Bekleniyor
						</cfif>
					</td>
					<td>
						<cfif len(get_training_request.second_boss_id) and len(get_training_request.second_boss_valid_date)>
							<cfif is_valid2 eq 1>Onay<cfelse>Red</cfif>
						<cfelseif len(get_training_request.second_boss_code) and not len(get_training_request.second_boss_valid_date)>
							Onay Bekleniyor
						</cfif>
					</td>
					<td>
						<cfif len(get_training_request.third_boss_id) and len(get_training_request.third_boss_valid_date)>
							<cfif is_valid3 eq 1>Onay<cfelse>Red</cfif>
						<cfelseif len(get_training_request.third_boss_id) and not len(get_training_request.third_boss_valid_date)>
							Onay Bekleniyor
						</cfif>
					</td>
					<td>
						<cfif len(get_training_request.fourth_boss_code) and len(get_training_request.fourth_boss_valid_date)>
							<cfif is_valid4 eq 1>Onay<cfelse>Red</cfif>
						<cfelseif len(get_training_request.fourth_boss_code) and not len(get_training_request.fourth_boss_valid_date)>
							Onay Bekleniyor
						</cfif>
					</td>
				</tr>
			</cfoutput>
		</tbody>
	</cf_form_list>
</cf_popup_box>

