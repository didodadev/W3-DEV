<script type="text/javascript">
	function yolla(id,alan)
	{
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.id#</cfoutput>.value  = id;
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.alan#</cfoutput>.value = alan;
        <cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>
<cfinclude template="../query/get_chapter_menu.cfm">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='58139.Bölümler'></cfsavecontent>
	<cf_box title="#title#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">	
		<cf_flat_list>
			<thead>
				<tr>
					<th><cf_get_lang_main no='75.No'></th>
					<th><cf_get_lang_main no='583.Bölüm'></th>
					<th><cf_get_lang_main no='74.Kategori'></th>
				</tr>
			</thead>
			<tbody>
			<cfoutput query="get_chapter_menu">
				<tr>
					<td>#chapter_id#</td>
					<td><a href="##" onClick="yolla('#chapter_id#','#chapter#')">#chapter#</a></td>
					<td>
						<cfset attributes.contentcat_id = get_chapter_menu.contentcat_id>
						<cfinclude template="../query/get_content_cat_name.cfm">
						#get_content_cat_name.contentcat# 
					</td>
				</tr>
			</cfoutput>
			</tbody>
		</cf_flat_list>
	</cf_box>
</div>
