<cfcomponent>    
    <!--- Pazaryeri tanimlarini getirir --->
    <cffunction name="get_market_place_fnc" access="public" returntype="query"> 
		<cfargument type="numeric" name="marketplace_id" required="no">
        <cfquery name="GET_MARKET_PLACE" datasource="#This.dsn#">
            SELECT
				MARKET_PLACE_ID,
				MARKET_PLACE,
				API_KEY,
				SECRET_KEY,
				ROLE_NAME,
				ROLE_PASS,
				MERCHANT_ID,
				RECORD_EMP,
				RECORD_DATE,
				UPDATE_EMP,
				UPDATE_DATE
            FROM
                MARKET_PLACE_SETTINGS
			WHERE
				MARKET_PLACE_ID = <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#arguments.marketplace_id#">
    	</cfquery>
  		<cfreturn get_market_place>
    </cffunction>
	
	<!---Pazaryeri Entegrasyon Tanım Parametreleri Güncelleniyor--->   
    <cffunction name="upd_marketplace_setting" access="public">
        <cfargument type="string" name="api_key" required="yes">
        <cfargument type="string" name="secret_key" required="yes">
        <cfargument type="string" name="role_name" required="yes">
        <cfargument type="string" name="role_pass" required="yes">
        <cfargument type="string" name="merchant_id" required="yes">
		<cfargument type="numeric" name="marketplace_id" required="no">
        <cfquery name="UPD_MARKETPLACE_SETTING" datasource="#this.DSN#">
            UPDATE 
                MARKET_PLACE_SETTINGS 
            SET
                API_KEY = <cfif len(arguments.api_key)>'#arguments.api_key#'<cfelse>NULL</cfif>,
                SECRET_KEY = <cfif len(arguments.secret_key)>'#arguments.secret_key#'<cfelse>NULL</cfif>,
                ROLE_NAME = <cfif len(arguments.role_name)>'#arguments.role_name#'<cfelse>NULL</cfif>,
                ROLE_PASS = <cfif len(arguments.role_pass)>'#arguments.role_pass#'<cfelse>NULL</cfif>,
                MERCHANT_ID = <cfif len(arguments.merchant_id)>'#arguments.merchant_id#'<cfelse>NULL</cfif>,
                UPDATE_EMP = '#session.ep.userid#',
                UPDATE_DATE = #now()#
           WHERE 
               MARKET_PLACE_ID = <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#arguments.marketplace_id#">
        </cfquery>
	</cffunction>
    <!--- Pazaryeri Ürün Kategori tanimlarini getirir --->
    <cffunction name="get_market_place_product_cat_fnc" access="public" returntype="query"> 
		<cfargument type="numeric" name="product_catid" required="no">
		<cfargument type="numeric" name="marketplace_pc_id" required="no">
        <cfquery name="GET_MARKET_PLACE_PRODUCT_CATID" datasource="#This.dsn1#">
            SELECT
				PRODUCT_CAT.PRODUCT_CATID,
				PRODUCT_CAT.HIERARCHY,
				PRODUCT_CAT.PRODUCT_CAT,
				MPPC.MARKETPLACE_PC_ID,
				MPPC.GITTIGIDIYOR_HIERARCHY,
				MPPC.GITTIGIDIYOR_PRODUCT_CAT,
				MPPC.N11_HIERARCHY,
				MPPC.N11_PRODUCT_CAT,
				MPPC.HEPSIBURADA_HIERARCHY,
				MPPC.HEPSIBURADA_PRODUCT_CAT,
				MPPC.SAHIBINDEN_HIERARCHY,
				MPPC.SAHIBINDEN_PRODUCT_CAT,
				MPPC.AMAZON_HIERARCHY,
				MPPC.AMAZON_PRODUCT_CAT,
				MPPC.PTTAVM_HIERARCHY,
				MPPC.PTTAVM_PRODUCT_CAT,
				MPPC.RECORD_EMP,
				MPPC.RECORD_DATE,
				MPPC.UPDATE_EMP,
				MPPC.UPDATE_DATE
            FROM
                PRODUCT_CAT 
				LEFT JOIN #This.dsn#.MARKET_PLACE_PRODUCT_CAT MPPC ON MPPC.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID
			WHERE
				PRODUCT_CAT.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#arguments.product_catid#">
    	</cfquery>
  		<cfreturn get_market_place_product_catid>
    </cffunction>	
	
</cfcomponent>
