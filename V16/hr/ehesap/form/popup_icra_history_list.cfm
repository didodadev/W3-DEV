    <cfset attributes.COMMANDMENT_ID= attributes.id>
    <cfquery name="get_history" datasource="#dsn#">
            SELECT * FROM COMMANDMENT_HISTORY where COMMANDMENT_ID = #attributes.COMMANDMENT_ID#
    </cfquery>
    <cf_box title="#getLang('','Tarihçe',57473)#" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cf_flat_list>
                <thead>
                    <tr>
                        <th width="15"><cf_get_lang dictionary_id="58577.Sıra"></th>
                        <th><cf_get_lang dictionary_id="57627.Kayıt Tarihi"></th>
                        <th><cf_get_lang dictionary_id="31746.İcra Tarihi"></th>
                        <th><cf_get_lang dictionary_id="59556.İcra Tutarı"></th>
                        <th><cf_get_lang dictionary_id="59559.İcra Detayı"></th>
                        <th><cf_get_lang dictionary_id="54332.IBAN_NO"></th>
                        <th><cf_get_lang dictionary_id="59668.İcra Güncelleme"></th>
                        <th><cf_get_lang dictionary_id="59669.İcra Ofisi"></th>
                    </tr>
                </thead>  
            <tbody>          
                <cfif get_history.recordcount> 
                <cfoutput query="get_history"> 

                <input type="hidden" name="COMMANDMENT_ID" id="COMMANDMENT_ID" value="#COMMANDMENT_ID#">
                <tr>
                    <td width="15">#currentrow#</td>
                    <td>#dateformat(record_date,'dd/mm/yyyy')# #timeformat(record_date,'HH:MM')#</td>
                    <td>#dateformat(COMMANDMENT_DATE,'dd/mm/yyyy')#</td>
                    <td>#COMMANDMENT_VALUE#</td>
                    <td>#COMMANDMENT_DETAIL#</td>
                    <td>#IBAN_NO#</td>
                    <td><cfif len(UPDATE_DATE)>#dateformat(UPDATE_DATE,'dd/mm/yyyy')#</cfif></td>
                    <td>#COMMANDMENT_OFFICE#</td>
                </tr>
                </cfoutput>   
                </cfif>
            </tbody>
        </cf_flat_list> 
    </cf_box>  