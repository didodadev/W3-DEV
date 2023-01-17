<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfif attributes.type eq 0>
    <cfquery name="get_product" datasource="#dsn3#" maxrows="100">
    SELECT
        ISNULL(( 
                SELECT TOP 1 
                    PT1.NEW_PRICE_KDV
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    (
                    PT1.IS_ACTIVE_S = 1 AND
                    PT1.STARTDATE <= #bugun_# AND DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_#
                    ) AND
                    PT1.PRODUCT_ID = PRODUCT.PRODUCT_ID
                ORDER BY
                	PT1.STARTDATE DESC,
					PT1.ROW_ID DESC
            ),PS.PRICE_KDV) AS SATIS_KDV,
        PRODUCT.PRODUCT_ID,
        PRODUCT.PRODUCT_NAME,
        PRODUCT.PRODUCT_CODE,
        PRODUCT.PRODUCT_CODE_2,
        PRODUCT_UNIT.PRODUCT_UNIT_ID,
        PRODUCT_UNIT.MAIN_UNIT,
        PRODUCT_CAT.PROFIT_MARGIN,
        PRODUCT_CAT.PRODUCT_CATID
    FROM
        PRODUCT_CAT,
        PRODUCT_UNIT,
        PRODUCT,
        PRICE_STANDART PS
    WHERE
        PS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
		PS.PURCHASESALES = 1 AND
		PS.PRICESTANDART_STATUS = 1 AND
        PRODUCT.PRODUCT_STATUS = 1 AND
        PRODUCT.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID AND
        PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
        PRODUCT_UNIT.IS_MAIN = 1 AND
        (
        PRODUCT.PRODUCT_NAME IS NOT NULL
        <cfloop from="1" to="#listlen(attributes.keyword,' ')#" index="ccc">
            <cfset kelime_ = listgetat(attributes.keyword,ccc,' ')>
                AND
                (
                PRODUCT.PRODUCT_NAME LIKE '%#kelime_#%' OR
                PRODUCT.PRODUCT_CODE_2 = '#kelime_#' OR
                PRODUCT.PRODUCT_ID IN (SELECT S.PRODUCT_ID FROM STOCKS_BARCODES SB2,STOCKS S WHERE SB2.STOCK_ID = S.STOCK_ID AND SB2.BARCODE = '#kelime_#')
                )
        </cfloop>
        )
    ORDER BY
        PRODUCT.PRODUCT_NAME
    </cfquery>
    
    <cf_grid_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id="58221.Ürün Adı"></th>
                <th width="50"><cf_get_lang dictionary_id="58585.Kod"></th>
                <th width="50"><cf_get_lang dictionary_id="57789.Özel Kod"></th>
                <th width="50"><cf_get_lang dictionary_id="58084.Fiyat"></th>
                <th width="50"><cf_get_lang dictionary_id="57452.Stok"></th>
                <cfif get_product.recordcount gt 1>
                <th>
                    <input type="checkbox" name="all_product_id" id="all_product_id" value="1" onclick="check_all_row('<cfoutput>#get_product.recordcount#</cfoutput>');"/>
                    <a href="javascript://" onclick="send_to_add_row();"><img src="/images/plus_small.gif" /></a>
                </th>
               </cfif>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="get_product">
            <cfset product_name_ = replace(product_name,'"','','all')>
            <cfset product_name_ = replace(product_name_,"'","","all")>
            <tr id="product_row_#product_id#">
                <td><a href="javascript://" onclick="hide('product_row_#product_id#');window.opener.add_row('#product_id#','#product_name_#','#TLFORMAT(SATIS_KDV)#');" class="tableyazi">#product_name#</a></td>
                <td>#product_code#</td>
                <td>#product_code_2#</td>
                <td style="text-align:right;">#TLFORMAT(SATIS_KDV)#</td>
                <td>&nbsp;</td>
                <cfif get_product.recordcount gt 1>
                    <td>
                    <input type="hidden" name="product_name_#currentrow#" id="product_name_#currentrow#" value="#product_name_#"/>
                    <input type="hidden" name="sales_#currentrow#" id="sales_#currentrow#" value="#TLFORMAT(SATIS_KDV)#"/>
                    <input type="checkbox" name="product_id_#currentrow#" id="product_id_#currentrow#" value="#product_id#"/></td>
                </cfif>
            </tr>
            </cfoutput>
        </tbody>
    </cf_grid_list>
    <script>
    function send_to_add_row()
    {
        for (var m=1; m <= <cfoutput>#get_product.recordcount#</cfoutput>; m++)
        {
            if(document.getElementById('product_id_' + m).checked == true)
            {
                pid_ = document.getElementById('product_id_' + m).value;
                pname_ = document.getElementById('product_name_' + m).value;
                psales_ = document.getElementById('sales_' + m).value;
                document.getElementById('product_id_' + m).checked = false;
                hide('product_row_' + pid_);
                window.opener.add_row(pid_,pname_,psales_);
            }
        }
    }
    
    function check_all_row(eleman_sayisi)
    {
        if(document.getElementById('all_product_id').checked == true)
        {
            for (var m=1; m <= eleman_sayisi; m++)
            {
                document.getElementById('product_id_' + m).checked = true;
            }
        }
        else
        {
            for (var m=1; m <= eleman_sayisi; m++)
            {
                document.getElementById('product_id_' + m).checked = false;
            }
        }
    }
    </script>
<cfelseif attributes.type eq 11>
	<cfquery name="get_product" datasource="#dsn3#" maxrows="100">
    SELECT
        (SELECT TOP 1 ROUND(PS_OZEL.PRICE_KDV,2) FROM PRICE_STANDART PS_OZEL WHERE PS_OZEL.PURCHASESALES = 1 AND PS_OZEL.PRODUCT_ID = PRODUCT.PRODUCT_ID AND PS_OZEL.PRICESTANDART_STATUS = 1) AS SATIS_KDV,
        PRODUCT.STOCK_ID,
        PRODUCT.PRODUCT_ID,
        PRODUCT.PROPERTY AS PRODUCT_NAME,
        PRODUCT.PRODUCT_CODE,
        PRODUCT.STOCK_CODE_2,
        PRODUCT.PRODUCT_NAME AS PPRODUCT_NAME,
        PRODUCT_UNIT.PRODUCT_UNIT_ID,
        PRODUCT_UNIT.MAIN_UNIT,
        PRODUCT_CAT.PROFIT_MARGIN,
        PRODUCT_CAT.PRODUCT_CATID,
        SB.BARCODE,
		(SELECT TOP 1 GSL.PRODUCT_STOCK FROM #dsn2_alias#.GET_STOCK_LAST GSL WHERE GSL.STOCK_ID = PRODUCT.STOCK_ID) AS GERCEK_STOK
    FROM
        PRODUCT_CAT,
        PRODUCT_UNIT,
        STOCKS AS PRODUCT,
        STOCKS_BARCODES SB
    WHERE
        PRODUCT.STOCK_ID = SB.STOCK_ID AND
        PRODUCT.PRODUCT_STATUS = 1 AND
        PRODUCT.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID AND
        PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
        PRODUCT_UNIT.IS_MAIN = 1 AND
        (
        PRODUCT.PRODUCT_NAME IS NOT NULL
        <cfloop from="1" to="#listlen(attributes.keyword,' ')#" index="ccc">
            <cfset kelime_ = listgetat(attributes.keyword,ccc,' ')>
                AND
                (
                PRODUCT.PROPERTY LIKE '%#kelime_#%' OR
                PRODUCT.PRODUCT_NAME LIKE '%#kelime_#%' OR
                PRODUCT.PRODUCT_CODE_2 = '#kelime_#' OR
                PRODUCT.PRODUCT_ID IN (SELECT S.PRODUCT_ID FROM STOCKS_BARCODES SB2,STOCKS S WHERE SB2.STOCK_ID = S.STOCK_ID AND SB2.BARCODE = '#kelime_#')
                )
        </cfloop>
        )
    ORDER BY
        PRODUCT.PRODUCT_NAME
    </cfquery>
    <cf_grid_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id="58221.Ürün Adı"></th>
                <th width="50"><cf_get_lang dictionary_id="58585.Kod"></th>
                <th width="50"><cf_get_lang dictionary_id="57789.Özel Kod"></th>
                <th width="50"><cf_get_lang dictionary_id="58084.Fiyat"></th>
                <th width="50"><cf_get_lang dictionary_id="57633.Barkod"></th>
                <cfif get_product.recordcount gt 1>
                <th>
                    <input type="checkbox" name="all_product_id" id="all_product_id" value="1" onclick="check_all_row('<cfoutput>#get_product.recordcount#</cfoutput>');"/>
                    <a href="javascript://" onclick="send_to_add_row();"><img src="/images/plus_small.gif" /></a>
                </th>
               </cfif>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="get_product">
            <cfset product_name_ = PPRODUCT_NAME&' '&replace(product_name,'"','','all')>
            <cfset product_name_ = PPRODUCT_NAME&' '&replace(product_name_,"'","","all")>
            <tr id="product_row_#BARCODE#">
                <td><a href="javascript://" onclick="hide('product_row_#BARCODE#');window.opener.#attributes.op_f_name#('#BARCODE#');" class="tableyazi">#PPRODUCT_NAME# #product_name#</a></td>
                <td>#product_code#</td>
                <td>#stock_code_2#</td>
                <td style="text-align:right;">#TLFORMAT(SATIS_KDV)#</td>
                <td style="text-align:right;">#BARCODE#</td>
                <cfif get_product.recordcount gt 1>
                    <td>
                    <input type="checkbox" name="barcode_#currentrow#" id="barcode_#currentrow#" value="#BARCODE#"/></td>
                </cfif>
            </tr>
            </cfoutput>
        </tbody>
    </cf_grid_list>
    <script>
    function send_to_add_row()
    {
        for (var m=1; m <= <cfoutput>#get_product.recordcount#</cfoutput>; m++)
        {
            if(document.getElementById('barcode_' + m).checked == true)
            {
                barcode_ = document.getElementById('barcode_' + m).value;
                document.getElementById('barcode_' + m).checked = false;
				hide('product_row_' + barcode_);
                window.opener.<cfoutput>#attributes.op_f_name#</cfoutput>(barcode_);
            }
        }
    }
    
    function check_all_row(eleman_sayisi)
    {
        if(document.getElementById('all_product_id').checked == true)
        {
            for (var m=1; m <= eleman_sayisi; m++)
            {
                document.getElementById('stock_id_' + m).checked = true;
            }
        }
        else
        {
            for (var m=1; m <= eleman_sayisi; m++)
            {
                document.getElementById('stock_id_' + m).checked = false;
            }
        }
    }
    </script>
<cfelseif attributes.type eq 10>
	<cfquery name="get_product" datasource="#dsn3#" maxrows="100">
    SELECT
        (SELECT TOP 1 ROUND(PS_OZEL.PRICE_KDV,2) FROM PRICE_STANDART PS_OZEL WHERE PS_OZEL.PURCHASESALES = 1 AND PS_OZEL.PRODUCT_ID = PRODUCT.PRODUCT_ID AND PS_OZEL.PRICESTANDART_STATUS = 1) AS SATIS_KDV,
        STOCKS.STOCK_ID,
        PRODUCT.PRODUCT_ID,
        STOCKS.PROPERTY AS PRODUCT_NAME,
        PRODUCT.PRODUCT_CODE,
        PRODUCT.PRODUCT_NAME AS PPRODUCT_NAME,
        STOCKS.STOCK_CODE_2,
        PRODUCT_UNIT.PRODUCT_UNIT_ID,
        PRODUCT_UNIT.MAIN_UNIT,
        PRODUCT_CAT.PROFIT_MARGIN,
        PRODUCT_CAT.PRODUCT_CATID,
		(SELECT TOP 1 GSL.PRODUCT_STOCK FROM #dsn2_alias#.GET_STOCK_LAST GSL WHERE GSL.STOCK_ID = STOCKS.STOCK_ID) AS GERCEK_STOK
    FROM
        PRODUCT_CAT,
        PRODUCT_UNIT,
        #dsn3_alias#.PRODUCT PRODUCT,
        #dsn3_alias#.STOCKS STOCKS
    WHERE
        --PRODUCT.PRODUCT_STATUS = 1 AND
        PRODUCT.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID AND
        PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
        STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
        PRODUCT_UNIT.IS_MAIN = 1 AND
        (
        PRODUCT.PRODUCT_NAME IS NOT NULL
        <cfloop from="1" to="#listlen(attributes.keyword,' ')#" index="ccc">
            <cfset kelime_ = listgetat(attributes.keyword,ccc,' ')>
                AND
                (
                STOCKS.PROPERTY LIKE '%#kelime_#%' OR
                PRODUCT.PRODUCT_NAME LIKE '%#kelime_#%' OR
                PRODUCT.PRODUCT_CODE_2 = '#kelime_#' OR
                PRODUCT.PRODUCT_ID IN (SELECT S.PRODUCT_ID FROM STOCKS_BARCODES SB2,STOCKS S WHERE SB2.STOCK_ID = S.STOCK_ID AND SB2.BARCODE = '#kelime_#')
                )
        </cfloop>
        )
    ORDER BY
        PRODUCT.PRODUCT_NAME
    </cfquery>
    <cf_grid_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id="58221.Ürün Adı"></th>
                <th width="50"><cf_get_lang dictionary_id="58585.Kod"></th>
                <th width="50"><cf_get_lang dictionary_id="57789.Özel Kod"></th>
                <th width="50"><cf_get_lang dictionary_id="58084.Fiyat"></th>
                <th width="50"><cf_get_lang dictionary_id="57452.Stok"></th>
                <cfif get_product.recordcount gt 1>
                <th>
                    <input type="checkbox" name="all_product_id" id="all_product_id" value="1" onclick="check_all_row('<cfoutput>#get_product.recordcount#</cfoutput>');"/>
                </th>
               </cfif>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="get_product">
            <cfset product_name_ = PPRODUCT_NAME&' '&replace(product_name,'"','','all')>
            <cfset product_name_ = PPRODUCT_NAME&' '&replace(product_name_,"'","","all")>
            <tr id="product_row_#stock_id#">
                <td><a href="javascript://" onclick="hide('product_row_#stock_id#');<cfif not isdefined("attributes.draggable")>window.opener.</cfif>#attributes.op_f_name#('#stock_id#','#product_name_#','#wrk_round(GERCEK_STOK)#');" class="tableyazi">#PPRODUCT_NAME# #product_name#</a></td>
                <td>#product_code#</td>
                <td>#stock_code_2#</td>
                <td style="text-align:right;">#TLFORMAT(SATIS_KDV)#</td>
                <td style="text-align:right;">#tlformat(GERCEK_STOK)#</td>
                <cfif get_product.recordcount gt 1>
                    <td>
                    <input type="hidden" name="product_name_#currentrow#" id="product_name_#currentrow#" value="#product_name_#"/>
					<input type="hidden" name="g_stock_#currentrow#" id="g_stock_#currentrow#" value="#wrk_round(GERCEK_STOK)#"/>
                    <input type="checkbox" name="stock_id_#currentrow#" id="stock_id_#currentrow#" value="#stock_id#"/></td>
                </cfif>
            </tr>
            </cfoutput>
        </tbody>
    </cf_grid_list>
    <cf_box_footer>
        <input class=" ui-wrk-btn ui-wrk-btn-success" name="wrk_submit_button" type="button" value="Kaydet" href="javascript://" onclick="send_to_add_row();">
    </cf_box_footer>
    <script>
    function send_to_add_row()
    {
        for (var m=1; m <= <cfoutput>#get_product.recordcount#</cfoutput>; m++)
        {
            if(document.getElementById('stock_id_' + m).checked == true)
            {
                sid_ = document.getElementById('stock_id_' + m).value;
                pname_ = document.getElementById('product_name_' + m).value;
                g_ = document.getElementById('g_stock_' + m).value;
                document.getElementById('stock_id_' + m).checked = false;
				hide('product_row_' + sid_);
                <cfif not isdefined("attributes.draggable")>window.opener.</cfif><cfoutput>#attributes.op_f_name#</cfoutput>(sid_,pname_,g_);
            }
        }
    }
    
    function check_all_row(eleman_sayisi)
    {
        if(document.getElementById('all_product_id').checked == true)
        {
            for (var m=1; m <= eleman_sayisi; m++)
            {
                document.getElementById('stock_id_' + m).checked = true;
            }
        }
        else
        {
            for (var m=1; m <= eleman_sayisi; m++)
            {
                document.getElementById('stock_id_' + m).checked = false;
            }
        }
    }
    </script>
<cfelse>
	<cfquery name="get_product" datasource="#dsn3#" maxrows="100">
    SELECT
        (SELECT TOP 1 ROUND(PS_OZEL.PRICE_KDV,2) FROM PRICE_STANDART PS_OZEL WHERE PS_OZEL.PURCHASESALES = 1 AND PS_OZEL.PRODUCT_ID = PRODUCT.PRODUCT_ID AND PS_OZEL.PRICESTANDART_STATUS = 1) AS SATIS_KDV,
        PRODUCT.STOCK_ID,
        PRODUCT.PRODUCT_ID,
        PRODUCT.PROPERTY AS PRODUCT_NAME,
        PRODUCT.PRODUCT_NAME AS PPRODUCT_NAME,
        PRODUCT.PRODUCT_CODE,
        PRODUCT.STOCK_CODE_2,
        PRODUCT_UNIT.PRODUCT_UNIT_ID,
        PRODUCT_UNIT.MAIN_UNIT,
        PRODUCT_CAT.PROFIT_MARGIN,
        PRODUCT_CAT.PRODUCT_CATID,
		(SELECT TOP 1 GSL.PRODUCT_STOCK FROM #dsn2_alias#.GET_STOCK_LAST GSL WHERE GSL.STOCK_ID = PRODUCT.STOCK_ID) AS GERCEK_STOK
    FROM
        PRODUCT_CAT,
        PRODUCT_UNIT,
        STOCKS AS PRODUCT
    WHERE
        PRODUCT.PRODUCT_STATUS = 1 AND
        PRODUCT.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID AND
        PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
        PRODUCT_UNIT.IS_MAIN = 1 AND
        (
        PRODUCT.PRODUCT_NAME IS NOT NULL
        <cfloop from="1" to="#listlen(attributes.keyword,' ')#" index="ccc">
            <cfset kelime_ = listgetat(attributes.keyword,ccc,' ')>
                AND
                (
                PRODUCT.PROPERTY LIKE '%#kelime_#%' OR
                PRODUCT.PRODUCT_NAME LIKE '%#kelime_#%' OR
                PRODUCT.PRODUCT_CODE_2 = '#kelime_#' OR
                PRODUCT.PRODUCT_ID IN (SELECT S.PRODUCT_ID FROM STOCKS_BARCODES SB2,STOCKS S WHERE SB2.STOCK_ID = S.STOCK_ID AND SB2.BARCODE = '#kelime_#')
                )
        </cfloop>
        )
    ORDER BY
        PRODUCT.PRODUCT_NAME
    </cfquery>
    <cf_grid_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id="58221.Ürün Adı"></th>
                <th width="50"><cf_get_lang dictionary_id="58585.Kod"></th>
                <th width="50"><cf_get_lang dictionary_id="57789.Özel Kod"></th>
                <th width="50"><cf_get_lang dictionary_id="58084.Fiyat"></th>
                <th width="50"><cf_get_lang dictionary_id="57452.Stok"></th>
                <cfif get_product.recordcount gt 1>
                <th>
                    <input type="checkbox" name="all_product_id" id="all_product_id" value="1" onclick="check_all_row('<cfoutput>#get_product.recordcount#</cfoutput>');"/>
                    <a href="javascript://" onclick="send_to_add_row();"><img src="/images/plus_small.gif" /></a>
                </th>
               </cfif>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="get_product">
            <cfset product_name_ = PPRODUCT_NAME&' '&replace(product_name,'"','','all')>
            <cfset product_name_ = PPRODUCT_NAME&' '&replace(product_name_,"'","","all")>
            <tr id="product_row_#stock_id#">
                <td><a href="javascript://" onclick="hide('product_row_#stock_id#');window.opener.add_row('#stock_id#','#product_name_#','#wrk_round(GERCEK_STOK)#');" class="tableyazi">#PPRODUCT_NAME# #product_name#</a></td>
                <td>#product_code#</td>
                <td>#stock_code_2#</td>
                <td style="text-align:right;">#TLFORMAT(SATIS_KDV)#</td>
                <td style="text-align:right;">#tlformat(GERCEK_STOK)#</td>
                <cfif get_product.recordcount gt 1>
                    <td>
                    <input type="hidden" name="product_name_#currentrow#" id="product_name_#currentrow#" value="#product_name_#"/>
					<input type="hidden" name="g_stock_#currentrow#" id="g_stock_#currentrow#" value="#wrk_round(GERCEK_STOK)#"/>
                    <input type="checkbox" name="stock_id_#currentrow#" id="stock_id_#currentrow#" value="#stock_id#"/></td>
                </cfif>
            </tr>
            </cfoutput>
        </tbody>
    </cf_grid_list>
    <script>
    function send_to_add_row()
    {
        for (var m=1; m <= <cfoutput>#get_product.recordcount#</cfoutput>; m++)
        {
            if(document.getElementById('stock_id_' + m).checked == true)
            {
                sid_ = document.getElementById('stock_id_' + m).value;
                pname_ = document.getElementById('product_name_' + m).value;
                g_ = document.getElementById('g_stock_' + m).value;
                document.getElementById('stock_id_' + m).checked = false;
				hide('product_row_' + sid_);
                window.opener.add_row(sid_,pname_,g_);
            }
        }
    }
    
    function check_all_row(eleman_sayisi)
    {
        if(document.getElementById('all_product_id').checked == true)
        {
            for (var m=1; m <= eleman_sayisi; m++)
            {
                document.getElementById('stock_id_' + m).checked = true;
            }
        }
        else
        {
            for (var m=1; m <= eleman_sayisi; m++)
            {
                document.getElementById('stock_id_' + m).checked = false;
            }
        }
    }
    </script>
</cfif>