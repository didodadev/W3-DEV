<!---employee_id si gonderilen calisanin kalan izin gunu hesaplanir SG 20130227 --->
<cfsavecontent variable="izin_hesap"><cfinclude template="/V16/hr/display/list_offtime_emp.cfm"></cfsavecontent>
<cfoutput>#toplam_hakedilen_izin - genel_izin_toplam - old_days#</cfoutput>