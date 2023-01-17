<cfset refinery = createObject("component","WBP/Recycle/files/cfc/refinery") />
<cfset fileUploadFolder = "#upload_folder#/member/" />

<cftransaction>

    <cfquery name="del_wast_oil" datasource="#DSN2#">
        DELETE FROM #dsn#.REFINERY_WASTE_OIL WHERE REFINERY_WASTE_OIL_ID = #attributes.id#
    </cfquery>

    <cfset getWasteOilRow = refinery.getWasteOilRow( refinery_waste_oil_id: attributes.id ) /> 

    <cfif getWasteOilRow.recordcount>
        <cfloop query="#getWasteOilRow#">
            <cfset refinery.delWastOilRow( REFINERY_WASTE_OIL_ROW_ID ) />
            
            <cfif len( ASSET_ID )>
                <cfset getAsset = refinery.getAsset(ASSET_ID) />
                <cfif getAsset.recordcount and fileExists("#fileUploadFolder#/#getAsset.ASSET_FILE_NAME#")>
                    <cffile action = "delete" file = "#fileUploadFolder#/#getAsset.ASSET_FILE_NAME#">
                </cfif>
                <cfset refinery.delAsset(ASSET_ID) />
            </cfif>

        </cfloop>
    </cfif>

</cftransaction>

<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=recycle.waste_oil_acceptance</cfoutput>';
</script>