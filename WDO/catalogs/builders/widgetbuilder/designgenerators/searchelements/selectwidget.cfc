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

            languagegenerator = createObject( "component", "WDO.catalogs.builders.widgetbuilder.designgenerators.languagegenerator" );
            lang = languagegenerator.generate( element.langNo );

            template = "<d" & 'iv class="col col-12">' & lang & "</div>" & crlf() & ident();
            template = template & '<d' & 'iv class="col col-12"><foutput>' & crlf() & ident() & '<select name="%s" id="%s" %s>' & crlf();
            template = template & ident() & '<option value=""><cf_get_lang_main no ="322.Seçiniz"></option>' & crlf();
            template = template & ident() & '%s' & crlf();
            template = template & ident() & '</select>' & crlf();
            template = template & ident() & '</cfoutput></div>' & crlf();

            optionsVal = options(element, function(any code) {
                arrayAppend(precode, code);
            }, arguments.namepostfix);

            //attributes
            attrbuilder = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.attributes.attributebuilder");
            attrVal = attrbuilder.generate(element, stck.name, function(any code) {
                arrayAppend(precode, code);
            });
            
            if (isdefined("this.preattr") && arrayLen(this.preattr))
            {
                attrVal = attrVal & " " & arrayToList(this.preattr, " ");
            }
            
            precodeList = arrayToList(listToArray(arrayToList(precode, crlf()), crlf()), crlf() & ident());
            result = iif(len(precodeList), DE(precodeList & crlf() & ident()), DE(ident())) & super.stringFormat(template, [element.label & arguments.namepostfix & this.index, stck.name & "_" & element.label & arguments.namepostfix & this.index, attrVal, optionsVal]);

        </cfscript>
        <cfreturn result>
    </cffunction>

    <cffunction name="options" access="public" returntype="string">
        <cfargument name="element" type="any">
        <cfargument name="precodeCallback" type="any">
        <cfargument name="namepostfix" type="any">
        <cfscript>
            if (arguments.element.devMethod.value eq "")
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
                return ident(this.identcount + 1) & "<c" & 'floop condition="##' & iteratorname & '.hasiter()##">' & crlf() & ident(this.identcount + 1) & '<option value="##' & iteratorname & '.get(' & arguments.element.listValueIndex & ')##" ##iif(isDefined("attributes.searched") and ' & iteratorname & '.get(' & arguments.element.listValueIndex & ') eq iif( isDefined("attributes.' & arguments.element.label & arguments.namepostfix & '"), "attributes.' & arguments.element.label & arguments.namepostfix '", "" ), de(''selected="selected"''), de(""))##>##' & iteratorname & ".get(" & arguments.element.listDisplayIndex & ")##</option>" & crlf() & ident(this.identcount + 1) & '<cfset ' & iteratorname & '.next()>' & crlf() & ident(this.identcount + 1) & "</cfloop>";
            }
        </cfscript>
    </cffunction>

</cfcomponent>