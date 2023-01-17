<cf_catalystheader>
<cfset get_mockup = model.getById( attributes.id ) />

<cfif get_mockup.recordcount>
    <div class="row">
        <div class="col col-12">
            <cf_box title="Mockup Preview - #get_mockup.MOCKUP_NAME#">
                <cf_tab defaultOpen="devAdd" divId="devAdd,devUpdate,devList,devInfo,devDash" divLang="Add;Upd;List;Info;Dashboard">
                    <div id = "unique_devAdd" class="ui-info-text uniqueBox">
                        <cfinclude template="../../../../documents/mockup_designer/#get_mockup.MOCKUP_FOLDER_NAME#/add.cfm">
                    </div>
                    <div id = "unique_devUpdate" class="ui-info-text uniqueBox">
                        <cfinclude template="../../../../documents/mockup_designer/#get_mockup.MOCKUP_FOLDER_NAME#/upd.cfm">
                    </div>
                    <div id = "unique_devList" class="ui-info-text uniqueBox">
                        <cfinclude template="../../../../documents/mockup_designer/#get_mockup.MOCKUP_FOLDER_NAME#/list.cfm">
                    </div>
                    <div id = "unique_devInfo" class="ui-info-text uniqueBox">
                        <cfinclude template="../../../../documents/mockup_designer/#get_mockup.MOCKUP_FOLDER_NAME#/det.cfm">
                    </div>
                    <div id = "unique_devDash" class="ui-info-text uniqueBox">
                        <cfinclude template="../../../../documents/mockup_designer/#get_mockup.MOCKUP_FOLDER_NAME#/dashboard.cfm">
                    </div>
                </cf_tab>
            </cf_box>
        </div>
    </div>
</cfif>