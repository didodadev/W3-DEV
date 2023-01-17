<cfif isDefined("application.plevne_service.threads")>
    <cfset threads = application.plevne_service.threads>
<cfelse>
    <cfset threads = arrayNew(1)>
</cfif>

<div class="col col-4 col-sm-6 col-xs-12">
    <cf_box>
        <div class="row badges">
            <div class="col-12 head-col">
                Active Threads
            </div>
            <div class="col col-6">
                <div class="number"><cfset writeOutput(arrayLen(threads) eq 0 ? "0" : int(threads[arrayLen(threads)]))></div>
            </div>
            <div class="col col-6 text-right">
                <span id="sparkline_threads"></span>
                <script>
                    $("#sparkline_threads").sparkline([<cfoutput>#arrayToList(threads)#</cfoutput>], {type: 'line', height: '40', width: '100'});
                </script>
            </div>
        </div>
    </cf_box>
</div>