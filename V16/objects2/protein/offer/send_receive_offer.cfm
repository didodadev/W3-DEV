<cfquery name="get_offer" datasource="#dsn3#">
    SELECT 
        O.OFFER_ID,
        O.OFFER_NUMBER,
        O.REF_NO,
        O.OFFER_HEAD,
        O.OFFER_TO,
        O.OFFER_TO_PARTNER,
        O.OFFER_TO_CONSUMER,
        O.OFFER_DATE,
        O.OFFER_STAGE,
        PTR.STAGE,
        PTR.LINE_NUMBER
    FROM 
        OFFER AS O
        LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR ON O.OFFER_STAGE = PTR.PROCESS_ROW_ID
    WHERE
       O.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>
<cfquery name="get_offer_row" datasource="#dsn3#">
    SELECT 
        ORR.OFFER_ID,
        ORR.OFFER_ROW_ID,
        ORR.PRODUCT_ID,
        ORR.STOCK_ID,
        S.STOCK_CODE,
        ORR.QUANTITY,
        ORR.UNIT,
        ORR.UNIT_ID,
        ORR.QUANTITY,
        ORR.PRICE,
        ORR.PRICE_OTHER,
        ORR.TAX,
        ORR.OTV_ORAN,
        ORR.OTVTOTAL,
        ORR.PRODUCT_NAME,
        ORR.DESCRIPTION,
        ORR.SPECT_VAR_NAME,
        ORR.SPECT_VAR_ID,
        ORR.OTHER_MONEY,
        ORR.OTHER_MONEY_VALUE 
    FROM 
        OFFER_ROW AS ORR
        LEFT JOIN #dsn#_product.STOCKS AS S ON S.STOCK_ID = ORR.STOCK_ID
    WHERE
        ORR.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>
<cfoutput>
    <div class="row">        
        <div class="col-md-2">
            <div class="row mb-2">
                <div class="col-lg-12">
                    <label class="font-weight-bold">Belge No</label>
                </div>
                <div class="col-lg-12">
                    <label>#get_offer.OFFER_NUMBER#</label>
                </div>
            </div>        
        </div>
        <div class="col-md-6">
            <div class="row mb-2">
                <div class="col-lg-12">
                    <label class="font-weight-bold">Başlık</label>
                </div>
                <div class="col-lg-12">
                    <label>#get_offer.OFFER_HEAD#</label>
                </div>
            </div>        
        </div>
        <div class="col-md-4">
            <div class="row mb-2">
                <div class="col-lg-12">
                    <label class="font-weight-bold">Tarih</label>
                </div>
                <div class="col-lg-12">
                    <label>#dateformat(get_offer.OFFER_DATE,'dd/mm/yyyy')#</label>
                </div>
            </div>        
        </div>
    </div>
</cfoutput>
<cfform name="add_cont_com" method="post"  enctype="multipart/form-data">
    <input type="hidden" name="offer_id"  value="<cfoutput>#attributes.offer_id#</cfoutput>">
    <input type="hidden" name="rows"  value="<cfoutput>#get_offer_row.recordcount#</cfoutput>">
    
    <div class="protein-table" id="search-results"> 
        <div class="table-responsive">
        <table class="table table-hover">
            <thead class="main-bg-color">
                <tr>    
                    <th>#</th>       
                    <th>Ürün</th>
                    <th>Açıklama</th>
                    <th>Stok Kodu</th>   
                    <th>Birim</th>
                    <th>Miktar</th>  
                    <th>Kdv</th>
                    <th>Ötv</th>
                    <th>Fiyat</th>                        
                </tr>
            </thead>
            <tbody>
                <cfoutput query="get_offer_row">            
                    <tr>
                        <td>#currentrow#</td>
                        <td>
                            #PRODUCT_NAME#<br/>
                            <small>#SPECT_VAR_NAME#</small>
                        </td>
                        <td>#DESCRIPTION#</td>
                        <td>#STOCK_CODE#</td>
                        <td>#UNIT#</td>
                        <td>#QUANTITY#</td>
                        <td>#OTV_ORAN#</td>
                        <td>#TAX#</td>
                        <td>
                            <div class="input-group mb-3">
                                <input type="text" name="price_#currentrow#" class="moneybox form-control text-right"  onKeyup="return(FormatCurrency(this,event,0));">
                                <span class="input-group-text font-weight-bold" >#OTHER_MONEY#</span>
                            </div>
                        </td>                     
                    </tr>
                </cfoutput>
            </tbody>        
            </table>
        </div>      
    </div>
    <div class="card-footer-bottom-margin" style=" display: block; height: 65px; "></div>
    <div class="card-footer text-muted" style=" width: 100%; left: 0; bottom: -2px; z-index: 9999; position: absolute; background: #f7f7f7; ">
        <cf_workcube_buttons 
            is_upd='0' 
            add_function="" 
            data_action = "/V16/objects2/protein/offer/data/offer:add_receive_offer" 
            next_page="/#site_language#/offer">
    </div>
</cfform>