<cfsavecontent variable="message"><cf_get_lang dictionary_id='37454.Raf Tipleri'></cfsavecontent>
<cf_box title="#message#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfinclude template="../query/get_shelves.cfm">
	<cf_flat_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='37110.Raf Tipi'></th>
				<th width="15"></th>
			</tr>
			</thead>
			<tbody>
			<cfif get_shelves.recordcount>
				<cfoutput query="get_shelves">
					<tr>
						<td> <a href="javascript://" onclick="add_shelf('#SHELF_NAME#',#SHELF_MAIN_ID#);" clasS="tableyazi">#SHELF_NAME#</a></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="1"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_flat_list>
</cf_box>
<script type="text/javascript">
	function add_shelf(shelf_name,shelf_id)
	{
		<cfif isdefined("attributes.shelf_name")>
			<cfif not isdefined("attributes.draggable")>window.opener.</cfif><cfoutput>#shelf_name#</cfoutput>.value = shelf_name;
		</cfif>
		<cfif isdefined("attributes.shelf_id")>
			<cfif not isdefined("attributes.draggable")>window.opener.</cfif><cfoutput>#shelf_id#</cfoutput>.value = shelf_id;
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>

	}
</script>
