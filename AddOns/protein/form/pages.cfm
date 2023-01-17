<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.layout_status" default="1">

<cfinclude template="../query/get_site_layouts.cfm">

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_site_layouts.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfform name="filter" action="#request.self#?fuseaction=protein.sites&event=upd&menu_id=#attributes.menu_id#" method="post">
    <input type="hidden" name="is_submit" id="is_submit" value="1">
	<input type="hidden" name="tab_menu" id="tab_menu" value="protein-pages">

            <!-- sil -->
		<div class="row">
			<div class="col col-12 uniqueRow">
				<div class="col col-12 col-md-12 col-xs-12 col-sm-12">
					<div class="form-group require">						
						<cfoutput>
						<div class="col col-2 col-sm-12">
							<input type="text" class="form-control" name="keyword" id="keyword" value="#attributes.keyword#" placeholder="Filtrele" maxlength="255">
						</div>
						<div class="col col-1col-sm-12">
							<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<input type="text" class="form-control" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:30px !important;">
						</div>
						<div class="col col-3 col-sm-12"><cf_wrk_search_button></div>
						</cfoutput>					
					</div>
				</div>
			</div>
		</div>
            <!-- sil -->

</cfform>

<div class="row">
	<div class="col col-12 uniqueRow">
		<div class="col col-12 col-md-12 col-xs-12 col-sm-12">
			<div class="form-group require">
				<table class="cart_summary">
					<thead>
						<tr>
							<th><cfoutput>#getLang('main',1165)#</cfoutput></th>
							<th>Page</th>
							<th><cfoutput>#getLang('main',217)#</cfoutput></th>
							<th><cfoutput>#getLang('main',1682)#</cfoutput></th>
							<th class="header_icn_none"><cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=protein.popup_add_site_objects','medium');"><img src="/images/plus_list.gif"></a></cfoutput></th>
						</tr>
					</thead>
					<tbody>
						<cfif get_site_layouts.recordcount>
							
						<cfset x=0>
						<cfoutput query="get_site_layouts" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfset x=x+1>
						<tr id="big_basket_row_">
							<td class="cart_product">
								#x#
							</td>
							<td class="cart_description">
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=protein.popup_select_site_objects&faction=#faction#&menu_id=#menu_id#<cfif GET_MAIN_MENU.site_type eq 4>&is_pda=1</cfif>','page');" class="tableyazi">#faction#</a>
								
							</td>
							<td class="aciklama">#header#</td>           
							<td class="yayin">
								<span></span>
							</td>
							<!-- sil -->
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=protein.popup_select_site_objects&faction=#faction#&menu_id=#GET_SITE_LAYOUTS.menu_id#<cfif GET_MAIN_MENU.site_type eq 4>&is_pda=1</cfif>','page');"><img src="/images/update_list.gif"></a></td>
							<!-- sil -->
						</tr>
						</cfoutput>
						<cfelse>
							<tr>
								<td colspan="6"><cfif isdefined("attributes.is_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif></td>
							</tr>
						</cfif>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>
<!----
<cf_big_list>
	<thead>
		<tr>
			<th><cf_get_lang_main no='169.Page'></td>
			<th style="width:150px;"><cf_get_lang_main no='1874.Sites'>/<cf_get_lang no ='891.Menü'></th>
			<th class="header_icn_none"><cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=protein.popup_add_site_objects','medium');"><img src="/images/plus_list.gif"></a></cfoutput></th>
			
		</tr>
	</thead>
	<tbody>
		<cfif get_site_layouts.recordcount>
			<cfset menu_id_list=''>       
			<cfoutput query="get_site_layouts">
				<cfif len(menu_id) and not listfind(menu_id_list,menu_id)>
					<cfset menu_id_list = Listappend(menu_id_list,menu_id)>
				</cfif>	
				</cfoutput>
			<cfif len(menu_id_list)>
				<cfset menu_id_list=listsort(menu_id_list,"numeric","ASC",",")>
					<cfquery name="GET_MENU_" datasource="#DSN#">
						SELECT MENU_NAME,MENU_ID, SITE_TYPE FROM MAIN_MENU_SETTINGS WHERE MENU_ID IN (#menu_id_list#) ORDER BY MENU_ID ASC
					</cfquery>
				<cfset menu_id_list=listsort(valuelist(get_menu_.menu_id),"numeric","ASC",",")>
			</cfif>
			<cfoutput query="get_site_layouts" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=protein.popup_select_site_objects&faction=#faction#&menu_id=#menu_id#<cfif get_menu_.site_type[listfind(menu_id_list,get_site_layouts.menu_id,',')] eq 4>&is_pda=1</cfif>','page');" class="tableyazi">#faction#</a></td>
                    <td width="250">
                    	<a href="#request.self#?fuseaction=protein.form_upd_main_menu&menu_id=#menu_id#" class="tableyazi"><cfif len(menu_id)>#get_menu_.menu_name[listfind(menu_id_list,get_site_layouts.menu_id,',')]#</cfif></a>			  
                    </td>--->
                    <!-- sil -->
                <!----    <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=protein.popup_select_site_objects&faction=#faction#&menu_id=#GET_SITE_LAYOUTS.menu_id#<cfif get_menu_.site_type[listfind(menu_id_list,get_site_layouts.menu_id,',')] eq 4>&is_pda=1</cfif>','page');"><img src="/images/update_list.gif"></a></td>
                    <!-- sil -->--->
            <!----    </tr>
            </cfoutput>
		<cfelse>
			<tr>
				<td colspan="3"><cfif isdefined("attributes.is_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>--->
<cfif attributes.maxrows lt attributes.totalrecords>

				<cfset url_string = "">
				<cfif len(attributes.keyword)>
				<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
				</cfif>
				<cfif isdefined("attributes.selected_link") and len(attributes.selected_link)>
				<cfset url_string = "#url_string#&selected_link=#attributes.selected_link#">
				</cfif>
				<cfif isdefined("attributes.menu_id") and len(attributes.menu_id)>
				<cfset url_string = "#url_string#&menu_id=#attributes.menu_id#">
				</cfif>
				
				   
				<cfset adres = "#request.self#?fuseaction=protein.sites&event=upd&menu_id=#attributes.menu_id#&tab_menu=protein-pages">
				<cf_paging
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#adres##url_string#"> </td>
		
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
