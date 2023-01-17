<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="namepostfix" default="">
        <cfscript>
            stck = this.domain[arrayFind(this.domain, function(elm) {
                return elm.name eq this.data.struct;
            })];
            element = stck.listOfElements[arrayFind(stck.listOfElements, function(elm) {
                return elm.label eq this.data.label;
            })];

            precode = [];
            postcode = [];

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

            //defaultvalue
            defaultvalue = '##iif(isDefined("attributes.' & element.label & arguments.namepostfix & '"), "attributes.' & element.label & arguments.namepostfix & '", de(""))##';

            languagegenerator = createObject( "component", "WDO.catalogs.builders.widgetbuilder.designgenerators.languagegenerator" );
            lang = languagegenerator.generate( element.langNo );

            //attributes
            attrbuilder = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.attributes.attributebuilder");
            clonedElement = duplicate(element);
            clonedElement.isrequired = 0;
            clonedElement.label = clonedElement.label & arguments.namepostfix;
            attrVal = attrbuilder.generate(clonedElement, stck.name, function(any code) {
                arrayAppend(precode, code);
            }, function(any code) {
                arrayAppend(postcode, code);
            }, 1);
            
            if (isdefined("this.preattr") && arrayLen(this.preattr))
            {
                attrVal = attrVal & " " & arrayToList(this.preattr, " ");
            }

            //template
            template = "<d" & 'iv class="col col-12">' & lang & '</div>' & crlf();
            template = template & ident() & "<d" & 'iv class="col col-12">%s<cfoutput><input type="text" name="%s" id="%s" value="%s" placeholder="%s" %s></cfoutput>%s</div>' & crlf();

            precodeList = arrayToList(listToArray(arrayToList(precode, crlf()), crlf()), crlf() & ident());
            postcodeList = crlf() & ident() & arrayToList(listToArray(arrayToList(postcode, crlf()), crlf()), crlf() & ident());
            result = super.stringFormat(template, [precodeList, element.label & arguments.namepostfix , stck.name & "_" & element.label & arguments.namepostfix, defaultvalue, lang, attrVal & autocompleteVal, postcodeList]);

        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>