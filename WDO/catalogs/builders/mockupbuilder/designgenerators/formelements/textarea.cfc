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
                return defaultValueBuilder.generate( element, stck, function(any code) {
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
                valueformat = '##iif(isDefined("' & this.data.struct & '_query"), "' & this.data.struct & '_query.' & this.data.label & '", DE(' & defaultValue & '))##';
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

            if (element.maxSize neq "")
            {
                arrayAppend(postcode, '<input name="' & element.label & 'Len" id="' & element.label & 'Len" value="0">');

                arrayAppend(postcode, '<script type="text/javascript">' & crlf() & ident(1) & '$(document).ready(function() {' & crlf() & ident(1) & '$("##' & element.label & '").on("change, blur, keyup", function() {' & crlf() & ident(2) & 'if ($(this).val().length > ' & element.maxSize & ') { ' & crlf() & ident(3) & '$(this).val($(this).val().substr(0, ' & element.maxSize & ')); ' & crlf() & ident(2) & '}' & crlf() & ident(2) & '$("##' & element.label & 'Len").val($(this).val().length);' & crlf() & ident(1) & '});' & crlf() & ident(1) & '});' & crlf() & '</script>');
            }

            //template
            template = '<textarea name="%s" id="%s" %s>%s</textarea>';
            if ( this.hasoutputtag ) {
                template = "<c" & 'foutput>' & template & '</cfoutput>';
            }

            precodeList = arrayToList(listToArray(arrayToList(precode, crlf()), crlf()), crlf() & ident());
            result = "";
            if ( len(precodeList) ) {
                result = precodeList & crlf() & ident();
            }
            result = result & super.stringFormat(template, [element.label & this.index, stck.name & "_" & element.label & this.index, attrVal, valueformat]);
            postcodeList = crlf() & ident() & arrayToList(listToArray(arrayToList(postcode, crlf()), crlf()), crlf() & ident());
            result = result & postcodeList;

        </cfscript>
        <cfreturn result>
    </cffunction>
</cfcomponent>