<!---
<cfdump var="#attributes#"><cfabort>
<cfscript>
	marketplace = createObject("Component","V16.add_options.b2b2c.protein.cfc.marketplace");
	marketplace.dsn = dsn;
	Integration = marketplace.upd_marketplace_setting(
															mp_api_key:attributes.api_key,
															mp_secret_key:attributes.secret_key,
															mp_role_name:attributes.role_name,
															mp_role_pass:attributes.role_pass,
															mp_role_pass:attributes.merchant_id;
</cfscript>
--->

        <cfquery name="UPD_MARKETPLACE_SETTING" datasource="#DSN#">
            UPDATE 
                MARKET_PLACE_SETTINGS 
            SET
                API_KEY = <cfif len(attributes.api_key)>'#attributes.api_key#'<cfelse>NULL</cfif>,
                SECRET_KEY = <cfif len(attributes.secret_key)>'#attributes.secret_key#'<cfelse>NULL</cfif>,
                ROLE_NAME = <cfif len(attributes.role_name)>'#attributes.role_name#'<cfelse>NULL</cfif>,
                ROLE_PASS = <cfif len(attributes.role_pass)>'#attributes.role_pass#'<cfelse>NULL</cfif>,
                MERCHANT_ID = <cfif len(attributes.merchant_id)>'#attributes.merchant_id#'<cfelse>NULL</cfif>,
                UPDATE_EMP = '#session.ep.userid#',
                UPDATE_DATE = #now()#
           WHERE 
               MARKET_PLACE_ID = <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.marketplace_id#">
        </cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
