<cfparam name="attributes.pr_order_ids" default="">
<cfparam name="attributes.approved" default="0">

<cfif len(attributes.pr_order_ids)>

    <cfobject name="washing_recepie" component="WBP.Fashion.files.cfc.washing_recepie">
    <cfset result = washing_recepie.copy_recepie_head( attributes.pr_order_ids, attributes.approved )>
    <cfset washing_recepie_id = result.generatedkey>
    <cfset washing_recepie.copy_recepie_row( attributes.pr_order_ids, washing_recepie_id )>

</cfif>

<script>
	window.location.href= '<cfoutput>#request.self#?fuseaction=textile.wahing_recepie&event=upd&rid=#washing_recepie_id#</Cfoutput>';
</script>