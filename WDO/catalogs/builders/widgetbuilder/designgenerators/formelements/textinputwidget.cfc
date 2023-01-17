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
            postcode = [];

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

            //autocomplete
            autocompleteBuilder = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.methodbuilders.autocomplete");
            autocompleteVal = autocompleteBuilder.generate(element, stck.name, function(any code) {
                arrayAppend(precode, code);
            });

            //threepoint
            threepointBuilder = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.methodbuilders.threepoint");
            threepointVal = threepointBuilder.generate(element, stck.name
            , function(any code){
                arrayAppend(precode, code);
            }, function(any code) {
                arrayAppend(postcode, code);
            });

            //data formatter
            dataformatter = createObject( "component", "WDO.catalogs.builders.widgetbuilder.designgenerators.formatters.dataformatter" );
            
            //current value
            if ( isDefined("arguments.vformat") ) {
                valueformat = arguments.vformat;
            } else {
                if ( len( element.devDBField.value ) ) {
                    valueformat = '##iif(isDefined("' & this.data.struct & '_query"), "' & dataformatter.format( this.data.struct & '_query.' & this.data.label, element ) & '", DE(' & defaultValue & '))##';
                } else {
                    valueformat = "";
                }
            }

            //set the dependencies
            getWidgetDependencyManager().addDependency( dependStruct: this.data.struct, dependEvent: this.eventtype );
            
            //attributes
            attrbuilder = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.attributes.attributebuilder");
            attrVal = attrbuilder.generate(element, stck.name, function(any code) {
                arrayAppend(precode, code);
            }, function(any code) {
                arrayAppend(postcode, code);
            }, 1);
            
            if (isdefined("this.preattr") && arrayLen(this.preattr))
            {
                attrVal = attrVal & " " & arrayToList(this.preattr, " ");
            }
            
            //template
            template = '<input type="text" name="%s" id="%s" value="%s" %s>';
            if ( this.hasoutputtag ) {
                template = "<c" & 'foutput>' & template & '</cfoutput>';
            }

            precodeList = arrayToList(listToArray(arrayToList(precode, crlf()), crlf()), crlf() & ident());
            result = iif(len(precodeList), DE(precodeList & crlf() & ident()), DE("")) & super.stringFormat(template, [element.label & this.index, stck.name & "_" & element.label & this.index, valueformat, attrVal & autocompleteVal]);
            postcodeList = crlf() & ident() & arrayToList(listToArray(arrayToList(postcode, crlf()), crlf()), crlf() & ident());
            result = result & postcodeList;
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>