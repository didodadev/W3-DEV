<cfif isdefined("attributes.deger")>
	<cfif attributes.amir_1_id neq attributes.amir_id_1_old>
		<cfquery name="UPD_MAIN" datasource="#dsn#">
			UPDATE
				TRAINING_REQUEST 
			SET
				FIRST_BOSS_ID = #attributes.amir_1_id#,
				FIRST_BOSS_CODE = #attributes.amir_code_1#,
				SECOND_BOSS_ID = <cfif len(attributes.amir_2_id)>#attributes.amir_2_id#,<cfelse>NULL,</cfif>
				SECOND_BOSS_CODE = <cfif len(attributes.amir_code_2)>#attributes.amir_code_2#,<cfelse>NULL,</cfif>
				THIRD_BOSS_ID = <cfif len(attributes.amir_3_id)>#attributes.amir_3_id#,<cfelse>NULL,</cfif>
				THIRD_BOSS_CODE = <cfif len(attributes.amir_code_3)>#attributes.amir_code_3#,<cfelse>NULL,</cfif>
				FOURTH_BOSS_ID = <cfif len(attributes.amir_4_id)>#attributes.amir_4_id#,<cfelse>NULL,</cfif>
				FOURTH_BOSS_CODE = <cfif len(attributes.amir_code_4)>#attributes.amir_code_4#,<cfelse>NULL,</cfif>
				FIFTH_BOSS_ID = <cfif len(attributes.amir_5_id)>#attributes.amir_5_id#,<cfelse>NULL,</cfif>
				FIFTH_BOSS_CODE = <cfif len(attributes.amir_code_5)>#attributes.amir_code_5#<cfelse>NULL</cfif>
			WHERE
				TRAIN_REQUEST_ID = #attributes.train_req_id#
		</cfquery>
		<cfquery name="UPD_ROW" datasource="#dsn#">
			UPDATE 
				TRAINING_REQUEST_ROWS 
			SET
				FIRST_BOSS_VALID_ROW = NULL,
				FIRST_BOSS_DATE_ROW = NULL,
				FIRST_BOSS_DETAIL_ROW = NULL,
				SECOND_BOSS_VALID_ROW = NULL,
				SECOND_BOSS_DATE_ROW = NULL,
				SECOND_BOSS_DETAIL_ROW = NULL,
				THIRD_BOSS_VALID_ROW = NULL,
				THIRD_BOSS_DATE_ROW = NULL,
				THIRD_BOSS_DETAIL_ROW = NULL,
				FOURTH_BOSS_VALID_ROW = NULL,
				FOURTH_BOSS_DATE_ROW = NULL,
				FOURTH_BOSS_DETAIL_ROW = NULL,
				FIFTH_BOSS_VALID_ROW = NULL,
				FIFTH_BOSS_DATE_ROW = NULL,
				FIFTH_BOSS_DETAIL_ROW = NULL
			WHERE 
				TRAIN_REQUEST_ID = #attributes.train_req_id#
		</cfquery>
	<cfelseif attributes.amir_2_id neq attributes.amir_id_2_old>
		<cfquery name="UPD_MAIN" datasource="#dsn#">
			UPDATE
				TRAINING_REQUEST 
			SET
				SECOND_BOSS_ID = <cfif len(attributes.amir_2_id)>#attributes.amir_2_id#,<cfelse>NULL,</cfif>
				SECOND_BOSS_CODE = <cfif len(attributes.amir_code_2)>#attributes.amir_code_2#,<cfelse>NULL,</cfif>
				THIRD_BOSS_ID = <cfif len(attributes.amir_3_id)>#attributes.amir_3_id#,<cfelse>NULL,</cfif>
				THIRD_BOSS_CODE = <cfif len(attributes.amir_code_3)>#attributes.amir_code_3#,<cfelse>NULL,</cfif>
				FOURTH_BOSS_ID = <cfif len(attributes.amir_4_id)>#attributes.amir_4_id#,<cfelse>NULL,</cfif>
				FOURTH_BOSS_CODE = <cfif len(attributes.amir_code_4)>#attributes.amir_code_4#,<cfelse>NULL,</cfif>
				FIFTH_BOSS_ID = <cfif len(attributes.amir_5_id)>#attributes.amir_5_id#,<cfelse>NULL,</cfif>
				FIFTH_BOSS_CODE = <cfif len(attributes.amir_code_5)>#attributes.amir_code_5#<cfelse>NULL</cfif>
			WHERE
				TRAIN_REQUEST_ID = #attributes.train_req_id#
		</cfquery>
		<cfquery name="UPD_ROW" datasource="#dsn#">
			UPDATE 
				TRAINING_REQUEST_ROWS 
			SET
				SECOND_BOSS_VALID_ROW = NULL,
				SECOND_BOSS_DATE_ROW = NULL,
				SECOND_BOSS_DETAIL_ROW = NULL,
				THIRD_BOSS_VALID_ROW = NULL,
				THIRD_BOSS_DATE_ROW = NULL,
				THIRD_BOSS_DETAIL_ROW = NULL,
				FOURTH_BOSS_VALID_ROW = NULL,
				FOURTH_BOSS_DATE_ROW = NULL,
				FOURTH_BOSS_DETAIL_ROW = NULL,
				FIFTH_BOSS_VALID_ROW = NULL,
				FIFTH_BOSS_DATE_ROW = NULL,
				FIFTH_BOSS_DETAIL_ROW = NULL
			WHERE 
				TRAIN_REQUEST_ID = #attributes.train_req_id#
		</cfquery>
	<cfelseif attributes.amir_3_id neq attributes.amir_id_3_old>
		<cfquery name="UPD_MAIN" datasource="#dsn#">
			UPDATE
				TRAINING_REQUEST 
			SET
				THIRD_BOSS_ID = <cfif len(attributes.amir_3_id)>#attributes.amir_3_id#,<cfelse>NULL,</cfif>
				THIRD_BOSS_CODE = <cfif len(attributes.amir_code_3)>#attributes.amir_code_3#,<cfelse>NULL,</cfif>
				FOURTH_BOSS_ID = <cfif len(attributes.amir_4_id)>#attributes.amir_4_id#,<cfelse>NULL,</cfif>
				FOURTH_BOSS_CODE = <cfif len(attributes.amir_code_4)>#attributes.amir_code_4#,<cfelse>NULL,</cfif>
				FIFTH_BOSS_ID = <cfif len(attributes.amir_5_id)>#attributes.amir_5_id#,<cfelse>NULL,</cfif>
				FIFTH_BOSS_CODE = <cfif len(attributes.amir_code_5)>#attributes.amir_code_5#<cfelse>NULL</cfif>
			WHERE
				TRAIN_REQUEST_ID = #attributes.train_req_id#
		</cfquery>
		<cfquery name="UPD_ROW" datasource="#dsn#">
			UPDATE 
				TRAINING_REQUEST_ROWS 
			SET
				THIRD_BOSS_VALID_ROW = NULL,
				THIRD_BOSS_DATE_ROW = NULL,
				THIRD_BOSS_DETAIL_ROW = NULL,
				FOURTH_BOSS_VALID_ROW = NULL,
				FOURTH_BOSS_DATE_ROW = NULL,
				FOURTH_BOSS_DETAIL_ROW = NULL,
				FIFTH_BOSS_VALID_ROW = NULL,
				FIFTH_BOSS_DATE_ROW = NULL,
				FIFTH_BOSS_DETAIL_ROW = NULL
			WHERE 
				TRAIN_REQUEST_ID = #attributes.train_req_id#
		</cfquery>
	<cfelseif attributes.amir_4_id neq attributes.amir_id_4_old>
		<cfquery name="UPD_MAIN" datasource="#dsn#">
			UPDATE
				TRAINING_REQUEST 
			SET
				FOURTH_BOSS_ID = <cfif len(attributes.amir_4_id)>#attributes.amir_4_id#,<cfelse>NULL,</cfif>
				FOURTH_BOSS_CODE = <cfif len(attributes.amir_code_4)>#attributes.amir_code_4#,<cfelse>NULL,</cfif>
				FIFTH_BOSS_ID = <cfif len(attributes.amir_5_id)>#attributes.amir_5_id#,<cfelse>NULL,</cfif>
				FIFTH_BOSS_CODE = <cfif len(attributes.amir_code_5)>#attributes.amir_code_5#<cfelse>NULL</cfif>
			WHERE
				TRAIN_REQUEST_ID = #attributes.train_req_id#
		</cfquery>
		<cfquery name="UPD_ROW" datasource="#dsn#">
			UPDATE 
				TRAINING_REQUEST_ROWS 
			SET
				FOURTH_BOSS_VALID_ROW = NULL,
				FOURTH_BOSS_DATE_ROW = NULL,
				FOURTH_BOSS_DETAIL_ROW = NULL,
				FIFTH_BOSS_VALID_ROW = NULL,
				FIFTH_BOSS_DATE_ROW = NULL,
				FIFTH_BOSS_DETAIL_ROW = NULL
			WHERE 
				TRAIN_REQUEST_ID = #attributes.train_req_id#
		</cfquery>
	<cfelseif attributes.amir_5_id neq attributes.amir_id_5_old>
		<cfquery name="UPD_MAIN" datasource="#dsn#">
			UPDATE
				TRAINING_REQUEST 
			SET
				FIFTH_BOSS_ID = <cfif len(attributes.amir_5_id)>#attributes.amir_5_id#,<cfelse>NULL,</cfif>
				FIFTH_BOSS_CODE = <cfif len(attributes.amir_code_5)>#attributes.amir_code_5#<cfelse>NULL</cfif>
			WHERE
				TRAIN_REQUEST_ID = #attributes.train_req_id#
		</cfquery>
		<cfquery name="UPD_ROW" datasource="#dsn#">
			UPDATE 
				TRAINING_REQUEST_ROWS 
			SET
				FIFTH_BOSS_VALID_ROW = NULL,
				FIFTH_BOSS_DATE_ROW = NULL,
				FIFTH_BOSS_DETAIL_ROW = NULL
			WHERE 
				TRAIN_REQUEST_ID = #attributes.train_req_id#
		</cfquery>
	</cfif>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<cfif not isdefined("attributes.submit_type")>
	
			<table cellspacing="1" cellpadding="2" border="0" width="98%" height="100%" class="color-border" align="center">
			  <tr class="color-list" valign="middle">
				<td height="35" class="headbold">&nbsp;Eğitim Talebi Onayla</td>
			  </tr>
			  <tr class="color-row" valign="top">
				<td>
				<table>
				<cfform name="add_notes" method="post" action="">
				<input type="hidden" name="type" id="type" value="<cfoutput>#attributes.type#</cfoutput>">
				<input type="hidden" name="submit_type" id="submit_type" value="1">
				<input type="hidden" name="request_row_id" id="request_row_id" value="<cfoutput>#attributes.request_row_id#</cfoutput>">
				  <tr>
					<td width="5"></td>
					<td valign="top"><cf_get_lang_main no='217.Açıklama'> *</td>
					<td><textarea style="width:220;height:70px;" name="detail" id="detail"></textarea></td>
				  </tr>
				  <tr>
					<td></td>
					<td></td>
					<td height="25"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
				  </tr>
				</cfform>
				</table>
				</td>
			  </tr>
			</table>
		<script type="text/javascript">
		function kontrol()
		{
			if(document.add_notes.detail.value=="")
			{
				alert("<cf_get_lang_main no ='217.Açıklama'> !");
				return false;
			}
			x=(250 - document.add_notes.detail.value.length);
			if(x<0)
			{ 
				alert ("Açıklama "+ ((-1) * x) +" Karakter Uzun !");
				return false;
			}
			return true;
		}
		</script>
	<cfelse>
		<cfif attributes.type eq 1>
			<cfquery name="UPD_ROW" datasource="#dsn#">
				UPDATE
					TRAINING_REQUEST_ROWS
				SET
					FIRST_BOSS_VALID_ROW = 1,
					FIRST_BOSS_DATE_ROW = #now()#,
					FIRST_BOSS_DETAIL_ROW = '#attributes.detail#'
				WHERE
					REQUEST_ROW_ID = #attributes.request_row_id#
			</cfquery>
		<cfelseif attributes.type eq 2>
			<cfquery name="UPD_ROW" datasource="#dsn#">
				UPDATE
					TRAINING_REQUEST_ROWS
				SET
					SECOND_BOSS_VALID_ROW = 1,
					SECOND_BOSS_DATE_ROW = #now()#,
					SECOND_BOSS_DETAIL_ROW = '#attributes.detail#'
				WHERE
					REQUEST_ROW_ID = #attributes.request_row_id#
			</cfquery>
		<cfelseif attributes.type eq 3>
			<cfquery name="UPD_ROW" datasource="#dsn#">
				UPDATE
					TRAINING_REQUEST_ROWS
				SET
					THIRD_BOSS_VALID_ROW = 1,
					THIRD_BOSS_DATE_ROW = #now()#,
					THIRD_BOSS_DETAIL_ROW = '#attributes.detail#'
				WHERE
					REQUEST_ROW_ID = #attributes.request_row_id#
			</cfquery>
		<cfelseif attributes.type eq 4>
			<cfquery name="UPD_ROW" datasource="#dsn#">
				UPDATE
					TRAINING_REQUEST_ROWS
				SET
					FOURTH_BOSS_VALID_ROW = 1,
					FOURTH_BOSS_DATE_ROW = #now()#,
					FOURTH_BOSS_DETAIL_ROW = '#attributes.detail#'
				WHERE
					REQUEST_ROW_ID = #attributes.request_row_id#
			</cfquery>
		<cfelseif attributes.type eq 5>
			<cfquery name="UPD_ROW" datasource="#dsn#">
				UPDATE
					TRAINING_REQUEST_ROWS
				SET
					FIFTH_BOSS_VALID_ROW = 1,
					FIFTH_BOSS_DATE_ROW = #now()#,
					FIFTH_BOSS_DETAIL_ROW = '#attributes.detail#'
				WHERE
					REQUEST_ROW_ID = #attributes.request_row_id#
			</cfquery>
		</cfif>
		<script type="text/javascript">
			wrk_opener_reload();
			window.close();
		</script>
	</cfif>
</cfif>
