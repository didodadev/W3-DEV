<cfparam name="attributes.form_submitted" default="">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.form_submitted)>
	<cfquery name="GET_IMS_CODE" datasource="#dsn#">
		SELECT 
			* 
		FROM 
			SETUP_IMS_CODE 
		WHERE
			IMS_CODE_ID IS NOT NULL
			<cfif len(attributes.keyword)>
			AND 
			(
			IMS_CODE_NAME LIKE '%#attributes.keyword#%' OR 
			IMS_CODE LIKE '%#attributes.keyword#%'
			)
			</cfif>
		ORDER BY 
			IMS_CODE
	</cfquery>
	<cfparam name='attributes.totalrecords' default="#get_ims_code.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','IMS Bölge Kodları','49657')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search" method="post" action="#request.self#?fuseaction=objects.popup_list_ims_codes">
			<cf_box_search>
				<input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
				<input type="hidden" name="form_submitted" id="form_submitted" value="1">
				<div class="form-group" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50"  placeholder="#message#">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" tabindex="3" name="maxrows" id="maxrows" required="yes" onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1,250" message="#message#" >
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" is_excel="0" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>

		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='52400.IMS Kodu'> 1001</th>
					<th><cf_get_lang dictionary_id='52254.IMS'> <cf_get_lang dictionary_id ='42529.Bölge Adı'> 1001</th>
					<th><cf_get_lang dictionary_id='52400.IMS Kodu'> 501</th>
					<th><cf_get_lang dictionary_id='52254.IMS'> <cf_get_lang dictionary_id ='42529.Bölge Adı'> 501</th>
				</tr>
			</thead>
			<tbody>
			<cfif len(attributes.form_submitted)>
				<cfif get_ims_code.recordcount>
					<cfoutput query="get_ims_code" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>#ims_code#</td>
							<td><a href="javascript://" class="tableyazi"  onClick="gonder(#ims_code_id#,'#ims_code# #ims_code_name#','#currentrow#')">#ims_code_name#</a></td>
							<td>#ims_code_501#</td>
							<td>#ims_code_501_name#</td>
						</tr>
					</cfoutput>
				<cfelse>
				<tr>
					<td height="20" colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
				</tr>
				</cfif>
				<cfelse>
					<tr>
						<td height="20" colspan="5"><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</td>
					</tr>
				</cfif>
			</tbody>
			
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "">
			<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.field_name)>
			<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
			</cfif>
			<cfif len(attributes.form_submitted)>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
			</cfif>
			<cf_paging 
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="objects.popup_list_ims_codes#url_str#"
					isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
			
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function gonder(society_id,society,id)
{
	var kontrol =0;
	uzunluk = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
	for(i=0;i<uzunluk;i++){
		if(<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==society_id)
		{
			kontrol=1;
		}
}

if(kontrol==0){
	<cfif isDefined("attributes.field_name")>
		x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>. <cfoutput>#attributes.field_name#</cfoutput>.options[x].value = society_id;
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = society;
			<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	</cfif>
	}
}
</script>
