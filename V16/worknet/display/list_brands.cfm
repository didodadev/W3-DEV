<cfset getBrand = createObject("component","V16.worknet.query.worknet_member").getBrand(member_id:attributes.cpid)>
<cf_flat_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='44592.İsim'></th>
			<th width="20"><a href="javascript://"><i class="fa fa-plus"></i></a></th>
		</tr>
	</thead>
	<cfif getBrand.recordcount>
		<cfoutput query="getBrand">
			<tr>
				<td>
					<a target="_blank" href="#file_web_path#member/#brand_logo_path#">#brand_name#</a>
				</td>
				<td>
					<a href="javascript://" onClick="AjaxPageLoad('#request.self#?fuseaction=worknet.form_brands&bid=#brand_id#&cpid=#attributes.cpid#','body_brands',0,'Loading..')"><i class="fa fa-pencil"></i></a>
				</td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
		</tr>
	</cfif>
</cf_flat_list>

