<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>

            template = ident() & '<div class="form-group">';
            template = template & crlf() & ident( this.identcount + 1 ) & '<div class="input-group">';
            template = template & crlf() & '%s';
            template = template & crlf() & ident( this.identcount + 1 ) & '</div>';
            template = template & crlf() & ident() & '</div>';

            inputwidget = createObject( "component", "WDO.catalogs.builders.widgetbuilder.designgenerators.inputfactory" ).create( type:this.data.fieldType, data:this.data, domain:this.domain, ident:this.identcount + 2, group:"filterelements" );
            input = inputwidget.generate();

            result = super.stringFormat( template, [ input ] );
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>