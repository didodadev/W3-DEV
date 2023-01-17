<cfinclude template="../../config.cfm" runonce="true">
<cfinclude template="../../models/types.cfm" runonce="true">

<cfparam name="attributes.interceptor_id" default="0">
<cfparam name="attributes.interceptor_category" default="">
<cfparam name="attributes.interceptor_path" default="">
<cfparam name="attributes.status" default="1">

<cfif not len(attributes.interceptor_category)>
    <script type="text/javascript">
        alert("Eksik bilgi!");
        history.back();
    </script>
</cfif>
<cfif not len(attributes.interceptor_path)>
    <script type="text/javascript">
        alert("interceptor boş olamaz!");
        history.back();
    </script>
</cfif>

<cfobject name="inst_interceptor" type="component" component="#addonns#.domains.interceptors">
<cfset inst_interceptor.save_interceptors(interceptor_id: attributes.interceptor_id, interceptor_category: attributes.interceptor_category, interceptor_path: attributes.interceptor_path, status: attributes.status)>

<script type="text/javascript">
    window.close();
</script>