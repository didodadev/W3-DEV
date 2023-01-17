<cfparam name="attributes.status" default="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("url.event") and url.event eq 'popUp'>
	<cfset url_string = "">
	<cfif isdefined("field_id")><cfset url_string = "#url_string#&field_id=#field_id#"></cfif>
	<cfif isdefined("field_name")><cfset url_string = "#url_string#&field_name=#field_name#"></cfif>
	<cfset action_file = "#request.self#?fuseaction=hr.list_complaints&event=popUp#url_string#">
<cfelse>
	<cfset action_file = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_complaints">
</cfif>
<cfif isdefined("attributes.is_submit")>
  <cfset get_complaint_list = createObject("component","V16.hr.cfc.setupComplaints").getComplaints(is_default:attributes.status,keyword:attributes.keyword)>
<cfelse>
	<cfset get_complaint_list.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_complaint_list.recordcount#">
<cfform name="list_complaint" action="#action_file#" method="post">
	<input type="hidden" name="is_submit" id="is_submit" value="1">
	<cf_box closable="0" collapsable="0">
		<cf_box_search plus="0">
			<div class="form-group">
				<cfinput type="text" name="keyword" id="keyword" placeholder="#getLang('main',48)#" value="#attributes.keyword#" maxlength="50">
			</div>
			<div class="form-group">
				<select name="status" id="status">
					<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
					<option value="1" <cfif attributes.status is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
					<option value="0" <cfif attributes.status is 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
				</select>
			</div>
			<div class="form-group small">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)" style="width:25px;">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4">
			</div>
		</cf_box_search>
</cf_box>
</cfform>
<cf_box closable="0" collapsable="0" title="#getLang('hr',800)#" add_href = "#request.self#?fuseaction=hr.list_complaints&event=add">
	<cf_grid_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='58577.Sıra'></th>
				<th><cf_get_lang dictionary_id='56623.Tanı'></th>
				<th><cf_get_lang dictionary_id='58585.Kod'></th>
				<th><cf_get_lang dictionary_id='43121.Kayıt Eden'></th>
				<th ><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
				<th width="30" class="text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_complaints&event=add"><i class="fa fa-plus"></i></a></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_complaint_list.recordcount>
				<cfoutput query="get_complaint_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td><cfif isdefined("url.event") and url.event eq 'popUp'><a href="javascript://" onclick="gonder('#complaint_id#','#jsStringFormat(complaint)#');" class="tableyazi"><cfelse><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_complaints&event=upd&complaint_id=#complaint_id#" class="tableyazi"></cfif>#complaint#</a></td>
						<td>#code#</td>
						<td>#get_emp_info(RECORD_EMP,0,1)#</td>         
						<td>#dateFormat(record_date,dateformat_style)#</td>
						<td class="text-center"><cfif isdefined("url.event") and url.event eq 'popUp'><a href="javascript://" onclick="gonder('#complaint_id#','#jsStringFormat(complaint)#');"><cfelse><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_complaints&event=upd&complaint_id=#complaint_id#"><i class="fa fa-pencil"></i></cfif></a></td>
					</tr>
				</cfoutput>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif get_complaint_list.recordcount eq 0>
		<div class="ui-info-bottom">
			<p><cfif isdefined('attributes.is_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></p>
		</div>
	</cfif>
<cfif get_complaint_list.recordcount and (attributes.totalrecords gt attributes.maxrows)>
	<cfset url_str = "">
	<cfif len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif len(attributes.status)>
		<cfset url_str = "#url_str#&status=#attributes.status#">
	</cfif>
	<cfif len(attributes.is_submit)>
		<cfset url_str = "#url_str#&is_submit=#attributes.is_submit#">
	</cfif>              	              
	<cf_paging page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="#listgetat(attributes.fuseaction,1,'.')#.list_complaints#url_str#"> 
</cfif>
</cf_box>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function gonder(id,name)
	{ 
		<cfif isDefined("attributes.field_id")>
		
			<cfif listlen(attributes.field_id,".") eq 1>
			
				<cfoutput>
					window.opener.document.getElementById("#attributes.field_id#").value=id;
				</cfoutput>
			<cfelse>
				window.opener.document.<cfoutput>#attributes.field_id#</cfoutput>.value=id;
			</cfif>
		</cfif>
		<cfif isDefined("attributes.field_name")>
		
			<cfif listlen(attributes.field_name,".") eq 1>
				<cfoutput>
					window.opener.document.getElementById("#attributes.field_name#").value=name;
					window.opener.document.getElementById("#attributes.field_name#").focus();
				</cfoutput>
			<cfelse>
				window.opener.document.<cfoutput>#attributes.field_name#</cfoutput>.value=name;
				window.opener.document.<cfoutput>#attributes.field_name#</cfoutput>.focus();
			</cfif>
		</cfif>
		window.close();
	}
</script>