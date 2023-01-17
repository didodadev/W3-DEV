<!---
    File :          row.cfc
    Author :        Halit Yurttaş <halityurttas@gmail.com>,Uğur Hamurpet <ugurhamurpet@workcube.com>
    Date :          21.10.2020
    Description :   Mockup create row component
--->
<cfcomponent extends="WDO.catalogs.builders.mockupbuilder.mockup">

    <cfproperty name="filters" type="struct">

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            languagegenerator = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.languagegenerator");

            if (len(this.data.rowtitle)) {
                seperator = '<div class="catalyst-seperator"><label onclick="slideBoxToggle(this)"><i class="icon-angle-down"></i>' & languagegenerator.generate(this.data.rowtitle) & '</label></div>' & crlf() & ident() & '<div>' & crlf() & '%s' & crlf() & ident() & '</div>';
            } else {
                seperator = '%s';
            }
            template = '<cf_box_elements>' & crlf() & '%s' & crlf() & ident() & '</cf_box_elements>'; 
            if ( this.data.showtitle ) {
                template = super.stringFormat(template, [seperator]);
            }
            result = "";
            colindex = 1;
            for (cols in this.data.listOfCols) {
                if (cols.coltype eq "col")
                {
                    col = getcol(cols);
                    result = result & col.generate(colindex) & crlf();
                }
                else if ( cols.coltype eq "grid" )
                {
                    col = getgrid(cols);
                    result = result & col.generate(colindex) & crlf();
                }
                else if ( cols.coltype eq "graph" ) 
                {
                    col = getgraph(cols);
                    result = result & col.generate(colindex) & crlf();
                }
                colindex++;
            }

            result = rtrim(result);
            result = super.stringFormat(template, [result]);
        </cfscript>
        <cfreturn result>
    </cffunction>

    <cffunction name="getcol" access="public" returntype="any">
        <cfargument name="cols" type="any">
        <cfreturn createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.col").init( data:arguments.cols, domain:this.domain, identcount:this.identcount + 1, elementgroup:this.elementgroup, eventtype:this.eventtype, emp_url: this.emp_url )>
    </cffunction>

    <cffunction name="getgrid" access="public" returntype="any">
        <cfargument name="cols" type="any">
        <cfreturn createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.grid").init( data:arguments.cols, domain:this.domain, identcount:this.identcount + 1, elementgroup:this.elementgroup, eventtype:this.eventtype, emp_url: this.emp_url )>
    </cffunction>

    <cffunction name="getgraph" access="public" returntype="any">
        <cfargument name="cols" type="any">
        <cfreturn createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.graph").init(data:arguments.cols, domain:this.domain, identcount:this.identcount + 1, elementgroup:this.elementgroup, eventtype:this.eventtype, emp_url: this.emp_url )>
    </cffunction>

</cfcomponent>