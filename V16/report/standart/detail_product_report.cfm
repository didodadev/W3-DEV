<cfparam name="attributes.module_id_control" default="5">
<cfsetting showdebugoutput="yes">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.sec" default="1">
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.price_catid" default="-2">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.companys" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.our_comp" default="">
<cfparam name="attributes.segment_id" default="">
<cfparam name="attributes.marks" default="">
<cfparam name="attributes.category" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.is_form_submited" default="">
<cfparam name="attributes.select_option" default="0">
<cfparam name="attributes.is_empty_price" default="0">
<cfparam name="company_id_list" default="">
<cfparam name="attributes.list_variation_id" default="">
<cfparam name="attributes.list_property_value" default="">
<cfparam name="attributes.list_property_id" default="">
<cfparam name="attributes.cat_id" default="">

<cfset get_property = createObject("component", "V16.product.cfc.get_product")>
<cfset get_property.dsn1 = dsn1>
<cfset get_property_variation = get_property.get_property_variation()>

<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
	<cfinclude template="detail_product_report_excel.cfm">
</cfif>
<cfquery name="GET_OUR_COMPANIES" datasource="#DSN#"><!--- Ürünlerin Satıldığı Şirketler --->
	SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY
</cfquery>
<cfquery name="GET_SEGMENTS" datasource="#dsn1#"><!--- Hedef Pazar --->
	SELECT * FROM PRODUCT_SEGMENT ORDER BY PRODUCT_SEGMENT
</cfquery>
<cfquery name="get_mark_names" datasource="#dsn1#"><!--- Markalar --->
	SELECT
		PB.BRAND_ID,
        PB.BRAND_NAME
	FROM
		PRODUCT_BRANDS PB
		,PRODUCT_BRANDS_OUR_COMPANY PBO
	WHERE
		PB.BRAND_ID = PBO.BRAND_ID
		AND PBO.OUR_COMPANY_ID =  #session.ep.company_id# 
	ORDER BY BRAND_NAME
</cfquery>
<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
	SELECT 
		PRODUCT_CAT.PRODUCT_CATID, 
		PRODUCT_CAT.HIERARCHY, 
		PRODUCT_CAT.PRODUCT_CAT
	FROM 
		PRODUCT_CAT,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = #session.ep.company_id# 
	ORDER BY 
		HIERARCHY
</cfquery>
<cfif not len(attributes.our_comp)><cfset attributes.our_comp = session.ep.company_id></cfif>			
<cfif len(attributes.is_form_submited)>
<!--- GET_PURCHASE_ALL ve GET_PRODUCT_CAT query'lerinin yerini degistirmeyiniz. Form submit olmadan ilk açılısında uzun süre bekletiyor. EY 20130318 --->
	<cfquery name="GET_PRODUCT_COST_ALL" datasource="#dsn3#">
        SELECT 
            PURCHASE_NET_ALL+PURCHASE_EXTRA_COST PRODUCT_COST,
            MONEY,
            PRODUCT_ID,
            RECORD_DATE,
            START_DATE
        FROM
            PRODUCT_COST
        WHERE
            START_DATE < #NOW()#
    </cfquery>
    <cfquery name="GET_PURCHASE_ALL" datasource="#DSN3#"><!--- bURADA SADECE ALIŞ FİYATLARI ÇEKİLİYOR. --->
        SELECT
            PS.PRICE_KDV,
            PS.MONEY,
            PU.PRODUCT_UNIT_ID,
            P.PRODUCT_ID
        FROM 
            PRODUCT P, 
            PRICE_STANDART PS,
            PRODUCT_UNIT PU,
            PRODUCT_CAT PC
        WHERE
            P.PRODUCT_CATID = PC.PRODUCT_CATID AND 
            P.PRODUCT_ID = PU.PRODUCT_ID AND
            PRODUCT_STATUS = 1 AND
            PS.PURCHASESALES = 0 AND
            PS.PRICESTANDART_STATUS = 1 AND	
            P.PRODUCT_ID = PS.PRODUCT_ID AND
            PS.UNIT_ID = PU.PRODUCT_UNIT_ID
        ORDER BY 
            P.PRODUCT_NAME
    </cfquery>
    <cfquery name="GET_PRODUCT" datasource="#DSN1#">
		SELECT DISTINCT * FROM (
			<cfloop list="#attributes.our_comp#" index="comp_indx">
				SELECT
					P.COMPANY_ID, 
					<cfif attributes.sec eq 2>
						<cfif ListFind(attributes.select_option,3) or ListFind(attributes.select_option,8)>
							S.STOCK_CODE AS PRODUCT_CODE,
                        </cfif>
                        <cfif ListFind(attributes.select_option,2)>
							S.PROPERTY,
                        </cfif>
                        <cfif ListFind(attributes.select_option,1)>
							S.BARCOD,
                        </cfif>
						S.STOCK_ID,
					<cfelse>
	                    <cfif ListFind(attributes.select_option,3) or ListFind(attributes.select_option,8)>
							P.PRODUCT_CODE,
                        </cfif>
                        <cfif ListFind(attributes.select_option,1)>
							P.BARCOD,
                        </cfif>
					</cfif>
                    <cfif ListFind(attributes.select_option,16)>
						P.PRODUCT_CODE_2,
                    </cfif>
                    <cfif ListFind(attributes.select_option,7)>
						P.MANUFACT_CODE,
                    </cfif>
					P.PRODUCT_NAME,
					P.PRODUCT_ID,
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
						P.PRODUCT_MANAGER,
                    </cfif>
                    <cfif ListFind(attributes.select_option,10)>
						P.SHORT_CODE,
                    </cfif>
					<cfif ListFind(attributes.select_option,4)>
                        PC.HIERARCHY,
                        PC.PRODUCT_CAT,
                    </cfif>
                    <cfif ListFind(attributes.select_option,11)>
						P.PRODUCT_DETAIL,
                    </cfif>
                    <cfif ListFind(attributes.select_option,9)>
						P.BRAND_ID,
                    </cfif>
					P.RECORD_DATE,
					P.UPDATE_DATE,
					P.PROD_COMPETITIVE,
                    <cfif ListFind(attributes.select_option,5)>
                        P.MAX_MARGIN,
                        P.MIN_MARGIN,
                    </cfif>
					P.IS_ZERO_STOCK,
					PS.PRICE,
					PS.PRICE_KDV,
					PS.IS_KDV,
					PS.MONEY,
					PU.ADD_UNIT,
                    <cfif ListFind(attributes.select_option,23)>
						PU.MAIN_UNIT,
                    </cfif>
					PU.MULTIPLIER,
					PU.DIMENTION,
					PU.WEIGHT,
					PU.PRODUCT_UNIT_ID
					<cfif listFind(attributes.select_option,21)>
						,PP.SHELF_CODE
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
                     COMPANY.FULLNAME,
                   	 PRODUCT_UNIT_ADD.ADD_UNIT_ADD
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
                    <cfif isdefined("attributes.list_property_id") and len(attributes.list_property_id) and len(attributes.list_variation_id)>
                        AND P.PRODUCT_ID IN
                        (
                            SELECT
                                PRODUCT_ID
                            FROM
                                #dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES
                            WHERE
                                <cfloop from="1" to="#listlen(attributes.list_property_id,',')#" index="pro_index">
                                PRODUCT_ID IN (

                                                SELECT 
                                                    PRODUCT_ID
                                                FROM
                                                    #dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES 
                                                WHERE
                                                    (
                                                    PROPERTY_ID = #ListGetAt(attributes.list_property_id,pro_index,",")# AND VARIATION_ID IN (#attributes.list_variation_id#)
                                                    <cfif ListGetAt(attributes.list_property_value,pro_index,",") neq 'empty'>AND(TOTAL_MAX=#ListGetAt(attributes.list_property_value,pro_index,",")# OR TOTAL_MIN=#ListGetAt(attributes.list_property_value,pro_index,",")#)</cfif>
                                                    )
                                                GROUP BY 
                                                    PRODUCT_ID  
                                            ) 
                                <cfif pro_index lt listlen(attributes.list_property_id,',')>AND</cfif>
                                </cfloop>
                        )
                    </cfif>
				<cfif listFind(attributes.select_option,21)>
					UNION ALL
					SELECT DISTINCT
						P.COMPANY_ID, 
						<cfif attributes.sec eq 2>
	                        <cfif ListFind(attributes.select_option,3) or ListFind(attributes.select_option,8)>
								S.STOCK_CODE AS PRODUCT_CODE,
                            </cfif>
                            <cfif ListFind(attributes.select_option,2)>
								S.PROPERTY,
                            </cfif>
                            <cfif ListFind(attributes.select_option,1)>
								S.BARCOD,
                            </cfif>
							S.STOCK_ID,
						<cfelse>
	                        <cfif ListFind(attributes.select_option,3) or ListFind(attributes.select_option,8)>
								P.PRODUCT_CODE,
                            </cfif>
                            <cfif ListFind(attributes.select_option,1)>
								P.BARCOD,
                            </cfif>
						</cfif>
                        <cfif ListFind(attributes.select_option,16)>
							P.PRODUCT_CODE_2,
                        </cfif>
                        <cfif ListFind(attributes.select_option,7)>
							P.MANUFACT_CODE,
                        </cfif>
						P.PRODUCT_NAME,
						P.PRODUCT_ID,
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
							P.PRODUCT_MANAGER,
                        </cfif>
                        <cfif ListFind(attributes.select_option,10)>
							P.SHORT_CODE,
                        </cfif>
						<cfif ListFind(attributes.select_option,4)>
                            PC.HIERARCHY,
                            PC.PRODUCT_CAT,
                        </cfif>
                        <cfif ListFind(attributes.select_option,11)>
							P.PRODUCT_DETAIL,
                        </cfif>
                        <cfif ListFind(attributes.select_option,9)>
							P.BRAND_ID,
                        </cfif>
						P.RECORD_DATE,
						P.UPDATE_DATE,
						P.PROD_COMPETITIVE,
                        <cfif ListFind(attributes.select_option,9)>
                            P.MAX_MARGIN,
                            P.MIN_MARGIN,
                        </cfif>
						P.IS_ZERO_STOCK,
						PS.PRICE,
						PS.PRICE_KDV,
						PS.IS_KDV,
						PS.MONEY,
						PU.ADD_UNIT,
                        <cfif ListFind(attributes.select_option,23)>
							PU.MAIN_UNIT,
                        </cfif>
						PU.MULTIPLIER,
						PU.DIMENTION,
						PU.WEIGHT,
						PU.PRODUCT_UNIT_ID
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
                         COMPANY.FULLNAME,
                         PRODUCT_UNIT_ADD.ADD_UNIT_ADD
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
                        <cfif isdefined("attributes.list_property_id") and len(attributes.list_property_id) and len(attributes.list_variation_id)>
                            AND P.PRODUCT_ID IN
                            (
                                SELECT
                                    PRODUCT_ID
                                FROM
                                    #dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES
                                WHERE
                                    <cfloop from="1" to="#listlen(attributes.list_property_id,',')#" index="pro_index">
                                    PRODUCT_ID IN (

                                                    SELECT 
                                                        PRODUCT_ID
                                                    FROM
                                                        #dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES 
                                                    WHERE
                                                        (
                                                        PROPERTY_ID = #ListGetAt(attributes.list_property_id,pro_index,",")# AND VARIATION_ID IN (#attributes.list_variation_id#)
                                                        <cfif ListGetAt(attributes.list_property_value,pro_index,",") neq 'empty'>AND(TOTAL_MAX=#ListGetAt(attributes.list_property_value,pro_index,",")# OR TOTAL_MIN=#ListGetAt(attributes.list_property_value,pro_index,",")#)</cfif>
                                                        )
                                                    GROUP BY 
                                                        PRODUCT_ID  
                                                ) 
                                    <cfif pro_index lt listlen(attributes.list_property_id,',')>AND</cfif>
                                    </cfloop>
                            )
                        </cfif>
				</cfif>
		<cfif comp_indx neq listlast(attributes.our_comp)>UNION ALL</cfif>
		</cfloop>
		) T1
	ORDER BY 
		PRODUCT_NAME
	</cfquery> 
</cfif>
<cfif ListFind(attributes.select_option,17)>
	<cfquery name="get_images" datasource="#DSN3#">
		SELECT 
			COUNT(PRODUCT_ID) AS URUN_SAYISI,
			PRODUCT_ID
		FROM 
			PRODUCT_IMAGES
		GROUP BY
			PRODUCT_ID
		ORDER BY
			PRODUCT_ID
	</cfquery>
	<cfset image_id_list = listsort(listdeleteduplicates(valuelist(get_images.PRODUCT_ID,',')),'numeric','ASC',',')>
</cfif>
<cfquery name="get_price_cat" datasource="#dsn3#">
	SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT ORDER BY PRICE_CAT
</cfquery>
<cfquery name="GET_LOCATION" datasource="#DSN#">
	SELECT
		D.DEPARTMENT_ID,
		D.DEPARTMENT_HEAD,
		D.DEPARTMENT_STATUS,
		SL.COMMENT,
		SL.LOCATION_ID,
		SL.STATUS
	FROM
		BRANCH B,
		DEPARTMENT D,
		STOCKS_LOCATION SL
	WHERE
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		B.COMPANY_ID = #session.ep.company_id# AND
		B.BRANCH_ID = D.BRANCH_ID AND
		D.IS_STORE <> 2 AND
		B.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	ORDER BY 
		D.DEPARTMENT_HEAD,
		D.DEPARTMENT_ID,
		SL.COMMENT
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = (((attributes.page-1)*attributes.maxrows)) + 1>
<cfform name="list_product" method="post" action="#request.self#?fuseaction=report.detail_product_report"><!--- #attributes.fuseaction# --->
    <input type="hidden" name="list_property_id" id="list_property_id" value="<cfif isdefined("attributes.list_property_id")><cfoutput>#attributes.list_property_id#</cfoutput></cfif>">
    <input type="hidden" name="list_variation_id" id="list_variation_id" value="<cfif isdefined("attributes.list_variation_id")><cfoutput>#attributes.list_variation_id#</cfoutput></cfif>">
    <input type="hidden" name="list_property_value" id="list_property_value" value="<cfif isdefined("attributes.list__property_value")><cfoutput>#attributes.list__property_value#</cfoutput></cfif>">
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='39584.Detaylı Ürün Raporu'></cfsavecontent>
    <cf_report_list_search title="#title#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-6 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57486.Kategori'></label>
										<div class="col col-12">
											<select name="cat" id="cat" style="width:170px;height:106px" multiple="multiple">
                                                <cfoutput query="get_product_cat">
                                                    <option value="#HIERARCHY#" <cfif listfind(attributes.cat,HIERARCHY)>selected</cfif>>#HIERARCHY#-#product_cat#</option>
                                                </cfoutput>
                                            </select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='40244.İlişkili Şirketlerimiz'></label>
										<div class="col col-12">
											<select name="our_comp" id="our_comp" style="width:170px;height:106px" multiple="multiple">
                                                <cfoutput query="GET_OUR_COMPANIES">
                                                    <option value="#comp_id#"<cfif listfind(attributes.our_comp,comp_id)>selected</cfif>>#NICK_NAME#</option>
                                                </cfoutput>
                                            </select>
										</div>
                                    </div>
                                    <div class="form-group">
                                        <cfset close_for_grid = 1 />
                                        <cfset close_style = 'display:none;' />
                                        <cfif isDefined("attributes.list_property_id") And Len(attributes.list_property_id)>
                                            <cfset close_for_grid = 0 />
                                            <cfset close_style = '' />
                                        </cfif>
                                        <cfsavecontent variable="group_input_txt"><cf_get_lang dictionary_id='33614.Product Features'></cfsavecontent>
                                        <cf_seperator id="extraDetail" title="#group_input_txt#" closeForGrid="#close_for_grid#">
                                        <div id="extraDetail" style="<cfoutput>#close_style#</cfoutput>">
                                            <cfif get_property_variation.recordcount eq 0>
                                                <tr><td></td></tr>
                                            <cfelse>
                                                <cfoutput>
                                                    <cfset a=0>
                                                    <cfloop from="1" to="#get_property_variation.recordcount#" index="main_str">
                                                        <cfif get_property_variation.property_id[main_str] neq get_property_variation.property_id[main_str-1]>
                                                            <input type="hidden" name="row_kontrol#main_str#" id="row_kontrol#main_str#" value="1">
                                                            <input type="hidden" name="property_id#main_str#" id="property_id#main_str#" value="#get_property_variation.property_id[main_str]#">
                                                            <select name="variation_id#main_str#" id="variation_id#main_str#" style="width:150px;" onchange="showInformation(#main_str#);" multiple="multiple">
                                                                <option value="">#get_property_variation.property[main_str]#</option>
                                                                <cfloop from="#main_str#" to="#get_property_variation.recordcount#" index="str">
                                                                    <cfif get_property_variation.property_id[main_str] eq get_property_variation.property_id[str]>
                                                                        <option value="#get_property_variation.property_detail_id[str]#" <cfif isdefined('attributes.list_variation_id') and listfind(attributes.list_variation_id,get_property_variation.property_detail_id[str])>selected="selected"</cfif>>#get_property_variation.property_detail[str]#</option>
                                                                    <cfelse>
                                                                        <cfbreak>
                                                                    </cfif>
                                                                </cfloop>
                                                            </select>
                                                            <cfset a=a+1>
                                                            <div id="information_row#main_str#" <cfif isdefined('attributes.list_variation_id') and listfind(attributes.list_property_id,get_property_variation.property_id[main_str])><cfelse>style="display:none;"</cfif>>
                                                                <input type="hidden" name="information_select#main_str#" style="width:80px;" id="information_select" value="<cfif isdefined('attributes.list_property_value') and listfind(attributes.list_property_id,get_property_variation.property_id[main_str]) and listgetat(attributes.list_property_value,listfind(attributes.list_property_id,get_property_variation.property_id[main_str]),',') neq 'empty'>#listgetat(attributes.list_property_value,listfind(attributes.list_property_id,get_property_variation.property_id[main_str]),',')#</cfif>" />
                                                            </div>
                                                        </cfif>
                                                    </cfloop>
                                                </cfoutput>
                                            </cfif>
                                        </div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-6 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='40146.Ürün Özellikleri'></label>
										<div class="col col-12">
                                            <select name="category" id="category" multiple="multiple" style="width:170px;height:106px">
                                                <option value="1" <cfif ListFind(attributes.category,1)>selected</cfif>><cf_get_lang dictionary_id ='39441.Envantere Dahil'></option><!--- is_inventory --->
                                                <option value="7" <cfif ListFind(attributes.category,7)>selected</cfif>><cf_get_lang dictionary_id ='40242.Extranetde Satılıyor'></option><!--- is_extranet --->
												<option value="6" <cfif ListFind(attributes.category,6)>selected</cfif>><cf_get_lang dictionary_id ='40154.İnternetde Satılıyor'></option><!---IS_INTERNET  --->
												<option value="14" <cfif ListFind(attributes.category,14)>selected</cfif>><cf_get_lang dictionary_id ='32064.Kalite Kontrol'></option><!---IS_QUALITY  --->
												<option value="11" <cfif ListFind(attributes.category,11)>selected</cfif>><cf_get_lang dictionary_id ='40243.Karma Koli'></option><!---IS_KARMA  --->
												<option value="12" <cfif ListFind(attributes.category,12)>selected</cfif>><cf_get_lang dictionary_id ='40160.Maliyet Takibi Yapılıyor'></option><!---IS_COST  --->
												<option value="5" <cfif ListFind(attributes.category,5)>selected</cfif>><cf_get_lang dictionary_id ='40240.Özelleştirilebilir'></option><!--- IS_PROTOTYPE --->
												<option value="3" <cfif ListFind(attributes.category,3)>selected</cfif>><cf_get_lang dictionary_id ='40149.Satışta'></option><!---is_SALES  --->
												<option value="9" <cfif ListFind(attributes.category,9)>selected</cfif>><cf_get_lang dictionary_id ='40158.Seri No Takibi Yapılıyor'></option><!--- is_serial_no --->
												<option value="10" <cfif ListFind(attributes.category,10)>selected</cfif>><cf_get_lang dictionary_id ='40159.Sıfır Stok'></option><!---IS_ZERO_STOCK  --->
												<option value="13" <cfif ListFind(attributes.category,13)>selected</cfif>><cf_get_lang dictionary_id ='40169.Stoklarla Sınırlı'></option><!---IS_LIMITED_STOCK  --->
												<option value="4" <cfif ListFind(attributes.category,4)>selected</cfif>><cf_get_lang dictionary_id ='40151.Tedarik Ediliyor'></option><!--- is_purchase --->
												<option value="8" <cfif ListFind(attributes.category,8)>selected</cfif>><cf_get_lang dictionary_id ='37067.Teraziye Gidiyor'></option><!--- IS_TERAZI --->
												<option value="2" <cfif ListFind(attributes.category,2)>selected</cfif>><cf_get_lang dictionary_id ='40238.Üretiliyor'></option><!--- is_production --->
                                            </select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58448.Ürün Sorumlusu'></label>
										<div class="col col-12">
                                           <select name="pos_code" id="pos_code" style="width:170px;height:106px" multiple>
                                                <cfif len(attributes.pos_code)>
                                                    <cfloop from="1" to="#listlen(attributes.pos_code)#" index="i">
                                                        <cfoutput>
                                                            <option value="#listgetat(attributes.pos_code, i, ',')#">#get_emp_info(listgetat(attributes.pos_code, i, ','),1,0)#</option>
                                                        </cfoutput>
                                                    </cfloop>
                                                </cfif>
                                            </select>
                                        </div>
                                        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multi_pars&field_name=list_product.pos_code&select_list=1&is_upd=0&is_multiple=1','list');"><img src="/images/plus_list.gif" border="0" align="top" alt="<cf_get_lang dictionary_id ='57582.Ekle'>"></a>
                                        <a href="javascript://" onClick="remove_field('pos_code');"><img src="/images/delete_list.gif" border="0" alt="<cf_get_lang dictionary_id ='57463.Sil'>" style="cursor=hand" align="top"></a>	
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-6 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
                                        <div class="col col-12">
                                            <select name="marks" id="marks" multiple="multiple" style="width:170px;height:106px">
                                                <cfoutput query="get_mark_names">
                                                    <option value="#BRAND_ID#"<cfif listfind(attributes.marks,BRAND_ID)>selected</cfif>>#BRAND_NAME#</option>
                                                </cfoutput>
                                            </select>
                                        </div>	
                                    </div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58715.Listele'>*</label>
										<div class="col col-12">
                                            <select name="select_option" id="select_option" multiple="multiple" style="width:170px;height:106px">
                                                <option value="1" <cfif listfind(attributes.select_option,1)>selected</cfif>><cf_get_lang dictionary_id ='57633.Barkod'></option>
                                                <option value="2" <cfif listfind(attributes.select_option,2)>selected</cfif>><cf_get_lang dictionary_id='58221.Ürün Adı'></option>
                                                <option value="23" <cfif listfind(attributes.select_option,23)>selected</cfif>><cf_get_lang dictionary_id ='57636.Birim'></option>
                                                <option value="26" <cfif listfind(attributes.select_option,26)>selected</cfif>> <cf_get_lang dictionary_id ='40473.Ek Birim'></option>
                                                <option value="27" <cfif listfind(attributes.select_option,27)>selected</cfif>><cf_get_lang dictionary_id='29533.Tedarikçi'></option>
                                                <option value="3" <cfif listfind(attributes.select_option,3)>selected</cfif>><cf_get_lang dictionary_id ='57518.Stok Kodu'></option>
                                                <option value="4" <cfif listfind(attributes.select_option,4)>selected</cfif>><cf_get_lang dictionary_id ='57486.Kategori'></option>
                                                <option value="5" <cfif listfind(attributes.select_option,5)>selected</cfif>><cf_get_lang dictionary_id ='40245.Net Marj'></option>
                                                <option value="6" <cfif listfind(attributes.select_option,6)>selected</cfif>><cf_get_lang dictionary_id='58084.Fiyat'></option>
                                                <option value="7" <cfif listfind(attributes.select_option,7)>selected</cfif>><cf_get_lang dictionary_id ='57634.Üretici Kodu'></option>
                                                <option value="8" <cfif listfind(attributes.select_option,8)>selected</cfif>><cf_get_lang dictionary_id='58800.Ürün Kodu'></option>
                                                <option value="9" <cfif listfind(attributes.select_option,9)>selected</cfif>><cf_get_lang dictionary_id='58847.Marka'></option>
                                                <option value="10" <cfif listfind(attributes.select_option,10)>selected</cfif>><cf_get_lang dictionary_id='58225.Model'></option>
                                                <option value="11" <cfif listfind(attributes.select_option,11)>selected</cfif>><cf_get_lang dictionary_id='57629.Açıklama'></option>
                                                <option value="13" <cfif listfind(attributes.select_option,13)>selected</cfif>><cf_get_lang dictionary_id ='40247.Alış KDV'></option>
                                                <option value="14" <cfif listfind(attributes.select_option,14)>selected</cfif>><cf_get_lang dictionary_id ='40248.Satış KDV'></option>
                                                <option value="15" <cfif listfind(attributes.select_option,15)>selected</cfif>><cf_get_lang dictionary_id='58448.Ürün Sorumlusu'></option>
                                                <option value="16" <cfif listfind(attributes.select_option,16)>selected</cfif>><cf_get_lang dictionary_id ='57789.Özel Kod'></option>
                                                <option value="17" <cfif listfind(attributes.select_option,17)>selected</cfif>><cf_get_lang dictionary_id ='29762.İmaj'></option>
                                                <cfif not isdefined("session.ep.cost_display_valid")><option value="18" <cfif listfind(attributes.select_option,18)>selected</cfif>><cf_get_lang dictionary_id='58258.Maliyet'></option></cfif>
                                                <option value="19" <cfif listfind(attributes.select_option,19)>selected</cfif>><cf_get_lang dictionary_id='58722.Standart Alış'></option>
                                                <option value="20" <cfif listfind(attributes.select_option,20)>selected</cfif>><cf_get_lang dictionary_id='58721.Standart Satış'></option>
                                                <option value="21" <cfif listfind(attributes.select_option,21)>selected</cfif>><cf_get_lang dictionary_id ='30001.Raf Bilgisi'></option>
                                                <option value="22" <cfif listfind(attributes.select_option,22)>selected</cfif>><cf_get_lang dictionary_id ='40252.Alt Barkodlar'></option>
                                                <option value="28" <cfif listfind(attributes.select_option,28)>selected</cfif>><cf_get_lang dictionary_id='33614.Product Features'></option>

                                                <!--- Kullanilmiyor diye kaldirdim. EY20130410
                                                <option value="24" <cfif listfind(attributes.select_option,24)>selected</cfif>><cf_get_lang dictionary_id ='57468.Belge'></option>
                                                <option value="25" <cfif listfind(attributes.select_option,25)>selected</cfif>>Video</option>
                                                --->
                                            </select>       
										</div>
									</div>
								</div>
                            </div>
                            <div class="col col-3 col-md-6 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='39370.Hedef Pazar'></label>
                                        <div class="col col-12">
                                            <select name="SEGMENT_ID" id="SEGMENT_ID" style="width:170px;height:70px" multiple="multiple">
                                                <cfoutput query="GET_SEGMENTS">
                                                    <option value="#PRODUCT_SEGMENT_ID#" <cfif listfind(attributes.segment_id,PRODUCT_SEGMENT_ID)>selected</cfif>>#PRODUCT_SEGMENT#</option>
                                                </cfoutput>
                                            </select>
                                        </div>	
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
										<div class="col col-12">
											 <div class="input-group">
                                                <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
                                                <input type="text" name="company" id="company" style="width:165px;" value="<cfif len(attributes.company)><cfoutput>#get_par_info(attributes.company_id,1,1,0)#</cfoutput></cfif>" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','250');" autocomplete="off"> 
                                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=list_product.company&field_comp_id=list_product.company_id&select_list=2','list');"></span>
                                             </div>       
										</div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12"><cf_get_lang dictionary_id='58964.Fiyat listesi'></label>
										<div class="col col-12">
											<select name="price_catid" id="price_catid" style="width:165px;" onchange="get_empty_option(this.value);">
                                                <option value="-1" <cfif attributes.price_catid eq -1>selected</cfif>><cf_get_lang dictionary_id='58722.Standart Alış'></option>
                                                <option value="-2" <cfif attributes.price_catid eq -2>selected</cfif>><cf_get_lang dictionary_id='58721.Standart Satış'></option>
                                                <cfoutput query="get_price_cat">
                                                <option value="#PRICE_CATID#" <cfif attributes.price_catid eq PRICE_CATID> selected</cfif>>#PRICE_CAT#</option>
                                                </cfoutput>
                                            </select>
										</div>
                                    </div>
                                    <div class="form-group">
                                        <div class="col col-12 col-xs-12" id="is_empty_price_td" <cfif isdefined("attributes.price_catid") and (attributes.price_catid eq -1 or attributes.price_catid eq -2)>style="display:none;"</cfif>>                    
                                            <select name="is_empty_price" id="is_empty_price">
                                                <option value="0" <cfif attributes.is_empty_price eq 0>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                                                <option value="-1" <cfif attributes.is_empty_price eq -1>selected</cfif>><cf_get_lang dictionary_id='52212.fiyatı'><cf_get_lang dictionary_id='30056.olmayanlar'></option>
                                                <option value="1" <cfif attributes.is_empty_price eq 1>selected</cfif>><cf_get_lang dictionary_id='52212.fiyatı'><cf_get_lang dictionary_id='30055.olanlar'></option>
                                            </select>   
                                        </div>    
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                                        <div class="col col-12">
                                            <select name="status" id="status">
                                                <option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                                <option value="0" <cfif attributes.status eq 0>selected </cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                                                <option value="2" <cfif attributes.status eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                                            </select>  
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label><cf_get_lang dictionary_id ='39059.KDV Dahil'> <input type="checkbox" name="is_kdv" id="is_kdv" value="1" <cfif isdefined("is_kdv")>checked</cfif>></label> 
                                        <label><input type="radio" name="sec" id="sec" value="1" <cfif attributes.sec eq 1>checked</cfif>><cf_get_lang dictionary_id ='57657.Ürün'></label>
                                        <label><input type="radio" name="sec" id="sec" value="2" <cfif attributes.sec eq 2>checked</cfif>><cf_get_lang dictionary_id='57452.Stok'></label>
                                    </div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
							<input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'> <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
                            <input name="is_form_submited" id="is_form_submited" type="hidden" value="1">
							<cf_wrk_report_search_button button_type='1' search_function='input_control()' is_excel='1'>					
					    </div>	  
					</div>
				</div>
			</div>
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-16">	
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.is_form_submited") and len(attributes.is_form_submited)>
   <cf_report_list>
            <cfif isdefined("get_product") and get_product.recordcount>
                <cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
                    <cfset attributes.startrow=1>
                    <cfset attributes.maxrows=get_product.recordcount>
                </cfif>
            </cfif>
            <thead>
                <tr> 
                    <cfif ListFind(attributes.select_option,3)><th width="100"><cf_get_lang dictionary_id='57518.Stok Kodu'></th></cfif>
                    <cfif ListFind(attributes.select_option,2)><th><cf_get_lang dictionary_id='57657.Ürün'></th></cfif>
                    <cfif ListFind(attributes.select_option,27)><th style="text-align:center;" width="250"><cf_get_lang dictionary_id='29533.Tedarikçi'></th></cfif>
                    <cfif ListFind(attributes.select_option,23)><th width="60"><cf_get_lang dictionary_id='57636.Birim'></th></cfif>
                    <cfif ListFind(attributes.select_option,26)><th style="text-align:center;" width="350"><cf_get_lang dictionary_id='40472.Ek Birimler'></th></cfif>
                    <cfif ListFind(attributes.select_option,1) or ListFind(attributes.select_option,22)><th width="120"><cf_get_lang dictionary_id='57633.Barkod'></th></cfif>
                    <cfif ListFind(attributes.select_option,7)><th width="120"><cf_get_lang dictionary_id='57634.Ürt Kodu'></th></cfif>
                    <cfif ListFind(attributes.select_option,8)><th width="120"><cf_get_lang dictionary_id='58800.Ürün Kodu'></th></cfif>
                    <cfif ListFind(attributes.select_option,9)><th width="120"><cf_get_lang dictionary_id='58847.Marka'></th></cfif>
                    <cfif ListFind(attributes.select_option,10)><th width="120"><cf_get_lang dictionary_id='58225.Model'></th></cfif>
                    <cfif ListFind(attributes.select_option,11)><th width="120"><cf_get_lang dictionary_id='57629.Açıklama'></th></cfif>
                    <cfif ListFind(attributes.select_option,13)><th width="120"><cf_get_lang dictionary_id ='40247.Alış KDV'></th></cfif>
                    <cfif ListFind(attributes.select_option,14)><th width="120"><cf_get_lang dictionary_id ='40248.Satış KDV'></th></cfif>
                    <cfif ListFind(attributes.select_option,15)><th width="120"><cf_get_lang dictionary_id='58448.Ürün Sorumlusu'></th></cfif>
                    <cfif ListFind(attributes.select_option,16)><th width="120"><cf_get_lang dictionary_id='57789.Özel Kod'></th></cfif>
                    <cfif ListFind(attributes.select_option,4)><th><cf_get_lang dictionary_id ='57486.Kategori'></th></cfif>
                    <cfif ListFind(attributes.select_option,4) and  ListFind(attributes.select_option,5)><th width="120"><cf_get_lang dictionary_id ='40253.Min Marj'></th></cfif>
                    <cfif ListFind(attributes.select_option,4) and  ListFind(attributes.select_option,5)><th width="120"><cf_get_lang dictionary_id ='40254.Max Marj'></th></cfif>
                    <cfif ListFind(attributes.select_option,19)>
                        <th width="80" nowrap="nowrap"><cf_get_lang dictionary_id='58176.Alış'><cf_get_lang dictionary_id='58084.Fiyat'></th>
                        <th style="text-align:center;" width="30"><cf_get_lang dictionary_id='58474.Birim'></th>
                    </cfif>
                    <cfif ListFind(attributes.select_option,20)>
                        <th width="80" nowrap="nowrap"><cf_get_lang dictionary_id='57448.Satış'><cf_get_lang dictionary_id='58084.Fiyat'></th>
                        <th style="text-align:center;" width="30"><cf_get_lang dictionary_id='58474.Birim'></th>
                    </cfif>
                    <cfif ListFind(attributes.select_option,6)>
                        <th nowrap="nowrap" width="120"><cf_get_lang dictionary_id ='40255.Liste Fiyat'></th>
                        <cfif attributes.price_catid neq -1 or attributes.price_catid neq -2>
                            <th style="text-align:center;" width="30"><cf_get_lang dictionary_id='58474.Para Birim'></th>
                        </cfif>
                    </cfif>
                    
                    <cfif ListFind(attributes.select_option,18)>
                        <th nowrap="nowrap" width="80"><cf_get_lang dictionary_id='58258.Maliyet'></th>
                        <th style="text-align:center;" width="30"><cf_get_lang dictionary_id='58474.Birim'></th>
                        <th width="120" nowrap="nowrap"><cf_get_lang dictionary_id ='58583.Fark'></th>
                    </cfif>
                    <cfif ListFind(attributes.select_option,17)>
                        <th width="120"><cf_get_lang dictionary_id ='29762.İmaj'></th>
                    </cfif>
                    <cfif listFind(attributes.select_option,21)>
                        <th width="120"><cf_get_lang dictionary_id ='40256.Raf'></th>
                    </cfif>
                    <th width="100" style="text-align:center;"><cf_get_lang dictionary_id='57756.Durum'></th>
                    <cfif listFind(attributes.select_option,28)>
                        <cfif get_property_variation.recordcount neq 0>
                            <cfloop from="1" to="#get_property_variation.recordcount#" index="main_str">
                                <cfif get_property_variation.property_id[main_str] neq get_property_variation.property_id[main_str-1]>
                                    <th width="100" style="text-align:center;"><cfoutput>#get_property_variation.property[main_str]#</cfoutput></th>
                                </cfif>
                            </cfloop>
                        </cfif>
                    </cfif>
                </tr> 
            </thead>
            <cfif isdefined("get_product") and get_product.recordcount>
                <cfset add_unit_list = "">
            <!---  <cfif ListFind(attributes.select_option,22)>
                    <cfquery name="GET_ALL_BARCODE" datasource="#dsn3#">
                        SELECT
                            STOCKS.PRODUCT_ID,
                            STOCKS.STOCK_ID,
                            STOCKS_BARCODES.BARCODE,
                            STOCKS_BARCODES.UNIT_ID
                        FROM 
                            STOCKS_BARCODES,
                            STOCKS 
                        WHERE 
                            STOCKS_BARCODES.STOCK_ID=STOCKS.STOCK_ID AND
                            STOCKS.PRODUCT_ID IN (<cfoutput query="GET_PRODUCT" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">#PRODUCT_ID#,</cfoutput>0)
                    </cfquery>
                    <cfif GET_ALL_BARCODE.RECORDCOUNT>
                        <cfoutput query="GET_ALL_BARCODE">
                            <cfif not isdefined('attributes.sec') or attributes.sec eq 1><!--- ürün bazında ise barcode listeleri --->
                                <cfif not isdefined('list_#PRODUCT_ID#_#UNIT_ID#')><cfset 'list_#PRODUCT_ID#_#UNIT_ID#'=''></cfif>
                                <cfset 'list_#PRODUCT_ID#_#UNIT_ID#'=listappend(evaluate('list_#PRODUCT_ID#_#UNIT_ID#'),BARCODE,',')>
                            <cfelse><!--- stock bazında ise barcode listeleri --->
                                <cfif not isdefined('list_#STOCK_ID#_#UNIT_ID#')><cfset 'list_#STOCK_ID#_#UNIT_ID#'=''></cfif>
                                <cfset 'list_#STOCK_ID#_#UNIT_ID#'=listappend(evaluate('list_#STOCK_ID#_#UNIT_ID#'),BARCODE,',')>
                            </cfif>
                        </cfoutput>
                    </cfif>
                </cfif>--->
                <cfif ListFind(attributes.select_option,26)>
                </cfif>
                <cfoutput query="get_product" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tbody>
                        <tr>
                            <cfif ListFind(attributes.select_option,3)><td style="mso-number-format:\@;">#get_product.product_code# </td></cfif><!--- Stok Kodu --->
                            <cfif ListFind(attributes.select_option,2)><td>#get_product.product_name# <cfif attributes.sec eq 2> #get_product.PROPERTY#</cfif></td></cfif><!--- Ürün İsmi --->
                            <cfif ListFind(attributes.select_option,27)>
                                <td><cfif LEN(FULLNAME)>#FULLNAME#</cfif></td>
                            </cfif>
                            <cfif ListFind(attributes.select_option,23)><td>#get_product.main_unit#</td></cfif><!--- Ürün Birimi --->
                            <cfif ListFind(attributes.select_option,26)><!--- Ürün Ek Birimleri FBS 20081024 --->
                                <td style="text-align:center; padding: 0px;" >
                                    <table class="ui-table-list ">
                                        <cfif LEN(ADD_UNIT_ADD)>
                                                <thead>
                                                    <tr class="color-list">
                                                        <th class="txtboldblue" width="60"><cf_get_lang dictionary_id ='40473.Ek Birim'></td>
                                                        <th class="txtboldblue" width="60"><cf_get_lang dictionary_id='57713.Boyut'></td>
                                                        <th class="txtboldblue" width="60"><cf_get_lang dictionary_id='58865.Çarpan'></td>
                                                        <!--- <td class="txtboldblue" width="60"><cf_get_lang dictionary_id ='1987.Ağırlık'></td>--->
                                                    </tr>
                                                </thead>
                                            <cfloop list="#ADD_UNIT_ADD#" delimiters=";" index="aa">
                                                <tbody>
                                                    <tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                                                        <td>#listgetAt(aa,1,':')#</td>
                                                        <td>#listgetAt(aa,2,':')#</td>
                                                        <td>#listgetAt(aa,3,':')#</td>
                                                        <!---   <td style="text-align:right;">#TLFormat(weight_ADD)#</td>--->
                                                    </tr>
                                                </tbody>
                                            </cfloop>
                                        </cfif>
                                    </table>
                                </td>
                            </cfif>
                            <cfif ListFind(attributes.select_option,22)><!--- tüm barkodlar --->
                                <td style="mso-number-format:\@;">
                                    #SUB_BARCODES#
                                </td>
                            <cfelseif ListFind(attributes.select_option,1)><!--- Barkod --->
                                <td style="mso-number-format:\@;">#get_product.barcod#</td>
                            </cfif>
                            <cfif ListFind(attributes.select_option,7)><td style="mso-number-format:\@;">#get_product.manufact_code#</td></cfif><!--- Üretici Kodu --->
                            <cfif ListFind(attributes.select_option,8)><td style="mso-number-format:\@;">#get_product.product_code#</td></cfif><!--- Ürün Kodu --->
                            <cfif ListFind(attributes.select_option,9)><!--- Marka --->
                                <cfif len(GET_PRODUCT.BRAND_ID)>
                                    <cfquery name="get_mark_names_" datasource="#DSN1#">
                                        SELECT BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID = #GET_PRODUCT.BRAND_ID#
                                    </cfquery>
                                </cfif>
                                <td><cfif len(GET_PRODUCT.BRAND_ID)>#get_mark_names_.BRAND_NAME#<cfelse>---</cfif></td>
                            </cfif>
                            <cfif ListFind(attributes.select_option,10)><!--- Model --->
                                <td>#SHORT_CODE#</td>
                            </cfif>
                            <cfif ListFind(attributes.select_option,11)><!--- Açıklama --->
                                <td>#PRODUCT_DETAIL#</td>
                            </cfif>
                            <cfif ListFind(attributes.select_option,13)><!--- Alış KDV --->
                                <td>#TAX_PURCHASE#</td>
                            </cfif>
                            <cfif ListFind(attributes.select_option,14)><!--- Satış KDV --->
                                <td>#TAX#</td>
                            </cfif>
                            <cfif ListFind(attributes.select_option,15)><!--- Ürün Sorumlusu --->
                                <td>#get_emp_info(PRODUCT_MANAGER,1,0)#</td>
                            </cfif>
                            <cfif ListFind(attributes.select_option,16)><!--- Özel Kod --->
                                <td style="mso-number-format:\@;">#PRODUCT_CODE_2#</td>
                            </cfif>
                            <cfif ListFind(attributes.select_option,4)><td>#get_product.hierarchy#-#get_product.product_cat#</td></cfif><!--- Kategori --->
                            <cfif ListFind(attributes.select_option,4) and  ListFind(attributes.select_option,5)><td>#TLFORMAT(get_product.MIN_MARGIN,2)#</td></cfif><!--- Net Marj --->
                            <cfif ListFind(attributes.select_option,4) and  ListFind(attributes.select_option,5)><td>#TLFORMAT(get_product.MAX_MARGIN,2)#</td></cfif><!--- Net Marj --->
                            <cfif ListFind(attributes.select_option,19)><!--- Fiyat --->
                                <cfquery name="GET_PURCHASE" dbtype="query" maxrows="1">
                                    SELECT * FROM GET_PURCHASE_ALL WHERE PRODUCT_ID=#get_product.PRODUCT_ID# AND  PRODUCT_UNIT_ID = #get_product.PRODUCT_UNIT_ID#
                                </cfquery>
                                <td style="text-align:right;" format="numeric">
                                    <cfquery name="GET_PRICE" datasource="#DSN3#">
                                        SELECT
                                            PRICE,
                                            PRICE_KDV,
                                            IS_KDV,
                                            MONEY 
                                        FROM 
                                            PRICE_STANDART,
                                            PRODUCT_UNIT
                                        WHERE
                                            PRICE_STANDART.PURCHASESALES = 0 AND
                                            PRODUCT_UNIT.IS_MAIN = 1 AND 
                                            PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
                                            PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
                                            PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND	
                                            PRICE_STANDART.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.PRODUCT_ID#">
                                    </cfquery>
                                    <cfif isdefined("attributes.is_kdv")>
                                        <cfset alis_fiyat = get_price.price_kdv>
                                    <cfelse>
                                        <cfset alis_fiyat = get_price.price>
                                    </cfif>                                
                                    #TLFormat(alis_fiyat,4)#
                                </td>                          
                                <td style="text-align:center;">#GET_PURCHASE.MONEY#</td>
                            </cfif>
                            <cfif ListFind(attributes.select_option,20)> 
                                <td style="text-align:right;" format="numeric">
                                    <cfquery name="GET_PRICE" datasource="#DSN3#">
                                        SELECT
                                            PRICE,
                                            PRICE_KDV,
                                            IS_KDV,
                                            MONEY 
                                        FROM
                                            PRICE_STANDART,
                                            PRODUCT_UNIT
                                        WHERE
                                            PRICE_STANDART.PURCHASESALES = 1 AND
                                            PRODUCT_UNIT.IS_MAIN = 1 AND 
                                            PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
                                            PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
                                            PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND	
                                            PRICE_STANDART.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.PRODUCT_ID#">
                                    </cfquery>
                                    <cfif isdefined("attributes.is_kdv")>
                                        <cfset satis_fiyat = get_price.price_kdv>
                                    <cfelse>
                                        <cfset satis_fiyat = get_price.price>
                                    </cfif>                                
                                    #TLFormat(satis_fiyat,4)#                            
                                </td>
                                <td style="text-align:center;">#MONEY#</td>
                            </cfif>
                            <cfif ListFind(attributes.select_option,6)>
                                <td style="text-align:right;" format="numeric"><cfif len(list_price) and list_price neq 0>#TLFormat(LIST_PRICE,2)#<cfelse>#TLFormat(0,2)#</cfif>&nbsp;</td>
                                    <cfif attributes.price_catid neq -1 or attributes.price_catid neq -2><!--- Fiyatı Olmayan Ürünler Gösterilsin Denilmiş ise. --->
                                        <cfif LEN(PRODUCT_ID1)>
                                            <td style="text-align:center;" width="30">#(LIST_MONEY)#</td>
                                        <cfelse>
                                            <td>&nbsp;</td>
                                        </cfif>
                                    </cfif>   
                            </cfif>
                            
                            <cfif ListFind(attributes.select_option,18)><!--- Maliyet --->
                                <cfquery name="GET_PRODUCT_COST" dbtype="query" maxrows="1">
                                    SELECT * FROM GET_PRODUCT_COST_ALL WHERE PRODUCT_ID=#get_product.PRODUCT_ID# ORDER BY START_DATE DESC,RECORD_DATE DESC
                                </cfquery>
                                <cfif len(GET_PRODUCT_COST.PRODUCT_COST)>
                                    <td style="text-align:right;">#TLFormat(GET_PRODUCT_COST.PRODUCT_COST,2)#</td>
                                <cfelse>
                                    <td style="text-align:right;"><cf_get_lang dictionary_id ='40263.Maliyet Yok'></td>
                                </cfif>
                                <td  style="text-align:center;">#GET_PRODUCT_COST.MONEY#</td>
                                <cfif GET_PRODUCT_COST.RECORDCOUNT and (GET_PRODUCT_COST.PRODUCT_COST neq 0) and isdefined('satis_fiyat')>
                                    <cfset cost_diff = satis_fiyat - GET_PRODUCT_COST.PRODUCT_COST>
                                    <cfset oran = (cost_diff / GET_PRODUCT_COST.PRODUCT_COST* 100)><!--- Yüzdelik oran kar/zarar --->
                                <cfelse>
                                    <cfset cost_diff = get_product.price_kdv>
                                    <cfset oran = "">
                                </cfif>
                                <td style="text-align:right;"><cfif cost_diff lt 0><font color="##FF0000"></cfif>#TLFormat(cost_diff,2)# & %#TLFormat(oran,2)#<cfif cost_diff lt 0></font></cfif></td>
                            </cfif>
                            <cfif ListFind(attributes.select_option,17)><!--- İmaj --->
                                <td><cfif listfind(image_id_list,get_product.PRODUCT_ID,',')><font color="fFF0000">#get_images.URUN_SAYISI[listfind(image_id_list,get_product..PRODUCT_ID,',')]#</font><cfelse><cf_get_lang dictionary_id='58546.YOK'></cfif></td>
                            </cfif>
                            <cfif listFind(attributes.select_option,21)>
                                <td>#shelf_code#</td>
                            </cfif>
                            <td style="text-align:center;"><cfif STATUS_INFO eq 1><cf_get_lang dictionary_id ='57493.Aktif'><cfelse><font color="FFF0000"><cf_get_lang dictionary_id ='57494.Pasif'></font></cfif></td>
                            <cfif listFind(attributes.select_option,28)>
                                <cfif get_property_variation.recordcount neq 0>
                                    <cfloop from="1" to="#get_property_variation.recordcount#" index="main_str">
                                        <cfif get_property_variation.property_id[main_str] neq get_property_variation.property_id[main_str-1]>
                                            
                                            <cfquery datasource="#dsn1_alias#" name="get_variation">
                                                SELECT PPD.PROPERTY_DETAIL FROM PRODUCT_DT_PROPERTIES AS PDP
                                                LEFT JOIN PRODUCT_PROPERTY_DETAIL AS PPD ON PDP.VARIATION_ID = PPD.PROPERTY_DETAIL_ID
                                                WHERE PDP.PRODUCT_ID = #get_product.PRODUCT_ID# AND PDP.PROPERTY_ID =#get_property_variation.property_id[main_str]#
                                            </cfquery>
                                            <td style="text-align:center;">#get_variation.PROPERTY_DETAIL#</td>
                                        </cfif>
                                    </cfloop>
                                </cfif>
                            </cfif>
                        </tr>
                    </tbody>
                </cfoutput>
            <cfelse>
                <tbody>
                    <tr>
                        <td colspan="20">
                            <cf_get_lang dictionary_id='57484.Kayıt Yok'>!
                        </td>
                    </tr>
                </tbody>
            </cfif>  
        <cfif isdefined("get_product") and get_product.recordcount>
            <cfparam name="attributes.totalrecords" default='#get_product.recordcount#'>
        <!---	<cfif isdefined('attributes.is_empty_price')>
        --->		<cfset toplam=get_product.recordcount>
                <cfset attributes.totalrecords=toplam>
            <!---</cfif>--->
        <cfelse>
            <cfset attributes.totalrecords=''>
        </cfif>
   </cf_report_list>
</cfif>
<cfif isdefined('attributes.totalrecords') and attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = attributes.fuseaction >
	<cfif len(attributes.is_form_submited)>
		<cfset url_str =  "#url_str#&is_form_submited=#attributes.is_form_submited#">
	</cfif>
	<cfif isdefined('attributes.is_empty_price')>
		<cfset url_str =  "#url_str#&is_empty_price=#attributes.is_empty_price#">
	</cfif>
	<cfif len(attributes.select_option)>
		<cfset url_str =  "#url_str#&select_option=#attributes.select_option#">
	</cfif>
	<cfif len(attributes.status)>
		<cfset url_str =  "#url_str#&status=#attributes.status#">
	</cfif>
	<cfif len(attributes.cat)>
		<cfset url_str =  "#url_str#&cat=#attributes.cat#">
	</cfif>
	<cfif len(attributes.category)>
		<cfset url_str =  "#url_str#&category=#attributes.category#">
	</cfif>
	<cfif len(attributes.marks)>
		<cfset url_str =  "#url_str#&marks=#attributes.marks#">
	</cfif>
	<cfif len(attributes.SEGMENT_ID)>
		<cfset url_str =  "#url_str#&SEGMENT_ID=#attributes.SEGMENT_ID#">
	</cfif>
	<cfif len(attributes.our_comp)>
		<cfset url_str =  "#url_str#&our_comp=#attributes.our_comp#">
	</cfif>
	<cfif len(attributes.pos_code)>
		<cfset url_str =  "#url_str#&pos_code=#attributes.pos_code#">
	</cfif>
	<cfif len(attributes.select_option)>
		<cfset url_str =  "#url_str#&select_option=#attributes.select_option#">
	</cfif>
	<cfif len(attributes.company_id)>
		<cfset url_str =  "#url_str#&company_id=#attributes.company_id#">
	</cfif>
	<cfif len(attributes.company)>
		<cfset url_str =  "#url_str#&company=#attributes.company#">
	</cfif>
	<cfif len(attributes.price_catid)>
		<cfset url_str =  "#url_str#&price_catid=#attributes.price_catid#">
	</cfif>
	<cfif len(attributes.sec)>
		<cfset url_str =  "#url_str#&sec=#attributes.sec#">
    </cfif>
    <cfif isDefined('attributes.list_property_id') and len(attributes.list_property_id)>
        <cfset url_str = '#url_str#&list_property_id=#attributes.list_property_id#'>
    </cfif>
    <cfif isDefined('attributes.list_property_value') and len(attributes.list_property_value)>
        <cfset url_str = '#url_str#&list_property_value=#attributes.list_property_value#'>
    </cfif>
    <cfif isDefined('attributes.list_variation_id') and len(attributes.list_variation_id)>
        <cfset url_str = '#url_str#&list_variation_id=#attributes.list_variation_id#'>
    </cfif>
        <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#url_str#">	
</cfif>
<script>
        function get_empty_option(price_catid)
        {
            if(price_catid == -1 || price_catid == -2)
                document.getElementById('is_empty_price_td').style.display = 'none';
            else
                document.getElementById('is_empty_price_td').style.display = '';
        }

        function showInformation(row)
        {
            if(document.getElementById("variation_id"+row).value=='')
                document.getElementById("information_row"+row).style.display='none';
            else
                document.getElementById("information_row"+row).style.display='';
        }
    
        function input_control()
        {   
            row_count=<cfoutput>#get_property_variation.recordcount#</cfoutput>;
            for(r=1;r<=row_count;r++)
            {   
                //deger_variation_id = eval("document.list_product.variation_id"+r);
                deger_variation_id = $('#variation_id'+r).val();//jquery ile multiple select değeri array olarak döner
                if(deger_variation_id!=undefined && deger_variation_id.value != "")
                {
                    deger_property_id = eval("document.list_product.property_id"+r);
                    deger_property_value=eval("document.list_product.information_select"+r);
                    
                    if(list_product.list_property_id.value.length==0) ayirac=''; else ayirac=',';
                    list_product.list_property_id.value=list_product.list_property_id.value+ayirac+deger_property_id.value;
                    //list_product.list_variation_id.value=list_product.list_variation_id.value+ayirac+deger_variation_id.value;
                    for (i = 0; i < deger_variation_id.length; i++) {
                        if(list_product.list_variation_id.value.length==0 || deger_variation_id[i]==0) ayirac2=''; else ayirac2=',';
                        list_product.list_variation_id.value = list_product.list_variation_id.value +ayirac2+ deger_variation_id[i];
                    }
                    if(list_product.list_property_id.value.length==0) ayirac=''; else ayirac=',';
                    if(deger_property_value.value=='')list_product.list_property_value.value=list_product.list_property_value.value+ayirac+'empty';
                    else list_product.list_property_value.value=list_product.list_property_value.value+ayirac+deger_property_value.value;
                    
                }
            }
            select_all('pos_code');
            if (document.getElementById('select_option').value==0)
            {
                alert("<cf_get_lang dictionary_id ='39098.Liste kategorisi seçmelisiniz'>!");
                return false;
            }
            if(document.list_product.is_excel.checked==false)
                {
                    document.list_product.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
                    return true;
                }
                else
                    document.list_product.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_detail_product_report</cfoutput>";
        }
        function select_all(selected_field)
        {
            var m = eval("document.list_product." + selected_field + ".length");
            for(i=0;i<m;i++)
            {
                eval("document.list_product."+selected_field+"["+i+"].selected=true")
            }
        }
        function remove_field(field_option_name)
        {
            field_option_name_value = eval('document.list_product.' + field_option_name);
            for (i=field_option_name_value.options.length-1;i>-1;i--)
            {
                if (field_option_name_value.options[i].selected==true)
                {
                    field_option_name_value.options.remove(i);
                }	
            }
        }
        list_product.list_property_id.value="";
	    list_product.list_property_value.value="";
	    list_product.list_variation_id.value="";
</script>