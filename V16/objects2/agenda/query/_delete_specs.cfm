<cfset "session.agenda.event#url.event_id#.specs"=listdeleteat(evaluate("session.agenda.event#url.event_id#.specs"),listfind(evaluate("session.agenda.event#url.event_id#.specs"),url.id))>
<script type="text/javascript">
    wrk_opener_reload();
	window.close();
</script>


