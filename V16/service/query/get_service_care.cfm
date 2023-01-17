<cfquery NAME="GET_SERVICE_CARE" DATASOURCE="#DSN3#">
	SELECT
		SERVICE_CARE.PRODUCT_CARE_ID,
		SERVICE_CARE.PRODUCT_ID,
		SERVICE_CARE.CARE_DESCRIPTION,
		SERVICE_CARE.COMPANY_AUTHORIZED_TYPE,
		SERVICE_CARE.COMPANY_AUTHORIZED,
		SERVICE_CARE.SERIAL_NO,
		SERVICE_CARE.RECORD_DATE,
		SERVICE_CARE.START_DATE,
        P.PRODUCT_NAME,
        C.COMPANY_ID,
        C.FULLNAME,
        C2.CONSUMER_ID,
        C2.CONSUMER_NAME + ' ' + C2.CONSUMER_SURNAME AS CONSUMER
	FROM
		SERVICE_CARE AS SERVICE_CARE WITH (NOLOCK) 
    LEFT JOIN PRODUCT AS P ON P.PRODUCT_ID = SERVICE_CARE.PRODUCT_ID
    LEFT JOIN #dsn#.COMPANY_PARTNER AS CP ON CP.PARTNER_ID = SERVICE_CARE.COMPANY_AUTHORIZED
    LEFT JOIN #dsn#.COMPANY AS C ON C.COMPANY_ID = CP.COMPANY_ID
    LEFT JOIN #dsn#.CONSUMER AS C2 ON C2.CONSUMER_ID = SERVICE_CARE.COMPANY_AUTHORIZED
	WHERE
		SERVICE_CARE.PRODUCT_CARE_ID IS NOT NULL
		<cfif len(attributes.is_active) and (attributes.is_active eq 1)>AND SERVICE_CARE.STATUS = 1</cfif>
		<cfif len(attributes.is_active) and (attributes.is_active eq 0)>AND SERVICE_CARE.STATUS = 0</cfif>
		<cfif len(attributes.keyword)>AND SERVICE_CARE.CARE_DESCRIPTION LIKE '%#ATTRIBUTES.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>
	ORDER BY
		SERVICE_CARE.CARE_DESCRIPTION
</cfquery>
<cfquery name="GET_SERVICECARE_CAT" datasource="#DSN3#">
	SELECT
		*
	FROM
		SERVICE_CARE_CAT WITH (NOLOCK)
</cfquery>
