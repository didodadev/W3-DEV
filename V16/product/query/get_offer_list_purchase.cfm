<cfquery name="GET_OFFER_LIST" datasource="#DSN#">
		<cfif (isDefined('attributes.offer_zone') and ((attributes.offer_zone eq '1') or (attributes.offer_zone eq '-'))) or (not isdefined('attributes.offer_zone'))>
			(
			SELECT 
				<cfif isdefined("attributes.product_id")>
				DISTINCT
				</cfif>			
				'P' AS USER_TYPE,
				O.OFFER_ID AS OFFER_ID,
				O.OFFER_HEAD,
				O.OFFER_DATE,
				O.OFFER_NUMBER,
				O.PRICE PRICE,
				O.OTHER_MONEY OTHER_MONEY,
				O.VALIDDATE,
				O.VALIDATOR_POSITION_CODE,
				O.VALID_EMP,
				O.OFFER_CURRENCY,
				O.OFFER_ZONE,
				O.PURCHASE_SALES,
				O.OFFER_TO,
				O.RECORD_MEMBER,
				CP.COMPANY_PARTNER_NAME NAME,
				CP.COMPANY_PARTNER_SURNAME SURNAME,
				C.NICKNAME NICKNAME ,
				C.COMPANY_ID COMPANY_ID
			FROM 
				#dsn3_alias#.OFFER O, 
				COMPANY_PARTNER CP,
				COMPANY C
				<cfif isdefined("attributes.product_id")>
				,#dsn3_alias#.OFFER_ROW OFR
				</cfif>		
			WHERE 
				O.RECORD_MEMBER = CP.PARTNER_ID AND 
				CP.COMPANY_ID = C.COMPANY_ID AND
				O.OFFER_ZONE = 1 AND 
				O.PURCHASE_SALES = 1
				<cfif isdefined("attributes.company_id") and isdefined("attributes.ismyhome")>
				AND OFFER_TO LIKE '%,#attributes.company_id#,%'
				</cfif>
				<cfif isDefined("attributes.currency_id") and len(attributes.currency_id)>
				AND O.OFFER_CURRENCY = #attributes.CURRENCY_ID#
				</cfif>
				<cfif isDefined("attributes.offer_status") and len(attributes.offer_status)>
				AND  O.OFFER_STATUS = #attributes.OFFER_STATUS#
				</cfif>
				<cfif isdefined("attributes.for_offer_id") and len(attributes.for_offer_id)>
				AND O.FOR_OFFER_ID = #ATTRIBUTES.FOR_OFFER_ID#
				</cfif>
				<cfif isdefined("attributes.product_id")>
					AND OFR.OFFER_ID = O.OFFER_ID
					AND OFR.PRODUCT_ID = #attributes.product_id#
				</cfif>		
				<cfif isDefined("attributes.keyword") and len(trim(attributes.keyword))>
				AND 
					(
						O.OFFER_HEAD LIKE '%#attributes.KEYWORD#%'  OR 
						O.OFFER_DETAIL LIKE '%#attributes.KEYWORD#%' OR
						O.OFFER_NUMBER LIKE '%#attributes.KEYWORD#%' OR
						C.FULLNAME LIKE '%#attributes.KEYWORD#%' OR
						C.NICKNAME LIKE '%#attributes.KEYWORD#%' OR
						CP.COMPANY_PARTNER_NAME LIKE '%#attributes.KEYWORD#%' OR
						CP.COMPANY_PARTNER_SURNAME LIKE '%#attributes.KEYWORD#%'
					)
				</cfif>
			)
		</cfif>
		<cfif (isdefined("attributes.offer_zone") and (attributes.offer_zone eq "-")) or (not isdefined("attributes.offer_zone"))>
	UNION
		</cfif>
		<cfif (isDefined("attributes.offer_zone") and ((attributes.offer_zone eq "0") or (attributes.offer_zone eq "-"))) or (not isdefined("attributes.offer_zone"))>
			(
			SELECT 
				<cfif isdefined("attributes.product_id")>
				DISTINCT
				</cfif>			
				'E' AS USER_TYPE,
				O.OFFER_ID AS OFFER_ID,
				O.OFFER_HEAD,
				O.OFFER_DATE,
				O.OFFER_NUMBER,
				O.PRICE PRICE,
				O.OTHER_MONEY OTHER_MONEY,
				O.VALIDDATE,
				O.VALIDATOR_POSITION_CODE,
				O.VALID_EMP,
				O.OFFER_CURRENCY,
				O.OFFER_ZONE,
				O.PURCHASE_SALES,
				O.OFFER_TO,
				O.RECORD_MEMBER,
				E.EMPLOYEE_NAME NAME,
				E.EMPLOYEE_SURNAME SURNAME,
				E.EMPLOYEE_EMAIL NICKNAME,
				EP.TITLE_ID COMPANY_ID
			FROM 
				#dsn3_alias#.OFFER O, 
				EMPLOYEES E,
				EMPLOYEE_POSITIONS EP
				<cfif isdefined("attributes.product_id")>
				,#dsn3_alias#.OFFER_ROW OFR
				</cfif>			
			WHERE 
				O.OFFER_ZONE = 0 AND 
				O.PURCHASE_SALES = 0 AND
				O.RECORD_MEMBER = E.EMPLOYEE_ID AND
				EP.EMPLOYEE_ID = E.EMPLOYEE_ID
				<cfif isdefined("attributes.company_id") and isdefined("attributes.ismyhome")>
				AND OFFER_TO LIKE '%,#attributes.company_id#,%'
				</cfif>
				<cfif isDefined("attributes.currency_id") and len(attributes.currency_id)>
				AND O.OFFER_CURRENCY = #attributes.CURRENCY_ID#
				</cfif>
				<cfif isDefined("attributes.offer_status") and len(attributes.offer_status)>
				AND O.OFFER_STATUS = #attributes.OFFER_STATUS#
				</cfif>
				<cfif isdefined("attributes.for_offer_id") and len(attributes.for_offer_id)>
				AND O.FOR_OFFER_ID = #ATTRIBUTES.FOR_OFFER_ID#
				</cfif>
				<cfif isdefined("attributes.product_id")>
					AND OFR.OFFER_ID = O.OFFER_ID
					AND OFR.PRODUCT_ID = #attributes.product_id#
				</cfif>			
				<cfif isDefined("attributes.keyword") and len(trim(attributes.keyword))>
				AND 
					(
						O.OFFER_HEAD LIKE '%#attributes.KEYWORD#%' OR 
						O.OFFER_DETAIL LIKE '%#attributes.KEYWORD#%' OR
						O.OFFER_NUMBER LIKE '%#attributes.KEYWORD#%' OR
						E.EMPLOYEE_NAME LIKE '%#attributes.KEYWORD#%' OR
						E.EMPLOYEE_SURNAME LIKE '%#attributes.KEYWORD#%'
					)
			</cfif>
			)
		</cfif>
		ORDER BY OFFER_ID DESC
</cfquery>
