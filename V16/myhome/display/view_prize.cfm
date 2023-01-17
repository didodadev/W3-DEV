<cfif fusebox.circuit eq 'myhome'><!---20131109--->
    <cfset attributes.prize_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.prize_id,accountKey:session.ep.userid)>
</cfif>
<cfquery name="GET_PRIZE" datasource="#DSN#">
  SELECT * FROM EMPLOYEES_PRIZE WHERE PRIZE_ID = #attributes.PRIZE_ID#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='31164.Ödüller'></cfsavecontent>
<cf_popup_box title="#message#">
	<table> 
    	<cfoutput query="GET_PRIZE">	
            <tr>
                <td width="100" class="txtbold" nowrap><cf_get_lang dictionary_id='57480.Başlık'></td>
                <td>#prize_head#</td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang dictionary_id ='31856.Ödül Veren'></td>
                <td>#get_emp_info(prize_give_person,0,1)#</td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang dictionary_id ='31857.Ödül Alan'></td>
                <td>#get_emp_info(prize_to,0,1)#</td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></td>
                <td>#prize_detail#</td>
            </tr>
        </cfoutput>
	</table>
</cf_popup_box>

