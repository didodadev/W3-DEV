/* 
    File: Fabric_Seri_Lot_Label.cfm
    Author: Yazılımsa - Semih Akartuna <semihakartuna@yazilimsa.com>
    Date: 05.03.2020
    Description:
	Fabric Seri Barkod Sablonu
*/
<style>
    .printableArea{
        display: block;
        position: relative;
        page-break-after: always;
        width: 130mm;
        height: 100mm;
        display: block;
        position: relative;
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
        .printableArea{border: 1px solid #2196F3; }*/
    <!--- SADECE DEVELOPER DA AÇ --->

    .printableArea div{display:block;position:absolute;}

    .bold{font-weight: bold;}
    .underline{text-decoration:underline;}
    .left{text-align:left;}
    .center{text-align:center;}
    .right{text-align:right;}

    #qr_seri_container {
        position: absolute;
        top: 49mm;
        left: -4mm;
        width: 36mm;
        height: 47mm;
        border-right: 0.2mm solid black;
    }

    div#qr_seri_no {
        position: absolute;
        top: 1mm;
        left: 4mm;
    }
    p#seri_no_text {
        position: absolute;
        top: 1mm;
        left: 2mm;
        z-index: 999;
        width: 100%;
        text-align: center;
    }

    #product_feature table {
        width:100%;
    }

    div#metre_info {
        left: 1mm;
        top: 29mm;
        width: 100%;
    }

    div#metre_info p {
        font-size: 36px;
        text-align: center;
    }

    div#metre_info small {
        text-align: center;
        display: block;
        font-size: 20px;
        line-height: 3mm;
    }

    #product_feature table td {
        font-size: 16px;
        border-bottom: 0.2mm solid black;
        height: 14mm;
    }

    div#product_feature {
        top: 2mm;
        left: 2mm;
        width: 78mm;
        height: 26mm;
        z-index: 999;
    }

    div#qr_det {
        position: absolute;
        right: 0mm;
        top: 0mm;
    }

    div#firm_info {
        position: absolute;
        top: 49mm;
        left: 35mm;
        width: 92mm;
        height: 40mm;
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
    }

</style>
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
		SHP.SHIP_DATE
	FROM 
		workcube_devcatalyst_1.SERVICE_GUARANTY_NEW SGN
		LEFT JOIN  workcube_devcatalyst_1.STOCKS S ON SGN.STOCK_ID = S.STOCK_ID
		LEFT JOIN workcube_devcatalyst_1.PRODUCT_CAT PC ON S.PRODUCT_CATID = PC.PRODUCT_CATID 
		LEFT JOIN workcube_devcatalyst_2020_1.SHIP SHP ON SGN.PROCESS_ID = SHP.SHIP_ID
	WHERE
		SGN.PROCESS_ID = #attributes.action_id# AND
		SGN.PROCESS_CAT = #attributes.action_type# AND
		SGN.PERIOD_ID = #session.ep.period_id# 
	ORDER BY 
		SGN.SERIAL_NO DESC
</cfquery>

<cfloop from="1" to="#get_serials.recordcount#" index="i">
    <div class="printableArea">
        <cfoutput>    
            <div id="product_feature">
                <table border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td>#get_serials.STOCK_CODE[i]#</td>
                    </tr>
                    <tr>
                        <td>#get_serials.PRODUCT_NAME[i]#</td>
                    </tr>
                    <tr>
                        <td>#get_serials.PRODUCT_CAT[i]#<br><small>#get_serials.HIERARCHY[i]#</small></td>
                    </tr>
                </table>
            </div>
            <div id="qr_det"> 
                <cf_workcube_barcode show="1" type="qrcode" width="190" height="190" value=" STOCK_CODE:#get_serials.STOCK_CODE[i]#;PRODUCT_NAME:#get_serials.PRODUCT_NAME[i]#;BARCOD:#get_serials.BARCOD[i]#;PRODUCT_CATID:#get_serials.PRODUCT_CATID[i]#;SHIP_NUMBER:#get_serials.SHIP_NUMBER[i]#;SHIP_DATE:#get_serials.SHIP_DATE[i]#">                     
            </div>
            <div id="qr_seri_container" class="bold">
                <p id="seri_no_text">#get_serials.SERIAL_NO[i]#</p>
                <div id="qr_seri_no">                    
                    <cf_workcube_barcode show="1" type="qrcode" width="120" height="120" value="#get_serials.SERIAL_NO[i]#">                     
                </div>
                <div id="metre_info">
                    <p>#get_serials.UNIT_ROW_QUANTITY[i]#</p>
                    <small>Metre</small>
                </div>      
            </div> 
            <div id="firm_info">
                <p id="f_name">Fabric Seri Lot Label</p>
                <div id="note"></div>
            </div>
        </cfoutput> 
    </div>
</cfloop>