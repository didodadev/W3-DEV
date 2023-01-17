<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            if (arrayLen(this.data.listOfElements)) {
                languagegenerator = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.languagegenerator");

                //stck = getTable(this.data.listOfElements[1]);
                //template = ident() & "<c" & 'fsavecontent variable="boxtitle">' & languagegenerator.generate( stck.langNo ) & '></cfsavecontent>' & crlf();
                //template = template & ident() & "<c" & 'f_box id="' & stck.name & '_box" closable="0" title="##boxtitle##">' & crlf() & '%s' & crlf() & ident() & '</cf_box>';
                template = '%s';
                template = template & crlf() & ident() & '<s' & 'cript type="text/javascript" src="/JS/assets/custom/formulaobserver.js"></script>';
            }
            else
            {
                template = "%s";
            }
        </cfscript>
        <cfreturn template>
    </cffunction>

    <cffunction name="getTable" access="private" returntype="any">
        <cfargument name="element" type="any">
        <cfscript>
            stk = arguments.element.struct;
            stck = this.domain[arrayFind(this.domain, function(elm) {
                return elm.name eq stk;
            })];
        </cfscript>
        <cfreturn stck>
    </cffunction>

</cfcomponent>