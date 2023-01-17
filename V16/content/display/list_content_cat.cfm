<script type="text/javascript">
	function yolla(id,alan)
	{
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.id#</cfoutput>.value  = id;
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.alan#</cfoutput>.value = alan;
        <cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>
<cfinclude template="../query/get_content_cat.cfm">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='42127.İçerik Kategorileri'></cfsavecontent>
	<cf_box title="#title#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">		
		<cf_flat_list>
			<thead>
				<tr>
					<th style="width:20px;"><cf_get_lang_main no='75.No'></th>
					<th><cf_get_lang_main no='74.Kategori'></th>
				</tr>
			</thead>
			<tbody>
			<cfoutput query="GET_CONTENT_CAT">
				<tr>
					<td>#contentcat_id#</td>
					<td><a href="##" onClick="yolla('#contentcat_id#','#contentcat#')">#contentcat#</a></td>
				</tr>
			</cfoutput>
			</tbody>
		</cf_flat_list>
	</cf_box>
</div>