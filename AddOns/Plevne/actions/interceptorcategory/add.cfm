<cfinclude template="../../config.cfm" runonce="true">
<cfinclude template="../../models/types.cfm" runonce="true">

<cfparam name="attributes.title" default="">
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.kind" default="1">

<cfif attributes.title eq "">
    <script type="text/javascript">
        alert("Tanım alanı boş bırakılamaz!");
        history.back();
    </script>
</cfif>

<cfobject name="inst_interceptor_categories" type="component" component="#addonns#.domains.interceptor_categories">
<cfset inst_interceptor_categories.save_interceptor_categories(title: attributes.title, status: attributes.status, interceptor_kind: attributes.kind)>

<script type="text/javascript">
    document.location.href = "<cfoutput>#request.self#?fuseaction=#attributes.pageFuseaction#</cfoutput>";
</script>