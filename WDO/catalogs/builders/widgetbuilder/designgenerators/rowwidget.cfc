<!---
    File :          rowwidget.cfc
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          10.11.2018
    Description :   Nocode form sayfalarında ki satırları oluşturan widget
    Notes :         
--->
<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.widget">

    <cfproperty name="filters" type="struct">

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            languagegenerator = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.languagegenerator");

            if (len(this.data.rowtitle)) {
                seperator = '<div class="catalyst-seperator"><label onclick="slideBoxToggle(this)"><i class="icon-angle-down"></i>' & languagegenerator.generate(this.data.rowtitle) & '</label></div>' & crlf() & ident() & '<div>' & crlf() & '%s' & crlf() & ident() & '</div>';
            } else {
                seperator = '%s';
            }
            template = '<cf_box_elements>' & crlf() & '%s' & crlf() & '</cf_box_elements>'; 
            if ( this.data.showtitle ) {
                template = super.stringFormat(template, [seperator]);
            }
            result = "";
            colindex = 1;
            for (cols in this.data.listOfCols) {
                if (cols.coltype eq "col")
                {
                    colwidget = getcolwidget(cols);
                    result = result & colwidget.generate(colindex) & crlf();
                }
                else if ( cols.coltype eq "grid" )
                {
                    colwidget = getgridwidget(cols);
                    result = result & colwidget.generate(colindex) & crlf();
                }
                else if ( cols.coltype eq "graph" ) 
                {
                    if ( not isDefined("this.filters") or not isStruct(this.filters) )
                    {
                        this.filters = structNew();
                    }

                    colwidget = getgraphwidget(cols);
                    result = result & colwidget.generate(colindex, function( elm, field ) {
                        if ( structKeyExists(this.filters, elm) ) {
                            return this.filters[elm].clientName;
                        } else {
                            structInsert( this.filters, elm, { clientName: elm & "_" & randRange(10000, 99999), field: field });
                            return this.filters[elm].clientName;
                        }
                    }) & crlf();
                }
                colindex++;
            }

            if (isDefined("this.filters")) {

                filterbuilder = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.graph.filterareabuilder")
                .init(
                    data: this.filters, domain: this.domain, eventtype: this.eventtype, identcount: this.identcount+1, elementgroup: "filterelements"
                );

                result = filterbuilder.generate() & result;

            }

            result = rtrim(result);
            result = super.stringFormat(template, [result]);
        </cfscript>
        <cfreturn result>
    </cffunction>

    <cffunction name="getcolwidget" access="public" returntype="any">
        <cfargument name="cols" type="any">
        <cfreturn createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.colwidget").init( data:arguments.cols, domain:this.domain, identcount:this.identcount + 1, elementgroup:this.elementgroup, eventtype:this.eventtype )>
    </cffunction>

    <cffunction name="getgridwidget" access="public" returntype="any">
        <cfargument name="cols" type="any">
        <cfreturn createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.gridwidget").init( data:arguments.cols, domain:this.domain, identcount:this.identcount + 1, elementgroup:this.elementgroup, eventtype:this.eventtype )>
    </cffunction>

    <cffunction name="getgraphwidget" access="public" returntype="any">
        <cfargument name="cols" type="any">
        <cfreturn createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.graphwidget").init(data:arguments.cols, domain:this.domain, identcount:this.identcount + 1, elementgroup:this.elementgroup, eventtype:this.eventtype )>
    </cffunction>

</cfcomponent>