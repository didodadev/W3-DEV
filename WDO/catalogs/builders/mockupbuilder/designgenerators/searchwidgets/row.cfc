<cfcomponent extends="WDO.catalogs.builders.mockupbuilder.designgenerators.row">

    <cffunction name="getcolwidget" access="public" returntype="any">
        <cfargument name="cols" type="any">
        <cfreturn createObject( "component", "WDO.catalogs.builders.mockupbuilder.designgenerators.searchwidgets.col" ).init( data:arguments.cols, domain:this.domain, identcount:this.identcount + 2, elementgroup:"searchelements", eventtype:this.eventtype )>
    </cffunction>

</cfcomponent>