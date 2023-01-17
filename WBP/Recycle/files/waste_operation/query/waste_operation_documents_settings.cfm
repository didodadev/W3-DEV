<cfset waste_operation = createObject("component","WBP/Recycle/files/waste_operation/cfc/waste_operation") />

<cfif attributes.document_count gt 0>
    <cfloop index="i" from="1" to="#attributes.document_count#">
        <cfif isDefined("attributes.documentId#i#")>
            <cfset waste_operation.saveDocument(
                documentId: evaluate("attributes.documentId#i#"),
                docStatus: isDefined("attributes.documentStatus#i#") ? 1 : 0,
                documentDeleted: evaluate("attributes.documentDeleted#i#"),
                category: evaluate("attributes.category#i#"),
                name: evaluate("attributes.name#i#"),
                code: evaluate("attributes.code#i#"),
                module: evaluate("attributes.module#i#"),
                module_id: evaluate("attributes.module_id#i#"),
                assetcat: evaluate("attributes.assetcat#i#"),
                target: evaluate("attributes.target#i#"),
                related_fields: evaluate("attributes.related_fields#i#")
            ) />
        </cfif>
    </cfloop>
</cfif>

<script>location.reload();</script>