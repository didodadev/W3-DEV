<!--- 20121116 SG eğitim talebi katalog ve katalog dışı talep display sayfası--->
<cfif fusebox.circuit eq 'myhome'>
    <cfset attributes.train_req_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.train_req_id,accountKey:session.ep.userid)>
</cfif>
<cfquery name="get_request" datasource="#dsn#">
	SELECT 
		TR.START_DATE,
		TR.FINISH_DATE,
		TR.EMPLOYEE_ID,
		TR.PURPOSE,
		TR.DETAIL,
		TR.PROCESS_STAGE,
		TR.REQUEST_TYPE,
		TR.TOTAL_HOUR,
		TR.TRAINING_PLACE,
		TR.TRAINER,
		TR.TRAINING_COST,
		(SELECT DISTINCT TRAIN_HEAD FROM TRAINING T,TRAINING_REQUEST_ROWS TRR WHERE T.TRAIN_ID = TRR.TRAINING_ID AND TRR.TRAIN_REQUEST_ID =TR.TRAIN_REQUEST_ID ) AS TRAIN_HEAD,
		(SELECT DISTINCT OTHER_TRAIN_NAME FROM TRAINING_REQUEST_ROWS TRR WHERE TRR.TRAIN_REQUEST_ID =TR.TRAIN_REQUEST_ID ) AS OTHER_TRAIN_NAME,
		TR.FIRST_BOSS_CODE,
		TR.FIRST_BOSS_VALID_DATE,
		TR.SECOND_BOSS_CODE,
		TR.SECOND_BOSS_VALID_DATE,
		TR.FIRST_BOSS_DETAIL,
		TR.FIRST_BOSS_ID,
		TR.SECOND_BOSS_DETAIL,
		TR.SECOND_BOSS_ID,
		TR.THIRD_BOSS_ID,
		TR.THIRD_BOSS_CODE,
		TR.THIRD_BOSS_DETAIL,
		TR.THIRD_BOSS_VALID_DATE,
		TR.FOURTH_BOSS_CODE,
		TR.FOURTH_BOSS_DETAIL,
		TR.FOURTH_BOSS_VALID_DATE,
		TR.THIRD_BOSS_VALID_DATE
	FROM 
		TRAINING_REQUEST TR
	WHERE
		TR.TRAIN_REQUEST_ID =#attributes.train_req_id#
</cfquery>
<cf_popup_box>
	<cfoutput>
	<table>
		<tr>
			<td class="txtbold"><cfif get_request.request_type eq 1>Katalog<cfelseif get_request.request_type eq 2>Katalog Dışı</cfif></td>
		</tr>
		<tr height="20">
			<td class="txtbold"><cf_get_lang_main no='70.Aşama'></td>
			<td>:
				<cfquery name="get_stage" datasource="#dsn#">
					SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = #get_request.process_stage#
				</cfquery>
				#get_stage.stage#
			</td>
		</tr>
		<cfif get_request.request_type eq 1>
		<tr height="20">
			<td class="txtbold"><cf_get_lang_main no='7.Eğitim'></td>
			<td>: #get_request.train_head#</td>
		</tr>
		<cfelse>
		<tr height="20">
			<td class="txtbold">Eğitim Adı</td>
			<td>: #get_request.other_train_name#</td>
		</tr>
		</cfif>
		<tr height="20">
			<td valign="top" class="txtbold">Amacı</td>
			<td>: #get_request.purpose#</td>
		</tr>
		<tr height="20">
			<td class="txtbold"><cf_get_lang_main no='89.Başlangıç'>-<cf_get_lang_main no='90.Bitiş'></td>
			<td>: #dateformat(get_request.start_date,dateformat_style)#-#dateformat(get_request.finish_date,dateformat_style)#</td>
		</tr>
		<cfif get_request.request_type eq 2>
		<tr height="20">
			<td class="txtbold">Toplam Saat</td>
			<td>: #get_request.total_hour#</td>
		</tr>
		<tr height="20">
			<td class="txtbold">Eğitim Yeri</td>
			<td>: #get_request.TRAINING_PLACE#</td>
		</tr>
		<tr height="20">
			<td class="txtbold">Firma, Eğitmen</td>
			<td>: #get_request.trainer#</td>
		</tr>
		<tr height="20">
			<td class="txtbold">Maliyet</td>
			<td>: #TLFORMAT(get_request.training_cost)#</td>
		</tr>
		</cfif>
		<tr height="20">
			<td class="txtbold">Eğitimi Talep Eden</td>
			<td>: #get_emp_info(get_request.employee_id,0,0)#</td>
		</tr>
		<tr height="20">
			<td class="txtbold">Pozisyonu</td>
			<td>:
				<cfquery name="get_position_name" datasource="#dsn#">
					SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#
				</cfquery>
				<cfif get_position_name.recordcount>
					<cfoutput>#get_position_name.position_name#</cfoutput>
				</cfif>
			</td>
		</tr>
		<tr height="20">
			<td valign="top" class="txtbold"><cf_get_lang_main no='217.Açıklama'></td>
			<td>: #get_request.detail#</td>
		</tr>
		<tr>
			<td class="txtbold">Onay1</td>
			<td>: <cfif len(get_request.first_boss_code)>#get_emp_info(get_request.first_boss_code,1,0)# 
			<cfif len(get_request.first_boss_valid_date)>(#dateformat(get_request.first_boss_valid_date,dateformat_style)#)<cfelse>Onay Bekleniyor</cfif></cfif></td>
		</tr>
		<tr>
			<td class="txtbold">Açıklama</td>
			<td>: #get_request.first_boss_detail#</td>
		</tr>
		<tr>
			<td class="txtbold">Onay2</td>
			<td>: 
				<cfif len(get_request.second_boss_code)>
					#get_emp_info(get_request.second_boss_code,1,0)# 
				<cfif len(get_request.second_boss_valid_date)>(#dateformat(get_request.second_boss_valid_date,dateformat_style)#)<cfelse>Onay Bekleniyor</cfif>
				</cfif>
			</td>
		</tr>
		<tr>
			<td class="txtbold">Açıklama</td>
			<td>: #get_request.second_boss_detail#</td>
		</tr>
		<tr>
			<td class="txtbold">IK Onay</td>
			<td>: 
				<cfif len(get_request.third_boss_id)>
					#get_emp_info(get_request.third_boss_id,0,0)#
					<cfif len(get_request.third_boss_valid_date)>(#dateformat(get_request.third_boss_valid_date,dateformat_style)#)<cfelse>Onay Bekleniyor</cfif>
				</cfif>
			</td>
		</tr>
		<tr>
			<td class="txtbold">Açıklama</td>
			<td>: #get_request.third_boss_detail#</td>
		</tr>
		<tr>
			<td class="txtbold">Yönetici Onay</td>
			<td>:
				<cfif len(get_request.fourth_boss_code)>
					#get_emp_info(get_request.fourth_boss_code,1,0)#
					<cfif len(get_request.fourth_boss_valid_date)>(#dateformat(get_request.fourth_boss_valid_date,'dd/mm/yyyyy')#)<cfelse>Onay Bekleniyor</cfif>
				</cfif>
			</td>
		</tr>
		<tr>
			<td class="txtbold">Açıklama</td>
			<td>: #get_request.fourth_boss_detail#</td>
		</tr>
	</table>
	</cfoutput>
	<cf_form_list style="width:500px;">
		<thead>
			<tr height="20">
				<th></th>
				<th width="200">Çalışan</th>
				<th width="70">1.Amir</th>
				<th width="70">2.Amir</th>
				<th width="70">IK</th>
				<th width="70">Yönetici</th>
			</tr>
		</thead>
		<cfquery name="get_training_request_rows" datasource="#dsn#">
			SELECT
				E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS ADSOYAD,
				TRR.IS_VALID,
				TRR.IS_VALID2,
				TRR.IS_VALID3,
				TRR.IS_VALID4
			FROM
				TRAINING_REQUEST_ROWS TRR INNER JOIN EMPLOYEES E
				ON TRR.EMPLOYEE_ID = E.EMPLOYEE_ID
			WHERE
				TRAIN_REQUEST_ID = #attributes.train_req_id#	
		</cfquery>
		<tbody>
			<cfoutput query="get_training_request_rows">
				<tr>
					<td>#currentrow#</td>
					<td>#ADSOYAD#</td>
					<td>
						<cfif len(get_request.first_boss_code) and len(get_request.first_boss_valid_date)>
							<cfif is_valid eq 1>Onay<cfelse>Red</cfif>
						<cfelseif len(get_request.first_boss_code) and not len(get_request.first_boss_valid_date)>
							Onay Bekleniyor
						</cfif>
					</td>
					<td>
						<cfif len(get_request.second_boss_id) and len(get_request.second_boss_valid_date)>
							<cfif is_valid2 eq 1>Onay<cfelse>Red</cfif>
						<cfelseif len(get_request.second_boss_code) and not len(get_request.second_boss_valid_date)>
							Onay Bekleniyor
						</cfif>
					</td>
					<td>
						<cfif len(get_request.third_boss_id) and len(get_request.third_boss_valid_date)>
							<cfif is_valid3 eq 1>Onay<cfelse>Red</cfif>
						<cfelseif <!---len(get_request.third_boss_id) and---> not len(get_request.third_boss_valid_date)>
							Onay Bekleniyor
						</cfif>
					</td>
					<td>
						<cfif len(get_request.fourth_boss_code) and len(get_request.fourth_boss_valid_date)>
							<cfif is_valid4 eq 1>Onay<cfelse>Red</cfif>
						<cfelseif len(get_request.fourth_boss_code) and not len(get_request.fourth_boss_valid_date)>
							Onay Bekleniyor
						</cfif>
					</td>
				</tr>
			</cfoutput>
		</tbody>
	</cf_form_list>
</cf_popup_box>
