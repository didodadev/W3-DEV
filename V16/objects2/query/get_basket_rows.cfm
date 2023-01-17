<cfif not isdefined("session.pp") and not isdefined("session.ww.userid") and not IsDefined("Cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
	<cfset cookie_name_ = createUUID()>
	<cfcookie name="wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#cookie_name_#" expires="1">
</cfif>
<cfquery name="GET_ROWS" datasource="#DSN3#">
	SELECT 
		'0' AS TYPE,
		OPR.*,
		S.STOCK_CODE,
		S.BARCOD,
		S.STOCK_CODE_2,
  		S.IS_INVENTORY,
        S.PRODUCT_DETAIL,
		S.IS_LIMITED_STOCK,
		PU.DIMENTION,
		PU.MAIN_UNIT,
		S.PROPERTY,
		P.PRODUCT_NAME,
        P.IS_ZERO_STOCK,
        P.USER_FRIENDLY_URL,
		P.IS_EXTRANET,
		P.IS_INTERNET,
        P.PRODUCT_CODE_2,
        P.MANUFACT_CODE,
        PC.IS_INSTALLMENT_PAYMENT
	FROM
		ORDER_PRE_ROWS OPR,
		STOCKS S,
		PRODUCT P,
		PRODUCT_UNIT PU,
        PRODUCT_CAT PC
	WHERE
    	PC.PRODUCT_CATID = P.PRODUCT_CATID AND
		P.PRODUCT_ID = S.PRODUCT_ID AND
		OPR.STOCK_ID = S.STOCK_ID AND
		S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
		S.PRODUCT_ID = PU.PRODUCT_ID AND
        P.PRODUCT_STATUS = 1 AND
        <!--- Dore de kaldırılacak --->
        <cfif isdefined('session.pp')>    
    	    P.IS_EXTRANET = 1 AND
        <cfelse>
	        P.IS_INTERNET = 1 AND 
        </cfif>
        <!--- Dore de kaldırılacak --->
		<cfif isdefined('attributes.x_is_order_type_') and attributes.x_is_order_type_ eq 0>
			OPR.IS_PART = 0 AND
		<cfelseif isdefined('attributes.x_is_order_type_') and attributes.x_is_order_type_ eq 1>
			OPR.IS_PART = 1 AND
		</cfif>
		<cfif isdefined("session.pp")>
			OPR.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
		<cfelseif isdefined("session.ww.userid")>
			OPR.RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
		<cfelseif isdefined("session.ep")>
			OPR.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		<cfelseif not isdefined("session_base.userid")><!--- sistemde olmayan misafir kullanıcılar için baskete atılan ürünler --->
			OPR.RECORD_GUEST = 1 AND 
			OPR.RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
			OPR.COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#')#"> AND
		</cfif>
		OPR.PRODUCT_ID IS NOT NULL
	ORDER BY 
		<cfif isdefined('attributes.is_basket_use_detail_promotion') and attributes.is_basket_use_detail_promotion eq 1>
			ISNULL(OPR.IS_PROM_ASIL_HEDIYE,0) ASC,
			OPR.PRICE_KDV DESC
		<cfelse>
			OPR.ORDER_ROW_ID
		</cfif>
</cfquery>

<!--- Ödeme yöntemleriyle taksit yapılmayacak ürünler --->
<cfquery name="GET_INS_PRODUCTS" dbtype="query">
	SELECT PRODUCT_NAME FROM GET_ROWS WHERE IS_INSTALLMENT_PAYMENT = 1
</cfquery>

<cfif session_base.language neq 'tr'>
	<cfif not isDefined('get_all_for_langs')>
        <cfquery name="GET_ALL_FOR_LANGS" datasource="#DSN#">
            SELECT 
                UNIQUE_COLUMN_ID, 
                TABLE_NAME,
                COLUMN_NAME,
                LANGUAGE,
                ITEM 
            FROM 
                SETUP_LANGUAGE_INFO 
            WHERE 
                (
                	(TABLE_NAME = 'PRODUCT' AND COLUMN_NAME = 'PRODUCT_NAME') OR
                	(TABLE_NAME = 'SETUP_COUNTRY' AND COLUMN_NAME = 'COUNTRY_NAME') OR
                	(TABLE_NAME = 'SETUP_UNIT' AND COLUMN_NAME = 'UNIT')                
                ) AND
                ITEM <> '' AND
                LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#">
        </cfquery>
	</cfif>
    
    <cfquery name="GET_PRODUCT_NAMES" dbtype="query">
    	SELECT * FROM GET_ALL_FOR_LANGS WHERE TABLE_NAME = 'PRODUCT' AND COLUMN_NAME = 'PRODUCT_NAME'
    </cfquery>
    
    <cfquery name="GET_ENG_UNITS" dbtype="query">
    	SELECT * FROM GET_ALL_FOR_LANGS WHERE TABLE_NAME = 'SETUP_UNIT' AND COLUMN_NAME = 'UNIT'
    </cfquery>
</cfif> 

