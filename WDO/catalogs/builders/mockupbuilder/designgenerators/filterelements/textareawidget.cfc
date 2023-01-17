<!---
    File :          filterelements/textareawidget.cfc
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          11.10.2018
    Description :   filtre alanında text area kullanmak için üretici
    Notes :         
--->
<cfcomponent extends="WDO.catalogs.builders.mockupbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            precode = [];

            languagegenerator = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.languagegenerator");
            langcode = '<c' & 'fsavecontent varibale="' & this.data.label &'_lang">' & languagegenerator.generate(this.data.langNo) & '</cfsavecontent>';
            arrayAppend(precode, langcode);

            template = '<c' & 'foutput><textarea name="%s" id="%s" placeholder="##%s##"></textarea></cfoutput>';
            result = super.stringFormat(template, [super.emptyAsNull(this.data.clientName)?:this.data.label, super.emptyAsNull(this.data.clientName)?:this.data.label, this.data.label & '_lang']);
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>