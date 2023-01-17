<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfif form_varmi eq 1>
	<cfset get_departments.recordCount=0>
</cfif>
<!--- Bu sayfanın Hedefde add_optionsda calisan hali mevcut BK20090319 --->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.asset_cat" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.branch" default="">
<cfparam name="attributes.department_id" default="">
<cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
	SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT WHERE MOTORIZED_VEHICLE = 1 ORDER BY ASSETP_CAT
</cfquery>
<cfset dep2_id_list = "">	
<cfset url_string = "">
<cfif isdefined("department_id")><cfset url_string = "#url_string#&department_id=#attributes.department_id#"></cfif>
<cfif isdefined("field_id")><cfset url_string = "#url_string#&field_id=#attributes.field_id#"></cfif>
<cfif isdefined("field_name")><cfset url_string = "#url_string#&field_name=#attributes.field_name#"></cfif>
<cfif isdefined("field_emp_id")><cfset url_string = "#url_string#&field_emp_id=#attributes.field_emp_id#"></cfif>
<cfif isdefined("field_emp_name")><cfset url_string = "#url_string#&field_emp_name=#attributes.field_emp_name#"></cfif>
<cfif isdefined("field_pre_date")><cfset url_string = "#url_string#&field_pre_date=#attributes.field_pre_date#"></cfif>
<cfif isdefined("field_pre_km")><cfset url_string = "#url_string#&field_pre_km=#attributes.field_pre_km#"></cfif>
<cfif isdefined("field_dep2")><cfset url_string = "#url_string#&field_dep2=#attributes.field_dep2#"></cfif>
<cfif isdefined("attributes.field_dep_name")><cfset url_string = "#url_string#&field_dep_name=#attributes.field_dep_name#"></cfif>
<cfif isdefined("attributes.field_dep_id")><cfset url_string = "#url_string#&field_dep_id=#attributes.field_dep_id#"></cfif>
<cfif isdefined("attributes.field_branch_name")><cfset url_string = "#url_string#&field_branch_name=#attributes.field_branch_name#"></cfif>
<cfif isdefined("attributes.field_branch_id")><cfset url_string = "#url_string#&field_branch_id=#attributes.field_branch_id#"></cfif>
<cfif isdefined("attributes.field_brand_name")><cfset url_string = "#url_string#&field_brand_name=#attributes.field_brand_name#"></cfif>
<cfif isdefined("attributes.field_brand_type_id")><cfset url_string = "#url_string#&field_brand_type_id=#attributes.field_brand_type_id#"></cfif>
<cfif isdefined("attributes.field_make_year")><cfset url_string = "#url_string#&field_make_year=#attributes.field_make_year#"></cfif>
<cfif isdefined("attributes.field_last_date")><cfset url_string = "#url_string#&field_last_date=#attributes.field_last_date#"></cfif>
<cfif isDefined("attributes.satinalma")><cfset url_string = "#url_string#&satinalma=#attributes.satinalma#"></cfif>
<cfif isdefined("attributes.is_active")><cfset url_string = "#url_string#&is_active=#attributes.is_active#"></cfif>
<cfif isdefined("attributes.is_passive")><cfset url_string = "#url_string#&is_passive=#attributes.is_passive#"></cfif>
<cfif isdefined("attributes.is_from_km_kontrol")><cfset url_string = "#url_string#&is_from_km_kontrol=#attributes.is_from_km_kontrol#"></cfif>
<cfset adres = "">
<cfif len(attributes.keyword)>
	<cfset adres = "#adres#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.search_branch_id")>
	<cfset adres = "#adres#&search_branch_id=#attributes.search_branch_id#">
</cfif>
	<cfquery name="GET_ASSETP_VEHICLE" datasource="#DSN#">
		SELECT
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_ID,
			ASSET_P.ASSETP,
			ASSET_P.ASSETP_ID,			
			ASSET_P.DEPARTMENT_ID,
			ASSET_P.DEPARTMENT_ID2,
			ASSET_P.BRAND_TYPE_ID,
			ASSET_P.MAKE_YEAR,
			ASSET_P.FUEL_TYPE,
			ASSET_P.ASSETP_CATID,
			ASSET_P.BRAND_TYPE_ID,
			DEPARTMENT.DEPARTMENT_HEAD,
			BRANCH.BRANCH_ID,
			BRANCH.BRANCH_NAME,
			SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
			SETUP_BRAND.BRAND_ID,
			SETUP_BRAND.BRAND_NAME
		FROM
			EMPLOYEE_POSITIONS,
			ASSET_P,
			SETUP_BRAND_TYPE,
			SETUP_BRAND,
			DEPARTMENT,
			BRANCH
		WHERE			
			<!--- Sube kontrolü --->
			BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
			<cfif isdefined("get_assetp_cats.assetp_catid") and len(get_assetp_cats.assetp_catid)> ASSET_P.ASSETP_CATID IN (#valuelist(get_assetp_cats.assetp_catid)#) AND </cfif>
			ASSET_P.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
			DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
			ASSET_P.BRAND_TYPE_ID = SETUP_BRAND_TYPE.BRAND_TYPE_ID AND
			SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID AND
			ASSET_P.POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE AND
			<!--- Sorumlusu bosta olanlar gelmesin --->
			EMPLOYEE_POSITIONS.EMPLOYEE_ID > 0
			<cfif isdefined("attributes.satinalma")>AND ASSET_P.PROPERTY = 1</cfif>
			<cfif isDefined("attributes.is_active")>AND ASSET_P.STATUS = 1</cfif>
			<cfif isDefined("attributes.is_passive")>AND ASSET_P.STATUS = 0</cfif>
			<cfif len(attributes.keyword)>AND ASSET_P.ASSETP LIKE '%#attributes.keyword#%'</cfif>
			<cfif len(attributes.asset_cat)>AND ASSET_P.ASSETP_CATID = #attributes.asset_cat#</cfif>
			<cfif len(attributes.branch_id) and len(attributes.branch)> AND BRANCH.BRANCH_ID = #attributes.branch_id#</cfif>
		ORDER BY
			ASSET_P.ASSETP
	</cfquery>
	<cfif isDefined("attributes.field_dep_name")>
		<cfoutput query="get_assetp_vehicle">
			<cfif len(department_id) and not ListFind(dep2_id_list,department_id)>
				<cfset dep2_id_list = ListAppend(dep2_id_list,department_id)>
			</cfif>
		</cfoutput>
	</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_assetp_vehicle.recordCount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>	
<!---<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_assetp_vehicle.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>--->

<cf_box title="#getLang('','Araçlar',57414)#"  scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_ship_asset" method="post" action="#request.self#?fuseaction=objects.popup_list_ship_vehicles#url_string#">
		<input type="hidden" name="is_submitted" id="is_submitted" value="1">
		<cf_box_search>
			<!-- sil -->
				<cfinput type="hidden" name="is_form_submitted" value="1">
				<div class="form-group" id="item-keyword">
					<cfinput type="text" maxlength="255"  placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" name="keyword">
				</div>	
				<div class="form-group" id="item-branch">
					<div class="input-group">
						<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>"> 
						<input type="text" placeholder="<cfoutput>#getLang('','Şube',57453)#</cfoutput>" name="branch" id="branch" value="<cfoutput>#attributes.branch#</cfoutput>"> 
						<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=search_ship_asset.branch&field_branch_id=search_ship_asset.branch_id')"></span>
					</div>	
				</div>				
				<div class="form-group" id="item-asset_cat">
					<select name="asset_cat" id="asset_cat">
						<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
						<cfoutput query="get_assetp_cats">
							<option value="#assetp_catid#" <cfif attributes.asset_cat eq assetp_catid>selected</cfif>>#assetp_cat#</option>
						</cfoutput>
					</select>
				</div>	
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_ship_asset' , #attributes.modal_id#)"),DE(""))#">
				</div>
				<!--- <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> --->
			<!-- sil -->
		</cf_box_search>
	</cfform>
	<cf_grid_list>
		<thead>
			<tr>		
				<th><cf_get_lang dictionary_id='29453.Plaka'></th>
				<th><cf_get_lang dictionary_id='57486.Kategori'></th>
				<th><cf_get_lang dictionary_id='33355.Kullanıcı Lokasyon'></th>
				<th><cf_get_lang dictionary_id='57544.Sorumlu'> 1</th>
			</tr>
		</thead>
		<tbody>
			<cfif get_assetp_vehicle.recordcount and form_varmi eq 1>
				<cfset cat_id_list = "">
				<cfset brand_name_list = "">
				<cfset assetp_id_list = "">
				<cfoutput query="get_assetp_vehicle" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(assetp_catid) and not listfind(cat_id_list,assetp_catid)>
						<cfset cat_id_list = Listappend(cat_id_list,assetp_catid)>
					</cfif>
					<cfif len(brand_type_id) and not listfind(brand_name_list,brand_type_id)>
						<cfset brand_name_list = Listappend(brand_name_list,brand_type_id)>
					</cfif>
					<cfif len(assetp_id) and not listfind(assetp_id_list,assetp_id)>
						<cfset assetp_id_list = Listappend(assetp_id_list,assetp_id)>
					</cfif>					
				</cfoutput>
				
				<cfif len(cat_id_list)>
					<cfset cat_id_list=listsort(cat_id_list,"numeric","ASC",",")>
					<cfquery name="GET_CAT" datasource="#DSN#">
						SELECT ASSETP_CATID,ASSETP_CAT FROM ASSET_P_CAT WHERE ASSETP_CATID IN (#cat_id_list#) ORDER BY ASSETP_CATID
					</cfquery>
					<cfset cat_id_list = listsort(listdeleteduplicates(valuelist(get_cat.assetp_catid,',')),'numeric','ASC',',')>
				</cfif>
				<cfif len(brand_name_list)>
					<cfset cat_id_list=listsort(cat_id_list,"numeric","ASC",",")>
					<cfquery name="LIST_BRANDS" datasource="#DSN#">
						SELECT
							SB.BRAND_ID,
							SBT.BRAND_TYPE_ID,
							SBT.BRAND_TYPE_NAME,
							SB.BRAND_NAME
						FROM
							SETUP_BRAND SB,
							SETUP_BRAND_TYPE SBT
						WHERE
							SBT.BRAND_ID = SB.BRAND_ID AND
							SBT.BRAND_TYPE_ID IN (#brand_name_list#)
						ORDER BY
							SBT.BRAND_TYPE_ID
					</cfquery>
					<cfset brand_name_list = listsort(listdeleteduplicates(valuelist(list_brands.brand_type_id,',')),'numeric','ASC',',')>
				</cfif>
				
				<!--- son KM ler icin --->
				<cfif isdefined('attributes.field_pre_date') or isDefined('attributes.field_pre_km')>
					<cfquery name="GET_KM" datasource="#DSN#">
						SELECT ASSETP_ID, KM_CONTROL_ID,KM_FINISH,FINISH_DATE FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID IN (#assetp_id_list#)
					</cfquery>
				</cfif>
				
				<cfoutput query="get_assetp_vehicle" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif isdefined('attributes.field_pre_date') or isDefined('attributes.field_pre_km')>
						<cfquery name="MAX_KM" dbtype="query" maxrows="1">
							SELECT * FROM GET_KM WHERE ASSETP_ID = #assetp_id# ORDER BY KM_CONTROL_ID DESC
						</cfquery>
					</cfif>
					<cfif isDefined('attributes.field_dep_name') and ListLen(dep2_id_list)>
						<cfquery name="GET_DEP2" dbtype="query">
							SELECT				 	
								DEPARTMENT_ID,
								DEPARTMENT_HEAD,
								BRANCH_NAME
							FROM 
								GET_ASSETP_VEHICLE
							WHERE 
								ASSETP_ID = #assetp_id#
						</cfquery>
					</cfif>
					<!--- Popup km kayıt dan çagrildiysa ve tahsis km girisi tamamlanmadiysa araci gosterme....Onur P. --->
					<cfif isDefined('attributes.is_from_km_kontrol')>
						<cfif len(max_km.km_finish)>		
							<tr>
								<td><a href="javascript://" class="tableyazi" onClick="gonder('#assetp_id#','#assetp#'<cfif isdefined("attributes.field_emp_id")>,'#employee_id#','#employee_name# #employee_surname#'</cfif><cfif isdefined("attributes.field_pre_km")>,'#tlformat(max_km.km_finish,0)#','#dateformat(max_km.finish_date,dateformat_style)#'</cfif><cfif isdefined("attributes.field_dep_name") and ListLen(dep2_id_list)>,'#get_dep2.branch_name# - #get_dep2.department_head#','#get_dep2.department_id#'</cfif>,'#branch_name#','#branch_id#','#brand_type_id#','#list_brands.brand_name[listfind(brand_name_list,brand_type_id,",")]# - #list_brands.brand_type_name[listfind(brand_name_list,brand_type_id,",")]#','#make_year#','#fuel_type#'<cfif isDefined("attributes.field_last_date")>,'#dateFormat(max_km.finish_date,dateformat_style)#'</cfif>)">#assetp#</a></td>	
								<td>#get_cat.assetp_cat[listfind(cat_id_list,get_assetp_vehicle.assetp_catid,",")]#</td>				
								<td>#branch_name# / #department_head# </td>
								<td>#employee_name# #employee_surname#</td>
							</tr>
						<cfelse>
							<tr>
								<td>#assetp#</td>	
								<td>#get_cat.assetp_cat[listfind(cat_id_list,get_assetp_vehicle.assetp_catid,",")]#</td>				
								<td>#branch_name# / #department_head# </td>
								<td>#employee_name# #employee_surname#</td>
							</tr>
						</cfif>
					<cfelse>
						<tr>
							<td><a href="javascript://" class="tableyazi" onClick="gonder('#assetp_id#','#assetp#'<cfif isdefined("attributes.field_emp_id")>,'#employee_id#','#employee_name# #employee_surname#'</cfif><cfif isdefined("attributes.field_pre_km")>,'#tlformat(max_km.km_finish,0)#','#dateformat(max_km.finish_date,dateformat_style)#'</cfif><cfif isdefined("attributes.field_dep_name") and ListLen(dep2_id_list)>,'#get_dep2.branch_name# - #get_dep2.department_head#','#get_dep2.department_id#'</cfif>,'#branch_name#','#branch_id#','#brand_type_id#','#list_brands.brand_name[listfind(brand_name_list,brand_type_id,",")]# - #list_brands.brand_type_name[listfind(brand_name_list,brand_type_id,",")]#','#make_year#','#fuel_type#'<cfif isDefined("attributes.field_last_date")>,'#dateFormat(max_km.finish_date,dateformat_style)#'</cfif>)">#assetp#</a></td>
							<td>#get_cat.assetp_cat[listfind(cat_id_list,get_assetp_vehicle.assetp_catid,',')]#</td>
							<td>#branch_name# / #department_head#</td>
							<td>#employee_name# #employee_surname#</td>
						</tr>		
					</cfif>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="5"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</cfif></td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<!-- sil -->
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif isdefined("keyword")>
				<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isdefined("asset_cat")>
				<cfset url_string = "#url_string#&asset_cat=#attributes.asset_cat#">
			</cfif>
			<cfif isdefined("branch_id")>
				<cfset url_string = "#url_string#&branch_id=#attributes.branch_id#">
			</cfif>
			<cfif isdefined("branch")>
				<cfset url_string = "#url_string#&branch=#attributes.branch#">
			</cfif>
			<cfif isdefined("is_submitted")>
				<cfset url_string = "#url_string#&is_submitted=#attributes.is_submitted#">
			</cfif>	
			<cfif attributes.totalrecords gt attributes.maxrows>
				<cfif form_varmi eq 1>
					<cfset url_string = "#url_string#&is_form_submitted=1">
					<cf_paging 
						page="#attributes.page#" 
						maxrows="#attributes.maxrows#" 
						totalrecords="#attributes.totalrecords#" 
						startrow="#attributes.startrow#" 
						adres="objects.popup_list_ship_vehicles#adres##url_string#"
						isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
				</cfif>
			</cfif>
		</cfif>
	<!-- sil -->
</cf_box>
<script type="text/javascript">
document.getElementById('keyword').focus();	
function gonder(id,name<cfif isdefined('attributes.field_emp_id')>,emp_id,emp_name</cfif><cfif isdefined('attributes.field_pre_km')>,last_km,last_date</cfif><cfif isdefined('attributes.field_dep_name') and ListLen(dep2_id_list)>,field_dep_name,field_dep_id</cfif>,field_branch_name,field_branch_id,field_brand_type_id,field_brand_name,field_make_year,fuel_type_id<cfif isDefined("attributes.field_last_date")>,field_last_date</cfif>)
{
   <cfif isDefined("attributes.field_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value=id;
	</cfif>
	<cfif isDefined("attributes.field_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value=name;
	</cfif>
	<cfif isDefined("attributes.field_emp_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_emp_id#</cfoutput>.value=emp_id;
	</cfif>
	<cfif isDefined("attributes.field_emp_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_emp_name#</cfoutput>.value=emp_name;
	</cfif>
	<cfif isDefined("attributes.field_pre_date")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_pre_date#</cfoutput>.value=last_date;
	</cfif>
	<cfif isDefined("attributes.field_pre_km")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_pre_km#</cfoutput>.value=last_km;
	</cfif>
	<cfif isDefined("attributes.field_dep_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_dep_name#</cfoutput>.value=field_dep_name;
	</cfif>
	<cfif isDefined("attributes.field_dep_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_dep_id#</cfoutput>.value=field_dep_id;
	</cfif>
	<cfif isDefined("attributes.field_branch_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_branch_name#</cfoutput>.value=field_branch_name;
	</cfif> 
	<cfif isDefined("attributes.field_branch_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_branch_id#</cfoutput>.value=field_branch_id;
	</cfif>
	<cfif isDefined("attributes.field_brand_type_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_brand_type_id#</cfoutput>.value=field_brand_type_id;
	</cfif>
	 <cfif isDefined("attributes.field_brand_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_brand_name#</cfoutput>.value=field_brand_name;
	</cfif> 
	<cfif isDefined("attributes.field_make_year")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_make_year#</cfoutput>.value = field_make_year;
	</cfif>		
	<cfif isDefined("attributes.field_last_date")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_last_date#</cfoutput>.value = field_last_date;
	</cfif>		
	<cfif isDefined("attributes.fuel_type_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.fuel_type_id#</cfoutput>.options[fuel_type_id].selected = true;
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>
