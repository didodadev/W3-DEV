<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.designgenerators.rowwidget">

    <cffunction name="getcolwidget" access="public" returntype="any">
        <cfargument name="cols" type="any">
        <cfreturn createObject( "component", "WDO.catalogs.builders.widgetbuilder.designgenerators.searchwidgets.colwidget" ).init( data:arguments.cols, domain:this.domain, identcount:this.identcount + 2, elementgroup:"searchelements", eventtype:this.eventtype )>
    </cffunction>

</cfcomponent>