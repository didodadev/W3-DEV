<cfset get_action = createObject('component','V16.content.display.contes.cfc.components')>
<cfset get_cates = get_action.GET_CATES()>
<div class="row">
	<div class="col col-6 uniqueRow">
		<div class="cntTableContainer">
			<div class="cntTableHeader">
				<span class="cntTableHeaderText"><cf_get_lang dictionary_id="58137.Kategoriler"></span>
				<ul class="cntTableHeaderBtns">
					<li data-button="add" data-table="cates"><i class="fa fa-plus"></i></li>
					<li><a href="#home"><i class="fa fa-undo"></i></a></li>					
				</ul>
			</div>
			<div id="returnmessage"></div>
				<table class="cntTable" id="cates" data-action="cates">
					<thead>
						<tr>
							<th>#</th>
							<th>Name</th>
							<th>Description</th>
							<th>Language</th>
							<th></th>
						</tr>
					</thead>
					<tbody>
						<cfoutput query="GET_CATES">
							<tr data-id="#CONTENTCAT_ID#">
								<td data-key>#get_cates.CurrentRow#</td>
								<td data-upd="CONTENTCAT">#CONTENTCAT#</td> 
								<td data-upd="CONTENTCAT_ALT1">#CONTENTCAT_ALT1#</td>
								<td data-upd="LANGUAGE_ID">#LANGUAGE_ID#</td>
								<td><span data-button="upd" class="contesTextBtn font-yellow-crusta"><cf_get_lang dictionary_id="57464.Güncelle"></span><span data-button="delete" class="contesTextBtn font-red-mint"><cf_get_lang dictionary_id="59032.Sil"></span></td>
							</tr>
						</cfoutput>					
				</tbody>
			</table>
		</div>
	</div>
</div>