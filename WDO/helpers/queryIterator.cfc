<cfcomponent>
    <cfproperty name="query" type="query">
    <cfproperty name="current" type="number">
    <cfproperty name="recordcount" type="number">
    <cfproperty name="columns" type="array">

    <cffunction name="init" access="public" returntype="any">
        <cfargument name="query" type="query">
        <cfset this.query=arguments.query>
        <cfset this.recordcount=arguments.query.recordcount>
        <cfset this.columns=this.query.getMeta().getColumnLabels()>
        <cfset this.current=1>
        <cfreturn this>
    </cffunction>

    <cffunction name="Get" access="public" returntype="any">
        <cfargument name="field" type="any">
        <cfscript>
            if (isNumeric(field)) {
                return this.query[this.columns[arguments.field]][this.current];
            } else {
                return this.query[arguments.field][this.current];
            }
        </cfscript>
    </cffunction>

    <cffunction name="GetRow" access="public" returntype="struct">
        <cfscript>
            row = {};
            for (col in this.columns) {
                row[col] = this.query[col][this.current];
            }
        </cfscript>
        <cfreturn row>
    </cffunction>

    <cffunction name="GetRowArray" access="public" returntype="array">
        <cfscript>
            row = [];
            for (col in this.columns)
            {
                row[arrayFind(this.columns, col)] = this.query[col][this.current];
            }
        </cfscript>
        <cfreturn row>
    </cffunction>

    <cffunction name="hasIter" access="public" returntype="boolean">
        <cfscript>
            return this.current <= this.recordcount;
        </cfscript>
    </cffunction>

    <cffunction name="Next" access="public" returntype="any">
        <cfscript>
            if (this.hasIter())
            {
                this.current++;
            }
        </cfscript>
    </cffunction>

    <cffunction name="Prev" access="public" returntype="any">
        <cfscript>
            if (this.current > 1)
            {
                this.current--;
            }
        </cfscript>
    </cffunction>

    <cffunction name="First" access="public" returntype="any">
        <cfscript>
            this.current = 1;
        </cfscript>
    </cffunction>

    <cffunction name="Last" access="public" returntype="any">
        <cfscript>
            this.current = this.recordcount;
        </cfscript>
    </cffunction>

</cfcomponent>