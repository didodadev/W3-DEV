<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getSearchResult">
        <cfargument name="keyword" default="">
			<cfset dsn_1 = '#dsn#_product'>
			<cfset dsn_2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
			<cfset dsn_3 = '#dsn#_#session.ep.company_id#'>
			<cfset period_id_list = 0>
			<cfquery name="GET_PERIOD" datasource="#DSN#">
				SELECT
					EPP.PERIOD_ID
				FROM
					EMPLOYEE_POSITION_PERIODS EPP,
					EMPLOYEE_POSITIONS EP
				WHERE 
					EPP.POSITION_ID = EP.POSITION_ID AND
					EP.POSITION_CODE = #session.ep.position_code#
			</cfquery>
			<cfif get_period.recordcount>
				<cfset period_id_list = ValueList(get_period.period_id,',')>
			</cfif>
			<cfquery name="generalSearchResult" datasource="#dsn#">
				SELECT
					1 RESULT_TYPE,
					CONTENT_ID AS RESULT_ID,
					CONT_HEAD AS RESULT_NAME,
					'' AS I_CAT,
					'' PURCHASE_SALES
				FROM
					CONTENT
				WHERE
					CONTENT_STATUS = 1 AND
					(
					<!---BK 20131012 6 aya kaldirilsin CONT_HEAD LIKE '%#keyword#%' OR
					CONT_SUMMARY LIKE'%#keyword#%' OR
					CONT_BODY LIKE'%#keyword#%' --->
					CONTAINS(*,'"#keyword#"')
					)
				<cfif get_module_user(27)>
					UNION
					SELECT
						2 RESULT_TYPE,
						C.COMPANY_ID AS RESULT_ID,
						C.NICKNAME +' - '+ CP.COMPANY_PARTNER_NAME +' '+ CP.COMPANY_PARTNER_SURNAME AS RESULT_NAME,
						'' AS I_CAT,
						'' PURCHASE_SALES
					FROM
						COMPANY_PARTNER CP,
						COMPANY C
					WHERE
						C.COMPANY_ID = CP.COMPANY_ID AND
						CP.COMPANY_PARTNER_STATUS = 1 AND
						C.COMPANYCAT_ID IN (
											SELECT DISTINCT	
												COMPANYCAT_ID
											FROM
												GET_MY_COMPANYCAT
											WHERE
												EMPLOYEE_ID = #session.ep.userid# AND
												OUR_COMPANY_ID = #session.ep.company_id#		
						) AND
						C.COMPANY_ID IN (
										SELECT 
											CPE.COMPANY_ID
										FROM
											COMPANY_PERIOD CPE
										WHERE
											C.COMPANY_ID = CPE.COMPANY_ID AND
											CPE.PERIOD_ID IN (#period_id_list#)
						) AND
						(
						CP.COMPANY_PARTNER_NAME +' '+ CP.COMPANY_PARTNER_SURNAME LIKE '%#keyword#%' OR
						C.FULLNAME LIKE '%#keyword#%' OR
						C.NICKNAME LIKE '%#keyword#%'
						)
					UNION
					SELECT
						3 RESULT_TYPE,
						CONSUMER_ID AS RESULT_ID,
						CONSUMER_NAME +' '+ CONSUMER_SURNAME AS RESULT_NAME,
						'' AS I_CAT,
						'' PURCHASE_SALES
					FROM
						CONSUMER
					WHERE
						CONSUMER_STATUS = 1 AND
						PERIOD_ID IN (#period_id_list#) AND
						CONSUMER_NAME +' '+ CONSUMER_SURNAME LIKE '%#keyword#%'
				</cfif>
				<cfif get_module_user(5)>
					UNION
					SELECT
						4 RESULT_TYPE,
						PRODUCT_ID AS RESULT_ID,
						PRODUCT_NAME AS RESULT_NAME,
						'' AS I_CAT,
						'' PURCHASE_SALES
					FROM
						#dsn_1#.PRODUCT
					WHERE
						PRODUCT_STATUS = 1 AND
						PRODUCT_NAME LIKE '%#keyword#%'
				</cfif>
				<cfif get_module_user(11)>
					<!--- siparis blogu
					UNION
					SELECT
						5 RESULT_TYPE,
						ORDER_ID AS RESULT_ID,
						ORDER_NUMBER AS RESULT_NAME,
						'' AS I_CAT,
						PURCHASE_SALES
					FROM
						#dsn_3#.ORDERS
					WHERE
						ORDER_STATUS = 1 AND
						PURCHASE_SALES = 1 AND
						ORDER_NUMBER LIKE '%#keyword#%'
					--->
					UNION
					SELECT
						9 RESULT_TYPE,
						OPP_ID AS RESULT_ID,
						OPP_HEAD AS RESULT_NAME,
						'' AS I_CAT,
						'' AS PURCHASE_SALES
					FROM
						#dsn_3#.OPPORTUNITIES
					WHERE
						OPP_STATUS = 1 AND
						(
						OPP_NO LIKE '%#keyword#%' OR
						OPP_HEAD LIKE '%#keyword#%'
						)
					UNION
					SELECT
						10 RESULT_TYPE,
						OFFER_ID AS RESULT_ID,
						OFFER_HEAD AS RESULT_NAME,
						'' AS I_CAT,
						'' AS PURCHASE_SALES
					FROM
						#dsn_3#.OFFER
					WHERE
						OFFER_STATUS = 1 AND
						((PURCHASE_SALES = 1 AND OFFER_ZONE = 0) OR (PURCHASE_SALES = 0 AND OFFER_ZONE = 1)) AND
						(
						OFFER_NUMBER LIKE '%#keyword#%' OR
						OFFER_HEAD LIKE '%#keyword#%'
						)
				</cfif>
				<cfif get_module_user(12)>
					<!--- satinalma siparisleri
					UNION
					SELECT
						6 RESULT_TYPE,
						ORDER_ID AS RESULT_ID,
						ORDER_NUMBER AS RESULT_NAME,
						'' AS I_CAT,
						PURCHASE_SALES
					FROM
						#dsn_3#.ORDERS
					WHERE
						ORDER_STATUS = 1 AND
						PURCHASE_SALES = 0 AND
						ORDER_ZONE = 0 AND
						ORDER_NUMBER LIKE '%#keyword#%'
					--->
					UNION
					SELECT
						11 RESULT_TYPE,
						OFFER_ID AS RESULT_ID,
						OFFER_HEAD AS RESULT_NAME,
						'' AS I_CAT,
						'' AS PURCHASE_SALES
					FROM
						#dsn_3#.OFFER
					WHERE
						OFFER_STATUS = 1 AND
						((OFFER_ZONE = 1 AND PURCHASE_SALES = 1) OR (OFFER_ZONE = 0 AND PURCHASE_SALES = 0)) AND
						(
						OFFER_NUMBER LIKE '%#keyword#%' OR
						OFFER_HEAD LIKE '%#keyword#%'
						)
				</cfif>
				<!--- fatura blogu
				<cfif listgetat(session.ep.user_level, 20)>
					UNION
					SELECT
						7 RESULT_TYPE,
						INVOICE_ID AS RESULT_ID,
						INVOICE_NUMBER AS RESULT_NAME,
						INVOICE_CAT AS I_CAT,
						PURCHASE_SALES 
					FROM
						#dsn_2#.INVOICE
					WHERE
						INVOICE_NUMBER LIKE '%#keyword#%' OR
						INVOICE_ID LIKE '%#keyword#%'
				</cfif>
				--->
				<cfif get_module_user(3)>
					UNION
					SELECT
						8 RESULT_TYPE,
						EMPLOYEE_ID AS RESULT_ID,
						EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME AS RESULT_NAME,
						'' AS I_CAT,
						'' AS PURCHASE_SALES 
					FROM
						EMPLOYEES
					WHERE
						EMPLOYEE_STATUS = 1 AND
						EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME LIKE '%#keyword#%'
				</cfif>
			</cfquery>
          <cfreturn generalSearchResult>
    </cffunction>
</cfcomponent>
