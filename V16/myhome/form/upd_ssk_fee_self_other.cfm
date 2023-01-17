<cfif fusebox.circuit eq 'myhome'>
    <cfset attributes.fee_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.fee_id,accountKey:session.ep.userid)>
    <cfset attributes.my_emp_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.my_emp_id,accountKey:session.ep.userid)>
    <cfset attributes.inout_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.inout_id,accountKey:session.ep.userid)>
</cfif>
<cfquery name="GET_VISITS" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		EMPLOYEES_SSK_FEE 
	WHERE 
		FEE_ID = #attributes.FEE_ID#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='31723.Vizite Güncelle'></cfsavecontent>
<cf_popup_box title="#message#">
	<cfif not len(GET_VISITS.valid_1) or not len(GET_VISITS.valid_2)> 
        <cfform name="vizit_request" method="post" action="#request.self#?fuseaction=myhome.emptypopup_upd_other_visits">
        <input type="hidden" name="fee_id" id="fee_id" value="<cfoutput>#GET_VISITS.FEE_ID#</cfoutput>">
        <input type="hidden" name="valid" id="valid" value="">
        <input type="hidden" name="valid_1" id="valid_1" value="">
        <input type="hidden" name="valid_2" id="valid_2" value="">
            <table>
                <tr height="20"> 
                    <td class="txtbold" width="100"><cf_get_lang dictionary_id='57576.Çalışan'></td>
                    <td><cfoutput>#get_emp_info(GET_VISITS.employee_id,0,0)#</cfoutput></td>
                    </tr>
                <tr height="20"> 
                    <td  class="txtbold"><cf_get_lang dictionary_id='57501.Başlama'></td>
                    <td><cfoutput>#dateformat(get_visits.fee_date,dateformat_style)# (#timeformat(get_visits.fee_hour,timeformat_style)#)</cfoutput></td>
                </tr>
                <tr height="20"> 
                    <td  class="txtbold"><cf_get_lang dictionary_id='57502.Bitiş'></td>
                    <td><cfoutput>#dateformat(get_visits.fee_dateout,dateformat_style)# (#timeformat(get_visits.fee_hourout,timeformat_style)#)</cfoutput></td>
                </tr>
                <tr height="20"> 
                    <td  class="txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></td>
                    <td><cfoutput>#get_visits.event#</cfoutput></td>
                </tr>
                <tr height="20"> 
                    <td  class="txtbold"><cf_get_lang dictionary_id ='57500.Onay'>1</td>
                    <td> 
                    	<cfif len(get_visits.validator_pos_code)>
                            <cfset pos_temp = "#get_emp_info(get_visits.validator_pos_code,1,0)#">
							<cfif get_visits.valid EQ 1>
                                <cf_get_lang dictionary_id='58699.Onaylandı'> !
                                <cfoutput>#pos_temp#</cfoutput>
                            <cfelseif get_visits.valid EQ 0>
                                <cf_get_lang dictionary_id='57617.Reddedildi'> !
                                <cfoutput>#pos_temp#</cfoutput>
                            <cfelse>
                                <input type="Hidden" name="validator_pos_code" id="validator_pos_code" value="<cfoutput>#get_visits.validator_pos_code#</cfoutput>"> 
                                <cfoutput>#pos_temp#</cfoutput>
                                 <cfsavecontent variable="message"><cf_get_lang dictionary_id ='31575.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Onaylamak istediğinizden emin misiniz '></cfsavecontent>
                                <input type="Image" src="/images/valid.gif" alt="<cf_get_lang dictionary_id='58475.Onayla'>" onClick="if (confirm('<cfoutput>#message#</cfoutput>')) {vizit_request.valid.value='1'} else {return false}" border="0">
                                <input type="Image" src="/images/refusal.gif" alt="<cf_get_lang dictionary_id='58461.Reddet'>" onClick="if (confirm('<cfoutput>#message#</cfoutput>')) {vizit_request.valid.value='0'} else {return false}" border="0">
                            </cfif>
                        <cfelseif not len(get_visits.validator_pos_code) and len(get_visits.validator_pos_code_1)>
                            <cfset pos_temp_1 = "#get_emp_info(get_visits.validator_pos_code_1,1,0)#">
							<cfif get_visits.valid_1 EQ 1>
                                <cf_get_lang dictionary_id='58699.Onaylandı'> !
                                <cfoutput>#pos_temp_1#</cfoutput>
                            <cfelseif get_visits.valid_1 EQ 0>
                                <cf_get_lang dictionary_id='57617.Reddedildi'> !
                                <cfoutput>#pos_temp_1#</cfoutput>
                            <cfelse>
                                <input type="Hidden" name="validator_pos_code_1" id="validator_pos_code_1" value="<cfoutput>#get_visits.validator_pos_code_1#</cfoutput>"> 
                                <cfoutput>#pos_temp_1#</cfoutput>
                                 <cfsavecontent variable="message"><cf_get_lang dictionary_id ='31575.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Onaylamak istediğinizden emin misiniz '></cfsavecontent>
                                <input type="Image" src="/images/valid.gif" alt="<cf_get_lang dictionary_id='58475.Onayla'>" onClick="if (confirm('<cfoutput>#message#</cfoutput>')) {vizit_request.valid_1.value='1'} else {return false}" border="0">
                                <input type="Image" src="/images/refusal.gif" alt="<cf_get_lang dictionary_id='58461.Reddet'>" onClick="if (confirm('<cfoutput>#message#</cfoutput>')) {vizit_request.valid_1.value='0'} else {return false}" border="0">
                            </cfif>
                      	</cfif>
                    </td>
                </tr>
                <tr height="20"> 
                    <td  class="txtbold"><cf_get_lang dictionary_id ='57500.Onay'>2</td>
                    <td> 
                      <cfif len(get_visits.validator_pos_code_2)>
                         <cfset pos_temp_2 = "#get_emp_info(get_visits.validator_pos_code_2,1,0)#">
                      <cfelse>
                         <cfset pos_temp_2 = "">
                      </cfif> 
                      <cfif get_visits.validator_pos_code_2 eq session.ep.position_code>
                          <input type="Hidden" name="validator_pos_code_2" id="validator_pos_code_2" value="<cfoutput>#get_visits.validator_pos_code_2#</cfoutput>"> 
                          <cfinput type="hidden" name="validator_position_2" style="width:150px;"  value="#pos_temp_2#">
                          <cfoutput>#pos_temp_2#</cfoutput> <cfsavecontent variable="message"><cf_get_lang dictionary_id ='31575.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Onaylamak istediğinizden emin misiniz '></cfsavecontent>
                          <input type="Image" src="/images/valid.gif" alt="<cf_get_lang dictionary_id='58475.Onayla'>" onClick="if (confirm('<cfoutput>#message#</cfoutput>')) {vizit_request.valid_2.value='1'} else {return false}" border="0">
                          <input type="Image" src="/images/refusal.gif" alt="<cf_get_lang dictionary_id='58461.Reddet'>" onClick="if (confirm('<cfoutput>#message#</cfoutput>')) {vizit_request.valid_2.value='0'} else {return false}" border="0">
                      <cfelse>
                          <cfoutput>#pos_temp_2#</cfoutput>
                         <cf_get_lang dictionary_id ='57615.Onay Bekliyor'> !
                      </cfif>
                    </td>
                </tr>
            </table>
        </cfform>
	<cfelse>
		<table>
			<tr height="20"> 
				<td  class="txtbold" width="100"><cf_get_lang dictionary_id='57576.Çalışan'></td>
				<td><cfoutput>#get_emp_info(get_visits.employee_id,0,0)#</cfoutput></td>
			</tr>
			<tr height="20"> 
				<td  class="txtbold"><cf_get_lang dictionary_id='57501.Başlama'></td>
				<td><cfoutput>#dateformat(get_visits.fee_date,dateformat_style)# (#timeformat(get_visits.fee_hour,timeformat_style)#)</cfoutput></td>
			</tr>
			<tr height="20"> 
				<td  class="txtbold"><cf_get_lang dictionary_id='57502.Bitiş'></td>
				<td><cfoutput>#dateformat(get_visits.fee_dateout,dateformat_style)# (#timeformat(get_visits.fee_hourout,timeformat_style)#)</cfoutput></td>
			</tr>
			<tr height="20"> 
				<td  class="txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></td>
				<td><cfoutput>#get_visits.event#</cfoutput></td>
			</tr>
				<tr height="20"> 
				<td  class="txtbold"><cf_get_lang dictionary_id='30925.Onay Durumu'></td>
				<td> 
				<cfif get_visits.valid EQ 1>
				<cf_get_lang dictionary_id='58699.Onaylandı'> !
				<cfoutput>#get_emp_info(get_visits.VALID_EMP,0,0)# (#dateformat(get_visits.validdate,dateformat_style)# #timeformat(get_visits.validdate,timeformat_style)#)</cfoutput>
				<cfelseif get_visits.valid EQ 0>
				<cf_get_lang dictionary_id='57617.Reddedildi'> !
				<cfoutput>#get_emp_info(get_visits.VALID_EMP,0,0)# (#dateformat(get_visits.validdate,dateformat_style)# #timeformat(get_visits.validdate,timeformat_style)#)</cfoutput>
				</cfif>
				</td>
			</tr>
			<tr> 
				<td height="35" colspan="2"  style="text-align:right;">
				<input type="button" value="<cf_get_lang dictionary_id='57553.Kapat'>"  onClick="window.close();" style="width:65px;" > </td>
			</tr>
		</table>
	</cfif>
</cf_popup_box>