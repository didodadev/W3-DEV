<cfparam name="attributes.keyword" default="">
<cfquery name="GET_ACTIVITY_STAGE" datasource="#dsn#">
	SELECT 
		ACTIVITY_STAGE_ID,
		ACTIVITY_STAGE
	FROM 
		SETUP_ACTIVITY_STAGES
	WHERE
		ACTIVITY_STAGE_ID IS NOT NULL
		<cfif len(attributes.keyword)>
		AND 
		(
		ACTIVITY_STAGE LIKE '%#attributes.keyword#%' 
		)
		</cfif>
	ORDER BY 
		ACTIVITY_STAGE
</cfquery>
<cfparam name='attributes.totalrecords' default="#get_activity_stage.recordcount#">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr height="35">
    <td class="headbold"><cf_get_lang dictionary_id='42918.Etkinlik Aşamaları'></td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr height="22" class="color-header">
          <td class="form-title" width="30"><cf_get_lang dictionary_id='57487.No'></td>
		  <td class="form-title"><cf_get_lang dictionary_id='43171.Etkinlik Aşama'></td>
        </tr>
		<cfif get_activity_stage.recordcount>
          <cfoutput query="get_activity_stage">
            <tr id=#currentrow# height="20" class="color-row" onClick="this.bgColor='CCCCCC'">
              <td>#currentrow#</td>
			  <td><a href="javascript://" class="tableyazi"  onClick="gonder(#activity_stage_id#,'#activity_stage#','#currentrow#')">#activity_stage#</a></td>
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
	<cfset url_str = "">
  <table width="98%" align="center" cellpadding="0" cellspacing="0" height="35">
    <tr>
      <td><cf_pages 
	  		page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="objects.popup_dsp_activity_stages#url_str#"></td>
      <td  style="text-align:right;"><cf_get_lang dictionary_id='57540.Toplam Kayit'><cfoutput>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
    </tr>
  </table>
</cfif>
<script type="text/javascript">
	
	function gonder(society_id,society,id)
	{
	var kontrol =0;
	uzunluk = opener.<cfoutput>#attributes.field_name#</cfoutput>.length;
	for(i=0;i<uzunluk;i++){
		if(opener.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==society_id)
		{
			kontrol=1;
		}
	}
	
	if(kontrol==0){
		<cfif isDefined("attributes.field_name")>
			x = opener.<cfoutput>#attributes.field_name#</cfoutput>.length;
			opener.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
			opener. <cfoutput>#attributes.field_name#</cfoutput>.options[x].value = society_id;
			opener.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = society;
		</cfif>
		}
	}
</script>
