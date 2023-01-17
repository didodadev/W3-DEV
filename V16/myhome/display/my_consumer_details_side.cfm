<cfif ((isdefined('document') and document eq 1) or not isdefined('document')) or ((isdefined('analysis') and analysis eq 1) or not isdefined('analysis')) or ((isdefined('extranet_internet') and extranet_internet eq 1) or not isdefined('extranet_internet'))>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <!--- Varliklar --->
        <cfif (isdefined('document') and document eq 1) or not isdefined('document')>
            <cf_get_workcube_asset asset_cat_id="-9" module_id='4' action_section='CONSUMER_ID' action_id='#attributes.cid#'>
        </cfif>
    </div>

    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <!--- Analizler --->
        <cfif (isdefined('analysis') and analysis eq 1) or not isdefined('analysis')>
            <cfinclude template="../../member/display/consumer_analysis.cfm">
        </cfif>
    </div>

    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cf_get_workcube_domain action_type='CONSUMER' action_id='#attributes.cid#'>
    </div>
</cfif>
