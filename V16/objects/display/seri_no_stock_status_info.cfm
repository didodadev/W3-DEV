<!--- Seri No' ya Göre Stok Durumu --->
<cfsavecontent  variable="variable"><cf_get_lang dictionary_id="61192"></cfsavecontent>

    <cfif isdefined("attributes.from_guaranty")> <!--- hızlı seri ekranından geliyorsa --->
        <cf_xml_page_edit fuseact="objects.popup_add_serial_operations">
    </cfif>
    <cf_seperator title="#variable#" id="serial_no">
        <cfform name="add_" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_serial_operations_action">
        <cf_flat_list id="serial_no">
            <cfset total_quantity = total_quantity2 = used_quantity = used_quantity2 = remaining_quantity = remaining_quantity2 = 0 > 
            <cfif isdefined("attributes.from_guaranty") <!--- and listfind("71,81,811,113",attributes.process_cat) --->>
                <cfquery name="GET_SHIP_ROW" datasource="#DSN3#">
                    SELECT
                        DEPARTMENT_IN,
                        LOCATION,
                        LOCATION_IN,
                        DELIVER_STORE_ID
                    FROM
                        #dsn2_alias#.SHIP SHIP,
                        #dsn2_alias#.SHIP_ROW SHIP_ROW
                    WHERE
                        SHIP.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND
                        SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND
                        SHIP_ROW.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
                        <cfif len(attributes.spect_id)>
                            AND SHIP_ROW.SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_id#">
                        </cfif>
                </cfquery>
            </cfif>
            <cfquery name="GET_STOCKS_ALL" datasource="#DSN3#">
                SELECT 
                    SERIAL_NO,
                    LOT_NO,
                    ISNULL(UNIT_ROW_QUANTITY,0) AS UNIT_ROW_QUANTITY,
                    PROCESS_CAT,
                    GUARANTY_ID
                FROM 
                    SERVICE_GUARANTY_NEW
                WHERE 
                    STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#">
                    <cfif isDefined("attributes.solo_serial_no") and len(attributes.solo_serial_no)>
                    AND SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.solo_serial_no#">
                    </cfif>
                    <cfif isdefined("attributes.from_guaranty") <!--- and listfind("71,81,811,113",attributes.process_cat,',') --->>
                        AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SHIP_ROW.DELIVER_STORE_ID#">
                        AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SHIP_ROW.LOCATION#">
                    </cfif>
                    AND IN_OUT = 1
                ORDER BY
                    GUARANTY_ID DESC
            </cfquery>
    
            <cfquery name="GET_PURCHASE_ALL" datasource="#dsn3#">
                SELECT 
                    SGNEW.SERIAL_NO,
                    SGNEW.LOT_NO,
                    SGNEW.ROW_PURCHASE_1,
                    SGNEW.ROW_PURCHASE_2,
                    ( (SGNEW.ROW_PURCHASE_1) - (SGNEW.ROW_PURCHASE_2) ) AS TOTAL,
                    SGNEW.TOPLAM_TOP
                FROM
                (
                    SELECT 
                        SGN.SERIAL_NO,
                        SGN.LOT_NO,
                        COUNT(SGN.SERIAL_NO) AS TOPLAM_TOP,
                        (
                            SELECT ISNULL(SUM(SGN2.UNIT_ROW_QUANTITY),0) AS ROW_1
                            FROM SERVICE_GUARANTY_NEW SGN2 
                            WHERE SGN2.IN_OUT = 1 AND SGN2.SERIAL_NO = SGN.SERIAL_NO  
                            <cfif isdefined("attributes.from_guaranty") and listfind("81,811,113",attributes.process_cat)>
                                AND SGN2.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SHIP_ROW.DELIVER_STORE_ID#">
                                AND SGN2.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SHIP_ROW.LOCATION#">
                            <cfelse>
                                AND SGN2.PROCESS_CAT NOT IN(81,811,113)
                            </cfif>
                        ) AS ROW_PURCHASE_1,
                        (
                            SELECT ISNULL(SUM(SGN3.UNIT_ROW_QUANTITY),0) AS ROW_2 
                            FROM SERVICE_GUARANTY_NEW SGN3 
                            WHERE SGN3.IN_OUT = 0 AND SGN3.SERIAL_NO = SGN.SERIAL_NO  
                            <cfif isdefined("attributes.from_guaranty") and listfind("81,811,113",attributes.process_cat)>
                                AND SGN3.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SHIP_ROW.DELIVER_STORE_ID#">
                                AND SGN3.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SHIP_ROW.LOCATION#"> 
                            <cfelse>
                                AND SGN3.PROCESS_CAT NOT IN(81,811,113)
                            </cfif>
                        ) AS ROW_PURCHASE_2
                    FROM 
                        SERVICE_GUARANTY_NEW AS SGN
                    WHERE 
                        SGN.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#">
                        <cfif isDefined("attributes.solo_serial_no") and len(attributes.solo_serial_no)>
                        AND SGN.SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.solo_serial_no#">
                        </cfif>
                        <cfif isdefined("attributes.from_guaranty") and listfind("81,811,113",attributes.process_cat)>
                        AND SGN.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SHIP_ROW.DELIVER_STORE_ID#">
                        AND SGN.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SHIP_ROW.LOCATION#">
                        <cfelse>
                            AND SGN.PROCESS_CAT NOT IN(81,811,113)
                        </cfif>
                        AND SGN.IN_OUT = 1
                    GROUP BY
                        SGN.SERIAL_NO,
                        SGN.LOT_NO
                ) AS SGNEW
                WHERE ( SGNEW.ROW_PURCHASE_1 - SGNEW.ROW_PURCHASE_2 ) > 0
            </cfquery>
    
            <cfquery name="GET_STOCKS_DEPARTMENT" datasource="#DSN2#">
                SELECT 
                    SR.PRODUCT_STOCK,
                    SR.STOCK_ID,
                    SR.STOCK_CODE,
                    SR.BARCOD,
                    SR.PROPERTY,
                    SR.PRODUCT_ID,
                    D.DEPARTMENT_ID,
                    D.DEPARTMENT_HEAD
                FROM 
                    GET_STOCK_PRODUCT SR,
                    #dsn_alias#.DEPARTMENT D
                WHERE 
                    SR.DEPARTMENT_ID = D.DEPARTMENT_ID AND
                    SR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#">
                ORDER BY
                    SR.DEPARTMENT_ID,
                    SR.STOCK_ID
            </cfquery>
    
            <cfquery name="get_unit_all" datasource="#dsn3#">
                SELECT ADD_UNIT, MULTIPLIER from STOCKS LEFT JOIN PRODUCT_UNIT ON STOCKS.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID WHERE STOCK_ID = #attributes.sid#
            </cfquery>
            <cfif  get_stocks_all.recordcount>
                <cfif isdefined("attributes.from_guaranty")>
                    <cfoutput>
                    <input type="hidden" value="multi_add" name="action_type" id="action_type" />
                    <input type="hidden" value="#attributes.stock_id#" name="stock_id" id="stock_id" />
                    <input type="hidden" value="#attributes.spect_id#" name="spect_id" id="spect_id" />
                    <input type="hidden" value="#attributes.process_cat#" name="process_cat" id="process_cat" />
                    <input type="hidden" value="#attributes.lot_no#" name="lot_no" />
                    <cfif isdefined("attributes.quantity")><input type="hidden" value="#attributes.quantity#" name="quantity"></cfif>
                    <cfif isdefined("attributes.process_id")><input type="hidden" value="#attributes.process_id#" name="process_id" id="process_id" /></cfif>
                    <cfif isdefined("attributes.process_number")><input type="hidden" value="#attributes.process_number#" name="process_number" id="process_number" /></cfif>
                    <cfif isdefined("attributes.amount")><input type="hidden" name="amount" id="amount" value="#attributes.amount#" /></cfif>
                    <cfif isdefined("attributes.wrk_row_id")><input type="hidden" value="#attributes.wrk_row_id#" name="wrk_row_id" id="wrk_row_id" /></cfif>
                    <cfif isdefined("attributes.main_process_cat")><input type="hidden" name="main_process_cat" id="main_process_cat" value="#attributes.main_process_cat#" /></cfif>
                    <cfif isdefined("attributes.main_process_id")><input type="hidden" name="main_process_id" id="main_process_id" value="#attributes.main_process_id#" /></cfif>
                    <cfif isdefined("attributes.main_process_no")><input type="hidden" name="main_process_no" id="main_process_no" value="#attributes.main_process_no#" /></cfif>
                    <cfif isdefined("attributes.main_serial_no")><input type="hidden" name="main_serial_no" id="main_serial_no" value="#attributes.main_serial_no#" /></cfif>
                    <cfif isdefined("attributes.is_change")><input type="hidden" name="is_change" id="is_change" value="#attributes.is_change#" /></cfif>
                    </cfoutput>
                </cfif>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='57637.Seri No'></th>
                        <th><cf_get_lang dictionary_id='32916.Lot No'></th>
                        <th><cf_get_lang dictionary_id='40163.Toplam Miktar'></th>
                        <th><cf_get_lang dictionary_id='57636.Birim'></th>
                        <cfif not isdefined("attributes.from_guaranty")><th><cf_get_lang dictionary_id='57635.Miktar'> 2</th></cfif>
                        <cfif not isdefined("attributes.from_guaranty")><th><cf_get_lang dictionary_id='57636.Birim'> 2</th></cfif>
                        <th><cf_get_lang dictionary_id='32551.Kullanılan Miktar'></th>
                        <cfif not isdefined("attributes.from_guaranty")><th><cf_get_lang dictionary_id='32551.Kullanılan Miktar'> 2</th></cfif>
                        <th><cf_get_lang dictionary_id='40270.Kalan Miktar'></th>
                        <cfif not isdefined("attributes.from_guaranty")><th><cf_get_lang dictionary_id='40270.Kalan Miktar'> 2</th></cfif>
                        <cfif not isDefined("attributes.from_guaranty")>
                            <cfoutput query="GET_STOCKS_DEPARTMENT">
                                <th>#department_head#</th>
                            </cfoutput>
                        </cfif>
                        <cfif isdefined("attributes.from_guaranty")>
                            <th width="20"></th>
                        </cfif>
                    </tr>
                </thead>
                <tbody>
                    <cfif isdefined("attributes.from_guaranty")>
                        <cfoutput query="get_stocks_all">
                            <cfquery name="get_rows2" datasource="#dsn3#">
                                SELECT
                                    ISNULL(SUM(UNIT_ROW_QUANTITY),0) AS UNIT_ROW_QUANTITY
                                FROM
                                    SERVICE_GUARANTY_NEW
                                WHERE
                                    STOCK_ID = #attributes.sid#
                                    AND IN_OUT = 0
                                    AND SERIAL_NO = '#GET_STOCKS_ALL.SERIAL_NO#'
                                    AND PROCESS_CAT <> #GET_STOCKS_ALL.PROCESS_CAT#
                            </cfquery>
                            <cfif UNIT_ROW_QUANTITY - get_rows2.UNIT_ROW_QUANTITY gt 0>
                                <tr>
                                    <td>#SERIAL_NO#</td>
                                    <td>#LOT_NO#</td>
                                    <td style="text-align:center"><cfset total_quantity += UNIT_ROW_QUANTITY> #tlformat(UNIT_ROW_QUANTITY)#</td>
                                    <td style="text-align:center">#get_unit_all.ADD_UNIT#</td>
                                    <!--- <td style="text-align:center"><cfset total_quantity2 += get_unit_all.MULTIPLIER> #tlformat(get_unit_all.MULTIPLIER)#</td> --->
                                    <!--- <td style="text-align:center">#( get_unit_all.recordCount gt 1 ) ? get_unit_all.ADD_UNIT[2] : ''#</td> --->
                                    <td style="text-align:center">
                                        <cfset used_quantity += get_rows2.UNIT_ROW_QUANTITY>
                                        #tlformat(get_rows2.UNIT_ROW_QUANTITY)# #get_unit_all.ADD_UNIT#
                                    </td>
                                    <!--- <td style="text-align:center">
                                        <cfset used_quantity2 += (get_rows2.UNIT_ROW_QUANTITY * get_unit_all.MULTIPLIER) / UNIT_ROW_QUANTITY>
                                        #tlformat((get_rows2.UNIT_ROW_QUANTITY * get_unit_all.MULTIPLIER) / UNIT_ROW_QUANTITY)# #( get_unit_all.recordCount gt 1 ) ? get_unit_all.ADD_UNIT[2] : ''#
                                    </td> --->
                                    <td style="text-align:center" class="editable"><cfset remaining_quantity += get_stocks_all.UNIT_ROW_QUANTITY - get_rows2.UNIT_ROW_QUANTITY> <cfif get_stocks_all.UNIT_ROW_QUANTITY - get_rows2.UNIT_ROW_QUANTITY lt 0><font color="red">#tlformat(get_stocks_all.UNIT_ROW_QUANTITY - get_rows2.UNIT_ROW_QUANTITY)# #get_unit_all.ADD_UNIT#</font><cfelse><div class="form-group"><div class="input-group" style="width:40px;"><input type="text" name="remaining_amount" id="remaining_amount_#GUARANTY_ID#" data-max-value = "#get_stocks_all.UNIT_ROW_QUANTITY - get_rows2.UNIT_ROW_QUANTITY#" value="#tlformat(get_stocks_all.UNIT_ROW_QUANTITY - get_rows2.UNIT_ROW_QUANTITY)#" onkeyup="return(FormatCurrency(this,event,2));" disabled><span>#get_unit_all.ADD_UNIT#</span></div></div></cfif></td>
                                    <!--- <td style="text-align:center">
                                        <cfif get_unit_all.recordCount gt 1 >
                                            #tlformat(get_unit_all.MULTIPLIER - ((get_rows2.UNIT_ROW_QUANTITY * get_unit_all.MULTIPLIER) / UNIT_ROW_QUANTITY))# #( get_unit_all.recordCount gt 1 ) ? get_unit_all.ADD_UNIT[2] : ''#
                                            <cfset remaining_quantity2 += get_unit_all.MULTIPLIER - ((get_rows2.UNIT_ROW_QUANTITY * get_unit_all.MULTIPLIER) / UNIT_ROW_QUANTITY)>
                                        </cfif>   
                                    </td> --->
                                    <cfif isdefined("attributes.from_guaranty")>
                                        <td><input type="checkbox" value="#GUARANTY_ID#" name="guaranty_ids" id="guaranty_ids"></td>
                                    </cfif>
                                </tr>
                            </cfif>
                        </cfoutput>
                        <tr>
                            <td colspan="2"><cf_get_lang dictionary_id ='57492.Toplam'></td>
                            <td style="text-align:center;"><cfoutput>#tlformat(total_quantity)#</cfoutput></td>
                            <td style="text-align:center;"><cfoutput>#get_unit_all.ADD_UNIT#</cfoutput></td>
                            <!--- <td style="text-align:center;"><cfoutput>#tlformat(total_quantity2)#</cfoutput></td> --->
                            <!--- <td style="text-align:center;"><cfoutput>#get_unit_all.ADD_UNIT[2]#</cfoutput></td>--->
                            <td style="text-align:center;"><cfoutput>#tlformat(used_quantity)# #get_unit_all.ADD_UNIT#</cfoutput></td>
                            <!--- <td style="text-align:center;"><cfoutput>#tlformat(used_quantity2)# #get_unit_all.ADD_UNIT[2]#</cfoutput></td> --->
                            <td style="text-align:center;"><cfoutput>#tlformat(remaining_quantity)# #get_unit_all.ADD_UNIT#</cfoutput></td>
                            <!--- <td style="text-align:center;"><cfoutput>#tlformat(remaining_quantity2)# #get_unit_all.ADD_UNIT[2]#</cfoutput></td> --->
                        </tr>
                        <tr>
                            <td colspan="11">
                                <a href="javascript://" class="ui-btn ui-btn-success col-sm-1" style="float:right;" name="add_button" onClick="add_button();">Kaydet</a>
                            </td>
                        </tr>
                    <cfelse>
                        <cfoutput query="GET_PURCHASE_ALL">
                            <tr>
                                <td>#SERIAL_NO#</td>
                                <td>#LOT_NO#</td>
                                <td>#tlformat(ROW_PURCHASE_1)#</td>
                                <td>#get_unit_all.ADD_UNIT#</td>
                                <td>#TOPLAM_TOP#</td>
                                <td>#( get_unit_all.recordCount gt 1 ) ? get_unit_all.ADD_UNIT[2] : ''#</td>
                                <td>#tlformat(ROW_PURCHASE_2)# #get_unit_all.ADD_UNIT#</td>
                                <td>#TLFormat(( ROW_PURCHASE_2 * TOPLAM_TOP) / ROW_PURCHASE_1)# #( get_unit_all.recordCount gt 1 ) ? get_unit_all.ADD_UNIT[2] : ''#</td>
                                <td>#tlformat(total)# #get_unit_all.ADD_UNIT#</td>
                                <td>#tlformat( TOPLAM_TOP -(( ROW_PURCHASE_2 * TOPLAM_TOP) / ROW_PURCHASE_1) )# #( get_unit_all.recordCount gt 1 ) ? get_unit_all.ADD_UNIT[2] : ''#</td>
                                <cfloop query="#GET_STOCKS_DEPARTMENT#">
                                    <cfquery name="get_purchase_serial" datasource="#dsn3#">
                                        SELECT ISNULL(SUM(SGN.UNIT_ROW_QUANTITY),0) AS PURC_ROW_Q FROM SERVICE_GUARANTY_NEW SGN WHERE SERIAL_NO = '#GET_PURCHASE_ALL.SERIAL_NO#' AND IN_OUT = 1 AND DEPARTMENT_ID = #DEPARTMENT_ID#
                                    </cfquery>
                                    <cfquery name="get_sale_serial" datasource="#dsn3#">
                                        SELECT ISNULL(SUM(SGN.UNIT_ROW_QUANTITY),0) AS PURC_ROW_Q FROM SERVICE_GUARANTY_NEW SGN WHERE SERIAL_NO = '#GET_PURCHASE_ALL.SERIAL_NO#' AND IN_OUT = 0 AND DEPARTMENT_ID = #DEPARTMENT_ID#
                                    </cfquery>
                                    <td>#TLFormat(get_purchase_serial.PURC_ROW_Q - get_sale_serial.PURC_ROW_Q)# #get_unit_all.ADD_UNIT#</td>
                                </cfloop>
                            </tr>
                        </cfoutput>
                    </cfif>
                </tbody>
            <cfelse>
                <tr>
                    <td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                </tr>
            </cfif>
        </cf_flat_list>
    </cfform>
    <cfif isdefined("attributes.from_guaranty")>
    <script>
        function add_button() { 
            var mistake = false;
            $("input[name = remaining_amount]").each(function() {
                var oldValue = parseFloat( $(this).attr('data-max-value') );
                var newValue = parseFloat( filterNum( $(this).val() ) );
                console.log( 'o: ' + oldValue );
                console.log( 'n: ' + newValue );
                if( newValue <= oldValue ) $(this).val( filterNum( $(this).val() ) );
                else{ 
                    alert('Girdiğiniz değer kalan miktardan fazla olamaz!'); 
                    mistake = true;
                    return false;
                }
            });
            if(!mistake) $("form#add_").submit();
            else{
                $("input[name = remaining_amount]").each(function() {
                    $(this).val( $(this).val().replaceAll('.',',') );
                });
            }
        }
        $("input[name = guaranty_ids]").click(function () {
            if( $(this).is(":checked") ) $("#remaining_amount_"+ $(this).val() +"").prop('disabled',false);
            else $("#remaining_amount_"+ $(this).val() +"").prop('disabled',true);
        });
    </script>
    </cfif>
    