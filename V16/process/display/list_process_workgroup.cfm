<cfparam name="attributes.keyword" default="">
<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
	SELECT
		WORKGROUP_ID,
		WORKGROUP_NAME
	FROM
		PROCESS_TYPE_ROWS_WORKGRUOP
	WHERE
		PROCESS_ROW_ID IS NULL 
		<cfif len(attributes.keyword)>
			AND WORKGROUP_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		</cfif>
	ORDER BY
		WORKGROUP_NAME
</cfquery>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_process_type.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset adres=''>
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset adres = "#adres#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.process_row_id") and len(attributes.process_row_id)>
	<cfset adres = "#adres#&process_row_id=#attributes.process_row_id#">
</cfif>
<cfform name="list_search" action="#request.self#?fuseaction=process.popup_list_process_workgroup" method="post">
    <cf_big_list_search title="#getLang('process',57)#">
        <cf_big_list_search_area>
            <div class="row form-inline">
                    <input type="hidden" name="process_row_id" id="process_row_id" value="<cfoutput>#attributes.process_row_id#</cfoutput>">
                <div class="form-group" id="item-keyword">
					<div class="col col-12 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    	<cfinput type="text" name="keyword" style="width:100px;" placeholder="#message#" value="#attributes.keyword#" maxlength="255">
					</div>
				</div>	
                <div class="form-group x-3_5">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
					<cf_wrk_search_button>
                </div>
            </div>
        </cf_big_list_search_area>
    </cf_big_list_search>
    <cf_medium_list>
        <thead>
            <tr>
                <th width="25"><cf_get_lang dictionary_id="57487.No"></th>
                <th><cf_get_lang dictionary_id="36244.Grup"></th>
                <th><input type="checkbox" id="all_check" name="all_check" value="1" onclick="hepsi();"></th>
            </tr>
        </thead>
        <tbody>
            <cfif get_process_type.recordcount>
                <cfoutput query="get_process_type" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">                 
                    <tr>
                        <td valign="top" width="30">#workgroup_id#</td>
                        <td>#workgroup_name#</td>
                        <td width="2%"><input type="checkbox" name="workgroup_id" id="workgroup_id" value="#workgroup_id#"></td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                </tr>
            </cfif>
        </tbody>
        <tfoot>
            <tr class="color-list">
                <td style="text-align:right;" colspan="3"><input type="button" value="<cf_get_lang dictionary_id='57461.Kaydet'>" onClick="add_checked();"></td>
            </tr>
        </tfoot>
    </cf_medium_list>
</cfform>
<cfif attributes.totalrecords gt attributes.maxrows>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
	<tr>
		<td><cf_pages page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="process.popup_list_process_workgroup&adres=#adres#">
		</td>
		<!-- sil -->
		<td align="right" style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
		<!-- sil -->
	</tr>
</table>
</cfif>
<script type="text/javascript">
<cfif attributes.totalrecords gt attributes.maxrows>
	var recordcount_ = "<cfoutput>#attributes.maxrows#</cfoutput>";
<cfelse>
	var recordcount_ = "<cfoutput>#get_process_type.recordcount#</cfoutput>";
</cfif>
function hepsi()
{
	if(document.getElementById('all_check').checked == true)
	{
		<cfif get_process_type.recordcount gt 1>	
			for(i=0;i<recordcount_;i++) document.all.workgroup_id[i].checked = true;
		<cfelseif get_process_type.recordcount eq 1>
			document.all.workgroup_id.checked = true;
		</cfif>
	}
	else
	{
		<cfif get_process_type.recordcount gt 1>	
			for(i=0;i<recordcount_;i++) document.all.workgroup_id[i].checked = false;
		<cfelseif get_process_type.recordcount eq 1>
			document.all.workgroup_id.checked = false;
		</cfif>
	}
}

function add_checked()
{
	var counter = 0;
	<cfif get_process_type.recordcount gt 1 and attributes.maxrows neq 1>	
		for(i=0;i<recordcount_;i++) 
		if (document.all.workgroup_id[i].checked == true) 
		{
			counter = counter + 1;
		}
		if (counter == 0)
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='36244.Grup'>");
			return false;
		}
	<cfelseif get_process_type.recordcount eq 1 or  attributes.maxrows eq 1>
	if (document.all.workgroup_id.checked == true) 
	{
		counter = counter + 1;
	}
	if (counter == 0)
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='36244.Grup'>");
		return false;
	}
	</cfif>
	list_search.action='<cfoutput>#request.self#?fuseaction=process.emptypopup_add_workgroup_to_process</cfoutput>';
	document.list_search.submit();
}
</script>
