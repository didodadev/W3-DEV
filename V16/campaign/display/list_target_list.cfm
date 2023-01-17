<cf_xml_page_edit fuseact="campaign.form_add_target_market" is_multi_page="1">
    <cfinclude template="../query/get_target_markets.cfm">
    <cfparam name="attributes.consumer_id" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.tmarket_id" default="">
    <cfquery name="get_target_name" datasource="#dsn3#">
        SELECT 
            * 
        FROM 
            TARGET_AUDIENCE_RECORD
        WHERE
            TMARKET_ID = #attributes.TMARKET_ID#
           <cfif isdefined("attributes.CALL_STATUS") and attributes.CALL_STATUS  eq 1>
                AND CALL_STATUS = 1
           <cfelseif isdefined("attributes.CALL_STATUS") and attributes.CALL_STATUS  eq 0>
                AND CALL_STATUS = 0
           </cfif>
    </cfquery>
    <cfquery name="get_member" datasource="#dsn#"> 
        SELECT DISTINCT
            1 TYPE,
            C.CONSUMER_ID MEMBER_TYPE,
            C.CONSUMER_CAT_ID,
            C.CONSUMER_NAME MEMBER_NAME,
            C.CONSUMER_SURNAME MEMBER_SURNAME,
            '' COMPANY_NAME,
            C.CONSUMER_EMAIL USER_EMAIL,
            C.CONSUMER_FAXCODE FAXCODE,
            C.CONSUMER_FAX FAX_NO,
            C.CONSUMER_WORKTELCODE TELCODE,
            C.CONSUMER_WORKTEL TEL_NO,
            C.WORKADDRESS MEMBER_ADDRESS,
            C.WORKPOSTCODE MEMBER_POSTCODE,
            C.WORK_COUNTY_ID MEMBER_COUNTY,
            C.WORK_CITY_ID MEMBER_CITY,
            C.WORKSEMT MEMBER_SEMT,
            C.DEPARTMENT MEMBER_DEPARTMENT,
            C.COMPANY MEMBER_COMPANY,
            C.MISSION MEMBER_MISSION,
            C.BIRTHDATE
        FROM
            CONSUMER C
            <cfif isdefined('TMARKET.REQ_CONS') and len(TMARKET.REQ_CONS)>,MEMBER_REQ_TYPE</cfif>
            <cfif ListLen(TMARKET.CONS_REL_BRANCH) or ListLen(TMARKET.CONS_REL_COMP)>,COMPANY_BRANCH_RELATED AS CBR</cfif>
            <cfif ListLen(TMARKET.CONS_AGENT_POS_CODE,',')>,WORKGROUP_EMP_PAR AS WEP</cfif>
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
                <cfif ListLen(TMARKET.IS_CONS_BLACK_LIST) and TMARKET.IS_CONS_BLACK_LIST eq 1>AND C.CONSUMER_ID IN(SELECT CONSUMER_ID FROM COMPANY_CREDIT WHERE CONSUMER_ID IS NOT NULL AND OUR_COMPANY_ID = #session.ep.company_id# AND IS_BLACKLIST = 1)</cfif>
            <cfelse>
                    AND 1=0	
            </cfif>
    UNION ALL
        SELECT DISTINCT
            2 TYPE,
            CP.PARTNER_ID MEMBER_TYPE,
            '',
            CP.COMPANY_PARTNER_NAME MEMBER_NAME,
            CP.COMPANY_PARTNER_SURNAME MEMBER_SURNAME,
            C.FULLNAME COMPANY_NAME,
            CP.COMPANY_PARTNER_EMAIL USER_EMAIL,
            '' FAXCODE,
            CP.COMPANY_PARTNER_FAX FAX_NO,
            CP.MOBIL_CODE TELCODE,
            CP.MOBILTEL TEL_NO,
            CP.COMPANY_PARTNER_ADDRESS MEMBER_ADDRESS,
            CP.COMPANY_PARTNER_POSTCODE MEMBER_POSTCODE,
            CP.COUNTY MEMBER_COUNTY,
            CP.CITY MEMBER_CITY,
            CP.SEMT MEMBER_SEMT,
            CP.DEPARTMENT MEMBER_DEPARTMENT,
            '' MEMBER_COMPANY,
            CP.MISSION MEMBER_MISSION,
            '' BIRTHDATE
        FROM
            COMPANY_PARTNER CP,
            <cfif isdefined('TMARKET.REQ_COMP') and len(TMARKET.REQ_COMP)>MEMBER_REQ_TYPE,</cfif>
            COMPANY C
            <cfif ListLen(TMARKET.COMP_REL_BRANCH) or ListLen(TMARKET.COMP_REL_COMP)>,COMPANY_BRANCH_RELATED AS CBR</cfif>
            <cfif ListLen(TMARKET.COMP_AGENT_POS_CODE,',')>,WORKGROUP_EMP_PAR AS WEP</cfif>
            <cfif Listlen(TMARKET.COMP_PRODUCTCAT_LIST,',')>,WORKNET_RELATION_PRODUCT_CAT MRP</cfif>
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
                <cfif listlen(TMARKET.SECTOR_CATS)>
                    AND C.COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY_SECTOR_RELATION WHERE SECTOR_ID IN (#LISTSORT(TMARKET.SECTOR_CATS,"NUMERIC")#))
                <!--- AND C.SECTOR_CAT_ID IN () --->
                </cfif>
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
                <cfif isDefined("attributes.keyword") and len(attributes.keyword)>AND (CP.COMPANY_PARTNER_NAME LIKE '%#attributes.keyword#%' OR CP.COMPANY_PARTNER_SURNAME LIKE '%#attributes.keyword#%' OR C.FULLNAME LIKE '%#attributes.keyword#%' OR C.NICKNAME LIKE '%#attributes.keyword#%')</cfif>
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
    UNION ALL 
        SELECT 
            3 TYPE,
            -1 AS MEMBER_TYPE,
            -1 AS CONSUMER_CAT_ID,
            MAILLIST_NAME MEMBER_NAME,
            MAILLIST_SURNAME MEMBER_SURNAME,
            '' COMPANY_NAME,
            MAILLIST_EMAIL USER_EMAIL,
            '' AS FAXCODE,
            '' AS FAX_NO,
            MAILLIST_TELCOD TELCODE,
            MAILLIST_TEL TEL_NO,
            MAILLIST_ADDRESS MEMBER_ADDRESS,
            MAILLIST_POSTCODE MEMBER_POSTCODE,
            '' AS MEMBER_COUNTY,
            '' AS MEMBER_CITY,
            '' AS MEMBER_SEMT,
            '' AS MEMBER_DEPARTMENT,
            '' AS MEMBER_COMPANY,
            '' AS MEMBER_MISSION,
            '' AS BIRTHDATE
        FROM
            MAILLIST
        WHERE
            <cfif listfindnocase('3,4,5,6',TMARKET.TARGET_MARKET_TYPE)>
                1 = 1
            <cfelse>
                1 = 0
            </cfif>
        ORDER BY
            TYPE,
            COMPANY_NAME
    </cfquery> 
    <cfquery dbtype="query" name="get_member_consumer">
        SELECT MEMBER_TYPE FROM GET_MEMBER WHERE TYPE=1 
    </cfquery>
    <cfset currentrow_consumer=get_member_consumer.recordcount>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.fuseaction" default="">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_member.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfset county_list=''>
    <cfset city_list=''>
    <cfset department_list=''>
    <cfset position_list=''>
    <cfif get_member.recordcount>
        <cfoutput query="get_member" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <cfif len(member_county) and not listfind(county_list,member_county)>
                <cfset county_list=listappend(county_list,member_county)>
            </cfif>
            <cfif len(member_city) and not listfind(city_list,member_city)>
                <cfset city_list=listappend(city_list,member_city)>
            </cfif>
            <cfif len(member_department) and not listfind(department_list,member_department)>
                <cfset department_list=listappend(department_list,member_department)>
            </cfif>
            <cfif len(member_mission) and not listfind(position_list,member_mission)>
                <cfset position_list=listappend(position_list,member_mission)>
            </cfif>
        </cfoutput>
        <cfif len(county_list)>
            <cfquery name="get_counties" datasource="#dsn#">
                SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_list#) ORDER BY COUNTY_ID
            </cfquery>
            <cfset county_list = listsort(listdeleteduplicates(valuelist(get_counties.county_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif len(city_list)>
            <cfquery name="get_cities" datasource="#dsn#">
                SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#city_list#) ORDER BY CITY_ID
            </cfquery>
            <cfset city_list = listsort(listdeleteduplicates(valuelist(get_cities.city_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif len(department_list)>
            <cfquery name="get_departments" datasource="#dsn#">
                SELECT PARTNER_DEPARTMENT_ID, PARTNER_DEPARTMENT FROM SETUP_PARTNER_DEPARTMENT WHERE PARTNER_DEPARTMENT_ID IN (#department_list#) ORDER BY PARTNER_DEPARTMENT_ID
            </cfquery>
            <cfset department_list = listsort(listdeleteduplicates(valuelist(get_departments.partner_department_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif len(position_list)>
            <cfquery name="get_positions" datasource="#dsn#">
                SELECT PARTNER_POSITION_ID, PARTNER_POSITION FROM SETUP_PARTNER_POSITION WHERE PARTNER_POSITION_ID IN (#position_list#) ORDER BY PARTNER_POSITION_ID
            </cfquery>
            <cfset position_list = listsort(listdeleteduplicates(valuelist(get_positions.partner_position_id,',')),'numeric','ASC',',')>
        </cfif>
    </cfif>
    <cf_box >
        <cfform name="search" method="post" action="#request.self#?fuseaction=campaign.list_target_list">
            <input type="hidden" name="tmarket_id" id="tmarket_id" value="<cfoutput>#attributes.tmarket_id#</cfoutput>" />
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" placeholder="#getLang('','keyword','57460')#" name="keyword" maxlength="100" value="#attributes.keyword#">
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" >
                </div>
                <div class="form-group">
                    <cf_wrk_search_button  button_type="4">
                </div>
                <div class="form-group">
                    <a title="<cf_get_lang no='180.Etiket Bas'>" class="ui-btn ui-btn-gray2" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=campaign.popup_camp_list_label&tmarket_id=#attributes.tmarket_id#</cfoutput>')"><i class="fa fa-barcode"></i></a>
                </div> 
                <div class="form-group">  
                    <cfif is_target_record eq 1>
                        <cfif not get_target_name.recordcount>
                            <a href="<cfoutput>#request.self#?fuseaction=campaign.emptypopup_target_audience_record&tmarket_id=#attributes.tmarket_id#</cfoutput>" class="ui-btn ui-btn-gray2" title="Hedef Kitle Kaydet">  <i class="fa fa-cloud-upload"></i></a>
                        </cfif>
                    </cfif>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','Hedef kitle','49363')# : #tmarket.tmarket_name#" uidrop="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <cfif get_member.recordcount> 
                        <cfoutput query="get_member" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
                            <cfif get_member.type[1] eq 1 and currentrow eq 1>
                                <th colspan="9"><cf_get_lang dictionary_id='29406.Bireysel Üyeler'></th>
                                
                                <cfelseif get_member.type[1] eq 2 and currentrow eq 1>
                                <th colspan="9"><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></th>
                                    
                                <cfelseif get_member.type[1] eq 3 and currentrow eq 1>
                                    <th colspan="9"><cf_get_lang dictionary_id='32440.Mail Listesi'></th>
                                
                                </cfif>
                                <cfif (get_member.type[currentrow] neq get_member.type[currentrow-1] and currentrow neq 1) and get_member.type[currentrow] eq 2>
                                <th  colspan="9"><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></th>
                                    </tr>
                                <cfelseif (get_member.type[currentrow] neq get_member.type[currentrow-1] and currentrow neq 1) and get_member.type[currentrow] eq 3>
                                <th colspan="9"><cf_get_lang dictionary_id='32440.Mail Listesi'></th>
                        
                            </cfif>
                    </cfoutput>
                    </cfif>		
                </tr>
       
                <tr> 
                    <th width="15"><cfoutput>#getLang('','sıra','58577')#</cfoutput></th>
                    <th><cfoutput>#getLang('','ad','57570')#</cfoutput></th>
                    <th><cfoutput>#getLang('','pozisyon','57573')#</cfoutput></th>
                    <th><cfoutput>#getLang('','departman','57572')#</cfoutput></th>
                    <th><cfoutput>#getLang('','şirket','57574')#</cfoutput></th>
                    <th><cfoutput>#getLang('','adres','58723')#</cfoutput></th>
                    <th><cfoutput>#getLang('','e-posta','57428')#</cfoutput></th>
                    <th><cfoutput>#getLang('','Telefon','57499')#</cfoutput></th>
                </tr>
                
            </thead>
            <tbody>
            <cfset currentrow_partner=0>
            <cfif get_member.recordcount>  <cfoutput query="get_member" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td><cfif type eq 1>#currentrow#<cfelse>#currentrow-currentrow_consumer#</cfif></td>
                        <td>
                            <cfif TYPE eq 1>
                                <a href="#request.self#?fuseaction=member.consumer_list&event=det&cid=#member_type#">#member_name# #member_surname#</a>
                            <cfelseif TYPE eq 2>
                                <a href="#request.self#?fuseaction=member.list_contact&event=upd&pid=#member_type#">#member_name# #member_surname# / #company_name#</a>
                            <cfelse>
                                #member_name# #member_surname#	
                            </cfif>
                        </td>
                        <td><cfif len(member_mission)>#get_positions.partner_position[listfind(position_list,member_mission,',')]#</cfif></td>
                        <td><cfif len(member_department)>#get_departments.partner_department[listfind(department_list,member_department,',')]#</cfif></td>
                        <td>#company_name#</td>
                        <td>#member_address# #member_postcode# #member_semt# <cfif isdefined('get_counties')>#get_counties.county_name[listfind(county_list,member_county,',')]# /</cfif> <cfif isdefined('get_cities')>#get_cities.city_name[listfind(city_list,member_city,',')]#</cfif></td>
                        <td><cfif len(user_email)>#get_member.user_email#</cfif></td>
                        <td nowrap><cfif len(tel_no)>(#telcode#) #tel_no#</cfif></td>
                    </tr>
                </cfoutput>
        <cfelse>
                <tr>
                    <td colspan="9"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
                </tr>
            </cfif>
            </tbody>
        </cf_grid_list> 
        <cfif get_target_name.recordcount>
            <div><cf_get_lang dictionary_id='62728.Bu Hedef Kitle Kaydedilmiştir'></div>
        <cfelse>
            <div><cf_get_lang dictionary_id='62727.Bu Hedef Kitle Kaydedilmemiştir'></div>
        </cfif>
        <cfset url_str = "">
        <cfif attributes.totalrecords gt attributes.maxrows>
            
        <cfif len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
      
        <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="campaign.list_target_list&tmarket_id=#attributes.tmarket_id##url_str#">
      
        </cfif>
    </cf_box>
    