<cfinclude template="../../config.cfm">
<cfinclude template="../../infrastructure/helpers.cfm" runOnce="true">

<cfobject name="inst_logs" type="component" component="#addonns#.domains.logs">
<cfobject name="inst_trace" type="component" component="#addonns#.domains.traces">
<style>
.badges {
    margin: 15px;
}
.badges .head-col {
    font-size: 15px;
    text-decoration: uppercase;
    color: #999;
    margin-bottom: 10px;
}
.badges .number {
    font-size: 36px;
    font-weight: bold;
}
.badges .link {
    text-transform: uppercase; font-weight: bold;
}
</style>
<cfoutput>
<script type="text/javascript" src="#addonpath#/assets/sparkline/sparkline.min.js"></script>
</cfoutput>
<cfset pageHead="PLEVNE DASHBOARD">
<cf_catalystHeader>
<div class="row">
    <div class="col col-9 col-sm-8 col-xs-12">
        <div class="row">
            <div class="col col-4 col-sm-6 col-xs-12">
                <cf_box>
                    <div class="row badges">
                        <div class="col-12 head-col">
                            <cf_get_lang dictionary_id='63528.Toplam Request Engelleme'>
                        </div>
                        <div class="col col-6">
                            <div class="number"><cfset writeOutput(inst_logs.count_logs(type: 1).CNT)></div>
                            <div class="link" style="color: red;"><cf_get_lang dictionary_id='33077.Detaylar'></div>
                        </div>
                        <div class="col col-6 text-right">
                            <span id="sparkline_requestfilter"></span>
                            <script>
                                <cfset sparkline_requestfilter = inst_logs.count_logs(type: 1, groups: "DATEPART(YEAR, LOGDATE), DATEPART(MONTH, LOGDATE)", date_start: dateAdd("m", -6, now()))>
                                $("#sparkline_requestfilter").sparkline([<cfoutput>#valueList(sparkline_requestfilter.CNT)#</cfoutput>], {type: 'bar', height: '40'});
                            </script>
                        </div>
                    </div>
                </cf_box>
            </div>
            <div class="col col-4 col-sm-6 col-xs-12">
                <cf_box>
                    <div class="row badges">
                        <div class="col-12 head-col">
                            <cf_get_lang dictionary_id='63529.Kritik Dosya Engelleme'>
                        </div>
                        <div class="col col-6">
                            <div class="number"><cfset writeOutput(inst_logs.count_logs(type: 1, source: "UploadControl").CNT)></div>
                            <div class="link" style="color: green;"><cf_get_lang dictionary_id='46850.Tümünü Göster'></div>
                        </div>
                        <div class="col col-6 text-right">
                            <span id="sparkline_filedrop"></span>
                            <script>
                                <cfset sparkline_requestfilter = inst_logs.count_logs(type: 1, source: "UploadControl", groups: "DATEPART(YEAR, LOGDATE), DATEPART(MONTH, LOGDATE)", date_start: dateAdd("m", -6, now()))>
                                $("#sparkline_filedrop").sparkline([<cfoutput>#valueList(sparkline_requestfilter.CNT)#</cfoutput>], {type: 'bar', height: '40'});
                            </script>
                        </div>
                    </div>
                </cf_box>
            </div>
            <div class="col col-4 col-sm-6 col-xs-12">
                <cf_box>
                    <div class="row badges">
                        <div class="col-12 head-col">
                            <cf_get_lang dictionary_id='57757.Uyarılar'>
                        </div>
                        <div class="col col-6">
                            <div class="number"><cfset writeOutput(inst_trace.get_traces_count().CNT)></div>
                            <div class="link" style="color: red;"><cf_get_lang dictionary_id="46850.Tümünü Göster"></div>
                        </div>
                        <div class="col col-6 text-right">
                            <span id="sparkline_traces"></span>
                            <script>
                                <cfset sparkline_traces = inst_trace.get_traces_count( groups: "DATEPART(YEAR, RECORD_DATE), DATEPART(MONTH, RECORD_DATE), DATEPART(DAY, RECORD_DATE)", record_date_start: dateAdd("m", -6, now()))>
                                $("#sparkline_traces").sparkline([<cfoutput>#valueList(sparkline_traces.CNT)#</cfoutput>], {type: 'bar', height: '40'});
                            </script>
                        </div>
                    </div>
                </cf_box>
            </div>
            <cfinclude template="../widgets/cpuload.cfm">
            <cfinclude template="../widgets/memoryused.cfm">
            <cfinclude template="../widgets/threads.cfm">
        </div>
        <div class="row">
            <div class="col col-12">
                <cf_box title="Log">
                    <cf_flat_list>
                        <thead>
                            <tr>
                                <th><cf_get_lang dictionary_id='35792.Kaynak'></th>
                                <th><cf_get_lang dictionary_id='57630.Tip'></th>
                                <th style="width: 200px;"><cf_get_lang dictionary_id='30631.Tarih'></th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfset query_logs = inst_logs.get_logs(top: 10)>
                            <cfoutput query="query_logs">
                                <tr>
                                    <td>#SOURCE#</td>
                                    <td><i class="fa fa-times-circle" style="color: red;"></i> #MESSAGE#</td>
                                    <td>#LOGDATE#</td>
                                </tr>
                            </cfoutput>
                        </tbody>
                    </cf_flat_list>
                </cf_box>
            </div>
        </div>
    </div>
    <div class="col col-3 col-sm-4 col-xs-12">
    </div>
</div>