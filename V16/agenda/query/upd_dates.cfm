<cf_date tarih='attributes.startdate'>
<cf_date tarih='attributes.finishdate'>
<cfif len(attributes.warning_start)><cf_date tarih='attributes.warning_start'></cfif>

<cfscript>
	// STARTDATE OLUSTUR
	attributes.STARTDATE = date_add('h', attributes.EVENT_START_CLOCK - TIME_ZONE, attributes.STARTDATE);
	attributes.STARTDATE = date_add('n', attributes.EVENT_START_MINUTE, attributes.STARTDATE);
	// finishdate olustur
	attributes.finishdate = date_add('h', attributes.event_finish_clock - TIME_ZONE, attributes.finishdate);
	attributes.finishdate = date_add('n', attributes.event_finish_minute, attributes.finishdate);
	//warning email date oluştur
	attributes.email_alert_day=date_add('d', -attributes.email_alert_day, attributes.startdate);
	
	if ((attributes.email_alert_hour eq 0.25) or (attributes.email_alert_hour eq 0.5))
		minute = attributes.email_alert_hour * 60;
	else
		minute = 0;
	
	attributes.email_alert_day = date_add('h',-attributes.email_alert_hour,attributes.email_alert_day);
	//attributes.email_alert_day = date_add('n',-minute,attributes.email_alert_day);
	// warning sms date oluştur
	if((session.ep.our_company_info.sms eq 1))
	{
		attributes.sms_alert_day=date_add('d', -attributes.sms_alert_day, attributes.startdate);
	
		if ((attributes.sms_alert_hour eq 0.25) or (attributes.sms_alert_hour eq 0.5))
			minute = attributes.sms_alert_hour * 60;
		else
			minute = 0;
		
		attributes.sms_alert_day=date_add('h',-attributes.sms_alert_hour,attributes.sms_alert_day);
		//attributes.sms_alert_day=date_add('n',-minute,attributes.sms_alert_day);
	}
	
	TO_POS = '';
	TO_PARS = '';
	TO_CONS = '';
	TO_GRPS = '';
	CC_POS = '';
	CC_PARS = '';
	CC_CONS = '';
	CC_GRPS = '';
	
	if(isdefined('validator_position'))
	{
		if(len(validator_position)) valid='';
		else valid=1;
	}
	else
		valid = 1;
		writeoutput(attributes.finishdate);
</cfscript>
