<cfparam name="attributes.status" default="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.is_submit")>
   <cfset get_medicine_list = createObject("component","V16.hr.cfc.setupDecisionmedicine").getDecisionmedicine(is_default:attributes.status,keyword:attributes.keyword)>
<cfelse>
	<cfset get_medicine_list.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_medicine_list.recordcount#">
<cfsavecontent variable="title"><cf_get_lang dictionary_id="55882.ilaç ve tıbbi malzemeler"></cfsavecontent>
<cfform name="list_decisionmedicine" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_decisionmedicine" method="post">
<input type="hidden" name="is_submit" id="is_submit" value="1">
	<cf_box closable="0" collapsable="0">
		<cf_box_search>
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
<cf_box closable="0" collapsable="0" title="#title#" add_href = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_decisionmedicine">
	<cf_grid_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='58577.Sıra'></th>
				<th><cf_get_lang no='797.İlaç İsimleri'></th>
				<th><cf_get_lang dictionary_id='57633.Barkod'></th>
				<th><cf_get_lang dictionary_id='58585.Kod'></th>
				<th><cf_get_lang dictionary_id='43121.Kayıt Eden'></th>
				<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
				<th class="text-center"><span class="fa fa-plus"></span></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_medicine_list.recordcount>
				<cfoutput query="get_medicine_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr class="color-row">
					<td width="20">#currentrow#</td>
					<td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_decisionmedicine&decision_medicine_id=#drug_id#" class="tableyazi">#DRUG_MEDICINE_NEW#</a></td>
					<td>#barcode#</td>         
                    <td>#code#</td> 
					<td>#get_emp_info(RECORD_EMP,0,1)#</td>         
                    <td>#dateFormat(record_date,dateformat_style)#</td>
					<td width="20" class="text-center"><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_decisionmedicine&decision_medicine_id=#drug_id#"><i class="fa fa-pencil"></i></a></td>
				</tr>
				</cfoutput>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif get_medicine_list.recordcount eq 0>
		<div class="ui-info-bottom">
			<p><cfif isdefined('attributes.is_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></p>
		</div>
	</cfif>
<cfif get_medicine_list.recordcount and (attributes.totalrecords gt attributes.maxrows)>
	<cfset url_str = "">
	<cfif isdefined("attributes.keyword")>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif isdefined("attributes.status")>
		<cfset url_str = "#url_str#&status=#attributes.status#">
	</cfif>
	<cfif isdefined("attributes.is_submit")>
		<cfset url_str = "#url_str#&is_submit=#attributes.is_submit#">
	</cfif>              	              
	<cf_paging page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="#listgetat(attributes.fuseaction,1,'.')#.list_decisionmedicine#URL_STR#">
</cfif>
</cf_box>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
	
