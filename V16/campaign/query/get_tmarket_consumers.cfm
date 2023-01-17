<!--- bu dosyadaki querynin nerdeyse aynısı query\get_tmarket_consumer_count.cfm . burdaki degiskilikler ordada yapılsın. "imza=HAKAN"--->
<cfquery name="GET_TMARKET_USERS" datasource="#DSN#">	
 SELECT DISTINCT
	<cfif isDefined("attributes.count")>
		COUNT (DISTINCT C.CONSUMER_ID) COUNT_CONSUMER
	<cfelse>
		C.CONSUMER_ID,
		C.CONSUMER_CAT_ID,
		C.CONSUMER_NAME,
		C.CONSUMER_SURNAME,
		C.CONSUMER_USERNAME,
		C.CONSUMER_EMAIL AS USER_EMAIL,
		C.CONSUMER_FAXCODE,
		C.CONSUMER_FAX,
		C.CONSUMER_WORKTELCODE,
		C.CONSUMER_WORKTEL,
		C.CONSUMER_TEL_EXT,
		C.CONSUMER_HOMETELCODE,
		C.CONSUMER_HOMETEL,
		C.MOBIL_CODE,
		C.MOBILTEL,
		LTRIM(RTRIM(C.MOBIL_CODE+C.MOBILTEL)) AS C_MOBILPHONE,		
		C.COMPANY,
		C.TITLE,
		C.MISSION,
		C.HOMEADDRESS,
		C.HOMEPOSTCODE,
		C.HOME_COUNTY_ID,
		C.HOME_CITY_ID,
		C.HOMESEMT,
		C.WORKADDRESS,
		C.WORKPOSTCODE,
		C.WORK_COUNTY_ID,
		C.WORK_CITY_ID,
		C.WORKSEMT,
		C.DEPARTMENT
	</cfif>
	FROM
		CONSUMER C
		<cfif ListLen(TMARKET.CONS_REL_BRANCH) or ListLen(TMARKET.CONS_REL_COMP)>
		,COMPANY_BRANCH_RELATED AS CBR
		</cfif>
		<cfif ListLen(TMARKET.CONS_AGENT_POS_CODE,',')>
		,WORKGROUP_EMP_PAR WEP	
		</cfif>
	<cfif listlen(TMARKET.CONSCAT_IDS)>
		,CONSUMER_CAT CC
	</cfif>
	<cfif listlen(TMARKET.CONS_SECTOR_CATS)>
		,SETUP_SECTOR_CATS SSC
	</cfif>
	<cfif listlen(TMARKET.CONS_SIZE_CATS)>
		,SETUP_COMPANY_SIZE_CATS SCSC
	</cfif>
	WHERE
		<cfif TMARKET.cons_want_email eq 1>
			C.WANT_EMAIL = 1 AND
		<cfelseif TMARKET.cons_want_email eq 0>
			C.WANT_EMAIL = 0 AND
		<cfelse>
			(C.WANT_EMAIL = 1 OR C.WANT_EMAIL = 0) AND
		</cfif>
	<cfif isdefined('TMARKET.REQ_CONS') and len(TMARKET.REQ_CONS)> 
		<cfquery name="GET_REQ_PEOPLE_CONS" datasource="#DSN#">
			SELECT 
				CONSUMER_ID,COUNT (CONSUMER_ID)
				FROM 
					MEMBER_REQ_TYPE 
				WHERE 
					REQ_ID IN (#TMARKET.REQ_CONS#)  
				GROUP BY 
					CONSUMER_ID HAVING COUNT(CONSUMER_ID)>=#ListLen(TMARKET.REQ_CONS,',')#
		</cfquery>
		<cfset C_REQ_CONS=ValueList(GET_REQ_PEOPLE_CONS.CONSUMER_ID,',')>
		<cfif len(C_REQ_CONS)>
			 C.CONSUMER_ID IN (#C_REQ_CONS#) AND
		</cfif>
	</cfif>
	<cfif ListLen(TMARKET.CONS_REL_BRANCH) or ListLen(TMARKET.CONS_REL_COMP)>
		C.CONSUMER_ID = CBR.CONSUMER_ID AND
		CBR.COMPANY_ID IS NULL AND
	</cfif>	
	<cfif ListLen(TMARKET.CONS_AGENT_POS_CODE,',')>
			C.CONSUMER_ID = WEP.CONSUMER_ID AND
			WEP.CONSUMER_ID IS NOT NULL	AND
			WEP.IS_MASTER = 1 AND 
	</cfif>	
	<cfif listlen(TMARKET.CONS_SIZE_CATS)>
		C.COMPANY_SIZE_CAT_ID = SCSC.COMPANY_SIZE_CAT_ID AND
		C.COMPANY_SIZE_CAT_ID IN (#LISTSORT(TMARKET.CONS_SIZE_CATS,"NUMERIC")#) AND
	</cfif>
	<cfif listlen(TMARKET.CONS_STATUS)>
		 C.CONSUMER_STATUS IN (#TMARKET.CONS_STATUS#) AND
	</cfif>
	<cfif listlen(TMARKET.CONS_SECTOR_CATS)>
		C.SECTOR_CAT_ID = SSC.SECTOR_CAT_ID AND
		C.SECTOR_CAT_ID IN (#LISTSORT(TMARKET.CONS_SECTOR_CATS,"NUMERIC")#) AND
	</cfif>
	<cfif listlen(TMARKET.CONSCAT_IDS)>
		C.CONSUMER_CAT_ID = CC.CONSCAT_ID AND
		CC.CONSCAT_ID IN (#LISTSORT(TMARKET.CONSCAT_IDS,"NUMERIC")#) AND
	</cfif>
	<cfif len(TMARKET.AGE_LOWER)>
		DATEDIFF(YEAR, C.BIRTHDATE, #now()#) >= #TMARKET.AGE_LOWER# AND
	</cfif>
	<cfif len(TMARKET.AGE_UPPER)>
		DATEDIFF(YEAR, C.BIRTHDATE, #now()#) <= #TMARKET.AGE_UPPER# AND
	</cfif>
	<cfif len(TMARKET.CHILD_LOWER)>
		C.CHILD >= #TMARKET.CHILD_LOWER# AND
	</cfif>
	<cfif len(TMARKET.CHILD_UPPER)>
		C.CHILD <= #TMARKET.CHILD_UPPER# AND
	</cfif>
	<cfif len(TMARKET.TMARKET_MEMBERSHIP_STARTDATE)>
		C.RECORD_DATE >= '#TMARKET.TMARKET_MEMBERSHIP_STARTDATE#' AND
	</cfif>
	<cfif len(TMARKET.TMARKET_MEMBERSHIP_FINISHDATE)>
		C.RECORD_DATE <= '#TMARKET.TMARKET_MEMBERSHIP_FINISHDATE#' AND
	</cfif>
	<cfif listlen(TMARKET.CONS_IS_POTANTIAL)>
		C.ISPOTANTIAL IN (#LISTSORT(TMARKET.CONS_IS_POTANTIAL,"NUMERIC")#) AND
	</cfif>
	<cfif listlen(TMARKET.TMARKET_SEX)>
		C.SEX IN (#LISTSORT(TMARKET.TMARKET_SEX,"NUMERIC")#) AND
	</cfif>
	<cfif listlen(TMARKET.TMARKET_MARITAL_STATUS)>
		C.MARRIED IN (#LISTSORT(TMARKET.TMARKET_MARITAL_STATUS,"NUMERIC")#) AND
	</cfif>
	<cfif len(TMARKET.CITY_ID)>
		(	
			C.HOME_CITY_ID IN (#TMARKET.CITY_ID#) OR
			C.WORK_CITY_ID IN (#TMARKET.CITY_ID#) OR
			C.TAX_CITY_ID IN (#TMARKET.CITY_ID#)
		)
		AND
	</cfif>
	<cfif len(TMARKET.COUNTY_ID)>
		(
			C.HOME_COUNTY_ID IN (#TMARKET.COUNTY_ID#) OR
			C.WORK_COUNTY_ID IN (#TMARKET.COUNTY_ID#) OR
			C.TAX_COUNTY_ID IN (#TMARKET.COUNTY_ID#)
		)
		AND
	</cfif>
	<cfif len(TMARKET.CONSUMER_VALUE)>C.CUSTOMER_VALUE_ID IN (#TMARKET.CONSUMER_VALUE#) AND</cfif>
	<cfif len(TMARKET.CONSUMER_IMS_CODE)>C.IMS_CODE_ID IN (#TMARKET.CONSUMER_IMS_CODE#) AND</cfif>
	<cfif len(TMARKET.CONSUMER_HOBBY)>C.CONSUMER_ID IN (SELECT CONSUMER_ID FROM CONSUMER_HOBBY WHERE HOBBY_ID IN (#TMARKET.CONSUMER_HOBBY#)) AND</cfif>
	<cfif len(TMARKET.CONSUMER_RESOURCE)>C.RESOURCE_ID IN (#TMARKET.CONSUMER_RESOURCE#) AND</cfif>
	<cfif len(TMARKET.CONSUMER_OZEL_KOD1)>C.OZEL_KOD='#TMARKET.CONSUMER_OZEL_KOD1#' AND</cfif>
	<cfif len(TMARKET.CONSUMER_SALES_ZONE)>C.SALES_COUNTY IN (#TMARKET.CONSUMER_SALES_ZONE#) AND</cfif>
	<cfif len(TMARKET.CONS_EDUCATION)>C.EDUCATION_ID IN (#TMARKET.CONS_EDUCATION#) AND</cfif>
	<cfif len(TMARKET.CONS_VOCATION_TYPE)>C.VOCATION_TYPE_ID IN (#TMARKET.CONS_VOCATION_TYPE#) AND</cfif>
	<cfif len(TMARKET.CONS_SOCIETY)>C.SOCIAL_SOCIETY_ID IN (#TMARKET.CONS_SOCIETY#) AND</cfif>
	<cfif len(TMARKET.CONS_INCOME_LEVEL)>C.INCOME_LEVEL_ID IN (#TMARKET.CONS_INCOME_LEVEL#) AND</cfif>
		1=1
	<cfif isdefined("attributes.target_mass_all")>
		OR (
		C.CONSUMER_ID IN (SELECT CON_ID FROM #dsn3_alias#.CAMPAIGN_TARGET_PEOPLE WHERE CAMP_ID = #attributes.camp_id# AND PAR_ID IS NULL)
		)
	</cfif>
	<cfif ListLen(TMARKET.CONS_REL_BRANCH)>
		AND CBR.BRANCH_ID IN (
							<cfloop from="1" to="#ListLen(TMARKET.CONS_REL_BRANCH)#" index="sayac">
							#ListGetAt(TMARKET.CONS_REL_BRANCH,sayac,',')#
								<cfif sayac lt ListLen(TMARKET.CONS_REL_BRANCH)>
								,
								</cfif>
							</cfloop>
						  )
	</cfif>
	<cfif ListLen(TMARKET.CONS_REL_COMP)>
		AND CBR.OUR_COMPANY_ID IN (
							<cfloop from="1" to="#ListLen(TMARKET.CONS_REL_COMP)#" index="sayac2">
							#ListGetAt(TMARKET.CONS_REL_COMP,sayac2,',')#
								<cfif sayac2 lt ListLen(TMARKET.CONS_REL_COMP)>
								,
								</cfif>
							</cfloop>
						  )
	</cfif>
	<cfif ListLen(TMARKET.CONS_AGENT_POS_CODE,',')>
		AND WEP.POSITION_CODE IN
								(
							<cfloop from="1" to="#listlen(TMARKET.CONS_AGENT_POS_CODE,',')#" index="sayac3">
							#ListGetAt(TMARKET.CONS_AGENT_POS_CODE,sayac3,',')#
								<cfif sayac3 lt ListLen(TMARKET.CONS_AGENT_POS_CODE)>
								,
								</cfif>
							</cfloop>
		
								)
	</cfif>
	<cfif ListLen(TMARKET.CONSUMER_STAGE)>
		AND C.CONSUMER_STAGE IN(#TMARKET.CONSUMER_STAGE#)
	</cfif>
	<cfif ListLen(TMARKET.CONSUMER_BIRTHDATE)>
		AND C.BIRTHDATE = #createodbcdatetime(TMARKET.CONSUMER_BIRTHDATE)#
	</cfif>
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
	<cfif TMARKET.IS_CONS_CEPTEL eq 1>
		AND C.MOBILTEL IS NOT NULL
	</cfif>
	<cfif TMARKET.IS_CONS_EMAIL eq 1>
		AND C.CONSUMER_EMAIL IS NOT NULL
	</cfif>
	<cfif TMARKET.IS_CONS_TAX eq 1>
		AND C.TAX_NO IS NOT NULL
	</cfif>
	<cfif TMARKET.IS_CONS_DEBT eq 1>
		AND C.CONSUMER_ID IN(SELECT
								CONSUMER_ID
							FROM
								#dsn2_alias#.CARI_ROWS_CONSUMER
							WHERE
								DUE_DATE < GETDATE()
							GROUP BY
								CONSUMER_ID
							HAVING
								ROUND(SUM(BORC-ALACAK),5) >0)
	</cfif>
	<cfif TMARKET.IS_CONS_OPEN_ORDER eq 1>
		AND C.CONSUMER_ID IN(SELECT
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
								<cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_START_DATE)>
									O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								</cfif>
								<cfif len(TMARKET.LAST_DAY_COUNT)>
									<cfif TMARKET.LAST_DAY_TYPE eq 1>
										DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 2>
										DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
									<cfelseif TMARKET.LAST_DAY_TYPE eq 3>
										DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 4>
										DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									</cfif>
								</cfif>
								ORR.ORDER_ROW_CURRENCY = -1
							)
	</cfif>
	<cfif ListLen(TMARKET.TRAINING_ID)>
		AND C.CONSUMER_ID IN(SELECT
								CON_ID
							FROM
								#dsn_alias#.TRAINING_CLASS_ATTENDER
							WHERE
								<cfloop from="1" to="#listlen(TMARKET.TRAINING_ID,',')#" index="sayac4">
									CLASS_ID = #ListGetAt(TMARKET.TRAINING_ID,sayac4,',')#
									<cfif sayac4 lt ListLen(TMARKET.TRAINING_ID)>
										<cfif TMARKET.TRAINING_STATUS eq 2>
											OR
										<cfelse >
											AND
										</cfif>
									</cfif>
								</cfloop>		
							)
	</cfif>
	<cfif ListLen(TMARKET.PROMOTION_ID)>
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
								<cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_START_DATE)>
									O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								</cfif>
								<cfif len(TMARKET.LAST_DAY_COUNT)>
									<cfif TMARKET.LAST_DAY_TYPE eq 1>
										DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 2>
										DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
									<cfelseif TMARKET.LAST_DAY_TYPE eq 3>
										DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 4>
										DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									</cfif>
								</cfif>
								<cfloop from="1" to="#listlen(TMARKET.PROMOTION_ID,',')#" index="sayac5">
									ORR.PROM_ID = #ListGetAt(TMARKET.PROMOTION_ID,sayac5,',')#
									<cfif sayac5 lt ListLen(TMARKET.PROMOTION_ID)>
										<cfif TMARKET.PROMOTION_STATUS eq 2>
											OR
										<cfelse >
											AND
										</cfif>
									</cfif>
								</cfloop>
							)
	</cfif>
	<cfif ListLen(TMARKET.PROMOTION_COUNT)>
		AND C.CONSUMER_ID IN(								
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
								<cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_START_DATE)>
									O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								</cfif>
								<cfif len(TMARKET.LAST_DAY_COUNT)>
									<cfif TMARKET.LAST_DAY_TYPE eq 1>
										DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 2>
										DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
									<cfelseif TMARKET.LAST_DAY_TYPE eq 3>
										DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 4>
										DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
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
								<cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_START_DATE)>
									O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								</cfif>
								<cfif len(TMARKET.LAST_DAY_COUNT)>
									<cfif TMARKET.LAST_DAY_TYPE eq 1>
										DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 2>
										DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
									<cfelseif TMARKET.LAST_DAY_TYPE eq 3>
										DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 4>
										DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
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
								<cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_START_DATE)>
									O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								</cfif>
								<cfif len(TMARKET.LAST_DAY_COUNT)>
									<cfif TMARKET.LAST_DAY_TYPE eq 1>
										DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 2>
										DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
									<cfelseif TMARKET.LAST_DAY_TYPE eq 3>
										DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 4>
										DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									</cfif>
								</cfif>
								<cfloop from="1" to="#listlen(TMARKET.ORDER_PRODUCT_ID,',')#" index="sayac6">
									ORR.PRODUCT_ID = #ListGetAt(TMARKET.ORDER_PRODUCT_ID,sayac6,',')#
									<cfif sayac6 lt ListLen(TMARKET.ORDER_PRODUCT_ID)>
										<cfif TMARKET.ORDER_PRODUCT_STATUS eq 2>
											OR
										<cfelse >
											AND
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
								<cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_START_DATE)>
									O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								</cfif>
								<cfif len(TMARKET.LAST_DAY_COUNT)>
									<cfif TMARKET.LAST_DAY_TYPE eq 1>
										DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 2>
										DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
									<cfelseif TMARKET.LAST_DAY_TYPE eq 3>
										DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 4>
										DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									</cfif>
								</cfif>
								<cfloop from="1" to="#listlen(TMARKET.ORDER_PRODUCTCAT_ID,',')#" index="sayac7">
									P.PRODUCT_CATID = #ListGetAt(TMARKET.ORDER_PRODUCTCAT_ID,sayac7,',')#
									<cfif sayac7 lt ListLen(TMARKET.ORDER_PRODUCTCAT_ID)>
										<cfif TMARKET.ORDER_PRODUCTCAT_STATUS eq 2>
											OR
										<cfelse >
											AND
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
								<cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_START_DATE)>
									O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								</cfif>
								<cfif len(TMARKET.LAST_DAY_COUNT)>
									<cfif TMARKET.LAST_DAY_TYPE eq 1>
										DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 2>
										DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
									<cfelseif TMARKET.LAST_DAY_TYPE eq 3>
										DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 4>
										DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
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
								<cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_START_DATE)>
									O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								</cfif>
								<cfif len(TMARKET.LAST_DAY_COUNT)>
									<cfif TMARKET.LAST_DAY_TYPE eq 1>
										DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 2>
										DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
									<cfelseif TMARKET.LAST_DAY_TYPE eq 3>
										DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 4>
										DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
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
								<cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_START_DATE)>
									O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								</cfif>
								<cfif len(TMARKET.LAST_DAY_COUNT)>
									<cfif TMARKET.LAST_DAY_TYPE eq 1>
										DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 2>
										DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
									<cfelseif TMARKET.LAST_DAY_TYPE eq 3>
										DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 4>
										DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
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
								<cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_START_DATE)>
									O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								</cfif>
								<cfif len(TMARKET.LAST_DAY_COUNT)>
									<cfif TMARKET.LAST_DAY_TYPE eq 1>
										DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 2>
										DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
									<cfelseif TMARKET.LAST_DAY_TYPE eq 3>
										DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 4>
										DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									</cfif>
								</cfif>
								O.CONSUMER_ID IS NOT NULL
							GROUP BY 
								CONSUMER_ID
							HAVING 
								<cfif TMARKET.ORDER_AMOUNT_TYPE eq 1>
									SUM(O.NETTOTAL) >= #TMARKET.ORDER_AMOUNT#
								<cfelseif TMARKET.ORDER_AMOUNT_TYPE eq 2>
									SUM(O.NETTOTAL) <= #TMARKET.ORDER_AMOUNT#
								<cfelseif TMARKET.ORDER_AMOUNT_TYPE eq 3>
									SUM(O.NETTOTAL) = #TMARKET.ORDER_AMOUNT#
								<cfelse>										
									SUM(O.NETTOTAL)/COUNT(ORDER_ID) = #TMARKET.ORDER_AMOUNT#
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
								<cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_START_DATE)>
									O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								</cfif>
								<cfif len(TMARKET.LAST_DAY_COUNT)>
									<cfif TMARKET.LAST_DAY_TYPE eq 1>
										DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 2>
										DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
									<cfelseif TMARKET.LAST_DAY_TYPE eq 3>
										DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 4>
										DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									</cfif>
								</cfif>
								O.CONSUMER_ID IS NOT NULL
							GROUP BY 
								CONSUMER_ID
							HAVING 
								<cfif TMARKET.ORDER_COUNT_TYPE eq 1>
									COUNT(ORDER_ID) >= #TMARKET.ORDER_COUNT#
								<cfelseif TMARKET.ORDER_COUNT_TYPE eq 2>
									COUNT(ORDER_ID) <= #TMARKET.ORDER_COUNT#
								<cfelseif TMARKET.ORDER_COUNT_TYPE eq 3>
									COUNT(ORDER_ID) = #TMARKET.ORDER_COUNT#
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
								<cfif isdate(TMARKET.ORDER_START_DATE) and isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE BETWEEN #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_START_DATE)>
									O.ORDER_DATE >= #createodbcdatetime(TMARKET.ORDER_START_DATE)# AND
								<cfelseif isdate(TMARKET.ORDER_FINISH_DATE)>
									O.ORDER_DATE <= #createodbcdatetime(TMARKET.ORDER_FINISH_DATE)# AND
								</cfif>
								<cfif len(TMARKET.LAST_DAY_COUNT)>
									<cfif TMARKET.LAST_DAY_TYPE eq 1>
										DATEDIFF(day,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 2>
										DATEDIFF(week,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND 
									<cfelseif TMARKET.LAST_DAY_TYPE eq 3>
										DATEDIFF(month,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									<cfelseif TMARKET.LAST_DAY_TYPE eq 4>
										DATEDIFF(year,O.ORDER_DATE,GETDATE()) < = #TMARKET.LAST_DAY_COUNT# AND
									</cfif>
								</cfif>
								O.CONSUMER_ID IS NOT NULL
							GROUP BY 
								CONSUMER_ID
							HAVING 
								<cfif TMARKET.PRODUCT_COUNT_TYPE eq 1>
									COUNT(PRODUCT_ID) >= #TMARKET.PRODUCT_COUNT#
								<cfelseif TMARKET.PRODUCT_COUNT_TYPE eq 2>
									COUNT(PRODUCT_ID) <= #TMARKET.PRODUCT_COUNT#
								<cfelseif TMARKET.PRODUCT_COUNT_TYPE eq 3>
									COUNT(PRODUCT_ID) = #TMARKET.PRODUCT_COUNT#
								<cfelse>										
									COUNT(ORR.PRODUCT_ID)/COUNT(O.ORDER_ID) = #TMARKET.PRODUCT_COUNT#
								</cfif>
						)
	</cfif>
	<cfif ListLen(TMARKET.IS_CONS_BLACK_LIST) and TMARKET.IS_CONS_BLACK_LIST eq 1>
		AND C.CONSUMER_ID IN(SELECT CONSUMER_ID FROM COMPANY_CREDIT WHERE CONSUMER_ID IS NOT NULL AND OUR_COMPANY_ID = #session.ep.company_id# AND IS_BLACKLIST = 1)
   </cfif>
	<cfif not isDefined("attributes.count")>
ORDER BY 
	C.CONSUMER_NAME,
	C.CONSUMER_SURNAME
	</cfif>
</cfquery>
