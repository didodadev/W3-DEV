<cfif not isdefined("url.struct_del_cc")>
	<cfset "session.agenda.event#url.event_id#.specs"=listdeleteat(evaluate("session.agenda.event#url.event_id#.specs"),listfind(evaluate("session.agenda.event#url.event_id#.specs"),url.id))>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<cfset "session.agenda.event#url.event_id#.specss"=listdeleteat(evaluate("session.agenda.event#url.event_id#.specss"),listfind(evaluate("session.agenda.event#url.event_id#.specss"),url.id))>
	<script type="text/javascript">
		opener.location=opener.location+'&struct_del_cc=';
		window.close();
	</script>
</cfif>
