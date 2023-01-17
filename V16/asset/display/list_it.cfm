<link rel="stylesheet" href="/css/assets/template/w3-intranet/intranet.css" type="text/css">
<script type="text/javascript" src="/JS/intranet.js"></script>
 <cfinclude template="../../rules/display/rule_menu.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.lib_cat_id" default="">
<cfparam name="attributes.rez_status" default="">
<cfparam name="attributes.writer" default="">
<cfparam name="attributes.publisher" default="">
<cfparam name="attributes.barcode_no" default="">

<cfinclude template="../query/get_lib_cat.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_lib_asset.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<!--- 
status değerleri:
0 --- Kitap kullanicinin elinde
1 --- Kitap elinde olan kullanici tarafindan teslim edildi
2 --- Kitap baska bir kullanicinin elinde veya reserve edilmişken bir kullanici tarafindan ilerki bir tarih icin reserve edildi.
3 --- Kitap bu kullanici tarafindan reserve edildi fakat daha almaya gelinmedi.
 --->
 <!---E.A 18.07.2012 select ifadeleri düzeltildi--->
		
<cfset QUERY_COUNT = get_lib_asset.recordcount>
<div class="wrapper" id="archive">
	<div class="search_group">
		<cf_box>
			<cfform name="search_asset" id="search_asset" action="#request.self#?fuseaction=asset.library" method="post">
				<cfinput type="hidden" name="is_form_submitted" value="1">
				<cf_box_search plus="0">
					<div class="blog_title" style="margin:5px;">
						<i class="fa fa-book"></i>
						<cf_get_lang dictionary_id='57697.Kütüphane'>
					</div>
					<div class="form-group">
						<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre','57460')#" value="#attributes.keyword#" maxlength="50">
					</div>
					<div class="form-group">
						<cf_wrk_combo
								name="lib_cat_id"
								query_name="LIB_CAT"
								option_name="LIBRARY_CAT"
								option_value="library_cat_id"
								option_text="#getLang('asset',54)#"
								value="#iif(isdefined("attributes.lib_cat_id"),'attributes.lib_cat_id',DE(''))#"
								width="150">
					</div>
					<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;">
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4">
					</div>
					<div class="form-group">
						<cfif not listfindnocase(denied_pages,'asset.popup_list_lib_book_rezervation')><a class="ui-btn ui-btn-update" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=asset.popup_list_lib_book_rezervation</cfoutput>')"><i class="fa fa-clock-o" alt="<cf_get_lang dictionary_id='47678.Rezervasyonlar'>" title="<cf_get_lang dictionary_id='47678.Rezervasyonlar'>"></i></a></cfif>
					</div>
					<div class="blog_title" style="margin:5px -5px;">
						<ul>
							<li id="type-folder-add"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=asset.popup_add_list_library_asset');"> <i class="wrk-uF0137"></i><span>Kategori Ekle</span></a></li>
							<li><a href="javascript:openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=asset.library&event=add')"><i class="fa fa-save"></i> <span><cf_get_lang dictionary_id='57461.Kaydet'></span></a></li>
							<li><cfoutput><a href="javascript://"><i class="wrk-uF0095"></i> <cfif qUERY_COUNT gt attributes.maxrows><cfelse>#qUERY_COUNT#</cfif> / #qUERY_COUNT#</a></cfoutput></li>
							<input type="hidden" name="baseUrl" value="<cfoutput>#request.self#</cfoutput>">
						</ul>
					</div>
				</cf_box_search>
				<cf_box_search_detail>
					<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-process_stage">
						<label><cf_get_lang dictionary_id='57572.Departman'></label>
						<select name="department_id" id="department_id">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="dep">
								<option value="#department_id#" <cfif isdefined("attributes.department_id")><cfif attributes.department_id eq department_id>selected</cfif></cfif>>#BRANCH_NAME# / #DEPARTMENT_HEAD# </option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-rez_status">
						<label><cf_get_lang dictionary_id='44754.Rezervasyon Durumu'></label>
						<select name="rez_status" id="rez_status">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<option value="1" <cfif attributes.rez_status eq 1>selected</cfif>><cf_get_lang dictionary_id='62644.Müsait'></option>
							<option value="0" <cfif attributes.rez_status eq 0 or attributes.rez_status eq 3>selected</cfif>><cf_get_lang dictionary_id='29750.Rezerve'></option>
							<option value="2" <cfif attributes.rez_status eq 2>selected</cfif>><cf_get_lang dictionary_id='47696.Beklemede'></option>
						</select>
					</div>
				<!---  --->
				<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-writer">
					<label><cf_get_lang dictionary_id='46282.Yazar'></label>
					<cfinput type="text" name="writer" value="#attributes.writer#" maxlength="50">

				</div>
				<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-publisher">
					<label><cf_get_lang dictionary_id='47686.Yayınevi'></label>
					<cfinput type="text" name="publisher" value="#attributes.publisher#" maxlength="50">

				</div>
				<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-barcode_no">
					<label><cf_get_lang dictionary_id='47699.Barkod No'></label>
					<cfinput type="text" name="barcode_no" value="#attributes.barcode_no#" maxlength="50">

				</div>
				</cf_box_search_detail>
			</cfform>
		</cf_box>
	</div>
    
	<div id="folder_list" class="archive_list"></div>
	<div class="archive_list">
	<cfif get_lib_asset.recordcount neq 0>
		<div class="ui-row">
			<cfoutput query="get_lib_asset">
				<cfinclude template="../query/get_lib_info.cfm">
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" style="height: 300px;">
					<div id="cat_#lib_asset_id#" class="archive_list_item">
						
							<cfif len(IMAGE_PATH)>
								<div class="archive_list_item_image">
									<img src="#file_web_path#asset/#IMAGE_PATH#">
								</div>
							<cfelse>
								<div class="archive_list_item_image">
									<img src="images/intranet/no-image.png">
								</div>
							</cfif>
						
						<div class="archive_list_item_text">
							<div class="archive_list_item_text_top">
								<a href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=asset.popup_list_lib_asset&lib_asset_id=#get_lib_asset.lib_asset_id#');">#lib_asset_name#</a>
							</div>
							<div class="archive_list_item_book_bottom">
								<ul>
									<cfquery name="GET_LIB_ASS_RESERVE_STATUS" datasource="#dsn#">
										SELECT STATUS FROM LIBRARY_ASSET_RESERVE WHERE LIBRARY_ASSET_ID = #get_lib_asset.lib_asset_id#
									</cfquery>
									<li class="user">
										#get_lib_cat.library_cat#
									</li>
									<li class="user">
										<cfif get_lib_asset.department_id is not 0>#get_assetp_dep.zone_name# / #get_assetp_dep.branch_name# / #get_assetp_dep.department_head#</cfif>
									</li>
									<li class="user">
										<cfif len(lib_asset_pub)>#lib_asset_pub#</cfif>
									</li>
									<li class="user">
										<cfif len(writer)>#writer#</cfif>
									</li>
									<li>
										<cfif get_lib_ass_reserve_status.status eq 0 or get_lib_ass_reserve_status.status eq 3 >
											<span href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=asset.popup_list_lib_asset_reservations&lib_asset_id=#get_lib_asset.lib_asset_id#');"><cf_get_lang dictionary_id='47796.Kitap Rezerve Edildi'>&nbsp;&nbsp<i class="fa fa-flag-o" style="color:red" alt="<cf_get_lang dictionary_id='47796.Kitap Rezerve Edildi'>!" title="<cf_get_lang dictionary_id='47796.Kitap Rezerve Edildi'>!"></i></span>
										<cfelse>
											<span href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=asset.popup_form_lib_asset_rezerve&lib_asset_id=#get_lib_asset.lib_asset_id#');"><cf_get_lang dictionary_id='47683.Kütüphane Rezervasyonu'>&nbsp;&nbsp<i class="fa fa-flag-checkered" style="color:green" alt="<cf_get_lang dictionary_id='47683.Kütüphane Rezervasyonu'>" title="<cf_get_lang dictionary_id='47683.Kütüphane Rezervasyonu'>"></i></span>
										</cfif>
									</li>
									<li class="user">
										<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=asset.library&event=upd&lib_asset_id=#get_lib_asset.lib_asset_id#')"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
									</li>
									
								</ul>
							</div>

						</div>
					</div>
				</div>
			</cfoutput>
		</div>
	<cfelse>
		<cf_box>
			<div class="ui-info-bottom">
				<cf_get_lang dictionary_id='57484.No record'>
			</div>
		</cf_box>
	</cfif> 
	</div>
</div>

<cfset url_string = ''>
		<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
			<cfset url_string = "#url_string#&department_id=#attributes.department_id#">
		</cfif>
		<cfif isdefined("attributes.lib_cat_id") and len(attributes.lib_cat_id)>
			<cfset url_string = "#url_string#&lib_cat_id=#attributes.lib_cat_id#" >
		</cfif>
		<cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
			<cfset url_string = "#url_string#&is_form_submitted=#attributes.is_form_submitted#" >
		</cfif>
		<cfif len(attributes.keyword)>
			<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
		</cfif>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="asset.library#url_string#">
<!--- 	</cf_box>
</div> --->
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
