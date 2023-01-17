<cfinclude template="../query/get_app.cfm">
<cfsetting showdebugoutput="no">
<table>
	<tr>
		<td valign="middle" align="center">
			<cfif len(get_app.photo)>
				<cf_get_server_file output_file="hr/#get_app.photo#" output_server="#get_app.photo_server_id#" image_width="235" output_type="0"  image_link="1">
			<cfelse>
				<cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !
			</cfif>
		</td>
	</tr>
</table>

