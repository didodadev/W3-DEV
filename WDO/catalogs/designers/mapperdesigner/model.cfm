
<cffunction name="getstruct">
    <cfargument name="fuseaction">
    <cfargument name="structname">
    <cfquery name="querysource" datasource="#dsn#">
        SELECT MODELJSON FROM WRK_MODEL WHERE MODEL_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fuseaction#'>
    </cfquery>
    <cfset model = deserializeJSON( querysource.MODELJSON )>
    <cfset structd = arrayFilter( model, function( st ) { return st.name eq structname; } )[1]>
    <cfreturn structd.listOfElements>
</cffunction>

<cffunction name="getStructNames">
    <cfargument name="fuseaction">
    <cfquery name="querysource" datasource="#dsn#">
        SELECT MODELJSON FROM WRK_MODEL WHERE MODEL_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fuseaction#'>
    </cfquery>
    <cfset model = deserializeJSON( querysource.MODELJSON )>
    <cfset structlist = arrayMap( model, function( elm ) { return elm.name } )>
    <cfreturn structlist>
</cffunction>