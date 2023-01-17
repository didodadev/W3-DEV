<cfquery name="GET_PRIZE" datasource="#DSN#">
  SELECT 
      EMPLOYEES_PRIZE.PRIZE_ID, 
      EMPLOYEES_PRIZE.PRIZE_HEAD, 
      EMPLOYEES_PRIZE.PRIZE_DETAIL, 
      SETUP_PRIZE_TYPE.PRIZE_TYPE_ID, 
      EMPLOYEES_PRIZE.PRIZE_DATE, 
      EMPLOYEES_PRIZE.PRIZE_GIVE_PERSON, 
      EMPLOYEES_PRIZE.PRIZE_TO, 
	  SETUP_PRIZE_TYPE.PRIZE_TYPE,
      EMPLOYEES_PRIZE.RECORD_DATE, 
      EMPLOYEES_PRIZE.RECORD_EMP, 
      EMPLOYEES_PRIZE.RECORD_IP, 
      EMPLOYEES_PRIZE.UPDATE_DATE, 
      EMPLOYEES_PRIZE.UPDATE_EMP, 
      EMPLOYEES_PRIZE.UPDATE_IP	 	
  FROM 
	  EMPLOYEES_PRIZE INNER JOIN SETUP_PRIZE_TYPE
	  ON EMPLOYEES_PRIZE.PRIZE_TYPE_ID = SETUP_PRIZE_TYPE.PRIZE_TYPE_ID
  WHERE 
  	PRIZE_ID = #URL.PRIZE_ID#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53122.Ödül"></cfsavecontent>
<cf_popup_box title="#message#">
	<cfoutput query="GET_PRIZE">	  
		<table  border="0"> 
			<tr>
				<td width="5"></td>
				<td width="65" class="txtbold"><cf_get_lang dictionary_id='58820.Başlık'></td>
				<td>#prize_head#</td>
			</tr>
			<tr>
				<td></td>
				<td class="txtbold"><cf_get_lang dictionary_id='57630.Tip'></td>
				<td>#prize_type#</td>
			</tr>
			<tr>
				<td></td>
				<td class="txtbold"><cf_get_lang dictionary_id='53124.Ödül Veren'></td>
				<td>#get_emp_info(prize_give_person,0,0)#</td>
			</tr>
			<tr>
				<td></td>
				<td class="txtbold"><cf_get_lang dictionary_id="53123.Ödül Alan"></td>
				<td>#get_emp_info(prize_to,0,0)#</td>
			</tr>
			<tr>
				<td></td>
				<td class="txtbold" colspan="2"><cf_get_lang dictionary_id='57629.Açıklama'></td>
			</tr>
			<tr>
				<td></td>
				<td colspan="2">#prize_detail#</td>
			</tr>
		</table>
	</cfoutput>
</cf_popup_box>

