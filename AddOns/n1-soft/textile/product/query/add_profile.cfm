<cfobject name="get_sample_request" component="addons.n1-soft.textile.cfc.get_sample_request">
<cfif isDefined("attributes.profileid") and len(attributes.profileid)>
    <cfif attributes.opr eq "Sil">
    <cfset get_sample_request.delete_stock_profile( attributes.profileid )>
    <cfelse>
    <cfset get_sample_request.update_stock_profile( attributes.profileid, attributes.txt_head, attributes.chk_sizes, attributes.chk_lens )>
    </cfif>
<cfelse>
    <cfset get_sample_request.insert_stock_profile(
    attributes.txt_head, attributes.chk_sizes, attributes.chk_lens
)>
</cfif>
<script type="text/javascript">
document.location.href = <cfoutput>"index.cfm?fuseaction=textile.list_sample_request&event=add_stock&pid=#attributes.pid#&pcode=#attributes.pcode#&req_id=#attributes.req_id#";</cfoutput>
</script>