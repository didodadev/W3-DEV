<cfcomponent>
    <cfproperty name="data" type="any">
    
    <cffunction name="init" access="public" returntype="any">
        <cfargument name="data" type="any">
        <cfset this.data = arguments.data>
        <cfreturn this>
    </cffunction>

    <cffunction name="generate" access="public" returntype="any">
        <cfargument name="layout" type="string" default="">
        <cfscript>
            result = {};
            helper = createObject( "component", "WDO.catalogs.builders.mockupbuilder.helper" );
            if ( ( layout eq "add" or layout eq "" ) and ( arrayLen( this.data.layout.addLayout.layout ) > 0 ) ) 
            {

                addLayout = this.data.layout.addLayout;
                addLayoutHtml = "";
                for (row in addLayout.layout) {
                    rowMethod = createObject( "component", "WDO.catalogs.builders.mockupbuilder.designgenerators.row" ).init( row, this.data.domain, "add" );
                    addLayoutHtml = addLayoutHtml & rowMethod.generate();
                }

                result.addLayout = addLayoutHtml;

            }
            else 
            {
                result.addLayout = "";
            }

            if ( ( layout eq "info" or layout eq "" ) and ( arrayLen( this.data.layout.infoLayout.layout ) > 0 ) )
            {
               
                infoLayout = this.data.layout.infoLayout;
                infoLayoutHtml = "";
                for (row in infoLayout.layout)
                {
                    rowMethod = createObject( "component", "WDO.catalogs.builders.mockupbuilder.designgenerators.row" ).init( row, this.data.domain, "update" );
                    infoLayoutHtml = infoLayoutHtml & rowMethod.generate();                 
                }

                result.infoLayout = infoLayoutHtml;

            }
            else
            {
                result.infoLayout = "";
            }

            if ( ( layout eq "upd" or layout eq "" ) and ( arrayLen( this.data.layout.updLayout.layout ) > 0 ) )
            {
               
                updateLayout = this.data.layout.updLayout;
                updateLayoutHtml = "";
                for (row in updateLayout.layout)
                {
                    rowMethod = createObject( "component", "WDO.catalogs.builders.mockupbuilder.designgenerators.row" ).init( row, this.data.domain, "update" );
                    updateLayoutHtml = updateLayoutHtml & rowMethod.generate();                 
                }

                result.updateLayout = updateLayoutHtml;

            }
            else
            {
                result.updateLayout = "";
            }

            if ( ( layout eq "list" or layout eq "" ) and ( arrayLen( this.data.layout.listLayout.layout ) > 0 ) )
            {
                
                tableMethod = createObject( "component", "WDO.catalogs.builders.mockupbuilder.designgenerators.table" ).init( this.data.layout, this.data.domain, "list" );
                tableLayoutHtml = tableMethod.generate();

                result.tableLayout = tableLayoutHtml;

            }
            else
            {
                result.tableLayout = "";
            }

            if ( ( layout eq "dashboard" or layout eq "" ) and ( arrayLen( this.data.layout.dashLayout.layout ) > 0 ) ) 
            {
                
                dashLayout = this.data.layout.dashLayout;
                dashLayoutHtml = "";
                for (row in dashLayout.layout)
                {
                    rowMethod = createObject( "component", "WDO.catalogs.builders.mockupbuilder.designgenerators.row" ).init( row, this.data.domain, "dashboard" );
                    dashLayoutHtml = dashLayoutHtml & rowMethod.generate();
                }

                result.dashLayout = dashLayoutHtml;

            }
            else
            {
                result.dashLayout = "";
            }

            
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>