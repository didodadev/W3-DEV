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
                valueformat = "<c" & 'fset ' & this.data.label & '_defaultValue = iif(isDefined("' & this.data.struct & '_query"), "' & this.data.struct & '_query.' & this.data.label & '", DE(' & defaultValue & '))>';
            }
            arrayAppend(precode, valueformat);

            //set the dependencies
            getWidgetDependencyManager().addDependency( dependStruct: this.data.struct, dependEvent: this.eventtype );

            //attributes
            attrbuilder = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.attributes.attributebuilder");
            attrVal = attrbuilder.generate(element, stck.name, function(any code) {
                arrayAppend(precode, code);
            });
            
            if (isdefined("this.preattr") && arrayLen(this.preattr))
            {
                attrVal = attrVal & " " & arrayToList(this.preattr, " ");
            }

            template = '<select name="%s" id="%s" %s>';
            optionsVal = options(element, function(code) {
                arrayAppend(precode, code);
            });
            
            precodeList = arrayToList(listToArray(arrayToList(precode, crlf()), crlf()), crlf() & ident());
            result = iif(len(precodeList), DE(precodeList & crlf() & ident()), DE(ident())) & super.stringFormat(template, [element.label & this.index, stck.name & "_" & element.label & this.index, attrVal]);
            result = result & crlf() & optionsVal;
            result = result & crlf() & ident() & "</select>";
            if ( this.hasoutputtag ) {
                result = "<c" & 'foutput>' & crlf() & ident() & result & crlf() & ident() & "</cfoutput>";
            }
        </cfscript>
        <cfreturn result>
    </cffunction>

    <cffunction name="options" access="public" returntype="string">
        <cfargument name="element" type="any">
        <cfargument name="precodeCallback" type="any">
        <cfscript>
            if (arguments.element.devMethod.value eq "")
            {
                return "";
            }
            else
            {
                methodname = arguments.element.label & "_method_" & iif( isDefined( "arguments.element.devMethod.name" ), "arguments.element.devMethod.name", de("customcode") );
                codegen = createObject("component", "WDO.catalogs.builders.componentbuilders.codegenerators.codegenerator").createGenerator(arguments.element.devMethod.type);
                code = codegen.generate(arguments.element.devMethod, methodname );
                arguments.precodeCallback(code);
                iteratorname = methodname & "_iterator";
                iteratorcode = "<c" & 'fset ' & iteratorname & ' = createObject("component", "WDO.helpers.queryiterator").init(' & methodname & ')>';
                arguments.precodeCallback(iteratorcode);
                return ident(this.identcount + 1) & "<c" & 'floop condition="##' & iteratorname & '.hasiter()##">' & crlf() & ident(this.identcount + 1) & '<option ##''value="''&' & iteratorname & '.get(' & arguments.element.listValueIndex & ')&''"''## ##iif( isDefined("' & this.data.label & '_defaultValue") and ' & this.data.label & '_defaultValue eq ' & iteratorname & ".get(" & arguments.element.listValueIndex & "), DE('selected'), DE(''))##>##" & iteratorname & ".get(" & arguments.element.listDisplayIndex & ")##</option>" & crlf() & ident(this.identcount + 1) & '<cfset ' & iteratorname & '.next()>' & crlf() & ident(this.identcount + 1) & "</cfloop>";
            }
        </cfscript>
    </cffunction>

</cfcomponent>