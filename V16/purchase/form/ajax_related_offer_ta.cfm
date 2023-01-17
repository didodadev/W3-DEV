<table class="ajax_list">
	<cfset relation_row_list = "">
    <cfquery name="get_offer_wrk_row" datasource="#dsn3#">
        SELECT WRK_ROW_ID FROM OFFER_ROW WHERE OFFER_ID = #attributes.offer_id# OR OFFER_ID IN (SELECT OFFER_ID FROM OFFER WHERE FOR_OFFER_ID = #attributes.offer_id#)
    </cfquery>
    <cfif get_offer_wrk_row.recordcount>
        <cfset relation_row_list = ValueList(get_offer_wrk_row.wrk_row_id,',')>
    </cfif>
    <cfif ListLen(relation_row_list)>
        <cfquery name="get_related_orders" datasource="#dsn3#">
            SELECT
                ORDER_ID,
                ORDER_NUMBER,
                OTHER_MONEY,
                OTHER_MONEY_VALUE
            FROM
                ORDERS
            WHERE
                ORDER_ID IN (SELECT DISTINCT ORDER_ID FROM ORDER_ROW WHERE WRK_ROW_RELATION_ID IN (#ListQualify(relation_row_list,"'")#))
            ORDER BY
                ORDER_ID
        </cfquery>
    </cfif>
    <cfif isdefined("get_related_orders") and get_related_orders.recordcount>
        <table class="ajax_list">
        <cfoutput query="get_related_orders">
            <tr>
                <td><a href="#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#order_id#" class="tableyazi" target="_blank">#order_number#</a> - #TLFormat(other_money_value)# #other_money#</td>
            </tr>
        </cfoutput>
        </table>
    <cfelse>
        <tr class="color-row" height="25">
            <td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </tr>
    </cfif>
</table>
