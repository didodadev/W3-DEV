<cfcomponent extends="WDO.catalogs.builders.mockupbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            languagegenerator = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.languagegenerator");

            result = ident() & '<table class="ajax_list" data-formulasummary="true"><tfoot>';
            for (summary in this.data) 
            {
                if (summary.groupby eq "")
                {
                    result = result & crlf() & ident(this.identcount + 1) & "<tr>";
                    result = result & crlf() & ident(this.identcount + 1) & '<td style="width: 250px;">' & languagegenerator.generate( summary.langNo ) & "</td>";
                    result = result & crlf() & ident(this.identcount + 2) & '<td><input type="text" name="' & summary.label & '" id="' & summary.label & '" data-clientformula="' & lcase(summary.type) & '([' & summary.field & '])"></td>';
                    result = result & crlf() & ident(this.identcount + 1) & "</tr>";
                }
                else 
                {
                    result = result & crlf() & ident(this.identcount + 1) & '<tr data-refname="' & summary.label & '_' & summary.groupby & '" data-rowformula="' & lcase(summary.type) & '([' & summary.field & '])" data-rowformulagroupby="' & summary.groupby & '" data-elementlabel="' & languagegenerator.generate( summary.langNo ) & '"></tr>';
                }
            }
            result = result & crlf() & ident() & "</tfoot></table>";
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>