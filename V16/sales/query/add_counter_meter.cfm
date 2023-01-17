
<cfset subsCounterPre = createObject("component","V16.sales.cfc.counter_meter")>
<cfset response = subsCounterPre.insert(
    subscription_id     :   attributes.subscription_id,
    counter_id          :   attributes.counter_id,
    previous_value      :   attributes.previous_value,
    last_value          :   attributes.last_value,
    difference          :   attributes.difference
)>
<cfif response.status>
    <script type="text/javascript">
        <cfoutput>
            window.location.href = '#request.self#?fuseaction=sales.counter_meter&event=upd&cm_id=#response.result.IDENTITYCOL#';
        </cfoutput>
    </script>
<cfelse>
    <script>
        alert('<cf_get_lang dictionary_id = "48344">');
    </script>
</cfif>