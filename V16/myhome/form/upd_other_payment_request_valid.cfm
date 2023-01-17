<cfif fusebox.circuit eq 'myhome'>
	<cfset attributes.id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.id,accountKey:'wrk')>
</cfif>
<cfquery name="get_payment_request" datasource="#DSN#">
	SELECT 
    	SPGR_ID, 
        AMOUNT_GET, 
        START_SAL_MON, 
        EMPLOYEE_ID, 
        DETAIL, 
        TAKSIT_NUMBER, 
        VALIDATOR_POSITION_CODE,
        VALID_EMP, 
        IS_VALID, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP, 
        VALID_1, 
        VALIDATOR_POSITION_CODE_1, 
        VALID_EMPLOYEE_ID_1, 
        VALIDDATE_1, 
        VALID_2, 
        VALIDATOR_POSITION_CODE_2, 
        VALID_EMPLOYEE_ID_2, 
        VALIDDATE_2 
    FROM 
	    SALARYPARAM_GET_REQUESTS 
    WHERE 
    	SPGR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfquery name="GET_REQUEST_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%myhome.popupform_upd_other_payment_request_valid%">
	ORDER BY 
		PTR.LINE_NUMBER
</cfquery>
<cfsavecontent variable="right">
	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=183&action_id=#attributes.id#&iid=1</cfoutput>','page','');"><img src="/images/print.gif" title="<cf_get_lang dictionary_id ='57474.Yazdır'>"></a>
</cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='31574.Taksitli Avans Talebi'></cfsavecontent>
<cf_popup_box title="#message#" right_images="#right#">
  <cfform name="form_upd_payment_request" method="post" action="#request.self#?fuseaction=myhome.emptypopup_upd_other_payment_request_valid">
  	<input type="hidden" name="process_stage" id="process_stage" value="<cfif get_request_stage.recordcount><cfoutput>#get_request_stage.process_row_id#</cfoutput></cfif>">
    <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
	<input type="hidden" name="valid_1" id="valid_1" value="">
	<input type="hidden" name="valid_2" id="valid_2" value="">
		<table>
			<cfoutput>
				<tr>
					<td class="txtbold" width="80"><cf_get_lang dictionary_id='57576.Çalışan'></td>
					<td>#get_emp_info(get_payment_request.EMPLOYEE_ID,0,0)#</td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='57673.Tutar'></td>				
					<td>#TLFormat(get_payment_request.AMOUNT_GET)#</td>				
				</tr>
				<tr>
					<td class="txtbold" ><cf_get_lang dictionary_id ='31550.Taksit Sayısı'></td>
					<td>#get_payment_request.TAKSIT_NUMBER#</td>
				</tr>
				<tr>
					<td valign="top" class="txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></td>				
					<td>#get_payment_request.DETAIL#</td>				
				</tr>
			</cfoutput>
			<tr height="20"> 
				<td class="txtbold"><cf_get_lang dictionary_id ='57500.Onay'>  1</td>
				<td> 
					<cfif len(get_payment_request.validator_position_code_1)>
						<cfset pos_temp_1 = "#get_emp_info(get_payment_request.validator_position_code_1,1,0)#">
					<cfelse>
						 <cfset pos_temp_1 = "">
					</cfif> 
					<cfif get_payment_request.valid_1 EQ 1>
						<cf_get_lang dictionary_id='58699.Onaylandı'> !
						<cfoutput>#pos_temp_1#</cfoutput>
					<cfelseif get_payment_request.valid_1 EQ 0>
						<cf_get_lang dictionary_id='57617.Reddedildi'> !
						<cfoutput>#pos_temp_1#</cfoutput>
					<cfelseif get_payment_request.validator_position_code_1 eq session.ep.position_code>
						<input type="Hidden" name="validator_position_code_1" id="validator_position_code_1" value="<cfoutput>#get_payment_request.validator_position_code_1#</cfoutput>"> 
						<cfinput type="hidden" name="validator_position_1" style="width:150px;" value="#pos_temp_1#">
						<cfoutput>#pos_temp_1#</cfoutput>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31575.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Onaylamak istediğinizden emin misiniz '></cfsavecontent>
						<input type="Image" src="/images/valid.gif" alt="<cf_get_lang dictionary_id='58475.Onayla'>" onClick="if (confirm('<cfoutput>#message#</cfoutput>')) {form_upd_payment_request.valid_1.value='1'} else {return false}" border="0">
						<cfsavecontent variable="message1"><cf_get_lang dictionary_id ='31576.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir reddetmek istediğinizden emin misiniz '></cfsavecontent>
						<input type="Image" src="/images/refusal.gif" alt="<cf_get_lang dictionary_id='58461.Reddet'>" onClick="if (confirm('<cfoutput>#message1#</cfoutput>')) {form_upd_payment_request.valid_1.value='0'} else {return false}" border="0">
					<cfelse>
						<cf_get_lang dictionary_id ='57615.Onay Bekliyor'> !
						<cfoutput>#pos_temp_1#</cfoutput>
					</cfif>
				</td>
			</tr>
			<tr height="20"> 
				<td class="txtbold"><cf_get_lang dictionary_id ='57500.Onay'> 2</td>
				<td> 
				  <cfif len(get_payment_request.validator_position_code_2)>
					 <cfset pos_temp_2 = "#get_emp_info(get_payment_request.validator_position_code_2,1,0)#">
				  <cfelse>
					 <cfset pos_temp_2 = "">
				  </cfif> 
				  <cfif len(get_payment_request.validator_position_code_2) and (get_payment_request.valid_1 eq 1)>
					  <cfif get_payment_request.valid_2 EQ 1>
							<cf_get_lang dictionary_id='58699.Onaylandı'> !
							<cfoutput>#pos_temp_2#</cfoutput>
					  <cfelseif get_payment_request.valid_2 EQ 0>
							<cf_get_lang dictionary_id='57617.Reddedildi'> !
							<cfoutput>#pos_temp_2#</cfoutput>
					  <cfelseif get_payment_request.validator_position_code_2 eq session.ep.position_code>
						  <input type="Hidden" name="validator_position_code_2"  id="validator_position_code_2"value="<cfoutput>#get_payment_request.validator_position_code_2#</cfoutput>"> 
						  <cfinput type="hidden" name="validator_position_2" style="width:150px;"  value="#pos_temp_2#">
						  <cfoutput>#pos_temp_2#</cfoutput>
						  <cfsavecontent variable="message"><cf_get_lang dictionary_id ='31575.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Onaylamak istediğinizden emin misiniz '></cfsavecontent>
						  <input type="Image" src="/images/valid.gif" alt="<cf_get_lang dictionary_id='58475.Onayla'>" onClick="if (confirm('<cfoutput>#message#</cfoutput>')) {form_upd_payment_request.valid_2.value='1'} else {return false}" border="0">
						  <cfsavecontent variable="message1"><cf_get_lang dictionary_id ='31576.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir reddetmek istediğinizden emin misiniz '></cfsavecontent>
						  <input type="Image" src="/images/refusal.gif" alt="<cf_get_lang dictionary_id='58461.Reddet'>" onClick="if (confirm('<cfoutput>#message1#</cfoutput>')) {form_upd_payment_request.valid_2.value='0'} else {return false}" border="0">
					  <cfelse>
						 <cf_get_lang dictionary_id ='57615.Onay Bekliyor'> !
						 <cfoutput>#pos_temp_2#</cfoutput>
					  </cfif>
					<cfelseif len(get_payment_request.validator_position_code_2) and (get_payment_request.valid_1 eq 0)>
						<cfoutput>#get_emp_info(get_payment_request.validator_position_code_2,1,0)#</cfoutput>
					<cfelseif len(get_payment_request.validator_position_code_2) and not len(get_payment_request.valid_2)>
						<cf_get_lang dictionary_id ='57615.Onay Bekliyor'> !
						<cfoutput>#get_emp_info(get_payment_request.validator_position_code_2,1,0)#</cfoutput>&nbsp;&nbsp;
					</cfif>
				</td>
			</tr>
			<tr height="20">
				<td class="txtbold"><cf_get_lang dictionary_id ='29661.HR'><cf_get_lang dictionary_id ='57500.Onay'></td>
				<td>
					<cfif get_payment_request.is_valid eq 1 and len(get_payment_request.valid_emp)>
						<cf_get_lang dictionary_id='58699.Onaylandı'> !
						<cfoutput>#get_emp_info(get_payment_request.valid_emp,0,0)#</cfoutput>
					<cfelseif get_payment_request.is_valid eq 0 and len(get_payment_request.valid_emp)>
						<cf_get_lang dictionary_id='57617.Reddedildi'> !
						<cfoutput>#get_emp_info(get_payment_request.valid_emp,0,0)#</cfoutput>
					<cfelse>
						<cf_get_lang dictionary_id ='57615.Onay Bekliyor'> !
					</cfif>
				</td>
			</tr>
		</table>
  </cfform>
</cf_popup_box>