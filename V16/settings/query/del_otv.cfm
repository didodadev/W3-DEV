<cfset DEL_OTV = createObject("component","V16.settings.cfc.OTV")/>
<cfset Delete = DEL_OTV.Delete(
    OTV_ID : attributes.oid
)/>
<script type="text/javascript">
    <cfoutput>
        window.location.href = 'index.cfm?fuseaction=settings.list_otv'
    </cfoutput>
</script>