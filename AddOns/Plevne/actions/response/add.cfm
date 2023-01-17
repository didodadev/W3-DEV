<cfinclude template="../../config.cfm" runonce="true">
<cfinclude template="../../models/types.cfm" runonce="true">

<cfparam name="attributes.header" default="">
<cfparam name="attributes.type" default="1">
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.response_data" default="">

<cfif not len(attributes.header)>
    <script type="text/javascript">
        alert("Eksik bilgi!");
        history.back();
    </script>
</cfif>

<cfif not len(attributes.response_data)>
    <script type="text/javascript">
        alert("Eksik bilgi!");
        history.back();
    </script>
</cfif>

<cfobject name="inst_responses" type="component" component="#addonns#.domains.responses">
<cfset inst_responses.save_responses(type: attributes.type, header: attributes.header, response_data: attributes.response_data, status: attributes.status)>

<script type="text/javascript">
    document.location.href = "<cfoutput>#request.self#?fuseaction=#attributes.pageFuseaction#</cfoutput>";
</script>