<!---
    File :          filterelements/textinputwidget.cfc
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          11.10.2018
    Description :   Filtre alanlarında kullanılan text input elementini üretir
    Notes :         
--->
<cfcomponent extends="WDO.catalogs.builders.mockupbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            precode = [];

            //autocomplete
            autocompleteVal = "";
            if ( isDefined( "this.data.autocomplete" ) and len( this.data.autocomplete ) ) {
                autocompleteBuilder = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.methodbuilders.autocomplete");
                autocompleteVal = autocompleteBuilder.generate(this.data, function(any code) {
                    arrayAppend(precode, code);
                });
            }

            languagegenerator = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.languagegenerator");
            langcode = '<c' & 'fsavecontent variable="' & this.data.label &'_lang">' & languagegenerator.generate(this.data.langNo) & '</cfsavecontent>';
            arrayAppend(precode, langcode);

            template = ident() & '<c' & 'foutput><input type="text" name="%s" id="%s" placeholder="##%s##" %s></cfoutput>';
            template = super.stringFormat(template, [super.emptyAsNull(this.data.clientName)?:this.data.label, super.emptyAsNull(this.data.clientName)?:this.data.label, this.data.label & '_lang', autocompleteVal]);

            result = arrayToList(precode, crlf()) & template;
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>