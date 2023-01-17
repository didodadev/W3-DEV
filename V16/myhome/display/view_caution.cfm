<cfif fusebox.circuit eq 'myhome'><!---20131108--->
    <cfset attributes.caution_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.caution_id,accountKey:session.ep.userid)>
</cfif>
<cfinclude template="../query/get_caution.cfm">
<cfform name="view_caution">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='31741.İhtar'></cfsavecontent>
<cf_popup_box title="#message#">
    <table border="0">
		<cfoutput query="get_caution">
            <tr>
                <td width="100" class="txtbold" nowrap><cf_get_lang dictionary_id='57480.Başlık'></td>
                <td>#caution_head#</td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang dictionary_id='31742.İhtar Eden'></td>
                <td>#get_emp_info(warner,0,1)#</td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang dictionary_id='31743.İhtar Alan'></td>
                <td> #employee_name# #employee_surname# </td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang dictionary_id='57742.Tarih'></td>
                <td>#dateformat(caution_date,dateformat_style)#</td>
            </tr>
            <tr>
                <td class="txtbold" valign="top"><cf_get_lang dictionary_id ='31744.Kurul'></td>
                <td>
                    <cfif isdefined("IS_DISCIPLINE_CENTER")><cf_get_lang dictionary_id ='31854.Merkez Displin Kurulu'><br/></cfif>
                    <cfif isdefined("IS_DISCIPLINE_BRANCH")><cf_get_lang dictionary_id ='31855.Şube Disiplin Kurulu'></cfif>
                </td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang dictionary_id ='30937.Gerekçe'></td>
                <td>#caution_detail#</td>
            </tr>
                <tr>	
                    <td class="txtbold" width="100" valign="top"><cf_get_lang dictionary_id ='30906.savunma'> </td>
                    <td><textarea style="width:150;height:50px;" name="apology" id="apology">#GET_CAUTION.APOLOGY#</textarea></td>			
                </tr>
                <input type="hidden" name="apolog" id="apolog" value="#CAUTION_ID#">
        </cfoutput>
    </table>
    <cf_popup_box_footer><cf_workcube_buttons is_upd='0'></cf_popup_box_footer>
</cf_popup_box>
</cfform>
