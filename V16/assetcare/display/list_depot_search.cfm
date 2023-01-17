<!---BU SAYFA HEM BASKET, HEM POPUP SAYFA OLARAK KULLANILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<cfsetting showdebugoutput="no">
<cfparam name="depot_type" default="0">
<cfinclude template="../query/get_depot_search.cfm">
<!---  x, y , xb, yb değişkenleri daha sonra değiştirilebilir.
	Hierarchy listesinin uzunluğu ;
	x ise merkez
	y ise cep depodur. Onur P...
--->
<cfset x = 1>
<cfset y = 2>
<cfset xb = "Merkez">
<cfset yb = "Cep">
<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.totalrecords" default='#get_depot_search.recordcount#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>



	<cfif isdefined("attributes.is_submitted") and len(branchs)>
		<cfoutput>
			<cf_grid_list>
				<tr>
					<td class="txtboldblue" width="100"><cf_get_lang dictionary_id='48366.Merkez Şube'>: 
						<cfif len(count_merkez.branch_counted)>#count_merkez.branch_counted#<cfelse>0</cfif>
					</td>
					<td class="txtboldblue"><cf_get_lang dictionary_id='48365.Cep Şube'> :<cfif len(count_cep.branch_counted)>#count_cep.branch_counted#<cfelse>0</cfif></td>
				</tr>
			</cf_grid_list>
		</cfoutput>
	</cfif>
	<cf_grid_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57574.Şirket'></th>
				<th><cf_get_lang dictionary_id='57992.Bölge'></th>
				<th><cf_get_lang dictionary_id='57453.Şube'></th>
				<th><cf_get_lang dictionary_id='43244.Şube Tipi'></th>
				<th><cf_get_lang dictionary_id='55661.Açılış Tarihi'></th>
				<th><cf_get_lang dictionary_id='41194.Telefon Numarası'> 1</th>
				<th><cf_get_lang dictionary_id='41194.Telefon Numarası'> 2</th>
				<th><cf_get_lang dictionary_id='57488.Fax'></th>
				<th width="20"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='58875.Çalışanlar'>"></i></th>
			</tr>
		</thead>
		<tbody>
			<cfif isdefined("attributes.is_submitted")>
				<cfif get_depot_search.recordcount>
					<cfoutput query="get_depot_search" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfset branch_hierarchy = (hierarchy)>
						<tr>
							<td>#company_name#</td>
							<td>#zone_name#</td>
							<td><cfloop from="1" to="#listlen(hierarchy,".")#" index="i"></cfloop><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_detail_branch2&id=#branch_id#');">#branch_name#</a></td>
							<td>
								<cfif len(hierarchy)>
									<cfif ListLen(branch_hierarchy,".") eq x>#xb#</cfif>
									<cfif ListLen(branch_hierarchy,".") eq y>#yb#</cfif>
								</cfif>
							</td>
							<td>#dateformat(foundation_date,dateformat_style)#</td>
							<td><cfif len(branch_tel1)><a href="tel://#branch_telcode##branch_tel1#">#branch_telcode#  #branch_tel1#</a></cfif></td>
							<td><cfif len(branch_tel2)><a href="tel://#branch_telcode##branch_tel1#">#branch_telcode#  #branch_tel2#</a></cfif></td>
							<td><cfif len(branch_fax)>#branch_telcode#  #branch_fax#</cfif></td>
							<td width="15"><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_branch_position&branch_id=#branch_id#');"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='57576.Çalışan'>" alt="<cf_get_lang dictionary_id='57576.Çalışan'>"></i></a>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="10" height="20"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'> !</td>
					</tr>
				</cfif>
			<cfelse>
				<tr>
					<td colspan="10" height="20"><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif isdefined("attributes.is_submitted") and attributes.totalrecords gt attributes.maxrows>
		<cfset url_str = "">
		<cfif isdefined("attributes.company_id")>
			<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
		</cfif>
		<cfif isdefined("attributes.zone_id")>
			<cfset url_str = "#url_str#&zone_id=#attributes.zone_id#">
		</cfif>
		<cfif isdefined("attributes.is_submitted")>
			<cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
		</cfif>
		<cfif isdefined("attributes.branch_name")>
			<cfset url_str = "#url_str#&branch_name=#attributes.branch_name#">
		</cfif>
		<cfif isdefined("attributes.branch_id")>
			<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
		</cfif>
		<cfif isdefined("attributes.depot_type")>
			<cfset url_str = "#url_str#&depot_type=#attributes.depot_type#">
		</cfif>
		<!-- sil -->
			<cf_paging 
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="assetcare.popup_list_depot_search#url_str#"></td>
		<!-- sil -->
	</cfif>
<cfelse>
	<div class="ui-info-bottom">
		<p><cf_get_lang dictionary_id='57701.Filtre Ediniz'> / <cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'></p>
	</div>
</cfif>
