<!--- Mail gönderme eklentisi--->
<!---
	<cf_wrk_Calender
		sender=mail gönderen kişi
		startdate=olayın başlama zamanı
		finishdate=olayın bitiş zamanı
		recorddate=olayın kayıt tarihi
		updatedate=olayın güncelleme tarihi
		detail=olayın detayı
		summary=olayın başlığı
		location=olay yeri
		list_mail=hatırlatıcı için gönderilen mail listesi
		type=0,1(0 ise takvim,1 ise hatırlatıcı.)
		>--->
<cfoutput>
<cfif attributes.type eq 0>
<cfsavecontent variable="caller.#attributes.content_name#"> 
BEGIN:VCALENDAR
PRODID:-//Microsoft Corporation//Outlook 10.0 MIMEDIR//EN
VERSION:2.0
METHOD:PUBLISH
BEGIN:VEVENT
TZID:Turkey 
X-LIC-LOCATION:Turkey 
ORGANIZER:MAILTO:#attributes.sender#
DTSTART:#dateformat(attributes.startdate,'yyyymmdd')#T#timeformat(attributes.startdate,'HHMM')#0000
DTEND:#dateformat(attributes.finishdate,'yyyymmdd')#T#timeformat(attributes.finishdate,'HHMM')#0000
TRANSP:OPAQUE
SEQUENCE:0
UID:040000008200E00074C5B7101A82E00800000000A0A14F273251C
DTSTAMP:#dateformat(attributes.recorddate,'yyyymmdd')#T#timeformat(attributes.recorddate,'HHMM')#0000
DESCRIPTION:#replace(reReplace(reReplace(JSStringFormat(attributes.detail),"\\r","","ALL"),"\'","'","ALL"),"\","")#
SUMMARY:#attributes.summary#
PRIORITY:5
CLASS:PUBLIC
BEGIN:VALARM
TRIGGER:-PT15M
ACTION:DISPLAY
DESCRIPTION:Reminder
END:VALARM
END:VEVENT
END:VCALENDAR
</cfsavecontent>
<cfelseif attributes.type eq 1>
<cfsavecontent variable="caller.#attributes.content_name#"> 
BEGIN:VCALENDAR
PRODID:-//Microsoft Corporation//Outlook 10.0 MIMEDIR//EN
VERSION:2.0
TZID:Turkey 
X-LIC-LOCATION:Turkey 
METHOD:REQUEST
BEGIN:VTIMEZONE
BEGIN:DAYLIGHT
TZOFFSETFROM:+0200
TZOFFSETTO:+0300
TZNAME:EEST
DTSTART:19700329T030000
RRULE:FREQ=YEARLY;BYDAY=-1SU;BYMONTH=3
END:DAYLIGHT
BEGIN:STANDARD
TZOFFSETFROM:+0300
TZOFFSETTO:+0200
TZNAME:EET
DTSTART:19701025T040000
RRULE:FREQ=YEARLY;BYDAY=-1SU;BYMONTH=10
END:STANDARD
END:VTIMEZONE
BEGIN:VEVENT
SEQUENCE:0
UID:CZTL-07DB0C01-00D3-0B1E-FF36-00739
LOCATION:#attributes.location#
SUMMARY:#attributes.summary#
DTSTART:#dateformat(attributes.startdate,'yyyymmdd')#T#timeformat(attributes.startdate,'HHMM')#0000
DTEND:#dateformat(attributes.finishdate,'yyyymmdd')#T#timeformat(attributes.finishdate,'HHMM')#0000
ORGANIZER:MAILTO:#attributes.sender#
ATTENDEE;RSVP=TRUE:mailto:#attributes.list_mail#
ATTENDEE;PARTSTAT=ACCEPTED;EMAIL="#attributes.sender#"
DTSTAMP:#dateformat(attributes.recorddate,'yyyymmdd')#T#timeformat(attributes.recorddate,'HHMM')#0000
END:VEVENT
END:VCALENDAR
</cfsavecontent>
</cfif>
</cfoutput>
