<cfdirectory directory="#upload_folder#pda\label_print" name="PdaQueryList" sort="datelastmodified" filter="*.txt" action="list">
<cfparam name="attributes.modal_id" default="">
<cfquery name="get_PdaQueryList" dbtype="query">
	SELECT * FROM PdaQueryList WHERE DATELASTMODIFIED >= #DATEADD('d',-2,now())# AND DATELASTMODIFIED <= #DATEADD('d',2,now())# ORDER BY DATELASTMODIFIED DESC
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Dosya Ekle','57515')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='29800.Dosya Adı'></th>
					<th><cf_get_lang dictionary_id='58466.Değiştirilme Tarihi'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_PdaQueryList.recordcount>
					<cfloop query="get_PdaQueryList">
						<cfoutput>
							<tr>
								<td>#currentrow#</td>
								<td><a href="javascript://" onClick="down_barcode('#name#');" class="tableyazi">#name#</a></td>
								<td>#DateFormat(datelastmodified,dateformat_style)# #TimeFormat(datelastmodified,'HH:MM:SS')#</td>
							</tr>
						</cfoutput>
					</cfloop>
				<cfelse>
					<tr>
						<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</cf_box>
</div>
<script type="text/javascript">
function down_barcode(name)
{
	<cfif isdefined("attributes.barcode_name")>
		<cfif not isdefined("attributes.draggable")>window.opener.</cfif><cfoutput>#barcode_name#</cfoutput>.value = name;
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>
