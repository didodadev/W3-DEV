<cfscript>
	structclear(evaluate("session.#module_name#"));
</cfscript>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
