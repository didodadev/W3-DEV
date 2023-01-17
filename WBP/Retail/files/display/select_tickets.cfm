<cfquery name="get_lists" datasource="#dsn_dev#" result="query_result">
    SELECT 
    	DISTINCT
        	BPL.PRINT_NO,
            BPL.RECORD_DATE
    FROM 
        BARCODE_PRINT_LIST BPL
    WHERE
    	PRINT_NO IS NOT NULL AND 
        PRINT_NO <> ''
    <cfif not session.ep.admin>
        AND BPL.DEPARTMENT = #listgetat(session.ep.USER_LOCATION,1,'-')#
    </cfif>
    ORDER BY
        BPL.RECORD_DATE DESC
</cfquery>


<script>
function gonder(code)
{
	window.opener.document.getElementById('barcode_list_id').value = code;
	window.close();
}
</script>

<cf_medium_list_search title="Etiket Listeleri"></cf_medium_list_search>
<cf_medium_list id="manage_table">
	<thead>
        <tr>
        	<th>Liste</th>
            <th>Kayıt</th>
        </tr>
    </thead>
    <tbody>
		<cfoutput query="get_lists">
        <tr>
        	<td><a href="javascript://" onclick="gonder('#PRINT_NO#');" class="tableyazi">#PRINT_NO#</a></td>
            <td>#dateformat(RECORD_DATE,'dd/mm/yyyy')#</td>
        </tr>
        </cfoutput>
	</tbody>
</cf_medium_list>