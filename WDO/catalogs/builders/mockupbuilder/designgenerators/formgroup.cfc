<cfcomponent extends="WDO.catalogs.builders.mockupbuilder.mockup">

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            stck = this.domain[arrayFind(this.domain, function(elm) {
                return elm.name eq this.data.struct;
            })];
            element = stck.listOfElements[arrayFind(stck.listOfElements, function(elm) {
                return elm.label eq this.data.label;
            })];

            result = generateelements(element, stck);
        </cfscript>
        <cfreturn result>
    </cffunction>

    <cffunction name="generateelements" access="public" returntype="string">
        <cfargument name="element" type="any">
        <cfargument name="domainStruct" type="any">
        <cfscript>
            if (arguments.element.fieldType eq "hidden input")
            {
                inputfactory = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.inputfactory").create( type:element.fieldType, data:this.data, domain:this.domain, ident:this.identcount + 1, group:this.elementgroup, eventtype:this.eventtype );
                result = inputfactory.generate();
            }
            else if (arguments.element.fieldType eq "button")
            {
                template = ident(this.identcount - 1) & '<div class="form-group">' & crlf() & ident() & '<div class="col col-12">' & crlf() & ident(this.identcount + 1) & "%s" & crlf() & ident() & '</div>' & crlf() & ident(this.identcount - 1) & '</div>';
                languagegenerator = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.languagegenerator");
                lang = languagegenerator.generate(arguments.element.langNo);
                buttonwidget = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.formelements.button").init( this.data, this.domain, this.eventtype, this.identcount + 1 );
                button = super.stringFormat(buttonwidget.generate(), [lang]);
                result = super.stringFormat(template, [button]);
            }
            else
            {
                displayForGenerator = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.properties.displayfor");

                template = ident(this.identcount - 1) & "<c" & 'fif 1 eq 1 ' & displayForGenerator.generate( element, domainStruct, this.eventtype ) & '>';

                template = template & crlf() & ident(this.identcount - 1) & '<div class="form-group" id="item-%s">' & crlf() & ident() & '<label class="col col-4 col-xs-12">%s%s</label>' & crlf() & ident() & '<div class="col col-8 col-xs-12">' & crlf() & ident(this.identcount + 1) & '%s' & crlf() & ident() & '</div>' & crlf() & ident(this.identcount - 1) & '</div>';
                
                if (isDefined("arguments.element.isRequired"))
                {
                    reqiredFieldSign = iif(arguments.element.isRequired eq "1", DE("*"), DE(""));
                }
                else
                {
                    reqiredFieldSign = "";
                }
                languagegenerator = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.languagegenerator");
                lang = languagegenerator.generate(arguments.element.langNo);
                inputfactory = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.inputfactory").create( type:element.fieldType, data:this.data, domain:this.domain, ident:this.identcount + 1, group:this.elementgroup, eventtype:this.eventtype );
                input = inputfactory.generate();

                template = super.stringFormat(template, [this.data.label, lang, reqiredFieldSign, input]);

                template = template & crlf() & ident() & "<c" & 'felse>';

                inputfactory = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.inputfactory").create( type:'hidden input', data:this.data, domain:this.domain, ident:this.identcount + 1, group:this.elementgroup, eventtype:this.eventtype );
                template = template & crlf() & ident() & inputfactory.generate();
                template = template & crlf() & ident() & "</c" & 'fif>';

                result = template;
            }
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>