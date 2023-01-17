<cfquery name="GET_TMARKET_PARTNERS_COUNT" datasource="#dsn#">
	SELECT 
		COUNT(COMPANY_PARTNER.PARTNER_ID) AS TOTAL
	FROM
		COMPANY,
		COMPANY_PARTNER
	WHERE
		COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID
		<cfif len(TMARKET.SECTOR_CATS)>
			AND
			COMPANY.SECTOR_CAT_ID IN (#TMARKET.SECTOR_CATS#)
		</cfif>
		<cfif len(TMARKET.COMPANY_SIZE_CATS)>
			AND
			COMPANY.COMPANY_SIZE_CAT_ID IN (#TMARKET.COMPANY_SIZE_CATS#)
		</cfif>
		<cfif LISTLEN(TMARKET.PARTNER_STATUS)>
			AND
			COMPANY.COMPANY_STATUS IN (#TMARKET.PARTNER_STATUS#)
		</cfif>
		<cfif LISTLEN(TMARKET.IS_POTANTIAL)>
			AND
			COMPANY.ISPOTANTIAL IN (#TMARKET.IS_POTANTIAL#)
		</cfif>
		<cfif LISTLEN(TMARKET.COMPANYCATS)>
			AND
			COMPANY.COMPANYCAT_ID IN (#TMARKET.COMPANYCATS#)
		</cfif>
		<cfif len(TMARKET.COMPANY_LOCATION)>
		<cfset COUNTER = 0>
			AND
			(
			<cfloop list="#TMARKET.COMPANY_LOCATION#" delimiters=" " index="I"><cfset COUNTER = COUNTER+1>
			COMPANY.COMPANY_ADDRESS LIKE '%#I#%'
			OR
			COMPANY.COUNTY LIKE '%#I#%'
			OR
			COMPANY.CITY LIKE '%#I#%'
			OR
			COMPANY.COUNTRY LIKE '%#I#%'
			<cfif LISTLEN(TMARKET.COMPANY_LOCATION," ") neq COUNTER>
				OR
			</cfif>
			</cfloop>
			)
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(
			COMPANY_PARTNER.COMPANY_PARTNER_ADDRESS LIKE '%#attributes.keyword#%'
			OR
			COMPANY_PARTNER.COMPANY_PARTNER_NAME LIKE '%#attributes.keyword#%'
			OR
			COMPANY_PARTNER.COMPANY_PARTNER_SURNAME LIKE '%#attributes.keyword#%'
			)
		</cfif>
		<cfif LEN(ListSort(TMARKET.TARGET_ALTS,'numeric'))>
			AND
			<cfloop list="#ListSort(TMARKET.TARGET_ALTS,'numeric')#" index="alt">
				COMPANY_PARTNER.PARTNER_ID IN 
					(
						SELECT 
							PAR_ID 
						FROM 
							SURVEY_VOTES 
						WHERE 
							VOTES LIKE '%,#alt#,%'
					)
			<cfif alt neq ListLast(ListSort(TMARKET.TARGET_ALTS,'numeric'))>AND</cfif>
			</cfloop>
		</cfif>
		<cfif LISTLEN(TMARKET.PARTNER_TMARKET_SEX)>
			AND
			COMPANY_PARTNER.SEX IN (#LISTSORT(TMARKET.PARTNER_TMARKET_SEX,"NUMERIC")#) 
		</cfif>
		<cfif LISTLEN(TMARKET.PARTNER_MISSION)>
			AND
			COMPANY_PARTNER.MISSION IN (#LISTSORT(TMARKET.PARTNER_MISSION,"NUMERIC")#) 
		</cfif>
		<cfif LISTLEN(TMARKET.PARTNER_DEPARTMENT)>
			AND
			COMPANY_PARTNER.DEPARTMENT IN (#LISTSORT(TMARKET.PARTNER_DEPARTMENT,"NUMERIC")#) 
		</cfif>
		<cfif len(tmarket.is_seller)>
		AND COMPANY.IS_SELLER = #tmarket.is_seller#
		</cfif>
		<cfif len(tmarket.is_buyer)>
		AND COMPANY.IS_SELLER = #tmarket.is_buyer#
		</cfif>
		<cfif listlen(tmarket.is_potantial)>
		AND COMPANY.ISPOTANTIAL IN (#tmarket.is_potantial#)
		</cfif>
		<cfif listlen(tmarket.partner_status)>
		AND COMPANY.COMPANY_STATUS IN (#tmarket.partner_status#)
		</cfif>
		<cfif listlen(tmarket.tmarket_sex)>
		AND COMPANY_PARTNER.SEX IN (#tmarket.tmarket_sex#)
		</cfif>
		<cfif listlen(tmarket.tmarket_sex)>
		AND COMPANY_PARTNER.IS_MARRIED IN (#tmarket.tmarket_sex#)
		</cfif>
		<cfif len(tmarket.companycats)>
		AND COMPANY.COMPANYCAT_ID IN (#tmarket.companycats#)
		</cfif>
		<cfif len(tmarket.ims_code_id)>
		AND COMPANY.IMS_CODE_ID = #tmarket.ims_code_id#
		</cfif>
		<cfif len(tmarket.gsm_code)>
		AND COMPANY_PARTNER.MOBIL_CODE = #tmarket.gsm_code#
		</cfif>
		<cfif len(tmarket.faculty)>
		AND COMPANY_PARTNER.FACULTY = #tmarket.faculty#
		</cfif>
		<cfif len(tmarket.county_id)>
		AND COMPANY.COUNTY = #tmarket.county_id#
		</cfif>
		<cfif len(tmarket.graduate_year)>
		AND COMPANY_PARTNER.GRADUATE_YEAR = '#tmarket.graduate_year#'
		</cfif>
		<cfif len(tmarket.city)>
		AND COMPANY.CITY = #tmarket.city#
		</cfif>
		<cfif len(tmarket.birthdate_start)>
		AND COMPANY_PARTNER.BIRTHDATE >= '#tmarket.birthdate_start#'
		</cfif>
		<cfif len(tmarket.birthdate_finish)>
		AND COMPANY_PARTNER.BIRTHDATE <= '#tmarket.birthdate_finish#'
		</cfif>
		<cfif len(tmarket.open_date)>
		AND COMPANY.CON_OPEN_DATE <= '#tmarket.open_date#'
		</cfif>
		<cfif len(tmarket.close_date)>
		AND COMPANY.CON_CLOSE_DATE <= '#tmarket.close_date#'
		</cfif>
		<cfif len(tmarket.fullname)>
		AND COMPANY.FULLNAME LIKE '%#tmarket.fullname#%'
		</cfif>
		<cfif len(tmarket.company_partner_name)>
		AND COMPANY_PARTNER.COMPANY_PARTNER_NAME LIKE '%#tmarket.company_partner_name#%'
		</cfif>
		<cfif len(tmarket.company_partner_surname)>
		AND COMPANY_PARTNER.COMPANY_PARTNER_SURNAME LIKE '%#tmarket.company_partner_surname#%'
		</cfif>
		<cfif len(tmarket.post_code)>
		AND COMPANY.COMPANY_POSTCODE LIKE '%#tmarket.post_code#'
		</cfif>
		<cfif len(tmarket.semt)>
		AND COMPANY.SEMT LIKE '%#tmarket.semt#'
		</cfif>
		<cfif len(tmarket.tel_code)>
		AND COMPANY.TEL_CODE LIKE '%#tmarket.tel_code#%'
		</cfif>
		<cfif len(tmarket.district)>
		AND COMPANY.DISTRICT LIKE '%#tmarket.district#%'
		</cfif>
		<cfif len(tmarket.birthplace)>
		AND COMPANY_PARTNER.BIRTHPLACE LIKE '%#tmarket.birthplace#%'
		</cfif>
		<cfif len(tmarket.hobby)>
		AND COMPANY_PARTNER.PARTNER_ID IN ( SELECT PARTNER_ID FROM COMPANY_PARTNER_HOBBY WHERE HOBBY_ID IN (#tmarket.hobby#) )
		</cfif>
		<cfif len(tmarket.society_id)>
		AND COMPANY_PARTNER.PARTNER_ID IN ( SELECT PARTNER_ID FROM COMPANY_PARTNER_SOCIETY WHERE SOCIETY_ID IN (#tmarket.society_id#) )
		</cfif>
		<cfif len(tmarket.customer_position)>
		AND COMPANY.COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_POSITION WHERE POSITION_ID IN (#tmarket.customer_position#) )
		</cfif>
		<cfif len(tmarket.insurance_company)>
		AND COMPANY.COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_PARTNER_INSURANCE_COMP WHERE INSURANCE_COMP_ID IN (#tmarket.insurance_company#) )
		</cfif>
		<cfif len(tmarket.other_works)>
		AND COMPANY.COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_PARTNER_JOB_OTHER WHERE JOB_ID IN (#tmarket.other_works#) )
		</cfif>
		<cfif len(tmarket.COMPTETITOR_DEPOT)>
		AND COMPANY.COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_PARTNER_RIVAL WHERE RIVAL_ID IN (#tmarket.COMPTETITOR_DEPOT#) )
		</cfif>
		<cfif len(tmarket.softwares)>
		AND COMPANY.COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_OFFICE_SOFTWARES WHERE SOFTWARE_ID IN (#tmarket.softwares#) )
		</cfif>
		<cfif len(tmarket.COMPANY_DEPOTS)>
		AND COMPANY.COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE BRANCH_ID IN (#tmarket.COMPANY_DEPOTS#) )
		</cfif>
		<cfif len(tmarket.cons_sales_total_start)>
		AND COMPANY.COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_CREDIT WHERE TOTAL_RISK_LIMIT >= #tmarket.cons_sales_total_start# )
		</cfif>
		<cfif len(tmarket.cons_sales_total_end)>
		AND COMPANY.COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_CREDIT WHERE TOTAL_RISK_LIMIT <= #tmarket.cons_sales_total_end# )
		</cfif>
</cfquery>
