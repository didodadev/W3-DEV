<cfcomponent>

    <cffunction name="create">
        <cfargument name="widget" type="any">
        <cfargument name="masterWidget" type="any">

        <cfif arguments.widget.uniqid eq masterWidget>
            <cfscript>
                builder = new WDO.catalogs.builders.packagebuilder.boxbuilder( widget );
            </cfscript>
        <cfelse>
            <cfscript>
                builder = new WDO.catalogs.builders.packagebuilder.ajaxboxbuilder( widget );
            </cfscript>
        </cfif>
        <cfreturn builder>
    </cffunction>

</cfcomponent>