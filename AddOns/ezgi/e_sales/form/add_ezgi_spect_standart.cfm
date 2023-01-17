<cfif not get_product.DESIGN_MAIN_ROW_ID gt 0>
	<script type="text/javascript">
		alert("Modül Bağlantısı Bulunamadı!");
		window.close()
	</script>
    <cfabort>
</cfif>
<cfparam name="attributes.measure_id" default="#get_product.MEASURE_ID#"> 
<cfquery name="get_image" datasource="#dsn3#">
	SELECT PATH FROM EZGI_DESIGN_MAIN_IMAGES WHERE DESIGN_MAIN_ROW_ID = #get_product.DESIGN_MAIN_ROW_ID#
</cfquery>
<cfquery name="get_measure" datasource="#dsn3#">
	SELECT        
    	ER.MEASURE, 
        ER.IS_STANDART, 
        ER.MEASURE_TYPE,
        ISNULL(ER.PRIVATE_RATE,0) AS PRIVATE_RATE, 
        ISNULL(ER.PRIVATE_PRICE,0) AS PRIVATE_PRICE, 
        ISNULL(ER.BIG_MEASURE,0) AS BIG_MEASURE, 
        ISNULL(ER.SMALL_MEASURE,0) AS SMALL_MEASURE, 
        ISNULL(ER.PRIVATE_MEASURE,0) AS PRIVATE_MEASURE,
        ISNULL(ER.PRIVATE2_MEASURE,0) AS PRIVATE2_MEASURE
	FROM            
  		EZGI_VIRTUAL_OFFER_ROW_MEASURE AS E INNER JOIN
      	EZGI_VIRTUAL_OFFER_ROW_MEASURE_ROW AS ER ON E.MEASURE_ID = ER.MEASURE_ID
	WHERE        
    	E.MEASURE_ID = #attributes.measure_id#
</cfquery>
<cfquery name="get_heights" dbtype="query">
	SELECT * FROM get_measure WHERE MEASURE_TYPE = 1 ORDER BY MEASURE
</cfquery>
<cfquery name="get_widths" dbtype="query">
	SELECT * FROM get_measure WHERE MEASURE_TYPE = 2 ORDER BY MEASURE
</cfquery>
<cfquery name="get_depths" dbtype="query">
	SELECT * FROM get_measure WHERE MEASURE_TYPE = 3 ORDER BY MEASURE
</cfquery>
<cfif not get_ROW.recordcount>
	<cfparam name="attributes.not_standart_rate" default="0">
	<cfparam name="attributes.hesapla" default="0">
    <cfparam name="attributes.height" default="#get_heights.measure#">
    <cfparam name="attributes.width" default="#get_widths.measure#">
    <cfparam name="attributes.depth" default="#get_depths.measure#">
    <cfparam name="attributes.side" default="1">
    <cfquery name="get_row" datasource="#dsn3#">
        SELECT        
        	EDP.PACKAGE_ROW_ID, 
            EDP.PACKAGE_NAME, 
            EDP.PACKAGE_AMOUNT,
            EDP.PACKAGE_NUMBER,  
            EDPP.PIECE_RELATED_ID, 
            EDPP.PIECE_ROW_ID, 
            EDPP.PIECE_TYPE, 
            EDPP.PIECE_NAME, 
            EDPP.PIECE_AMOUNT, 
        	EDPT.QUESTION_ID, 
            EDPT.BOY_FORMUL, 
            EDPT.EN_FORMUL, 
            ISNULL(EDPT.IS_AMOUNT_CHANGE,0) AS IS_AMOUNT_CHANGE, 
            ISNULL(EDPT.IS_PRICE_CHANGE,0) IS_PRICE_CHANGE, 
            ISNULL(EDPT.PRIVATE_PRICE_TYPE,0) PRIVATE_PRICE_TYPE, 
            EDPT.AMOUNT_FORMUL,
            EDPT.PIECE_ROW_PROTOTIP_ID,
            ISNULL(EDPT.PRIVATE_PRICE,0) AS PRIVATE_PRICE,  
         	EDPT.PRIVATE_PRICE_MONEY
		FROM            
        	EZGI_DESIGN_PACKAGE AS EDP INNER JOIN
         	EZGI_DESIGN_PIECE AS EDPP ON EDP.PACKAGE_ROW_ID = EDPP.DESIGN_PACKAGE_ROW_ID LEFT OUTER JOIN
          	EZGI_DESIGN_PIECE_PROTOTIP AS EDPT ON EDPP.PIECE_ROW_ID = EDPT.PIECE_ROW_ID
		WHERE        
        	EDP.DESIGN_MAIN_ROW_ID = #get_product.DESIGN_MAIN_ROW_ID# AND 
            EDPP.PIECE_TYPE <> 3 <!---AND
            EDP.PACKAGE_PARTNER_ID IS NULL--->
		UNION ALL
		SELECT        
        	EDP.PACKAGE_ROW_ID, 
            EDP.PACKAGE_NAME, 
            EDP.PACKAGE_AMOUNT, 
            EDP.PACKAGE_NUMBER, 
            EDPRR.PIECE_RELATED_ID, 
            EDPRR.PIECE_ROW_ID, 
            EDPRR.PIECE_TYPE, 
            EDPRR.PIECE_NAME, 
            EDPRR.PIECE_AMOUNT, 
   			EDPT.QUESTION_ID, 
            EDPT.BOY_FORMUL, 
            EDPT.EN_FORMUL, 
            ISNULL(EDPT.IS_AMOUNT_CHANGE,0) AS IS_AMOUNT_CHANGE, 
            ISNULL(EDPT.IS_PRICE_CHANGE,0) IS_PRICE_CHANGE, 
            ISNULL(EDPT.PRIVATE_PRICE_TYPE,0) PRIVATE_PRICE_TYPE, 
            EDPT.AMOUNT_FORMUL,
            EDPT.PIECE_ROW_PROTOTIP_ID,
            ISNULL(EDPT.PRIVATE_PRICE,0) AS PRIVATE_PRICE, 
         	EDPT.PRIVATE_PRICE_MONEY
		FROM            
        	EZGI_DESIGN_PACKAGE AS EDP INNER JOIN
         	EZGI_DESIGN_PIECE AS EDPP ON EDP.PACKAGE_ROW_ID = EDPP.DESIGN_PACKAGE_ROW_ID INNER JOIN
          	EZGI_DESIGN_PIECE_ROW AS EDPR ON EDPP.PIECE_ROW_ID = EDPR.PIECE_ROW_ID INNER JOIN
          	EZGI_DESIGN_PIECE_ROWS AS EDPRR ON EDPR.RELATED_PIECE_ROW_ID = EDPRR.PIECE_ROW_ID LEFT OUTER JOIN
         	EZGI_DESIGN_PIECE_PROTOTIP AS EDPT ON EDPRR.PIECE_ROW_ID = EDPT.PIECE_ROW_ID
		WHERE        
        	EDP.DESIGN_MAIN_ROW_ID = #get_product.DESIGN_MAIN_ROW_ID# AND 
            EDPP.PIECE_TYPE = 3 <!---AND
            EDP.PACKAGE_PARTNER_ID IS NULL--->
		ORDER BY 
        	EDP.PACKAGE_ROW_ID
	</cfquery>
    <!---<cfdump var="#get_row#">--->
    <cfquery name="get_row" dbtype="query">
        SELECT * FROM GET_ROW WHERE NOT (PIECE_ROW_PROTOTIP_ID IS NULL) order by PACKAGE_NUMBER
    </cfquery>
    <cfquery name="GET_MAIN_ROW" datasource="#DSN3#">
        SELECT 
        	DESIGN_MAIN_NAME, 
            DESIGN_MAIN_RELATED_ID,
            ISNULL(PRIVATE_PRICE_TYPE,0) PRIVATE_PRICE_TYPE, 
            ISNULL(PRIVATE_PRICE,0) AS PRIVATE_PRICE, 
         	PRIVATE_PRICE_MONEY
       	FROM 
        	EZGI_DESIGN_MAIN_ROW 
       	WHERE 
        	DESIGN_MAIN_ROW_ID = #get_product.DESIGN_MAIN_ROW_ID#
    </cfquery>
    <cfif GET_MAIN_ROW.recordcount and len(GET_MAIN_ROW.DESIGN_MAIN_RELATED_ID)>
        <cfquery name="get_main_price" datasource="#dsn3#">
            SELECT 
                OFR.STOCK_ID,       
                ISNULL(OFR.SALES_PRICE,0) AS SALES_PRICE, 
                ISNULL(OFR.SALES_PRICE_MONEY,'#session.ep.money#') AS SALES_PRICE_MONEY,
                ISNULL(OFR.PURCHASE_PRICE,0) AS PURCHASE_PRICE,
                ISNULL(OFR.PURCHASE_PRICE_MONEY,'#session.ep.money#') AS PURCHASE_PRICE_MONEY,
                ISNULL(OFR.COST_PRICE,0) AS COST_PRICE,
                ISNULL(OFR.COST_PRICE_MONEY,'#session.ep.money#') AS COST_PRICE_MONEY
            FROM
                EZGI_VIRTUAL_OFFER_PRICE_ROW AS OFR INNER JOIN
                EZGI_VIRTUAL_OFFER_PRICE_LIST AS OFL ON OFR.PRICE_CAT_ID = OFL.PRICE_CAT_ID
            WHERE        
                OFR.PRICE_CAT_ID = 1 AND 
                OFL.STATUS = 1 AND 
                OFR.STOCK_ID IN (#GET_MAIN_ROW.DESIGN_MAIN_RELATED_ID#)
        </cfquery>
  	</cfif>
<cfelse>
    <cfparam name="attributes.hesapla" default="1">
    <cfparam name="attributes.height" default="#get_product.BOY#">
    <cfparam name="attributes.width" default="#get_product.EN#">
    <cfparam name="attributes.depth" default="#get_product.DERINLIK#">
    <cfparam name="attributes.side" default="#get_product.YON#">
    <cfquery name="GET_MAIN_ROW" dbtype="query">
        SELECT 
        	PIECE_NAME AS DESIGN_MAIN_NAME, 
            STOCK_ID AS DESIGN_MAIN_RELATED_ID ,
            PRIVATE_PRICE_TYPE, 
            PRIVATE_PRICE, 
         	PRIVATE_PRICE_MONEY
      	FROM 
        	get_row
       	WHERE 
        	PIECE_TYPE = 0
    </cfquery>
    <cfquery name="get_main_price" dbtype="query">
     	SELECT 
        	STOCK_ID,       
         	SALES_PRICE, 
         	SALES_PRICE_MONEY,
        	PURCHASE_PRICE,
        	PURCHASE_PRICE_MONEY,
        	COST_PRICE,
         	COST_PRICE_MONEY
      	FROM 
        	get_row
     	WHERE    
        	PIECE_TYPE = 0    
 	</cfquery>
    <cfquery name="get_row" dbtype="query">
        SELECT * FROM GET_ROW WHERE PIECE_TYPE <> 0 
    </cfquery>
    <cfparam name="attributes.not_standart_rate" default="#get_row.not_standart_rate#">
    <cfif not isdefined('is_form_submitted')>
		<cfoutput query="get_row">
            <cfset 'attributes.alternative_stock_id_#PIECE_TYPE#_#PIECE_ROW_ID#' = STOCK_ID>
        </cfoutput>
    </cfif>
</cfif>
<cfset height = attributes.height>
<cfset width = attributes.width>
<cfset depth = attributes.depth>
<cfset side = attributes.side>
<!---Yükseklik İçin Ek Ölçüler Alınıyor--->
<cfquery name="get_heights_detail" dbtype="query">
	SELECT * FROM get_heights WHERE MEASURE = #height#
</cfquery>
<cfif not get_heights_detail.recordcount>
	<script type="text/javascript">
		alert("<cfoutput>#height#</cfoutput> Ölçüsüne Ait Kayıt Bulunamadı!");
		window.close()
	</script>
    <cfabort>
<cfelseif get_heights_detail.recordcount gt 1>
	<script type="text/javascript">


		alert("<cfoutput>#height#</cfoutput> Ölçüsüne Ait Birden Fazla Kayıt Bulundu!");
		window.close()
	</script>
    <cfabort>
<cfelse>
	<cfset height1 = get_heights_detail.BIG_MEASURE>
    <cfset height2 = get_heights_detail.SMALL_MEASURE>
    <cfset height3 = get_heights_detail.PRIVATE_MEASURE>
    <cfset height4 = get_heights_detail.PRIVATE2_MEASURE>
    <!---<cfset height_private_rate = get_heights_detail.PRIVATE_RATE>
    <cfset height_private_price = get_heights_detail.PRIVATE_PRICE>--->
    <cfif get_heights_detail.IS_STANDART eq 0>
    	<cfset height_is_standart = 0>
   	<cfelse>
    	<cfset height_is_standart = 1>
    </cfif>
</cfif>
<!---Genişlik İçin Ek Ölçüler Alınıyor--->
<cfquery name="get_widths_detail" dbtype="query">
	SELECT * FROM get_widths WHERE MEASURE = #width#
</cfquery>
<cfif not get_widths_detail.recordcount>
	<script type="text/javascript">
		alert("<cfoutput>#width#</cfoutput> Ölçüsüne Ait Kayıt Bulunamadı!");
		window.close()
	</script>
    <cfabort>
<cfelseif get_widths_detail.recordcount gt 1>
	<script type="text/javascript">
		alert("<cfoutput>#width#</cfoutput> Ölçüsüne Ait Birden Fazla Kayıt Bulundu!");
		window.close()
	</script>
    <cfabort>
<cfelse>
	<cfset width1 = get_widths_detail.BIG_MEASURE>
    <cfset width2 = get_widths_detail.SMALL_MEASURE>
    <cfset width3 = get_widths_detail.PRIVATE_MEASURE>
    <cfset width4 = get_widths_detail.PRIVATE2_MEASURE>
    <!---<cfset width_private_rate = get_heights_detail.PRIVATE_RATE>
    <cfset width_private_price = get_heights_detail.PRIVATE_PRICE>--->
    <cfif get_widths_detail.IS_STANDART eq 0>
    	<cfset width_is_standart = 0>
   	<cfelse>
    	<cfset width_is_standart = 1>
    </cfif>
</cfif>
<!---Derinlik İçin Ek Ölçüler Alınıyor--->
<cfquery name="get_depths_detail" dbtype="query">
	SELECT * FROM get_depths WHERE MEASURE = #depth#
</cfquery>
<cfif not get_depths_detail.recordcount>
	<script type="text/javascript">
		alert("<cfoutput>#depth#</cfoutput> Ölçüsüne Ait Kayıt Bulunamadı!");
		window.close()
	</script>
    <cfabort>
<cfelseif get_depths_detail.recordcount gt 1>
	<script type="text/javascript">
		alert("<cfoutput>#depth#</cfoutput> Ölçüsüne Ait Birden Fazla Kayıt Bulundu!");
		window.close()
	</script>
    <cfabort>
<cfelse>
	<cfset depth1 = get_depths_detail.BIG_MEASURE>
    <cfset depth2 = get_depths_detail.SMALL_MEASURE>
    <cfset depth3 = get_depths_detail.PRIVATE_MEASURE>
    <cfset depth4 = get_depths_detail.PRIVATE2_MEASURE>
    <!---<cfset depth_private_rate = get_heights_detail.PRIVATE_RATE>
    <cfset depth_private_price = get_heights_detail.PRIVATE_PRICE>--->
    <cfif get_depths_detail.IS_STANDART eq 0>
    	<cfset depth_is_standart = 0>
   	<cfelse>
    	<cfset depth_is_standart = 1>
    </cfif>
</cfif>

<cfquery name="get_row_4" dbtype="query">
	SELECT * FROM GET_ROW WHERE NOT (PIECE_ROW_PROTOTIP_ID IS NULL) AND PIECE_TYPE = 4
</cfquery>
<cfset piece_id_list_4 = ValueList(get_row_4.PIECE_ROW_ID)>

<cfquery name="get_row_1" dbtype="query">
	SELECT * FROM GET_ROW WHERE NOT (PIECE_ROW_PROTOTIP_ID IS NULL) AND PIECE_TYPE <> 4
</cfquery>
<cfset piece_id_list_1 = ValueList(get_row_1.PIECE_ROW_ID)>
<cfquery name="get_questions_id" dbtype="query">
	SELECT QUESTION_ID FROM get_row_1 WHERE NOT(QUESTION_ID IS NULL)
    UNION ALL
    SELECT QUESTION_ID FROM get_row_4 WHERE NOT(QUESTION_ID IS NULL)
</cfquery>
<cfset question_id_list = ValueList(get_questions_id.QUESTION_ID)>
<cfif ListLen(question_id_list)>
	<cfquery name="get_questions" datasource="#dsn#">
    	SELECT QUESTION_ID, QUESTION_NAME FROM SETUP_ALTERNATIVE_QUESTIONS WHERE QUESTION_ID IN (#question_id_list#)
    </cfquery>
    <cfoutput query="get_questions">
    	<cfset 'QUESTION_NAME_#QUESTION_ID#' = QUESTION_NAME>
    </cfoutput>
</cfif>
<cfif ListLen(piece_id_list_4)>
	<cfquery name="GET_ALTERNATIVE_4" datasource="#DSN3#">
            SELECT        
                AB.PIECE_ROW_ID, 
                AB.ALTERNATIVE_STOCK_ID, 
                AB.ALTERNATIVE_AMOUNT_FORMUL, 
                AB.ALTERNATIVE_AMOUNT, 
                S.PRODUCT_NAME, 
                EDP.PIECE_TYPE
            FROM            
                EZGI_DESIGN_PIECE_PROTOTIP_ALTERNATIVE AS AB INNER JOIN
                EZGI_DESIGN_PIECE_ROWS AS EDP ON AB.PIECE_ROW_ID = EDP.PIECE_ROW_ID INNER JOIN
                STOCKS AS S ON AB.ALTERNATIVE_STOCK_ID = S.STOCK_ID
            WHERE        
                AB.PIECE_ROW_ID IN (#piece_id_list_4#) AND 
                EDP.PIECE_TYPE = 4 AND 
                S.PRODUCT_STATUS = 1
            UNION ALL
            SELECT        
            	E.PIECE_ROW_ID, 
                AP.STOCK_ID AS ALTERNATIVE_STOCK_ID, 
                '' AS ALTERNATIVE_AMOUNT_FORMUL, 
                ISNULL(AP.ALTERNATIVE_PRODUCT_AMOUNT, 1) AS ALTERNATIVE_AMOUNT, 
                S1.PRODUCT_NAME, 
            	4 AS PIECE_TYPE
			FROM            
            	ALTERNATIVE_PRODUCTS AS AP INNER JOIN
           		STOCKS AS S ON AP.PRODUCT_ID = S.PRODUCT_ID INNER JOIN
             	STOCKS AS S1 ON AP.STOCK_ID = S1.STOCK_ID INNER JOIN
          		EZGI_DESIGN_PIECE_ROWS AS E ON S.STOCK_ID = E.PIECE_RELATED_ID
            WHERE        
                E.PIECE_ROW_ID IN (#piece_id_list_4#) AND 
                AP.TREE_STOCK_ID IS NULL
   	</cfquery>
    <!---<cfdump var="#GET_ALTERNATIVE_4#">--->
    <cfset alternative_stock_id_list_4 = ValueList(GET_ALTERNATIVE_4.ALTERNATIVE_STOCK_ID)>
    <cfif ListLen(alternative_stock_id_list_4)>
        <cfquery name="get_price" datasource="#dsn3#">
            SELECT 
                OFR.STOCK_ID,       
                OFR.SALES_PRICE, 
                OFR.SALES_PRICE_MONEY,
                OFR.PURCHASE_PRICE,
                OFR.PURCHASE_PRICE_MONEY,
                OFR.COST_PRICE,
                OFR.COST_PRICE_MONEY
            FROM
                EZGI_VIRTUAL_OFFER_PRICE_ROW AS OFR INNER JOIN
                EZGI_VIRTUAL_OFFER_PRICE_LIST AS OFL ON OFR.PRICE_CAT_ID = OFL.PRICE_CAT_ID
            WHERE        
                OFR.PRICE_CAT_ID = 1 AND 
                OFL.STATUS = 1 AND 
                OFR.STOCK_ID IN (#alternative_stock_id_list_4#)
        </cfquery>
        <!---<cfdump var="#get_price#">--->
        <cfoutput query="get_price">
            <cfset 'SALES_PRICE_4_#STOCK_ID#' = SALES_PRICE>
            <cfset 'SALES_PRICE_MONEY_4_#STOCK_ID#' = SALES_PRICE_MONEY>
            <cfset 'PURCHASE_PRICE_4_#STOCK_ID#' = PURCHASE_PRICE>
            <cfset 'PURCHASE_PRICE_MONEY_4_#STOCK_ID#' = PURCHASE_PRICE_MONEY>
            <cfset 'COST_PRICE_4_#STOCK_ID#' = COST_PRICE>
            <cfset 'COST_PRICE_MONEY_4_#STOCK_ID#' = COST_PRICE_MONEY>
        </cfoutput>
    </cfif>
</cfif>
<cfif ListLen(piece_id_list_1)>
	<cfquery name="GET_ALTERNATIVE_1" datasource="#DSN3#">
    	SELECT        
        	AB.PIECE_ROW_ID, 
            AB.ALTERNATIVE_STOCK_ID,
            AB.ALTERNATIVE_AMOUNT_FORMUL, 
            AB.ALTERNATIVE_AMOUNT, 
            EDP.PIECE_TYPE, 
            AB.ALTERNATIVE_PIECE_ROW_ID, 
            ED.PIECE_NAME
		FROM            
     		EZGI_DESIGN_PIECE_PROTOTIP_ALTERNATIVE AS AB INNER JOIN
          	EZGI_DESIGN_PIECE_ROWS AS EDP ON AB.PIECE_ROW_ID = EDP.PIECE_ROW_ID INNER JOIN
          	EZGI_DESIGN_PIECE_ROWS AS ED ON AB.ALTERNATIVE_PIECE_ROW_ID = ED.PIECE_ROW_ID
		WHERE        
        	AB.PIECE_ROW_ID IN (#piece_id_list_1#) AND 
            EDP.PIECE_TYPE <> 4
   	</cfquery>
    <!---<cfdump var="#GET_ALTERNATIVE_1#">--->
    <cfset alternative_piece_id_list_1 = ValueList(GET_ALTERNATIVE_1.ALTERNATIVE_PIECE_ROW_ID)>
    <cfif ListLen(alternative_piece_id_list_1)>
        <cfquery name="get_price_1" datasource="#dsn3#">
            SELECT 
            	OFR.PIECE_ROW_ID,
                OFR.SALES_PRICE, 
                OFR.SALES_PRICE_MONEY,
                OFR.PURCHASE_PRICE,
                OFR.PURCHASE_PRICE_MONEY,
                OFR.COST_PRICE,
                OFR.COST_PRICE_MONEY,
                (SELECT PIECE_TYPE FROM EZGI_DESIGN_PIECE_ROWS WHERE PIECE_ROW_ID = OFR.PIECE_ROW_ID) as PIECE_TYPE
            FROM
                EZGI_VIRTUAL_OFFER_PRICE_ROW AS OFR INNER JOIN
                EZGI_VIRTUAL_OFFER_PRICE_LIST AS OFL ON OFR.PRICE_CAT_ID = OFL.PRICE_CAT_ID
            WHERE        
                OFR.PRICE_CAT_ID = 1 AND 
                OFL.STATUS = 1 AND 
                OFR.PIECE_ROW_ID IN (#alternative_piece_id_list_1#)
        </cfquery>
        <!---<cfdump var="#get_price_1#">--->
        <cfoutput query="get_price_1">
            <cfset 'SALES_PRICE_#PIECE_TYPE#_#PIECE_ROW_ID#' = SALES_PRICE>
            <cfset 'SALES_PRICE_MONEY_#PIECE_TYPE#_#PIECE_ROW_ID#' = SALES_PRICE_MONEY>
            <cfset 'PURCHASE_PRICE_#PIECE_TYPE#_#PIECE_ROW_ID#' = PURCHASE_PRICE>
            <cfset 'PURCHASE_PRICE_MONEY_#PIECE_TYPE#_#PIECE_ROW_ID#' = PURCHASE_PRICE_MONEY>
            <cfset 'COST_PRICE_#PIECE_TYPE#_#PIECE_ROW_ID#' = COST_PRICE>
            <cfset 'COST_PRICE_MONEY_#PIECE_TYPE#_#PIECE_ROW_ID#' = COST_PRICE_MONEY>
        </cfoutput>
  	</cfif>
</cfif>

<cf_popup_box title="#getLang('objects',1529)# - #get_product.PRODUCT_NAME#">
    <cfform name="addSpecAll" id="addSpecAll" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_virtual_offer_row_spect_aktar">
        <cfinput name="ezgi_id" value="#attributes.ezgi_id#" type="hidden">
        <cfinput name="is_form_submitted" value="1" type="hidden">
        <cfinput name="upd_standart" value="1" type="hidden">
        <cfif isdefined('attributes.revision')>
        	<cfinput type="hidden" name="revision" value="1">
        </cfif>
        <cfif isdefined('attributes.ezgi_kilit')>
        	<cfinput type="hidden" name="ezgi_kilit" value="1">
        </cfif>
        <cf_area width="400">
            <cfoutput>
                <table style="height:110px">
                    <tr>
                        <td style="height:20px; vertical-align:middle" colspan="2"></td>
                    </tr>
                </table>
            </cfoutput>
        </cf_area>
        <cf_area>
             <table>
                <tr>
                	<td style="height:20px; width:100px">Yön</td>
                   	<td style="width:100px">
                        	<select name="side" id="side" style="width:70px; height:20px" onChange="degisti();">
                            	<option value="1" <cfif attributes.side eq 1>selected</cfif>>Sağ</option>
                                <option value="2" <cfif attributes.side eq 2>selected</cfif>>Sol</option>
                                <option value="3" <cfif attributes.side eq 3>selected</cfif>>Dışa Sağ</option>
                                <option value="4" <cfif attributes.side eq 4>selected</cfif>>Dışa Sol</option>
                            </select>
                  	</td>
                    <td style="width:100px">Yükseklik (mm)</td>
                    <td style="width:100px">
                    	<select name="height" id="height" style="width:70px; height:20px; text-align:right" onChange="degisti(1);">
                        	<cfoutput query="get_heights">
                            	<option style="<cfif not IS_STANDART>color:red</cfif>" value="#measure#" <cfif attributes.height eq measure>selected</cfif>>#measure#</option>
                            </cfoutput>
                        </select>
                    </td>
                </tr>
                <tr>
                	<td colspan="2"></td>
                    <td>Genişlik (mm)</td>
                    <td>
                    	<select name="width" id="width" style="width:70px; height:20px; text-align:right" onChange="degisti(2);">
                        	<cfoutput query="get_widths">
                            	<option style="<cfif not IS_STANDART>color:red</cfif>" value="#measure#" <cfif attributes.width eq measure>selected</cfif>>#measure#</option>
                            </cfoutput>
                        </select>
                    </td>
                </tr>
                <tr>
                	<td colspan="2"></td>
                    <td>Derinlik (mm)</td>
                    <td>
                    	<select name="depth" id="depth" style="width:70px; height:20px; text-align:right" onChange="degisti(3);">
                        	<cfoutput query="get_depths">
                            	<option style="<cfif not IS_STANDART>color:red</cfif>" value="#measure#" <cfif attributes.depth eq measure>selected</cfif>>#measure#</option>
                            </cfoutput>
                        </select>
                    </td>
                </tr>
            </table>
        </cf_area>
        <cf_area>
        	<table>
                <tr>
                	<td style="height:70px; width:100px">
                    	<cfif len(get_image.PATH)>
                        	<cfoutput>
                    		<img src="/documents/product/#get_image.PATH#" style="height:160px; width:130px; vertical-align:middle">
                            </cfoutput>
                        </cfif>
                    </td>
              	</tr>
          	</table>
        </cf_area>
        <cf_area new_line="1">
            <br />
            <table style="width:100%;">
            	<tr>
                 	<td>
                     	<cf_medium_list>
                                <thead>
                                    <tr>
                                        <th style="width:30px"><cf_get_lang_main no='1165.Sıra'></th>
                                        <th style="width:100px"><cfoutput>#getLang('prod',141)#</cfoutput></th>
                                        <th><cf_get_lang_main no='809.Ürün Adı'></th>
                                        <th style="width:70px; text-align:center"><cfoutput>#getLang('stock',301)# <cf_get_lang_main no='2902.Boy'>-<cf_get_lang_main no='2901.En'><BR />(mm)</cfoutput></th>
                                        <th style="width:50px"><cf_get_lang_main no='223.Miktar'></th>
                                        <th style="width:50px"><cf_get_lang_main no='223.Miktar'>2</th>
                                        <th style="width:50px"><cf_get_lang_main no='672.Fiyat'></th>
                                        <th style="width:40px"><cf_get_lang_main no='265.Döviz'></th>
                                        <th style="width:50px"></th>
                                        <th style="width:50px"><cf_get_lang_main no='80.Toplam'></th>
                                        <th style="width:40px"><cf_get_lang_main no='265.Döviz'></th>
                                    </tr>
                                </thead>
                                <tbody>
                                	<cfset ozel_toplam = 0>
                                	<cfset toplam = 0>
                                    <cfset purchase_total = 0>
                                    <cfset cost_total = 0>
                                    <cfif GET_MAIN_ROW.recordcount>
                                    	<cfoutput>
                                            <tr>
                                                <td style="text-align:right; font-weight:bold">0</td>
                                                <td style="text-align:left; font-weight:bold">Ana Ürün</td>
                                                <td style="text-align:left; font-weight:bold" nowrap>#GET_MAIN_ROW.DESIGN_MAIN_NAME#</td>
                                                <td></td>
                                                <td style="text-align:right; font-weight:bold">#TlFormat(1,2)#</td>
                                                <td style="text-align:right; font-weight:bold">#TlFormat(1,2)#</td>
                                                <td style="text-align:right; font-weight:bold">
                                                    <cfif get_main_price.recordcount>
                                                        #TlFormat(get_main_price.SALES_PRICE,2)#
                                                    <cfelse>
                                                        <span style="color:red">
                                                            #TlFormat(0,2)#
                                                        </span>
                                                    </cfif>
                                                </td>
                                                <td style="text-align:left; font-weight:bold">
                                                    <cfif get_main_price.recordcount>
                                                        #get_main_price.SALES_PRICE_MONEY#
                                                    <cfelse>
                                                        <span style="color:red">
                                                            #session.ep.money#
                                                        </span>
                                                    </cfif>
                                                </td>
                                                <td style="text-align:right; color:red">
                                                	<cfif height_is_standart eq 0><!--- Ana Ürün Sadece Yükseklik Özel Ölçüde Devreye Giriyor--->
                                                    	<cfif GET_MAIN_ROW.PRIVATE_PRICE_TYPE eq 1>
                                                         	<cfif isdefined('RATE2_#GET_MAIN_ROW.PRIVATE_PRICE_MONEY#')>
                                                        		<cfset ozel_toplam = ozel_toplam+((GET_MAIN_ROW.PRIVATE_PRICE*Evaluate('RATE2_#GET_MAIN_ROW.PRIVATE_PRICE_MONEY#'))+(get_main_price.SALES_PRICE*Evaluate('RATE2_#GET_MAIN_ROW.PRIVATE_PRICE_MONEY#')))>
                                                                        #TlFormat((PRIVATE_PRICE*Evaluate('RATE2_#GET_MAIN_ROW.PRIVATE_PRICE_MONEY#'))+(get_main_price.SALES_PRICE*Evaluate('RATE2_#GET_MAIN_ROW.PRIVATE_PRICE_MONEY#')),2)#
                                                       		</cfif>
                                                      	<cfelseif GET_MAIN_ROW.PRIVATE_PRICE_TYPE eq 2>
                                                        	<cfif len(GET_MAIN_ROW.PRIVATE_PRICE)>
                                                      			<cfif isnumeric(get_main_price.SALES_PRICE)>
                                                      				<cfset ozel_toplam = ozel_toplam+((GET_MAIN_ROW.PRIVATE_PRICE/100)*get_main_price.SALES_PRICE)>
                                                                    #TlFormat((GET_MAIN_ROW.PRIVATE_PRICE/100)*get_main_price.SALES_PRICE,2)#
                                                                <cfelse>
                                                                	#TlFormat(0,2)#
                                                                </cfif>
                                                     		<cfelse>
                                                            	<script type="text/javascript">
																	alert("Dikkat : Özel Ölçü İçin Fark Fiyatı Girilmemiş.!");
																	window.close()
																</script>
                                                                <cfabort>
                                                            </cfif>
                                                     	</cfif>
                                                    </cfif>
                                                </td>
                                                <td style="text-align:right; font-weight:bold">
                                                    <cfif get_main_price.recordcount>
                                                        #TlFormat(get_main_price.SALES_PRICE,2)#
                                                        <cfset toplam = toplam+get_main_price.SALES_PRICE>
                                                        <cfset purchase_total = purchase_total+get_main_price.PURCHASE_PRICE>
                                                        <cfset cost_total = cost_total+get_main_price.COST_PRICE>
                                                    <cfelse>
                                                        #TlFormat(0,2)#
                                                    </cfif>
                                                </td>
                                                <td style="text-align:left; font-weight:bold">
                                                    #session.ep.money#
                                                </td>
                                            </tr>


                                            <cfinput type="hidden" name="stock_id_0" value="#GET_MAIN_ROW.DESIGN_MAIN_RELATED_ID#">
                                            <cfinput type="hidden" name="piece_row_id" value="0">
                                            <cfinput type="hidden" name="PIECE_AMOUNT_0" value="1">
                                            <cfinput type="hidden" name="piece_type_0" value="0">
                                            <cfinput type="hidden" name="IS_PRICE_CHANGE_0" value="0">
                                            <cfinput type="hidden" name="IS_AMOUNT_CHANGE_0" value="0">
                                            <cfinput type="hidden" name="QUESTION_ID_0" value="0">
                                            <cfinput type="hidden" name="BOY_FORMUL_0" value="">
                                            <cfinput type="hidden" name="EN_FORMUL_0" value="">
                                            <cfinput type="hidden" name="AMOUNT_FORMUL_0" value="1">
                                            
                                        	<cfinput type="hidden" name="sales_price_0" value="#get_main_price.SALES_PRICE#">
                                            <cfinput type="hidden" name="sales_price_money_0" value="#get_main_price.SALES_PRICE_MONEY#">
                                            <cfinput type="hidden" name="purchase_price_0" value="#get_main_price.PURCHASE_PRICE#">
                                            <cfinput type="hidden" name="purchase_price_money_0" value="#get_main_price.PURCHASE_PRICE_MONEY#">
                                            <cfinput type="hidden" name="cost_price_0" value="#get_main_price.COST_PRICE#">
                                            <cfinput type="hidden" name="cost_price_money_0" value="#get_main_price.COST_PRICE_MONEY#">
                                            <cfinput type="hidden" name="PRIVATE_PRICE_MONEY_0" value="#session.ep.money#">
                                         	<cfinput type="hidden" name="PRIVATE_PRICE_TYPE_0" value="#GET_MAIN_ROW.PRIVATE_PRICE_TYPE#">
                                           	<cfinput type="hidden" name="PRIVATE_PRICE_0" value="#GET_MAIN_ROW.PRIVATE_PRICE#">
                                        </cfoutput>
                                    </cfif>
                                    <!---<cfdump var="#get_row#">--->
                                    
                                	<cfif get_row.recordcount>
                                    	<cfset fuga = ''>
                                    	<cfoutput query="get_row">
                                        	
                                        	<cfinput type="hidden" name="piece_row_id" value="#piece_row_id#">
                                            <cfinput type="hidden" name="piece_type_#piece_row_id#" value="#piece_type#">
                                            <cfinput type="hidden" name="IS_PRICE_CHANGE_#piece_row_id#" value="#IS_PRICE_CHANGE#">
                                            <cfinput type="hidden" name="IS_AMOUNT_CHANGE_#piece_row_id#" value="#IS_AMOUNT_CHANGE#">
                                            <cfinput type="hidden" name="QUESTION_ID_#piece_row_id#" value="#QUESTION_ID#">
                                            <cfinput type="hidden" name="BOY_FORMUL_#piece_row_id#" value="#BOY_FORMUL#">
                                            <cfinput type="hidden" name="EN_FORMUL_#piece_row_id#" value="#EN_FORMUL#">
                                            <cfinput type="hidden" name="AMOUNT_FORMUL_#piece_row_id#" value="#AMOUNT_FORMUL#">
                                            
                                            <cfparam name="attributes.PIECE_AMOUNT_#PIECE_ROW_ID#" default="#TlFormat(get_row.piece_amount,2)#">
                                            <cfparam name="attributes.alternative_stock_id_#PIECE_TYPE#_#PIECE_ROW_ID#" default="0">
                                            <cfset quantity = Filternum(Evaluate('attributes.PIECE_AMOUNT_#PIECE_ROW_ID#'),2)>
                                            <cfset amount = Filternum(Evaluate('attributes.PIECE_AMOUNT_#PIECE_ROW_ID#'),2)>
                                            <cfif isdefined('Package_ROW_ID')>
												<cfif fuga neq Package_ROW_ID>
                                                    <cfset fuga = Package_ROW_ID>
                                                    <tr>
                                                        <td colspan="12"><hr /></td>
                                                    </tr>
                                                </cfif>
                                            </cfif>
                                        	<tr>
                                            	<td style="text-align:right">#currentrow#</td>
                                                <td style="text-align:left">
                                                	<cfif isdefined('QUESTION_NAME_#QUESTION_ID#')>
                                                		#Evaluate('QUESTION_NAME_#QUESTION_ID#')#
                                                	</cfif>
                                                </td>
                                                <td style="text-align:left">
                                                	<cfif isdefined('QUESTION_NAME_#QUESTION_ID#')>
														<cfif PIECE_TYPE eq 4>
                                                            <cfquery name="alternative_row" dbtype="query">
                                                                select * from GET_ALTERNATIVE_4 where PIECE_ROW_ID = #PIECE_ROW_ID# order by PRODUCT_NAME
                                                            </cfquery>
                                                            <select name="alternative_stock_id_4_#PIECE_ROW_ID#" id="alternative_stock_id_4_#PIECE_ROW_ID#" style="width:350px; height:20px" onChange="degisti();">
                                                                <option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                                                                <cfloop query="alternative_row">
                                                                    <option value="#ALTERNATIVE_STOCK_ID#" <cfif isdefined('attributes.alternative_stock_id_4_#PIECE_ROW_ID#') and Evaluate('attributes.alternative_stock_id_4_#PIECE_ROW_ID#') eq ALTERNATIVE_STOCK_ID>selected style="font-weight:bold"</cfif>>#PRODUCT_NAME#</option>
                                                                </cfloop>
                                                            </select>
                                                        <cfelse>
                                                            <cfquery name="alternative_row" dbtype="query">
                                                                select * from GET_ALTERNATIVE_1 where PIECE_ROW_ID = #PIECE_ROW_ID# order by PIECE_NAME
                                                            </cfquery>
                                                            <!---<cfdump var="#alternative_row#">--->
                                                            <select name="alternative_stock_id_#PIECE_TYPE#_#PIECE_ROW_ID#" id="alternative_stock_id_#PIECE_TYPE#_#PIECE_ROW_ID#" style="width:350px; height:20px" onChange="degisti();">
                                                                <option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                                                                <cfloop query="alternative_row">
                                                                    <option value="#ALTERNATIVE_PIECE_ROW_ID#" <cfif isdefined('attributes.alternative_stock_id_#PIECE_TYPE#_#PIECE_ROW_ID#') and Evaluate('attributes.alternative_stock_id_#PIECE_TYPE#_#PIECE_ROW_ID#') eq ALTERNATIVE_PIECE_ROW_ID>selected style="font-weight:bold"</cfif>>#PIECE_NAME#</option>
                                                                </cfloop>
                                                            </select>
                                                        </cfif>
                                                    <cfelse>
                                                    	#PIECE_NAME#
                                                    </cfif>
                                                </td>
                                                <td style="text-align:center">
                                                	<cfif len(boy_formul)>
                                                    	<cfset boy = Evaluate('#boy_formul#')>
                                                    	<input name="boy_#PIECE_ROW_ID#" type="text" id="boy_#PIECE_ROW_ID#" title="#boy_formul#" value="#boy#" style="width:40px; height:20px; text-align:right" onChange="degisti();">
                                                    </cfif>
                                                	<cfif len(en_formul)>
                                                    	<cfset en = Evaluate('#en_formul#')>
                                                    	<input name="en_#PIECE_ROW_ID#" type="text" id="en_#PIECE_ROW_ID#" title="#en_formul#" value="#en#" style="width:40px; height:20px; text-align:right" onChange="degisti();">
                                                    </cfif>
                                                </td>
                                                <td style="text-align:right">
                                                	<input type="text" name="piece_amount_#PIECE_ROW_ID#" id="piece_amount_#PIECE_ROW_ID#" value="#TlFormat(quantity)#" style="text-align:right; width:50px; height:20px" onChange="degisti();" <cfif IS_AMOUNT_CHANGE eq 0>readonly</cfif>>
                                                
                                                </td>
                                                
                                                <td style="text-align:right" title="#Evaluate('amount_formul')#">
                                                	<cfif len(amount_formul)>
                                                    	<cftry>
                                                    		<cfset amount2 = Evaluate('#amount_formul#')>
                                                        	<cfcatch type="Any">
																	<cfoutput>BBBB#amount_formul#</cfoutput>
                                                                <cfabort>
                                                            </cfcatch>
                                                        </cftry>
                                                    	<input name="amount2_#PIECE_ROW_ID#" type="text" id="amount2_#PIECE_ROW_ID#" value="#TlFormat(amount2)#" style="width:50px; height:20px; text-align:right" onChange="degisti();">
                                                    </cfif>
                                                </td>
                                                <td style="text-align:right">
                                                	<cfif isdefined('QUESTION_NAME_#QUESTION_ID#') and IS_PRICE_CHANGE eq 0>
														<cfif PIECE_TYPE eq 4>
                                                            <cfif isdefined("SALES_PRICE_4_#Evaluate('attributes.alternative_stock_id_4_#PIECE_ROW_ID#')#")>
                                                                #TlFormat(Evaluate("SALES_PRICE_4_#Evaluate('attributes.alternative_stock_id_4_#PIECE_ROW_ID#')#"),2)#
                                                                <cfset sales_price_row = Evaluate("SALES_PRICE_4_#Evaluate('attributes.alternative_stock_id_4_#PIECE_ROW_ID#')#")>
                                                                <cfset purchase_price = Evaluate("PURCHASE_PRICE_4_#Evaluate('attributes.alternative_stock_id_4_#PIECE_ROW_ID#')#")>
                                                                <cfset cost_price = Evaluate("COST_PRICE_4_#Evaluate('attributes.alternative_stock_id_4_#PIECE_ROW_ID#')#")>
                                                                
                                                            <cfelse>
                                                                <span style="color:red">
                                                                    #TlFormat(0,2)#
                                                                </span>
                                                                <cfset sales_price_row = 0>
                                                                <cfset purchase_price = 0>
                                                                <cfset cost_price = 0>
                                                            </cfif>
                                                        <cfelse>
                                                            <cfif isdefined("SALES_PRICE_#PIECE_TYPE#_#Evaluate('attributes.alternative_stock_id_#PIECE_TYPE#_#PIECE_ROW_ID#')#")>
                                                                #TlFormat(Evaluate("SALES_PRICE_#PIECE_TYPE#_#Evaluate('attributes.alternative_stock_id_#PIECE_TYPE#_#PIECE_ROW_ID#')#"),2)#
                                                                <cfset sales_price_row = Evaluate("SALES_PRICE_#PIECE_TYPE#_#Evaluate('attributes.alternative_stock_id_#PIECE_TYPE#_#PIECE_ROW_ID#')#")>
                                                                <cfset purchase_price = Evaluate("PURCHASE_PRICE_#PIECE_TYPE#_#Evaluate('attributes.alternative_stock_id_#PIECE_TYPE#_#PIECE_ROW_ID#')#")>
                                                                <cfset cost_price = Evaluate("COST_PRICE_#PIECE_TYPE#_#Evaluate('attributes.alternative_stock_id_#PIECE_TYPE#_#PIECE_ROW_ID#')#")>
                                                            <cfelse>
                                                                <span style="color:red">
                                                                    #TlFormat(0,2)#
                                                                </span>
                                                                <cfset sales_price_row = 0>
                                                                <cfset purchase_price = 0>
                                                                <cfset cost_price = 0>
                                                            </cfif>
                                                        </cfif>
                                                    <cfelse>
                                                    	#TlFormat(0,2)#
                                                		<cfset sales_price_row = 0>
                                                      	<cfset purchase_price = 0>
                                                      	<cfset cost_price = 0>
                                                    </cfif>
                                               	</td>
                                                <td style="text-align:left">
                                                	<cfif isdefined('QUESTION_NAME_#QUESTION_ID#')>
														<cfif PIECE_TYPE eq 4>
                                                            <cfif isdefined("SALES_PRICE_MONEY_4_#Evaluate('attributes.alternative_stock_id_4_#PIECE_ROW_ID#')#")>
                                                                #Evaluate("SALES_PRICE_MONEY_4_#Evaluate('attributes.alternative_stock_id_4_#PIECE_ROW_ID#')#")#
                                                                <cfset sales_PRICE_ROW_MONEY = Evaluate("SALES_PRICE_MONEY_4_#Evaluate('attributes.alternative_stock_id_4_#PIECE_ROW_ID#')#")>
                                                                <cfset purchase_PRICE_MONEY = Evaluate("PURCHASE_PRICE_MONEY_4_#Evaluate('attributes.alternative_stock_id_4_#PIECE_ROW_ID#')#")>
                                                                <cfset cost_PRICE_MONEY = Evaluate("COST_PRICE_MONEY_4_#Evaluate('attributes.alternative_stock_id_4_#PIECE_ROW_ID#')#")>
                                                            <cfelse>
                                                                <span style="color:red">
                                                                    #session.ep.money#
                                                                </span>
                                                                <cfset sales_PRICE_ROW_MONEY = session.ep.money>
                                                                <cfset purchase_PRICE_MONEY = session.ep.money>
                                                                <cfset cost_PRICE_MONEY = session.ep.money>
                                                            </cfif>
                                                        <cfelse>
                                                            <cfif isdefined("SALES_PRICE_MONEY_#PIECE_TYPE#_#Evaluate('attributes.alternative_stock_id_#PIECE_TYPE#_#PIECE_ROW_ID#')#")>
                                                                #Evaluate("SALES_PRICE_MONEY_#PIECE_TYPE#_#Evaluate('attributes.alternative_stock_id_#PIECE_TYPE#_#PIECE_ROW_ID#')#")#
                                                                <cfset sales_PRICE_ROW_MONEY = Evaluate("SALES_PRICE_MONEY_#PIECE_TYPE#_#Evaluate('attributes.alternative_stock_id_#PIECE_TYPE#_#PIECE_ROW_ID#')#")>
                                                                <cfset purchase_PRICE_MONEY = Evaluate("PURCHASE_PRICE_MONEY_#PIECE_TYPE#_#Evaluate('attributes.alternative_stock_id_#PIECE_TYPE#_#PIECE_ROW_ID#')#")>
                                                                <cfset cost_PRICE_MONEY = Evaluate("COST_PRICE_MONEY_#PIECE_TYPE#_#Evaluate('attributes.alternative_stock_id_#PIECE_TYPE#_#PIECE_ROW_ID#')#")>
                                                            <cfelse>
                                                                <span style="color:red">
                                                                    #session.ep.money#
                                                                </span>
                                                                <cfset sales_PRICE_ROW_MONEY = session.ep.money>
                                                                <cfset purchase_PRICE_MONEY = session.ep.money>
                                                                <cfset cost_PRICE_MONEY = session.ep.money>
                                                            </cfif>
                                                        </cfif>
                                                    <cfelse>
                                                    	#session.ep.money#
                                                		<cfset sales_PRICE_ROW_MONEY = session.ep.money>
                                                      	<cfset purchase_PRICE_MONEY = session.ep.money>
                                                      	<cfset cost_PRICE_MONEY = session.ep.money>
                                                    </cfif>
                                                </td>
                                                <td style="text-align:right; color:red">
                                                <cfif height_is_standart eq 0>
                                                	<cfif PIECE_TYPE eq 4>
                                                    	<cfif len(amount_formul)>
                                                    		<cfif find('HEIGHT',#amount_formul#)>
                                                            	<cfif PRIVATE_PRICE_TYPE eq 1>
                                                                	<cfif isdefined('RATE2_#sales_price_row_money#')>
                                                        				<cfset ozel_toplam = ozel_toplam+((PRIVATE_PRICE*Evaluate('RATE2_#sales_price_row_money#'))+(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')))>
                                                                        #TlFormat((PRIVATE_PRICE*Evaluate('RATE2_#sales_price_row_money#'))+(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')),2)#
                                                                  	</cfif>
                                                                <cfelseif PRIVATE_PRICE_TYPE eq 2>
                                                                	<cfif isdefined('RATE2_#sales_price_row_money#')>
                                                        				<cfset ozel_toplam = ozel_toplam+((PRIVATE_PRICE/100)*(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')))>
                                                                        #TlFormat((PRIVATE_PRICE/100)*(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')),2)#
                                                                   	</cfif>
                                                                </cfif>
                                                           	<cfelseif find('WEIGHT',#amount_formul#)> 
                                                            	<cfif PRIVATE_PRICE_TYPE eq 1>
                                                                	<cfif isdefined('RATE2_#sales_price_row_money#')>
                                                        				<cfset ozel_toplam = ozel_toplam+((PRIVATE_PRICE*Evaluate('RATE2_#sales_price_row_money#'))+(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')))>
                                                                        #TlFormat((PRIVATE_PRICE*Evaluate('RATE2_#sales_price_row_money#'))+(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')),2)#
                                                                  	</cfif>
                                                                <cfelseif PRIVATE_PRICE_TYPE eq 2>
                                                                	<cfif isdefined('RATE2_#sales_price_row_money#')>
                                                        				<cfset ozel_toplam = ozel_toplam+((PRIVATE_PRICE/100)*(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')))>
                                                                        #TlFormat((PRIVATE_PRICE/100)*(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')),2)#
                                                                   	</cfif>
                                                                </cfif>
                                                            <cfelseif find('DEPTH',#amount_formul#)>
                                                            	<cfif PRIVATE_PRICE_TYPE eq 1>
                                                                	<cfif isdefined('RATE2_#sales_price_row_money#')>
                                                        				<cfset ozel_toplam = ozel_toplam+((PRIVATE_PRICE*Evaluate('RATE2_#sales_price_row_money#'))+(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')))>
                                                                        #TlFormat((PRIVATE_PRICE*Evaluate('RATE2_#sales_price_row_money#'))+(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')),2)#
                                                                  	</cfif>
                                                                <cfelseif PRIVATE_PRICE_TYPE eq 2>
                                                                	<cfif isdefined('RATE2_#sales_price_row_money#')>
                                                        				<cfset ozel_toplam = ozel_toplam+((PRIVATE_PRICE/100)*(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')))>
                                                                        #TlFormat((PRIVATE_PRICE/100)*(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')),2)#
                                                                   	</cfif>
                                                                </cfif>
                                                            </cfif>
                                                       	</cfif>
                                                    <cfelse>
                                                    	<cfif len(amount_formul)>
                                                    		<cfif find('HEIGHT',#boy_formul#)>
                                                            	<cfif PRIVATE_PRICE_TYPE eq 1>
                                                                	<cfif isdefined('RATE2_#sales_price_row_money#')>
                                                        				<cfset ozel_toplam = ozel_toplam+((PRIVATE_PRICE*Evaluate('RATE2_#sales_price_row_money#'))+(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')))>
                                                                        #TlFormat((PRIVATE_PRICE*Evaluate('RATE2_#sales_price_row_money#'))+(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')),2)#
                                                                  	</cfif>
                                                                <cfelseif PRIVATE_PRICE_TYPE eq 2>
                                                                	<cfif isdefined('RATE2_#sales_price_row_money#')>
                                                        				<cfset ozel_toplam = ozel_toplam+((PRIVATE_PRICE/100)*(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')))>
                                                                        #TlFormat((PRIVATE_PRICE/100)*(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')),2)#
                                                                   	</cfif>
                                                                </cfif>
                                                           	<cfelseif find('WEIGHT',#en_formul#)> 
                                                            	<cfif PRIVATE_PRICE_TYPE eq 1>
                                                                	<cfif isdefined('RATE2_#sales_price_row_money#')>
                                                        				<cfset ozel_toplam = ozel_toplam+((PRIVATE_PRICE*Evaluate('RATE2_#sales_price_row_money#'))+(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')))>
                                                                        #TlFormat((PRIVATE_PRICE*Evaluate('RATE2_#sales_price_row_money#'))+(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')),2)#
                                                                  	</cfif>
                                                                <cfelseif PRIVATE_PRICE_TYPE eq 2>
                                                                	<cfif isdefined('RATE2_#sales_price_row_money#')>
                                                        				<cfset ozel_toplam = ozel_toplam+((PRIVATE_PRICE/100)*(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')))>
                                                                        #TlFormat((PRIVATE_PRICE/100)*(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')),2)#
                                                                   	</cfif>
                                                                </cfif>
                                                            <cfelseif find('DEPTH',#en_formul#)>
                                                            	<cfif PRIVATE_PRICE_TYPE eq 1>
                                                                	<cfif isdefined('RATE2_#sales_price_row_money#')>
                                                        				<cfset ozel_toplam = ozel_toplam+((PRIVATE_PRICE*Evaluate('RATE2_#sales_price_row_money#'))+(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')))>
                                                                        #TlFormat((PRIVATE_PRICE*Evaluate('RATE2_#sales_price_row_money#'))+(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')),2)#
                                                                  	</cfif>
                                                                <cfelseif PRIVATE_PRICE_TYPE eq 2>
                                                                	<cfif isdefined('RATE2_#sales_price_row_money#')>
                                                        				<cfset ozel_toplam = ozel_toplam+((PRIVATE_PRICE/100)*(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')))>
                                                                        #TlFormat((PRIVATE_PRICE/100)*(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#')),2)#
                                                                        
                                                                   	</cfif>
                                                                </cfif>
                                                            </cfif>
                                                       	</cfif>
                                                    </cfif>
                                                </cfif>
                                                <cfinput type="hidden" name="PRIVATE_PRICE_MONEY_#piece_row_id#" value="#PRIVATE_PRICE_MONEY#">
                                                <cfinput type="hidden" name="PRIVATE_PRICE_TYPE_#piece_row_id#" value="#PRIVATE_PRICE_TYPE#">
                                                <cfinput type="hidden" name="PRIVATE_PRICE_#piece_row_id#" value="#PRIVATE_PRICE#">
                                                </td>
                                                <td style="text-align:right">
                                                	<cfif isdefined('RATE2_#sales_price_row_money#')>
                                                		#TlFormat(SALES_PRICE_row*amount2*Evaluate('RATE2_#sales_price_row_money#'),2)#
                                                        <cfset toplam = toplam+(sales_PRICE_ROW*amount2*Evaluate('RATE2_#sales_price_row_money#'))>
                                                        <cfset purchase_total = purchase_total+(purchase_price*amount2*Evaluate('RATE2_#purchase_PRICE_MONEY#'))>
                                                        <cfset cost_total = cost_total+(cost_price*amount2*Evaluate('RATE2_#cost_PRICE_MONEY#'))>
                                                   	<cfelse>
                                                    	<span style="color:red">
                                                    		#TlFormat(0,2)#
                                                        </span>
                                                    </cfif>
                                               	</td>
                                                <td style="text-align:left">#session.ep.money#</td>
                                                
                                            </tr>
                                            <cfinput type="hidden" name="sales_price_#piece_row_id#" value="#sales_PRICE_ROW#">
                                            <cfinput type="hidden" name="sales_price_money_#piece_row_id#" value="#sales_PRICE_ROW_money#">
                                            <cfinput type="hidden" name="purchase_price_#piece_row_id#" value="#purchase_price#">
                                            <cfinput type="hidden" name="purchase_price_money_#piece_row_id#" value="#purchase_price_money#">
                                            <cfinput type="hidden" name="cost_price_#piece_row_id#" value="#cost_price#">
                                            <cfinput type="hidden" name="cost_price_money_#piece_row_id#" value="#cost_price_money#">
                                        </cfoutput>
                                        <tr>
                                        	<cfoutput>
                                                <!---<cfinput type="hidden" name="not_standart_value" value="#toplam#">
                                                <cfinput type="hidden" name="not_standart_money" value="#session.ep.money#">--->
                                                <td colspan="7" style="text-align:left; color:red"><b>Özel Ürün Farkı</b></td>
                                                <td style="text-align:right">
                                                	<!---%<input type="text" name="not_standart_rate" id="not_standart_rate" value="#attributes.not_standart_rate#" readonly="readonly" style="width:25px" class="box" />--->
                                                </td>
                                                <td style="text-align:right; color:red"><b>#TlFormat(ozel_toplam,2)#</b></td>
                                                <td style="text-align:right">#TlFormat(toplam,2)#</td>
                                                <td style="text-align:left; color:red">#session.ep.money#</td>
                                            </cfoutput>
                                        </tr>
                                        <tr>
                                        	<cfoutput>
                                                <cfinput type="hidden" name="toplam" value="#ozel_toplam+toplam#">
                                              	<cfinput type="hidden" name="purchase_total" value="#ozel_toplam+purchase_total#">
                                              	<cfinput type="hidden" name="cost_total" value="#ozel_toplam+cost_total#">
                                                <cfinput type="hidden" name="money" value="#session.ep.money#">
                                                <td colspan="9"><b>Toplam</b></td>
                                                <td style="text-align:right"><b>#TlFormat(ozel_toplam+toplam,2)#</b></td>
                                                <td style="text-align:left">#session.ep.money#</td>
                                            </cfoutput>
                                        </tr>
                                    </cfif>
                         	</tbody>
                           	<tfoot>
                          		<tr>
                                	<td colspan="7" style="text-align:right; color:red; font-weight:bold; vertical-align:middle">
                                    	<cfif not isdefined('attributes.revision')>
                                            <span id="is_price_change_" <cfif not isdefined('attributes.is_form_submitted')>style="display:none"</cfif>>
                                                <input type="checkbox" name="is_price_change" id="is_price_change" value="1" checked><cf_get_lang_main no ='133.Teklif'> <cf_get_lang no ='1532.Fiyatı Güncelle'>
                                            </span>
                                        </cfif>
                                    </td>
                                 	<td colspan="4" style=" text-align:right">
                                 		<cfif get_product.is_prototip eq 1>
                                     		<cfif get_row.recordcount>
                                            	<span id="hesapla_" <cfif isdefined('attributes.is_form_submitted')>style="display:none"</cfif>>
                                                	<input type="button" name="vazgec" id="vazgec" value="Vazgeç" style="background-color:red" onClick="window.close();">
                                                    <input type="button" name="hesapla" id="hesapla" value="Hesapla" onClick="control(0);">
                                               	</span>
                                                <span id="guncelle_" <cfif not isdefined('attributes.is_form_submitted')>style="display:none"</cfif>>
                                                	<input type="button" name="vazgec" id="vazgec" value="Vazgeç" style="background-color:red" onClick="window.close();">
                                                    <cfif not isdefined('attributes.ezgi_kilit')>
                                        				<cf_workcube_buttons is_upd='1' is_delete='0' is_cancel='1' add_function="control(1)">
                                                    </cfif>
                                             	</span>
                                        	</cfif>
                                      	<cfelse>
                                       		<font color="FF0000"><cf_get_lang no="870.Ürün Özelleştirilebilir Olmadığı İçin Spec Kaydedemezsiniz"> !</font>
                                     	</cfif>
                                 	</td>
                             	</tr>
                          	</tfoot>
                      	</cf_medium_list>
                  	</td>
               	</tr>
            </table>
        </cf_area>  
    </cfform>
</cf_popup_box>
<script type="text/javascript">
	function aktar()
	{
		if(document.getElementById('uploaded_file').value == '')
		{
			alert('Lütfen Dosya Seçiniz!');	
			return false;
		}
		else
		{
			var sor = confirm('Dosyayı Aktarıyorsunuz !');
			if(sor==true)
			{
				document.getElementById("addSpecAll").action = "<cfoutput>#request.self#</cfoutput>?fuseaction=prod.emptypopup_upd_ezgi_virtual_offer_row_spect_aktar";
				document.getElementById("addSpecAll").enctype = "multipart/form-data";
				document.getElementById("addSpecAll").submit();
				
			}
			else
				return false;
		}
	}
	function control(type)
	{
		<cfoutput query="get_row">
			<cfif isdefined('QUESTION_NAME_#QUESTION_ID#')>
				piece_type = #piece_type#;
				if(piece_type == 4)
				{
					if(document.getElementById('alternative_stock_id_4_#PIECE_ROW_ID#').value==0)
					{
						alert("#getLang('invoice',39)#");
						return false;
					}
				}
				else
				{
					if(document.getElementById('alternative_stock_id_#PIECE_TYPE#_#PIECE_ROW_ID#').value==0)
					{
						alert("#getLang('invoice',39)#");
						return false;
					}
				}
			</cfif>
		</cfoutput>
		if(type == 1)
		{
			return true;
		}
		if(type == 0)
		{
			document.getElementById("addSpecAll").action = "<cfoutput>#request.self#?fuseaction=prod.popup_upd_ezgi_virtual_offer_row_spect&ezgi_id=#attributes.ezgi_id#</cfoutput>";
			document.getElementById("addSpecAll").submit();
			return true;
		}
	}
	function degisti(measure)
	{
		document.getElementById('hesapla_').style.display = '';
		document.getElementById('guncelle_').style.display = 'none';
		if(measure == 1)
		{

			<cfoutput query="get_heights">
				if(document.getElementById('height').value == #measure#)
				{
					if(#IS_STANDART#==0)
					{
						alert('Dikkat Özel Ölçü Seçtiniz');
					}
					else
					document.getElementById('not_standart_rate').value=0;
				}	
			</cfoutput>
		}
	}
</script>