<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="index" type="numeric">
        <cfscript>
            template = ident(this.identcount - 1) & '<div class="col col-%s col-xs-12" type="column" index="%s" sort="true" data-formulacontainer="%s">' & crlf() & '%s' & crlf() & ident(this.identcount - 1) & '</div>';
            boxwidget = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.blocks.boxwidget").init(this.data, this.domain, this.eventtype, this.identcount);
            container = boxwidget.generate();
            tblwidget = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.blocks.tablewidget").init(this.data, this.domain, this.eventtype, this.identcount + 1);
            result = tblwidget.generate();
            result = rtrim(result);
            formulacontainer = this.data.listOfElements[1].struct;
            result = super.stringFormat(template, [this.data.colsize, index, formulacontainer, super.stringFormat(container, [result])]);
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>