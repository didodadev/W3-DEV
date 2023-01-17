<cfif listlen(attributes.default_product_ids)>
    
    <style>
        .default_product_card {
            background: rgba(48, 184, 242, 0.17);
            padding: 30px;
            border-radius: 20px;
            display: flex;
            flex-direction: column;
            align-content: center;
            flex-wrap: wrap;
            align-items: center;
            margin: 2vw;
            min-height: 420px;
        }

        .default_product_card h4 {
            font-family: "Roboto";
            font-style: normal;
            font-weight: 700;
            font-size: 30px;
            line-height: 36px;
            text-align: center;
            color: #000000;
        }

        .default_product_card .desc {
            font-style: normal;
            font-weight: 400;
            font-size: 16px;
            line-height: 18px;
            text-align: center;
            padding: 10px 15px;
            color: #000000;
        }

        .default_product_card .price {
            font-weight: 500;
            font-size: 24px;
            line-height: 28px;
            text-align: center;
            color: #375677;
            padding: 5px 15px;
        }

        .default_product_card .price2 {
            font-weight: 700;
            font-size: 24px;
            line-height: 26px;
            text-align: center;
            color: #375677;
            padding: 5px 15px;
        }

        .default_product_card a {
            background: #30B8F2;
            border-radius: 10px;
            width: 75%;
            display: inline-block;
            padding: 10px 20px;
            font-family: "PoppinsB";
            font-size: 16px;
            color: #FFFFFF;
            margin: 20px 0 0 0;
            text-align: center;
            transition: 0.4s;
        }
        @media(min-width: 1450px) {
            .default_product_card { min-height: 300px; }
        }
        @media screen and (max-width: 600px) {
            .default_product_card a { width: 100%; }
        }
    </style>
    
    <cfset prodData = createObject("component","V16/objects2/product/cfc/data") />
    <div class="container prem">
        <div class="row">
            <cfloop list="#attributes.default_product_ids#" item="item" index="i">
                <!--- xml'den tanımlanan default_product_id değerlerine göre stock_id bulunur --->
                <cfquery name="get_product" datasource="#dsn3#">
                    SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#item#">
                </cfquery>

                <cfset get_stock = prodData.GET_HOMEPAGE_PRODUCTS(stock_id: get_product.stock_id,session_base:session_base) />

                <cfif get_stock.recordcount>
                    <div class="col-md-<cfoutput>#12 / listLen(attributes.default_product_ids)#</cfoutput>">
                        <div class="default_product_card allin-bg ">
                            <h4><cfoutput>#get_stock.PRODUCT_NAME#</cfoutput></h4>
                            <p class="desc"><cfoutput>#get_stock.PRODUCT_DETAIL#</cfoutput></p>
                            <p class="desc"><cfoutput>#get_stock.PRODUCT_DETAIL2#</cfoutput></p>
                            <p class="price"><cfoutput>#TLFormat(get_stock.PRICE)# #get_stock.MONEY# #get_stock.ADD_UNIT#</cfoutput></p>
                            <!--- <p class="price2">7.900TL Kullanıcı/Yıl 2 ay ücretsiz </p> --->
                            <a href="/tr/sepet/<cfoutput>#get_stock.PRODUCT_ID#</cfoutput>" target=""><cfoutput>#listGetAt(attributes.default_product_button_text, i)#</cfoutput></a>
                        </div>
                    </div>
                </cfif>
            </cfloop>
        </div>
    </div>
</cfif>