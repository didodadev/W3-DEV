<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfquery name="control_filter_par_id" datasource="#dsn#">
		SELECT
			PARTNER_ID
		FROM
			COMPANY_PARTNER 
		WHERE 
			COMPANY_PARTNER_NAME LIKE '%#ATTRIBUTES.keyword#%' OR
			COMPANY_PARTNER_SURNAME LIKE '%#ATTRIBUTES.keyword#%'
	</cfquery>
	<cfquery name="control_filter_comp_id" datasource="#dsn#">
		SELECT
			COMPANY_ID
		FROM
			COMPANY
		WHERE 
			NICKNAME LIKE '%#ATTRIBUTES.keyword#%'  
	</cfquery>
</cfif>
<cfquery name="GET_OFFER_LIST" datasource="#DSN3#">
	SELECT 
		<cfif isdefined("attributes.product_id")>
		DISTINCT
		</cfif>	
		OFFER.OFFER_ID,
		OFFER.CONSUMER_ID,
		OFFER.PARTNER_ID,
		OFFER.COMPANY_ID,		
		OFFER.OFFER_TO,
		OFFER.OFFER_TO_PARTNER,
		<!---M ER 90 Güne Siline 20061110 OFFER.SALES_POSITION_CODE, --->
		OFFER.SALES_EMP_ID,
		OFFER.SALES_PARTNER_ID,
		OFFER.OFFER_NUMBER,
		OFFER.OFFER_DATE,
		OFFER.OFFER_HEAD,
		OFFER.PRICE,
		OFFER.OTHER_MONEY,
		OFFER.OFFER_STATUS,
		OFFER.COMMETHOD_ID,
		OFFER.RECORD_MEMBER,
		OFFER.OFFER_CURRENCY,
		OFFER.OFFER_ZONE
	FROM 
		OFFER
		<cfif isdefined("attributes.product_id")>
		,OFFER_ROW OFR
		</cfif>		
		<cfif isdefined("filter_cat") and len(filter_cat)>
			<cfif (filter_cat eq 2) or (filter_cat eq 4)>
			,#dsn_alias#.COMPANY_PARTNER AS COMPANY_PARTNER
			,#dsn_alias#.COMPANY AS COMPANY
			<cfelseif (filter_cat eq 1) or (filter_cat eq 3)>
			,#dsn_alias#.CONSUMER AS CONSUMER
			</cfif>
		</cfif>
	WHERE 
	<cfif isdefined("form.offer_zone")>
		<cfif not len(form.offer_zone)>
		(
			(
		OFFER.PURCHASE_SALES = 1 AND
		OFFER.OFFER_ZONE = 0
			)
		OR
			(
		OFFER.PURCHASE_SALES = 0 AND
		OFFER.OFFER_ZONE = 1
			)
		)
		<cfelseif not form.offer_zone>
		(
		OFFER.PURCHASE_SALES = 1 AND
		OFFER.OFFER_ZONE = 0
		)
		<cfelseif form.offer_zone>
		(
		OFFER.PURCHASE_SALES = 0 AND
		OFFER.OFFER_ZONE = 1
		)
		</cfif>
	<cfelse>
		(
			(
		OFFER.PURCHASE_SALES = 1 AND
		OFFER.OFFER_ZONE = 0
			)
		OR
			(
		OFFER.PURCHASE_SALES = 0 AND
		OFFER.OFFER_ZONE = 1
			)
		)
	</cfif>
	<cfif isdefined("attributes.product_id")>
		AND OFR.OFFER_ID = OFFER.OFFER_ID
		AND OFR.PRODUCT_ID = #attributes.product_id#
	</cfif>
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
			OFFER.OFFER_HEAD LIKE '%#attributes.keyword#%' OR
			OFFER.OFFER_NUMBER LIKE '%#attributes.keyword#%'
	<cfif control_filter_par_id.recordcount>
	   		OR OFFER.PARTNER_ID = #control_filter_par_id.PARTNER_ID#
	</cfif>
	<cfif control_filter_comp_id.recordcount>
	   		OR OFFER.COMPANY_ID = #control_filter_comp_id.COMPANY_ID#
	</cfif>
		)
	<cfelse>
		AND OFFER_STATUS =1
	</cfif>
	<cfif isdefined("offer_status_cat_id") and len(offer_status_cat_id)>
		AND OFFER.OFFER_CURRENCY = #offer_status_cat_id#
	</cfif>
	<cfif isdefined("filter_cat") and len(filter_cat)>
		<cfif filter_cat eq 1>
		AND CONSUMER.ISPOTANTIAL = 0
		AND OFFER.CONSUMER_ID=CONSUMER.CONSUMER_ID
		<cfif len(attributes.keyword)>
		AND
		( CONSUMER.CONSUMER_NAME LIKE '%#attributes.keyword#%'
		OR	CONSUMER.CONSUMER_SURNAME LIKE '%#attributes.keyword#%'
		OR	CONSUMER.CONSUMER_EMAIL LIKE '%#attributes.keyword#%'
		)
			</cfif>
		<cfelseif filter_cat eq 2>
			AND	COMPANY.ISPOTANTIAL=0
			AND	OFFER.PARTNER_ID=COMPANY_PARTNER.PARTNER_ID 
			AND	COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID
			<cfif len(attributes.keyword)>
			AND
				(
				COMPANY_PARTNER.COMPANY_PARTNER_NAME LIKE '%#attributes.keyword#%' OR
				COMPANY_PARTNER.COMPANY_PARTNER_SURNAME LIKE '%#attributes.keyword#%' OR
				COMPANY_PARTNER.COMPANY_PARTNER_EMAIL LIKE '%#attributes.keyword#%'
				)
			</cfif>
		<cfelseif filter_cat eq 3>
			AND CONSUMER.ISPOTANTIAL = 1
			AND OFFER.CONSUMER_ID = CONSUMER.CONSUMER_ID
			<cfif len(attributes.keyword)>
			AND
				(
				CONSUMER.CONSUMER_NAME LIKE '%#attributes.keyword#%' OR
				CONSUMER.CONSUMER_SURNAME LIKE '%#attributes.keyword#%' OR
				CONSUMER.CONSUMER_EMAIL LIKE '%#attributes.keyword#%'
				)
			</cfif>
		<cfelseif filter_cat eq 4>
			AND COMPANY.ISPOTANTIAL = 1
			AND OFFER.PARTNER_ID=COMPANY_PARTNER.PARTNER_ID
			AND COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID
			<cfif len(attributes.keyword)>
			AND
				(
				COMPANY_PARTNER.COMPANY_PARTNER_NAME LIKE '%#attributes.keyword#%' OR
				COMPANY_PARTNER.COMPANY_PARTNER_SURNAME LIKE '%#attributes.keyword#%' OR
				COMPANY_PARTNER.COMPANY_PARTNER_EMAIL LIKE '%#attributes.keyword#%'
				
				)
			</cfif>
		</cfif>
	</cfif>
	<cfif isdefined("attributes.company_id") and  isdefined("attributes.ismyhome")>
		AND
		(
		OFFER.COMPANY_ID = #attributes.company_id# OR
		OFFER.OFFER_TO LIKE '%,#attributes.company_id#,%'
		)
	</cfif>
	<cfif isdefined("attributes.consumer_id") and  isdefined("attributes.ismyhome")>
		AND OFFER.OFFER_TO LIKE '%#attributes.consumer_id#%'
	</cfif>
	<cfif isdefined("attributes.status") and (attributes.status neq 0)>
	  <cfif  attributes.status eq 1>
	    AND OFFER_STATUS = 1
	  <cfelseif attributes.status eq 2>
	    AND OFFER_STATUS = 0
	  </cfif>
	</cfif>
	ORDER BY 
		OFFER.OFFER_ID DESC
</cfquery>
