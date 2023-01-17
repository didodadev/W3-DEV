<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.widget">

    <cffunction name="generate">
        <cfscript>
            if (this.data.cachetime eq 0) 
            {
                return "";
            }
            else 
            {
                return '<c' & 'fcache action="optimal" timespan="##createtimespan(0,0,' & this.data.cachetime & ',0)##">' & crlf() & '%s' & crlf() & '</cfcache>';
            }
        </cfscript>
    </cffunction>

</cfcomponent>