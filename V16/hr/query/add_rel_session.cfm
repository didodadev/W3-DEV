<cfset ArrayAppend(evaluate("session.hr.t_#t_id#.tr_id"), tr_id)>
<cfset ArrayAppend(evaluate("session.hr.t_#t_id#.tr_name"), tr_name)>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
