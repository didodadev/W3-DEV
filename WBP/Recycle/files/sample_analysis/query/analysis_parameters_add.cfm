<cfset analysis_parameters = createObject("component","WBP/Recycle/files/sample_analysis/cfc/analysis_parameters") />

<cfif attributes.parameterType eq 'unit'>
    <cfif attributes.unit_count gt 0>
        <cfloop index="i" from="1" to="#attributes.unit_count#">
            <cfif isDefined("attributes.unitId#i#")>
                <cfset analysis_parameters.saveUnit(
                    unitId: evaluate("attributes.unitId#i#"),
                    unitName: evaluate("attributes.unitName#i#"),
                    unitStatus: isDefined("attributes.unitStatus#i#") ? 1 : 0,
                    unitDeleted: evaluate("attributes.unitDeleted#i#")
                ) />
            </cfif>
        </cfloop>
    </cfif>
<cfelseif attributes.parameterType eq 'group'>
    <cfif attributes.group_count gt 0>
        <cfloop index="i" from="1" to="#attributes.group_count#">
            <cfif isDefined("attributes.groupId#i#")>
                <cfset analysis_parameters.saveGroup(
                    groupId: evaluate("attributes.groupId#i#"),
                    groupName: evaluate("attributes.groupName#i#"),
                    groupStatus: isDefined("attributes.groupStatus#i#") ? 1 : 0,
                    groupDeleted: evaluate("attributes.groupDeleted#i#")
                ) />
                <cfif evaluate("attributes.groupDeleted#i#") eq 1>
                    <cfset analysis_parameters.delParameter( groupId: evaluate("attributes.groupId#i#") ) />
                </cfif>
                <cfif evaluate("attributes.groupDeleted#i#") eq 1>
                    <cfset analysis_parameters.delMethod( groupId: evaluate("attributes.groupId#i#") ) />
                </cfif>
            </cfif>
        </cfloop>
    </cfif>
<cfelseif attributes.parameterType eq 'parameter'>
    <cfif attributes.parameter_count gt 0>
        <cfloop index="i" from="1" to="#attributes.parameter_count#">
            <cfif isDefined("attributes.parameterId#i#")>
                <cfset analysis_parameters.saveParameter(
                    parameterId: evaluate("attributes.parameterId#i#"),
                    groupId: evaluate("attributes.groupId#i#"),
                    parameterName: evaluate("attributes.parameterName#i#"),
                    minLimit: evaluate("attributes.minLimit#i#"),
                    maxLimit: evaluate("attributes.maxLimit#i#"),
                    parameterStatus: isDefined("attributes.parameterStatus#i#") ? 1 : 0,
                    parameterDeleted: evaluate("attributes.parameterDeleted#i#")
                ) />
            </cfif>
        </cfloop>
    </cfif>
<cfelseif attributes.parameterType eq 'method'>
    <cfif attributes.method_count gt 0>
        <cfloop index="i" from="1" to="#attributes.method_count#">
            <cfif isDefined("attributes.methodId#i#")>
                <cfset analysis_parameters.saveMethod(
                    methodId: evaluate("attributes.methodId#i#"),
                    groupId: evaluate("attributes.groupId#i#"),
                    parameterId: evaluate("attributes.parameterId#i#"),
                    methodName: evaluate("attributes.methodName#i#"),
                    methodStatus: isDefined("attributes.methodStatus#i#") ? 1 : 0,
                    methodDeleted: evaluate("attributes.methodDeleted#i#")
                ) />
            </cfif>
        </cfloop>
    </cfif>
<cfelseif attributes.parameterType eq 'analyzeCat'>
    <cfif attributes.analyzeCat_count gt 0>
        <cfloop index="i" from="1" to="#attributes.analyzeCat_count#">
            <cfif isDefined("attributes.analyzeCatId#i#")>
                <cfset analysis_parameters.saveAnalyzeCat(
                    analyzeCatId: evaluate("attributes.analyzeCatId#i#"),
                    analyzeCatName: evaluate("attributes.analyzeCatName#i#"),
                    analyzeCatStatus: isDefined("attributes.analyzeCatStatus#i#") ? 1 : 0,
                    analyzeCatDeleted: evaluate("attributes.analyzeCatDeleted#i#")
                ) />
            </cfif>
        </cfloop>
    </cfif>
</cfif>

<script>location.reload();</script>