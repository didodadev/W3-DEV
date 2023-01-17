<cfquery name="get_job_other" datasource="#dsn#">
	SELECT SECTOR_CAT_ID, SECTOR_CAT FROM SETUP_SECTOR_CATS ORDER BY SECTOR_CAT
</cfquery>
<cfparam name="attributes.modal_id" default="">
<script type="text/javascript">
	function gonder(sector_cat_id,sector_cat)
	{
	var kontrol =0;
	uzunluk=<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
	for(i=0;i<uzunluk;i++){
		if(<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==sector_cat_id){
			kontrol=1;
		}
	}
	
	if(kontrol==0){
		<cfif isDefined("attributes.field_name")>
			x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].value = sector_cat_id;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = sector_cat;
		</cfif>
		}
	}
</script>
<cf_box  title="#getLang('','',32585)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_grid_list>	
		<thead><tr><th><cf_get_lang dictionary_id='57579.Sektör'></th></tr></thead>
        <tbody>
            <cfif get_job_other.recordcount>
                <cfoutput query="get_job_other">
                    <tr>
                    <td width="178"><a href="javascript://" class="tableyazi"  onClick="gonder(#sector_cat_id#,'#sector_cat#')">#sector_cat#</a></td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
                </tr>
            </cfif>
        </tbody>
    </cf_grid_list>
</cf_box>

