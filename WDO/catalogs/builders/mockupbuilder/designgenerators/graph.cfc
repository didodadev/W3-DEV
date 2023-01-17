<cfcomponent extends="WDO.catalogs.builders.mockupbuilder.mockup">

    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="index" type="numeric">
        <cfargument name="filterFunc" type="function">
        <cfscript>

            typename = replace( lCase( this.data.name ), " ", "_" );
            template = ident( this.identcount - 1 ) & '<div class="col col-%s col-xs-12 text-center">' & crlf() & '%s' & crlf() & ident( this.identcount -1 );
            template = template & '<img src="' & this.emp_url & '/images/graphics/' & typename & '.png" height="250"></img>';
            template = template & '</div>';
            
            /* boxMethod = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.blocks.box").init(this.data, this.domain, this.eventtype, this.identcount);
            container = boxMethod.generate(); */

            /*typename = replace( lCase( this.data.name ), " ", "_" );
            graphbuilder = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.graph.graphfactory").create( type: typename, data: this.data, domain: this.domain, ident: this.identcount );

            argumentbuilder = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.graph.argumentbuilder").init( type: typename, data: this.data, domain: this.domain, ident: this.identcount, eventtype: 'graph' );
            queryparams = argumentbuilder.generate( filterFunc );

            graphdata = graphbuilder.generate( queryparams ); */

            widgetcode = stringFormat( template, [ this.data.colsize, index, "", "" ] );

            return widgetcode;
        </cfscript>
    </cffunction>

</cfcomponent>