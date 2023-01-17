<cfif isDefined("application.plevne_service.memoryusage")>
    <cfset memoryusage = application.plevne_service.memoryusage>
<cfelse>
    <cfset memoryusage = arrayNew(1)>
</cfif>

<div class="col col-4 col-sm-6 col-xs-12">
    <cf_box>
        <div class="row badges">
            <div class="col-12 head-col">
                Memory Used
            </div>
            <div class="col col-6">
                <div class="number"><cfset writeOutput(arrayLen(memoryusage) eq 0 ? "0" : calcFileSize( int(memoryusage[arrayLen(memoryusage)])))></div>
            </div>
            <div class="col col-6 text-right">
                <span id="sparkline_memoryusage"></span>
                <script>
                    $("#sparkline_memoryusage").sparkline([<cfoutput>#arrayToList(memoryusage)#</cfoutput>], {type: 'line', height: '40', width: '100'});
                </script>
            </div>
        </div>
    </cf_box>
</div>