<cf_date tarih='form.startdate'>
<cf_date tarih='form.finishdate'>

<!--- <cfif len(form.warning_start)>
	<cf_date tarih='form.warning_start'>
</cfif> --->

<cfscript>
// STARTDATE OLUŞTUR
FORM.STARTDATE = date_add('h', FORM.EVENT_START_CLOCK - TIME_ZONE, FORM.STARTDATE);
FORM.STARTDATE = date_add('n', FORM.EVENT_START_MINUTE, FORM.STARTDATE);
// finishdate oluştur
form.finishdate = date_add('h', form.event_finish_clock - TIME_ZONE, form.finishdate);
form.finishdate = date_add('n', form.event_finish_minute, form.finishdate);

TO_POS = '';
TO_PARS = '';
TO_CONS = '';
TO_GRPS = '';
CC_POS = '';
CC_PARS = '';
CC_CONS = '';
CC_GRPS = '';
/*
for (i=1; i lte listlen(FORM.TOS);i = i+1)
	if (listgetat(form.tos,i) CONTAINS 'POS')
		TO_POS = LISTAPPEND(TO_POS,LISTGETAT(listgetat(form.tos,i),2,'-'));
	else if (listgetat(form.tos,i) CONTAINS 'PAR')
		TO_PARS = LISTAPPEND(TO_PARS,LISTGETAT(listgetat(form.tos,i),2,'-'));
	else if (listgetat(form.tos,i) CONTAINS 'CON')
		TO_CONS = LISTAPPEND(TO_CONS,LISTGETAT(listgetat(form.tos,i),2,'-'));
	else if (listgetat(form.tos,i) CONTAINS 'GRP')
		TO_GRPS = LISTAPPEND(TO_GRPS,LISTGETAT(listgetat(form.tos,i),2,'-'));

for (i=1; i lte listlen(FORM.CCS);i = i+1)
	if (listgetat(form.CCs,i) CONTAINS 'POS')
		CC_POS = LISTAPPEND(CC_POS,LISTGETAT(listgetat(form.CCs,i),2,'-'));
	else if (listgetat(form.CCs,i) CONTAINS 'PAR')
		CC_PARS = LISTAPPEND(CC_PARS,LISTGETAT(listgetat(form.CCs,i),2,'-'));
	else if (listgetat(form.CCs,i) CONTAINS 'CON')
		CC_CONS = LISTAPPEND(CC_CONS,LISTGETAT(listgetat(form.CCs,i),2,'-'));
	else if (listgetat(form.CCs,i) CONTAINS 'GRP')
		CC_GRPS = LISTAPPEND(CC_GRPS,LISTGETAT(listgetat(form.CCs,i),2,'-'));
*/
if (isdefined('validator_position'))
	{
	if (len(validator_position))
		valid='';
	else
		valid=1;
	}
else
	valid = 1;
</cfscript>
