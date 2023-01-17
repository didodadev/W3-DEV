<cfsetting showdebugoutput="no">
<iframe id="agenda_iframe" name="agenda_iframe" height="" width="100%" frameborder="0" src="<cfoutput>#request.self#?</cfoutput>fuseaction=agenda.emptypopup_event_calendar&iframe=1"></iframe>
<script type="text/javascript">
	document.getElementById('agenda_iframe').height = document.body.offsetHeight - 90; // spry+ara_menu+footer heights
</script>

