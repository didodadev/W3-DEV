<cfscript>
		get_inspection_level = createObject("component", "V16.settings.cfc.setupInspectionLevel");
		upd_Inspection_Level = get_inspection_level.updInspectionLevel
		(
			dsn3		: dsn3,
			is_active	: iif(isDefined("attributes.is_active"),'attributes.is_active',de(0)),
			level_id	: attributes.inspection_level_id,
			level_code	: attributes.inspection_level_code,
			level_name	: attributes.inspection_level_name,
			description	: attributes.description,
			is_default	: iif(isDefined("attributes.is_default"),'attributes.is_default',de(0))
		);
</cfscript>
<script type="text/javascript">
		location.href = document.referrer;
</script>
