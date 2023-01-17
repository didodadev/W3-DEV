<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.url_str" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset url_str = "">
<cfif isdefined('attributes.field_id') and len(attributes.field_id)>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined('attributes.field_name') and len(attributes.field_name)>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfquery name="get_shift" datasource="#DSN#">
	SELECT     	S.SHIFT_NAME,
				S.SHIFT_ID
	FROM      	SETUP_SHIFTS AS S INNER JOIN
            	BRANCH AS B ON S.BRANCH_ID = B.BRANCH_ID
	WHERE     	(B.COMPANY_ID = #session.ep.COMPANY_ID#) AND (S.IS_PRODUCTION=1)
				<cfif len(attributes.keyword)>AND S.SHIFT_NAME LIKE '%#attributes.keyword#%'</cfif> 
	ORDER BY 	S.SHIFT_NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_shift.recordCount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
<cfform name="search_shift" method="post" action="#request.self#?fuseaction=prod.popup_list_ezgi_shift&#url_str#"> 
  <tr>
    <td class="headbold"><cfoutput>#getLang('ehesap',116)#</cfoutput></td>
    <td align="right" style="text-align:right;">
	<table>
	  <tr>
		<td><cf_get_lang_main no='48.Filtre'> :</td>
       	<td><cfinput type="text" name="keyword" value="#attributes.keyword#"></td>
       	<td><cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1," required="yes" style="width:25px;"></td>
       	<td><cf_wrk_search_button></td>
  	  </tr>
	</table>
    </td>
  </tr>
</cfform>
</table>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr class="color-border">
    <td>
	<table width="100%" border="0" cellspacing="1" cellpadding="2">
	  <tr height="22" class="color-header">
	  	<td class="form-title"><cfoutput>#getLang('ehesap',116)#</cfoutput></td>
	  </tr>
	<cfif get_shift.recordcount>
	<cfoutput query="get_shift" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
	  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
		<td><a href="javascript://" onClick="add_shift('#SHIFT_ID#','#SHIFT_NAME#');" class="tableyazi">#SHIFT_NAME#</a>		
		</td>
	  </tr>
	</cfoutput>
	<cfelse>
	  <tr class="color-row">
		<td height="20" colspan="3"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
	  </tr>
	</cfif>
	</table>
    </td>
  </tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfif len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif isdefined("attributes.call_function") and len(attributes.keyword)>
		<cfset url_str = "#url_str#&call_function=#attributes.call_function#">
	</cfif>

	<table width="98%" border="0" cellpadding="0" cellspacing="0" height="35" align="center">
	  <tr>
	 	<td>
		  <cf_pages page="#attributes.page#"
		  		 maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			   startrow="#attributes.startrow#"
			      adres="objects.popup_list_shift#url_str#">
		</td>
	  	<!-- sil -->
	  	<td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
	  <!-- sil -->
	  </tr>
	</table>
</cfif>
<script language="JavaScript">
function add_shift(field_id,field_name)
{
	<cfif isdefined("attributes.field_id")>
		opener.document.all.<cfoutput>#attributes.field_id#</cfoutput>.value = field_id;
	</cfif>
	<cfif isdefined("attributes.field_name")>
		opener.document.all.<cfoutput>#attributes.field_name#</cfoutput>.value = field_name;
	</cfif>
	<cfif isdefined("attributes.call_function")>
		try{opener.<cfoutput>#attributes.call_function#</cfoutput>;}
			catch(e){};
	</cfif>
	window.close();
}
	document.search_shift.keyword.select();		
</script>
