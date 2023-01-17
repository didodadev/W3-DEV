<!--- islem tiplerini atamadıgı icin raporlarda görünmüyordu FA--->
<!--- islem tiplerine gore stok hareketine ait islem kategorisi belirlenir --->
<cfcomponent>
    <cffunction name="get_ship_process_cat" returntype="any" output="false">
        <cfargument name="process_cat" default="" required="yes">
        <cfargument name="new_datasource" default="#this.dsn2#">
        <cfquery name="get_ship_process_cat" datasource="#new_datasource#">
            SELECT
                SPC.SHIP_TYPE_ID
            FROM
                #this.dsn3_alias#.SETUP_PROCESS_CAT SPC
            WHERE
                SPC.PROCESS_CAT_ID = #arguments.process_cat#
            ORDER BY
                SPC.PROCESS_CAT
        </cfquery>
        <cfreturn get_ship_process_cat.SHIP_TYPE_ID>
    </cffunction>
</cfcomponent>
