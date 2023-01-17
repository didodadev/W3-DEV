<cfcomponent>
    <cfproperty name="data" type="any">
    <cfproperty name="dependencies" type="struct" getter="true">
    
    <cffunction name="init" access="public" returntype="any">
        <cfargument name="data" type="any">
        <cfset this.data = arguments.data>
        <cfset this.dependencies = {}>
        <cfreturn this>
    </cffunction>

    <cffunction name="generate" access="public" returntype="any">
        <cfargument name="layout" type="string" default="">
        <cfscript>
            result = {};
            resolver = createObject( "component", "WDO.catalogs.objectResolver" ).init();
            helper = createObject( "component", "WDO.catalogs.builders.widgetbuilder.helper" );
            if ( ( layout eq "add" or layout eq "" ) and ( arrayLen( this.data.layout.addLayout.layout ) > 0 ) ) 
            {
                dependencyContainer = resolver.resolveByRequest( namespace:"WDO.catalogs.builders.widgetbuilder.widgetdependencies", hasInit:1 );
                widgetcomponents = resolver.resolveByRequest( namespace:"WDO.catalogs.builders.widgetbuilder.widgetcomponents", hasInit:1 );

                addLayout = this.data.layout.addLayout;
                addLayoutHtml = "";
                for (row in addLayout.layout) {
                    rowwidget = createObject( "component", "WDO.catalogs.builders.widgetbuilder.designgenerators.rowwidget" ).init( row, this.data.domain, "add" );
                    addLayoutHtml = addLayoutHtml & rowwidget.generate() & helper.crlf();
                }

                bodyonload = arrayToList( widgetcomponents.getOnload(), helper.crlf() );
                bodyunload = arrayToList( widgetcomponents.getUnload(), helper.crlf() );
                result.addLayout = bodyonload & helper.crlf() & addLayoutHtml & helper.crlf() & bodyunload;
                this.dependencies.addDependencies = dependencyContainer.getDependencies();

                resolver.destroyInRequest( "WDO.catalogs.builders.widgetbuilder.widgetdependencies" );
                resolver.destroyInRequest( "WDO.catalogs.builders.widgetbuilder.widgetcomponents" );
            }
            else 
            {
                result.addLayout = "";
            }

            if ( ( layout eq "upd" or layout eq "" ) and ( arrayLen( this.data.layout.updLayout.layout ) > 0 ) )
            {
                dependencyContainer = resolver.resolveByRequest( namespace:"WDO.catalogs.builders.widgetbuilder.widgetdependencies", hasInit:1 );
                widgetcomponents = resolver.resolveByRequest( namespace:"WDO.catalogs.builders.widgetbuilder.widgetcomponents", hasInit:1 );

                updateLayout = this.data.layout.updLayout;
                updateLayoutHtml = "";
                for (row in updateLayout.layout)
                {
                    rowwidget = createObject( "component", "WDO.catalogs.builders.widgetbuilder.designgenerators.rowwidget" ).init( row, this.data.domain, "update" );
                    updateLayoutHtml = updateLayoutHtml & rowwidget.generate() & helper.crlf();                 
                }

                bodyonload = arrayToList( widgetcomponents.getOnload(), helper.crlf() );
                bodyunload = arrayToList( widgetcomponents.getUnload(), helper.crlf() );
                result.updateLayout = bodyonload & helper.crlf() & updateLayoutHtml & helper.crlf() & bodyunload;
                this.dependencies.updDependencies = dependencyContainer.getDependencies();

                resolver.destroyInRequest( "WDO.catalogs.builders.widgetbuilder.widgetdependencies" );
                resolver.destroyInRequest( "WDO.catalogs.builders.widgetbuilder.widgetcomponents" );
            }
            else
            {
                result.updateLayout = "";
            }

            if ( ( layout eq "list" or layout eq "" ) and ( arrayLen( this.data.layout.listLayout.layout ) > 0 ) )
            {
                dependencyContainer = resolver.resolveByRequest( namespace:"WDO.catalogs.builders.widgetbuilder.widgetdependencies", hasInit:1 );
                widgetcomponents = resolver.resolveByRequest( namespace:"WDO.catalogs.builders.widgetbuilder.widgetcomponents", hasInit:1 );

                tablewidget = createObject( "component", "WDO.catalogs.builders.widgetbuilder.designgenerators.tablewidget" ).init( this.data.layout, this.data.domain, "list" );
                tableLayoutHtml = tablewidget.generate() & helper.crlf();

                bodyonload = arrayToList( widgetcomponents.getOnload(), helper.crlf() );
                bodyunload = arrayToList( widgetcomponents.getUnload(), helper.crlf() );
                result.tableLayout = bodyonload & helper.crlf() & tableLayoutHtml & helper.crlf() & bodyunload;
                this.dependencies.listDependencies = dependencyContainer.getDependencies();

                resolver.destroyInRequest( "WDO.catalogs.builders.widgetbuilder.widgetdependencies" );
                resolver.destroyInRequest( "WDO.catalogs.builders.widgetbuilder.widgetcomponents" );
            }
            else
            {
                result.tableLayout = "";
            }

            if ( ( layout eq "dashboard" or layout eq "" ) and ( arrayLen( this.data.layout.dashLayout.layout ) > 0 ) ) 
            {
                dependencyContainer = resolver.resolveByRequest( namespace:"WDO.catalogs.builders.widgetbuilder.widgetdependencies", hasInit:1 );
                widgetcomponents = resolver.resolveByRequest( namespace:"WDO.catalogs.builders.widgetbuilder.widgetcomponents", hasInit:1 );

                dashLayout = this.data.layout.dashLayout;
                dashLayoutHtml = "";
                for (row in dashLayout.layout)
                {
                    rowwidget = createObject( "component", "WDO.catalogs.builders.widgetbuilder.designgenerators.rowwidget" ).init( row, this.data.domain, "dashboard" );
                    dashLayoutHtml = rowwidget.generate() & helper.crlf();
                }

                bodyonload = arrayToList( widgetcomponents.getOnload(), helper.crlf() );
                bodyunload = arrayToList( widgetcomponents.getUnload(), helper.crlf() );
                result.dashLayout = bodyonload & helper.crlf() & dashLayoutHtml & helper.crlf() & bodyunload;
                this.dependencies.dashDependencies = dependencyContainer.getDependencies();

                resolver.destroyInRequest( "WDO.catalogs.builders.widgetbuilder.widgetdependencies" );
                resolver.destroyInRequest( "WDO.catalogs.builders.widgetbuilder.widgetcomponents" );
            }
            else
            {
                result.dashLayout = "";
            }

            
        </cfscript>
        <cfreturn result>
    </cffunction>


</cfcomponent>