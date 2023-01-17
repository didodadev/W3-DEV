<cfparam name="attributes.keyword" default="">
<cfquery name="GET_VISIT_TYPE" datasource="#DSN#">
	SELECT 
		VISIT_TYPE_ID,
		VISIT_TYPE
	FROM 
		SETUP_VISIT_TYPES 
	WHERE
		VISIT_TYPE_ID IS NOT NULL
	<cfif len(attributes.keyword)>
		AND (VISIT_TYPE LIKE '%#attributes.keyword#%')
	</cfif>
	ORDER BY 
		VISIT_TYPE
</cfquery>
<cfparam name='attributes.totalrecords' default="#get_visit_type.recordcount#">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33071.Ziyaret Nedenleri'></cfsavecontent>
<cf_medium_list_search title="#message#"></cf_medium_list_search>
<cf_medium_list>
<thead>
    	<th><cf_get_lang dictionary_id="57487.No"></th>
        <th><cf_get_lang dictionary_id="33071.Ziyaret Nedenleri"></th>
    </thead>
    <tbody>
		<cfif get_visit_type.recordcount>
          <cfoutput query="get_visit_type">
            <tr id=#currentrow# height="20" class="color-row" onClick="this.bgColor='CCCCCC'">
            	<td>#currentrow#</td>
			  	<td><a href="javascript://" class="tableyazi"  onClick="gonder(#visit_type_id#,'#visit_type#','#currentrow#')">#visit_type#</a></td>
            </tr>
          </cfoutput>
          <cfelse>
          	<tr class="color-row">
            	<td height="20" colspan="5"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'> !</td>
          	</tr>
        </cfif>
    </tbody>
</cf_medium_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "">
	<cfif len(attributes.field_name)>
	  <cfset url_str = "#url_str#&field_name=#attributes.field_name#">
	</cfif>
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
