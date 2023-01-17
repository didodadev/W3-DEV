<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="addCounter" access="remote"  returntype="string" returnFormat="json">
        <cfargument name="subscription_no" type="string" required="true">
        <cfargument name="asset_p_id" required="false" default = "0">
        <cfargument name="product_id" type="numeric" required="true">
        <cfargument name="amount" type="numeric" required="true">
        <cfargument name="process_type" type="numeric" required="true">
        <cfargument name="process_doc_no" type="string" required="true">
        <cfargument name="process_date" type="date" required="true">
        <cftry>
            <cf_date tarih = "arguments.process_date">
            
            <cfquery name = "add_counter_row" datasource="#dsn#">
                INSERT INTO
                    SUBSCRIPTION_COUNTER_ROWS
                (
                    SUBSCRIPTION_NO,
                    DOMAIN,
                    DOMAIN_IP,
                    ASSET_P_ID,
                    PRODUCT_ID,
                    AMOUNT,
                    PROCESS_TYPE,
                    PROCESS_DOC_NO,
                    PROCESS_DATE,
                    WEX_DATE,
                    IS_CALCULATION
                ) VALUES (
                    '#arguments.subscription_no#',
                    '#cgi.http_host#',
                    '#cgi.remote_addr#',
                    #arguments.asset_p_id#,
                    #arguments.product_id#,
                    #arguments.amount#,
                    '#arguments.process_type#',
                    '#arguments.process_doc_no#',
                    #arguments.process_date#,
                    #now()#,
                    0
                )
            </cfquery>

            <cfcatch type="any">
                <cfdump  var="#cfcatch#">
                <cfabort>
                <cfreturn 0>
            </cfcatch>
        </cftry>

        <cfreturn 1>
    </cffunction>
</cfcomponent>