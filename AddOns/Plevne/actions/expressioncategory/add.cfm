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

<cfobject name="inst_expression_categories" type="component" component="#addonns#.domains.expression_categories">
<cfset inst_expression_categories.save_expression_categories(title: attributes.title, status: attributes.status, expression_kind: attributes.kind)>

<script type="text/javascript">
    <cfif isdefined("attributes.draggable")>
        closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
        location.reload();
    <cfelse>
        document.location.href = "<cfoutput>#request.self#?fuseaction=#attributes.pageFuseaction#</cfoutput>";
    </cfif>
</script>