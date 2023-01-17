<cftransaction>
<cfquery name="TMARKET" datasource="#dsn3#">
	SELECT * FROM TARGET_MARKETS WHERE TMARKET_ID = #attributes.TMARKET_ID#
</cfquery>
<cfquery name="GET_NAME" datasource="#DSN3#">
        INSERT INTO 
            TARGET_AUDIENCE_RECORD
            (
            	TMARKET_ID,
                COMPANY_ID,
                PARTNER_ID,
                CONSUMER_ID,
                IS_TARGET_RECORD,
                OTHER_RECORD,
                CALL_STATUS,
                RECORD_DATE,
                RECORD_IP,
                UPDATE_DATE,
                UPDATE_IP
            )
        SELECT
            *
        FROM 
            (
                SELECT DISTINCT
                    #URL.TMARKET_ID# TMARKET_ID,
                    NULL AS PARTNER_ID ,
                    NULL AS COMPANY_ID,
                    C.CONSUMER_ID,
                    1 AS IS_TARGET_RECORD,
                    1 AS OTHER_RECORD,
                    1 AS CALL_STATUS,
                    #NOW()# AS RECORD_DATE,
                    '#CGI.REMOTE_ADDR#' AS RECORD_IP,
                    NULL AS UPDATE_DATE,
                    'NULL' AS UPDATE_IP
            	FROM
                    #DSN_ALIAS#.CONSUMER C
                    <cfif isdefined('TMARKET.REQ_CONS') and len(TMARKET.REQ_CONS)>,#DSN_ALIAS#.MEMBER_REQ_TYPE</cfif>
                    <cfif ListLen(TMARKET.CONS_REL_BRANCH) or ListLen(TMARKET.CONS_REL_COMP)>,#DSN_ALIAS#.COMPANY_BRANCH_RELATED AS CBR</cfif>
                    <cfif ListLen(TMARKET.CONS_AGENT_POS_CODE,',')>,#DSN_ALIAS#.WORKGROUP_EMP_PAR WEP</cfif>
                WHERE
                    <cfif TMARKET.cons_want_email eq 1>
                        C.WANT_EMAIL = 1
                    <cfelseif TMARKET.cons_want_email eq 0>
                        C.WANT_EMAIL = 0
                    <cfelse>
                        (C.WANT_EMAIL = 1 OR C.WANT_EMAIL = 0)
                    </cfif>
                    <cfif isdefined('TMARKET.REQ_CONS') and len(TMARKET.REQ_CONS)>
                        AND C.CONSUMER_ID=MEMBER_REQ_TYPE.CONSUMER_ID
                        AND REQ_ID IN (#TMARKET.REQ_CONS#)
                    </cfif>
                    <cfif Listlen(TMARKET.CONS_ID_LIST)>
                        AND C.CONSUMER_ID IN (#TMARKET.CONS_ID_LIST#)
                    </cfif>
                    <cfif listfindnocase('0,2,3,5',TMARKET.TARGET_MARKET_TYPE)>
                        <cfif ListLen(TMARKET.CONS_REL_BRANCH) or ListLen(TMARKET.CONS_REL_COMP)>
                            AND C.CONSUMER_ID = CBR.CONSUMER_ID
                            AND CBR.COMPANY_ID IS NULL
                        </cfif>
                        <cfif ListLen(TMARKET.CONS_AGENT_POS_CODE,',')>
                            AND C.CONSUMER_ID = WEP.CONSUMER_ID
                            AND WEP.CONSUMER_ID IS NOT NULL
                            AND WEP.IS_MASTER = 1 
                        </cfif>
                        <cfif listlen(TMARKET.CONS_STATUS)>AND C.CONSUMER_STATUS IN (#TMARKET.CONS_STATUS#)</cfif>
                        <cfif listlen(TMARKET.CONS_IS_POTANTIAL)>AND C.ISPOTANTIAL IN (#LISTSORT(TMARKET.CONS_IS_POTANTIAL,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.TMARKET_SEX)>AND C.SEX IN (#LISTSORT(TMARKET.TMARKET_SEX,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.TMARKET_MARITAL_STATUS)>AND C.MARRIED IN (#LISTSORT(TMARKET.TMARKET_MARITAL_STATUS,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.CONSCAT_IDS)>AND C.CONSUMER_CAT_ID IN (#LISTSORT(TMARKET.CONSCAT_IDS,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.CONS_SECTOR_CATS)>AND C.SECTOR_CAT_ID IN (#LISTSORT(TMARKET.CONS_SECTOR_CATS,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.CONS_SIZE_CATS)>AND C.COMPANY_SIZE_CAT_ID IN (#LISTSORT(TMARKET.CONS_SIZE_CATS,"NUMERIC")#)</cfif>
                        <cfif len(TMARKET.AGE_LOWER)>AND C.BIRTHDATE < #createODBCDateTime(DATEADD('YYYY',-TMARKET.AGE_LOWER,now()))#</cfif>
                        <cfif len(TMARKET.AGE_UPPER)>AND C.BIRTHDATE > #createODBCDateTime(DATEADD('YYYY',-TMARKET.AGE_UPPER,now()))#</cfif>
                        <cfif len(TMARKET.CHILD_LOWER)>AND C.CHILD >= #TMARKET.CHILD_LOWER#</cfif>
                        <cfif len(TMARKET.CHILD_UPPER)>AND C.CHILD <= #TMARKET.CHILD_UPPER#</cfif>
                        <cfif len(TMARKET.TMARKET_MEMBERSHIP_STARTDATE)> AND C.START_DATE >=# createODBCDateTime(TMARKET.TMARKET_MEMBERSHIP_STARTDATE)#</cfif>
                        <cfif len(TMARKET.TMARKET_MEMBERSHIP_FINISHDATE)> AND C.START_DATE <=# dateadd('d',1,createODBCDateTime(TMARKET.TMARKET_MEMBERSHIP_FINISHDATE))#</cfif>
                        <cfif listlen(TMARKET.CITY_ID)>AND C.WORK_CITY_ID IN (#LISTSORT(TMARKET.CITY_ID,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.COUNTY_ID)>AND C.WORK_COUNTY_ID IN (#LISTSORT(TMARKET.COUNTY_ID,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.CONSUMER_VALUE)>AND C.CUSTOMER_VALUE_ID IN (#LISTSORT(TMARKET.CONSUMER_VALUE,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.CONSUMER_IMS_CODE)>AND C.IMS_CODE_ID IN (#LISTSORT(TMARKET.CONSUMER_IMS_CODE,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.CONSUMER_RESOURCE)>AND C.RESOURCE_ID IN (#LISTSORT(TMARKET.CONSUMER_RESOURCE,"NUMERIC")#)</cfif>
                        <cfif len(TMARKET.CONSUMER_OZEL_KOD1)>AND C.OZEL_KOD LIKE '%#TMARKET.CONSUMER_OZEL_KOD1#%'</cfif>
                        <cfif listlen(TMARKET.CONSUMER_SALES_ZONE)>AND C.SALES_COUNTY IN (#LISTSORT(TMARKET.CONSUMER_SALES_ZONE,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.CONS_EDUCATION)>AND C.EDUCATION_ID IN (#LISTSORT(TMARKET.CONS_EDUCATION,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.CONS_VOCATION_TYPE)>AND C.VOCATION_TYPE_ID IN (#LISTSORT(TMARKET.CONS_VOCATION_TYPE,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.CONS_SOCIETY)>AND C.SOCIAL_SOCIETY_ID IN (#LISTSORT(TMARKET.CONS_SOCIETY,"NUMERIC")#)</cfif>
                        <cfif isDefined("attributes.keyword") and len(attributes.keyword)>AND( C.CONSUMER_NAME LIKE '%#attributes.keyword#%' OR C.CONSUMER_SURNAME LIKE '%#attributes.keyword#%')</cfif>
                        <cfif ListLen(TMARKET.CONS_REL_BRANCH)>
                            AND CBR.BRANCH_ID IN 
                            (
                                <cfloop from="1" to="#ListLen(TMARKET.CONS_REL_BRANCH)#" index="sayac">
                                    #ListGetAt(TMARKET.CONS_REL_BRANCH,sayac,',')#
                                    <cfif sayac lt ListLen(TMARKET.CONS_REL_BRANCH)>,</cfif>
                                </cfloop>
                            )
                        </cfif>
                        <cfif ListLen(TMARKET.CONS_REL_COMP)>
                            AND CBR.OUR_COMPANY_ID IN
                            (
                                <cfloop from="1" to="#ListLen(TMARKET.CONS_REL_COMP)#" index="sayac2">
                                    #ListGetAt(TMARKET.CONS_REL_COMP,sayac2,',')#
                                    <cfif sayac2 lt ListLen(TMARKET.CONS_REL_COMP)>,</cfif>
                                </cfloop>
                            )
                        </cfif>
                        <cfif ListLen(TMARKET.CONS_AGENT_POS_CODE,',')>
                            AND WEP.POSITION_CODE IN
                            (
                                <cfloop from="1" to="#listlen(TMARKET.CONS_AGENT_POS_CODE,',')#" index="sayac3">
                                    #ListGetAt(TMARKET.CONS_AGENT_POS_CODE,sayac3,',')#
                                    <cfif sayac3 lt ListLen(TMARKET.CONS_AGENT_POS_CODE)>,</cfif>
                                </cfloop>
                            )
                        </cfif>
                        <cfif ListLen(TMARKET.CONSUMER_STAGE)>AND C.CONSUMER_STAGE IN(#TMARKET.CONSUMER_STAGE#)</cfif>
                        <cfif ListLen(TMARKET.CONSUMER_BIRTHDATE)>AND C.BIRTHDATE = #createodbcdatetime(TMARKET.CONSUMER_BIRTHDATE)#</cfif>
                        <cfif len(TMARKET.CONS_PASSWORD_DAY)>
                            AND C.CONSUMER_PASSWORD NOT IN
                                (
                                    SELECT
                                        CH.CONSUMER_PASSWORD
                                    FROM
                                        #dsn_alias#.CONSUMER_HISTORY CH
                                    WHERE
                                        C.CONSUMER_ID = CH.CONSUMER_ID AND
                                        DATEDIFF(day,CH.RECORD_DATE,GETDATE()) < #TMARKET.CONS_PASSWORD_DAY#
                                    GROUP BY
                                        CH.CONSUMER_PASSWORD
                                )
                        </cfif>
                        <cfif TMARKET.IS_CONS_CEPTEL eq 1>AND C.MOBILTEL IS NOT NULL</cfif>
                        <cfif TMARKET.IS_CONS_EMAIL eq 1>AND C.CONSUMER_EMAIL IS NOT NULL</cfif>
                        <cfif TMARKET.IS_CONS_TAX eq 1>AND C.TAX_NO IS NOT NULL</cfif>
                        <cfif TMARKET.IS_CONS_DEBT eq 1>
                            AND C.CONSUMER_ID IN
                            (	
                                SELECT
                                    CONSUMER_ID
                                FROM
                                    #dsn2_alias#.CARI_ROWS_CONSUMER
                                WHERE
                                    DUE_DATE < GETDATE()
                                GROUP BY
                                    CONSUMER_ID
                                HAVING
                                    ROUND(SUM(BORC-ALACAK),5) >0
                            )
                        </cfif>
                        <cfif TMARKET.IS_CONS_OPEN_ORDER eq 1>
                            AND C.CONSUMER_ID IN
                            (
                                SELECT
                                    CONSUMER_ID
                                FROM
                                    #dsn3_alias#.ORDERS O,
                                    #dsn3_alias#.ORDER_ROW ORR
                                WHERE
                                    O.ORDER_STATUS = 1 AND
                                    O.CONSUMER_ID IS NOT NULL AND
                                    (
                                        (	O.PURCHASE_SALES = 1 AND
                                            O.ORDER_ZONE = 0
                                         )  
                                        OR
                                        (	O.PURCHASE_SALES = 0 AND
                                            O.ORDER_ZONE = 1
                                        )
                                    ) AND
                                    O.ORDER_ID = ORR.ORDER_ID AND
                                    O.CONSUMER_ID IS NOT NULL AND
                                    <cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
                                    <cfelseif isdate(TMARKET.ORDER_START_DATE)>O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
                                    <cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND</cfif>
                                    <cfif len(TMARKET.LAST_DAY_COUNT)>
                                        <cfif TMARKET.LAST_DAY_TYPE eq 1>DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 2>DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 3>DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 4>DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND</cfif>
                                    </cfif>
                                    ORR.ORDER_ROW_CURRENCY = -1
                            )
                        </cfif>
                        <cfif ListLen(TMARKET.TRAINING_ID)>
                            AND C.CONSUMER_ID IN
                            (
                                SELECT
                                    CON_ID
                                FROM
                                    #dsn_alias#.TRAINING_CLASS_ATTENDER
                                WHERE
                                    <cfloop from="1" to="#listlen(TMARKET.TRAINING_ID,',')#" index="sayac4">
                                        CLASS_ID = #ListGetAt(TMARKET.TRAINING_ID,sayac4,',')#
                                        <cfif sayac4 lt ListLen(TMARKET.TRAINING_ID)>
                                            <cfif TMARKET.TRAINING_STATUS eq 2>OR
                                            <cfelse>AND</cfif>
                                        </cfif>
                                    </cfloop>		
                            )
                        </cfif>
                        <cfif ListLen(TMARKET.PROMOTION_ID)>
                            AND C.CONSUMER_ID IN
                            (					
                                SELECT
                                    O.CONSUMER_ID
                                FROM
                                    #dsn3_alias#.ORDERS O,
                                    #dsn3_alias#.ORDER_ROW ORR
                                WHERE
                                    O.ORDER_STATUS = 1 AND
                                    O.CONSUMER_ID IS NOT NULL AND
                                    (
                                        (	O.PURCHASE_SALES = 1 AND
                                            O.ORDER_ZONE = 0
                                         )  
                                        OR
                                        (	O.PURCHASE_SALES = 0 AND
                                            O.ORDER_ZONE = 1
                                        )
                                    ) AND
                                    O.CONSUMER_ID IS NOT NULL AND
                                    O.ORDER_ID = ORR.ORDER_ID AND
                                    <cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
                                    <cfelseif isdate(TMARKET.ORDER_START_DATE)>O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
                                    <cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND</cfif>
                                    <cfif len(TMARKET.LAST_DAY_COUNT)>
                                        <cfif TMARKET.LAST_DAY_TYPE eq 1>DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 2>DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 3>DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 4>DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND</cfif>
                                    </cfif>
                                    <cfloop from="1" to="#listlen(TMARKET.PROMOTION_ID,',')#" index="sayac5">
                                        ORR.PROM_ID = #ListGetAt(TMARKET.PROMOTION_ID,sayac5,',')#
                                        <cfif sayac5 lt ListLen(TMARKET.PROMOTION_ID)>
                                            <cfif TMARKET.PROMOTION_STATUS eq 2>OR
                                                <cfelse>AND
                                            </cfif>
                                        </cfif>
                                    </cfloop>
                            )
                        </cfif>
                        <cfif ListLen(TMARKET.PROMOTION_COUNT)>
                            AND C.CONSUMER_ID IN
                            (								
                                SELECT
                                    O.CONSUMER_ID
                                FROM
                                    #dsn3_alias#.ORDERS O,
                                    #dsn3_alias#.ORDER_ROW ORR
                                WHERE
                                    O.ORDER_STATUS = 1 AND
                                    O.CONSUMER_ID IS NOT NULL AND
                                    (
                                        (	O.PURCHASE_SALES = 1 AND
                                            O.ORDER_ZONE = 0
                                         )  
                                        OR
                                        (	O.PURCHASE_SALES = 0 AND
                                            O.ORDER_ZONE = 1
                                        )
                                    ) AND
                                    O.ORDER_ID = ORR.ORDER_ID AND
                                    <cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
                                    <cfelseif isdate(TMARKET.ORDER_START_DATE)>O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
                                    <cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
                                    </cfif>
                                    <cfif len(TMARKET.LAST_DAY_COUNT)>
                                        <cfif TMARKET.LAST_DAY_TYPE eq 1>DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 2>DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 3>DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 4>DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                        </cfif>
                                    </cfif>								
                                    O.CONSUMER_ID IS NOT NULL AND
                                    ORR.PROM_ID IS NOT NULL
                                GROUP BY
                                    O.CONSUMER_ID
                                HAVING
                                    COUNT(PROM_ID) >= #TMARKET.PROMOTION_COUNT#
                            )
                        </cfif>
                        <cfif len(TMARKET.IS_GIVEN_ORDER) and (len(TMARKET.ORDER_START_DATE) or len(TMARKET.LAST_DAY_COUNT))>
                            AND C.CONSUMER_ID <cfif TMARKET.IS_GIVEN_ORDER eq 2> NOT </cfif>IN(								
                                                SELECT
                                                    O.CONSUMER_ID
                                                FROM
                                                    #dsn3_alias#.ORDERS O
                                                WHERE
                                                    O.ORDER_STATUS = 1 AND
                                                    O.CONSUMER_ID IS NOT NULL AND
                                                    (
                                                        (	O.PURCHASE_SALES = 1 AND
                                                            O.ORDER_ZONE = 0
                                                         )  
                                                        OR
                                                        (	O.PURCHASE_SALES = 0 AND
                                                            O.ORDER_ZONE = 1
                                                        )
                                                    ) AND
                                                    <cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
                                                    <cfelseif isdate(TMARKET.ORDER_START_DATE)>O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
                                                    <cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
                                                    </cfif>
                                                    <cfif len(TMARKET.LAST_DAY_COUNT)>
                                                        <cfif TMARKET.LAST_DAY_TYPE eq 1>DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 2>DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 3>DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 4>DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        </cfif>
                                                    </cfif>								
                                                    O.CONSUMER_ID IS NOT NULL
                                                )
                        </cfif>
                        <cfif ListLen(TMARKET.ORDER_PRODUCT_ID)>
                            AND C.CONSUMER_ID IN(SELECT
                                                    O.CONSUMER_ID
                                                FROM
                                                    #dsn3_alias#.ORDERS O,
                                                    #dsn3_alias#.ORDER_ROW ORR
                                                WHERE
                                                    O.ORDER_STATUS = 1 AND
                                                    O.CONSUMER_ID IS NOT NULL AND
                                                    (
                                                        (	O.PURCHASE_SALES = 1 AND
                                                            O.ORDER_ZONE = 0
                                                         )  
                                                        OR
                                                        (	O.PURCHASE_SALES = 0 AND
                                                            O.ORDER_ZONE = 1
                                                        )
                                                    ) AND
                                                    O.CONSUMER_ID IS NOT NULL AND
                                                    O.ORDER_ID = ORR.ORDER_ID AND
                                                    <cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
                                                    <cfelseif isdate(TMARKET.ORDER_START_DATE)>O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
                                                    <cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
                                                    </cfif>
                                                    <cfif len(TMARKET.LAST_DAY_COUNT)>
                                                        <cfif TMARKET.LAST_DAY_TYPE eq 1>DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 2>DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 3>DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 4>DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        </cfif>
                                                    </cfif>
                                                    <cfloop from="1" to="#listlen(TMARKET.ORDER_PRODUCT_ID,',')#" index="sayac6">
                                                        ORR.PRODUCT_ID = #ListGetAt(TMARKET.ORDER_PRODUCT_ID,sayac6,',')#
                                                        <cfif sayac6 lt ListLen(TMARKET.ORDER_PRODUCT_ID)>
                                                            <cfif TMARKET.ORDER_PRODUCT_STATUS eq 2>OR
                                                            <cfelse>AND
                                                            </cfif>
                                                        </cfif>
                                                    </cfloop>
                                                )
                        </cfif>
                        <cfif ListLen(TMARKET.ORDER_PRODUCTCAT_ID)>
                            AND C.CONSUMER_ID IN(SELECT
                                                    O.CONSUMER_ID
                                                FROM
                                                    #dsn3_alias#.ORDERS O,
                                                    #dsn3_alias#.ORDER_ROW ORR,
                                                    #dsn3_alias#.PRODUCT P
                                                WHERE
                                                    O.ORDER_STATUS = 1 AND
                                                    O.CONSUMER_ID IS NOT NULL AND
                                                    (
                                                        (	O.PURCHASE_SALES = 1 AND
                                                            O.ORDER_ZONE = 0
                                                         )  
                                                        OR
                                                        (	O.PURCHASE_SALES = 0 AND
                                                            O.ORDER_ZONE = 1
                                                        )
                                                    ) AND
                                                    O.CONSUMER_ID IS NOT NULL AND
                                                    O.ORDER_ID = ORR.ORDER_ID AND
                                                    P.PRODUCT_ID = ORR.PRODUCT_ID AND
                                                    <cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
                                                    <cfelseif isdate(TMARKET.ORDER_START_DATE)>O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
                                                    <cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
                                                    </cfif>
                                                    <cfif len(TMARKET.LAST_DAY_COUNT)>
                                                        <cfif TMARKET.LAST_DAY_TYPE eq 1>DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 2>DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 3>DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 4>DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        </cfif>
                                                    </cfif>
                                                    <cfloop from="1" to="#listlen(TMARKET.ORDER_PRODUCTCAT_ID,',')#" index="sayac7">
                                                        P.PRODUCT_CATID = #ListGetAt(TMARKET.ORDER_PRODUCTCAT_ID,sayac7,',')#
                                                        <cfif sayac7 lt ListLen(TMARKET.ORDER_PRODUCTCAT_ID)>
                                                            <cfif TMARKET.ORDER_PRODUCTCAT_STATUS eq 2>OR
                                                            <cfelse>AND
                                                            </cfif>
                                                        </cfif>
                                                    </cfloop>
                                                )
                        </cfif>
                        <cfif ListLen(TMARKET.ORDER_COMMETHOD_ID)>
                            AND C.CONSUMER_ID IN(SELECT
                                                    O.CONSUMER_ID
                                                FROM
                                                    #dsn3_alias#.ORDERS O
                                                WHERE
                                                    O.ORDER_STATUS = 1 AND
                                                    O.CONSUMER_ID IS NOT NULL AND
                                                    (
                                                        (	O.PURCHASE_SALES = 1 AND
                                                            O.ORDER_ZONE = 0
                                                         )  
                                                        OR
                                                        (	O.PURCHASE_SALES = 0 AND
                                                            O.ORDER_ZONE = 1
                                                        )
                                                    ) AND
                                                    O.CONSUMER_ID IS NOT NULL AND
                                                    <cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
                                                    <cfelseif isdate(TMARKET.ORDER_START_DATE)>O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
                                                    <cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
                                                    </cfif>
                                                    <cfif len(TMARKET.LAST_DAY_COUNT)>
                                                        <cfif TMARKET.LAST_DAY_TYPE eq 1>DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 2>DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 3>DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 4>DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        </cfif>
                                                    </cfif>
                                                    COMMETHOD_ID IS NOT NULL AND 
                                                    COMMETHOD_ID IN(#TMARKET.ORDER_COMMETHOD_ID#)
                                                )
                        </cfif>
                        <cfif ListLen(TMARKET.ORDER_PAYMETHOD_ID)>
                            AND C.CONSUMER_ID IN(SELECT
                                                    O.CONSUMER_ID
                                                FROM
                                                    #dsn3_alias#.ORDERS O
                                                WHERE
                                                    O.ORDER_STATUS = 1 AND
                                                    O.CONSUMER_ID IS NOT NULL AND
                                                    (
                                                        (	O.PURCHASE_SALES = 1 AND
                                                            O.ORDER_ZONE = 0
                                                         )  
                                                        OR
                                                        (	O.PURCHASE_SALES = 0 AND
                                                            O.ORDER_ZONE = 1
                                                        )
                                                    ) AND
                                                    O.CONSUMER_ID IS NOT NULL AND
                                                    <cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
                                                    <cfelseif isdate(TMARKET.ORDER_START_DATE)>O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
                                                    <cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
                                                    </cfif>
                                                    <cfif len(TMARKET.LAST_DAY_COUNT)>
                                                        <cfif TMARKET.LAST_DAY_TYPE eq 1>DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 2>DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 3>DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 4>DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        </cfif>
                                                    </cfif>
                                                    PAYMETHOD IS NOT NULL AND
                                                    PAYMETHOD IN(#TMARKET.ORDER_PAYMETHOD_ID#)
                                                )
                        </cfif>
                        <cfif ListLen(TMARKET.ORDER_CARDPAYMETHOD_ID)>
                            AND C.CONSUMER_ID IN(SELECT
                                                    O.CONSUMER_ID
                                                FROM
                                                    #dsn3_alias#.ORDERS O
                                                WHERE
                                                    O.ORDER_STATUS = 1 AND
                                                    O.CONSUMER_ID IS NOT NULL AND
                                                    (
                                                        (	O.PURCHASE_SALES = 1 AND
                                                            O.ORDER_ZONE = 0
                                                         )  
                                                        OR
                                                        (	O.PURCHASE_SALES = 0 AND
                                                            O.ORDER_ZONE = 1
                                                        )
                                                    ) AND
                                                    O.CONSUMER_ID IS NOT NULL AND
                                                    <cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
                                                    <cfelseif isdate(TMARKET.ORDER_START_DATE)>O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
                                                    <cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
                                                    </cfif>
                                                    <cfif len(TMARKET.LAST_DAY_COUNT)>
                                                        <cfif TMARKET.LAST_DAY_TYPE eq 1>DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 2>DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 3>DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 4>DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        </cfif>
                                                    </cfif>
                                                    CARD_PAYMETHOD_ID IS NOT NULL AND
                                                    CARD_PAYMETHOD_ID IN(#TMARKET.ORDER_CARDPAYMETHOD_ID#)
                                                )
                        </cfif>
                        <cfif ListLen(TMARKET.ORDER_AMOUNT)>
                            AND C.CONSUMER_ID IN(
                                                SELECT
                                                    O.CONSUMER_ID
                                                FROM
                                                    #dsn3_alias#.ORDERS O
                                                WHERE
                                                    O.ORDER_STATUS = 1 AND
                                                    O.CONSUMER_ID IS NOT NULL AND
                                                    (
                                                        (	O.PURCHASE_SALES = 1 AND
                                                            O.ORDER_ZONE = 0
                                                         )  
                                                        OR
                                                        (	O.PURCHASE_SALES = 0 AND
                                                            O.ORDER_ZONE = 1
                                                        )
                                                    ) AND
                                                    <cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
                                                    <cfelseif isdate(TMARKET.ORDER_START_DATE)>O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
                                                    <cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
                                                    </cfif>
                                                    <cfif len(TMARKET.LAST_DAY_COUNT)>
                                                        <cfif TMARKET.LAST_DAY_TYPE eq 1>DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 2>DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 3>DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 4>DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        </cfif>
                                                    </cfif>
                                                    O.CONSUMER_ID IS NOT NULL
                                                GROUP BY 
                                                    CONSUMER_ID
                                                HAVING 
                                                    <cfif TMARKET.ORDER_AMOUNT_TYPE eq 1>SUM(O.NETTOTAL) >= #TMARKET.ORDER_AMOUNT#
                                                    <cfelseif TMARKET.ORDER_AMOUNT_TYPE eq 2>SUM(O.NETTOTAL) <= #TMARKET.ORDER_AMOUNT#
                                                    <cfelseif TMARKET.ORDER_AMOUNT_TYPE eq 3>SUM(O.NETTOTAL) = #TMARKET.ORDER_AMOUNT#
                                                    <cfelse>SUM(O.NETTOTAL)/COUNT(ORDER_ID) = #TMARKET.ORDER_AMOUNT#
                                                    </cfif>
                                            )
                        </cfif>
                        <cfif ListLen(TMARKET.ORDER_COUNT)>
                            AND C.CONSUMER_ID IN(
                                                SELECT
                                                    O.CONSUMER_ID
                                                FROM
                                                    #dsn3_alias#.ORDERS O
                                                WHERE
                                                    O.ORDER_STATUS = 1 AND
                                                    O.CONSUMER_ID IS NOT NULL AND
                                                    (
                                                        (	O.PURCHASE_SALES = 1 AND
                                                            O.ORDER_ZONE = 0
                                                         )  
                                                        OR
                                                        (	O.PURCHASE_SALES = 0 AND
                                                            O.ORDER_ZONE = 1
                                                        )
                                                    ) AND
                                                    <cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
                                                    <cfelseif isdate(TMARKET.ORDER_START_DATE)>O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
                                                    <cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
                                                    </cfif>
                                                    <cfif len(TMARKET.LAST_DAY_COUNT)>
                                                        <cfif TMARKET.LAST_DAY_TYPE eq 1>DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 2>DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 3>DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 4>DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        </cfif>
                                                    </cfif>
                                                    O.CONSUMER_ID IS NOT NULL
                                                GROUP BY 
                                                    CONSUMER_ID
                                                HAVING 
                                                    <cfif TMARKET.ORDER_COUNT_TYPE eq 1>COUNT(ORDER_ID) >= #TMARKET.ORDER_COUNT#
                                                    <cfelseif TMARKET.ORDER_COUNT_TYPE eq 2>COUNT(ORDER_ID) <= #TMARKET.ORDER_COUNT#
                                                    <cfelseif TMARKET.ORDER_COUNT_TYPE eq 3>COUNT(ORDER_ID) = #TMARKET.ORDER_COUNT#
                                                    </cfif>
                                            )
                        </cfif>
                        <cfif ListLen(TMARKET.PRODUCT_COUNT)>
                            AND C.CONSUMER_ID IN(
                                                SELECT
                                                    O.CONSUMER_ID
                                                FROM
                                                    #dsn3_alias#.ORDERS O,
                                                    #dsn3_alias#.ORDER_ROW ORR
                                                WHERE
                                                    O.ORDER_STATUS = 1 AND
                                                    O.ORDER_ID = ORR.ORDER_ID AND
                                                    O.CONSUMER_ID IS NOT NULL AND
                                                    (
                                                        (	O.PURCHASE_SALES = 1 AND
                                                            O.ORDER_ZONE = 0
                                                         )  
                                                        OR
                                                        (	O.PURCHASE_SALES = 0 AND
                                                            O.ORDER_ZONE = 1
                                                        )
                                                    ) AND
                                                    <cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
                                                    <cfelseif isdate(TMARKET.ORDER_START_DATE)>O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
                                                    <cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
                                                    </cfif>
                                                    <cfif len(TMARKET.LAST_DAY_COUNT)>
                                                        <cfif TMARKET.LAST_DAY_TYPE eq 1>DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 2>DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 3>DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        <cfelseif TMARKET.LAST_DAY_TYPE eq 4>DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
                                                        </cfif>
                                                    </cfif>
                                                    O.CONSUMER_ID IS NOT NULL
                                                GROUP BY 
                                                    CONSUMER_ID
                                                HAVING 
                                                    <cfif TMARKET.PRODUCT_COUNT_TYPE eq 1>COUNT(PRODUCT_ID) >= #TMARKET.PRODUCT_COUNT#
                                                    <cfelseif TMARKET.PRODUCT_COUNT_TYPE eq 2>COUNT(PRODUCT_ID) <= #TMARKET.PRODUCT_COUNT#
                                                    <cfelseif TMARKET.PRODUCT_COUNT_TYPE eq 3>COUNT(PRODUCT_ID) = #TMARKET.PRODUCT_COUNT#
                                                    <cfelse>COUNT(ORR.PRODUCT_ID)/COUNT(O.ORDER_ID) = #TMARKET.PRODUCT_COUNT#
                                                    </cfif>
                                            )
                        </cfif>
                    <cfelse>
                            AND 1=0	
                    </cfif>
            UNION ALL
                SELECT DISTINCT
                    #URL.TMARKET_ID# TMARKET_ID,
                    CP.COMPANY_ID,
                    CP.PARTNER_ID,
                    NULL AS CONSUMER_ID,
                    1 AS IS_TARGET_RECORD,
                    1 AS OTHER_RECORD,
                    1  AS CALL_STATUS,
                 	#NOW()# AS RECORD_DATE,
                    '#CGI.REMOTE_ADDR#' AS RECORD_IP,
                    NULL AS UPDATE_DATE,
                    'NULL' AS UPDATE_IP
                FROM
                    #DSN_ALIAS#.COMPANY_PARTNER CP,
                    <cfif isdefined('TMARKET.REQ_COMP') and len(TMARKET.REQ_COMP)>#DSN_ALIAS#.MEMBER_REQ_TYPE,</cfif>
                    #DSN_ALIAS#.COMPANY C
                    <cfif ListLen(TMARKET.COMP_REL_BRANCH) or ListLen(TMARKET.COMP_REL_COMP)>,#DSN_ALIAS#.COMPANY_BRANCH_RELATED AS CBR</cfif>
                    <cfif ListLen(TMARKET.COMP_AGENT_POS_CODE,',')>,#DSN_ALIAS#.WORKGROUP_EMP_PAR WEP</cfif>
                    <cfif Listlen(TMARKET.COMP_PRODUCTCAT_LIST,',')>,#DSN_ALIAS#.WORKNET_RELATION_PRODUCT_CAT MRP</cfif>
                WHERE
                    C.COMPANY_ID = CP.COMPANY_ID
                    <cfif isdefined('TMARKET.REQ_COMP') and len(TMARKET.REQ_COMP)>
                        AND C.COMPANY_ID=MEMBER_REQ_TYPE.COMPANY_ID
                        AND REQ_ID IN (#TMARKET.REQ_COMP#)
                    </cfif>
                    <cfif TMARKET.comp_want_email eq 1>
                        AND CP.WANT_EMAIL = 1  
                    <cfelseif TMARKET.comp_want_email eq 0>
                        AND CP.WANT_EMAIL = 0 
                    <cfelse>
                        AND (CP.WANT_EMAIL = 1 OR CP.WANT_EMAIL = 0)
                    </cfif>
                    <cfif Listlen(TMARKET.COMP_ID_LIST)>
                        AND C.COMPANY_ID IN (#TMARKET.COMP_ID_LIST#)
                    </cfif>
                    <cfif Listlen(TMARKET.PARTNER_ID_LIST)>
                        AND CP.PARTNER_ID IN (#TMARKET.PARTNER_ID_LIST#)
                    </cfif>
                    <cfif ListLen(TMARKET.PARTNER_STAGE)>AND C.COMPANY_STATE IN(#TMARKET.PARTNER_STAGE#)</cfif>
                    <cfif listfindnocase('0,1,3,4',TMARKET.TARGET_MARKET_TYPE)>
                        <cfif ListLen(TMARKET.COMP_REL_BRANCH) or ListLen(TMARKET.COMP_REL_COMP)>
                            AND C.COMPANY_ID = CBR.COMPANY_ID
                            AND CP.COMPANY_ID = CBR.COMPANY_ID
                            AND CBR.CONSUMER_ID IS NULL
                        </cfif>
                        <cfif ListLen(TMARKET.COMP_AGENT_POS_CODE,',')>
                            AND C.COMPANY_ID = WEP.COMPANY_ID
                            AND WEP.COMPANY_ID IS NOT NULL
                            AND WEP.IS_MASTER = 1 
                        </cfif>
                        <cfif listlen(TMARKET.PARTNER_STATUS)>AND C.COMPANY_STATUS IN (#TMARKET.PARTNER_STATUS#)</cfif>
                        <cfif listlen(TMARKET.ONLY_FIRMMEMBER)>AND C.MANAGER_PARTNER_ID=CP.PARTNER_ID</cfif>
                        <cfif listlen(TMARKET.COMP_CONMEMBER)>AND C.IS_RELATED_COMPANY=#TMARKET.COMP_CONMEMBER#</cfif>
                        <cfif listlen(TMARKET.IS_POTANTIAL)>AND C.ISPOTANTIAL IN (#TMARKET.IS_POTANTIAL#)</cfif>
                        <cfif listlen(TMARKET.PARTNER_TMARKET_SEX)>AND CP.SEX IN (#LISTSORT(TMARKET.PARTNER_TMARKET_SEX,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.PARTNER_MISSION)>AND CP.MISSION IN (#LISTSORT(TMARKET.PARTNER_MISSION,"NUMERIC")#)</cfif>
                        <cfif TMARKET.IS_BUYER eq 1>AND C.IS_BUYER = 1</cfif>
                        <cfif TMARKET.IS_SELLER eq 1>AND C.IS_SELLER = 1</cfif>
                        <cfif listlen(TMARKET.SECTOR_CATS)>AND C.SECTOR_CAT_ID IN (#LISTSORT(TMARKET.SECTOR_CATS,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.COMPANY_SIZE_CATS)>AND C.COMPANY_SIZE_CAT_ID IN (#LISTSORT(TMARKET.COMPANY_SIZE_CATS,"NUMERIC")#)</cfif>
                        <cfif len(TMARKET.PARTNER_STATUS)>AND CP.COMPANY_PARTNER_STATUS	IN(#TMARKET.PARTNER_STATUS#)</cfif>
                        <cfif listlen(TMARKET.COMPANYCATS)>AND C.COMPANYCAT_ID IN (#LISTSORT(TMARKET.COMPANYCATS,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.PARTNER_DEPARTMENT)>AND CP.DEPARTMENT IN (#LISTSORT(TMARKET.PARTNER_DEPARTMENT,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.COMPANY_CITY_ID)>AND C.CITY IN (#LISTSORT(TMARKET.COMPANY_CITY_ID,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.COMPANY_COUNTY_ID)>AND C.COUNTY IN (#LISTSORT(TMARKET.COMPANY_COUNTY_ID,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.COMPANY_COUNTRY_ID)>AND C.COUNTRY IN (#LISTSORT(TMARKET.COMPANY_COUNTRY_ID,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.COUNTRY_ID)>AND C.COUNTRY IN (#LISTSORT(TMARKET.COUNTRY_ID,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.COMPANY_VALUE)>AND C.COMPANY_VALUE_ID IN (#LISTSORT(TMARKET.COMPANY_VALUE,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.COMPANY_IMS_CODE)>AND C.IMS_CODE_ID IN (#LISTSORT(TMARKET.COMPANY_IMS_CODE,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.COMPANY_RESOURCE)>AND C.RESOURCE_ID IN (#LISTSORT(TMARKET.COMPANY_RESOURCE,"NUMERIC")#)</cfif>
                        <cfif listlen(TMARKET.COMPANY_OZEL_KOD1)>AND C.OZEL_KOD  = '#TMARKET.COMPANY_OZEL_KOD1#'</cfif>
                        <cfif listlen(TMARKET.COMPANY_OZEL_KOD2)>AND C.OZEL_KOD_1 = '#TMARKET.COMPANY_OZEL_KOD2#'</cfif>
                        <cfif listlen(TMARKET.COMPANY_OZEL_KOD3)>AND C.OZEL_KOD_2 = '#TMARKET.COMPANY_OZEL_KOD3#'</cfif>
                        <cfif listlen(TMARKET.COMPANY_SALES_ZONE)>AND C.SALES_COUNTY IN (#LISTSORT(TMARKET.COMPANY_SALES_ZONE,"NUMERIC")#)</cfif>
                        <cfif len(TMARKET.TMARKET_MEMBERSHIP_STARTDATE)>AND C.START_DATE >=# createODBCDateTime(TMARKET.TMARKET_MEMBERSHIP_STARTDATE)#</cfif>
                        <cfif len(TMARKET.TMARKET_MEMBERSHIP_FINISHDATE)>AND C.START_DATE <=# dateadd('d',1,createODBCDateTime(TMARKET.TMARKET_MEMBERSHIP_FINISHDATE))#</cfif>
                        <cfif isDefined("attributes.keyword") and len(attributes.keyword)>AND (CP.COMPANY_PARTNER_NAME LIKE '%#attributes.keyword#%' OR CP.COMPANY_PARTNER_SURNAME LIKE '%#attributes.keyword#%')</cfif>
                        <cfif ListLen(TMARKET.COMP_FIRM_LIST)>
                            AND C.FIRM_TYPE IN (',#TMARKET.COMP_FIRM_LIST#,')
                        </cfif>
                        <cfif Listlen(TMARKET.COMP_PRODUCTCAT_LIST)>
                            AND C.COMPANY_ID=MRP.COMPANY_ID
                            AND MRP.PRODUCT_CATID IN(#TMARKET.COMP_PRODUCTCAT_LIST#)
                        </cfif>
                        <cfif ListLen(TMARKET.COMP_REL_BRANCH)>
                            AND CBR.BRANCH_ID IN (
                                                <cfloop from="1" to="#ListLen(TMARKET.COMP_REL_BRANCH)#" index="sayac">
                                                #ListGetAt(TMARKET.COMP_REL_BRANCH,sayac,',')#
                                                    <cfif sayac lt ListLen(TMARKET.COMP_REL_BRANCH)>
                                                    ,
                                                    </cfif>
                                                </cfloop>
                                              )
                        </cfif>
                        <cfif ListLen(TMARKET.COMP_REL_COMP)>
                            AND CBR.OUR_COMPANY_ID IN (
                                                <cfloop from="1" to="#ListLen(TMARKET.COMP_REL_COMP)#" index="sayac2">
                                                #ListGetAt(TMARKET.COMP_REL_COMP,sayac2,',')#
                                                    <cfif sayac2 lt ListLen(TMARKET.COMP_REL_COMP)>
                                                    ,
                                                    </cfif>
                                                </cfloop>
                                              )
                        </cfif>
                        <cfif ListLen(TMARKET.COMP_AGENT_POS_CODE,',')>
                            AND WEP.POSITION_CODE IN
                                                    (
                                                <cfloop from="1" to="#listlen(TMARKET.COMP_AGENT_POS_CODE,',')#" index="sayac3">
                                                #ListGetAt(TMARKET.COMP_AGENT_POS_CODE,sayac3,',')#
                                                    <cfif sayac3 lt ListLen(TMARKET.COMP_AGENT_POS_CODE)>
                                                    ,
                                                    </cfif>
                                                </cfloop>
                                                    )
                        </cfif>
                <cfelse>
                    AND 1=0	
                </cfif>
                ) as xxx 
    </cfquery>
</cftransaction>
<cflocation url="#request.self#?fuseaction=campaign.list_target_list_extra&tmarket_id=#url.tmarket_id#" addtoken="no">
