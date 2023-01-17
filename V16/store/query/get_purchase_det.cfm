<cfquery name="GET_SALE_DET" datasource="#dsn2#">
	SELECT 
    	INVOICE_ID, 
        INVOICE_CAT, 
        SHIP_DATE, 
        SERIAL_NUMBER, 
        SERIAL_NO, 
        INVOICE_NUMBER, 
        COMPANY_ID, 
        PARTNER_ID, 
        CONSUMER_ID, 
        EMPLOYEE_ID, 
        DEPARTMENT_LOCATION, 
        DEPARTMENT_ID, 
        NETTOTAL, 
        PAY_METHOD, 
        DUE_DATE, 
        NOTE, 
        ORDER_ID, 
        DELIVER_EMP, 
        SHIP_METHOD, 
        IS_CASH, 
        CASH_ID, 
        KASA_ID, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        SALE_EMP, 
        SALE_PARTNER, 
        PROJECT_ID, 
        UPD_STATUS, 
        PROCESS_CAT, 
        IS_WITH_SHIP, 
        IS_IPTAL, 
        REF_NO, 
        IS_COST, 
        SHIP_ADDRESS_ID, 
        IS_RETURN, 
        CARD_PAYMETHOD_ID, 
        CARD_PAYMETHOD_RATE, 
        COMMETHOD_ID, 
        CONSUMER_REFERENCE_CODE, 
        PARTNER_REFERENCE_CODE, 
        CARI_ACTION_TYPE, 
        CANCEL_TYPE_ID, 
        ASSETP_ID, 
        ACC_DEPARTMENT_ID, 
        SUBSCRIPTION_ID, 
        CITY_ID, 
        COUNTY_ID, 
        DELIVER_CONS_ID, 
        CONTRACT_ID, 
        RECORD_DATE, 
        RECORD_EMP, 
        ACC_TYPE_ID 
    FROM 
    	INVOICE 
    WHERE 
    	INVOICE_ID=#URL.IID#
</cfquery>
<cfif len(get_sale_det.company_id) >
	<cfquery name="GET_SALE_DET_COMP" datasource="#dsn#">
		SELECT 
			COMPANY_ID,
			TAXOFFICE,
			TAXNO,
			COMPANY_ADDRESS,
			FULLNAME
		FROM
			COMPANY
		WHERE 
			COMPANY_ID=#GET_SALE_DET.COMPANY_ID#
	</cfquery>
	<cfif len(GET_SALE_DET.PARTNER_ID)>
	<cfquery name="GET_SALE_DET_CONS" datasource="#dsn#">
		SELECT
			PARTNER_ID,COMPANY_PARTNER_NAME,
			COMPANY_PARTNER_SURNAME
		FROM
			COMPANY_PARTNER
		WHERE
			PARTNER_ID= #GET_SALE_DET.PARTNER_ID#
	</cfquery>
	</cfif>
<cfelseif len(GET_SALE_DET.CONSUMER_ID)>
	<cfquery name="GET_CONS_NAME" datasource="#dsn#">
		SELECT
			CONSUMER_NAME,
			CONSUMER_SURNAME,
			COMPANY,
			CONSUMER_ID
		FROM
			CONSUMER
		WHERE
			CONSUMER_ID=#GET_SALE_DET.CONSUMER_ID#
	</cfquery>		
</cfif>
<cfquery name="GET_WITH_SHIP_ALL" datasource="#dsn2#">
	SELECT
		SHIP_NUMBER,
		SHIP_ID,
		IS_WITH_SHIP,
		SHIP_PERIOD_ID
	FROM
		INVOICE_SHIPS 
	WHERE
	<cfif not isDefined("attributes.ID")>
		INVOICE_ID=#attributes.IID#
	<cfelse>
		INVOICE_ID=#attributes.ID#
	</cfif>
</cfquery>

<!--- faturaya cekilen irsaliyeler ve bu irsaliyelerin period_id lerini tutar --->
<cfset ship_id_with_period = "">
<cfloop query="GET_WITH_SHIP_ALL">
	<cfset ship_id_with_period = listappend(ship_id_with_period,'#GET_WITH_SHIP_ALL.SHIP_ID#;#GET_WITH_SHIP_ALL.SHIP_PERIOD_ID#')>
</cfloop>

<cfquery name="GET_WITH_SHIP" dbtype="query">
	SELECT 
    	* 
    FROM 
	    GET_WITH_SHIP_ALL 
    WHERE 
    	IS_WITH_SHIP = 1 
</cfquery>

