<cf_date tarih='attributes.startdate'>
<cf_date tarih='attributes.finishdate'>

<cfif len(attributes.warning_start)>
	<cf_date tarih='attributes.warning_start'>
</cfif>

<cfscript>
	// startdate oluştur
	attributes.startdate = date_add('h', attributes.event_start_clock - time_zone, attributes.startdate);
	attributes.startdate = date_add('n', attributes.event_start_minute, attributes.startdate);
	// finishdate oluştur
	attributes.finishdate = date_add('h', attributes.event_finish_clock - attributes.time_zone, attributes.finishdate);
	attributes.finishdate = date_add('n', attributes.event_finish_minute, attributes.finishdate);
	//warning email date oluştur
	form.email_alert_day=date_add('d', -attributes.email_alert_day, attributes.startdate);

	if ((attributes.email_alert_hour eq 0.25) or (attributes.email_alert_hour eq 0.5))
		minute = attributes.email_alert_hour * 60;
	else
		minute = 0;

	attributes.email_alert_day = date_add('h',-attributes.email_alert_hour,attributes.email_alert_day);
	attributes.email_alert_day = date_add('n',-minute,attributes.email_alert_day);
</cfscript>


