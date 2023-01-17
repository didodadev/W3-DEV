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

            if (element.method.value neq "")
            {
                methodgen = createObject("component", "WDO.catalogs.builders.componentbuilders.codegenerators.codegenerator").createGenerator(element.method.type);
                methodcode = methodgen.generate(element.method, element.label & "_method_");
                arrayAppend(precode, methodcode);
            }

            languagegenerator = createObject( "component", "WDO.catalogs.builders.mockupbuilder.designgenerators.languagegenerator" );
            lang = languagegenerator.generate( element.langNo );

            //template
            template = '<d' & 'iv class="col col-12">' & lang & '</div>' & crlf() & ident();
            template = '<d' & 'iv class="col col-12">';
            template = template & '<cf_multiselect_check query_name="' & element.label & '_method_' & element.method.name & '" option_text="##getLang(''main'',''' & element.langNo & ''')##" name="' & element.label & this.index & '" width="180" option_name="listGetAt(' & element.label & '_method_' & element.method.name & '.columnlist, 1)" option_value="listGetAt(' & element.label & '_method_' & element.method.name & '.columnlist, 2)">';
            template = template & '</div>';

            precodeList = arrayToList(listToArray(arrayToList(precode, crlf()), crlf()), crlf() & ident());

            result = iif(len(precodeList), DE(precodeList & crlf() & ident()), DE(ident())) & template;
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>