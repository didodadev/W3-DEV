<!---
    File :          formgroupwidget.cfc
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          05.09.2019
    Description :   Grafiklerin filtreleri için form-group ekler
    Notes :         Bu dosya filterareabuilder.cfc tarafından çağrılır ve sadece filter area için uygundur
--->
<cfcomponent extends="WDO.catalogs.builders.mockupbuilder.widget">

    <!--- Form group için kod üretir --->
    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            stck = this.domain[arrayFind(this.domain, function(elm) {
                return elm.name eq this.data.struct;
            })];
            element = stck.listOfElements[arrayFind(stck.listOfElements, function(elm) {
                return elm.label eq this.data.label;
            })];

            if ( element.fieldType eq "hidden input" ) {
                inputwidget = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.inputfactory").create( type:element.fieldType, data:this.data, domain:this.domain, ident:this.identcount + 1, eventtype:this.eventtype );
                result = inputwidget.generate();
            }
            else if ( element.fieldType eq "button" ) 
            {
                result = "";
            }
            else 
            {
                template = ident() & '<div class="form-group"><div class="input-group x-10">' & crlf() & ident(this.identcount + 1) & '%s' & crlf() & ident() & '</div></div>';

                inputwidget = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.inputfactory").create( type:element.fieldType, data:this.data, domain:this.domain, ident:this.identcount + 1, group:this.elementgroup, eventtype:this.eventtype );

                input = inputwidget.generate();

                result = stringFormat( template, [input] );
            }
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>