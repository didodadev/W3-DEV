
<!--- amac            : gelen ship_method parametresine g�re  SHIP_METHOD_ID,SHIP_METHOD bilgisini getirmek
	  parametre adi   : ship_method
	  kullanim        : get_ship_method('Sevk Yontemi') --->
<cffunction name="get_ship_method" access="public" returnType="query" output="no">
	<cfargument name="ship_method" required="yes" type="string">
     <cfquery name="GET_SHIP" datasource="#dsn#">
        SELECT
            SHIP_METHOD_ID,
            SHIP_METHOD
        FROM
            SHIP_METHOD 
        WHERE
            SHIP_METHOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ship_method#%">
        ORDER BY SHIP_METHOD    
     </cfquery>				
<cfreturn get_ship>
</cffunction>
	 


