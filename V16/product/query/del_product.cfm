<cfscript>
	ArrayDeleteAt(session[module_name][var_],attributes.row_);
</cfscript>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
