<cfif isdefined('attributes.design_piece_row_id') and len(attributes.design_piece_row_id)>
	<cfset package = 0>
<cfelse>
	<cfset package = 1>
</cfif>
<cfif (isdefined('attributes.design_package_row_id') and len(attributes.design_package_row_id)) or (isdefined('attributes.design_piece_row_id') and len(attributes.design_piece_row_id))>
	<cfset piece = 1>
<cfelse>
	<cfset piece = 0>
</cfif>
<cfquery name="get_piece_standart_eklenti" datasource="#dsn3#"> <!---Parça İçin Standart Eklentilerin Default Tanımlar Dosyasından Çekilmesi--->
	SELECT        
    	TBL.STOCK_ID, 
        TBL.FORMUL, 
        S.PRODUCT_ID, 
        S.PRODUCT_NAME, 
        S.PRODUCT_CODE, 
        PU.MAIN_UNIT,
        (SELECT TOP (1) SPECT_MAIN_ID FROM SPECT_MAIN WHERE STOCK_ID = S.STOCK_ID AND IS_TREE = 1 ORDER BY SPECT_MAIN_ID DESC) AS SPECT_MAIN_ID
	FROM            
    	(
        	SELECT        
            	PIECE_STOCK_ID_1 AS STOCK_ID, PIECE_FORMUL_1 AS FORMUL
          	FROM            
            	EZGI_DESIGN_DEFAULTS
          	UNION ALL
          	SELECT        
            	PIECE_STOCK_ID_2, PIECE_FORMUL_2
          	FROM            
            	EZGI_DESIGN_DEFAULTS AS EZGI_DESIGN_DEFAULTS_1
          	UNION ALL
          	SELECT        
            	PIECE_STOCK_ID_3, PIECE_FORMUL_3
         	FROM            
            	EZGI_DESIGN_DEFAULTS AS EZGI_DESIGN_DEFAULTS_2
         	UNION ALL
          	SELECT        
            	PIECE_STOCK_ID_4, PIECE_FORMUL_4
          	FROM            
            	EZGI_DESIGN_DEFAULTS AS EZGI_DESIGN_DEFAULTS_3
          	UNION ALL
          	SELECT        
            	PIECE_STOCK_ID_5, PIECE_FORMUL_5
           	FROM            
            	EZGI_DESIGN_DEFAULTS AS EZGI_DESIGN_DEFAULTS_4
      	) AS TBL INNER JOIN
      	STOCKS AS S ON TBL.STOCK_ID = S.STOCK_ID INNER JOIN
      	PRODUCT_UNIT AS PU ON S.PRODUCT_ID = PU.PRODUCT_ID
	WHERE        
    	TBL.STOCK_ID IS NOT NULL AND 
        TBL.FORMUL IS NOT NULL AND 
        PU.IS_MAIN = 1
</cfquery>
<cfquery name="get_piece_eklenti_material" datasource="#dsn3#"> <!---Parça Standart Eklentiler İçin Formül Altyapısının Çekilmesi--->
	SELECT  
    	DISTINCT      
        <cfif isdefined('is_transfer') and is_transfer eq 1> 
        	<cfif package eq 1>
        		ED.EMKTR,	
            <cfelse>
            	ED.EMKTR/EDP.PIECE_AMOUNT AS EMKTR,
            </cfif>
     	<cfelse>	
         	ED.EMKTR,
     	</cfif> 
        ISNULL(ED.BOY,0) AS BOY, 
        ISNULL(ED.EN,0) AS EN, 
        ISNULL(ED.ALAN,0) AS ALAN, 
        ISNULL(ED.CEVRE,0) AS CEVRE, 
        ISNULL(ED.KENAR1,0) AS KENAR1, 
        ISNULL(ED.KENAR2,0) AS KENAR2, 
        ISNULL(ED.KENAR3,0) AS KENAR3, 
        ISNULL(ED.KENAR4,0) AS KENAR4, 
        ISNULL(ED.KALINLIK,0) AS KALINLIK, 
        EDP.DESIGN_ID, 
        EDP.DESIGN_MAIN_ROW_ID, 
        EDP.DESIGN_PACKAGE_ROW_ID, 
  		EDP.PIECE_ROW_ID
	FROM            
    	EZGI_DESIGN_PRODUCT_OLCU AS ED INNER JOIN
    	EZGI_DESIGN_PIECE AS EDP ON ED.CODE_ID = EDP.PIECE_ROW_ID
	WHERE        
    	ED.TYPE = 2
        <cfif isdefined('attributes.design_id') and len(attributes.design_id)>        
    		AND EDP.DESIGN_ID = #attributes.design_id#
        </cfif>
        <cfif isdefined('attributes.design_main_row_id') and len(attributes.design_main_row_id)>
        	AND EDP.DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id#
       	</cfif>
        <cfif isdefined('attributes.design_package_row_id') and len(attributes.design_package_row_id)>
        	AND EDP.DESIGN_PACKAGE_ROW_ID = #attributes.design_package_row_id#
        </cfif>
        <cfif isdefined('attributes.design_piece_row_id') and len(attributes.design_piece_row_id)>
        	AND EDP.PIECE_ROW_ID = #attributes.design_piece_row_id#
        </cfif>
 	<cfif piece eq 1>
        UNION ALL
        SELECT        
            <cfif isdefined('is_transfer') and is_transfer eq 1> 
            	<cfif package eq 1>
                	EPR.AMOUNT*EDP.PIECE_AMOUNT AS EMKTR,
                <cfelse>
           			EPR.AMOUNT AS EMKTR,
                </cfif>
            <cfelse>	
                EPR.AMOUNT*EDP.PIECE_AMOUNT AS EMKTR,
           	</cfif> 
            ISNULL(EDO.BOY,0) AS BOY, 
            ISNULL(EDO.EN,0) AS EN, 
            ISNULL(EDO.ALAN,0) AS ALAN, 
            ISNULL(EDO.CEVRE,0) AS CEVRE, 
            ISNULL(EDO.KENAR1,0) AS KENAR1, 
            ISNULL(EDO.KENAR2,0) AS KENAR2, 
            ISNULL(EDO.KENAR3,0) AS KENAR3, 
            ISNULL(EDO.KENAR4,0) AS KENAR4, 
            ISNULL(EDO.KALINLIK,0) AS KALINLIK, 
            EDP.DESIGN_ID, 
            EDP.DESIGN_MAIN_ROW_ID, 
            EDP.DESIGN_PACKAGE_ROW_ID, 
            EDP.PIECE_ROW_ID
        FROM            
            EZGI_DESIGN_PIECE AS EDP INNER JOIN
            EZGI_DESIGN_PIECE_ROW AS EPR ON EDP.PIECE_ROW_ID = EPR.PIECE_ROW_ID INNER JOIN
            EZGI_DESIGN_PRODUCT_OLCU AS EDO ON EPR.RELATED_PIECE_ROW_ID = EDO.CODE_ID
        WHERE        
            EDP.PIECE_TYPE = 3 AND 
            EDO.TYPE = 2
             <cfif isdefined('attributes.design_id') and len(attributes.design_id)>        
                AND EDP.DESIGN_ID = #attributes.design_id#
            </cfif>
            <cfif isdefined('attributes.design_main_row_id') and len(attributes.design_main_row_id)>
                AND EDP.DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id#
            </cfif>
            <cfif isdefined('attributes.design_package_row_id') and len(attributes.design_package_row_id)>
                AND EDP.DESIGN_PACKAGE_ROW_ID = #attributes.design_package_row_id#
            </cfif>
            <cfif isdefined('attributes.design_piece_row_id') and len(attributes.design_piece_row_id)>
                AND EDP.PIECE_ROW_ID = #attributes.design_piece_row_id#
            </cfif>
  	</cfif>
</cfquery>
<!---<cfdump var="#get_piece_eklenti_material#">--->
<cfif package eq 1>
    <cfquery name="get_package_standart_eklenti" datasource="#dsn3#"> <!---Paket İçin Standart Eklentilerin Default Tanımlar Dosyasından Çekilmesi--->
        SELECT        
            TBL.STOCK_ID, 
            TBL.FORMUL, 
            S.PRODUCT_ID, 
            S.PRODUCT_NAME, 
            S.PRODUCT_CODE, 
            PU.MAIN_UNIT,
            ISNULL((SELECT TOP (1) SPECT_MAIN_ID FROM SPECT_MAIN WHERE STOCK_ID = S.STOCK_ID AND IS_TREE = 1 ORDER BY SPECT_MAIN_ID DESC),0) AS SPECT_MAIN_ID
        FROM            
            (
                SELECT        
                    PACKAGE_STOCK_ID_1 AS STOCK_ID, PACKAGE_FORMUL_1 AS FORMUL
                FROM            
                    EZGI_DESIGN_DEFAULTS
                UNION ALL
                SELECT        
                    PACKAGE_STOCK_ID_2, PACKAGE_FORMUL_2
                FROM            
                    EZGI_DESIGN_DEFAULTS AS EZGI_DESIGN_DEFAULTS_1
                UNION ALL
                SELECT        
                    PACKAGE_STOCK_ID_3, PACKAGE_FORMUL_3
                FROM            
                    EZGI_DESIGN_DEFAULTS AS EZGI_DESIGN_DEFAULTS_2
                UNION ALL
                SELECT        
                    PACKAGE_STOCK_ID_4, PACKAGE_FORMUL_4
                FROM            
                    EZGI_DESIGN_DEFAULTS AS EZGI_DESIGN_DEFAULTS_3
                UNION ALL
                SELECT        
                    PACKAGE_STOCK_ID_5, PACKAGE_FORMUL_5
                FROM            
                    EZGI_DESIGN_DEFAULTS AS EZGI_DESIGN_DEFAULTS_4
            ) AS TBL INNER JOIN
            STOCKS AS S ON TBL.STOCK_ID = S.STOCK_ID INNER JOIN
            PRODUCT_UNIT AS PU ON S.PRODUCT_ID = PU.PRODUCT_ID
        WHERE        
            TBL.STOCK_ID IS NOT NULL AND 
            TBL.FORMUL IS NOT NULL AND 
            PU.IS_MAIN = 1
    </cfquery>
    <cfquery name="get_package_eklenti_material" datasource="#dsn3#"> <!---Paket Standart Eklentiler İçin Formül Altyapısının Çekilmesi--->
        SELECT        
            ED.EMKTR, 
            EDP.DESIGN_ID, 
            EDP.DESIGN_MAIN_ROW_ID, 
            EDP.PACKAGE_ROW_ID
        FROM            
            EZGI_DESIGN_PRODUCT_OLCU AS ED INNER JOIN
            EZGI_DESIGN_PACKAGE AS EDP ON ED.CODE_ID = EDP.PACKAGE_ROW_ID
        WHERE        
            ED.TYPE = 1
            <cfif isdefined('attributes.design_id') and len(attributes.design_id)>        
                AND EDP.DESIGN_ID = #attributes.design_id#
            </cfif>
            <cfif isdefined('attributes.design_main_row_id') and len(attributes.design_main_row_id)>
                AND EDP.DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id#
            </cfif>
            <cfif isdefined('attributes.design_package_row_id') and len(attributes.design_package_row_id)>
                AND EDP.PACKAGE_ROW_ID = #attributes.design_package_row_id#
            </cfif>
    </cfquery>
</cfif>

<cfif isdefined('is_transfer') and is_transfer eq 1> <!---Transfer İçin Veri Toplama--->
	<cfquery name="get_material_1" datasource="#dsn3#">
    	SELECT        
            EDR1.STOCK_ID, 
            S.PRODUCT_NAME, 
            S.PRODUCT_CODE,
            S.PRODUCT_ID,
            (SELECT TOP (1) SPECT_MAIN_ID FROM SPECT_MAIN WHERE STOCK_ID = EDR1.STOCK_ID AND IS_TREE = 1 ORDER BY SPECT_MAIN_ID DESC) AS SPECT_MAIN_ID,
            SUM(EDR1.AMOUNT) AS AMOUNT, 
            P.MAIN_UNIT,
            0 AS LINE_NUMBER,
            0 AS OPERATION_TYPE_ID
        FROM            
            ( 
            	<!---Parça Tipi Yonga Levha İse (Transfer)--->
        		SELECT        
                	EDP.DESIGN_ID, 
                    EDP.DESIGN_MAIN_ROW_ID, 
                    EDP.DESIGN_PACKAGE_ROW_ID, 
                    EDP.PIECE_ROW_ID, 
                    EDPR.STOCK_ID, 
                    EDP.PIECE_TYPE, 
                    <cfif (isdefined('attributes.design_piece_row_id') and len(attributes.design_piece_row_id))>
                    	SUM(EDPR.AMOUNT) AS AMOUNT
                    <cfelse>
						SUM(EDPR.AMOUNT*EDP.PIECE_AMOUNT) AS AMOUNT
					</cfif>
				FROM            
                	EZGI_DESIGN_PIECE_rows AS EDP INNER JOIN <!---Bayras İçin Değişti--->
               		EZGI_DESIGN_RECETE AS EDPR ON EDP.PIECE_ROW_ID = EDPR.PIECE_ROW_ID
				WHERE        
                	EDP.PIECE_TYPE = 1
				GROUP BY 
                	EDP.DESIGN_ID, 
                    EDP.DESIGN_MAIN_ROW_ID, 
                    EDP.DESIGN_PACKAGE_ROW_ID, 
                    EDP.PIECE_ROW_ID, 
                    EDPR.STOCK_ID, 
                    EDP.PIECE_TYPE
              	UNION ALL
                <!---Parça Tipi Genel Reçete İse (Transfer)--->
                SELECT        
                    EDP.DESIGN_ID, 
                    EDP.DESIGN_MAIN_ROW_ID, 
                    EDP.DESIGN_PACKAGE_ROW_ID, 
                    EDP.PIECE_ROW_ID, 
                    EDPR.STOCK_ID, 
                    EDP.PIECE_TYPE, 
                    <cfif (isdefined('attributes.design_piece_row_id') and len(attributes.design_piece_row_id))>
                    	SUM(EDPR.AMOUNT) AS AMOUNT
                    <cfelse>
						SUM(EDPR.AMOUNT*EDP.PIECE_AMOUNT) AS AMOUNT
					</cfif>
                FROM            
                    EZGI_DESIGN_PIECE_rows AS EDP INNER JOIN <!---Bayras İçin Değişti--->
                    EZGI_DESIGN_PIECE_ROW AS EDPR ON EDP.PIECE_ROW_ID = EDPR.PIECE_ROW_ID
                WHERE        
                    EDP.PIECE_TYPE = 2
                GROUP BY 
                    EDPR.STOCK_ID, 
                    EDP.DESIGN_ID, 
                    EDP.DESIGN_MAIN_ROW_ID, 
                    EDP.DESIGN_PACKAGE_ROW_ID, 
                    EDP.PIECE_ROW_ID, 
                    EDP.PIECE_TYPE
             	UNION ALL
                <!---Parça Tipi Montaj Ürünü İse ve Sadece Montaj Ürününe ait Reçete (Transfer)--->
                SELECT        
                    EDP.DESIGN_ID, 
                    EDP.DESIGN_MAIN_ROW_ID, 
                    EDP.DESIGN_PACKAGE_ROW_ID, 
                    EDP.PIECE_ROW_ID, 
                    EDPR.STOCK_ID, 
                    EDP.PIECE_TYPE, 
                    SUM(EDP.PIECE_AMOUNT * EDPR.AMOUNT) AS AMOUNT
                FROM            
                    EZGI_DESIGN_PIECE AS EDP INNER JOIN
                    EZGI_DESIGN_PIECE_ROW AS EDPR ON EDP.PIECE_ROW_ID = EDPR.PIECE_ROW_ID
                WHERE        
                    EDP.PIECE_TYPE = 3 AND 
                    EDPR.STOCK_ID IS NOT NULL
                GROUP BY 
                    EDPR.STOCK_ID, 
                    EDP.DESIGN_ID, 
                    EDP.DESIGN_MAIN_ROW_ID, 
                    EDP.DESIGN_PACKAGE_ROW_ID, 
                    EDP.PIECE_ROW_ID, 
                    EDP.PIECE_TYPE
             	<cfif (isdefined('attributes.design_piece_row_id') and len(attributes.design_piece_row_id)) or (isdefined('attributes.design_package_row_id') and len (attributes.design_package_row_id))>
                	<!---Parça Tipi Montaj Ürünü İse ve Paket ve Parça Bazında isteniyorsa Sadece Montaj Ürünün altındaki Parçalara ait Reçete--->
                	UNION ALL
                    SELECT        
                    	EDP.DESIGN_ID, 
                        EDP.DESIGN_MAIN_ROW_ID, 
                        EDP.DESIGN_PACKAGE_ROW_ID, 
                        EDP.PIECE_ROW_ID, 
                        EDR0.STOCK_ID, 
                        EDP.PIECE_TYPE,  
                        SUM(EDR0.AMOUNT * EDP.PIECE_AMOUNT * EDPR.AMOUNT) AS AMOUNT
                    FROM           
                        EZGI_DESIGN_PIECE AS EDP INNER JOIN
                        EZGI_DESIGN_PIECE_ROW AS EDPR ON EDP.PIECE_ROW_ID = EDPR.PIECE_ROW_ID INNER JOIN
                        EZGI_DESIGN_RECETE AS EDR0 ON EDPR.RELATED_PIECE_ROW_ID = EDR0.PIECE_ROW_ID
                    WHERE        
                        EDP.PIECE_TYPE = 3 AND 
                        EDPR.STOCK_ID IS NULL
                    GROUP BY 
                        EDP.DESIGN_ID, 
                        EDP.DESIGN_MAIN_ROW_ID, 
                        EDP.DESIGN_PACKAGE_ROW_ID, 
                        EDP.PIECE_ROW_ID, 
                        EDR0.STOCK_ID,
                        EDP.PIECE_TYPE
                </cfif>
                UNION ALL
            <!---Parça Tipi Aksesuar Ürünü İse--->
			SELECT        
            	DESIGN_ID, 
                DESIGN_MAIN_ROW_ID, 
                DESIGN_PACKAGE_ROW_ID, 
                PIECE_ROW_ID, 
                PIECE_RELATED_ID AS STOCK_ID, 
                PIECE_TYPE, 
                PIECE_AMOUNT
			FROM            
            	EZGI_DESIGN_PIECE AS EDP
			WHERE        
            	PIECE_TYPE = 4
           	<!---Paket veya Modülün Sepetinde Aksesuar Ürünü İse--->
       		UNION ALL
            SELECT        
            	DESIGN_ID, 
                DESIGN_MAIN_ROW_ID, 
                DESIGN_PACKAGE_ROW_ID, 
                0 AS PIECE_ROW_ID, 
                STOCK_ID, 
                0 AS PIECE_TYPE, 
                AMOUNT
			FROM            
            	EZGI_DESIGN_ALL_MATERIAL
            )
            AS EDR1 INNER JOIN
            STOCKS AS S ON EDR1.STOCK_ID = S.STOCK_ID INNER JOIN
            PRODUCT_UNIT AS P ON S.PRODUCT_UNIT_ID = P.PRODUCT_UNIT_ID
        WHERE 
            P.IS_MAIN = 1
            <cfif isdefined('attributes.design_id') and len(attributes.design_id)>        
                AND EDR1.DESIGN_ID = #attributes.design_id#
            </cfif>
            <cfif isdefined('attributes.design_main_row_id') and len(attributes.design_main_row_id)>
                AND EDR1.DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id#
            </cfif>
            <cfif isdefined('attributes.design_package_row_id') and len(attributes.design_package_row_id)>
                AND EDR1.DESIGN_PACKAGE_ROW_ID = #attributes.design_package_row_id#
            </cfif>
            <cfif isdefined('attributes.design_piece_row_id') and len(attributes.design_piece_row_id)>
                AND EDR1.PIECE_ROW_ID = #attributes.design_piece_row_id#
            </cfif>
        GROUP BY 
            EDR1.STOCK_ID, 
            S.PRODUCT_NAME, 
            S.PRODUCT_ID,
            S.PRODUCT_CODE,
            P.MAIN_UNIT
        ORDER BY
            s.PRODUCT_CODE
    </cfquery>
<cfelse> <!---Design Ekranında Malzeme Gösterim İçin Reçete Hesaplama--->
	<cfquery name="get_material_1" datasource="#dsn3#"> <!---Reçetedeki Bilgiyi Toplama--->
    	SELECT        
            EDR1.STOCK_ID, 
            S.PRODUCT_NAME, 
            S.PRODUCT_CODE,
            S.PRODUCT_ID,
            (SELECT TOP (1) SPECT_MAIN_ID FROM SPECT_MAIN WHERE STOCK_ID = EDR1.STOCK_ID AND IS_TREE = 1 ORDER BY SPECT_MAIN_ID DESC) AS SPECT_MAIN_ID,
            SUM(EDR1.AMOUNT) AS AMOUNT, 
            P.MAIN_UNIT,
            0 AS LINE_NUMBER,
            0 AS OPERATION_TYPE_ID
        FROM            
            ( 
            	<!---Parça Tipi Yonga Levha İse ve Montaj Ürününe Bağlı Değilse--->
                SELECT        
                	EDP.DESIGN_ID, 
                    EDP.DESIGN_MAIN_ROW_ID, 
                    EDP.DESIGN_PACKAGE_ROW_ID, 
                    EDP.PIECE_ROW_ID, 
                    EDPR0.STOCK_ID, 
                    EDP.PIECE_TYPE, 
                    SUM(EDP.PIECE_AMOUNT * EDPR0.AMOUNT) AS AMOUNT
				FROM            
                	EZGI_DESIGN_PIECE AS EDP INNER JOIN
                 	EZGI_DESIGN_RECETE_0 AS EDPR0 ON EDP.PIECE_ROW_ID = EDPR0.PIECE_ROW_ID LEFT OUTER JOIN
                 	EZGI_DESIGN_PIECE_ROW AS EDPR ON EDP.PIECE_ROW_ID = EDPR.RELATED_PIECE_ROW_ID
				WHERE        
                	EDP.PIECE_TYPE = 1 AND 
                    EDPR.RELATED_PIECE_ROW_ID IS NULL 
				GROUP BY 
                	EDP.DESIGN_ID, 
                    EDP.DESIGN_MAIN_ROW_ID, 
                    EDP.DESIGN_PACKAGE_ROW_ID, 
                    EDP.PIECE_ROW_ID, 
                    EDPR0.STOCK_ID, 
                    EDP.PIECE_TYPE
              	UNION ALL
                <!---Parça Tipi Yonga Levha İse ve Montaj Ürününe Bağlıysa--->
                SELECT        
                	EDP.DESIGN_ID, 
                    EDP.DESIGN_MAIN_ROW_ID, 
                    EDP.DESIGN_PACKAGE_ROW_ID, 
                    EDP.PIECE_ROW_ID, 
                    EDPR0.STOCK_ID, 
                    EDP.PIECE_TYPE, 
               		SUM(EDPR.AMOUNT * EDPP.PIECE_AMOUNT * EDPR0.AMOUNT) AS AMOUNT
				FROM            
                	EZGI_DESIGN_PIECE AS EDP INNER JOIN
                  	EZGI_DESIGN_RECETE_0 AS EDPR0 ON EDP.PIECE_ROW_ID = EDPR0.PIECE_ROW_ID INNER JOIN
                  	EZGI_DESIGN_PIECE_ROW AS EDPR ON EDP.PIECE_ROW_ID = EDPR.RELATED_PIECE_ROW_ID INNER JOIN
                  	EZGI_DESIGN_PIECE_ROWS AS EDPP ON EDPR.PIECE_ROW_ID = EDPP.PIECE_ROW_ID
				WHERE        
                	EDP.PIECE_TYPE = 1 
				GROUP BY 
                	EDP.DESIGN_ID, 
                    EDP.DESIGN_MAIN_ROW_ID, 
                    EDP.DESIGN_PACKAGE_ROW_ID, 
                    EDP.PIECE_ROW_ID, 
                    EDPR0.STOCK_ID, 
                    EDP.PIECE_TYPE
             	UNION ALL
                <!---Parça Tipi Genel Reçete İse--->
                SELECT        
                    EDP.DESIGN_ID, 
                    EDP.DESIGN_MAIN_ROW_ID, 
                    EDP.DESIGN_PACKAGE_ROW_ID, 
                    EDP.PIECE_ROW_ID, 
                    EDPR.STOCK_ID, 
                    EDP.PIECE_TYPE, 
                    SUM(EDP.PIECE_AMOUNT * EDPR.AMOUNT) AS AMOUNT
                FROM            
                    EZGI_DESIGN_PIECE AS EDP INNER JOIN
                    EZGI_DESIGN_PIECE_ROW AS EDPR ON EDP.PIECE_ROW_ID = EDPR.PIECE_ROW_ID
                WHERE        
                    EDP.PIECE_TYPE = 2 AND
                    EDPR.PIECE_ROW_ROW_TYPE <> 3
                GROUP BY 
                    EDPR.STOCK_ID, 
                    EDP.DESIGN_ID, 
                    EDP.DESIGN_MAIN_ROW_ID, 
                    EDP.DESIGN_PACKAGE_ROW_ID, 
                    EDP.PIECE_ROW_ID, 
                    EDP.PIECE_TYPE
             	UNION ALL
                <!---Parça Tipi Montaj Ürünü İse ve Sadece Montaj Ürününe ait Reçete--->
                SELECT        
                    EDP.DESIGN_ID, 
                    EDP.DESIGN_MAIN_ROW_ID, 
                    EDP.DESIGN_PACKAGE_ROW_ID, 
                    EDP.PIECE_ROW_ID, 
                    EDPR.STOCK_ID, 
                    EDP.PIECE_TYPE, 
                    SUM(EDP.PIECE_AMOUNT * EDPR.AMOUNT) AS AMOUNT
                FROM            
                    EZGI_DESIGN_PIECE AS EDP INNER JOIN
                    EZGI_DESIGN_PIECE_ROW AS EDPR ON EDP.PIECE_ROW_ID = EDPR.PIECE_ROW_ID
                WHERE        
                    EDP.PIECE_TYPE = 3 AND 
                    EDPR.STOCK_ID IS NOT NULL
                GROUP BY 
                    EDPR.STOCK_ID, 
                    EDP.DESIGN_ID, 
                    EDP.DESIGN_MAIN_ROW_ID, 
                    EDP.DESIGN_PACKAGE_ROW_ID, 
                    EDP.PIECE_ROW_ID, 
                    EDP.PIECE_TYPE
             	<cfif (isdefined('attributes.design_piece_row_id') and len(attributes.design_piece_row_id)) or (isdefined('attributes.design_package_row_id') and len (attributes.design_package_row_id))>
                	<!---Parça Tipi Montaj Ürünü İse ve Paket ve Parça Bazında isteniyorsa Sadece Montaj Ürünün altındaki Parçalara ait Reçete--->
                	UNION ALL
                	SELECT        
                        EDP.DESIGN_ID, 
                        EDP.DESIGN_MAIN_ROW_ID, 
                        EDP.DESIGN_PACKAGE_ROW_ID, 
                        EDP.PIECE_ROW_ID, 
                        EDR0.STOCK_ID, 
                        EDP.PIECE_TYPE, 
                        SUM(EDR0.AMOUNT * EDP.PIECE_AMOUNT * EDPR.AMOUNT) AS AMOUNT
                    FROM            
                        EZGI_DESIGN_PIECE AS EDP INNER JOIN
                        EZGI_DESIGN_PIECE_ROW AS EDPR ON EDP.PIECE_ROW_ID = EDPR.PIECE_ROW_ID INNER JOIN
                        EZGI_DESIGN_RECETE_0 AS EDR0 ON EDPR.RELATED_PIECE_ROW_ID = EDR0.PIECE_ROW_ID
                    WHERE        
                        EDP.PIECE_TYPE = 3 AND 
                        EDPR.STOCK_ID IS NULL
                    GROUP BY 
                        EDP.DESIGN_ID, 
                        EDP.DESIGN_MAIN_ROW_ID, 
                        EDP.DESIGN_PACKAGE_ROW_ID, 
                        EDP.PIECE_ROW_ID, 
                        EDP.PIECE_TYPE, 
                        EDR0.STOCK_ID
                </cfif>
                UNION ALL
				<!---Parça Tipi Aksesuar Ürünü İse--->
                SELECT        
                    DESIGN_ID, 
                    DESIGN_MAIN_ROW_ID, 
                    DESIGN_PACKAGE_ROW_ID, 
                    PIECE_ROW_ID, 
                    PIECE_RELATED_ID AS STOCK_ID, 
                    PIECE_TYPE, 
                    PIECE_AMOUNT
                FROM            
                    EZGI_DESIGN_PIECE AS EDP
                WHERE        
                    PIECE_TYPE = 4
              	<!---Paket veya Modülün Sepetinde Aksesuar Ürünü İse--->
                UNION ALL
                SELECT        
                    DESIGN_ID, 
                    DESIGN_MAIN_ROW_ID, 
                    DESIGN_PACKAGE_ROW_ID, 
                    0 AS PIECE_ROW_ID, 
                    STOCK_ID, 
                    0 AS PIECE_TYPE, 
                    AMOUNT
                FROM            
                    EZGI_DESIGN_ALL_MATERIAL
            )
            AS EDR1 INNER JOIN
            STOCKS AS S ON EDR1.STOCK_ID = S.STOCK_ID INNER JOIN
            PRODUCT_UNIT AS P ON S.PRODUCT_UNIT_ID = P.PRODUCT_UNIT_ID
        WHERE 
            P.IS_MAIN = 1
            <cfif isdefined('attributes.design_id') and len(attributes.design_id)>        
                AND EDR1.DESIGN_ID = #attributes.design_id#
            </cfif>
            <cfif isdefined('attributes.design_main_row_id') and len(attributes.design_main_row_id)>
                AND EDR1.DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id#
            </cfif>
            <cfif isdefined('attributes.design_package_row_id') and len(attributes.design_package_row_id)>
                AND EDR1.DESIGN_PACKAGE_ROW_ID = #attributes.design_package_row_id#
            </cfif>
            <cfif isdefined('attributes.design_piece_row_id') and len(attributes.design_piece_row_id)>
                AND EDR1.PIECE_ROW_ID = #attributes.design_piece_row_id#
            </cfif>
        GROUP BY 
            EDR1.STOCK_ID, 
            S.PRODUCT_NAME, 
            S.PRODUCT_ID,
            S.PRODUCT_CODE,
            P.MAIN_UNIT
        ORDER BY
            s.PRODUCT_CODE
    </cfquery>
</cfif>
<cfset get_material_piece = queryNew("EZGI_TREE_ROW_TYPE, STOCK_ID, PRODUCT_ID, SPECT_MAIN_ID, PRODUCT_CODE, PRODUCT_NAME, MAIN_UNIT, AMOUNT, LINE_NUMBER, OPERATION_TYPE_ID","integer, integer, integer, integer, VarChar, VarChar, VarChar, Decimal, integer, integer") />
<cfoutput query="get_piece_standart_eklenti">
	<cfset FORMUL = get_piece_standart_eklenti.FORMUL>
    <cfset PRODUCT_ID = get_piece_standart_eklenti.PRODUCT_ID>
    <cfset PRODUCT_CODE = get_piece_standart_eklenti.PRODUCT_CODE>
    <cfset PRODUCT_NAME = get_piece_standart_eklenti.PRODUCT_NAME>
    <cfset STOCK_ID = get_piece_standart_eklenti.STOCK_ID>
    <cfset MAIN_UNIT = get_piece_standart_eklenti.MAIN_UNIT>
    <cfset SPECT_MAIN_ID = get_piece_standart_eklenti.SPECT_MAIN_ID>
    <cfloop query="get_piece_eklenti_material">
    	<cftry>
        	<cfset calc_amount = Evaluate('#FORMUL#')>
       		<cfcatch type="any">
                <script>
                  alert(#PRODUCT_NAME#+" Ürününün Formülünde Hata Var ");
               </script>            	
          	</cfcatch>
   		</cftry>
        <cftry>
    	<cfset Temp = QueryAddRow(get_material_piece)>
        <cfset Temp = QuerySetCell(get_material_piece, "EZGI_TREE_ROW_TYPE", 1)> <!---Ürün Ağacı Satır tipi Standart Eklenti pARÇA iÇİN--->
        <cfset Temp = QuerySetCell(get_material_piece, "STOCK_ID", stock_id)>
        <cfset Temp = QuerySetCell(get_material_piece, "PRODUCT_ID", product_id)>
        <cfset Temp = QuerySetCell(get_material_piece, "PRODUCT_CODE", product_code)>
        <cfset Temp = QuerySetCell(get_material_piece, "PRODUCT_NAME", product_name)>
        <cfset Temp = QuerySetCell(get_material_piece, "MAIN_UNIT", main_unit)>
        <cfset Temp = QuerySetCell(get_material_piece, "AMOUNT", calc_amount)>
        <cfset Temp = QuerySetCell(get_material_piece, "LINE_NUMBER", 0)>
        <cfset Temp = QuerySetCell(get_material_piece, "OPERATION_TYPE_ID", 0)>
        <cfset Temp = QuerySetCell(get_material_piece, "SPECT_MAIN_ID", SPECT_MAIN_ID)>
        	<cfcatch type="any">
                <script>
                  alert(#PRODUCT_NAME#+" Ürünününde hata var ");
               </script>            	
          	</cfcatch>
        </cftry>
    </cfloop>
</cfoutput>
<cfif package eq 1>
	<cfset get_material_package = queryNew("EZGI_TREE_ROW_TYPE, STOCK_ID, PRODUCT_ID, SPECT_MAIN_ID, PRODUCT_CODE, PRODUCT_NAME, MAIN_UNIT, AMOUNT, LINE_NUMBER, OPERATION_TYPE_ID","integer, integer, integer, integer, VarChar, VarChar, VarChar, Decimal, integer, integer") />
    <cfoutput query="get_package_standart_eklenti">
        <cfset FORMUL = get_package_standart_eklenti.FORMUL>
        <cfset PRODUCT_ID = get_package_standart_eklenti.PRODUCT_ID>
        <cfset PRODUCT_CODE = get_package_standart_eklenti.PRODUCT_CODE>
        <cfset PRODUCT_NAME = get_package_standart_eklenti.PRODUCT_NAME>
        <cfset STOCK_ID = get_package_standart_eklenti.STOCK_ID>
        <cfset MAIN_UNIT = get_package_standart_eklenti.MAIN_UNIT>
        <cfset SPECT_MAIN_ID = get_package_standart_eklenti.SPECT_MAIN_ID>
        <cfloop query="get_package_eklenti_material">
            <cftry>
                <cfset calc_amount = Evaluate('#FORMUL#')>
                <cfcatch type="any">
                    <script>
                      alert(#PRODUCT_NAME#+" Ürününün Formülünde Hata Var ");
                   </script>            	
                </cfcatch>
            </cftry>
            <cfset Temp = QueryAddRow(get_material_package)>
            <cfset Temp = QuerySetCell(get_material_package, "EZGI_TREE_ROW_TYPE", 2)> <!---Ürün Ağacı Satır tipi Standart Eklenti pAKET iÇİN--->
            <cfset Temp = QuerySetCell(get_material_package, "STOCK_ID", stock_id)>
            <cfset Temp = QuerySetCell(get_material_package, "PRODUCT_ID", product_id)>
            <cfset Temp = QuerySetCell(get_material_package, "PRODUCT_CODE", product_code)>
            <cfset Temp = QuerySetCell(get_material_package, "PRODUCT_NAME", product_name)>
            <cfset Temp = QuerySetCell(get_material_package, "MAIN_UNIT", main_unit)>
            <cfset Temp = QuerySetCell(get_material_package, "AMOUNT", calc_amount)>
            <cfset Temp = QuerySetCell(get_material_package, "LINE_NUMBER", 0)>
            <cfset Temp = QuerySetCell(get_material_package, "OPERATION_TYPE_ID", 0)>
            <cfset Temp = QuerySetCell(get_material_package, "SPECT_MAIN_ID", SPECT_MAIN_ID)>
        </cfloop>
    </cfoutput>
</cfif>
<cfquery name="get_material_2" dbtype="query">
	SELECT
    	EZGI_TREE_ROW_TYPE,
    	STOCK_ID, 
        PRODUCT_NAME, 
        PRODUCT_CODE,
        PRODUCT_ID,
        MAIN_UNIT,
        LINE_NUMBER,
        OPERATION_TYPE_ID,
        AMOUNT,
        SPECT_MAIN_ID
    FROM 
    	get_material_piece 
  	WHERE
    	AMOUNT >0
  	UNION ALL
    <cfif package eq 1>
        SELECT 
        	EZGI_TREE_ROW_TYPE, 
            STOCK_ID, 
            PRODUCT_NAME, 
            PRODUCT_CODE,
            PRODUCT_ID,
            MAIN_UNIT,
            LINE_NUMBER,
            OPERATION_TYPE_ID,
            AMOUNT,
            SPECT_MAIN_ID
        FROM 
            get_material_package 
      	where
        	AMOUNT >0 
        UNION ALL
    </cfif>
    SELECT 
    	0 as EZGI_TREE_ROW_TYPE,
    	STOCK_ID, 
        PRODUCT_NAME, 
        PRODUCT_CODE,
        PRODUCT_ID,
        MAIN_UNIT,
        LINE_NUMBER,
        OPERATION_TYPE_ID,
        AMOUNT,
        SPECT_MAIN_ID
   	FROM 
    	get_material_1
  	where
    	AMOUNT > 0
</cfquery>
<cfquery name="get_material_3" dbtype="query">
	SELECT
    	STOCK_ID, 
        PRODUCT_NAME, 
        PRODUCT_CODE,
        PRODUCT_ID,
        MAIN_UNIT,
        LINE_NUMBER,
        OPERATION_TYPE_ID,
        0 AS AMOUNT,
        SPECT_MAIN_ID
  	FROM
    	get_material_2	
	GROUP BY
    	STOCK_ID, 
        PRODUCT_NAME, 
        PRODUCT_CODE,
        PRODUCT_ID,
        MAIN_UNIT,
        LINE_NUMBER,
        OPERATION_TYPE_ID,
        SPECT_MAIN_ID
</cfquery>
<cfquery name="get_ezgi_paket_standart_eklenti" dbtype="query"> <!---Sadece Standart Paket Eklentileri--->
	SELECT
    	STOCK_ID, 
        PRODUCT_NAME, 
        PRODUCT_CODE,
        PRODUCT_ID,
        MAIN_UNIT,
        LINE_NUMBER,
        OPERATION_TYPE_ID,
        SPECT_MAIN_ID,
        SUM(AMOUNT) AS AMOUNT
  	FROM
    	get_material_2
  	WHERE
    	EZGI_TREE_ROW_TYPE = 2		
	GROUP BY
    	STOCK_ID, 
        PRODUCT_NAME, 
        PRODUCT_CODE,
        PRODUCT_ID,
        MAIN_UNIT,
        LINE_NUMBER,
        OPERATION_TYPE_ID,
        SPECT_MAIN_ID
</cfquery>
<cfquery name="get_ezgi_parca_standart_eklenti" dbtype="query"> <!---Sadece Standart Parça Eklentileri--->
	SELECT
    	STOCK_ID, 
        PRODUCT_NAME, 
        PRODUCT_CODE,
        PRODUCT_ID,
        MAIN_UNIT,
        LINE_NUMBER,
        OPERATION_TYPE_ID,
        SPECT_MAIN_ID,
        SUM(AMOUNT) AS AMOUNT
  	FROM
    	get_material_2
  	WHERE
    	EZGI_TREE_ROW_TYPE = 1		
	GROUP BY
    	STOCK_ID, 
        PRODUCT_NAME, 
        PRODUCT_CODE,
        PRODUCT_ID,
        MAIN_UNIT,
        LINE_NUMBER,
        OPERATION_TYPE_ID,
        SPECT_MAIN_ID
</cfquery>
<cfoutput query="get_material_3">
	<cfset 'PRODUCT_NAME_#STOCK_ID#' = PRODUCT_NAME>
    <cfset 'PRODUCT_CODE_#STOCK_ID#' = PRODUCT_CODE>
    <cfset 'PRODUCT_ID_#STOCK_ID#' = PRODUCT_ID>
    <cfset 'MAIN_UNIT_#STOCK_ID#' = MAIN_UNIT>
    <cfset 'LINE_NUMBER_#STOCK_ID#' = LINE_NUMBER>
    <cfset 'OPERATION_TYPE_ID_#STOCK_ID#' = OPERATION_TYPE_ID>
    <cfset 'AMOUNT_#STOCK_ID#' = 0>
    <cfset 'SPECT_MAIN_ID_#STOCK_ID#' = SPECT_MAIN_ID>
</cfoutput>
<cfoutput query="get_material_2">
	<cfif isdefined('AMOUNT_#STOCK_ID#') and AMOUNT gt 0>
    	<cfset 'AMOUNT_#STOCK_ID#' = Evaluate('AMOUNT_#STOCK_ID#') + AMOUNT>
    </cfif>
</cfoutput>
<cfset get_material = queryNew("STOCK_ID, PRODUCT_ID, SPECT_MAIN_ID, PRODUCT_CODE, PRODUCT_NAME, MAIN_UNIT, AMOUNT, LINE_NUMBER, OPERATION_TYPE_ID","integer, integer, integer, VarChar, VarChar, VarChar, Decimal, integer, integer") />
<cfoutput query="get_material_3">
	<cfif isdefined('AMOUNT_#STOCK_ID#') and Evaluate('AMOUNT_#STOCK_ID#') gt 0>
		<cfset calc_amount = Evaluate('AMOUNT_#STOCK_ID#')>
		<cfset Temp = QueryAddRow(get_material)>
        <cfset Temp = QuerySetCell(get_material, "STOCK_ID", stock_id)>
        <cfset Temp = QuerySetCell(get_material, "PRODUCT_ID", product_id)>
        <cfset Temp = QuerySetCell(get_material, "PRODUCT_CODE", product_code)>
        <cfset Temp = QuerySetCell(get_material, "PRODUCT_NAME", product_name)>
        <cfset Temp = QuerySetCell(get_material, "MAIN_UNIT", main_unit)>
        <cfset Temp = QuerySetCell(get_material, "AMOUNT", calc_amount)>
        <cfset Temp = QuerySetCell(get_material, "LINE_NUMBER", line_number)>
        <cfset Temp = QuerySetCell(get_material, "OPERATION_TYPE_ID", operation_type_id)>
        <cfif len(SPECT_MAIN_ID)>
        	<cfset Temp = QuerySetCell(get_material, "SPECT_MAIN_ID", SPECT_MAIN_ID)>
        <cfelse>
        	<cfset Temp = QuerySetCell(get_material, "SPECT_MAIN_ID", 0)>
        </cfif>
    </cfif>
</cfoutput>
