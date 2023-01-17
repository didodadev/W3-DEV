<!---
    File :          filterelements/multiselectwidget.cfc
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          11.10.2019
    Description :   filtre alanında multiselect kullanmak için üretici
    Notes :         
--->
<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            precode = [];
            
            if (this.data.method.value neq "")
            {
                methodgen = createObject("component", "WDO.catalogs.builders.componentbuilders.codegenerators.codegenerator").createGenerator(this.data.method.type);
                methodcode = methodgen.generate(this.data.method, this.data.label & "_method_");
                arrayAppend(precode, methodcode);
            }

            //template
            template = '<cf_multiselect_check query_name="' & this.data.label & '_method_' & this.data.method.name & '" option_text="##getLang(''main'',''' & this.data.langNo & ''')##" name="' & super.emptyAsNull(this.data.clientName)?:this.data.label & '" width="180" option_name="listGetAt(' & this.data.label & '_method_' & this.data.method.name & '.columnlist, 1)" option_value="listGetAt(' & this.data.label & '_method_' & this.data.method.name & '.columnlist, 2)">';

            precodeList = arrayToList(listToArray(arrayToList(precode, crlf()), crlf()), crlf() & ident());
    
            result = iif(len(precodeList), DE(precodeList & crlf() & ident()), DE(ident())) & template;

        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>