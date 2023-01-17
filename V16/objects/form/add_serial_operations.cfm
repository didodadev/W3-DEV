<cf_xml_page_edit fuseact="objects.popup_add_serial_operations">
    <cfsetting showdebugoutput="yes">
    <cfquery name="get_rows" datasource="#dsn3#">
        <cfif attributes.process_cat_id eq 116>
            <cfif (isdefined("attributes.process_id") and attributes.process_id eq 0) or (isdefined("attributes.is_change") and attributes.is_change eq 1)>
                SELECT
                    STOCKS.STOCK_CODE,
                    STOCKS.PRODUCT_NAME,
                    STOCKS.STOCK_ID,
                    STOCKS.PRODUCT_ID,
                    <cfif isdefined("attributes.spect_id") and len(attributes.spect_id)>#attributes.spect_id# AS SPECT_ID<cfelse>'' AS SPECT_ID</cfif> ,
                    #attributes.amount# QUANTITY,
                    0 AS QUANTITY_2
                FROM
                    STOCKS
                WHERE
                    STOCKS.IS_SERIAL_NO = 1
                    <cfif isdefined("attributes.stock_id")>
                        AND STOCKS.STOCK_ID = #attributes.stock_id#
                    </cfif>
            <cfelse>
                SELECT
                    STOCKS.STOCK_CODE,
                    STOCKS.PRODUCT_NAME,
                    STOCK_EXCHANGE.EXIT_STOCK_ID,
                    STOCK_EXCHANGE.EXIT_PRODUCT_ID,
                    STOCK_EXCHANGE.EXIT_SPECT_ID SPECT_ID,
                    SUM(STOCK_EXCHANGE.EXIT_AMOUNT) QUANTITY,
                    0 AS QUANTITY_2
                FROM
                    #dsn2_alias#.STOCK_EXCHANGE,
                    STOCKS
                WHERE
                    STOCK_EXCHANGE.STOCK_EXCHANGE_ID = #attributes.process_id#
                    AND STOCK_EXCHANGE.EXIT_STOCK_ID = STOCKS.STOCK_ID
                    AND STOCKS.IS_SERIAL_NO = 1
                    AND STOCK_EXCHANGE.PROCESS_TYPE = #attributes.process_cat_id# 
                    AND STOCK_EXCHANGE.EXCHANGE_NUMBER = '#attributes.belge_no#'
                    <cfif isdefined("attributes.stock_id")>
                        AND STOCKS.STOCK_ID = #attributes.stock_id#
                    </cfif>
                GROUP BY
                    STOCKS.STOCK_CODE,
                    STOCKS.PRODUCT_NAME,
                    STOCK_EXCHANGE.EXIT_STOCK_ID,
                    STOCK_EXCHANGE.EXIT_PRODUCT_ID,
                    STOCK_EXCHANGE.EXIT_SPECT_ID,
                    STOCK_EXCHANGE.STOCK_EXCHANGE_ID
                ORDER BY STOCK_EXCHANGE.STOCK_EXCHANGE_ID
            </cfif>
        <cfelse>
            SELECT
                STOCKS.STOCK_CODE,
                STOCKS.PRODUCT_NAME,
                SHIP_ROW.STOCK_ID,
                SHIP_ROW.PRODUCT_ID,
                SHIP_ROW.SPECT_VAR_ID SPECT_ID,
                SHIP_ROW.WRK_ROW_ID,
                SHIP_ROW.SHIP_ROW_ID,
                SUM(SHIP_ROW.AMOUNT) QUANTITY,
                SUM(SHIP_ROW.AMOUNT2) QUANTITY_2
            FROM
                #dsn2_alias#.SHIP SHIP,
                #dsn2_alias#.SHIP_ROW SHIP_ROW,
                STOCKS
            WHERE
                SHIP.SHIP_ID = #attributes.process_id# AND
                SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND
                SHIP_ROW.STOCK_ID = STOCKS.STOCK_ID AND
                STOCKS.IS_SERIAL_NO = 1 AND
                SHIP.SHIP_STATUS = 1
                AND SHIP.SHIP_TYPE = #attributes.process_cat_id# 
                AND SHIP.SHIP_NUMBER = '#attributes.belge_no#'
            GROUP BY
                STOCKS.STOCK_CODE,
                STOCKS.PRODUCT_NAME,
                SHIP_ROW.WRK_ROW_ID,
                SHIP_ROW.STOCK_ID,
                SHIP_ROW.PRODUCT_ID,
                SHIP_ROW.SPECT_VAR_ID,
                SHIP_ROW.SHIP_ROW_ID
            ORDER BY SHIP_ROW.SHIP_ROW_ID ASC
            
        </cfif>
    </cfquery>
    <!--- <cfquery name="GET_INV" datasource="#DSN2#">
        SELECT INVOICE_NUMBER,SHIP_NUMBER,IS_WITH_SHIP FROM INVOICE_SHIPS WHERE SHIP_ID = #attributes.process_id# AND SHIP_PERIOD_ID= #session.ep.period_id#
    </cfquery> --->
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='32706.Hızlı Seri No Girişi'></cfsavecontent>
    <div class="col col-12">
        <cf_box title="#message# : #get_process_name(attributes.process_cat_id)# (#attributes.belge_no#)" collapsable="#iif(isdefined("attributes.draggable"),1,0)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
            <cf_box_search more="0">
                <div class="form-group" id="item-add_new_serial_no">
                    <input type="text" value="" id="add_new_serial_no" name="add_new_serial_no" placeholder="<cfoutput><cf_get_lang dictionary_id='32708.Seri No Ekle'></cfoutput>"  onkeyup="return(add_serial_no_control(event));"//>
                </div>
                <div class="form-group" id="item-add_new_serial_no_amount">
                    <input type="text" value="" id="add_new_serial_no_amount" name="add_new_serial_no_amount" placeholder="<cf_get_lang dictionary_id = "57635.Miktar">"  onkeyup="return(FormatCurrency(this,event,2));"//>
                </div>
                <div class="form-group" id="item-add_new_serial_no_button">			
                    <a class="ui-btn ui-btn-gray" name="add_new_serial_no_button" id="add_new_serial_no_button" onclick="add_serial_no();"><i class="fa fa-plus"></i></a>
                </div>
                <div class="form-group" id="item-delete_old_serial_no">
                    <input type="text" value="" id="delete_old_serial_no" name="delete_old_serial_no" placeholder="<cfoutput><cf_get_lang dictionary_id='32711.Seri No Çıkar'></cfoutput>" onkeyup="return(del_serial_no_control(event));"/>
                </div>
                <div class="form-group" id="item-add_new_serial_no_button">			
                    <a class="ui-btn ui-btn-gray2" name="delete_old_serial_no_button" id="delete_old_serial_no_button" value="-" onclick="del_serial_no();"><i class="fa fa-minus"></i></a>
                </div>
            </cf_box_search>   
            <div id="action_div"></div>
            <cf_grid_list>
                <thead>
                    <tr>
                        <th width="20"></th>
                        <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                        <th><cf_get_lang dictionary_id='33902.Stok Adı'></th>
                        <th><cf_get_lang dictionary_id='33657.Çıkan'><cf_get_lang dictionary_id='57718.Seri Nolar'></th>
                        <!--- <th><cf_get_lang dictionary_id='32823.Toplam Miktar'></th>
                        <th><cf_get_lang dictionary_id='32551.Kullanılan Miktar'></th> --->
                        <th><cf_get_lang dictionary_id='32724.İrsaliye Miktarı'></th>
                        <th><cf_get_lang dictionary_id='32724.İrsaliye Miktarı'> 2</th>
                        <th><cf_get_lang dictionary_id='32725.Çıkış Miktarı'></th>
                        <th><cf_get_lang dictionary_id='32725.Çıkış Miktarı'> 2</th>
                        <cfif attributes.process_cat_id neq 116><th><input id="check_ship_row_All" name="check_ship_row_All" onclick="wrk_select_all('check_ship_row_All','action_list_id');" type="checkbox"></th></cfif>
                        <!--- <th><cf_get_lang dictionary_id='32727.Kalan Miktar'></th> --->
                    </tr>
                </thead>
                <tbody>
                    <cfset stockCode = arrayNew(1) />
                    <cfset bfStockCode = structNew() />
                    <cfoutput query="get_rows">
                        <cfif not structKeyExists( bfStockCode, STOCK_ID )>
                            <cfset bfStockCode[STOCK_ID]["QUANTITY"] = QUANTITY />
                            <cfset bfStockCode[STOCK_ID]["QUANTITY_2"] = QUANTITY_2 />
                            <cfset bfStockCode[STOCK_ID]["COUNTER"] = 1 />
                        <cfelse>
                            <cfset bfStockCode[STOCK_ID]["QUANTITY"] += QUANTITY />
                            <cfset bfStockCode[STOCK_ID]["QUANTITY_2"] += QUANTITY_2 />
                            <cfset bfStockCode[STOCK_ID]["COUNTER"] += 1 />
                        </cfif>
                    </cfoutput>
                    <cfoutput query="get_rows">
                        <cfif not arrayContains( stockCode, STOCK_CODE )>
                            <cfquery name="GET_SERIAL_INFO" datasource="#DSN3#">
                                SELECT DISTINCT
                                    SG.LOT_NO,
                                    SG.SERIAL_NO,
                                    SG.UNIT_ROW_QUANTITY
                                FROM
                                    SERVICE_GUARANTY_NEW AS SG
                                WHERE
                                    STOCK_ID = #STOCK_ID# AND
                                    <cfif attributes.process_id eq 0>
                                        WRK_ROW_ID = '#attributes.wrk_row_id#' AND
                                    <cfelse>
                                        PROCESS_ID = #attributes.process_id# AND
                                    </cfif>
                                    PROCESS_CAT = #attributes.process_cat_id# AND
                                    SG.PERIOD_ID = #session.ep.period_id#
                                    <cfif attributes.process_cat_id eq 116>
                                        AND IN_OUT = 0
                                    </cfif>
                                    <cfif len(spect_id)>AND SG.SPECT_ID = #spect_id#</cfif>
                            </cfquery>
                            <cfquery name="GET_SERIAL_INFO1" datasource="#DSN3#">
                                SELECT
                                top 1 
                                    SG.LOT_NO,
                                    SG.SERIAL_NO
                                FROM
                                    SERVICE_GUARANTY_NEW AS SG
                                WHERE
                                    STOCK_ID = #STOCK_ID#                       
                            </cfquery>
                            <!--- <cfif len(GET_SERIAL_INFO.SERIAL_NO)>
                                <cfquery name="GET_SERIAL_INFO2" datasource="#dsn3#">
                                    SELECT SG.UNIT_ROW_QUANTITY FROM SERVICE_GUARANTY_NEW AS SG WHERE SERIAL_NO IN ('#valuelist(GET_SERIAL_INFO.SERIAL_NO,',')#') AND IN_OUT = 1
                                </cfquery>
                                <cfquery name="get_rows2" datasource="#dsn3#">
                                    SELECT
                                        SUM(UNIT_ROW_QUANTITY) AS UNIT_ROW_QUANTITY
                                    FROM
                                        SERVICE_GUARANTY_NEW
                                    WHERE SERIAL_NO IN ('#valuelist(GET_SERIAL_INFO.SERIAL_NO,',')#') AND IN_OUT = 0
                                    GROUP BY
                                        SERIAL_NO
                                </cfquery>
                            </cfif> --->
                            <tr height="20">
                                <td class="iconL">
                                    <!--- <cfif not GET_INV.recordcount or attributes.process_cat_id eq 116> --->
                                        <cfif isdefined("attributes.wrk_row_id") and len(attributes.wrk_row_id)><cfset wrk_row_id= attributes.wrk_row_id><cfelse></cfif>
                                        <a href="javascript:void(0)" id="order_row#currentrow#"  onclick="gizle_goster(order_row#currentrow#);connectAjax('#currentrow#','#request.self#?fuseaction=stock.seri_no_stock_status_info&from_guaranty=1&sid=#stock_id#&lot_no=#GET_SERIAL_INFO1.lot_no#&process_number=#attributes.belge_no#&quantity=#get_rows.QUANTITY#<cfif isdefined("attributes.wrk_row_id") and len(attributes.wrk_row_id)>&wrk_row_id=#attributes.wrk_row_id#</cfif>&process_cat=#attributes.process_cat_id#&process_id=#process_id#&stock_id=#STOCK_ID#&spect_id=#SPECT_ID#<cfif isdefined("attributes.is_change")>&is_change=1</cfif><cfif attributes.process_cat_id eq 116>&amount=#quantity#</cfif>');"><i class="fa fa-caret-right"></i></a>
                                    <!--- </cfif> --->
                                </td>
                                <td>#STOCK_CODE# <cfif len(SPECT_ID)>(#STOCK_ID# - #SPECT_ID#)</cfif></td>
                                <td>#PRODUCT_NAME#</td>
                                <td style="width: 50mm;padding: 0;">
                                    <cfset totalExitSerialAmount = 0 />
                                    <cfif GET_SERIAL_INFO.recordCount>
                                        <table>
                                            <cfloop query="GET_SERIAL_INFO">
                                                <cfset totalExitSerialAmount+=len(GET_SERIAL_INFO.UNIT_ROW_QUANTITY) ? GET_SERIAL_INFO.UNIT_ROW_QUANTITY : 0 />
                                                <tr>
                                                    <td style="border:none;">#GET_SERIAL_INFO.SERIAL_NO#</td>
                                                    <td style="border:none;"><i><b>(#TLFormat(GET_SERIAL_INFO.UNIT_ROW_QUANTITY)#)</i></b></td>
                                                </tr>
                                            </cfloop>
                                        </table>
                                    </cfif>
                                    <!--- <div id="serial_no_list_#stock_id#<cfif len(spect_id)>_#spect_id#</cfif>" style="max-height:75px; overflow:auto;">#valuelist(GET_SERIAL_INFO.SERIAL_NO,'<br />')#</div> --->
                                </td>
                                <!--- <td id="serial_no_quantity_#stock_id#"><cfif isdefined("GET_SERIAL_INFO2.UNIT_ROW_QUANTITY")>#GET_SERIAL_INFO2.UNIT_ROW_QUANTITY#</cfif></td>
                                <td><cfif isdefined("get_rows2.UNIT_ROW_QUANTITY")>#get_rows2.UNIT_ROW_QUANTITY#</cfif></td> --->
                                <td id="serial_no_amount_#stock_id#<cfif len(spect_id)>_#spect_id#</cfif>">#TLFormat(bfStockCode[STOCK_ID]["QUANTITY"])#</td>
                                <td id="serial_no_amount_#stock_id#<cfif len(spect_id)>_#spect_id#</cfif>">#TLFormat(bfStockCode[STOCK_ID]["QUANTITY_2"])#</td>
                                <td id="serial_no_record_#stock_id#<cfif len(spect_id)>_#spect_id#</cfif>">#TLFormat(totalExitSerialAmount)#</td>
                                <td id="serial_no_record_#stock_id#<cfif len(spect_id)>_#spect_id#</cfif>">#TLFormat(GET_SERIAL_INFO.recordCount)#</td>
                                <cfif attributes.process_cat_id neq 116 and bfStockCode[STOCK_ID]["COUNTER"] eq 1><td><input id="action_list_id" name="action_list_id" type="checkbox" value="#SHIP_ROW_ID#" data-serial-total-value="#totalExitSerialAmount#" data-serial-total-value_2="#GET_SERIAL_INFO.recordCount#" data-stock-id="#STOCK_ID#"></td></cfif>
                                <!--- <td id="serial_no_fark_#stock_id#<cfif len(spect_id)>_#spect_id#</cfif>"><cfif isdefined("GET_SERIAL_INFO2.UNIT_ROW_QUANTITY") and len(GET_SERIAL_INFO2.UNIT_ROW_QUANTITY)>#GET_SERIAL_INFO2.UNIT_ROW_QUANTITY-get_rows2.UNIT_ROW_QUANTITY#</cfif></td> --->
                            </tr>
                            <tr id="order_row#currentrow#" class="table_detail">
                                <td colspan="20">
                                    <div align="left" id="DISPLAY_ORDER_STOCK_INFO#currentrow#"></div>
                                </td>
                            </tr>
                            <cfset arrayAppend( stockCode, STOCK_CODE ) />
                        </cfif>
                    </cfoutput>
                </tbody>
            </cf_grid_list>
            <cf_box_footer>
                <cf_workcube_buttons add_function="setShip()">
            </cf_box_footer>
            <!--- <cfif GET_INV.recordcount and attributes.process_cat_id neq 116>
                <div clas="ui-card">
                    <div class="ui-card-item">
                        <span class="ui-stage" style="color:#fd397a;"><cf_get_lang dictionary_id='32728.Bu irsaliye faturalaştığı için seri işlemi yapamazsınız!'></span>
                    </div>
                </div>
            </cfif> --->
        </cf_box>
    </div>
    <script>
    
    function del_serial_no_control(e)
    {
        if(!e) return false;/*if(!e) var e = window.event;*/
        var key=e.keyCode || e.which;
        if(key == 13)
            {
            del_serial_no();
            document.getElementById('delete_old_serial_no').value = '';
            }
    }
    function add_serial_no_control(e)
    {
        if(!e) return false;/*if(!e) var e = window.event;*/
        var key=e.keyCode || e.which;
        if(key == 13)
            {
            add_serial_no();
            document.getElementById('add_new_serial_no').value = '';
            }
    }
    function add_serial_no()
    {
        <!--- <cfif GET_INV.recordcount>
            alert("<cf_get_lang dictionary_id='32728.Bu irsaliye faturalaştığı için seri işlemi yapamazsınız!'>");
            return false;
        </cfif> --->
        serial_no_ = document.getElementById('add_new_serial_no').value;
        add_new_serial_no_amount = document.getElementById('add_new_serial_no_amount').value;
        if(serial_no_=='')
            {
            alert("<cf_get_lang dictionary_id='41875.Lütfen Seri No Giriniz'>!");
            return false;
            }
        else{
            AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_add_serial_operations_action&action_type=add<cfif isdefined("attributes.stock_id")>&stock_id=<cfoutput>#attributes.stock_id#</cfoutput></cfif><cfif isdefined("attributes.spect_id")>&spect_id=<cfoutput>#attributes.spect_id#</cfoutput></cfif>&process_id=<cfoutput>#attributes.process_id#</cfoutput><cfif attributes.process_cat_id eq 116>&amount=<cfoutput>#attributes.amount#</cfoutput></cfif>&process_cat=<cfoutput>#attributes.process_cat_id#</cfoutput>&process_number=<cfoutput>#attributes.belge_no#</cfoutput>&quantity=<cfoutput>#get_rows.QUANTITY#</cfoutput><cfif isdefined("attributes.wrk_row_id")>&wrk_row_id=<cfoutput>#attributes.wrk_row_id#</cfoutput></cfif>&serial_no=' + serial_no_ + '&add_new_serial_no_amount=' + add_new_serial_no_amount,'action_div',1);
            location.reload();
        }
    }
    function del_serial_no()
    {
        <!--- <cfif GET_INV.recordcount>
            alert("<cf_get_lang dictionary_id='32728.Bu irsaliye faturalaştığı için seri işlemi yapamazsınız!'>");
            return false;
        </cfif> --->
        serial_no_ = document.getElementById('delete_old_serial_no').value;
        if(serial_no_=='')
            {
            alert("<cf_get_lang dictionary_id='41875.Lütfen Seri No Giriniz'>!");
            return false;
            }
        else{
            AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_add_serial_operations_action&action_type=del&process_id=<cfoutput>#attributes.process_id#</cfoutput>&process_cat=<cfoutput>#attributes.process_cat_id#</cfoutput>&serial_no=' + serial_no_,'action_div',1);
            location.reload();
        }
    }
    function connectAjax(crtrow,load_url_){
        AjaxPageLoad(load_url_,'DISPLAY_ORDER_STOCK_INFO'+crtrow,1);
    }
    
    function setShip() {
    
        if( confirm("İrsaliye satırlarının miktarları güncellenecek!") ){
            
            if( $("input[name = action_list_id]:checked").length > 0 ){
    
                if( window.opener.form_basket.wrk_submit_button != 'undefined' ){
    
                    $("#working_div_main").show();
    
                    var ship_row_id,
                        stock_id, 
                        serial_total,
                        serial_total_2;
                    
                        $("input[name = action_list_id]:checked").each(function(){
                            ship_row_id = $(this).val();
                            stock_id = $(this).attr('data-stock-id');
                            serial_total = $(this).attr('data-serial-total-value');
                            serial_total_2 = $(this).attr('data-serial-total-value_2');
    
                            if( window.opener.basket.items.length > 0 ){
                                window.opener.basket.items.forEach(( element, index ) => {
                                    if( element.STOCK_ID == stock_id ){
                                        window.opener.basket.items[index].AMOUNT = serial_total;
                                        window.opener.$("#tblBasket tr[itemindex="+index+"]").find("#Amount").val( commaSplit( serial_total, 1 ) );
                                        window.opener.hesapla("Amount",index);
    
                                        window.opener.$("#tblBasket tr[itemindex="+index+"]").find("#amount_other").val( commaSplit( serial_total_2, 1 ) );
                                        window.opener.basket.items[index].AMOUNT_OTHER = serial_total_2;
                                        window.opener.hesapla("amount_other",index);
                                    }
                                });
                            }
    
                        });
    
                        setTimeout(() => {
                            opener.updateButton();
                            window.close();
                        }, 1000);
                        
                        /* var data = new FormData();
                        data.append('ship_row_id', ship_row_id.join(','));
                        data.append('serial_total', serial_total.join(','));
                        data.append('serial_total_2', serial_total_2.join(','));
    
                        AjaxControlPostDataJson('V16/objects/cfc/set_ship_row.cfc?method=set_ship_row', data, function (response) {
                            if( response.STATUS ){
                                //window.opener.location.reload();
                                setTimeout(() => {
                                    window.opener.$("#wrk_submit_button").click();
                                    window.close();
                                }, 15000);
                            }
                        }); */
    
                }else{
                    alert("Bu belge güncellenemez!");
                }
    
            }else{
                alert("Lütfen en az 1 adet seçim yapınız!");
            }
        }
        return false;
    }
    
    </script>
    