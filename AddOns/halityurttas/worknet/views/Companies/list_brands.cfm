<cfsetting showdebugoutput="no">
<cfinclude template="../../config.cfm">
<cfset getBrand = objectResolver.resolveByRequest("#addonNS#.components.companies.member").getBrand(member_id:attributes.cpid)>
<table class="ajax_list" style="width:98%;">
	<cfif getBrand.recordcount>
		<cfoutput query="getBrand">
			<tr>
				<td>
					<a target="_blank" href="#file_web_path#member/#brand_logo_path#" class="tableyazi">#brand_name#</a>
				</td>
				<td style="float:right;">
					<a href="javascript://" onClick="AjaxPageLoad('#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['add-brands']['fuseaction']#&bid=#brand_id#&cpid=#attributes.cpid#','body_brands',0,'Loading..')"><img src="/images/update_list.gif"  border="0" title="<cf_get_lang_main no='52.Güncelle'>"></a>
				</td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td colspan="2"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
		</tr>
	</cfif>
</table>

