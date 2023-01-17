<cfset get_action = createObject('component','V16.content.display.contes.cfc.components')>
<cfset get_sites = get_action.GET_SITES()>
<cfset get_pages = get_action.GET_PAGES()>
<cfset get_component = get_action.GET_COMPONENT()>
<div class="row">
	<div class="col col-6 col-sm-12 uniqueRow">
		<div class="cntTableContainer">
			<div class="cntTableHeader">
				<span class="cntTableHeaderText">Sites</span>
				<ul class="cntTableHeaderBtns">
					<li data-button="add" data-table="sites"><i class="fa fa-plus"></i></li>
					<li><a href="#home"><i class="fa fa-undo"></i></a></li>					
				</ul>
			</div>
				<table class="cntTable" id="sites" data-action="sites">
					<thead>
						<tr>
							<th>Id</th>
							<th>Name</th>
							<th>Path</th>
							<th></th>
						</tr>
					</thead>
					<tbody>
						<tr data-id="0">
							<td data-key>0</td>
							<td data-upd="SITE_NAME">SA</td> 
							<td data-upd="SITE_PATH">SA</td>
							<td><span data-button="upd" class="contesTextBtn font-yellow-crusta"><cf_get_lang dictionary_id="57464.Güncelle"></span><span data-button="delete" class="contesTextBtn font-red-mint"><cf_get_lang dictionary_id="59032.Sil"></span></td>
						</tr>
						<cfoutput query="get_sites">
							<tr data-id="#SITE_ID#">
								<td data-key>#SITE_ID#</td>
								<td data-upd="SITE_NAME">#SITE_NAME#</td> 
								<td data-upd="SITE_PATH">#SITE_PATH#</td>
								<td><span data-button="upd" class="contesTextBtn font-yellow-crusta"><cf_get_lang dictionary_id="57464.Güncelle"></span><span data-button="delete" class="contesTextBtn font-red-mint"><cf_get_lang dictionary_id="59032.Sil"></span></td>
							</tr>
						</cfoutput>					
				</tbody>
			</table>
		</div>
	</div>	
</div>
<div class="row">
	<div class="col col-6 col-sm-12 uniqueRow">
		<div class="cntTableContainer">
			<div class="cntTableHeader">
				<span class="cntTableHeaderText">Pages</span>
				<ul class="cntTableHeaderBtns">
					<li data-button="add" data-table="pages"><i class="fa fa-plus"></i></li>
					<li><a href="#home"><i class="fa fa-undo"></i></a></li>					
				</ul>
			</div>
				<table class="cntTable" id="pages" data-action="pages">
					<thead>
						<tr>
							<th>D</th> 
							<th>SITE</th>
							<th>FRIENDLY_URL</th>
							<th>HEAD</th>
							<th></th>
						</tr>
					</thead>
					<tbody>
						<tr data-id="0">
							<td data-key>0</td>
							<td data-upd="SITE_ID">0</td> 
							<td data-upd="PAGE_FRIENDLY_URL">SA</td>
							<td data-upd="PAGE_HEAD">SA</td>
							<td><span data-button="upd" class="contesTextBtn font-yellow-crusta"><cf_get_lang dictionary_id="57464.Güncelle"></span><span data-button="delete" class="contesTextBtn font-red-mint"><cf_get_lang dictionary_id="59032.Sil"></span></td>
						</tr>
						<cfoutput query="get_pages">
							<tr data-id="#PAGE_ID#">
								<td data-key>#PAGE_ID#</td>
								<td data-upd="SITE_ID">#SITE_ID#</td> 
								<td data-upd="PAGE_FRIENDLY_URL">#PAGE_FRIENDLY_URL#</td>
								<td data-upd="PAGE_HEAD">#PAGE_HEAD#</td>
								<td><span data-button="upd" class="contesTextBtn font-yellow-crusta"><cf_get_lang dictionary_id="57464.Güncelle"></span><span data-button="delete" class="contesTextBtn font-red-mint"><cf_get_lang dictionary_id="59032.Sil"></span></td>
							</tr>
						</cfoutput>					
				</tbody>
			</table>
		</div>
	</div>
</div>
<div class="row">
	<div class="col col-6 col-sm-12 uniqueRow">
		<div class="cntTableContainer">
			<div class="cntTableHeader">
				<span class="cntTableHeaderText">Component</span>
				<ul class="cntTableHeaderBtns">
					<li data-button="add" data-table="component"><i class="fa fa-plus"></i></li>
					<li><a href="#home"><i class="fa fa-undo"></i></a></li>					
				</ul>
			</div>
				<table class="cntTable" id="component" data-action="component">
					<thead>
						<tr>
							<th>COMPONENT_ID</th>
							<th>PAGE</th>
							<th>NAME</th>
							<th>PATH</th>
							<th></th>
						</tr>
					</thead>
					<tbody>
						<tr data-id="0">
							<td data-key>0</td>
							<td data-upd="PAGE_ID">0</td> 
							<td data-upd="COMPONENT_NAME">SA</td> 
							<td data-upd="PATH">SA</td>
							<td><span data-button="upd" class="contesTextBtn font-yellow-crusta"><cf_get_lang dictionary_id="57464.Güncelle"></span><span data-button="delete" class="contesTextBtn font-red-mint"><cf_get_lang dictionary_id="59032.Sil"></span></td>
						</tr>
						<cfoutput query="get_component">
							<tr data-id="#COMPONENT_ID#">
								<td data-key>#COMPONENT_ID#</td>
								<td data-upd="PAGE_ID">#PAGE_ID#</td> 
								<td data-upd="COMPONENT_NAME">#COMPONENT_NAME#</td> 
								<td data-upd="PATH">#PATH#</td>
								<td><span data-button="upd" class="contesTextBtn font-yellow-crusta"><cf_get_lang dictionary_id="57464.Güncelle"></span><span data-button="delete" class="contesTextBtn font-red-mint"><cf_get_lang dictionary_id="59032.Sil"></span></td>
							</tr>
						</cfoutput>					
				</tbody>
			</table>
		</div>
	</div>
</div>
