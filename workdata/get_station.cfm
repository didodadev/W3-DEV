<!---M.ER 20.02.2008
	 Ürün İstasyonlarını  Getirir
--->
<cffunction name="get_station" access="public" returnType="query" output="no">
	<cfargument name="station_name" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="">
	<cfargument name="stock_id" required="no" type="string">
		<cfquery name="_GET_STATION_LIST_" datasource="#dsn3#">
			SELECT 
            	STATION_ID,
                STATION_NAME 
            FROM 
            	WORKSTATIONS 
            WHERE 
            	STATION_NAME LIKE '#arguments.station_name#%' 
                AND ACTIVE=1
                <cfif isdefined("arguments.stock_id") and len(arguments.stock_id)>
               		 AND WORKSTATIONS.STATION_ID IN(SELECT WS_ID FROM WORKSTATIONS_PRODUCTS WP WHERE WP.STOCK_ID IN(#arguments.stock_id#))
				</cfif>
		</cfquery>
	<cfreturn _GET_STATION_LIST_>
</cffunction>
