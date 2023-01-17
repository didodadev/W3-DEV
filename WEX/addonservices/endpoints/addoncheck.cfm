<cfparam name="attributes.product_id">

<cfobject name="addon_checker" type="component" component="WEX.addonservices.clients.checkaddonstatus">
<cfset addon_status = addon_checker.get_trial_status(product_id)>

<cfif addon_status>
    <script type="text/javascript">
        window.reload();
    </script>
<cfelse>
    <p>Addon bilgisine ulaşılamadı lütfen daha sonra tekrar deneyin</p>
</cfif>