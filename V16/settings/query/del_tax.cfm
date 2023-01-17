<cfset DEL_TAX = createObject("component","V16.settings.cfc.TAX")/>
<cfset Delete = DEL_TAX.Delete(
    tid : attributes.tid
)/>
<script type="text/javascript">
    <cfoutput>
        window.location.href = 'index.cfm?fuseaction=settings.list_tax'
    </cfoutput>
</script>
