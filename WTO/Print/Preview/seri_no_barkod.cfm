
<style>
    .printableArea{
        display: block;
		position: relative;
		page-break-after: always;
		width: 85mm;
		height: 65mm;
		display: block;
		position: relative;
		margin-left: 10mm;
		margin-top: 4mm;
    }
    @media print  
    {
        .printableArea{
            page-break-after:always;
        }
    }

    .printableArea * {
        font-family: Arial,Helvetica Neue,Helvetica,sans-serif; 
        -webkit-box-sizing: border-box;
        -moz-box-sizing: border-box;
        box-sizing: border-box;
        font-size: 12px;
    }
    .printableArea *:before,
    .printableArea *:after {
        -webkit-box-sizing: border-box;
        -moz-box-sizing: border-box;
        box-sizing: border-box;
    }

    <!--- SADECE DEVELOPER DA AÇ --->
        /*.printableArea div{border:1px solid red;}
        .printableArea{border: 1px solid #2196F3; } */
    <!--- SADECE DEVELOPER DA AÇ --->

    .printableArea div{display:block;position:absolute;}

    .bold{font-weight: bold;}
    .underline{text-decoration:underline;}
    .left{text-align:left;}
    .center{text-align:center;}
    .right{text-align:right;}

    #qr_seri_container {
        position: absolute;
		top: 140px;
		left: -6mm;
		width: 36mm;
		height: 26mm;
		border-right: 0.2mm solid black;
    }

    div#qr_seri_no {
        position: absolute;
		top: -3mm;
		left: 4mm;
    }
    p#seri_no_text {
	    position: absolute;
    top: 54mm;
    left: 31mm;
    z-index: 999;
    width: 63mm;
    text-align: left;
    font-size: 14px;
	}

    #product_feature table {
        width:100%;
    }

    div#metre_info {
   left: 31mm;
    top: -6mm;
    width: 100%;
    }
    

    div#metre_info p {
        font-size: 31px;
        text-align: center;
		margin: 8mm 0mm 2mm 0mm;
    }

    div#metre_info small {
        text-align: center;
        display: block;
        font-size: 20px;
        line-height: 3mm;
    }

    #product_feature table td {
		font-size: 12px;
		border-bottom: 0.2mm solid black;
		height: 11mm;
		font-weight: bold;
    }

    div#product_feature {
        top: 2mm;
		left: 2mm;
		width: 50mm;
		height: 26mm;
		z-index: 999;
    }

    div#qr_det {
      position: absolute;
    right: -13mm;
    top: -5mm;
    }

    div#firm_info {
      position: absolute;
		left: 35mm;
		width: 58mm;
		height: 33mm;
		top: 3mm;
	}

    p#f_name {
        font-size: 18px;
        font-weight: 600;
        margin-bottom: 1mm;
    }
    div#note {
        width: 100%;
        height: 100%;
        border: 0.4mm dotted;
		z-index: 999;
    }

</style>

<cfif isDefined("attributes.action_id") and len(attributes.action_id)>
    <cfquery name="get_serials" datasource="#dsn3#">
        SELECT 
            SGN.SERIAL_NO,
            SGN.LOT_NO,
            SGN.UNIT_ROW_QUANTITY,  
            S.PRODUCT_NAME,
            S.PROPERTY,
            S.BARCOD,
            S.STOCK_CODE,
            S.PRODUCT_CATID,             
            PC.PRODUCT_CAT,
            PC.HIERARCHY,
            SHP.SHIP_NUMBER,
            SHP.SHIP_DATE,
            S.PROPERTY
        FROM 
            SERVICE_GUARANTY_NEW SGN
            LEFT JOIN STOCKS S ON SGN.STOCK_ID = S.STOCK_ID
            LEFT JOIN PRODUCT_CAT PC ON S.PRODUCT_CATID = PC.PRODUCT_CATID 
            LEFT JOIN #dsn2#.SHIP SHP ON SGN.PROCESS_ID = SHP.SHIP_ID		
        WHERE
            SGN.PROCESS_ID = #attributes.action_id# AND
            SGN.PROCESS_CAT = #attributes.action_type# AND
            SGN.PERIOD_ID = #session.ep.period_id# AND
            SGN.STOCK_ID = #attributes.action_row_id# 
        ORDER BY 
            SGN.SERIAL_NO DESC
    </cfquery>

    <cfloop from="1" to="#get_serials.recordcount#" index="i">
        <div class="printableArea">
            <cfoutput>    
                <div id="product_feature">
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td style="font-size:18px!important">#get_serials.PRODUCT_NAME[i]#</td>
                        </tr>
                        <tr>
                            <td>#get_serials.PROPERTY[i]#</td>
                        </tr>
                        <tr>
                            <td>#get_serials.PRODUCT_CAT[i]#<br><small>#get_serials.HIERARCHY[i]#</small></td>
                        </tr>
                    </table>
                </div>
                <div id="qr_det"> 
                    <cf_workcube_barcode show="1" type="qrcode" width="190" height="190" value=" STOCK_CODE:#get_serials.STOCK_CODE[i]#;PRODUCT_NAME:#get_serials.PRODUCT_NAME[i]#;BARCOD:#get_serials.BARCOD[i]#;PRODUCT_CATID:#get_serials.PRODUCT_CATID[i]#;SHIP_NUMBER:#get_serials.SHIP_NUMBER[i]#;SHIP_DATE:#get_serials.SHIP_DATE[i]#;SERIAL_NO:#get_serials.SERIAL_NO[i]#">                     
                    <div id="metro_info" style="left:5mm">
                        <p>#get_serials.SERIAL_NO[i]#</p>    
                    </div>
                </div>
                <div id="qr_seri_container" class="bold" style="border:0px;">                
                    <!---
                    <div id="qr_seri_no">                    
                        <cf_workcube_barcode show="1" type="qrcode" width="120" height="120" value="#get_serials.SERIAL_NO[i]#">                     
                    </div>--->
                    <div id="metre_info" style="left:0">
                        <p>#TlFormat(get_serials.UNIT_ROW_QUANTITY[i],2)#</p>
                        <small>Metre</small>
                    </div>  
                    
                </div> 
                
            </cfoutput> 
        </div>
    </cfloop>
<cfelseif isDefined("attributes.sid") and len(attributes.sid)>
    <cfquery name="GET_STOCKS_ALL" datasource="#DSN2#">
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
            SR.STOCK_ID = #attributes.sid#
        ORDER BY
            SR.DEPARTMENT_ID,
            SR.STOCK_ID
    </cfquery>
   <cfif GET_STOCKS_ALL.recordCount>
        <cfoutput query="get_stocks_all">
            <cfquery name="get_purchase_serial" datasource="#dsn3#">
                SELECT ISNULL(SUM(SGN.UNIT_ROW_QUANTITY),0) AS PURC_ROW_Q FROM SERVICE_GUARANTY_NEW SGN WHERE SERIAL_NO = '#attributes.serial_no#' AND IN_OUT = 1 AND DEPARTMENT_ID = #DEPARTMENT_ID#
            </cfquery>
            <cfquery name="get_sale_serial" datasource="#dsn3#">
                SELECT ISNULL(SUM(SGN.UNIT_ROW_QUANTITY),0) AS PURC_ROW_Q FROM SERVICE_GUARANTY_NEW SGN WHERE SERIAL_NO = '#attributes.serial_no#' AND IN_OUT = 0 AND DEPARTMENT_ID = #DEPARTMENT_ID#
            </cfquery>
            <cfset serial_product_stock = get_purchase_serial.PURC_ROW_Q - get_sale_serial.PURC_ROW_Q>
            <cfquery name="get_stock_info" datasource="#dsn3#">
                SELECT
                    S.PRODUCT_NAME,
                    PC.PRODUCT_CAT,
                    PC.HIERARCHY,
                    S.PRODUCT_CATID
                FROM
                    STOCKS S
                    JOIN PRODUCT_CAT PC ON S.PRODUCT_CATID = PC.PRODUCT_CATID 
                WHERE 
                    S.STOCK_ID = #STOCK_ID#
            </cfquery>
            <cfif serial_product_stock gt 0>
                <div class="printableArea">   
                    <div id="product_feature">
                        <table border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td style="height:9mm">#get_stock_info.PRODUCT_NAME#</td>
                            </tr>
                            <tr>
                                <td style="height:9mm">#GET_STOCKS_ALL.PROPERTY#</td>
                            </tr>
                            <tr>
                                <td style="height:9mm">#get_stock_info.PRODUCT_CAT#<br><small>#get_stock_info.HIERARCHY#</small></td>
                            </tr>
                            <tr>
                                <td style="height:9mm">#department_head#</td>
                            </tr>
                        </table>
                    </div>
                    <div id="qr_det"> 
                        <cf_workcube_barcode show="1" type="qrcode" width="190" height="190" value=" STOCK_CODE:#GET_STOCKS_ALL.STOCK_CODE#;PRODUCT_NAME:#get_stock_info.PRODUCT_NAME#;BARCOD:#GET_STOCKS_ALL.BARCOD#;PRODUCT_CATID:#get_stock_info.PRODUCT_CATID#;SERIAL_NO:#attributes.SERIAL_NO#">                     
                        <div id="metro_info" style="left:15mm">
                            <p>#attributes.SERIAL_NO#</p>    
                        </div>
                    </div>
                    <div id="qr_seri_container" class="bold" style="border:0px;">                
                        <div id="metre_info" style="left:0">
                            <p>#TlFormat(serial_product_stock,2)#</p>
                            <small>Metre</small>
                        </div>  
                    </div>
                </div>
            </cfif>
        </cfoutput>
   </cfif>
<cfelse>
    <cfset serial_no_list = urlDecode(attributes.serial_no)>
    <cfset department_id_list = attributes.department_id>
    <cfset location_id_list = attributes.location_id>
    <cfset stock_id_list = attributes.stock_id>
    <cfloop from="1" to="#listlen(serial_no_list)#" index="i">
        <cfquery name = "get_product" datasource="#dsn3#">
            SELECT 
                SGNEW.SERIAL_NO,
                SGNEW.LOT_NO,
                SGNEW.ROW_PURCHASE_1,
                SGNEW.ROW_PURCHASE_2,
                ( SGNEW.ROW_PURCHASE_1 - SGNEW.ROW_PURCHASE_2 ) AS TOTAL,
                SGNEW.TOPLAM_TOP,
                SGNEW.PRODUCT_NAME,
                SGNEW.STOCK_CODE,
                SGNEW.PROPERTY,
                SGNEW.DEPARTMENT_HEAD,
                SGNEW.STOCK_ID,
                SGNEW.BARCOD
            FROM
            (
                SELECT 
                    SERIAL_NO,
                    LOT_NO,
                    COUNT(SERIAL_NO) AS TOPLAM_TOP,
                    PRODUCT_NAME,
                    STOCK_CODE,
                    PROPERTY,
                    DEPARTMENT_HEAD,
                    S3.STOCK_ID,
                    BARCOD,
                    (
                        SELECT ISNULL(SUM(SGN2.UNIT_ROW_QUANTITY),0) AS ROW_1
                        FROM SERVICE_GUARANTY_NEW SGN2 
                        LEFT JOIN STOCKS S ON SGN2.STOCK_ID = S.STOCK_ID
                        LEFT JOIN #dsn_alias#.DEPARTMENT D ON SGN2.DEPARTMENT_ID = D.DEPARTMENT_ID
                        WHERE SGN2.IN_OUT = 1 AND SGN2.SERIAL_NO = SGN.SERIAL_NO  
                        AND SGN2.DEPARTMENT_ID = #listGetAt(department_id_list,i,',')#
                        AND SGN2.LOCATION_ID = #listGetAt(location_id_list,i,',')#
                        AND SGN2.SERIAL_NO = '#listGetAt(serial_no_list,i,',')#'
                        AND S.STOCK_ID = #listGetAt(stock_id_list,i,',')#
                    ) AS ROW_PURCHASE_1,
                    (
                        SELECT ISNULL(SUM(SGN3.UNIT_ROW_QUANTITY),0) AS ROW_2 
                        FROM SERVICE_GUARANTY_NEW SGN3 
                        LEFT JOIN STOCKS S2 ON SGN3.STOCK_ID = S2.STOCK_ID
                        LEFT JOIN #dsn_alias#.DEPARTMENT D2 ON SGN3.DEPARTMENT_ID = D2.DEPARTMENT_ID
                        WHERE SGN3.IN_OUT = 0 AND SGN3.SERIAL_NO = SGN.SERIAL_NO  
                        AND SGN3.DEPARTMENT_ID = #listGetAt(department_id_list,i,',')#
                        AND SGN3.LOCATION_ID = #listGetAt(location_id_list,i,',')#
                        AND SGN3.SERIAL_NO = '#listGetAt(serial_no_list,i,',')#'
                        AND S2.STOCK_ID = #listGetAt(stock_id_list,i,',')#
                    ) AS ROW_PURCHASE_2
                FROM 
                    SERVICE_GUARANTY_NEW AS SGN
                    LEFT JOIN STOCKS S3 ON SGN.STOCK_ID = S3.STOCK_ID
                    LEFT JOIN #dsn_alias#.DEPARTMENT D3 ON SGN.DEPARTMENT_ID = D3.DEPARTMENT_ID
                WHERE 
                    1 = 1
                    AND SGN.DEPARTMENT_ID = #listGetAt(department_id_list,i,',')#
                    AND SGN.LOCATION_ID = #listGetAt(location_id_list,i,',')#    
                    AND SGN.SERIAL_NO = '#listGetAt(serial_no_list,i,',')#'         
                    AND S3.STOCK_ID = #listGetAt(stock_id_list,i,',')#
                    AND IN_OUT = 1
                GROUP BY
                    SERIAL_NO,
                    LOT_NO,
                    PRODUCT_NAME,
                    STOCK_CODE,
                    PROPERTY,
                    DEPARTMENT_HEAD,
                    S3.STOCK_ID,
                    BARCOD
            ) AS SGNEW
            WHERE SGNEW.ROW_PURCHASE_1 - SGNEW.ROW_PURCHASE_2 > 0
        </cfquery>
        <cfquery name="get_stock_info" datasource="#dsn3#">
            SELECT
                S.PRODUCT_NAME,
                PC.PRODUCT_CAT,
                PC.HIERARCHY,
                S.PRODUCT_CATID
            FROM
                STOCKS S
                JOIN PRODUCT_CAT PC ON S.PRODUCT_CATID = PC.PRODUCT_CATID 
            WHERE 
                S.STOCK_ID = #listGetAt(stock_id_list,i,',')#
        </cfquery>
        <div class="printableArea">   
            <div id="product_feature">
                <table border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td style="height:9mm"><cfoutput>#get_product.PRODUCT_NAME#</cfoutput></td>
                    </tr>
                    <tr>
                        <td style="height:9mm"><cfoutput>#get_product.PROPERTY#</cfoutput></td>
                    </tr>
                    <tr>
                        <td style="height:9mm"><cfoutput>#get_stock_info.PRODUCT_CAT#</cfoutput><br><small><cfoutput>#get_stock_info.HIERARCHY#</cfoutput></small></td>
                    </tr>
                    <tr>
                        <td style="height:9mm"><cfoutput>#get_product.DEPARTMENT_HEAD#</cfoutput></td>
                    </tr>
                </table>
            </div>
            <div id="qr_det"> 
                <cf_workcube_barcode show="1" type="qrcode" width="190" height="190" value=" STOCK_CODE:#get_product.STOCK_CODE#;PRODUCT_NAME:#get_product.PRODUCT_NAME#;BARCOD:#get_product.BARCOD#;PRODUCT_CATID:#get_stock_info.PRODUCT_CATID#;SERIAL_NO:#get_product.SERIAL_NO#">                     
                <div id="metro_info" style="left:15mm">
                    <p><cfoutput>#get_product.SERIAL_NO#</cfoutput></p>    
                </div>
            </div>
            <div id="qr_seri_container" class="bold" style="border:0px;">                
                <div id="metre_info" style="left:0">
                    <p><cfoutput>#TlFormat(get_product.TOTAL,2)#</cfoutput></p>
                    <small>Metre</small>
                </div>  
            </div>
        </div>

    </cfloop>
</cfif>