<cfquery name="get_offer_list" datasource="#dsn3#">
	SELECT
		<cfif len(attributes.listing_type) and attributes.listing_type eq 2>
			ORW.OFFER_ROW_ID,
			ORW.STOCK_ID,
			ORW.WRK_ROW_ID,
			ORW.PRODUCT_ID,
			ORW.PRODUCT_NAME,
			ORW.QUANTITY,
			ORW.UNIT,
		</cfif>
		O.OFFER_ID,
		O.FOR_OFFER_ID,
		O.OFFER_DATE,
		O.OFFER_FINISHDATE,
		O.DELIVERDATE,
		O.OFFER_HEAD,
		O.OFFER_NUMBER,
		O.OFFER_CURRENCY,
		O.OFFER_STAGE,
		O.IS_PARTNER_ZONE,
		O.IS_PUBLIC_ZONE,
		O.OFFER_STATUS,
		O.SALES_EMP_ID,
		O.OFFER_TO,
		O.OFFER_TO_CONSUMER,
		O.SHIP_METHOD,
		O.PAYMETHOD,
		O.OTHER_MONEY,
		O.OTHER_MONEY_VALUE,
		O.REF_NO,
		O.RECORD_MEMBER,
		O.RECORD_DATE
	FROM
		<cfif len(attributes.listing_type) and attributes.listing_type eq 2>
			OFFER_ROW ORW,
		</cfif>
		OFFER O
	WHERE
		<cfif len(attributes.listing_type) and attributes.listing_type eq 2>
			O.OFFER_ID = ORW.OFFER_ID AND
			<cfif len(attributes.product_id) and len(attributes.product_name)>
				 ORW.PRODUCT_ID =#attributes.product_id# AND
			</cfif>		
		</cfif>
		<cfif len(attributes.listing_type) and attributes.listing_type eq 1>
			<cfif len(attributes.product_id) and len(attributes.product_name)>
				 O.OFFER_ID IN(SELECT OFFER_ID FROM OFFER_ROW WHERE PRODUCT_ID= #attributes.product_id#)AND
			</cfif>
		</cfif>		
		<cfif len(attributes.keyword)>
			<cfif len(attributes.listing_type) and attributes.listing_type eq 1>
				(O.OFFER_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR O.OFFER_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR O.REF_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">) AND
			<cfelse>
				ORW.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> AND
			</cfif>
		</cfif>
		<cfif len(attributes.offer_number)>
			O.OFFER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.offer_number#%"> AND
		</cfif>
		<cfif len(attributes.currency_id)>
			O.OFFER_CURRENCY = #attributes.currency_id# AND
		</cfif>
		<cfif len(attributes.offer_stage)>
			O.OFFER_STAGE = #attributes.offer_stage# AND
		</cfif>
		<cfif len(attributes.public_partner) and attributes.public_partner eq 1>
			O.IS_PARTNER_ZONE = 1 AND O.IS_PUBLIC_ZONE = 0 AND
		<cfelseif len(attributes.public_partner) and attributes.public_partner eq 2>
			O.IS_PARTNER_ZONE = 0 AND O.IS_PUBLIC_ZONE = 1 AND
		<cfelseif len(attributes.public_partner) and attributes.public_partner eq 3>
			O.IS_PARTNER_ZONE = 1 AND O.IS_PUBLIC_ZONE = 1 AND
		</cfif>
		<cfif len(attributes.offer_status)>
			O.OFFER_STATUS = #attributes.offer_status# AND
		</cfif>
		<cfif len(attributes.employee_id) and len(attributes.employee)>
			(O.SALES_EMP_ID = #attributes.employee_id# OR O.RECORD_MEMBER = #attributes.employee_id#) AND
		</cfif>
		<cfif len(attributes.company_id) and len(attributes.company)>
			O.OFFER_TO LIKE '%,#attributes.company_id#,%' AND
		<cfelseif len(attributes.consumer_id) and len(attributes.company)>
			O.OFFER_TO_CONSUMER LIKE '%,#attributes.consumer_id#,%' AND
		</cfif>
		<cfif len(attributes.public_start_date)>
			O.STARTDATE >= #attributes.public_start_date# AND
		</cfif>
		<cfif len(attributes.public_finish_date)>
			O.FINISHDATE <= #attributes.public_finish_date# AND
		</cfif>
		<cfif len(attributes.start_date) and len(attributes.finish_date)>
			O.OFFER_DATE >= #attributes.start_date# AND
			O.OFFER_DATE <= #attributes.finish_date# AND
		</cfif>
		((O.OFFER_ZONE = 1 AND O.PURCHASE_SALES = 1) OR (O.OFFER_ZONE = 0 AND O.PURCHASE_SALES = 0))
		<cfif isdefined("attributes.project_id") and len (attributes.project_id) and isdefined("attributes.project_head") and len (attributes.project_head)>
			AND O.PROJECT_ID = #attributes.project_id#
		</cfif>
	ORDER BY
		O.OFFER_ID DESC,
		O.FOR_OFFER_ID DESC
</cfquery>
