<cfparam name="attributes.keyword" default="">
<cfset url_string = "">
<cfif len(attributes.keyword)>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
</cfif>
<cfquery name="get_design_paper" datasource="#dsn#">
	SELECT 
        MMS.RECORD_EMP,
		MMS.NAME,
		MMS.FORM_ID,
		E.EMPLOYEE_NAME,
        E.EMPLOYEE_SURNAME,
        E.EMPLOYEE_ID,
		MMS.RECORD_DATE 
    FROM 
        #DSN3_ALIAS#.SETUP_PRINT_FILES MMS,
        EMPLOYEES E
    WHERE 
        MMS.RECORD_EMP = E.EMPLOYEE_ID AND
		MMS.NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> AND
		ACTIVE = 1 AND
		IS_XML = 1
</cfquery>
<cfparam name="attributes.totalrecords" default=#get_design_paper.recordcount#>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" height="35">
  <tr>
    <td class="headbold">Design Paper</td>
    <td>
      <table align="right">
      <tr>
          <cfform name="filter" action="#request.self#?fuseaction=settings.list_design_paper" method="post">
            <td><cf_get_lang_main no='48.Filtre'></td>
            <td><cfinput type="Text" maxlength="255" value="#attributes.keyword#" name="keyword" id="keyword"></td>
			<td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
            </td>
            <td><cf_wrk_search_button></td>
          </cfform>
        </tr>
      </table>
    </td>
  </tr>
</table>

<table width="98%" align="center" border="0" cellspacing="1" cellpadding="2" class="color-border">
	<tr height="22" class="color-header">
	  <td class="form-title">Tasarım Adı</td>
	  <td class="form-title" width="150">Kaydeden</td>
	  <td class="form-title" width="65">Tarih</td>
      <td width="15"><cfoutput><a href="#request.self#?fuseaction=settings.form_add_design_paper"><img src="/images/plus_square.gif" border="0"></a></cfoutput></td>
	</tr>	
	<cfif get_design_paper.recordcount>
	  <cfoutput query="get_design_paper" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
	   <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
	   	  <td><a href="#request.self#?fuseaction=settings.form_upd_design_paper&design_id=#form_id#" class="tableyazi">#name#</a></td>
		  <td width="150"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#EMPLOYEE_ID#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
		  <td width="65">#dateformat(RECORD_DATE,dateformat_style)#</td>
          <td width="15"><a href="#request.self#?fuseaction=settings.form_upd_design_paper&design_id=#form_id#" class="tableyazi"><img src="/images/update_list.gif" border="0" align="absmiddle"></a></td>
		</tr>
	    </cfoutput>
	  <cfelse>
	  <tr class="color-row" height="20">
		<td colspan="4"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
	  </tr>
	</cfif>
</table>
<cfif attributes.maxrows lt attributes.totalrecords>
  <table cellpadding="0" cellspacing="0" border="0" width="98%" height="35" align="center">
    <tr>
      <td>
        <cfset adres = "settings.list_design_paper">
        <cf_pages page="#attributes.page#" 
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres##url_string#"> </td>
      <td align="right" style="text-align:right;">
      <cfoutput>Toplam Kayıt :#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
    </tr>
  </table>
</cfif>
<br/>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
