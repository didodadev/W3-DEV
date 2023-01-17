<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="index" type="numeric">
        <cfargument name="extends" type="string" default="">
        <cfscript>
            template = result = ident(this.identcount - 1) & '<div class="col col-%s col-xs-12" type="column" index="%s" sort="true" data-formulacontainer="%s">' & crlf() & '%s' & crlf() & ident(this.identcount - 1) & '</div>';
            result = "";
            formulacontainer = "";
            for (field in this.data.listOfElements) {
                if (len(formulacontainer) eq 0) formulacontainer = field.struct;
                fgwidget = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators#extends#.formgroupwidget").init( data:field, domain:this.domain, identcount:this.identcount + 1, elementgroup:this.elementgroup, eventtype:this.eventtype );
                result = result & fgwidget.generate() & crlf();
            }
            result = rtrim(result);
            result = super.stringFormat(template, [this.data.colsize, index, formulacontainer, result]);
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>