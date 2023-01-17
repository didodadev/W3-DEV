<cfobject type="component" component="WBP.Fashion.files.cfc.stretching_test" name="cmpst">
<cfobject type="component" component="WBP.Fashion.files.cfc.stockactions" name="cmpsa">
<script type="text/javascript">
    document.location.href = '/index.cfm?fuseaction=stock.form_add_fis&st_id=<cfoutput>#attributes.st_id#</cfoutput>';
</script>