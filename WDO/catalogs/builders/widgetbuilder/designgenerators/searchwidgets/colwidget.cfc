<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.designgenerators.colwidget">

    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="index" type="numeric">
        <cfargument name="extends" type="string" default="">
        <cfreturn super.generate(arguments.index, ".searchwidgets")>
    </cffunction>

</cfcomponent>