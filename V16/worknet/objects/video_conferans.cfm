<cfif isdefined('session.pp.userid')>
	<cfinclude template="../../objects/display/video_conferans.cfm">
<cfelse>
	<script language="javascript">
		alert("<cf_get_lang no='159.Lütfen üye girişi yapınız'>");
		window.close();
	</script>
</cfif>
