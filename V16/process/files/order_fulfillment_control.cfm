<!---
    Author: Workcube - Melek KOCABEY <melekkocabey@workcube.com>
    Date: 03.03.2021
    Description:
	Satınalma ve satış siparişinde işlenmiş siparişlerin güncellenmemesini kontrol eder. (main display file)
--->
<cfset dsn = application.systemParam.systemParam().dsn>
<cfset dsn3 = '#dsn#_#session.ep.company_id#'>
<script type="text/javascript">

    process_cat_dsp_function = function() {
        order_id = $("#order_id").val();
        
        var sql = "SELECT TOP 1 1 AS C  FROM ORDERS_SHIP OS,ORDERS_INVOICE OI WHERE OS.ORDER_ID = "+order_id+"OR OI.ORDER_ID = "+order_id;
        cnt_order_ship_inv = wrk_query(sql,'dsn3');

        var query = "SELECT IS_ORDER_UPDATE,IS_PURCHASE_ORDER_UPDATE FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfoutput>#session.ep.company_id#</cfoutput>";
        get_our_comp_inf = wrk_query(query,'dsn'); 

        <cfif caller.attributes.fuseaction eq 'sales.list_order'>
            var get_our_comp_inf_ = get_our_comp_inf.IS_ORDER_UPDATE;
        <cfelseif caller.attributes.fuseaction eq 'purchase.list_order'>
            var get_our_comp_inf_ = get_our_comp_inf.IS_PURCHASE_ORDER_UPDATE;
        </cfif>

        if ( cnt_order_ship_inv.recordcount != 0 &&  get_our_comp_inf_ == 0) {
            wrk_opener_reload();
        }     
        return true;
    }

</script>