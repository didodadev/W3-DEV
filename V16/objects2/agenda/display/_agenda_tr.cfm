<table border="0" cellpadding="0" cellspacing="0" width="100%" height="22">
	<cfif isDefined("url.yil")>
    	<cfset temp = "&yil=#url.yil#&ay=#url.ay#">
    	<cfif isDefined("url.gun")>
      		<cfset temp = "#temp#&gun=#url.gun#">
    	</cfif>
    <cfelse>
    	<cfset temp = "">
  	</cfif>
  	<tr class="txtsubmenu">
    	<td width="30" class="titlebold">
      		<cfif not listfindnocase(denied_pages,'agenda.welcome')>
        		<a href="<cfoutput>#request.self#?fuseaction=agenda.welcome#temp#</cfoutput>" class="titlebold"><cf_get_lang_main no='3.Ajanda'></a>
      		</cfif>
    	</td>
    	<td class="txtsubmenu">
      		<cfif not listfindnocase(denied_pages,'agenda.view_daily')>
        		<a href="<cfoutput>#request.self#?fuseaction=agenda.view_daily#temp#</cfoutput>" class="txtsubmenu"><cf_get_lang_main no='1045.Günlük'></a> :
      		</cfif>
      		<cfif not listfindnocase(denied_pages,'agenda.view_weekly')>
        		<a href="<cfoutput>#request.self#?fuseaction=agenda.view_weekly#temp#</cfoutput>" class="txtsubmenu"><cf_get_lang_main no='1046.Haftalık'></a> :
      		</cfif>
      		<cfif not listfindnocase(denied_pages,'agenda.view_monthly')>
        		<a href="<cfoutput>#request.self#?fuseaction=agenda.view_monthly#temp#</cfoutput>" class="txtsubmenu"><cf_get_lang_main no='1520.Aylık'></a> :
      		</cfif>
     		<cfif not listfindnocase(denied_pages,'agenda.form_add_event')>
        		<cfif not isdefined("session.agenda_userid")>
          			<a href="<cfoutput>#request.self#?fuseaction=agenda.view_daily&event=add</cfoutput>" class="txtsubmenu"><cf_get_lang_main no='1084.Olay Ekle'></a> :
        		</cfif>
      		</cfif>
      		<cfif not listfindnocase(denied_pages,'agenda.form_settings')>
        		<a href="<cfoutput>#request.self#?fuseaction=agenda.form_settings</cfoutput>" class="txtsubmenu"><cf_get_lang_main no='117.Tanımlar'></a>
      		</cfif>
    	</td>
    	<td align="right" class="tableyazi" style="text-align:right;">
      		<cfif isdefined("session.agenda_userid")>
        		<cfif session.agenda_user_type is "e">
					<cfset attributes.employee_id = session.agenda_userid>
				  	<cfinclude template="../query/get_hr_name.cfm">
          			<cfoutput> <cf_get_lang no='1619.Şu anda'> <font color="##ff0000">#get_hr_name.employee_name# #get_hr_name.employee_surname#</font> <cf_get_lang no='1619..ajandasına bakmaktasınız.'>&nbsp;&nbsp; </cfoutput>
          		<cfelse>
          			<cfset attributes.partner_id = session.agenda_userid>
          			<cfinclude template="../query/get_partner_name.cfm">
          			<cfoutput> <cf_get_lang no='1619.Şu anda'> <font color="##ff0000">#get_partner_name.company_partner_name# #get_partner_name.company_partner_surname#</font> <cf_get_lang no='1620.ajandasına bakmaktasınız.'>&nbsp;&nbsp; </cfoutput>
        		</cfif>
        	<cfelse>
				<cf_get_lang no='1619.Şu anda'> <font color="##ff0000"><cf_get_lang no='332.kendi'></font> <cf_get_lang no='1620.ajandanıza
				bakmaktasınız.'> &nbsp;&nbsp;
      		</cfif>
    	</td>
  	</tr>
</table>

