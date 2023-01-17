<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.designgenerators.formgroupwidget">


    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            stck = this.domain[arrayFind(this.domain, function(elm) {
                return elm.name eq this.data.struct;
            })];
            element = stck.listOfElements[arrayFind(stck.listOfElements, function(elm) {
                return elm.label eq this.data.label;
            })];
            result = generatesearchelements(element, stck);
        </cfscript>
        <cfreturn result>
    </cffunction>

    <cffunction name="generatesearchelements" access="public" returntype="string">
        <cfargument name="element" type="any">
        <cfargument name="domainStruct" type="any">

        <cfscript>
            if ( arguments.element.fieldType eq "hidden input" or arguments.element.fieldType eq "button" )
            {
                result = super.generateelements( arguments.element, arguments.domainStruct );
            }
            else 
            {
                displayForGenerator = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.properties.displayfor");

                template = ident(this.identcount - 1) & "<c" & 'fif 1 eq 1 ' & displayForGenerator.generate( element, domainStruct, this.eventtype ) & '>';
                template = template & crlf() & ident() & '<div style="form-group" id="item-%s">' & crlf() & ident( this.identcount + 1 ) & '%s' & crlf() & ident( this.identcount - 1 ) & '</div>';

                inputwidget = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.inputfactory").create( type:element.fieldType, data:this.data, domain:this.domain, ident:this.identcount + 1, group:this.elementgroup, eventtype:this.eventtype );
                
                if (isDefined("arguments.element.filterAsRange") && arguments.element.filterAsRange eq 1) 
                {
                    input = '<div class="col col-6">' & inputwidget.generate("_min") & '</div>';
                    input = input & '<div class="col col-6">' & inputwidget.generate("_max") & '</div>';
                }
                else 
                {
                    input = inputwidget.generate();
                }

                template = super.stringFormat(template, [this.data.label, input]);

                template = template & crlf() & ident() & "<c" & 'felse>';

                inputwidget = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.inputfactory").create( type:'hidden input', data:this.data, domain:this.domain, ident:this.identcount + 1, group:this.elementgroup, eventtype:this.eventtype );
                template = template & crlf() & ident() & inputwidget.generate();
                template = template & crlf() & ident() & "</c" & 'fif>';

                result = template;

            }
        </cfscript>
        <cfreturn result>
    </cffunction>


</cfcomponent>