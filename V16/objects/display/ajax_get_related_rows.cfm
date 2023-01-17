<cfquery name="get_rows" datasource="#DSN3#">
    SELECT DISTINCT
        TO_TABLE AS ILISKILI_TABLO,
        TO_ACTION_ID ILISKILI_KAYIT,
        FROM_TABLE ILISKI_TABLOSU,
        FROM_ACTION_ID ILISKI_KAYDI
    FROM 
        RELATION_ROW
    WHERE
        FROM_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(attributes.action_type)#"> AND
        FROM_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
        (TO_TABLE = 'OFFER' OR TO_TABLE = 'ORDERS' OR TO_TABLE = 'OPPORTUNITIES')
    
    UNION
    
    SELECT DISTINCT
        FROM_TABLE AS ILISKILI_TABLO,
        FROM_ACTION_ID ILISKILI_KAYIT,
        TO_TABLE ILISKI_TABLOSU,
        TO_ACTION_ID ILISKI_KAYDI
    FROM 
        RELATION_ROW
    WHERE
        TO_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(attributes.action_type)#"> AND
        TO_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
        (FROM_TABLE = 'OFFER' OR FROM_TABLE = 'ORDERS' OR FROM_TABLE = 'OPPORTUNITIES')
</cfquery>
<cf_ajax_list>
<thead>
    <tr>
        <cfoutput>
            <th><cf_get_lang dictionary_id='57692.İşlem'></th>
            <th><cf_get_lang dictionary_id='58772.İşlem No'></th>
            <th><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>	            
            <th <cfif attributes.is_compare eq 1 and attributes.action_type is 'OFFER'> colspan="2"</cfif>><cf_get_lang dictionary_id='58820.Başlık'></th> <!--- Baslik --->
       </cfoutput>
    </tr>
</thead>
<tbody>
    <cfoutput query="get_rows">
        <cfquery name="GET_ACTION" datasource="#DSN3#">
            <cfif ILISKILI_TABLO is 'ORDERS'>
                SELECT ORDER_NUMBER AS ISLEM_NO,ORDER_HEAD AS ISLEM_BASLIK,PURCHASE_SALES,ORDER_STATUS STATUS FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#iliskili_kayit#">
            <cfelseif ILISKILI_TABLO is 'OFFER'>
                SELECT OFFER_NUMBER AS ISLEM_NO,OFFER_HEAD AS ISLEM_BASLIK,PURCHASE_SALES,OFFER_STATUS STATUS FROM OFFER WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#iliskili_kayit#">
            <cfelseif ILISKILI_TABLO is 'OPPORTUNITIES'>
                SELECT OPP_NO AS ISLEM_NO,OPP_HEAD AS ISLEM_BASLIK,'2' PURCHASE_SALES,OPP_STATUS STATUS FROM OPPORTUNITIES WHERE OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#iliskili_kayit#">
            </cfif>
        </cfquery>
        <tr height="20">
            <td width="50">
                <cfif iliskili_tablo is 'ORDERS'>
                    <cf_get_lang dictionary_id='57611.Sipariş'>
                <cfelseif iliskili_tablo is 'OFFER'>
                    <cf_get_lang dictionary_id='57545.Teklif'>
                <cfelseif iliskili_tablo is 'OPPORTUNITIES'>
                    <cf_get_lang dictionary_id='57612.Fırsat'>
                </cfif>
            </td>
            <td width="50">#get_action.islem_no#</td>
            <td><cfif get_action.purchase_sales eq 0><cf_get_lang dictionary_id='58176.Alış'><cf_get_lang dictionary_id='57448.Satış'></cfif></td>
            <td>
                <cfif get_action.purchase_sales eq 0 and iliskili_tablo is 'ORDERS'>
                    <cfif get_action.status eq 0>
                        <a href="#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#iliskili_kayit#"  style="color:999999;">#get_action.islem_baslik#</a>
                    <cfelse> 
                        <a href="#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#iliskili_kayit#"  class="tableyazi">#get_action.islem_baslik#</a>
                    </cfif>
                <cfelseif get_action.purchase_sales eq 1 and iliskili_tablo is 'ORDERS'>
                    <cfif get_action.status eq 0>
                        <a href="#request.self#?fuseaction=sales.list_order&event=upd&order_id=#iliskili_kayit#"  style="color:999999;">#get_action.islem_baslik#</a>
                    <cfelse> 
                        <a href="#request.self#?fuseaction=sales.list_order&event=upd&order_id=#iliskili_kayit#"  class="tableyazi">#get_action.islem_baslik#</a>
                    </cfif>
                <cfelseif get_action.purchase_sales eq 0 and iliskili_tablo is 'OFFER'>
                    <cfif get_action.status eq 0>
                        <a href="#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#iliskili_kayit#"  style="color:999999;">#get_action.islem_baslik#</a>
                    <cfelse> 
                        <a href="#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#iliskili_kayit#"  class="tableyazi">#get_action.islem_baslik#</a>
                    </cfif>
                <cfelseif get_action.purchase_sales eq 1 and iliskili_tablo is 'OFFER'>
                    <cfif get_action.status eq 0>
                        <a href="#request.self#?fuseaction=sales.list_offer&event=upd&offer_id=#iliskili_kayit#"  style="color:999999;">#get_action.islem_baslik#</a>
                    <cfelse> 
                        <a href="#request.self#?fuseaction=sales.list_offer&event=upd&offer_id=#iliskili_kayit#"  class="tableyazi">#get_action.islem_baslik#</a>
                    </cfif>
                <cfelseif get_action.purchase_sales eq 2 and iliskili_tablo is 'OPPORTUNITIES'>
                    <cfif get_action.status eq 0>
                        <a href="#request.self#?fuseaction=sales.list_opportunity&event=det&opp_id=#iliskili_kayit#&opp_no=#get_action.islem_no#"  style="color:999999;">#get_action.islem_baslik#</a>
                    <cfelse> 
                        <a href="#request.self#?fuseaction=sales.list_opportunity&event=det&opp_id=#iliskili_kayit#&opp_no=#get_action.islem_no#"  class="tableyazi">#get_action.islem_baslik#</a>
                    </cfif>
                </cfif>
            </td>
            <cfif attributes.is_compare eq 1 and attributes.action_type is 'OFFER'>
                <td width="10%" align="center">
                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_company_offers&rel_offer_id=#iliskili_kayit#&offer_id=#attributes.action_id#','medium');"><i class='icn-md icon-exchange' title="<cf_get_lang dictionary_id='32516.Karşılaştır'>"></i></a>
                </td>
            </cfif>
            <cfif not get_rows.recordcount>
                <cfoutput>
                    <tr>
                        <td align="left" colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td> <!--- Kayit Yok --->
                    </tr>
                </cfoutput>
           </cfif> 
        </tr>
    </cfoutput>
</tbody>
</cf_ajax_list>
