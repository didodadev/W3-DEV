<cfquery name="GET_PAR_COUNT" datasource="#dsn#">
	SELECT 
		COMPANY.FULLNAME,
		COMPANY.IMS_CODE_ID,
		COMPANY.COMPANY_POSTCODE,
		COMPANY.SEMT,
		COMPANY.COMPANY_ADDRESS,
		COMPANY.COUNTY,
		COMPANY.CITY,
		COMPANY.COUNTRY,
		COMPANY_PARTNER.COMPANY_ID,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY_PARTNER.PARTNER_ID
	FROM
		COMPANY,
		COMPANY_PARTNER,
		COMPANY_PARTNER_DETAIL
	WHERE
		COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
		COMPANY_PARTNER_DETAIL.PARTNER_ID = COMPANY_PARTNER.PARTNER_ID
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
		AND COMPANY_PARTNER_DETAIL.MARRIED IN (#tmarket.tmarket_sex#)
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
		<cfif len(tmarket.city_id)>
		AND COMPANY.CITY = #tmarket.city_id#
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
