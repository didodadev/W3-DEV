<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="vformat" type="string">

        <cfscript>
            stck = this.domain[arrayFind(this.domain, function(elm) {
                return elm.name eq this.data.struct;
            })];
            element = stck.listOfElements[arrayFind(stck.listOfElements, function(elm) {
                return elm.label eq this.data.label;
            })];

            precode = [];

            //valueOf
            valueofGenerator = createObject( "component", "WDO.catalogs.builders.widgetbuilder.designgenerators.properties.valueof" );
            defaultValue = valueOfGenerator.generate( element, stck, this.eventtype, function() {
                //default value
                defaultValueBuilder = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.methodbuilders.defaultvalue");
                return defaultValueBuilder.generate( element, stck, function(any code) {
                    arrayAppend(precode, code);
                });
            } );


            //ifmethod
            /*
            ifmethodBuilder = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.methodbuilders.ifmethod");
            temp = ifmethodBuilder.generate(element, function(any code) {
                arrayAppend(precode, code);
            });
            */

            //current value
            if ( isDefined("arguments.vformat") ) {
                valueformat = arguments.vformat;
            } else {
                valueformat = "<c" & 'fset ' & this.data.label & '_defaultValue = ####iif(isDefined("' & this.data.struct & '_query"), "' & this.data.struct & '_query.' & this.data.label & '", DE(' & defaultValue & '))####>';
            }
            arrayAppend(precode, valueformat);

            //set the dependencies
            getWidgetDependencyManager().addDependency( dependStruct: this.data.struct, dependEvent: this.eventtype );

            if (element.devMethod.value neq "")
            {
                methodgen = createObject("component", "WDO.catalogs.builders.componentbuilders.codegenerators.codegenerator").createGenerator(element.devMethod.type);
                methodcode = methodgen.generate(element.devMethod, element.label & "_method_");
                arrayAppend(precode, methodcode);
            }

            template = '<cf_multiselect_check query_name="' & element.label & '_method_' & element.devMethod.name & '" option_text="##getLang(''main'',''' & element.langNo & ''')##" name="' & element.label & this.index & '" width="180" option_name="listGetAt(' & element.label & '_method_' & element.devMethod.name & '.columnlist, 1)" option_value="listGetAt(' & element.label & '_method_' & element.label & '.columnlist, 2)" value="##' & element.label & '_defaultValue##">';
            
            precodeList = arrayToList(listToArray(arrayToList(precode, crlf()), crlf()), crlf() & ident());
            result = iif(len(precodeList), DE(precodeList & crlf() & ident()), DE(ident())) & template;
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>