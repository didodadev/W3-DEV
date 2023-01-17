<cfquery name="get_excel" datasource="#dsn_dev#">
	SELECT
    	GPAR.ADD_POINT,
        GPAR.DEL_POINT,
        GPAR.CARD_NO
    FROM
    	GENIUS_POINT_ADDS_ROWS GPAR
    WHERE
    	GPAR.ROW_ID = #attributes.row_id#
</cfquery>

<cfif get_excel.recordcount>
	<cfquery name="get_card_members" datasource="#dsn#">
        SELECT
            C.CONSUMER_NAME,
            C.CONSUMER_SURNAME,
            CC.CARD_NO
        FROM
            CUSTOMER_CARDS CC,
            CONSUMER C
        WHERE
            CC.ACTION_TYPE_ID = 'CONSUMER_ID' AND
            CC.ACTION_ID = C.CONSUMER_ID AND
            CC.CARD_NO IN ('#REPLACE(valuelist(get_excel.CARD_NO),",","','","all")#')
    </cfquery>
</cfif>

<cf_medium_list_search title="Toplu İşlem Satırları"></cf_medium_list_search>
<table class="medium_list">
<thead>
    <tr>
        <th>Kart No</th>
        <th width="200">Müşteri Adı</th>
        <th width="75">(+)</th>
        <th width="75">(-)</th>
    </tr>
</thead>
<cfoutput query="get_excel">
    <cfquery name="get_member" dbtype="query">
        SELECT * FROM get_card_members WHERE CARD_NO = '#CARD_NO#'
    </cfquery>
    <tr>
        <td>#CARD_NO#</td>
        <td>#get_member.CONSUMER_NAME# #get_member.CONSUMER_SURNAME#</td>
        <td>#tlformat(ADD_POINT)#</td>
        <td>#tlformat(DEL_POINT)#</td>
    </tr>
</cfoutput>
</table>