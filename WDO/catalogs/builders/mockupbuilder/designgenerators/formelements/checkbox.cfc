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
            precode = [];
            postcode = [];

            //valueOf
            valueofGenerator = createObject( "component", "WDO.catalogs.builders.mockupbuilder.designgenerators.properties.valueof" );
            defaultValue = valueOfGenerator.generate( element, stck, this.eventtype, function() {
                //default value
                defaultValueBuilder = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.methodbuilders.defaultvalue");
                return defaultValueBuilder.generate( element, function(any code) {
                    arrayAppend(precode, code);
                });
            } );

            //ifmethod
            /*
            ifmethodBuilder = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.methodbuilders.ifmethod");
            temp = ifmethodBuilder.generate(element, function(any code) {
                arrayAppend(precode, code);
            });
            */
            
            //current value
            if ( isDefined("arguments.vformat") ) {
                valueformat = arguments.vformat;
            } else {
                valueformat = '##iif(iif(isDefined("' & this.data.struct & '_query"), "' & this.data.struct & '_query.' & this.data.label & '", DE(' & defaultValue & ')) eq 1, DE("checked=""checked"""), DE(""))##';
            }

            //set the dependencies
            //getWidgetDependencyManager().addDependency( dependStruct: this.data.struct, dependEvent: this.eventtype );
            
            //attributes
            attrbuilder = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.attributes.attributebuilder");
            attrVal = attrbuilder.generate(element, stck.name, function(any code) {
                arrayAppend(precode, code);
            });
            
            if (isdefined("this.preattr") && arrayLen(this.preattr))
            {
                attrVal = attrVal & " " & arrayToList(this.preattr, " ");
            }

            //template
            template = '<input type="checkbox" name="%s" id="%s" value="1" %s %s>';

            if ( this.hasoutputtag ) {
                template = "<c" & 'foutput>' & template & '</cfoutput>';
            }

            precodeList = arrayToList(listToArray(arrayToList(precode, crlf()), crlf()), crlf() & ident());
            result = iif(len(precodeList), DE(precodeList & crlf() & ident()), DE("")) & super.stringFormat(template, [element.label & this.index, stck.name & "_" & element.label & this.index, valueformat, attrVal]);
            postcodeList = crlf() & ident() & arrayToList(listToArray(arrayToList(postcode, crlf()), crlf()), crlf() & ident());
            result = result & postcodeList;
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>