<!---
    File :          filterelements/checkboxwidget.cfc
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          11.10.2018
    Description :   filtre alanında checkbox kullanmak için üretici
    Notes :         
--->
<cfcomponent extends="WDO.catalogs.builders.mockupbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            languagegenerator = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.languagegenerator");
            
            //template
            template = "<c" & 'foutput><input type="checkbox" name="%s" id="%s" value="1" %s>' & languagegenerator.generate('%s') & '</cfoutput>';
            result = super.stringFormat(template, [super.emptyAsNull(element.clientName)?:element.label, super.emptyAsNull(element.clientName)?:element.label, preattr, element.langNo]);
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>