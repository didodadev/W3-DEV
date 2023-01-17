<cfset session_base = session_base?:session.ep />
<script>
    
    let xml = {
        use_basket_project_discount_: <cfoutput>#isdefined('use_basket_project_discount_') ? use_basket_project_discount_ : 0#</cfoutput>
    };
    let sessionVariable = {
        is_lot_no : <cfoutput>#session_base.our_company_info.is_lot_no eq 1 ? 1 : 0#</cfoutput>,
        isBranchAuthorization : <cfoutput>#session_base.isBranchAuthorization eq 1 ? 1 : 0#</cfoutput>,
        user_location: <cfoutput>#session_base.user_location#</cfoutput>
    };

    let dsn = {
        dsn3_alias : "<cfoutput>#dsn3_alias#</cfoutput>",
        dsn_alias : "<cfoutput>#dsn_alias#</cfoutput>"
    };

    let event = {
        nextEvent : "<cfoutput>#isdefined("nextEvent") ? nextEvent : ''#</cfoutput>",
        queryPath : "<cfoutput>#isdefined("queryPath") ? queryPath : ''#</cfoutput>",
        event : "<cfoutput>#attributes.event#</cfoutput>",
        woStruct : "<cfoutput>#isdefined("WOStruct") and isStruct(WOStruct) ? 1 : 0 #</cfoutput>",
        extendControllerFileName : "<cfoutput>#isDefined("WOStruct") and structKeyExists(WOStruct['#attributes.fuseaction#'],'extendedForm') ? WOStruct["#attributes.fuseaction#"]["extendedForm"]["controllerFileName"] : ''#</cfoutput>"
    }

</script>