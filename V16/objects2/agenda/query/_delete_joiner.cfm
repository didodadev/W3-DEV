<cfif not isdefined("url.struct_delete")>
<cfset "session.agenda.event#url.event_id#.joins"=listdeleteat(evaluate("session.agenda.event#url.event_id#.joins"),listfind(evaluate("session.agenda.event#url.event_id#.joins"),url.id))>
<script type="text/javascript">
    wrk_opener_reload();
	window.close();
</script>
<cfelse>
<cfset "session.agenda.event#url.event_id#.joinss"=listdeleteat(evaluate("session.agenda.event#url.event_id#.joinss"),listfind(evaluate("session.agenda.event#url.event_id#.joinss"),url.id))>
<script type="text/javascript">
	opener.location=opener.location+'&struct_delete=';
	window.close();
</script>
</cfif>

