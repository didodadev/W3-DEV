<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.selected_link" default="">
<cfparam name="attributes.menu_id" default="">
<cfparam name="attributes.layout_status" default="1">
<cfif isdefined("attributes.is_submit")>
	<cfinclude template="../query/get_site_layouts.cfm">
<cfelse>
	<cfset get_site_layouts.recordcount = 0>   
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_site_layouts.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="GET_MAIN_MENU" datasource="#DSN#">
	SELECT MENU_NAME, MENU_ID FROM MAIN_MENU_SETTINGS ORDER BY MENU_NAME
</cfquery>
<cfinclude template="../protein_upper.cfm">
<cfform name="filter" action="#request.self#?fuseaction=protein.list_site_layouts" method="post">
    <input type="hidden" name="is_submit" id="is_submit" value="1">
   <cf_big_list_search title="#getLang('settings',1456)#">
        <cf_big_list_search_area>
            <!-- sil -->
			<div class="row">
					<div class="row form-inline">
						<div class="form-group">
							<div class="input-group">										
								<input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" placeholder="Filtrele" maxlength="255">
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<select name="menu_id" id="menu_id" style="width:175px;">
									<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
									<cfoutput query="get_main_menu">
									<option value="#menu_id#" <cfif attributes.menu_id eq menu_id>selected</cfif>>#menu_name#</option>
									</cfoutput>
								</select>
							</div>
						</div>
							<div class="form-group">
								<div class="input-group x-3_5">
							<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:30px;">
								</div>
							</div>
							 <div class="form-group"><cf_wrk_search_button></div>							
						</div>
					</div>
			</div>				
            <!-- sil -->
		</cf_big_list_search_area>
    </cf_big_list_search>
    
</cfform>


	 <cf_big_list>
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
							<cfset x=0>
							<cfoutput query="get_site_layouts" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfset x=x+1>
								<tr>
									<td class="cart_product">
										#x#
									</td>
									<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=protein.popup_select_site_objects&faction=#faction#&menu_id=#menu_id#<cfif get_menu_.site_type[listfind(menu_id_list,get_site_layouts.menu_id,',')] eq 4>&is_pda=1</cfif>','page');" class="tableyazi">#faction#</a></td>
									
									<td class="aciklama">#header#</td>           
									<td class="yayin">										
									</td>
									<!-- sil -->
									<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=protein.popup_select_site_objects&faction=#faction#&menu_id=#GET_SITE_LAYOUTS.menu_id#<cfif get_menu_.site_type[listfind(menu_id_list,get_site_layouts.menu_id,',')] eq 4>&is_pda=1</cfif>','page');"><img src="/images/update_list.gif"></a></td>
									<!-- sil -->
								</tr>
							</cfoutput>
						<cfelse>
							<tr>
								<td colspan="5"><cfif isdefined("attributes.is_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif></td>
							</tr>
						</cfif>
					</tbody>
		
				<cfif attributes.maxrows lt attributes.totalrecords>
				<table cellpadding="0" cellspacing="0" border="0" width="98%" height="35" align="center">
					<tr>
						<td>
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
							<cfif len(attributes.is_submit)>
							<cfset url_string = "#url_string#&is_submit=#attributes.is_submit#">
							</cfif>      
							<cfset adres = "protein.list_site_layouts">
							<cf_pages page="#attributes.page#" 
								maxrows="#attributes.maxrows#"
								totalrecords="#attributes.totalrecords#"
								startrow="#attributes.startrow#"
								adres="#adres##url_string#"> </td>
						<!-- sil -->
						<td align="right" style="text-align:right;"> <cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
						<!-- sil -->
					</tr>
				</table>
				</cfif>
	</cf_big_list>








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
                    </td>
                    <!-- sil -->---->
                   <!---- <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=protein.popup_select_site_objects&faction=#faction#&menu_id=#GET_SITE_LAYOUTS.menu_id#<cfif get_menu_.site_type[listfind(menu_id_list,get_site_layouts.menu_id,',')] eq 4>&is_pda=1</cfif>','page');"><img src="/images/update_list.gif"></a></td>
                    <!-- sil -->--->
                <!----</tr>
            </cfoutput>
		<cfelse>
			<tr>
				<td colspan="3"><cfif isdefined("attributes.is_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cfif attributes.maxrows lt attributes.totalrecords>
	<table cellpadding="0" cellspacing="0" border="0" width="98%" height="35" align="center">
		<tr>
			<td>
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
				<cfif len(attributes.is_submit)>
				<cfset url_string = "#url_string#&is_submit=#attributes.is_submit#">
				</cfif>      
				<cfset adres = "protein.list_site_layouts">
				<cf_pages page="#attributes.page#" 
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#adres##url_string#"> </td>---->
		<!----	<!-- sil -->
		<!----	<td align="right" style="text-align:right;"> <cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>---->
			<!-- sil -->---->
		<!----</tr>
	</table>
</cfif>---->
<cfinclude template="../protein_footer.cfm">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
