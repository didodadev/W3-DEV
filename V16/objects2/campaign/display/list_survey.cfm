<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfinclude template="../query/get_surveys.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_surveys.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
	  <tr> 
		<td  style="text-align:right;"> 
		  <!--- Arama --->
		  <table>
		<cfform name="search_survey" method="post" action="#request.self#?fuseaction=objects2.list_survey">
		  <tr>
			<td><cf_get_lang_main no='48.Filtre'>:</td>
			<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
			<td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
			</td>
			<td><cf_wrk_search_button></td>
			</tr>
		</cfform>
		</table>
		<!--- Arama --->
			</td>
		  </tr>
	</table>
      <table width="100%" cellspacing="1" cellpadding="1" border="0" align="center" class="color-border">
        <tr height="22" class="color-header"> 
          <td width="25" class="form-title" height="22"><cf_get_lang_main no='75.No'></td>
          <td class="form-title" height="22"><cf_get_lang_main no='1250.Anket'></td>
          <td class="form-title" height="22"><cf_get_lang_main no='1398.Soru'></td>
          <td class="form-title" width="150" height="22"><cf_get_lang_main no='487.Kaydeden'></td>
          <td class="form-title" width="100" height="22"><cf_get_lang_main no='330.Tarih'></td>
          <td class="form-title" width="40" height="22"><cf_get_lang no='175.Oyla'></td>
        </tr>
	<cfif get_surveys.recordcount>
		<cfoutput query="get_surveys" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
			<tr height="20" class="color-row"> 
			  <td>#currentrow#</td>
			  <td><a href="#request.self#?fuseaction=objects2.poll&survey_id=#survey_id#" class="tableyazi">#survey_head#</a></td>
			  <td>#survey#</td>
			  <td>#employee_name# #employee_surname#</td>
			  <td>#dateformat(date_add('h',session.ep.time_zone,record_date),'dd/mm/yyyy')# (#timeformat(date_add('h',session.ep.time_zone,record_date),'HH:MM')#)</td>
			  <td align="center"><a href="#request.self#?fuseaction=objects2.poll&survey_id=#survey_id#" title="<cf_get_lang no='278.Oy Ver'>"><img src="/images/hand.gif" border="0" alt="<cf_get_lang no='278.Oy Ver'>" /></a></td>
			</tr>
		</cfoutput>
	<cfelse>
        <tr class="color-row" height="20"> 
          <td colspan="6"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
        </tr>
	</cfif>
      </table>
<cfif get_surveys.recordcount and (attributes.totalrecords gt attributes.maxrows)>
	<table cellpadding="0" cellspacing="0" border="0" width="98%" height="35" align="center">
	  <tr> 
	    <td>
		<cf_pages 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="objects2.list_survey#url_str#"> 
	    </td>
	    <td style="text-align:right;"> <cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
	  </tr>
	</table>
</cfif>

