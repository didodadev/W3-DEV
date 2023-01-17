<cfcomponent extends="WDO.catalogs.builders.mockupbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        
        <cfscript>

            stck = this.domain[ arrayFind( this.domain, function(elm) {
                return elm.name eq this.data.struct;
            })];
            element = stck.listOfElements[ arrayFind( stck.listOfElements, function(elm) {
                return elm.label eq this.data.label;
            })];

            //set the dependencies
            getWidgetDependencyManager().addDependency( dependStruct: this.data.struct, dependEvent: this.eventtype );

            //data formatter
            dataformatter = createObject( "component", "WDO.catalogs.builders.mockupbuilder.designgenerators.formatters.dataformatter" );

            languagegenerator = createObject( "component", "WDO.catalogs.builders.mockupbuilder.designgenerators.languagegenerator" );
            lang = languagegenerator.generate( element.langNo );
            
            //template
            template = '<d' & 'iv class="col col-12">' & lang & '</div>' & crlf();
            template = template & ident() & '<d' & 'iv class="col col-12">' & crlf();
            template = template & ident() & "<c" & 'f_workcube_process select_value="##iif(isDefined("attributes.process_stage"), "attributes.process_stage" , DE(""))##" is_upd="0" is_detail="0">' & crlf();
            template = template & ident() & '</div>' & crlf();

            result = template;

        </cfscript>
        
        <cfreturn result>
    </cffunction>

</cfcomponent>