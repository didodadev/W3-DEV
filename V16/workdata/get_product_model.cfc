<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_PRODUCT_MODEL" datasource="#DSN#_product">
                SELECT 
                	* 
                FROM 
                	PRODUCT_BRANDS_MODEL
				ORDER BY
					RECORD_DATE DESC,
					MODEL_ID DESC
            </cfquery>
          <cfreturn GET_PRODUCT_MODEL>
    </cffunction>
</cfcomponent>

