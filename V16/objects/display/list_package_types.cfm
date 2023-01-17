<cfparam name="attributes.keyword" default="">
<cfquery name="GET_IMS_CODE" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_PACKAGE_TYPE
	WHERE
		PACKAGE_TYPE_ID IS NOT NULL
		<cfif len(attributes.keyword)>AND PACKAGE_TYPE LIKE '%#attributes.keyword#%'</cfif>
	ORDER BY 
		PACKAGE_TYPE
</cfquery>
<cfparam name='attributes.totalrecords' default="#get_ims_code.recordcount#">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
function gonder(id1,id2,id3)
{
	<cfif isDefined("attributes.ship_piece_id")>
		opener.<cfoutput>#attributes.ship_piece_id#</cfoutput>.value=id1;
	</cfif>
	<cfif isDefined("attributes.ship_piece")>
		opener.<cfoutput>#attributes.ship_piece#</cfoutput>.value=id2;
	</cfif>
	<cfif isDefined("attributes.ship_ebat")>
		opener.<cfoutput>#attributes.ship_ebat#</cfoutput>.value=id3;
	</cfif>
	window.close();
}
</script>
<cfset url_str = "">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.ship_piece_id)>
	<cfset url_str = "#url_str#&ship_piece_id=#attributes.ship_piece_id#">
</cfif>
<cfif len(attributes.ship_piece)>
	<cfset url_str = "#url_str#&ship_piece=#attributes.ship_piece#">
</cfif>
<cfif len(attributes.ship_ebat)>
	<cfset url_str = "#url_str#&ship_ebat=#attributes.ship_ebat#">
</cfif>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr height="35">
    <td class="headbold"><cf_get_lang dictionary_id='42140.Paket Tipleri'></td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr height="22" class="color-header">
          <td class="form-title" width="30"><cf_get_lang dictionary_id='57487.No'></td>
		  <td class="form-title"><cf_get_lang dictionary_id='59088.Tip'></td>
		  <td class="form-title"><cf_get_lang dictionary_id='48383.Ebat'></td>
        </tr>
		<cfif get_ims_code.recordcount>
          <cfoutput query="get_ims_code">
            <tr id=#currentrow# height="20" class="color-row" onClick="this.bgColor='CCCCCC'">
              <td>#currentrow#</td>
			  <td><a href="javascript://" class="tableyazi"  onClick="gonder(#package_type_id#,'#package_type#','#dimention#')">#package_type#</a></td>
			  <td>#dimention#</td>
            </tr>
          </cfoutput>
          <cfelse>
          <tr class="color-row">
            <td height="20" colspan="5"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'> !</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" height="35">
    <tr>
      <td><cf_pages 
	  		page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="objects.popup_dsp_visit_types#url_str#"></td>
      <td  style="text-align:right;"><cf_get_lang dictionary_id='57540.Toplam Kayit'><cfoutput>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
    </tr>
  </table>
</cfif>
