<cfset get_action = createObject('component','AddOns.Atwork.protein.cfc.components')>
<cfset get_sites = get_action.GET_SITES()>
<cfset get_pages = get_action.GET_PAGES()>
<cfset get_component = get_action.GET_COMPONENT()>

			
<cfform name="search" action="" method="post">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.form_varmi" default="">
<cfparam name="attributes.status" default="">
<input type="hidden" name="form_varmi" id="form_varmi" value="1">	 
<div class="col col-12">
		<h3 class="workdevPageHead">Siteler</h3>
</div> 		
			<div class="row form-inline">
                <div class="form-group">
                    <div class="input-group">
                    	<input type="text" name="keyword" id="keyword" placeholder="<cf_get_lang_main no='48.Filtre'>" value="<cfoutput>#attributes.keyword#</cfoutput>" maxlength="50">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                    	<select name="status" id="status">
                    	    <option value="1" <cfif attributes.status eq 1>selected</cfif>>Aktif</option>
                    	    <option value="2" <cfif attributes.status eq 2>selected</cfif>>Pasif</option>
						</select>
					</div>
				</div>
				<div class="form-group">
                    <cf_wrk_search_button>
                </div>
				<div class="form-group">
                    <cfoutput>
					<a href="#request.self#?fuseaction=protein.sites&event=add" class="btn grey-cascade btn-small icon-pluss margin-left-5"></a>
					</cfoutput>
                </div>
			</div>
 
</cfform>
<cfif attributes.form_varmi eq 1>
	<cfset getUtilities.recordcount = 0>
<cfelse>
	<cfset getUtilities.recordcount = 0>
</cfif>
<cf_medium_list>
	<thead>
		<tr height="20">
			<th>No</th>
			<th>Domain</th>
			<th>Aktif</th>
			<th>Yayın</th>
			<th>Bakım</th>
			
		</tr>
	</thead>
	<tbody>
		<cfoutput query="get_sites">
			<tr data-id="#MENU_ID#">
				<td data-key>#MENU_ID#</td>
				<td data-upd="SITE_NAME"><a href="#request.self#?fuseaction=protein.sites&event=upd&menu_id=#MENU_ID#">#MENU_NAME#</a></td> 
			    <!---<td data-upd="SITE_PATH"><a href="#request.self#?fuseaction=protein.sites&event=upd&menu_id=#MENU_ID#">#SITE_PATH#</a></td>--->
				<td></td>
				<td></td>
				<td colspan="2"></td>
			</tr>
		</cfoutput>			 
	</tbody>
</cf_medium_list>