<cfparam name="attributes.keyword" default="">
<cfquery name="GET_TITLE" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		SETUP_PARTNER_POSITION
	WHERE
		PARTNER_POSITION_ID IS NOT NULL
		<cfif len(attributes.keyword)>
		AND PARTNER_POSITION LIKE '%#attributes.keyword#%' 
		</cfif>
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default=#get_title.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
	function add_title(id,name)
	{
		<cfif isdefined("attributes.field_id")>
			opener.<cfoutput>#field_id#</cfoutput>.value = id;
		</cfif>
		<cfif isdefined("attributes.field_name")>
			opener.<cfoutput>#field_name#</cfoutput>.value = name;
		</cfif>
		window.close();
	}
</script>
<cfset url_string="">
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#field_name#">
</cfif>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>	
   <td height="35" class="headbold"><cf_get_lang dictionary_id='52687.Görevler'></td>
    <td  valign="bottom" style="text-align:right;"> 
      <!--- Arama --->
      <table>
        <cfform action="#request.self#?fuseaction=objects.popup_list_members_title" method="post">
          <tr> 
            <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
            <td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
            <td>
               <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
			   <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
            </td>
            <td><cf_wrk_search_button></td>
          </tr>
        </cfform>
      </table>
   </td>
  </tr>
</table>
<table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
  <tr class="color-border"> 
    <td> 
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr class="color-header" height="22"> 
		  <td class="form-title" width="75"><cf_get_lang dictionary_id='39931.Görev'></td>
		</tr>
	<cfif get_title.recordcount>
	<cfoutput query="get_title" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
	<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
		<td><a href="javascript://" onClick="add_title('#partner_position_id#','#partner_position#');" class="tableyazi">#partner_position#</a></td>
	</tr>
	</cfoutput>
	<cfelse>
	<tr class="color-row">
	<td colspan="1"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
	</tr>
	</cfif>
</table>
  </td>
 </tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
	<tr> 
		<td><cf_pages 
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="objects.popup_list_members_title&keyword=#attributes.keyword#"></td>
		<!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
	</tr>
</table>
</cfif>

