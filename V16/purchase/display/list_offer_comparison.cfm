<cfquery name="get_main_offer_details" datasource="#dsn3#">
    SELECT
        ORW.OFFER_ID,
        SUM(((((ORW.QUANTITY*ORW.PRICE)+ ORW.EXTRA_PRICE_TOTAL)/100000000000000000000)*((100-DISCOUNT_1)*(100- DISCOUNT_2)*(100-DISCOUNT_3)*(100-DISCOUNT_4)*(100-DISCOUNT_5)*(100-DISCOUNT_6)*(100-DISCOUNT_7)*(100-DISCOUNT_8)*(100-DISCOUNT_9)*(100-DISCOUNT_10))/ORW.QUANTITY) * ORW.QUANTITY) AS NET_PRICE,
        O.PRICE,
        O.OTHER_MONEY,
        O.OTHER_MONEY_VALUE
    FROM
        OFFER O,
        OFFER_ROW ORW
    WHERE
        O.OFFER_ID = ORW.OFFER_ID AND
        O.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
    GROUP BY
        ORW.OFFER_ID, O.PRICE, O.OTHER_MONEY, O.OTHER_MONEY_VALUE
</cfquery>
<cfquery name="get_coming_offer_for_main" datasource="#dsn3#">
    SELECT OFFER_ID,OFFER_NUMBER,OFFER_HEAD,OFFER_DETAIL,OFFER_TO,OFFER_TO_PARTNER,OTHER_MONEY,OTHER_MONEY_VALUE,REVISION_NUMBER FROM OFFER WHERE FOR_OFFER_ID = #attributes.offer_id# ORDER BY OFFER_TO_PARTNER, REVISION_OFFER_ID, REVISION_NUMBER
</cfquery>
<cfquery name="get_finally_coming_offers" dbtype="query">
    SELECT OFFER_TO FROM get_coming_offer_for_main GROUP BY OFFER_TO
</cfquery>
<cf_grid_list>
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='33905.Teklifler'></th>
            <th><cf_get_lang dictionary_id='58820.Başlık'></th>
            <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
        </tr>
        <tr>
            <td class="bold"><cfoutput>#get_offer_detail.OFFER_NUMBER#</cfoutput></td>
            <td class="bold"><cfoutput>#get_offer_detail.OFFER_HEAD#</cfoutput></td>
            <td class="bold"><cfoutput>#get_offer_detail.OFFER_DETAIL#</cfoutput></td>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="get_finally_coming_offers">
            <cfquery name="get_last_offer_head" dbtype="query" maxrows="1">
                SELECT * FROM get_coming_offer_for_main WHERE OFFER_TO = '#OFFER_TO#' ORDER BY REVISION_NUMBER DESC
            </cfquery>
            <tr>
                <td>
                    #get_par_info(listdeleteduplicates(get_last_offer_head.offer_to_partner),0,1,0,1)#/#get_last_offer_head.OFFER_NUMBER#
                    <cfif get_last_offer_head.REVISION_NUMBER neq ''>/R-#get_last_offer_head.REVISION_NUMBER#</cfif>
                </td>
                <td>#get_last_offer_head.OFFER_HEAD#</td>
                <td>#get_last_offer_head.OFFER_DETAIL#</td>
            </tr>
        </cfoutput>
    </tbody>
</cf_grid_list>
<cf_grid_list sort="true">
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id="33905.Teklifer"></th>
            <th class="text-right"><cf_get_lang dictionary_id="39067.Kdv siz Toplam"></th>
            <th><cf_get_lang dictionary_id="34434.Pr Birimi"></th>
            <th class="text-right"><cf_get_lang dictionary_id="34019.Kdv li Toplam"></th>
            <th><cf_get_lang dictionary_id="34434.Pr Birimi"></th>
            <th class="text-right"><cf_get_lang dictionary_id="58124.Döviz Toplam"></th>
            <th><cf_get_lang dictionary_id="34434.Pr Birimi"></th>
            <th class="text-center">%</th>
            <th class="text-center" title="<cf_get_lang dictionary_id="35353.Teknik Puan">"><cf_get_lang dictionary_id="64694.T.P"></th>
            <th class="text-center" title="<cf_get_lang dictionary_id="59580.Form Puanı">"><cf_get_lang dictionary_id="64693.F.P"></th>
            <th class="text-center" title="<cf_get_lang dictionary_id="58552.Müşteri Değeri">"><cf_get_lang dictionary_id="64692.M.D"></th>
        </tr>
        <tr>
            <td class="bold"><cf_get_lang dictionary_id="59607.Muhammen Bedel"></td>
            <td class="text-right bold"><cfoutput>#TLFormat(get_main_offer_details.NET_PRICE)#</cfoutput></td>
            <td class="bold">TL</td>
            <td class="text-right bold"><cfoutput>#TLFormat(get_main_offer_details.PRICE)#</cfoutput></td>
            <td class="bold">TL</td>
            <td class="text-right bold"><cfoutput>#TLFormat(get_main_offer_details.OTHER_MONEY_VALUE)#</cfoutput></td>
            <td class="bold"><cfoutput>#get_main_offer_details.OTHER_MONEY#</cfoutput></td>
            <td class="text-center bold">%</td>
            <td class="text-center bold">10</td>
            <td class="text-center bold">-</td>
            <td class="text-center bold">-</td>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="get_finally_coming_offers">
            <cfquery name="get_finally_coming_offers_details" dbtype="query" maxrows="1">
                SELECT * FROM get_coming_offer_for_main WHERE OFFER_TO = '#OFFER_TO#' ORDER BY REVISION_NUMBER DESC
            </cfquery>
            <cfquery name="get_coming_offer_details" datasource="#dsn3#">
                SELECT
                    ORW.OFFER_ID,
                    SUM(((((ORW.QUANTITY*ORW.PRICE)+ ORW.EXTRA_PRICE_TOTAL)/100000000000000000000)*((100-DISCOUNT_1)*(100- DISCOUNT_2)*(100-DISCOUNT_3)*(100-DISCOUNT_4)*(100-DISCOUNT_5)*(100-DISCOUNT_6)*(100-DISCOUNT_7)*(100-DISCOUNT_8)*(100-DISCOUNT_9)*(100-DISCOUNT_10))/ORW.QUANTITY) * ORW.QUANTITY) AS NET_PRICE,
                    O.PRICE,
                    O.OTHER_MONEY,
                    O.OTHER_MONEY_VALUE
                FROM
                    OFFER O,
                    OFFER_ROW ORW
                WHERE
                    O.OFFER_ID = ORW.OFFER_ID AND
                    O.FOR_OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#"> AND
                    O.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_finally_coming_offers_details.OFFER_ID#">
                GROUP BY
                    ORW.OFFER_ID, O.PRICE, O.OTHER_MONEY, O.OTHER_MONEY_VALUE
            </cfquery>
            <cfquery name="get_techical_point" datasource="#dsn3#">
                SELECT ISNULL(SUM(TECHNICAL_POINT),0) AS SUM_POINT, COUNT(TECHNICAL_POINT) AS COUNT_POINT FROM PURCHASE_TECHNICAL_POINT WHERE FOR_OFFER_ID = #attributes.offer_id# AND OFFER_ID = #get_finally_coming_offers_details.OFFER_ID# AND COMPANY_ID = #listdeleteduplicates(get_finally_coming_offers_details.offer_to)#
            </cfquery>
            <tr>
                <td>#get_par_info(listdeleteduplicates(get_finally_coming_offers_details.offer_to_partner),0,1,0,1)#/#get_finally_coming_offers_details.OFFER_NUMBER#<cfif get_finally_coming_offers_details.REVISION_NUMBER neq ''>/R-#get_finally_coming_offers_details.REVISION_NUMBER#</cfif></td>
                <td class="text-right">#TLFormat(get_coming_offer_details.NET_PRICE)#</td>
                <td>TL</td>
                <td class="text-right">#TLFormat(get_coming_offer_details.PRICE)#</td>
                <td>TL</td>
                <td class="text-right">#TLFormat(get_coming_offer_details.OTHER_MONEY_VALUE)#</td>
                <td>#get_coming_offer_details.OTHER_MONEY#</td>
                <cfif get_main_offer_details.NET_PRICE neq 0>
                    <cfset diff_rate = wrk_round(((get_coming_offer_details.NET_PRICE*100)/get_main_offer_details.NET_PRICE)-100,2)>
                <cfelse>
                    <cfset diff_rate = 0>
                </cfif>
                <td class="text-center" <cfif diff_rate lt 0>style="color:##0BAB03;"<cfelseif diff_rate gt 0>style="color:red;"</cfif>><cfif diff_rate gt 0>+</cfif>#diff_rate#%</td>
                <td class="text-center"><cfif get_techical_point.SUM_POINT neq 0 and get_techical_point.COUNT_POINT neq 0>#wrk_round(get_techical_point.SUM_POINT/get_techical_point.COUNT_POINT)#<cfelse>-</cfif></td>
                <td class="text-center">--</td>
                <td class="text-center">
                    <cfquery name="GET_CUSTOMER_VALUE" datasource="#DSN#">
                        SELECT SCV.CUSTOMER_VALUE FROM COMPANY C LEFT JOIN SETUP_CUSTOMER_VALUE SCV WITH (NOLOCK) ON C.COMPANY_VALUE_ID = SCV.CUSTOMER_VALUE_ID WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listdeleteduplicates(get_finally_coming_offers_details.offer_to)#">
                    </cfquery>
                    <cfif len(GET_CUSTOMER_VALUE.CUSTOMER_VALUE)>
                        #GET_CUSTOMER_VALUE.CUSTOMER_VALUE#
                    <cfelse>
                        -
                    </cfif>
                </td>
            </tr>
        </cfoutput>
    </tbody>
</cf_grid_list>