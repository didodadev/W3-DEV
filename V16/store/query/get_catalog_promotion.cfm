<cfquery name="GET_CATALOG" datasource="#DSN3#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		CP.CAMP_ID,
		CP.CATALOG_HEAD,
		CP.VALID,
		CP.VALID_EMP,
		CP.VALIDATE_DATE,
		CP.RECORD_EMP,
		CP.STARTDATE,
		CP.FINISHDATE,
		CP.CATALOG_ID,
		CP.RECORD_DATE,
		COUNT(CPP.CATALOG_ID) AS SAYI
	FROM
		CATALOG_PROMOTION CP,
		CATALOG_PROMOTION_PRODUCTS CPP
	WHERE
		CP.CATALOG_ID = CPP.CATALOG_ID AND
		CP.CATALOG_ID IN (
							SELECT DISTINCT
								C.CATALOG_ID
							FROM
								CATALOG_PROMOTION C,
								CATALOG_PRICE_LISTS CL
							WHERE
								C.CATALOG_ID = CL.CATALOG_PROMOTION_ID AND
								CL.PRICE_LIST_ID IN (SELECT PRICE_CATID FROM PRICE_CAT WHERE BRANCH LIKE '%,#listgetat(session.ep.user_location, 2, '-')#,%')
							<cfif len(attributes.record_id) and len(attributes.record_emp)>
								AND C.RECORD_EMP = #attributes.record_id#
							</cfif>
							<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
								AND C.STARTDATE >= #attributes.startdate#
							</cfif>
							<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
								AND C.FINISHDATE <= #attributes.finishdate#
							</cfif>	
							<cfif len(attributes.keyword)>
								AND C.CATALOG_HEAD LIKE '%#attributes.keyword#%'
							</cfif>
							<cfif len(attributes.catalog_status) and (attributes.catalog_status eq 0)>
								AND C.CATALOG_STATUS = 0
							<cfelseif len(attributes.catalog_status) and (attributes.catalog_status eq 1)>
								AND C.CATALOG_STATUS = 1
							</cfif>		
							)
		<cfif len(attributes.record_id) and len(attributes.record_emp)>
			AND CP.RECORD_EMP = #attributes.record_id#
		</cfif>
		<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
			AND CP.STARTDATE >= #attributes.startdate#
		</cfif>
		<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
			AND CP.FINISHDATE <= #attributes.finishdate#
		</cfif>	
		<cfif len(attributes.keyword)>
			AND CP.CATALOG_HEAD LIKE '%#attributes.keyword#%'
		</cfif>
		<cfif len(attributes.catalog_status) and (attributes.catalog_status eq 0)>
			AND CP.CATALOG_STATUS = 0
		<cfelseif len(attributes.catalog_status) and (attributes.catalog_status eq 1)>
			AND CP.CATALOG_STATUS = 1
		</cfif>
	GROUP BY 
		CP.CAMP_ID,
		CP.CATALOG_HEAD,
		CP.VALID,
		CP.VALID_EMP,
		CP.VALIDATE_DATE,
		CP.RECORD_EMP,
		CP.STARTDATE,
		CP.FINISHDATE,
		CP.CATALOG_ID,
		CP.RECORD_DATE		
	ORDER BY  
		CP.RECORD_DATE DESC
</cfquery>
