<cfcomponent extends="WDO.catalogs.builders.mockupbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            stck = this.domain[arrayFind(this.domain, function(elm) {
                return elm.name eq this.data.struct;
            })];
            element = stck.listOfElements[arrayFind(stck.listOfElements, function(elm) {
                return elm.label eq this.data.label;
            })];

            languagegenerator = createObject( "component", "WDO.catalogs.builders.mockupbuilder.designgenerators.languagegenerator" );
            lang = languagegenerator.generate( element.langNo );

            template = '<d' & 'iv class="col col-12">' & lang & '</div>' & crlf();
            template = template & ident() & '<d' & 'iv class="col col-12"><cfoutput><textarea name="%s" id="%s" placeholder="%s"></textarea></cfoutput></div>' & crlf();

            result = super.stringFormat( template, [element.label, stck.name & "_" & element.label, lang] );
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>