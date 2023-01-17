<cfquery name="get_rows1" datasource="#dsn_Dev#">
    SELECT
        GAR.ACTION_ROW_ID,
        GAR.BARCODE,
        GAR.MIKTAR,
        GAR.SATIR_IPTALMI,
        GA.*
    FROM
        GENIUS_ACTIONS GA,
        GENIUS_ACTIONS_ROWS GAR
    WHERE
        GA.ACTION_ID = GAR.ACTION_ID AND
        GAR.STOCK_ID IS NULL
</cfquery>

<cfoutput query="get_rows1">
    <cfquery name="get_stock" datasource="#dsn1#">
        SELECT
            SB.STOCK_ID,
            S.PROPERTY,
            P.PRODUCT_STATUS,
            P.IS_SALES,
            P.PRODUCT_ID
        FROM
            #dsn1_alias#.STOCKS_BARCODES SB,
            #dsn1_alias#.STOCKS S,
            #dsn1_alias#.PRODUCT P
        WHERE
            SB.STOCK_ID = S.STOCK_ID AND
            S.PRODUCT_ID = P.PRODUCT_ID AND
            SB.BARCODE = '#BARCODE#' 
            --AND P.IS_SALES = 1 
            --AND P.PRODUCT_STATUS = 1
    </cfquery>
    <cfif get_stock.recordcount>
        <cfquery name="upd_" datasource="#dsn_dev#">
            UPDATE
                GENIUS_ACTIONS_ROWS
            SET
                STOCK_ID = #get_stock.STOCK_ID#
            WHERE
                ACTION_ROW_ID = #ACTION_ROW_ID#
        </cfquery>
        <cfquery name="get_s" datasource="#dsn2#">
        	SELECT * FROM STOCKS_ROW WHERE RELATED_ROW_ID = #ACTION_ROW_ID#
        </cfquery>
        <cfif not get_s.recordcount>
        	<cfif belge_turu eq 2>
				<cfset stock_in_ = MIKTAR>
                <cfset stock_out_ = 0>
                <cfset stock_islem_tipi_ = -1004>
                <cfif SATIR_IPTALMI eq 1>
                    <cfset stock_in_ = -1 * stock_in_>
                </cfif>
            <cfelse>
                <cfset stock_in_ = 0>
                <cfset stock_out_ = MIKTAR>
                <cfif belge_turu eq 1>
                    <cfset stock_islem_tipi_ = -1005>
                <cfelse>
                    <cfset stock_islem_tipi_ = -1003>
                </cfif>
                <cfif SATIR_IPTALMI eq 1>
                    <cfset stock_out_ = -1 * stock_out_>
                </cfif>
            </cfif>
            
            <cfquery name="GET_POS_EQUIPMENT" datasource="#DSN3#">
                SELECT
                    (SELECT TOP 1 D.DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT D WHERE D.BRANCH_ID = B.BRANCH_ID) AS DEPARTMENT_ID,
                    POS_EQUIPMENT.*,
                    B.BRANCH_NAME
                FROM
                    POS_EQUIPMENT,
                    #dsn_alias#.BRANCH B
                WHERE
                    POS_EQUIPMENT.BRANCH_ID = B.BRANCH_ID AND
                    POS_EQUIPMENT.EQUIPMENT_CODE = #KASA_NUMARASI#
                ORDER BY
                    POS_EQUIPMENT.FILENAME ASC
            </cfquery>            
            
            <cfquery name="add_" datasource="#dsn2#">
                INSERT INTO
                    STOCKS_ROW
                    (
                        STOCK_ID,
                        PRODUCT_ID,
                        UPD_ID,
                        PROCESS_TYPE,
                        STOCK_IN,
                        STOCK_OUT,
                        STORE,
                        STORE_LOCATION,
                        PROCESS_DATE,
                        DELIVER_DATE,
                        WRK_ROW_ID,
                        RELATED_ROW_ID
                    )
                    VALUES
                    (
                        #get_stock.STOCK_ID#,
                        #get_stock.PRODUCT_ID#,
                        #ACTION_ID#,
                        #stock_islem_tipi_#,
                        #stock_in_#,
                        #stock_out_#,
                        #GET_POS_EQUIPMENT.DEPARTMENT_ID#,
                        1,
                        #createodbcdatetime(FIS_TARIHI)#,
                        #createodbcdatetime(FIS_TARIHI)#,
                        '#ACTION_ROW_ID#-#SUBE_KODU#-#kasa_numarasi#-#kasiyer_no#-#action_id#-#fis_numarasi#-#dateformat(FIS_TARIHI,"ddmmyyyy")#',
                        #ACTION_ROW_ID#
                    )   
            </cfquery>
        </cfif>
    </cfif>
</cfoutput>
<cflocation url="#request.self#?fuseaction=retail.popup_manage_bad_rows" addtoken="no">