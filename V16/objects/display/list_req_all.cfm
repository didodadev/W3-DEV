<cfset cfc=createObject("component","V16.training_management.cfc.training_survey")> 
<cfset url_string = "">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.req_year" default="#session.ep.period_year#">
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#url.field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#url.field_name#">
</cfif>
<cfset adres = "">
<cfif len(attributes.keyword)>
	<cfset adres = "#adres#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.req_year)>
	<cfset adres = "#adres#&req_year=#attributes.req_year#">
</cfif>
<cfset GET_REQS=cfc.GetReqs(req_year:attributes.req_year)>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GET_REQS.recordCount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>	
<script type="text/javascript">
	function add_store(in_coming_id,in_coming_name)
	{
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = in_coming_id;
		<cfif isdefined("attributes.field_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = in_coming_name;
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='58709.Yetkinlikler'></cfsavecontent>
<div class="col col-12 col-xs-12">
	<cf_box title="#message#" scroll="0" collapsable="1" resize="1"  popup_box="#iif(isdefined("attributes.draggable"),1,0)#">			
		<cfform name="search_req" action="#request.self#?fuseaction=objects.popup_list_req#url_string#" method="post">
			<cf_box_search>
				<div class="form-group" id="keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" style="width:100px;" value="#attributes.keyword#">
				</div>	
				<div class="form-group" id="keyword">
					<select name="req_year" id="req_year">
						<cfloop from="#year(now())-3#" to="#year(now())#" index="j">
							<cfoutput><option value="#j#" <cfif attributes.req_year eq j>selected</cfif>>#j#</option></cfoutput>
						</cfloop>
					</select>
				</div>	
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_req' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_flat_list>
			<thead>
				<tr> 
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57907.Yetkinlik'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_reqs.recordcount>
				<cfoutput query="get_reqs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#currentrow#</td>
					<td><a href="javascript://" onClick="add_store('#req_type_id#','#req_type#')" class="tableyazi">#req_type#</a></td>
				</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<table width="99%" border="0" cellpadding="0" cellspacing="0" height="35" align="center" >
				<tr>
					<td><cf_pages
					page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="objects.popup_list_req#adres##url_string#"></td>
					<!-- sil -->
					<td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
					<!-- sil -->
				</tr>
			</table>
		</cfif>
	</cf_box>
</div>
