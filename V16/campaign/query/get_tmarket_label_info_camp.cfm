<cfif isdefined("attributes.cont")>
	<!--- Buranin nerden geldigine bakilacak kullanilmiyorsa kaldirilacak FBS 20110819 --->
	<cfif isdefined('attributes.consumer_ids') and len(attributes.consumer_ids) or isdefined('attributes.partner_ids') and len(attributes.partner_ids)>
    	<cfquery name="get_camp_list_label_info" datasource="#dsn#">
			<cfif len(attributes.consumer_ids)>
				SELECT
					CONSUMER.CONSUMER_NAME AS NAME,
					CONSUMER.CONSUMER_SURNAME SURNAME,
					CONSUMER.COMPANY AS COMPANY,
					CONSUMER.HOMEADDRESS ADDRESS,
					CONSUMER.HOMEPOSTCODE AS POSCODE,
					CONSUMER.HOME_COUNTY_ID AS COUNTY,
					CONSUMER.HOME_CITY_ID AS CITY,
					CONSUMER.HOME_COUNTRY_ID AS COUNTRY,
					CONSUMER.HOMESEMT AS SEMT,
					CONSUMER.CONSUMER_HOMETELCODE TELCODE,
					CONSUMER.CONSUMER_HOMETEL TEL,
					
					CONSUMER.WORKADDRESS WORK_ADDRESS,
					CONSUMER.WORKPOSTCODE WORK_POSCODE,
					CONSUMER.WORK_COUNTY_ID WORK_COUNTY,
					CONSUMER.WORK_CITY_ID WORK_CITY,
					CONSUMER.WORK_COUNTRY_ID WORK_COUNTRY,
					CONSUMER.WORKSEMT WORK_SEMT,
					CONSUMER.CONSUMER_WORKTELCODE WORK_TELCODE,
					CONSUMER.CONSUMER_WORKTEL WORK_TEL
				FROM
					CONSUMER
				WHERE
					CONSUMER_ID IN (#attributes.consumer_ids#)
			</cfif>
			<cfif len(attributes.partner_ids) and len(attributes.consumer_ids)>
				UNION
			</cfif>	  
			<cfif len(attributes.partner_ids)>
				SELECT
					COMPANY_PARTNER.COMPANY_PARTNER_NAME AS NAME,
					COMPANY_PARTNER.COMPANY_PARTNER_SURNAME SURNAME,
					COMPANY.FULLNAME AS COMPANY,
					COMPANY_PARTNER.COMPANY_PARTNER_ADDRESS ADDRESS,
					COMPANY_PARTNER.COMPANY_PARTNER_POSTCODE AS POSCODE,
					COMPANY_PARTNER.COUNTY AS COUNTY,
					COMPANY_PARTNER.CITY AS CITY,
					COMPANY_PARTNER.COUNTRY AS COUNTRY,
					COMPANY_PARTNER.SEMT AS SEMT,
					COMPANY_PARTNER.COMPANY_PARTNER_TELCODE TELCODE,
					COMPANY_PARTNER.COMPANY_PARTNER_TEL TEL,
					
					COMPANY.COMPANY_ADDRESS WORK_ADDRESS,
					COMPANY.COMPANY_POSTCODE WORK_POSCODE,
					COMPANY.COUNTY WORK_COUNTY,
					COMPANY.CITY WORK_CITY,
					COMPANY.COUNTRY WORK_COUNTRY,
					COMPANY.SEMT WORK_SEMT,
					COMPANY.COMPANY_TELCODE WORK_TELCODE,
					COMPANY.COMPANY_TEL1 WORK_TEL
				FROM
					COMPANY_PARTNER,
					COMPANY
				WHERE
					COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
					COMPANY_PARTNER.PARTNER_ID IN (#attributes.partner_ids#)
		  </cfif>	  
	</cfquery>
  </cfif> 
<cfelse>
	<!--- Burasi Kampanya Liste Yoneticisi Ekranindaki Bilgileri Iceriyor --->
	<cfif isDefined("attributes.camp_id") and Len(attributes.camp_id)>
        <cfquery name="get_camp_list_label_info" datasource="#dsn#">
            SELECT
                CONSUMER.CONSUMER_NAME AS NAME,
                CONSUMER.CONSUMER_SURNAME SURNAME,
                CONSUMER.HOMEADDRESS ADDRESS,
                CONSUMER.COMPANY AS COMPANY,
                CONSUMER.HOMEPOSTCODE AS POSCODE,
                CONSUMER.HOME_COUNTY_ID AS COUNTY,
                CONSUMER.HOME_CITY_ID AS CITY,
                CONSUMER.HOME_COUNTRY_ID AS COUNTRY,
                CONSUMER.HOMESEMT AS SEMT,
                CONSUMER.CONSUMER_HOMETELCODE TELCODE,
                CONSUMER.CONSUMER_HOMETEL TEL,
                CONSUMER.WORKADDRESS WORK_ADDRESS,
                CONSUMER.WORKPOSTCODE WORK_POSCODE,
                CONSUMER.WORK_COUNTY_ID WORK_COUNTY,
                CONSUMER.WORK_CITY_ID WORK_CITY,
                CONSUMER.WORK_COUNTRY_ID WORK_COUNTRY,
                CONSUMER.WORKSEMT WORK_SEMT,
                CONSUMER.CONSUMER_WORKTELCODE WORK_TELCODE,
                CONSUMER.CONSUMER_WORKTEL WORK_TEL
            FROM
                CONSUMER
            WHERE
                 <cfif isDefined("attributes.keyword") and Len(attributes.keyword)>
                    (CONSUMER_NAME LIKE '%#attributes.keyword#%' OR CONSUMER_SURNAME LIKE '%#attributes.keyword#%') AND
                </cfif>
                <cfif isdefined("attributes.consumer_ids") and len(attributes.consumer_ids)>
                    CONSUMER_ID IN (#attributes.consumer_ids#)
                <cfelse>	
                    CONSUMER_ID IN (SELECT 
                                        CON_ID
                                    FROM 
                                        #dsn3_alias#.CAMPAIGN_TARGET_PEOPLE
                                    WHERE
                                        CAMP_ID = #attributes.CAMP_ID# AND
                                        CON_ID IS NOT NULL AND
                                        PAR_ID IS NULL
                                    <cfif isdefined("attributes.employee") and isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
                                        AND RECORD_EMP = #attributes.employee_id#
                                    </cfif>
                                    <cfif isdefined("attributes.date1") and len(attributes.date1)>
                                        AND RECORD_DATE >  #DATEADD("d",0,attributes.date1)#
                                    </cfif>
                                    <cfif isdefined("attributes.date2") and len(attributes.date2)>
                                        AND RECORD_DATE <= #DATEADD("d",1,attributes.date2)#
                                    </cfif>
                                    )
                </cfif>
        UNION ALL
            SELECT
                COMPANY_PARTNER.COMPANY_PARTNER_NAME AS NAME,
                COMPANY_PARTNER.COMPANY_PARTNER_SURNAME SURNAME,
                COMPANY_PARTNER.COMPANY_PARTNER_ADDRESS ADDRESS,
                COMPANY.FULLNAME AS COMPANY,
                COMPANY_PARTNER.COMPANY_PARTNER_POSTCODE AS POSCODE,
                COMPANY_PARTNER.COUNTY AS COUNTY,
                COMPANY_PARTNER.CITY AS CITY,
                COMPANY_PARTNER.COUNTRY AS COUNTRY,
                COMPANY_PARTNER.SEMT AS SEMT,
                COMPANY_PARTNER.COMPANY_PARTNER_TELCODE TELCODE,
                COMPANY_PARTNER.COMPANY_PARTNER_TEL TEL,
                COMPANY.COMPANY_ADDRESS WORK_ADDRESS,
                COMPANY.COMPANY_POSTCODE WORK_POSCODE,
                COMPANY.COUNTY WORK_COUNTY,
                COMPANY.CITY WORK_CITY,
                COMPANY.COUNTRY WORK_COUNTRY,
                COMPANY.SEMT WORK_SEMT,
                COMPANY.COMPANY_TELCODE WORK_TELCODE,
                COMPANY.COMPANY_TEL1 WORK_TEL
            FROM
                COMPANY_PARTNER,
                COMPANY
            WHERE
                <cfif  isDefined("attributes.keyword") and Len(attributes.keyword)>
                    (COMPANY_PARTNER_NAME LIKE '%#attributes.keyword#%' OR COMPANY_PARTNER_SURNAME LIKE '%#attributes.keyword#%') AND
                </cfif>
                COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
               <cfif isdefined("attributes.partner_ids") and len(attributes.partner_ids)>
                    COMPANY_PARTNER.PARTNER_ID IN (#attributes.partner_ids#)
               <cfelse>
                    COMPANY_PARTNER.PARTNER_ID IN (SELECT
                                                        PAR_ID
                                                    FROM
                                                        #dsn3_alias#.CAMPAIGN_TARGET_PEOPLE
                                                    WHERE
                                                        CAMP_ID = #attributes.CAMP_ID# AND
                                                        CON_ID IS NULL AND 
                                                        PAR_ID IS NOT NULL
                                                    <cfif isdefined("attributes.employee") and isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
                                                        AND RECORD_EMP = #attributes.employee_id#
                                                    </cfif>
                                                    <cfif isdefined("attributes.date1") and len(attributes.date1)>
                                                        AND RECORD_DATE > #DATEADD("d",0,attributes.date1)#
                                                    </cfif>
                                                    <cfif isdefined("attributes.date2") and len(attributes.date2)>
                                                        AND RECORD_DATE <= #DATEADD("d",1,attributes.date2)# 
                                                    </cfif>)
               </cfif>
        </cfquery>
    <!--- BurasiHedef Kitleler Ekranindaki Bilgileri Iceriyor --->
	<cfelseif isDefined("attributes.tmarket_id") and Len(attributes.tmarket_id)>
		<cfquery name="TMARKET" datasource="#DSN3#">
            SELECT
                *
            FROM
                TARGET_MARKETS
            WHERE
                1=1 
            <cfif isDefined("attributes.tmarket_id") and len(attributes.tmarket_id)>
                AND TMARKET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.tmarket_id#">)
            <cfelseif isdefined("attributes.keyword") and len(attributes.keyword)>
                AND (TMARKET_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                TMARKET_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
            </cfif>
            ORDER BY
                RECORD_DATE DESC
        </cfquery>
        <cfquery name="get_camp_list_label_info" datasource="#dsn#">
            SELECT
                'C' AS PARTNER_TYPE,
                C.CONSUMER_NAME AS NAME,
                C.CONSUMER_SURNAME SURNAME,
                C.HOMEADDRESS ADDRESS,
                C.COMPANY AS COMPANY,
                C.HOMEPOSTCODE AS POSCODE,
                C.HOME_COUNTY_ID AS COUNTY,
                C.HOME_CITY_ID AS CITY,
                C.HOME_COUNTRY_ID AS COUNTRY,
                C.HOMESEMT AS SEMT,
                C.CONSUMER_HOMETELCODE TELCODE,
                C.CONSUMER_HOMETEL TEL,
                C.WORKADDRESS WORK_ADDRESS,
                C.WORKPOSTCODE WORK_POSCODE,
                C.WORK_COUNTY_ID WORK_COUNTY,
                C.WORK_CITY_ID WORK_CITY,
                C.WORK_COUNTRY_ID WORK_COUNTRY,
                C.WORKSEMT WORK_SEMT,
               	C.CONSUMER_WORKTELCODE WORK_TELCODE,
                C.CONSUMER_WORKTEL WORK_TEL
            FROM
                CONSUMER C
                <cfif ListLen(TMARKET.CONS_REL_BRANCH) or ListLen(TMARKET.CONS_REL_COMP)>
                ,COMPANY_BRANCH_RELATED AS CBR
                </cfif>
                <cfif ListLen(TMARKET.CONS_AGENT_POS_CODE,',')>
                ,WORKGROUP_EMP_PAR WEP	
                </cfif>
            WHERE
                WANT_EMAIL = 1
                <cfif listfindnocase('0,2,3,5',TMARKET.TARGET_MARKET_TYPE)><!--- Bireysel Üye Seçili ise --->
                    <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                        AND ( C.CONSUMER_NAME LIKE '%#attributes.keyword#%' OR C.CONSUMER_SURNAME LIKE '%#attributes.keyword#%' )
                    </cfif>	
                    <cfif ListLen(TMARKET.CONS_REL_BRANCH) or ListLen(TMARKET.CONS_REL_COMP)>
                        AND C.CONSUMER_ID = CBR.CONSUMER_ID
                        AND CBR.COMPANY_ID IS NULL
                    </cfif>
                    <cfif ListLen(TMARKET.CONS_AGENT_POS_CODE,',')>
                        AND C.CONSUMER_ID = WEP.CONSUMER_ID
                        AND WEP.CONSUMER_ID IS NOT NULL
                        AND WEP.IS_MASTER = 1 
                    </cfif>
                    <cfif isdefined('TMARKET.REQ_CONS') and len(TMARKET.REQ_CONS)> 
                        <cfquery name="GET_REQ_PEOPLE_CONS" datasource="#DSN#">
                            SELECT 
                                CONSUMER_ID,
                                COUNT (CONSUMER_ID)
                            FROM 
                                MEMBER_REQ_TYPE 
                            WHERE 
                                REQ_ID IN (#TMARKET.REQ_CONS#)  
                            GROUP BY 
                                CONSUMER_ID 
                            HAVING 
                                COUNT(CONSUMER_ID) >= #ListLen(TMARKET.REQ_CONS,',')#
                        </cfquery>
                        <cfset C_REQ_CONS = ValueList(GET_REQ_PEOPLE_CONS.CONSUMER_ID,',')>
                        AND C.CONSUMER_ID IN (#C_REQ_CONS#)
                    </cfif>			
                    <cfif listlen(TMARKET.CONS_STATUS)>AND C.CONSUMER_STATUS IN (#TMARKET.CONS_STATUS#)</cfif>
                    <cfif listlen(TMARKET.CONS_IS_POTANTIAL)>AND C.ISPOTANTIAL IN (#LISTSORT(TMARKET.CONS_IS_POTANTIAL,"NUMERIC")#)</cfif>
                    <cfif listlen(TMARKET.TMARKET_SEX)>AND C.SEX IN (#LISTSORT(TMARKET.TMARKET_SEX,"NUMERIC")#)</cfif>
                    <cfif listlen(TMARKET.TMARKET_MARITAL_STATUS)>AND C.MARRIED IN (#LISTSORT(TMARKET.TMARKET_MARITAL_STATUS,"NUMERIC")#)</cfif>
                    <cfif listlen(TMARKET.CONSCAT_IDS)>AND C.CONSUMER_CAT_ID IN (#LISTSORT(TMARKET.CONSCAT_IDS,"NUMERIC")#)</cfif>
                    <cfif listlen(TMARKET.CONS_SECTOR_CATS)>AND C.SECTOR_CAT_ID IN (#LISTSORT(TMARKET.CONS_SECTOR_CATS,"NUMERIC")#)</cfif>
                    <cfif listlen(TMARKET.CONS_SIZE_CATS)>AND C.COMPANY_SIZE_CAT_ID IN (#LISTSORT(TMARKET.CONS_SIZE_CATS,"NUMERIC")#)</cfif>
                    <cfif len(TMARKET.AGE_LOWER)>
                        AND C.BIRTHDATE < #createODBCDateTime(DATEADD('YYYY',-TMARKET.AGE_LOWER,now()))#
                    </cfif>
                    <cfif len(TMARKET.AGE_UPPER)>
                        AND C.BIRTHDATE > #createODBCDateTime(DATEADD('YYYY',-TMARKET.AGE_UPPER,now()))#
                    </cfif>
                    <cfif len(TMARKET.CHILD_LOWER)>AND C.CHILD >= #TMARKET.CHILD_LOWER#</cfif>
                    <cfif len(TMARKET.CHILD_UPPER)>AND C.CHILD <= #TMARKET.CHILD_UPPER#</cfif>
                    <cfif len(TMARKET.TMARKET_MEMBERSHIP_STARTDATE)>AND C.START_DATE >=#TMARKET.TMARKET_MEMBERSHIP_STARTDATE#</cfif>
                    <cfif len(TMARKET.TMARKET_MEMBERSHIP_FINISHDATE)>AND C.START_DATE <=#TMARKET.TMARKET_MEMBERSHIP_FINISHDATE#</cfif>
                    <cfif listlen(TMARKET.CITY_ID)>AND C.WORK_CITY_ID IN (#LISTSORT(TMARKET.CITY_ID,"NUMERIC")#)</cfif>
                    <cfif listlen(TMARKET.COUNTY_ID)>AND C.WORK_COUNTY_ID IN (#LISTSORT(TMARKET.COUNTY_ID,"NUMERIC")#)</cfif>
                    <cfif listlen(TMARKET.CONSUMER_VALUE)>AND C.CUSTOMER_VALUE_ID IN (#LISTSORT(TMARKET.CONSUMER_VALUE,"NUMERIC")#)</cfif>
                    <cfif listlen(TMARKET.CONSUMER_IMS_CODE)>AND C.IMS_CODE_ID IN (#LISTSORT(TMARKET.CONSUMER_IMS_CODE,"NUMERIC")#)</cfif>
                    <cfif listlen(TMARKET.CONSUMER_RESOURCE)>AND C.RESOURCE_ID IN (#LISTSORT(TMARKET.CONSUMER_RESOURCE,"NUMERIC")#)</cfif>
                    <cfif len(TMARKET.CONSUMER_OZEL_KOD1)>AND C.OZEL_KOD LIKE '%TMARKET.CONSUMER_OZEL_KOD1%'</cfif>
                    <cfif listlen(TMARKET.CONSUMER_SALES_ZONE)>AND C.SALES_COUNTY IN (#LISTSORT(TMARKET.CONSUMER_SALES_ZONE,"NUMERIC")#)</cfif>
                    <cfif listlen(TMARKET.CONS_EDUCATION)>AND C.EDUCATION_ID IN (#LISTSORT(TMARKET.CONS_EDUCATION,"NUMERIC")#)</cfif>
                    <cfif listlen(TMARKET.CONS_VOCATION_TYPE)>AND C.VOCATION_TYPE_ID IN (#LISTSORT(TMARKET.CONS_VOCATION_TYPE,"NUMERIC")#)</cfif>
                    <cfif listlen(TMARKET.CONS_SOCIETY)>AND C.SOCIAL_SOCIETY_ID IN (#LISTSORT(TMARKET.CONS_SOCIETY,"NUMERIC")#)</cfif>
                    <cfif ListLen(TMARKET.CONS_REL_BRANCH)>
                        AND CBR.BRANCH_ID IN (
                                            <cfloop from="1" to="#ListLen(TMARKET.CONS_REL_BRANCH)#" index="sayac">
                                                #ListGetAt(TMARKET.CONS_REL_BRANCH,sayac,',')#
                                                <cfif sayac lt ListLen(TMARKET.CONS_REL_BRANCH)>,</cfif>
                                            </cfloop>
                                            )
                    </cfif>
                    <cfif ListLen(TMARKET.CONS_REL_COMP)>
                        AND CBR.OUR_COMPANY_ID IN (
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
                <cfelse>
                        AND 1=0	
                </cfif>
        UNION ALL
            SELECT
                'P' AS PARTNER_TYPE,
                CP.COMPANY_PARTNER_NAME AS NAME,
                CP.COMPANY_PARTNER_SURNAME AS SURNAME,
                CP.COMPANY_PARTNER_ADDRESS ADDRESS,
                C.FULLNAME AS COMPANY,
                CP.COMPANY_PARTNER_POSTCODE AS POSCODE,
                CP.COUNTY AS COUNTY,
                CP.CITY AS CITY,
                CP.COUNTRY AS COUNTRY,
                CP.SEMT AS SEMT,
                CP.COMPANY_PARTNER_TELCODE TELCODE,
                CP.COMPANY_PARTNER_TEL TEL,
                C.COMPANY_ADDRESS WORK_ADDRESS,
                C.COMPANY_POSTCODE WORK_POSCODE,
                C.COUNTY WORK_COUNTY,
                C.CITY WORK_CITY,
                C.COUNTRY WORK_COUNTRY,
                C.SEMT WORK_SEMT,
                C.COMPANY_TELCODE WORK_TELCODE,
                C.COMPANY_TEL1 WORK_TEL
            FROM
                COMPANY_PARTNER CP,
                COMPANY C
                <cfif ListLen(TMARKET.COMP_REL_BRANCH) or ListLen(TMARKET.COMP_REL_COMP)>
                ,COMPANY_BRANCH_RELATED AS CBR
                </cfif>
                <cfif ListLen(TMARKET.COMP_AGENT_POS_CODE,',')>
                ,WORKGROUP_EMP_PAR WEP	
                </cfif>
            WHERE
                C.COMPANY_ID = CP.COMPANY_ID
                <cfif listfindnocase('0,1,3,4',TMARKET.TARGET_MARKET_TYPE)><!--- Kurumsal üyeler seçili ise gelsin.Değilse getirmesin. --->
                    <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                        AND ( CP.COMPANY_PARTNER_NAME LIKE '%#attributes.keyword#%' OR CP.COMPANY_PARTNER_SURNAME LIKE '%#attributes.keyword#%' )
                    </cfif>	
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
                    <cfif isdefined('TMARKET.REQ_COMP') and len(TMARKET.REQ_COMP)>
                        <cfquery name="GET_REQ_PEOPLE" datasource="#DSN#">
                            SELECT 
                                PARTNER_ID,
                                COUNT (PARTNER_ID)
                            FROM 
                                MEMBER_REQ_TYPE 
                            WHERE 
                                REQ_ID IN (#TMARKET.REQ_COMP#)  
                            GROUP BY 
                                PARTNER_ID
                            HAVING
                                COUNT(PARTNER_ID) >= #ListLen(TMARKET.REQ_COMP,',')#
                        </cfquery>
                        <cfset C_REQ=ValueList(GET_REQ_PEOPLE.PARTNER_ID,',')>
                         AND CP.COMPANY_ID IN (#C_REQ#) 
                    </cfif>
                    <cfif listlen(TMARKET.PARTNER_STATUS)>AND C.COMPANY_STATUS IN (#TMARKET.PARTNER_STATUS#)</cfif>
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
                    <cfif listlen(TMARKET.COMPANY_VALUE)>AND C.COMPANY_VALUE_ID IN (#LISTSORT(TMARKET.COMPANY_VALUE,"NUMERIC")#)</cfif>
                    <cfif listlen(TMARKET.COMPANY_IMS_CODE)>AND C.IMS_CODE_ID IN (#LISTSORT(TMARKET.COMPANY_IMS_CODE,"NUMERIC")#)</cfif>
                    <cfif listlen(TMARKET.COMPANY_RESOURCE)>AND C.RESOURCE_ID IN (#LISTSORT(TMARKET.COMPANY_RESOURCE,"NUMERIC")#)</cfif>
                    <cfif listlen(TMARKET.COMPANY_OZEL_KOD1)>AND C.OZEL_KOD  = '#TMARKET.COMPANY_OZEL_KOD1#'</cfif>
                    <cfif listlen(TMARKET.COMPANY_OZEL_KOD2)>AND C.OZEL_KOD_1 = '#TMARKET.COMPANY_OZEL_KOD2#'</cfif>
                    <cfif listlen(TMARKET.COMPANY_OZEL_KOD3)>AND C.OZEL_KOD_2 = '#TMARKET.COMPANY_OZEL_KOD3#'</cfif>
                    <cfif listlen(TMARKET.COMPANY_SALES_ZONE)>AND C.SALES_COUNTY IN (#LISTSORT(TMARKET.COMPANY_SALES_ZONE,"NUMERIC")#)</cfif>
                    <cfif ListLen(TMARKET.COMP_REL_BRANCH)>
                        AND CBR.BRANCH_ID IN (
                                            <cfloop from="1" to="#ListLen(TMARKET.COMP_REL_BRANCH)#" index="sayac">
                                                #ListGetAt(TMARKET.COMP_REL_BRANCH,sayac,',')#
                                                <cfif sayac lt ListLen(TMARKET.COMP_REL_BRANCH)>,</cfif>
                                            </cfloop>
                                            )
                    </cfif>
                    <cfif ListLen(TMARKET.COMP_REL_COMP)>
                        AND CBR.OUR_COMPANY_ID IN (
                                            <cfloop from="1" to="#ListLen(TMARKET.COMP_REL_COMP)#" index="sayac2">
                                                #ListGetAt(TMARKET.COMP_REL_COMP,sayac2,',')#
                                                <cfif sayac2 lt ListLen(TMARKET.COMP_REL_COMP)>,</cfif>
                                            </cfloop>
                                            )
                    </cfif>
                    <cfif ListLen(TMARKET.COMP_AGENT_POS_CODE,',')>
                        AND WEP.POSITION_CODE IN (
                                            <cfloop from="1" to="#listlen(TMARKET.COMP_AGENT_POS_CODE,',')#" index="sayac3">
                                                #ListGetAt(TMARKET.COMP_AGENT_POS_CODE,sayac3,',')#
                                                <cfif sayac3 lt ListLen(TMARKET.COMP_AGENT_POS_CODE)>,</cfif>
                                            </cfloop>
                                            )
                    </cfif>
            <cfelse>
                AND 1=0	
            </cfif>
            ORDER BY
                PARTNER_TYPE,
                COMPANY,
                NAME,
                SURNAME
        </cfquery>
    </cfif>
</cfif>
