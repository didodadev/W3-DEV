<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            stck = this.domain[arrayFind(this.domain, function(elm) {
                return elm.name eq this.data.struct;
            })];
            element = stck.listOfElements[arrayFind(stck.listOfElements, function(elm) {
                return elm.label eq this.data.label;
            })];
            languagegenerator = createObject( "component", "WDO.catalogs.builders.widgetbuilder.designgenerators.languagegenerator" );
            lang = languagegenerator.generate( element.langNo );

            //template
            template = '<d' & 'iv class="col col-12">' & lang & '</div>' & crlf() & ident();
            template = "<d" & 'iv class="col col-12"><cfoutput><input type="checkbox" name="%s" id="%s" value="1"></cfoutput></div>' & lang;
            result = super.stringFormat( template, [element.label, stck.name & "_" & element.label] );
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>