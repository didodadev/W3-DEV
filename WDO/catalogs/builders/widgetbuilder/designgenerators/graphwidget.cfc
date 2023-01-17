<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="index" type="numeric">
        <cfargument name="filterFunc" type="function">
        <cfscript>
            cachebuilder = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.graph.cachebuilder").init(this.data, this.domain, this.eventtype, this.identcount);
            cachetemplate = cachebuilder.generate();

            template = ident( this.identcount - 1 ) & '<div class="col col-%s col-xs-12" type="column">' & crlf() & '%s' & crlf() & ident( this.identcount -1 ) & '</div>';

            boxwidget = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.blocks.boxwidget").init(this.data, this.domain, this.eventtype, this.identcount);
            container = boxwidget.generate();

            typename = replace( lCase( this.data.name ), " ", "_" );
            graphbuilder = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.graph.graphfactory").create( type: typename, data: this.data, domain: this.domain, ident: this.identcount );

            argumentbuilder = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.graph.argumentbuilder").init( type: typename, data: this.data, domain: this.domain, ident: this.identcount, eventtype: 'graph' );
            queryparams = argumentbuilder.generate( filterFunc );

            graphdata = graphbuilder.generate( queryparams );

            widgetcode = stringFormat( template, [ this.data.colsize, stringFormat( container, [ graphdata ] ) ] );

            if ( len( cachetemplate ) ) 
            {
                widgetcode = stringFormat( cachetemplate, [widgetcode] );
            }

            return widgetcode;
        </cfscript>
    </cffunction>

</cfcomponent>