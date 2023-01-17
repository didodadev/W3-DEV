<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_PRODUCT" datasource="#DSN3#">
			SELECT
				PRODUCT_NAME
			FROM 
				PRODUCT
			WHERE
				PRODUCT_ID = 3347
            </cfquery>
          <cfreturn GET_PRODUCT.PRODUCT_NAME>
    </cffunction>
</cfcomponent>


