<cfscript>
    data = [
        [
            title   :   "Database are being created",
            content :   ""
        ],
        [
            title   :   "Installation completed",
            content :   ""
        ]
    ];
</cfscript>
<cfoutput>
    <div class="stepwizard">
        <cfloop from="1" to="2" index="row">
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