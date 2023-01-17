<!---
    File :          filterareabuilder.cfc
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          02.09.2019
    Description :   Grafikler için filtre alanı oluşturur
    Notes :         
--->
<cfcomponent extends="WDO.catalogs.builders.mockupbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            if (not arrayLen( structKeyArray( this.data ) ) ) return;

            template = crlf() & ident() & '<div class="form-horizontal">' & crlf() & ident(this.identcount + 1) & '<form action="" method="post">' & crlf() & ident(this.identcount + 2) & '%s' crlf() & ident(this.identcount + 1) & '</form>' & crlf() & ident() & '<hr>' & crlf() & ident() & '</div>' & crlf() & ident();
            result = "";
            for ( fkey in structKeyArray( this.data ) ) {
                element = structCopy(this.data[fkey].field);
                element.clientName = this.data[fkey].clientName;

                fgwidget = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.graph.formgroupwidget").init( data: element, domain: this.domain, identcount: this.identcount + 1, elementgroup: this.elementgroup, eventtype: this.eventtype );
                result = result & fgwidget.generate() & crlf();
            }
            result = result & '<button type="button" onclick="eval($(this).closest(' & "'.portBox[data-reload]'" & ").data('reload')).call(null, $(this).closest('form').serialize()" & ')">Ara</button>';
            result = super.stringFormat(template, [result]);
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>