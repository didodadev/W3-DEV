<cfquery name="GET_SALE_DET" datasource="#DSN2#">
	SELECT 
		INVOICE.*,
        SPC.INVOICE_TYPE_CODE,
        CASE WHEN CA.ACTION_ID IS NOT NULL THEN CA.ACTION_ID ELSE 0 END AS RELATED_ACTION_ID,
		CASE WHEN CA.ACTION_ID IS NOT NULL THEN 'CASH_ACTIONS' ELSE '' END AS RELATED_ACTION_TABLE
	FROM 
		INVOICE
        LEFT JOIN CASH_ACTIONS CA ON CA.PAPER_NO = INVOICE.INVOICE_NUMBER  AND CA.ACTION_TYPE_ID = 35,
        #dsn3_alias#.SETUP_PROCESS_CAT SPC
	WHERE
    	INVOICE.PROCESS_CAT = SPC.PROCESS_CAT_ID AND
		INVOICE_CAT <> 67 AND
		INVOICE_CAT <> 69 AND
        PURCHASE_SALES = 1
		<cfif not isDefined("attributes.id")>
        	AND INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
        <cfelse>
        	AND INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
        </cfif>
		<cfif session.ep.isBranchAuthorization>
            AND 
            (
                INVOICE.RECORD_EMP IN
                (
                    SELECT 
                        EMPLOYEE_ID
                    FROM 
                        #dsn_alias#.EMPLOYEE_POSITIONS EP,
                        #dsn_alias#.DEPARTMENT D
                    WHERE
                        EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
                        D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
                )
                OR 
                INVOICE.DEPARTMENT_ID IN
                (
                    SELECT 
                        DEPARTMENT_ID
                    FROM 
                        #dsn_alias#.DEPARTMENT D
                    WHERE
                        D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
                )
            )
        </cfif>		
</cfquery>
<cfif len(get_sale_det.company_id) and get_sale_det.company_id neq 0>
	<cfset comp = "comp">
	<cfquery name="GET_SALE_DET_COMP" datasource="#DSN#">
		SELECT 
			COMPANY_ID,
            COMPANYCAT_ID,
			TAXOFFICE,
			TAXNO,
			COMPANY_ADDRESS,
			COUNTY,
			CITY,
			COUNTRY,
			FULLNAME,
			COMPANY_TELCODE,
			COMPANY_TEL1,
			COMPANY_FAX,
			COMPANY_ADDRESS,
			COMPANY_EMAIL,
			MOBIL_CODE,
			MOBILTEL,
			MEMBER_CODE,
			IMS_CODE_ID,
            USE_EFATURA,
			EFATURA_DATE,
			IS_PERSON
		FROM
			COMPANY
		WHERE 
			COMPANY.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det.company_id#">
	</cfquery>
	<cfif len(get_sale_det.partner_id)>
        <cfquery name="GET_SALE_DET_CONS" datasource="#DSN#">
            SELECT 
                PARTNER_ID,
                COMPANY_PARTNER_NAME,
                COMPANY_PARTNER_SURNAME
            FROM 
                COMPANY_PARTNER
            WHERE 
                PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det.partner_id#">
        </cfquery>
	</cfif>
<cfelseif len(get_sale_det.consumer_id)>
	<cfquery name="GET_CONS_NAME" datasource="#DSN#">
		SELECT 
			CONSUMER_ID,
            CONSUMER_CAT_ID,
			COMPANY,
			MEMBER_CODE,
			TC_IDENTY_NO,
			CONSUMER_NAME,
			CONSUMER_SURNAME,
			CONSUMER_WORKTELCODE,
			CONSUMER_WORKTEL,
			CONSUMER_FAX,
			CONSUMER_EMAIL,
			MOBIL_CODE,
			MOBILTEL,
			TAX_ADRESS,
			TAX_CITY_ID,
			TAX_COUNTY_ID,
			TAX_COUNTRY_ID,
			TAX_NO,
			TAX_OFFICE,
			VOCATION_TYPE_ID,
			IMS_CODE_ID,
            USE_EFATURA,
            EFATURA_DATE
		FROM 
			CONSUMER
		WHERE 
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det.consumer_id#">
	</cfquery>		
<cfelseif len(get_sale_det.employee_id)>
	<cfquery name="GET_EMPLOYEES" datasource="#dsn#">
		SELECT 
			EMPLOYEE_ID,
			EMPLOYEE_USERNAME,
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME
		FROM 
			EMPLOYEES
		WHERE 
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det.employee_id#">

	</cfquery>
</cfif>
<cfquery name="GET_PERIOD_DSNS" datasource="#DSN#"> <!--- faturaya irsaliye cekilebilecek aktif dönem ve bir önceki dönem bilgilerini getiriyor --->
    SELECT 
    	SP.PERIOD_YEAR, 
        SP.OUR_COMPANY_ID, 
        SP.PERIOD_ID 
    FROM 
    	SETUP_PERIOD SP 
    WHERE 
    	SP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
    	SP.PERIOD_ID IN (SELECT ISH.SHIP_PERIOD_ID FROM #dsn2_alias#.INVOICE_SHIPS ISH WHERE ISH.INVOICE_ID = <cfif not isDefined("attributes.id")><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"></cfif>)
</cfquery>
<cfif get_period_dsns.recordcount eq 0>
	<cfquery name="GET_PERIOD_DSNS" datasource="#DSN#"> <!--- faturaya irsaliye cekilebilecek aktif dönem ve bir önceki dönem bilgilerini getiriyor --->
		SELECT 
			SP.PERIOD_YEAR,
			SP.OUR_COMPANY_ID,
			SP.PERIOD_ID 
		FROM 
			SETUP_PERIOD SP
		WHERE 
			SP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
	</cfquery>
</cfif>
<!--- INVOICE_SHIPS tablosundaki SHIP_NUMBER alanı irsaliye no bilgilerini tutmadıgında ilgili döneme baglanıp irsaliye nolar alınıyor --->
<cfquery name="GET_WITH_SHIP_ALL" datasource="#dsn#">
	SELECT
		SHIP_DATE,
		SHIP_NUMBER,
		SHIP_ID,
		IS_WITH_SHIP,
		SHIP_PERIOD_ID,
		PROJECT_ID,
		SHIP_TYPE
	FROM
	(
        <cfloop query="get_period_dsns">
            SELECT
                S.SHIP_DATE,
                S.SHIP_NUMBER,
                INV_S.SHIP_ID,
                INV_S.IS_WITH_SHIP,
                INV_S.SHIP_PERIOD_ID,
                ISNULL(S.PROJECT_ID,0) PROJECT_ID,
				SHIP_TYPE
            FROM
                #dsn2_alias#.INVOICE_SHIPS INV_S,
                #dsn#_#get_period_dsns.period_year#_#get_period_dsns.our_company_id#.SHIP S
            WHERE
                INV_S.SHIP_ID = S.SHIP_ID		
                AND INV_S.SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_period_dsns.period_id#">
                <cfif not isDefined("attributes.id")>
                    AND INV_S.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
                <cfelse>
                    AND INV_S.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
                </cfif>
                <cfif currentrow neq get_period_dsns.recordcount> 
                    UNION ALL
                </cfif>					
        </cfloop>
	) AS A1
</cfquery>
<!--- faturaya cekilen irsaliyeler ve bu irsaliyelerin period_id lerini tutar --->
<cfset ship_id_with_period = "">
<cfset ship_project_without_period = "">

<cfset ship_date_without_period = "">
<cfloop query="get_with_ship_all">
	<cfset ship_id_with_period = listappend(ship_id_with_period,'#get_with_ship_all.ship_id#;#get_with_ship_all.ship_period_id#')>
	<cfif get_with_ship_all.is_with_ship eq 0>
		<cfset ship_project_without_period = listappend(ship_project_without_period,'#project_id#')>
		<cfset ship_date_without_period = listappend(ship_date_without_period,'#dateformat(get_with_ship_all.ship_date,"dd/mm/yyyy")#')>
	</cfif>
</cfloop>
<cfquery name="GET_WITH_SHIP" dbtype="query">
	SELECT * FROM GET_WITH_SHIP_ALL WHERE IS_WITH_SHIP = 1 
</cfquery>
<cfquery name="GET_ORDER" datasource="#DSN3#">
	SELECT
		ORDER_ID,
		ORDER_NUMBER
	FROM 
		ORDERS_INVOICE
	WHERE 
		INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#"> AND
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
</cfquery>
<cfif get_order.recordcount>
	<cfquery name="GET_ORDER_NUM" datasource="#DSN3#">
		SELECT
			ORDER_NUMBER,
			ORDER_ID
		FROM 
			ORDERS 
		WHERE 
			<cfif get_order.recordcount>
                ORDER_ID IN (#listsort(valuelist(get_order.order_id),"numeric","asc",",")#)
            <cfelse>
                ORDER_ID IS NULL
            </cfif>
	</cfquery>
</cfif>
<cfquery name="get_makbuz_info" datasource="#dsn#">
    SELECT IS_EPRODUCER_RECEIPT, IS_EVOUCHER FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.company_id# 
</cfquery>
<cfquery name="PAYMENT_GET_SALE_DET_COMP" datasource="#DSN#">
	SELECT 
		COMPANY_ID,
		COMPANYCAT_ID,
		TAXOFFICE,
		TAXNO,
		COMPANY_ADDRESS,
		COUNTY,
		CITY,
		COUNTRY,
		FULLNAME,
		COMPANY_TELCODE,
		COMPANY_TEL1,
		COMPANY_FAX,
		COMPANY_ADDRESS,
		COMPANY_EMAIL,
		MEMBER_CODE,
		IMS_CODE_ID,
		USE_EFATURA,
		EFATURA_DATE,
		IS_PERSON
	FROM
		COMPANY
	WHERE 
		COMPANY.COMPANY_ID = '#get_sale_det.payment_company_id#'
</cfquery>