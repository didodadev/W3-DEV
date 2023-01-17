<cfcomponent extends="WDO.catalogs.builders.mockupbuilder.mockup">

    <cffunction name="generate" access="public" returntype="string">
        
        <cfscript>

            stck = this.domain[ arrayFind( this.domain, function(elm) {
                return elm.name eq this.data.struct;
            })];
            element = stck.listOfElements[ arrayFind( stck.listOfElements, function(elm) {
                return elm.label eq this.data.label;
            })];

            //set the dependencies
            //getWidgetDependencyManager().addDependency( dependStruct: this.data.struct, dependEvent: this.eventtype );

            //data formatter
            dataformatter = createObject( "component", "WDO.catalogs.builders.mockupbuilder.designgenerators.formatters.dataformatter" );
            
            //template
            result = "<c" & 'f_workcube_process select_value="##iif(isDefined("' & this.data.struct & '_query"), "' & dataformatter.format( this.data.struct & '_query.' & this.data.label, element ) & '", DE(""))##" is_upd="0" is_detail="##(attributes.event eq "add")?0:1##">';

        </cfscript>
        
        <cfreturn result>
    </cffunction>

</cfcomponent>