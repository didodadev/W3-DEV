<cfparam name="id" default="0">

<cfinclude template="../../config.cfm" runonce="true">
<cfinclude template="../../models/types.cfm" runonce="true">

<cfobject name="inst_logs" type="component" component="#addonns#.models.logs">
<cfset result_logs = inst_logs.get_log(attributes.id)>

<cf_box title="Log">
<cfif result_logs.recordcount gt 0>
    <div class="row" style="margin-bottom: 1rem;">
        <div class="col col-3">
            <cf_get_lang dictionary_id='35792.Kaynak'>
        </div>
        <div class="col col-9">
            <cfoutput>#result_logs.SOURCE#</cfoutput>
        </div>
    </div>
    <div class="row" style="margin-bottom: 1rem;">
        <div class="col col-3">
            <cf_get_lang dictionary_id='30631.Tarih'>
        </div>
        <div class="col col-9">
            <cfoutput>#result_logs.LOGDATE#</cfoutput>
        </div>
    </div>
    <div class="row" style="margin-bottom: 1rem;">
        <div class="col col-3">
            <cf_get_lang dictionary_id='57543.Mesaj'>
        </div>
        <div class="col col-9">
            <cfoutput>#result_logs.MESSAGE#</cfoutput>
        </div>
    </div>
    <div class="row" style="margin-bottom: 1rem;">
        <div class="col col-3">
            <cf_get_lang dictionary_id='57771.Detay'>
        </div>
        <div class="col col-9">
            <cfoutput>#rereplace(result_logs.TRACE, "\r", "<br>", "all")#</cfoutput>
        </div>
    </div>
<cfelse>
    <cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>
</cfif>
</cf_box>