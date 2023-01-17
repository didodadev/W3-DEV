<cfscript>
    data = [
        [
            title   :   "Main Database and Product Database Definition",
            content :   ""
        ],
        [
            title   :   "Documents Settings",
            content :   ""
        ],
        [
            title   :   "Workcube Parameter Settings",
            content :   ""
        ],
        [
            title   :   "Upload Workcube System Datas",
            content :   ""
        ],
        [
            title   :   "Company Definitions and Create Db Objects",
            content :   ""
        ],
        [
            title   :   "Fiscal Year Definitions and Create Db Objects",
            content :   ""
        ],
        [
            title   :   "Create User",
            content :   ""
        ],
        [
            title   :   "Installation completed",
            content :   ""
        ],
        [
            title   :   "WBP Upload",
            content :   ""
        ]
    ];
    showUntil = ArrayLen(data);

</cfscript>
<cfoutput>
    <div class="stepwizard">
        <cfloop from="1" to="#showUntil#" index="row">
            <div class="step_area">   
                <div class="circle step#row#">#row#</div>
                <div class="content">
                    <div class="title">#data[row]["title"]#</div>
                    <div class="text">#data[row]["content"]#</div>
                </div>
            </div>
        </cfloop>
    </div>
</cfoutput>