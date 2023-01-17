<cfquery name="get_stores" datasource="#dsn#">
		SELECT
			OUR_COMPANY.NICK_NAME,
			DEPARTMENT.DEPARTMENT_HEAD,
			DEPARTMENT.DEPARTMENT_ID,
			BRANCH.BRANCH_ID,
			ZONE.ZONE_ID,
			ZONE.ZONE_NAME,BRANCH.BRANCH_NAME
		FROM
			OUR_COMPANY,
			DEPARTMENT, 
			BRANCH, 
			ZONE
		WHERE
			BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID 
			AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID 
			AND BRANCH.ZONE_ID = ZONE.ZONE_ID
			AND DEPARTMENT.IS_STORE <> 2
	</cfquery>
<script type="text/javascript">
	function gonder(dep_id,dep_name)
	{
	var kontrol =0;
	uzunluk=opener.<cfoutput>#attributes.field_name#</cfoutput>.length;
	for(i=0;i<uzunluk;i++){
		if(opener.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==dep_id){
			kontrol=1;
		}
	}
if(kontrol==0){
		<cfif isDefined("attributes.field_name")>
			x = opener.<cfoutput>#attributes.field_name#</cfoutput>.length;
			opener.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1)
			opener.<cfoutput>#attributes.field_name#</cfoutput>.options[x].value = dep_id;
			opener.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = dep_name;
		</cfif>
	}
}
</script>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
  <td height="35" class="headbold"><cf_get_lang dictionary_id='45822.Depolar'></td>
	<td style="text-align:right;">
	<table>
	   <cfform name="search_ims" action="#request.self#?fuseaction=objects.popup_list_stores_detail" method="post">
			<input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
	 	 <!-- sil -->
        <tr>
		   <td></td>
			<td><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></td>
		  </tr>
		</cfform>
		 <!-- sil -->
      </table>
	</td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr height="22" class="color-row">
			<td colspan="4" style="text-align:right;">
			<table border="0">
			<!-- sil -->
			<tr>
					<!-- sil -->
			</table>
			<!--- Arama --->
			</td>
		</tr>
	<tr height="22" class="color-header">		
        <td class="form-title" width="178"><cf_get_lang dictionary_id='58485.Şirket Adı'></td>
		<td class="form-title" width="271" class="form-title"><cf_get_lang dictionary_id='30031.Lokasyon'></td>
		<td class="form-title" width="229"><cf_get_lang dictionary_id='58763.Depo'></td>
	</tr>
		<cfif get_stores.recordcount>
		<cfoutput query="get_stores"><tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td width="178">#NICK_NAME#</td>
				<td>#ZONE_NAME# / #BRANCH_NAME#</td>
				<td><a href="javascript://" class="tableyazi"  onClick="gonder(#department_id#,'#department_head#')">#department_head#</a></td>
			</tr>		
	</cfoutput>
	<cfelse>
	<tr class="color-row">
		<td colspan="4" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
	</tr>
	</cfif>
</table>
</td>
</tr>
</table>
