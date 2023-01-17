<cfscript>
		get_impropriety_source = createObject("component", "V16.settings.cfc.setupImproprietySource");
		add_Improriety_Source = get_impropriety_source.addImproprietySource
		(
			dsn3		: dsn3,
			is_active	: iif(isDefined("attributes.is_active"),'attributes.is_active',de(0)),
			imp_source_name	: attributes.imp_source_name,
			description	: attributes.imp_source_detail,
			is_default	: iif(isDefined("attributes.is_default"),'attributes.is_default',de(0))
		);
</cfscript>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
