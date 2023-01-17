<cfsetting showdebugoutput="yes">
<cfif attributes.is_type eq 1>
    <cfquery name="GET_SHIP_ROW" datasource="#dsn3#">
        SELECT     
            STOCK_CODE, 
            STOCK_CODE_2, 
            PRODUCT_ID, 
            PRODUCT_NAME, 
            UNIT, 
            AMOUNT, 
            SHIPPING_ID,
            SHIPPING_ROW_ID, 
            STOCK_ID,
            PRODUCT_NAME2,
           	CASE
            	WHEN 
                	PRODUCT_TREE_AMOUNT IS NOT NULL
              	THEN
                	PRODUCT_TREE_AMOUNT
             	ELSE             
                    ISNULL(
                            (
                            SELECT        
                            	SUM(EPS.PAKET_SAYISI) AS PAKET_SAYISI
							FROM           
                            	EZGI_PAKET_SAYISI AS EPS INNER JOIN
                        		SPECTS AS S ON EPS.MODUL_SPECT_ID = S.SPECT_MAIN_ID
							WHERE        
                            	S.SPECT_VAR_ID = TBL.SPECT_VAR_ID
                            ) * AMOUNT
                    	, 0)
           	END 
                AS PAKET_SAYISI, 
            ISNULL(
                    (
                    SELECT     
                        SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                    FROM         
                        EZGI_SHIPPING_PACKAGE_LIST
                    WHERE     
                        SHIPPING_ROW_ID = TBL.SHIPPING_ROW_ID AND 
                        SHIPPING_ID = TBL.SHIPPING_ID AND 
                        TYPE = 1
                    )
            , 0) AS CONTROL_AMOUNT,
            LOT_NO
        FROM         
            (
            SELECT     
            	S.STOCK_CODE, 
                S.STOCK_CODE_2, 
                S.PRODUCT_ID, 
                S.PRODUCT_NAME, 
                ORR.UNIT, 
                ORR.QUANTITY AS AMOUNT, 
                ORR.SPECT_VAR_ID,
                ESRR.SHIP_RESULT_ID AS SHIPPING_ID, 
                ESRR.SHIP_RESULT_ROW_ID AS SHIPPING_ROW_ID,
             	S.STOCK_ID,
                S.PRODUCT_TREE_AMOUNT,
                ORR.PRODUCT_NAME2,
                (
                    SELECT 
                        DISTINCT PO.LOT_NO
                    FROM      
                        PRODUCTION_ORDERS_ROW AS PORR INNER JOIN
                        PRODUCTION_ORDERS AS PO ON PORR.PRODUCTION_ORDER_ID = PO.P_ORDER_ID
                    WHERE     
                        PORR.TYPE = 1 AND 
                        PORR.ORDER_ROW_ID = ORR.ORDER_ROW_ID
                ) AS LOT_NO
			FROM         
            	ORDER_ROW AS ORR INNER JOIN
                EZGI_SHIP_RESULT_ROW AS ESRR ON ORR.ORDER_ROW_ID = ESRR.ORDER_ROW_ID INNER JOIN
                STOCKS AS S ON ORR.STOCK_ID = S.STOCK_ID
			WHERE     
            	ESRR.SHIP_RESULT_ID = #attributes.ship_id# AND
                ORR.ORDER_ROW_CURRENCY = -6 AND
                ISNULL(S.IS_PROTOTYPE,0) = 1
            ) AS TBL  
     	UNION ALL
         SELECT     
            STOCK_CODE, 
            STOCK_CODE_2, 
            PRODUCT_ID, 
            PRODUCT_NAME, 
            UNIT, 
            AMOUNT, 
            SHIPPING_ID,
            SHIPPING_ROW_ID, 
            STOCK_ID,
            PRODUCT_NAME2,
           	ISNULL(
           		(
                    SELECT     
                        SUM(PAKET_SAYISI) AS PAKET_SAYISI
                    FROM         
                        EZGI_PAKET_SAYISI
                    WHERE     
                        MODUL_ID = TBL.STOCK_ID
            	) * AMOUNT
         	, 0) AS PAKET_SAYISI, 
            ISNULL(
                    (
                    SELECT     
                        SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                    FROM         
                        EZGI_SHIPPING_PACKAGE_LIST
                    WHERE     
                        SHIPPING_ROW_ID = TBL.SHIPPING_ROW_ID AND 
                        SHIPPING_ID = TBL.SHIPPING_ID AND 
                        TYPE = 1
                    )
            , 0) AS CONTROL_AMOUNT,
            LOT_NO
        FROM         
            (
            SELECT     
            	S.STOCK_CODE, 
                S.STOCK_CODE_2, 
                S.PRODUCT_ID, 
                S.PRODUCT_NAME, 
                ORR.UNIT, 
                ORR.QUANTITY AS AMOUNT, 
                ESRR.SHIP_RESULT_ID AS SHIPPING_ID, 
                ESRR.SHIP_RESULT_ROW_ID AS SHIPPING_ROW_ID,
             	S.STOCK_ID,
                S.PRODUCT_TREE_AMOUNT,
                ORR.PRODUCT_NAME2,
                (
                    SELECT 
                        DISTINCT PO.LOT_NO
                    FROM      
                        PRODUCTION_ORDERS_ROW AS PORR INNER JOIN
                        PRODUCTION_ORDERS AS PO ON PORR.PRODUCTION_ORDER_ID = PO.P_ORDER_ID
                    WHERE     
                        PORR.TYPE = 1 AND 
                        PORR.ORDER_ROW_ID = ORR.ORDER_ROW_ID
                ) AS LOT_NO
			FROM         
            	ORDER_ROW AS ORR INNER JOIN
                EZGI_SHIP_RESULT_ROW AS ESRR ON ORR.ORDER_ROW_ID = ESRR.ORDER_ROW_ID INNER JOIN
                STOCKS AS S ON ORR.STOCK_ID = S.STOCK_ID
			WHERE     
            	ESRR.SHIP_RESULT_ID = #attributes.ship_id# AND
                ORR.ORDER_ROW_CURRENCY = -6 AND
                ISNULL(S.IS_PROTOTYPE,0) = 0
            ) AS TBL  
     	ORDER BY
        	SHIPPING_ROW_ID                   
    </cfquery>
<cfelse>
    <cfquery name="GET_SHIP_ROW" datasource="#dsn3#">
        SELECT     
            STOCK_CODE, 
            STOCK_CODE_2, 
            PRODUCT_ID, 
            PRODUCT_NAME, 
            UNIT, 
            AMOUNT, 
            SHIPPING_ID, 
            SHIPPING_ROW_ID,
            STOCK_ID, 
            PRODUCT_NAME2,
            CASE
            	WHEN 
                	PRODUCT_TREE_AMOUNT IS NOT NULL
              	THEN
                	PRODUCT_TREE_AMOUNT
             	ELSE             
                    ISNULL(
                            (
                            SELECT     
                                SUM(PAKET_SAYISI) AS PAKET_SAYISI
                            FROM         
                                EZGI_PAKET_SAYISI
                            WHERE     
                                MODUL_ID = TBL.STOCK_ID
                            ) * AMOUNT
                    	, 0)
           	END 
                AS PAKET_SAYISI,  
            ISNULL(
                    (
                    SELECT     
                        SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                    FROM         
                        EZGI_SHIPPING_PACKAGE_LIST
                    WHERE     
                        SHIPPING_ROW_ID = TBL.SHIPPING_ROW_ID AND 
                        SHIPPING_ID = TBL.SHIPPING_ID AND 
                        TYPE = 2
                    )
            , 0) AS CONTROL_AMOUNT,
            LOT_NO
        FROM         
            (
            SELECT 
            	S.PRODUCT_TREE_AMOUNT,    
                S.STOCK_CODE, 
                S.STOCK_CODE_2, 
                S.PRODUCT_ID, 
                S.PRODUCT_NAME, 
                SIR.UNIT, 
                SIR.AMOUNT, 
                SIR.DISPATCH_SHIP_ID AS SHIPPING_ID, 
                SIR.SHIP_ROW_ID AS SHIPPING_ROW_ID,
                SIR.STOCK_ID,
                ORR.PRODUCT_NAME2,
                (
                    SELECT 
                        DISTINCT PO.LOT_NO
                    FROM      
                        PRODUCTION_ORDERS_ROW AS PORR INNER JOIN
                        PRODUCTION_ORDERS AS PO ON PORR.PRODUCTION_ORDER_ID = PO.P_ORDER_ID
                    WHERE     
                        PORR.TYPE = 1 AND 
                        PORR.ORDER_ROW_ID = ORR.ORDER_ROW_ID
                ) AS LOT_NO
            FROM          
                #dsn2_alias#.SHIP_INTERNAL_ROW AS SIR INNER JOIN
                ORDER_ROW ORR ON SIR.ROW_ORDER_ID = ORR.ORDER_ROW_ID INNER JOIN
                STOCKS AS S ON SIR.STOCK_ID = S.STOCK_ID
            WHERE      
                SIR.DISPATCH_SHIP_ID = #attributes.ship_id# AND
                ORR.ORDER_ROW_CURRENCY = -6
            ) AS TBL  
      	ORDER BY
        	SHIPPING_ROW_ID                      
    </cfquery>
</cfif>    
<cfquery name="get_url" datasource="#dsn2#">
	SELECT
		SHIP_NUMBER,
    	DELIVER_STORE_ID,
        LOCATION
    FROM
    	SHIP
    WHERE
    	(SHIP_ID = #ship_id#)
</cfquery>
<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_shipping&department_id=#department_id#&date1=#date1#&date2=#date2#&is_form_submitted=1&page=#page#&kontrol_status=#kontrol_status#">
<div style="width:290px">
<table cellpadding="1" cellspacing="1" align="left" class="color-border" width="100%">
    <form name="add_fis" method="post" action="<cfoutput>#request.self#?fuseaction=#adres#</cfoutput>">
        <tr class="color-list">
            <td colspan="4">
            <table width="99%" height="29" cellpadding="0" cellspacing="0">
                <tr>
                    <td> <cfif attributes.is_type eq 1><b><cf_get_lang_main no='3185.Sevk Plan No'> :</b><cfelse><b><cf_get_lang_main no='3178.Sevk Talep No'> :</b></cfif><cfoutput>#attributes.DELIVER_PAPER_NO#</cfoutput></b></td>
                    <td style="text-align:right"><input type="submit" value="<cf_get_lang_main no='20.Geri'>" name="1"></td>
                </tr>
            </table>
            </td>
        </tr>
        <tr class="color-list" height="20">
            <td>
                <cf_get_lang_main no='40.Stok'> <cf_get_lang_main no='485.Adı'>
            </td>
            <td width="25">
                <cf_get_lang_main no='223.Miktar'>
            </td>
            <td width="20">
                OK
            </td>                                
        </tr>
        <cfoutput query="GET_SHIP_ROW">
            <tr height="30px" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td >
                	<a href="#request.self#?fuseaction=pda.form_shipping_control_stock&ship_id=#ship_id#&f_stock_id=#GET_SHIP_ROW.stock_id#&department_id=#department_id#&date1=#date1#&date2=#date2#&page=#page#&kontrol_status=#kontrol_status#&product_name=#PRODUCT_NAME#&is_type=#attributes.is_type#&deliver_paper_no=#attributes.DELIVER_PAPER_NO#&shipping_row_id=#SHIPPING_ROW_ID#">
                        #PRODUCT_NAME#
                        <cfif len(LOT_NO)>
                            - #LOT_NO#
                        </cfif>
                        <cfif len(PRODUCT_NAME2)>
                            <br>
                            #PRODUCT_NAME2#
                        </cfif>
                    </a>
                </td>
                <td style="text-align:center;color:FF0000;"><strong>#PAKET_SAYISI#</strong></td>
                <td style="text-align:center">
                 <cfif PAKET_SAYISI eq 0>
                    <img src="/images/plus_ques.gif" border="0" title="<cf_get_lang_main no='2178.Barkod Yok'>.">
                 <cfelseif PAKET_SAYISI - CONTROL_AMOUNT eq 0>
                    <img src="/images/c_ok.gif" border="0" title="<cf_get_lang_main no='3133.Kontrol Edildi'>.">
                 <cfelseif CONTROL_AMOUNT eq 0>
                    <img src="/images/caution_small.gif" border="0" title="<cf_get_lang_main no='3134.Kontrol Edilmedi'>.">
                 <cfelseif PAKET_SAYISI gt CONTROL_AMOUNT>
                    <img src="/images/warning.gif" border="0" title="<cf_get_lang_main no='3135.Kontrol Eksik'>.">   
                 </cfif>
                </td>       
            </tr>
        </cfoutput>
    </form>
</table>
</td>