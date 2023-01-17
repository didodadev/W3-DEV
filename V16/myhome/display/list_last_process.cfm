<cfinclude template="../query/query_last_process.cfm">
<cfset q_last_process=GET_LAST_PROCESSES()>
<table class="detail_basket_list">
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='57742.Tarih'></th>
            <th><cf_get_lang dictionary_id='57692.İşlem'></th>
            <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="q_last_process">
        <tr>
            <td>#LOG_DATE#</td>
            <td>#HEAD#</td>
            <td>#ACTION_NAME#</td>
        </tr>
        </cfoutput>
    </tbody>
</table>