<cfif isDefined("application.plevne_service.cpuloads")>
    <cfset cpuloads = application.plevne_service.cpuloads>
<cfelse>
    <cfset cpuloads = arrayNew(1)>
</cfif>

<div class="col col-4 col-sm-6 col-xs-12">
    <cf_box>
        <div class="row badges">
            <div class="col-12 head-col">
                CPU Loads
            </div>
            <div class="col col-6">
                <div class="number">%<cfset writeOutput(arrayLen(cpuloads) eq 0 ? "0" : int(cpuloads[arrayLen(cpuloads)]))></div>
            </div>
            <div class="col col-6 text-right">
                <span id="sparkline_cpuloads"></span>
                <script>
                    $("#sparkline_cpuloads").sparkline([<cfoutput>#arrayToList(cpuloads)#</cfoutput>], {type: 'line', height: '40', width: '100'});
                </script>
            </div>
        </div>
    </cf_box>
</div>