<cfquery name="GET_VISIT_TYPE" datasource="#DSN#">
	SELECT 
		VISIT_TYPE_ID,
		VISIT_TYPE
	FROM 
		SETUP_VISIT_TYPES
	ORDER BY 
		VISIT_TYPE
</cfquery>
<cfparam name='attributes.totalrecords' default="#get_visit_type.recordcount#">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr height="35">
    	<td class="headbold"><cf_get_lang dictionary_id='42915.Ziyaret Nedenleri'></td>
	</tr>
</table>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  	<tr class="color-border">
    	<td>
      	<table cellspacing="1" cellpadding="2" width="100%" border="0">
        	<tr height="22" class="color-header">
          		<td class="form-title" width="30"><cf_get_lang dictionary_id='57487.No'></td>
		  		<td class="form-title"><cf_get_lang dictionary_id='51717.Ziyaret Nedeni'></td>
        	</tr>
		<cfif get_visit_type.recordcount>
          <cfoutput query="get_visit_type">
           	<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
            	<td>#currentrow#</td>
			  	<td><a href="javascript://" class="tableyazi"  onClick="gonder(#visit_type_id#,'#visit_type#','#currentrow#')">#visit_type#</a></td>
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
<br/>
<script type="text/javascript">
function gonder(visit_type_id,visit_type,id)
{
	var kontrol =0;
	uzunluk = opener.<cfoutput>#attributes.field_name#</cfoutput>.length;
	for(i=0;i<uzunluk;i++)
	{
		if(opener.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==visit_type_id)
			kontrol=1;
	}
	
	if(kontrol==0)
	{
		<cfif isDefined("attributes.field_name")>
			x = opener.<cfoutput>#attributes.field_name#</cfoutput>.length;
			opener.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
			opener. <cfoutput>#attributes.field_name#</cfoutput>.options[x].value = visit_type_id;
			opener.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = visit_type;
		</cfif>
	}
}
</script>
