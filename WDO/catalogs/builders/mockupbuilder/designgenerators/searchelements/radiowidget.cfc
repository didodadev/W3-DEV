<cfcomponent extends="WDO.catalogs.builders.mockupbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            stck = this.domain[arrayFind(this.domain, function(elm) {
                return elm.name eq this.data.struct;
            })];
            element = stck.listOfElements[arrayFind(stck.listOfElements, function(elm) {
                return elm.label eq this.data.label;
            })];

            precode = [];

            languagegenerator = createObject( "component", "WDO.catalogs.builders.mockupbuilder.designgenerators.languagegenerator" );
            lang = languagegenerator.generate( element.langNo );

            template = "<d" & 'iv class="col col-12">' & lang & '</div>' & crlf() & ident();
            template = template & "<d" & 'iv class="col col-12">' & radios(element, function(any code) {
                arrayAppend(precode, code);
            }) & "</div>";

            precodeList = arrayToList(listToArray(arrayToList(precode, crlf()), crlf()), crlf() & ident());
            result = iif(len(precodeList), DE(precodeList & crlf() & ident()), DE(ident())) & template;
        </cfscript>
        <cfreturn result>
    </cffunction>

    <cffunction name="radios" access="public" returntype="string">
        <cfargument name="element" type="any">
        <cfargument name="precodeCallback" type="any">
        <cfscript>
            if (arguments.element.devmethod.value eq "")
            {
                return "";
            }
            else 
            {
                methodname = arguments.element.label & "_method_" & iif( isDefined( "arguments.element.devMethod.name" ), "arguments.element.devMethod.name", de("customcode") );
                codegen = createObject("component", "WDO.catalogs.builders.componentbuilders.codegenerators.codegenerator").createGenerator(arguments.element.devMethod.type);
                code = codegen.generate(arguments.element.devMethod, methodname);
                arguments.precodeCallback(code);
                iteratorname = methodname & "_iterator";
                iteratorcode = "<c" & 'fset ' & iteratorname & ' = createObject("component", "WDO.helpers.queryiterator").init(' & methodname & ')>';
                arguments.precodeCallback(iteratorcode);
                return "<cfoutput><c" & 'floop condition="##' & iteratorname & '.hasiter()##">' & crlf() & ident(this.identcount + 1) & '<input type="radio" style="float: none; display: inline;" name="' & arguments.element.label & this.index & '" ##''value="'' & ' & iteratorname & '.get(' & arguments.element.listValueIndex & ')##"> ##' & iteratorname & '.get(' & arguments.element.listDisplayIndex & ')##' & crlf() & ident() & '<cfset ' & iteratorname & '.next()>' & crlf() & ident() & "</cfloop></cfoutput>";
            }
        </cfscript>
    </cffunction>

</cfcomponent>