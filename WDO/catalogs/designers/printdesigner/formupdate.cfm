<cfparam name="attributes.id" default="">

<cfinclude template="model.cfm">

<cfif len( attributes.id ) and attributes.id gt 0>

    <cfscript>
        query_args = {
            PRINTID: attributes.id,
            PRINT_HEAD: attributes.print_head,
            PRINT_FUSEACTION: attributes.related_wo,
            PRINT_SYSNAME: replace( lCase( listlast( attributes.print_head, "." ) ), " ", "_" ),
            PRINT_SOLUTION: attributes.solution,
            PRINT_SOLUTIONID: attributes.solutionid,
            PRINT_FAMILY: attributes.family,
            PRINT_FAMILYID: attributes.familyid,
            PRINT_MODULE: attributes.module,
            PRINT_MODULEID: attributes.moduleid,
            STATUS: 1,
            PRINT_DESCRIPTION: attributes.description
        };
        updatePrint( argumentcollection = query_args );
    </cfscript>

<cfelse>

    <cfscript>
        query_args = {
            PRINT_HEAD: attributes.print_head,
            PRINT_FUSEACTION: attributes.related_wo,
            PRINT_SYSNAME: replace( lCase( listlast( attributes.print_head, "." ) ), " ", "_" ),
            PRINT_SOLUTION: attributes.solution,
            PRINT_SOLUTIONID: attributes.solutionid,
            PRINT_FAMILY: attributes.family,
            PRINT_FAMILYID: attributes.familyid,
            PRINT_MODULE: attributes.module,
            PRINT_MODULEID: attributes.moduleid,
            STATUS: 1,
            PRINT_DESCRIPTION: attributes.description
        };
        attributes.id = insertPrint( argumentcollection = query_args );
    </cfscript>

</cfif>
1