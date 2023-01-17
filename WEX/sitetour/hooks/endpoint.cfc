<cfcomponent>

    <cffunction name="insert" access="public">
        <cfargument name="data">

        <cfif isDefined("arguments.data.help_fuseaction") and len(arguments.data.help_fuseaction)>
            <cfobject type="component" name="datalayer" component="WEX.sitetour.components.data">
            <cfset datalayer.insert(arguments.data.help_fuseaction, arguments.data.help_head, arguments.data.help_topic, arguments.data.recorder_name, arguments.data.recorder_name, arguments.data.recorder_email, arguments.data.is_news)>
            <cfreturn "Ok">
        </cfif>
        <cfreturn "No">

    </cffunction>

    <cffunction name="update" access="public">
        <cfargument name="data">
        <cfif isDefined("arguments.data.help_id") and len(arguments.data.help_id)>
            <cfobject type="component" name="datalayer" component="WEX.sitetour.components.data">
            <cfset datalayer.update(arguments.data.help_fuseaction,arguments.data.help_id, arguments.data.help_head, arguments.data.help_topic, arguments.data.is_new)>
            <cfreturn "Ok">
        </cfif>
        <cfreturn "No">

    </cffunction>
    
    <cffunction name="delete" access="public">
        <cfargument name="data">
      
        <cfif isDefined("arguments.data.help_id") and len(arguments.data.help_id)>
            <cfobject type="component" name="datalayer" component="WEX.sitetour.components.data">
            <cfset datalayer.delete(arguments.data.help_id)>
            <cfreturn "Ok">
        </cfif>
        <cfreturn "No">

    </cffunction>


    <cffunction name="getlist" access="public">
        <cfargument name="data">
        
        <cfif isDefined("arguments.data.help_fuseaction") and len(arguments.data.help_fuseaction)>
            <cfobject type="component" name="datalayer" component="WEX.sitetour.components.data">
            <cfset query_list = datalayer.getlist(arguments.data.help_fuseaction)>
            <cfif query_list.recordcount>
                <cfset result = arrayNew(1)>
                <cfloop from="1" to="#query_list.recordcount#" index="i">
                    <cfset arrayAppend(result, queryGetRow(query_list, i))>
                </cfloop>
                <cfreturn replace(serializeJSON(result), "//", "")>
            <cfelse>
                <cfreturn "[]">
            </cfif>
            <cfreturn "[]">
        </cfif>
    </cffunction>

    <cffunction name="getlists" access="public">
        <cfargument name="data">
        
            <cfobject type="component" name="datalayer" component="WEX.sitetour.components.data">
            <cfset query_list = datalayer.getlists(arguments.data.help_fuseaction, arguments.data.keyword, arguments.data.news, arguments.data.startrow, arguments.data.maxrows)>
            <cfif query_list.recordcount>
                <cfset result = arrayNew(1)>
                <cfloop from="1" to="#query_list.recordcount#" index="i">
                    <cfset arrayAppend(result, queryGetRow(query_list, i))>
                </cfloop>
                <cfreturn replace(serializeJSON(result), "//", "")>
            <cfelse>
                <cfreturn "[]">
            </cfif>
            <cfreturn "[]">
    </cffunction>

    <cffunction name="getitem" access="public">
        <cfargument name="data">

        <cfif isDefined("arguments.data.help_id") and len(arguments.data.help_id)>
            <cfobject type="component" name="datalayer" component="WEX.sitetour.components.data">
            <cfset query_item = datalayer.getitem(arguments.data.help_id)>
            <cfif query_item.recordcount>
                <cfreturn replace(serializeJSON(queryGetRow(query_item, 1)), "//", "")>
            <cfelse>
                <cfreturn "">
            </cfif>
        <cfelse>
            <cfreturn "">
        </cfif>
    </cffunction>

</cfcomponent>