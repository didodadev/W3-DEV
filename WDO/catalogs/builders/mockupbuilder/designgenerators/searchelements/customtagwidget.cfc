<cfcomponent extends="WDO.catalogs.builders.mockupbuilder.widget">

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
            getWidgetDependencyManager().addDependency( dependStruct: this.data.struct, dependEvent: this.eventtype );
            
            languagegenerator = createObject( "component", "WDO.catalogs.builders.mockupbuilder.designgenerators.languagegenerator" );
            lang = languagegenerator.generate( element.langNo );

            //template
            template = '<d' & 'iv class="col col-12">' & lang & '</div>' & crlf() & ident();
            template = template & '<d' & 'iv class="col col-12"><cf_' & element.devMethod.tag & ' ' & replace( element.devMethod.formula, '\"', '"', "all" ) & '></div>';

            result = template;
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>