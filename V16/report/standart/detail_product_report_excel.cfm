<cfquery name="GET_PRODUCT1" datasource="#DSN1#">
		SELECT        
       		COMPANY_ID as "Sirket ID"
			<cfif ListFind(attributes.select_option,3) or ListFind(attributes.select_option,8)>
            	,PRODUCT_CODE AS "Ürün Kodu"
            </cfif>                          
            <cfif ListFind(attributes.select_option,2)>
            	<cfif attributes.sec eq 2>
                    ,PRODUCT_NAME AS "Ürün Adı"
                    , PROPERTY AS "Özellik"
                <cfelse>
                	,PRODUCT_NAME AS "Ürün Adı"
            	</cfif>
            </cfif>
            <cfif ListFind(attributes.select_option,27)>
            	,FULLNAME AS "Tedarikçi"
            </cfif>
            <cfif ListFind(attributes.select_option,23)>
            	,MAIN_UNIT AS "Ana Birim"
            </cfif>
            <cfif ListFind(attributes.select_option,26)>
           	 , ADD_UNIT_ADD AS "Ek Birimler"
            </cfif>
            <cfif ListFind(attributes.select_option,22)>
            	,SUB_BARCODES as "Alt Barkodlar"
            </cfif>  
            <cfif ListFind(attributes.select_option,1)>
            	,BARCOD AS "Barkod"
            </cfif>
            <cfif ListFind(attributes.select_option,7)>
            	,MANUFACT_CODE AS "Üretici Kodu"
            </cfif>
            <cfif ListFind(attributes.select_option,9)>
            	,BRAND_NAME AS "MARKA"
            </cfif>
            <cfif ListFind(attributes.select_option,10)>
            	,SHORT_CODE AS "Model"
            </cfif>
            <cfif ListFind(attributes.select_option,11)>
            	,PRODUCT_DETAIL AS "Açıklama"
            </cfif>
            <cfif ListFind(attributes.select_option,14)>
            	,TAX AS "Satış KDV"
            </cfif>
            <cfif ListFind(attributes.select_option,13)>
            	,TAX_PURCHASE AS "Alış KDV"
            </cfif>
            <cfif ListFind(attributes.select_option,15)>
           		 ,PRODUCT_MANAGER AS "Ürün Sorumlusu"
            </cfif>
            <cfif ListFind(attributes.select_option,16)>
            	,PRODUCT_CODE_2 AS "Özel Kod"
            </cfif>
            <cfif ListFind(attributes.select_option,4)>
            	, HIERARCHY AS "HIYERARSİ"
                ,PRODUCT_CAT AS "Kategori"
              <cfif ListFind(attributes.select_option,5)>
                , MAX_MARGIN AS "Net Marj"
                , MIN_MARGIN AS "Net Marj"
              </cfif>
            </cfif>           
            <cfif ListFind(attributes.select_option,19) or ListFind(attributes.select_option,20)>            
            	,convert(numeric(38,2),cast(PRICE1 AS float)) AS "ALIS FIYAT(KDV siz)"
            	,MONEY1 AS "PARA BIRIMI ALIS"
                ,convert(numeric(38,2),cast(PRICE2 AS float)) AS "SATIS FIYAT(KDV siz)"
            	,MONEY2 AS "PARA BIRIMI SATIS"
            </cfif>                        
            <cfif ListFind(attributes.select_option,6)>
				<cfif attributes.price_catid eq -1 or attributes.price_catid eq -2>               
                    , LIST_PRICE AS "LİSTE FİYATI"               
                <cfelse>                
                    , LIST_PRICE AS "LİSTE FİYATI"               
                </cfif>
             </cfif>   
             <cfif not isdefined('is_empty_price')>
              ,LIST_MONEY AS "LIST_MONEY"
             </cfif>
            <cfif ListFind(attributes.select_option,18)>          
            ,convert(numeric(38,2),cast(PRODUCT_COST AS float)) AS "MALİYET"
			,MONEY3 AS "Para birimi"
            </cfif>
            <cfif listFind(attributes.select_option,21)>
            	,SHELF_CODE AS "RAF"
            </cfif>
            
         FROM (
			<cfloop list="#attributes.our_comp#" index="comp_indx">
				SELECT
					P.COMPANY_ID COMPANY_ID, 
                     <cfif ListFind(attributes.select_option,18)>
                         (SELECT TOP 1 convert(numeric(38,2),cast(PRODUCT_COST AS float)) FROM #dsn3_alias#.PRODUCT_COST PRC WHERE PRC.PRODUCT_ID = P.PRODUCT_ID AND PRC.START_DATE < #now()#) PRODUCT_COST,
                         (SELECT TOP 1 MONEY FROM #dsn3_alias#.PRODUCT_COST PRC WHERE PRC.PRODUCT_ID = P.PRODUCT_ID AND PRC.START_DATE < #now()#) MONEY3,
                     </cfif>
                    <cfif ListFind(attributes.select_option,9)>
                     (SELECT DISTINCT BRAND_NAME FROM PRODUCT_BRANDS PB,PRODUCT_BRANDS_OUR_COMPANY PBO WHERE PB.BRAND_ID = PBO.BRAND_ID	AND PBO.OUR_COMPANY_ID = #session.ep.company_id# AND PB.BRAND_ID = P.BRAND_ID) BRAND_NAME,
                    </cfif>
                     <cfif ListFind(attributes.select_option,19) or ListFind(attributes.select_option,20)>
                        ( SELECT 
                        		TOP 1 convert(numeric(38,2),cast(PRICE AS float)) 
                        FROM 
                            PRICE_STANDART,
                            PRODUCT_UNIT
                        WHERE
                            PRICE_STANDART.PURCHASESALES = 0 AND
                            PRODUCT_UNIT.IS_MAIN = 1 AND 
                            PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
                            PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
                            PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND	
                            PRICE_STANDART.PRODUCT_ID = P.PRODUCT_ID) AS PRICE1,
                        (SELECT 
                        	TOP 1 convert(numeric(38,2),cast(PRICE AS float))                     
                        FROM
                            PRICE_STANDART,
                            PRODUCT_UNIT
                        WHERE
                            PRICE_STANDART.PURCHASESALES = 1 AND
                            PRODUCT_UNIT.IS_MAIN = 1 AND 
                            PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
                            PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
                            PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND	
                            PRICE_STANDART.PRODUCT_ID = P.PRODUCT_ID) PRICE2,
                            (SELECT 
                            	TOP 1 MONEY                            
                            FROM
                                PRICE_STANDART,
                                PRODUCT_UNIT
                            WHERE
                                PRICE_STANDART.PURCHASESALES = 1 AND
                                PRODUCT_UNIT.IS_MAIN = 1 AND 
                                PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
                                PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
                                PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND	
                                PRICE_STANDART.PRODUCT_ID = P.PRODUCT_ID) MONEY2,
                            (SELECT 
                            	TOP 1 MONEY 
                            FROM 
                            	#dsn3_alias#.PRICE_STANDART PS,
                                #dsn3_alias#.PRODUCT_UNIT PU,
                                #dsn3_alias#.PRODUCT_CAT PC 
                            WHERE  
                                P.PRODUCT_CATID = PC.PRODUCT_CATID 
                                AND P.PRODUCT_ID = PU.PRODUCT_ID AND
                                P.PRODUCT_STATUS = 1 AND
                                PS.PURCHASESALES = 0 AND
                                PS.PRICESTANDART_STATUS = 1 AND	
                                P.PRODUCT_ID = PS.PRODUCT_ID AND
                                PS.UNIT_ID = PU.PRODUCT_UNIT_ID and
                                PU.PRODUCT_ID=PU.PRODUCT_ID
                                AND  PU.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
                            ) MONEY1,
                     </cfif>
					<cfif attributes.sec eq 2>
						<cfif ListFind(attributes.select_option,3) or ListFind(attributes.select_option,8)>
							S.STOCK_CODE AS PRODUCT_CODE,
                        </cfif>
                        <cfif ListFind(attributes.select_option,2)>
							S.PROPERTY PROPERTY,
                        </cfif>
                        <cfif ListFind(attributes.select_option,1)>
							S.BARCOD BARCOD,
                        </cfif>
						S.STOCK_ID STOCK_ID,
					<cfelse>
	                    <cfif ListFind(attributes.select_option,3) or ListFind(attributes.select_option,8)>
							P.PRODUCT_CODE PRODUCT_CODE,
                        </cfif>
                        <cfif ListFind(attributes.select_option,1)>
							P.BARCOD BARCOD,
                        </cfif>
					</cfif>
                    <cfif ListFind(attributes.select_option,16)>
						P.PRODUCT_CODE_2 PRODUCT_CODE_2,
                    </cfif>
                    <cfif ListFind(attributes.select_option,7)>
						P.MANUFACT_CODE MANUFACT_CODE,
                    </cfif>
					P.PRODUCT_NAME PRODUCT_NAME,
					P.PRODUCT_ID PRODUCT_ID,
                    <cfif ListFind(attributes.select_option,14)>
						ISNULL((SELECT PT.TAX FROM #dsn#_#comp_indx#.PRODUCT_TAX PT WHERE PT.PRODUCT_ID = P.PRODUCT_ID AND PT.OUR_COMPANY_ID=#comp_indx#),P.TAX) TAX,
                    </cfif>
                    <cfif ListFind(attributes.select_option,13)>
						ISNULL((SELECT PT.TAX_PURCHASE FROM #dsn#_#comp_indx#.PRODUCT_TAX PT WHERE PT.PRODUCT_ID = P.PRODUCT_ID AND PT.OUR_COMPANY_ID=#comp_indx#),P.TAX_PURCHASE) TAX_PURCHASE,
                    </cfif>
					<cfif attributes.sec eq 1>
						P.PRODUCT_STATUS STATUS_INFO,
					<cfelse>
						S.STOCK_STATUS STATUS_INFO,
					</cfif>
                    <cfif ListFind(attributes.select_option,15)>
						P.PRODUCT_MANAGER PRODUCT_MANAGER,
                    </cfif>
                    <cfif ListFind(attributes.select_option,10)>
						P.SHORT_CODE SHORT_CODE,
                    </cfif>
					<cfif ListFind(attributes.select_option,4)>
                        PC.HIERARCHY HIERARCHY,
                        PC.PRODUCT_CAT PRODUCT_CAT,
                    </cfif>
                    <cfif ListFind(attributes.select_option,11)>
						P.PRODUCT_DETAIL PRODUCT_DETAIL,
                    </cfif>
                  
					P.RECORD_DATE RECORD_DATE,
					P.UPDATE_DATE UPDATE_DATE,
					P.PROD_COMPETITIVE PROD_COMPETITIVE,
                    <cfif ListFind(attributes.select_option,5)>
                        P.MAX_MARGIN MAX_MARGIN,
                        P.MIN_MARGIN MIN_MARGIN,
                    </cfif>
					P.IS_ZERO_STOCK IS_ZERO_STOCK,
					PS.PRICE PRICE,
					PS.PRICE_KDV PRICE_KDV,
					PS.IS_KDV IS_KDV,
					PS.MONEY MONEY,
					PU.ADD_UNIT ADD_UNIT,
                    <cfif ListFind(attributes.select_option,23)>
						PU.MAIN_UNIT MAIN_UNIT,
                    </cfif>
					PU.MULTIPLIER MULTIPLIER,
					PU.DIMENTION DIMENTION,
					PU.WEIGHT WEIGHT,
					PU.PRODUCT_UNIT_ID PRODUCT_UNIT_ID
					<cfif listFind(attributes.select_option,21)>
						,PP.SHELF_CODE SHELF_CODE
					</cfif>
                    ,
                    <cfif attributes.price_catid eq -1 or attributes.price_catid eq -2>
                    	PS.PRODUCT_ID AS PRODUCT_ID1,
                        0 AS LIST_PRICE,
                        '' AS LIST_MONEY,
                    <cfelse>
                        PRICE.PRODUCT_ID AS PRODUCT_ID1,
                        PRICE.PRICE AS LIST_PRICE,
                        PRICE.MONEY AS LIST_MONEY,
                    </cfif>
                     COMPANY.FULLNAME FULLNAME,
                   	 PRODUCT_UNIT_ADD.ADD_UNIT_ADD ADD_UNIT_ADD
                    <cfif ListFind(attributes.select_option,22)>
                    ,DD5.MY_BARCODE SUB_BARCODES
                    </cfif>
					FROM 
						PRODUCT P                       
                          <cfif ListFind(attributes.select_option,22) AND attributes.sec eq 1>
                        	LEFT JOIN  <!--- ALT BARKODLARI ÇEKMEK İÇİN EKLENDİ --->
                                 (

                                    SELECT D5.PRODUCT_ID,
                                    stuff( (
                                                    SELECT 
                                                        ';'+BARCODE AS BARCODE
                                                               
                                                        FROM 
                                                           #dsn3_alias#.STOCKS_BARCODES,
                                                            STOCKS S
                                                        WHERE
                                                            S.STOCK_ID = STOCKS_BARCODES.STOCK_ID
                                                            AND D5.PRODUCT_ID = S.PRODUCT_ID
                                                   FOR XML PATH(''), TYPE).value('.', 'varchar(1000)'),1,1,'')
                                           AS MY_BARCODE
                                           FROM 
                                           PRODUCT D5
                                    ) AS DD5
                                 ON
                                    DD5.PRODUCT_ID = P.PRODUCT_ID
                       </cfif>
                    LEFT JOIN
                           (
                       		 Select 
								 distinct ST2.PRODUCT_ID,
                                 substring(
                                            (
                                                Select 
                    
                                                    ';'+CONVERT( NVARCHAR(10),ST1.ADD_UNIT )+':'+CONVERT(NVARCHAR(10),ST1.DIMENTION)+':'+ CONVERT(NVARCHAR(50),ST1.MULTIPLIER)    AS [text()]
                                                From
                     
                                                        (
                                                            SELECT 
                                                                PRODUCT_ID,
                                                                CASE WHEN
                                                                	LEN(ADD_UNIT) > 0 THEN ADD_UNIT ELSE '-' END AS ADD_UNIT  ,
                                                                CASE WHEN
                                                                	LEN(DIMENTION) > 0 THEN DIMENTION ELSE '-' END AS DIMENTION  ,
                                                                CASE WHEN
                                                                	LEN(MULTIPLIER) > 0 THEN MULTIPLIER ELSE '-' END AS MULTIPLIER  
                                                               
                                                                
                                                             FROM 
                                                                 #dsn3_alias#.PRODUCT_UNIT
                                                             WHERE IS_MAIN =  0 
                                                ) ST1 
                                                Where
                                                    ST1.PRODUCT_ID = ST2.PRODUCT_ID
                                                ORDER BY 
                                                    ST1.PRODUCT_ID For XML PATH ('')
                                            )
                                            ,2, 1000
                                        ) ADD_UNIT_ADD
                                 
                                     From (
                                            SELECT 
                                                    PRODUCT_ID,
                                                    CASE WHEN
                                                        LEN(ADD_UNIT) > 0 THEN ADD_UNIT ELSE '-' END AS ADD_UNIT  ,
                                                    CASE WHEN
                                                        LEN(DIMENTION) > 0 THEN DIMENTION ELSE '-' END AS DIMENTION  ,
                                                    CASE WHEN
                                                        LEN(MULTIPLIER) > 0 THEN MULTIPLIER ELSE '-' END AS MULTIPLIER  
                                             FROM 
                                                    #dsn3_alias#.PRODUCT_UNIT
                                             WHERE IS_MAIN =  0
                                     
                                     		) ST2 
                         ) AS PRODUCT_UNIT_ADD
                    ON 
                    	PRODUCT_UNIT_ADD.PRODUCT_ID = P.PRODUCT_ID 
                    <cfif attributes.price_catid eq -1 or attributes.price_catid eq -2>
                    <cfelse>
						<cfif attributes.is_empty_price eq 0 or attributes.is_empty_price eq -1> LEFT </cfif>
                            JOIN #DSN3_alias#.PRICE ON 
                            PRICE.PRODUCT_ID = P.PRODUCT_ID AND 
                            <cfif attributes.is_empty_price neq -1> 
                            	PRICE.PRICE_CATID = #attributes.price_catid# AND 
                            </cfif>
                            PRICE.STARTDATE <= #now()# 
                            AND (PRICE.FINISHDATE >= #now()# OR PRICE.FINISHDATE IS NULL)
                            <!--- <cfif attributes.is_empty_price eq -1>
                                 --  AND PRICE.PRODUCT_ID IS NULL  
                             <cfelseif attributes.is_empty_price eq 1>
                                    --AND PRICE.PRODUCT_ID IS NOT NULL  
                             </cfif>--->
                        </cfif>
                    LEFT JOIN
                    	 #DSN_ALIAS#.COMPANY 
                    ON
                    	COMPANY.COMPANY_ID = P.COMPANY_ID
                    , 
					#dsn3_alias#.PRICE_STANDART PS,
					#dsn3_alias#.PRODUCT_UNIT PU,
					#dsn3_alias#.PRODUCT_CAT PC
					<cfif attributes.sec eq 2>,#dsn3_alias#.STOCKS S
                    
                     <cfif ListFind(attributes.select_option,22)>
                        	LEFT JOIN  <!--- ALT BARKODLARI ÇEKMEK İÇİN EKLENDİ --->
                                 (
                                    SELECT D5.STOCK_ID,
                                     D5.PRODUCT_UNIT_ID,
                                    stuff( (
                                                    SELECT 
                                                       
                                                        ';'+BARCODE AS BARCODE
                                                               
                                                        FROM 
                                                            #dsn3_alias#.STOCKS_BARCODES
                                                            WHERE
                                                             D5.STOCK_ID = STOCK_ID
                                                   FOR XML PATH(''), TYPE).value('.', 'varchar(1000)'),1,1,'')
                                           AS MY_BARCODE
                                           FROM STOCKS  D5
                                    ) AS DD5
                                 ON
                                    DD5.STOCK_ID = S.STOCK_ID
                       </cfif>
                    </cfif>
					,#dsn1_alias#.PRODUCT_OUR_COMPANY AS PRODUCT_OUR_COMPANY
					<cfif listFind(attributes.select_option,21)>
					,#dsn3_alias#.PRODUCT_PLACE PP
					</cfif>
				WHERE
                	<cfif ListFind(attributes.select_option,22) AND  attributes.sec eq 2>
                            DD5.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                        </cfif>
                	<cfif attributes.price_catid eq -1 or attributes.price_catid eq -2> 
                    <cfelse>
						<cfif attributes.is_empty_price eq -1>
                          P.PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM #DSN3_ALIAS#.PRICE WHERE PRICE_CATID = #attributes.price_catid#  AND STARTDATE <= #now()#  AND (FINISHDATE >= #now()# OR FINISHDATE IS NULL)) AND
                        </cfif>
                    </cfif>
					<cfif attributes.sec eq 2> S.PRODUCT_ID = P.PRODUCT_ID AND </cfif>
					P.PRODUCT_ID=PRODUCT_OUR_COMPANY.PRODUCT_ID AND
					PRODUCT_OUR_COMPANY.OUR_COMPANY_ID  = #comp_indx# AND
					<cfif listFind(attributes.select_option,21)>
						PP.PLACE_STATUS = 1 AND
						PP.PRODUCT_ID = P.PRODUCT_ID AND
					</cfif>
					P.PRODUCT_CATID = PC.PRODUCT_CATID AND
					P.PRODUCT_ID = PU.PRODUCT_ID AND
					<cfif attributes.price_catid eq -1 or attributes.price_catid eq -2>
                        PS.PURCHASESALES = <cfif isDefined("attributes.price_catid") and (attributes.price_catid eq -1)>0<cfelse>1</cfif> AND
                    <cfelse>
                        PS.PURCHASESALES = 1 AND
                    </cfif>
					PS.PRICESTANDART_STATUS = 1 AND	
					P.PRODUCT_ID = PS.PRODUCT_ID AND
					PS.UNIT_ID = PU.PRODUCT_UNIT_ID
					<cfif isdefined('attributes.company_id') and len(attributes.company_id) and  len(attributes.company)>AND P.COMPANY_ID = #attributes.company_id#</cfif> 
					<cfif len(attributes.pos_code)>AND P.PRODUCT_MANAGER IN (#attributes.pos_code#)</cfif> 
					<cfif isdefined('attributes.category')>
						<cfif ListFind(attributes.category,1)>AND P.IS_INVENTORY = 1</cfif>
						<cfif ListFind(attributes.category,2)>AND P.IS_PRODUCTION = 1</cfif>
						<cfif ListFind(attributes.category,3)>AND P.IS_SALES = 1</cfif>
						<cfif ListFind(attributes.category,4)>AND P.IS_PURCHASE = 1</cfif>
						<cfif ListFind(attributes.category,5)>AND P.IS_PROTOTYPE = 1</cfif>
						<cfif ListFind(attributes.category,6)>AND P.IS_INTERNET = 1</cfif>
						<cfif ListFind(attributes.category,7)>AND P.IS_EXTRANET = 1</cfif>
						<cfif ListFind(attributes.category,8)>AND P.IS_TERAZI = 1</cfif>
						<cfif ListFind(attributes.category,9)>AND P.IS_SERIAL_NO = 1</cfif>
						<cfif ListFind(attributes.category,10)>AND P.IS_ZERO_STOCK = 1</cfif>
						<cfif ListFind(attributes.category,11)>AND P.IS_KARMA = 1</cfif>
						<cfif ListFind(attributes.category,12)>AND P.IS_COST = 1</cfif>
                        <cfif ListFind(attributes.category,13)>AND P.IS_LIMITED_STOCK = 1</cfif>
                        <cfif ListFind(attributes.category,14)>AND P.IS_QUALITY = 1</cfif>
					</cfif>
					<cfif len(attributes.marks)>AND P.BRAND_ID IN (#attributes.marks#)</cfif>
					<cfif attributes.sec eq 1 and attributes.status neq 2>AND P.PRODUCT_STATUS = #attributes.status#<!--- ürün-stok seçeneklerine ürünün veya stoğun aktifliğine bakar. --->
					<cfelseif attributes.sec eq 2 and attributes.status neq 2>AND S.STOCK_STATUS = #attributes.status#</cfif>
					<cfif len(attributes.cat)>
						 AND(
						 <cfloop from="1" to="#listlen(attributes.cat)#" index="c"> 
							(P.PRODUCT_CODE LIKE '#ListGetAt(attributes.cat,c,',')#.%')
							 <cfif C neq listlen(attributes.cat)>OR</cfif>
						</cfloop>)
					</cfif>
					<cfif len(attributes.SEGMENT_ID)>AND P.SEGMENT_ID IN(#attributes.segment_id#)</cfif>
				<cfif listFind(attributes.select_option,21)>
					UNION ALL
					SELECT DISTINCT
						P.COMPANY_ID COMPANY_ID, 
                         <cfif ListFind(attributes.select_option,18)>
                         (SELECT TOP 1 convert(numeric(38,2),cast(PRODUCT_COST AS float)) FROM #dsn3_alias#.PRODUCT_COST PRC WHERE PRC.PRODUCT_ID = P.PRODUCT_ID AND PRC.START_DATE < #now()#) PRODUCT_COST,
                         (SELECT TOP 1 MONEY FROM #dsn3_alias#.PRODUCT_COST PRC WHERE PRC.PRODUCT_ID = P.PRODUCT_ID AND PRC.START_DATE < #now()#) MONEY3,
                     </cfif>
                    <cfif ListFind(attributes.select_option,9)>
                     (SELECT DISTINCT BRAND_NAME FROM PRODUCT_BRANDS PB,PRODUCT_BRANDS_OUR_COMPANY PBO WHERE PB.BRAND_ID = PBO.BRAND_ID	AND PBO.OUR_COMPANY_ID = #session.ep.company_id# AND PB.BRAND_ID = P.BRAND_ID) BRAND_NAME,
                    </cfif>
                     <cfif ListFind(attributes.select_option,19) or ListFind(attributes.select_option,20)>
                        ( SELECT 
                        		TOP 1 convert(numeric(38,2),cast(PRICE AS float)) 
                        FROM 
                            PRICE_STANDART,
                            PRODUCT_UNIT
                        WHERE
                            PRICE_STANDART.PURCHASESALES = 0 AND
                            PRODUCT_UNIT.IS_MAIN = 1 AND 
                            PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
                            PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
                            PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND	
                            PRICE_STANDART.PRODUCT_ID = P.PRODUCT_ID) AS PRICE1,
                        (SELECT 
                        	TOP 1 convert(numeric(38,2),cast(PRICE AS float))                     
                        FROM
                            PRICE_STANDART,
                            PRODUCT_UNIT
                        WHERE
                            PRICE_STANDART.PURCHASESALES = 1 AND
                            PRODUCT_UNIT.IS_MAIN = 1 AND 
                            PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
                            PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
                            PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND	
                            PRICE_STANDART.PRODUCT_ID = P.PRODUCT_ID) PRICE2,
                            (SELECT 
                            	TOP 1 MONEY                            
                            FROM
                                PRICE_STANDART,
                                PRODUCT_UNIT
                            WHERE
                                PRICE_STANDART.PURCHASESALES = 1 AND
                                PRODUCT_UNIT.IS_MAIN = 1 AND 
                                PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
                                PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
                                PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND	
                                PRICE_STANDART.PRODUCT_ID = P.PRODUCT_ID) MONEY2,
                            (SELECT 
                            	TOP 1 MONEY 
                            FROM 
                            	#dsn3_alias#.PRICE_STANDART PS,
                                #dsn3_alias#.PRODUCT_UNIT PU,
                                #dsn3_alias#.PRODUCT_CAT PC 
                            WHERE  
                                P.PRODUCT_CATID = PC.PRODUCT_CATID 
                                AND P.PRODUCT_ID = PU.PRODUCT_ID AND
                                P.PRODUCT_STATUS = 1 AND
                                PS.PURCHASESALES = 0 AND
                                PS.PRICESTANDART_STATUS = 1 AND	
                                P.PRODUCT_ID = PS.PRODUCT_ID AND
                                PS.UNIT_ID = PU.PRODUCT_UNIT_ID and
                                PU.PRODUCT_ID=PU.PRODUCT_ID
                                AND  PU.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
                            ) MONEY1,
                     </cfif>
						<cfif attributes.sec eq 2>
	                        <cfif ListFind(attributes.select_option,3) or ListFind(attributes.select_option,8)>
								S.STOCK_CODE AS PRODUCT_CODE,
                            </cfif>
                            <cfif ListFind(attributes.select_option,2)>
								S.PROPERTY PROPERTY,
                            </cfif>
                            <cfif ListFind(attributes.select_option,1)>
								S.BARCOD BARCOD,
                            </cfif>
							S.STOCK_ID STOCK_ID,
						<cfelse> 
	                        <cfif ListFind(attributes.select_option,3) or ListFind(attributes.select_option,8)>
								P.PRODUCT_CODE PRODUCT_CODE,
                            </cfif>
                            <cfif ListFind(attributes.select_option,1)>
								P.BARCOD BARCOD,
                            </cfif>
						</cfif>
                        <cfif ListFind(attributes.select_option,16)>
							P.PRODUCT_CODE_2 PRODUCT_CODE_2,
                        </cfif>
                        <cfif ListFind(attributes.select_option,7)>
							P.MANUFACT_CODE MANUFACT_CODE,
                        </cfif>
						P.PRODUCT_NAME PRODUCT_NAME,
						P.PRODUCT_ID PRODUCT_ID,
                        <cfif ListFind(attributes.select_option,14)>
							ISNULL((SELECT PT.TAX FROM #dsn#_#comp_indx#.PRODUCT_TAX PT WHERE PT.PRODUCT_ID = P.PRODUCT_ID AND PT.OUR_COMPANY_ID=#comp_indx#),P.TAX) TAX,
                        </cfif>
                        <cfif ListFind(attributes.select_option,13)>
							ISNULL((SELECT PT.TAX_PURCHASE FROM #dsn#_#comp_indx#.PRODUCT_TAX PT WHERE PT.PRODUCT_ID = P.PRODUCT_ID AND PT.OUR_COMPANY_ID=#comp_indx#),P.TAX_PURCHASE) TAX_PURCHASE,
                        </cfif>
						<cfif attributes.sec eq 1>
							P.PRODUCT_STATUS STATUS_INFO,
						<cfelse>
							S.STOCK_STATUS STATUS_INFO,
						</cfif>
                        <cfif ListFind(attributes.select_option,15)>
							P.PRODUCT_MANAGER PRODUCT_MANAGER,
                        </cfif>
                        <cfif ListFind(attributes.select_option,10)>
							P.SHORT_CODE SHORT_CODE,
                        </cfif>
						<cfif ListFind(attributes.select_option,4)>
                            PC.HIERARCHY HIERARCHY,
                            PC.PRODUCT_CAT PRODUCT_CAT,
                        </cfif>
                        <cfif ListFind(attributes.select_option,11)>
							P.PRODUCT_DETAIL PRODUCT_DETAIL,
                        </cfif>
                    
						P.RECORD_DATE RECORD_DATE,
						P.UPDATE_DATE UPDATE_DATE,
						P.PROD_COMPETITIVE PROD_COMPETITIVE,
                        <cfif ListFind(attributes.select_option,9)>
                            P.MAX_MARGIN MAX_MARGIN,
                            P.MIN_MARGIN MIN_MARGIN,
                        </cfif>
						P.IS_ZERO_STOCK IS_ZERO_STOCK,
						PS.PRICE PRICE,
						PS.PRICE_KDV PRICE_KDV,
						PS.IS_KDV IS_KDV,
						PS.MONEY MONEY,
						PU.ADD_UNIT ADD_UNIT,
                        <cfif ListFind(attributes.select_option,23)>
							PU.MAIN_UNIT MAIN_UNIT,
                        </cfif>
						PU.MULTIPLIER MULTIPLIER,
						PU.DIMENTION DIMENTION,
						PU.WEIGHT WEIGHT,
						PU.PRODUCT_UNIT_ID PRODUCT_UNIT_ID
						,'' AS SHELF_CODE
                         ,
                         <cfif attributes.price_catid eq -1 or attributes.price_catid eq -2>
                            PS.PRODUCT_ID AS PRODUCT_ID1,
                            0 AS LIST_PRICE,
                            '' AS LIST_MONEY,
                    	<cfelse>
                             PRICE.PRODUCT_ID AS PRODUCT_ID1 ,
                             PRICE.PRICE AS LIST_PRICE,
                             PRICE.MONEY AS LIST_MONEY,
                         </cfif>
                         COMPANY.FULLNAME FULLNAME,
                         PRODUCT_UNIT_ADD.ADD_UNIT_ADD ADD_UNIT_ADD
                           <cfif ListFind(attributes.select_option,22)>
                                ,DD5.MY_BARCODE SUB_BARCODES
                            </cfif>
					FROM 
						PRODUCT P                      
                         <cfif ListFind(attributes.select_option,22) AND attributes.sec eq 1>
                        	LEFT JOIN  <!--- ALT BARKODLARI ÇEKMEK İÇİN EKLENDİ --->
                                 (
                                    SELECT D5.PRODUCT_ID,                                    
                                    stuff( (
                                                    SELECT 
                                                        ';'+BARCODE  AS BARCODE
                                                        FROM 
                                                            #dsn3_alias#.STOCKS_BARCODES,
                                                            STOCKS S
                                                        WHERE
                                                            S.STOCK_ID = STOCKS_BARCODES.STOCK_ID
                                                            AND D5.PRODUCT_ID = S.PRODUCT_ID
                                                   FOR XML PATH(''), TYPE).value('.', 'varchar(1000)'),1,1,'')
                                           AS MY_BARCODE
                                           FROM PRODUCT  D5
                                    ) AS DD5
                                 ON
                                    DD5.PRODUCT_ID = P.PRODUCT_ID
                       </cfif>
                       LEFT JOIN
                        (
                       		 Select 
								distinct ST2.PRODUCT_ID,
							 substring(
										(
											Select 
				
												';'+CONVERT( NVARCHAR(10),ST1.ADD_UNIT )+':'+CONVERT(NVARCHAR(10),ST1.DIMENTION)+':'+ CONVERT(NVARCHAR(50),ST1.MULTIPLIER)    AS [text()]
											From
				 
				 									(
                                                    	SELECT 
                                                         		PRODUCT_ID,
                                                                CASE WHEN
                                                                    LEN(ADD_UNIT) > 0 THEN ADD_UNIT ELSE '-' END AS ADD_UNIT  ,
                                                                CASE WHEN
                                                                    LEN(DIMENTION) > 0 THEN DIMENTION ELSE '-' END AS DIMENTION  ,
                                                                CASE WHEN
                                                                    LEN(MULTIPLIER) > 0 THEN MULTIPLIER ELSE '-' END AS MULTIPLIER  
                                  
                                                         FROM 
                                                             #dsn3_alias#.PRODUCT_UNIT
                                                         WHERE IS_MAIN =  0 
				 							) ST1 
                                            Where
                                                ST1.PRODUCT_ID = ST2.PRODUCT_ID
                                            ORDER BY 
                                                ST1.PRODUCT_ID For XML PATH ('')
                                   		)
                 						,2, 1000
                 					) ADD_UNIT_ADD
                                 
                     From (
                                    SELECT 
                                            PRODUCT_ID,
                                            CASE WHEN
                                                LEN(ADD_UNIT) > 0 THEN ADD_UNIT ELSE '-' END AS ADD_UNIT  ,
                                            CASE WHEN
                                                LEN(DIMENTION) > 0 THEN DIMENTION ELSE '-' END AS DIMENTION  ,
                                            CASE WHEN
                                                LEN(MULTIPLIER) > 0 THEN MULTIPLIER ELSE '-' END AS MULTIPLIER  
               
                                     FROM 
                                            #dsn3_alias#.PRODUCT_UNIT
                                     WHERE IS_MAIN =  0
                     
                     ) ST2 

                         ) AS PRODUCT_UNIT_ADD
                    ON 
                    	PRODUCT_UNIT_ADD.PRODUCT_ID = P.PRODUCT_ID 
                    <cfif attributes.price_catid eq -1 or attributes.price_catid eq -2>
                    <cfelse>
						<cfif attributes.is_empty_price eq 0 or attributes.is_empty_price eq -1>
                            LEFT
                        </cfif>
                    		JOIN #DSN3_alias#.PRICE ON 
                            PRICE.PRODUCT_ID = P.PRODUCT_ID AND  
                            <cfif attributes.is_empty_price neq -1>
                            PRICE.PRICE_CATID = #attributes.price_catid# AND 
                            </cfif>
                            PRICE.STARTDATE <= #now()# 
                            AND (PRICE.FINISHDATE >= #now()# OR PRICE.FINISHDATE IS NULL)
                       <!--- <cfif attributes.is_empty_price eq -1>
                        	AND PRICE.PRODUCT_ID IS NULL  
                        <cfelseif attributes.is_empty_price eq 1>
                        	AND PRICE.PRODUCT_ID IS NOT NULL  
                        </cfif>--->
                     </cfif>
                         LEFT JOIN
                    		 #DSN_ALIAS#.COMPANY 
                    	ON
                    		COMPANY.COMPANY_ID = P.COMPANY_ID
                        , 
						#dsn3_alias#.PRICE_STANDART PS,
						#dsn3_alias#.PRODUCT_UNIT PU,
						#dsn3_alias#.PRODUCT_CAT PC
						<cfif attributes.sec eq 2>,#dsn3_alias#.STOCKS S
                           <cfif ListFind(attributes.select_option,22)>
                        	LEFT JOIN  <!--- ALT BARKODLARI ÇEKMEK İÇİN EKLENDİ --->
                                 (
                                    SELECT D5.STOCK_ID,
                                     D5.PRODUCT_UNIT_ID,
                                    stuff( (
                                                    SELECT 
                                                       
                                                        ';'+BARCODE  AS BARCODE
                                                               
                                                        FROM 
                                                            #dsn3_alias#.STOCKS_BARCODES
                                                         WHERE
                                                          D5.STOCK_ID = STOCK_ID
                                                   FOR XML PATH(''), TYPE).value('.', 'varchar(1000)'),1,1,'')
                                           AS MY_BARCODE
                                           FROM STOCKS  D5
                                    ) AS DD5
                                 ON
                                    DD5.STOCK_ID = S.STOCK_ID
                       </cfif>
                        </cfif>
						,#dsn1_alias#.PRODUCT_OUR_COMPANY AS PRODUCT_OUR_COMPANY
					WHERE 
						<cfif ListFind(attributes.select_option,22) AND  attributes.sec eq 2>
                            DD5.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                        </cfif>
						<cfif attributes.price_catid eq -1 or attributes.price_catid eq -2> 
                        <cfelse>
                            <cfif attributes.is_empty_price eq -1>
                              P.PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM #DSN3_ALIAS#.PRICE WHERE PRICE_CATID = #attributes.price_catid#  AND STARTDATE <= #now()#  AND (FINISHDATE >= #now()# OR FINISHDATE IS NULL)) AND
                            </cfif>
                        </cfif>
						<cfif attributes.sec eq 2> S.PRODUCT_ID = P.PRODUCT_ID AND </cfif>
						P.PRODUCT_ID=PRODUCT_OUR_COMPANY.PRODUCT_ID AND
						PRODUCT_OUR_COMPANY.OUR_COMPANY_ID  = #comp_indx# AND
						<cfif listFind(attributes.select_option,21)>
							P.PRODUCT_ID NOT IN(SELECT PRODUCT_ID FROM #dsn3_alias#.PRODUCT_PLACE WHERE PRODUCT_ID IS NOT NULL) AND
						</cfif>
						P.PRODUCT_CATID = PC.PRODUCT_CATID AND
						P.PRODUCT_ID = PU.PRODUCT_ID AND
						<cfif attributes.price_catid eq -1 or attributes.price_catid eq -2>
                            PS.PURCHASESALES = <cfif isDefined("attributes.price_catid") and (attributes.price_catid eq -1)>0<cfelse>1</cfif> AND
                        <cfelse>
                            PS.PURCHASESALES = 1 AND
                        </cfif>
						PS.PRICESTANDART_STATUS = 1 AND	
						P.PRODUCT_ID = PS.PRODUCT_ID AND
						PS.UNIT_ID = PU.PRODUCT_UNIT_ID
						<cfif len(attributes.company)>AND P.COMPANY_ID = #attributes.company_id#</cfif> 
						<cfif len(attributes.pos_code)>AND P.PRODUCT_MANAGER IN (#attributes.pos_code#)</cfif> 
						<cfif isdefined('attributes.category')>
							<cfif ListFind(attributes.category,1)>AND P.IS_INVENTORY = 1</cfif>
							<cfif ListFind(attributes.category,2)>AND P.IS_PRODUCTION = 1</cfif>
							<cfif ListFind(attributes.category,3)>AND P.IS_SALES = 1</cfif>
							<cfif ListFind(attributes.category,4)>AND P.IS_PURCHASE = 1</cfif>
							<cfif ListFind(attributes.category,5)>AND P.IS_PROTOTYPE = 1</cfif>
							<cfif ListFind(attributes.category,6)>AND P.IS_INTERNET = 1</cfif>
							<cfif ListFind(attributes.category,7)>AND P.IS_EXTRANET = 1</cfif>
							<cfif ListFind(attributes.category,8)>AND P.IS_TERAZI = 1</cfif>
							<cfif ListFind(attributes.category,9)>AND P.IS_SERIAL_NO = 1</cfif>
							<cfif ListFind(attributes.category,10)>AND P.IS_ZERO_STOCK = 1</cfif>
							<cfif ListFind(attributes.category,11)>AND P.IS_KARMA = 1</cfif>
							<cfif ListFind(attributes.category,12)>AND P.IS_COST = 1</cfif>
                            <cfif ListFind(attributes.category,13)>AND P.IS_LIMITED_STOCK = 1</cfif>
                            <cfif ListFind(attributes.category,14)>AND P.IS_QUALITY = 1</cfif>
						</cfif>
						<cfif len(attributes.marks)>AND P.BRAND_ID IN (#attributes.marks#)</cfif>
						<cfif attributes.sec eq 1 and attributes.status neq 2>AND P.PRODUCT_STATUS = #attributes.status#
						<cfelseif attributes.sec eq 2 and attributes.status neq 2>AND S.STOCK_STATUS = #attributes.status#</cfif>
						<cfif len(attributes.cat)>
							 AND(
							 <cfloop from="1" to="#listlen(attributes.cat)#" index="c"> 
								(P.PRODUCT_CODE LIKE '#ListGetAt(attributes.cat,c,',')#.%')
								 <cfif C neq listlen(attributes.cat)>OR</cfif>
							</cfloop>)
						</cfif>
						<cfif len(attributes.SEGMENT_ID)>AND P.SEGMENT_ID IN(#attributes.segment_id#)</cfif>	
				</cfif>
		<cfif comp_indx neq listlast(attributes.our_comp)>UNION ALL</cfif>
		</cfloop>
		) T1
	ORDER BY 
		PRODUCT_NAME
	</cfquery>     
<cfif not DirectoryExists("#upload_folder#/reserve_files/#dateFormat(now(),'yyyymmdd')#")>
	<cfdirectory action="create" directory="#upload_folder#/reserve_files/#dateFormat(now(),'yyyymmdd')#">
</cfif>
<cfset file_name = "detail_product_report_#session.ep.userid#_#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#.xls">
<cfspreadsheet action="write"  filename="#upload_folder#/reserve_files/#dateFormat(now(),'yyyymmdd')#/#file_name#" QUERY="GET_PRODUCT1"  
sheet=1 sheetname="Detayli Urun" overwrite=true> 
<script type="text/javascript">
    <cfoutput>
        get_wrk_message_div("Excel","Excel","documents/reserve_files/#dateFormat(now(),'yyyymmdd')#/#file_name#") ;
    </cfoutput>
</script>