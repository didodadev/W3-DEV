<cfcomponent extends="WDO.catalogs.builders.mockupbuilder.mockup">

    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="vformat" type="string">

        <cfscript>

            stck = this.domain[arrayFind(this.domain, function(elm) {
                return elm.name eq this.data.struct;
            })];
            element = stck.listOfElements[arrayFind(stck.listOfElements, function(elm) {
                return elm.label eq this.data.label;
            })];

            //set the dependencies
            //getWidgetDependencyManager().addDependency( dependStruct: this.data.struct, dependEvent: this.eventtype );
            
            //template
            result = "<c" & 'f_' & element.devMethod.tag & ' ' & replace( element.devMethod.formula, '\"', '"', "all" ) & '>'; 
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>