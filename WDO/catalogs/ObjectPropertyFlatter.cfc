<!---
    File :          ObjectFlatter.cfc
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          08.10.2019
    Description :   Flatten object with dot notation
    Notes :         
--->
<cfcomponent>
    
    <cffunction name="flatten" access="public" returntype="array">
        <cfargument name="data" type="any">
        <cfargument name="flattenArray" type="array" default="#arrayNew(1)#">
        <cfargument name="parentName" type="string" default="">

        <cfset arguments.flattenArray = flattenFactory( arguments.data, arguments.flattenArray, arguments.parentName )>
        
        <cfreturn arguments.flattenArray>
    </cffunction>

    <cffunction name="flattenFactory" access="public" returntype="array">
        <cfargument name="data" type="any">
        <cfargument name="flattenArray" type="array">
        <cfargument name="parentName" type="string">

        <cfif isStruct( arguments.data )>
            <cfreturn this.flattenStruct( arguments.data, arguments.flattenArray, arguments.parentName )>
        </cfif>
        <cfif isArray( arguments.data )>
            <cfreturn this.flattenArray( arguments.data, arguments.flattenArray, arguments.parentName )>
        </cfif>

        <cfreturn arguments.flattenArray>
    </cffunction>

    <cffunction name="flattenStruct" access="public" returntype="array">
        <cfargument name="data" type="struct">
        <cfargument name="flattenArray" type="array">
        <cfargument name="parentName" type="string">

        <cfif arrayContains( arguments.flattenArray, arguments.parentName )>
            <cfset arrayDelete( arguments.flattenArray, arguments.parentName )>
        </cfif>

        <cfloop collection="#arguments.data#" item="attr">
            <cfset elementName = ( len( arguments.parentName ) ? arguments.parentName & "." : "" ) & attr>
            <cfset arrayAppend( arguments.flattenArray, elementName )>
            <cfset arguments.flattenArray = flattenFactory( arguments.data[attr], arguments.flattenArray, elementName )>
        </cfloop>

        <cfreturn arguments.flattenArray>
    </cffunction>

    <cffunction name="flattenArray" access="public" returntype="array">
        <cfargument name="data" type="array">
        <cfargument name="flattenArray" type="array">
        <cfargument name="parentName" type="string">

        <cfloop array="#arguments.data#" index="i" item="attr">
            <cfset elementName = ( len( arguments.parentName ) ? arguments.parentName : "" ) & "[" & i & "]">
            <cfset arrayAppend( arguments.flattenArray, elementName )>
            <cfset arguments.flattenArray = flattenFactory( attr, arguments.flattenArray, elementName )>
        </cfloop>

        <cfreturn arguments.flattenArray>
    </cffunction>

</cfcomponent>