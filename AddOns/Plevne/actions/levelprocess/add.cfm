<cfinclude template="../../config.cfm" runonce="true">
<cfinclude template="../../models/types.cfm" runonce="true">

<cfparam name="attributes.contrast" default="">
<cfparam name="attributes.process_kind" default="">
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.relation_id" default="">

<cfif attributes.contrast eq "">
    <script type="text/javascript">
        alert("Contrast alanı boş bırakılamaz!");
        history.back();
    </script>
</cfif>
<cfif attributes.process_kind eq "">
    <script type="text/javascript">
        alert("Tür alanı boş bırakılamaz!");
        history.back();
    </script>
</cfif>
<cfif attributes.process_type eq "">
    <script type="text/javascript">
        alert("İşlem tipi alanı boş bırakılamaz!");
        history.back();
    </script>
</cfif>
<cfif attributes.relation_id eq "">
    <script type="text/javascript">
        alert("İşlem türü alanı boş bırakılamaz!");
        history.back();
    </script>
</cfif>

<cfobject name="inst_level_process" type="component" component="#addonns#.domains.level_process">
<cfset inst_level_process.save_level_process(process_kind: attributes.process_kind, process_type: attributes.process_type, relation_id: attributes.relation_id, contrast: attributes.contrast)>

<script type="text/javascript">
    document.location.href = "<cfoutput>#request.self#?fuseaction=#attributes.pageFuseaction#</cfoutput>";
</script>