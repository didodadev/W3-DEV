<!--- Seri No' ya Göre Stok Durumu --->
<cfsavecontent  variable="variable"><cf_get_lang dictionary_id="61191">
</cfsavecontent>
<cf_seperator title="#variable#" id="lot_no_id">
    <cf_flat_list id="lot_no_id">
        <cfquery name="GET_STOCKS_ALL" datasource="#DSN2#">
            DECLARE @stock_out_amount2 int;
            DECLARE @stock_in_amount2 int;
            SELECT
                LOT_NO,
                SUM(STOCK_OUT) AS STOCK_OUT,
                SUM(STOCK_IN) AS STOCK_IN,
                SUM(STOCK_IN - STOCK_OUT) AS STOK_DURUMU,
                ( SELECT SUM(AMOUNT2) AS STOCK_AMOUNT2_IN FROM STOCKS_ROW AS SR WHERE STOCK_OUT = 0 AND SR.LOT_NO = STOCKS_ROW.LOT_NO ) AS LAST_IN_AMOUNT2,
                ( SELECT SUM(AMOUNT2) AS STOCK_AMOUNT2_OUT FROM STOCKS_ROW AS SR WHERE STOCK_IN = 0 AND SR.LOT_NO = STOCKS_ROW.LOT_NO ) AS LAST_OUT_AMOUNT2
            FROM 
                STOCKS_ROW
            WHERE 
                STOCK_ID = #attributes.sid#
                AND LOT_NO IS NOT NULL
            GROUP BY
                LOT_NO
            ORDER BY
                LOT_NO ASC
        </cfquery>
        <cfquery name="get_unit_all" datasource="#dsn3#">
            SELECT ADD_UNIT, MULTIPLIER from STOCKS LEFT JOIN PRODUCT_UNIT ON STOCKS.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID WHERE STOCK_ID = #attributes.sid#
        </cfquery>
        <cfif  get_stocks_all.recordcount>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='32916.Lot No'></th>
                    <th><cf_get_lang dictionary_id='40531.Giren Miktar'></th>
                    <th><cf_get_lang dictionary_id='57636.Birim'></th>
                    <th>2. <cf_get_lang dictionary_id='40531.Giren Miktar'></th>
                    <th><cf_get_lang dictionary_id='57636.Birim'></th>
                    <th><cf_get_lang dictionary_id='40535.Çıkan Miktar'></th>
                    <th><cf_get_lang dictionary_id='57636.Birim'></th>
                    <th>2. <cf_get_lang dictionary_id='40535.Çıkan Miktar'></th>
                    <th><cf_get_lang dictionary_id='57636.Birim'></th>
                    <th><cf_get_lang dictionary_id='40270.Kalan Miktar'></th>
                    <th>2. <cf_get_lang dictionary_id='57635.Miktar'></th>
                </tr>
            </thead>
            <tbody>
            <cfoutput query="get_stocks_all">
                <tr>
                    <td>#LOT_NO#</td>
                    <td style="text-align:center">#TLFormat(STOCK_IN)#</td>
                    <td style="text-align:center">#get_unit_all.ADD_UNIT#</td>
                    <td style="text-align:center">#TLFormat(LAST_IN_AMOUNT2)#</td>
                    <td style="text-align:center">#get_unit_all.recordcount GT 1 ? get_unit_all.ADD_UNIT[2] : get_unit_all.ADD_UNIT#</td>
                    <td style="text-align:center">#TLFormat(STOCK_OUT)#</td>
                    <td style="text-align:center">#get_unit_all.ADD_UNIT#</td>
                    <td style="text-align:center"># len( LAST_OUT_AMOUNT2 ) ? TLFormat(LAST_OUT_AMOUNT2) : TLFormat(0)#</td>
                    <td style="text-align:center">#( get_unit_all.recordcount GT 1 ? get_unit_all.ADD_UNIT[2] : get_unit_all.ADD_UNIT )#</td>
                    <td style="text-align:center">#TLFormat(STOK_DURUMU)# #get_unit_all.ADD_UNIT#</td>
                    <td style="text-align:center">#TLFormat(STOK_DURUMU/wrk_round( get_unit_all.recordcount GT 1  ? get_unit_all.MULTIPLIER[2] : get_unit_all.MULTIPLIER ,8,1))# # ( get_unit_all.recordcount GT 1 ) ? get_unit_all.ADD_UNIT[2] : get_unit_all.ADD_UNIT #</td>
                  </tr>
            </cfoutput>
            </tbody>
        <cfelse>
            <tr>
                <td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </cf_flat_list>

