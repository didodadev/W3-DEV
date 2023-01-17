<script type="text/javascript">
  function add_faction(e_id,e_name)
  {
    <cfif isdefined("attributes.field_emp_id")>
		opener.<cfoutput>#field_emp_id#</cfoutput>.value = e_id;
	</cfif>
	<cfif isdefined("attributes.field_name")>
		opener.<cfoutput>#field_name#</cfoutput>.value = e_name;
	</cfif>
	
	window.close();
  }
</script>

<cfquery name="get_emp" datasource="#dsn#">
  SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLYEE_SURNAME FROM EMPLOYEES
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_emp.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" height="35">
<cfform name="form1" method="post" action="#request.self#?fuseaction=settings.popup_emp_list&field_emp_id=add_faction.emp_id&field_name=add_faction.emp_name">
  <tr>
    <td class="headbold"><cf_get_lang_main no='1463.Çalışanlar'></td>
	<td align="right" style="text-align:right;">
	  <table>
			<tr>
			<td><cf_get_lang_main no='48.Filtre'>:</td>
			<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
			<td>
              <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
		<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
			</td>
			<td><cf_wrk_search_button></td>
			</tr>
		</table>
	</td>
  </tr>
 </cfform>
</table>

<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
  <tr class="color-border">
   <td>
  <table width="100%" cellpadding="2" cellspacing="1">
  <cfif  get_emp.RECORDCOUNT>
    <cfoutput query="get_emp" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
	 <tr class="color-row">	  
	  <td height="20">
	 <!--- <a href="#request.self#?fuseaction=dev.emptypopup_add_rel_faction&FACTION_REL_ID=#FUSEACTION_ID#&faction_ID=#URL.FACTION_ID#" class="tableyazi">#fuseaction#</a> --->
	   <a href="##" onClick="add_faction('#employee_id#','#emp_name#');" class="tableyazi">#employee_name# #employee_surname#</a>
	  </td> 
	 </tr>
	</cfoutput>
	<cfelse>
	 <tr class="color-row">
	   <td colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
	 </tr>
   </cfif>
   </table>
    <cfif attributes.totalrecords gt attributes.maxrows>
  	<table cellpadding="0" cellspacing="0" border="0" width="98%" height="35" align="center">
	   <tr> 
		 <td>
		<cfset adres = "#attributes.fuseaction#">
		<cfif len(attributes.keyword)>
			<cfset adres = "#adres#&keyword=#attributes.keyword#">
		</cfif>
		<cf_pages page="#attributes.page#"
		  maxrows="#attributes.maxrows#"
		  totalrecords="#attributes.totalrecords#"
		  startrow="#attributes.startrow#"
		  adres="#adres#">
		 </td>
		<!-- sil --><td colspan="2" align="right" style="text-align:right;"> <cf_get_lang_main no='128.Toplam Kayıt'>:<cfoutput>#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
	   </tr>
	 </table>
	  </cfif>
   </td>
  </tr> 
</table>

