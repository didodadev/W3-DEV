<cfquery name="upd_address_member" datasource="#dsn#">
	<cfif attributes.is_comp eq 0>
            UPDATE
                CONSUMER
            SET
                <cfif attributes.no eq 1>
                    TAX_ADRESS=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.address#">,
                    TAX_POSTCODE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.p_code#">,
                    TAX_COUNTRY_ID=<cfif len(attributes.country)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country#"><cfelse>null</cfif>, 
                    TAX_CITY_ID=<cfif len(attributes.city)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city#"><cfelse>null</cfif>,
                    TAX_SEMT=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.town#">,
                    TAX_COUNTY_ID=<cfif len(attributes.county)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county#"><cfelse>null</cfif>,
                <cfelseif attributes.no eq 2>
                    HOMEADDRESS=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.address#">,
                    HOMEPOSTCODE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.p_code#">,
                    HOME_COUNTRY_ID=<cfif len(attributes.country)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country#"><cfelse>null</cfif>, 
                    HOME_CITY_ID=<cfif len(attributes.city)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city#"><cfelse>null</cfif>,
                    HOME_COUNTY_ID=<cfif len(attributes.county)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county#"><cfelse>null</cfif>,
                    HOMESEMT=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.town#">,
                <cfelseif attributes.no eq 3>
                    WORKADDRESS=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.address#">,
                    WORKPOSTCODE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.p_code#">,
                    WORK_COUNTY_ID=<cfif len(attributes.county)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county#"><cfelse>null</cfif>,
                    WORK_CITY_ID=<cfif len(attributes.city)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city#"><cfelse>null</cfif>,
                    WORK_COUNTRY_ID =<cfif len(attributes.country)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country#"><cfelse>null</cfif>, 
                    WORKSEMT=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.town#">,
                </cfif>
                    UPDATE_DATE=#now()#,
                    UPDATE_EMP=#session.ep.userid#,
                    UPDATE_IP='#cgi.remote_addr#'
            WHERE
                CONSUMER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
    <cfelse>
            UPDATE
                COMPANY
            SET
                COMPANY_ADDRESS=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.address#">, 
                COMPANY_POSTCODE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.p_code#">, 
                COUNTY=<cfif len(attributes.county)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county#"><cfelse>null</cfif>,
                CITY=<cfif len(attributes.city)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city#"><cfelse>null</cfif>,
                COUNTRY=<cfif len(attributes.country)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country#"><cfelse>null</cfif>, 
                SEMT=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.town#">,
                UPDATE_DATE=#now()#,
                UPDATE_EMP=#session.ep.userid#,
                UPDATE_IP='#cgi.remote_addr#'
            WHERE
                COMPANY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
    </cfif>
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
