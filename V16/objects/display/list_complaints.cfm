<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.modal_id" default="">
<cfif isDefined("attributes.assurance_id") and len(attributes.assurance_id)>
	<cfquery name="get_complaints" datasource="#dsn#">
		SELECT 
			SC.COMPLAINT_ID, 
			SC.COMPLAINT ,
			SC.CODE,
			CP.COMPLAINT_PRICE
		FROM 
			SETUP_COMPLAINTS SC LEFT JOIN SETUP_HEALTH_ASSURANCE_TYPE_TREATMENTS SHATT ON SC.COMPLAINT_ID = SHATT.SETUP_COMPLAINT_ID
			LEFT JOIN COMPLAINT_PRICE CP ON CP.COMPLAINT_ID = SC.COMPLAINT_ID
		WHERE
			1=1
				AND SHATT.ASSURANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assurance_id#">
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				<cfif len(attributes.keyword) eq 1>
					AND COMPLAINT LIKE '#attributes.keyword#%'
				<cfelse>
					AND COMPLAINT LIKE '%#attributes.keyword#%'
				</cfif>
			</cfif>
		ORDER BY 
			CODE 
	</cfquery>
<cfelse>
	<cfquery name="get_complaints" datasource="#dsn#">
		SELECT 
			COMPLAINT_ID, 
			COMPLAINT ,
			CODE,
			'' COMPLAINT_PRICE
		FROM 
			SETUP_COMPLAINTS 
		WHERE
			1=1 
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				<cfif len(attributes.keyword) eq 1>
					AND COMPLAINT LIKE '#attributes.keyword#%'
				<cfelse>
					AND COMPLAINT LIKE '%#attributes.keyword#%'
				</cfif>
			</cfif>
		ORDER BY 
			CODE 
	</cfquery>
</cfif>
<cfparam name="attributes.x_rnd_nmbr" default="2">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_complaints.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_string = "">
<cfif isdefined("attributes.field_name") and len(attributes.field_name)>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_id") and len(attributes.field_id)>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.assurance_id") and len(attributes.assurance_id)>
	<cfset url_string = "#url_string#&assurance_id=#attributes.assurance_id#">
</cfif>
<cfif isdefined("attributes.field_price") and len(attributes.field_price)>
	<cfset url_string = "#url_string#&field_price=#attributes.field_price#">
</cfif>
<cfif isdefined("attributes.x_rnd_nmbr") and len(attributes.x_rnd_nmbr)>
	<cfset url_string = "#url_string#&x_rnd_nmbr=#attributes.x_rnd_nmbr#">
</cfif>
<script type="text/javascript">
function gonder(complaint_id,complaint,complaint_price)
{
	<cfif isDefined("attributes.field_id")>		
		<cfif listlen(attributes.field_id,".") eq 1>		
			<cfoutput>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_id#").value=complaint_id;
			</cfoutput>
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value=complaint_id;
		</cfif>
	</cfif>
	<cfif isDefined("attributes.field_name")>	
		<cfif listlen(attributes.field_name,".") eq 1>
			<cfoutput>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_name#").value=complaint;
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_name#").focus();
			</cfoutput>
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value=complaint;
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.focus();
		</cfif>
	</cfif>
	<cfif isDefined("attributes.field_price")>
		if(complaint_price != ''){
			<cfif listlen(attributes.field_price,".") eq 1>
				<cfoutput>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_price#").value=commaSplit(complaint_price,#attributes.x_rnd_nmbr#);
				</cfoutput>
			<cfelse>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_price#</cfoutput>.value=commaSplit(complaint_price,<cfoutput>#attributes.x_rnd_nmbr#</cfoutput>);
			</cfif>
		}
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>

<div class="col col-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='55885.Tedavi Tipleri'></cfsavecontent>
	<cf_box title="#message#" closable="0" collapsable="0" add_href="#request.self#?fuseaction=hr.popup_add_complaints&is_popup=1"popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cf_wrk_alphabet keyword="url_string"  popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform action="#request.self#?fuseaction=objects.popup_list_complaints#url_string#" method="post" name="search">
			<cf_big_list_search_area>        
				<div class="ui-form-list flex-list">
					<div class="form-group" id="keyword">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
						<cfinput type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="255">
					</div>	
					<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4"  search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
					</div>              
				</div>
			</cf_big_list_search_area>
		</cfform>
		<cf_ajax_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='57487.no'></th>
					<th width="75"><cf_get_lang dictionary_id='58585.Kod'></th>
					<th><cf_get_lang dictionary_id='32413.Tanı'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_complaints.recordcount>
					<cfoutput query="get_complaints" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<cfif isdefined("attributes.from_inspection") and attributes.from_inspection eq 1>
						<td><a href="javascript://" class="tableyazi"  onClick="gonder_inspection(#complaint_id#,'#complaint#')">#code#</a></td>
						<td><a href="javascript://" class="tableyazi"  onClick="gonder_inspection(#complaint_id#,'#complaint#')">#complaint#</a></td>
						<cfelse>
						<td><a href="javascript://" class="tableyazi"  onClick="gonder(#complaint_id#,'#complaint#',<cfif len(complaint_price)>#complaint_price#<cfelse>''</cfif>)">#code#</a></td>
						<td><a href="javascript://" class="tableyazi"  onClick="gonder(#complaint_id#,'#complaint#',<cfif len(complaint_price)>#complaint_price#<cfelse>''</cfif>)">#complaint#</a></td>
						</cfif>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="3" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
					</tr>
				</cfif>
			</tbody>
		</cf_ajax_list>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
		</cfif>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cf_paging page="#attributes.page#"
						maxrows="#attributes.maxrows#"
						totalrecords="#attributes.totalrecords#"
						startrow="#attributes.startrow#"
						adres="objects.popup_list_complaints#url_string#"
						isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function gonder_inspection(complaint_id,complaint)
	{
		<cfif isDefined("attributes.field_name")>
			x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].value = complaint_id;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = complaint;
		</cfif>
    }
</script>
