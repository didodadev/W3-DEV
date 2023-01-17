<cfparam name="attributes.modal_id" default="">
<cfif not cgi.HTTP_REFERER contains 'hr.search_app'>
    <cfloop list="#attributes.list_empapp_id#" index="bas" delimiters=",">
        <cfif listvaluecount(attributes.list_empapp_id,bas,',') gt 1>
            <script type="text/javascript">
                alert("<cf_get_lang dictionary_id ='55134.Aynı Özgeçmişe ait birden fazla kayıt seçilmiş Lütfen seçtiğiniz kayıtları gözden geçiriniz'>!");
                closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>')
            </script>
            <cfabort>
        </cfif>
    </cfloop>
</cfif>
<cfquery name="GET_SETUP_WARNING" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_WARNINGS 
	ORDER BY 
		SETUP_WARNING
</cfquery>
<cfsavecontent variable="txt">
<cfif not isdefined('attributes.old')>
	<cf_get_lang dictionary_id='31870.Seçim Listesi'>: <cf_get_lang dictionary_id='45697.Yeni Kayıt'>
<cfelseif isdefined('attributes.old') and attributes.old eq 1>
	<cf_get_lang dictionary_id='62730.Seçim Listesine Ekle'>
</cfif>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12"  class="ui-scroll">
	<cf_box title="#txt#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<!--- <cfif not(isDefined("attributes.type") and attributes.type eq 1) or (isDefined("attributes.type") and attributes.type eq 2)>
			<cf_seperator title="#txt#" id="big_list" style="display:none;">
		</cfif> --->
			<div id="big_list">
				<cfform name="add_list" action="#request.self#?fuseaction=hr.emptypopup_add_select_emp_list" method="post">
					<cfif isdefined('attributes.old') and attributes.old eq 1><div id="list_div"></div></cfif>
						<cf_box_elements>
							<cfif not isdefined('attributes.old')>
								<input name="record_num" id="record_num" type="hidden" value="1">
								<input name="record_count" id="record_count" type="hidden" value="1">
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column">
									<div class="form-group" id="item-list_status">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='57493.Aktif'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<input type="checkbox" name="list_status" id="list_status" value="1" checked>
										</div>
									</div>
									<div class="form-group" id="item-list_name">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='58820.Başlık'>*</label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='55140.Liste Adı'></cfsavecontent>
											<cfinput type="text" name="list_name"  value="" required="yes" message="#message#" maxlength="50">
										</div>
									</div>
									<div class="form-group" id="item-list_detail">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='57629.Açıklama'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<textarea name="list_detail" id="list_detail" style="height:50px"></textarea>
										</div>
									</div>				
									<div class="form-group" id="item-process">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<cf_workcube_process 
											is_upd='0' 
											process_cat_width='150' 
											is_detail='0'>
										</div>
									</div>
									<div class="form-group" id="item-pif_name">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='56204.Personel İstek Formu'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="pif_id" id="pif_id" value="">
												<input type="text" name="pif_name" id="pif_name" value="" >
												<span class="input-group-addon icon-ellipsis" title="<cf_get_lang no ='61.Seçim Listesi Seç'>" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_personel_requirement&field_id=pif_id&field_name=pif_name&draggable=1</cfoutput>');"></span>
											</div>
										</div>
									</div>
									<div class="form-group" id="item-notice_head_list">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55836.Başvurulan İlan'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="notice_id_list" id="notice_id_list" value="<cfif isdefined('attributes.notice_head') and isdefined('attributes.notice_id')><cfoutput>#attributes.notice_id#</cfoutput></cfif>">
												<input type="text" name="notice_head_list" id="notice_head_list" value="<cfif isdefined('attributes.notice_head') and isdefined('attributes.notice_id')><cfoutput>#attributes.notice_head#</cfoutput></cfif>" >
												<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_notices&field_id=add_list.notice_id_list&field_name=add_list.notice_head_list');"></span> 
											</div>
										</div>
									</div>
									<div class="form-group" id="item-app_position_list">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="position_id_list" id="position_id_list" value="<cfoutput>#attributes.position_id#</cfoutput>" maxlength="50">
												<input type="text" name="app_position_list" id="app_position_list"  value="<cfoutput>#attributes.app_position#</cfoutput>">
												<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_list.position_id_list&field_pos_name=add_list.app_position_list&field_comp_id=add_list.our_company_id_list&field_branch_name=add_list.branch_list&field_branch_id=add_list.branch_id_list&field_dep_name=add_list.department_list&field_dep_id=add_list.department_id_list&show_empty_pos=1');"></span> 
											</div>
										</div>
									</div>
									<div class="form-group" id="item-position_cat_id_list">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="position_cat_id_list" id="position_cat_id_list" value="<cfoutput>#attributes.position_cat_id#</cfoutput>">
												<cfinput type="text" name="position_cat_list"  value="#attributes.position_cat#">
												<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_cats&field_cat_id=add_list.position_cat_id_list&field_cat=add_list.position_cat_list');"></span> 
											</div>
										</div>
									</div>
									<div class="form-group" id="item-branch_id_list">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="branch_id_list" id="branch_id_list" value="<cfoutput>#attributes.branch_id#</cfoutput>">
												<input type="text" name="branch_list" id="branch_list" value="<cfoutput>#attributes.branch#</cfoutput>" >
												<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=add_list.department_id_list&field_name=add_list.department_list&field_branch_name=add_list.branch_list&field_branch_id=add_list.branch_id_list&field_our_company_id=add_list.our_company_id_list</cfoutput>');"></span>
											</div>
										</div>
									</div>	
									<div class="form-group" id="item-our_company_id_list">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<input type="hidden" name="our_company_id_list" id="our_company_id_list" value="<cfoutput>#attributes.our_company_id#</cfoutput>">	
											<input type="hidden" name="department_id_list" id="department_id_list" value="<cfoutput>#attributes.department_id#</cfoutput>">
											<input type="text" name="department_list" id="department_list" value="<cfoutput>#attributes.department#</cfoutput>" >
										</div>
									</div>
									<div class="form-group" id="item-company_list">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='57585.Kurumsal Üye'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<div class="input-group">
												<input type="hidden" value="<cfoutput>#attributes.company_id#</cfoutput>" name="company_id_list" id="company_id_list">
												<input type="text" name="company_list" id="company_list" value="<cfoutput>#attributes.company#</cfoutput>" >
												<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=add_list.company_id_list&field_comp_name=add_list.company_list&select_list=7','list');"></span> 
											</div>
											
										</div>
									</div>
								</div>
								<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                    <cf_seperator id="authorized" title="#getLang('','Başvuru Kriterleri',33254)#">
									<cf_grid_list id="authorized">
										<thead>
											<th style="text-align:center;">
												<span class="fa fa-plus center" style="cursor:pointer;" title="" onClick="add_row();" alt="<cf_get_lang dictionary_id='57582.Ekle'>">
											</th>
											<th>
												<input type="hidden" name="url_link" id="url_link" value="<cfoutput>#request.self#?fuseaction=myhome.upd_emp_app_select_list</cfoutput>" ><cf_get_lang dictionary_id='57578.Yetkili'>* 
												<input type="hidden" name="positions" id="positions" value="">
											</th>
                                            <th><cf_get_lang dictionary_id='57527.Talepler'>*</th>
                                            <th><cfoutput>#getLang('','Açıklama',36199)#</cfoutput></th>
                                            <th><cfoutput>#getLang('','Son Cevap',31431)#-#getLang('','Tarih',30631)#</cfoutput> *</th>
                                            <th><cfoutput>#getLang('','Son Cevap',31431)#-#getLang('','Saat',57491)#/#getLang('','Dk',58827)#</cfoutput> *</th>
                                            <th><cfoutput>#getLang('','SMS',32002)#-#getLang('','Tarih',30631)#</cfoutput> *</th>
                                            <th><cfoutput>#getLang('','SMS',32002)#-#getLang('','Saat',57491)#/#getLang('','Dk',58827)#</cfoutput> *</th>
                                            <th><cfoutput>#getLang('','Email Uyarı',31432)#-#getLang('','Tarih',30631)#</cfoutput></th>
                                            <th><cfoutput>#getLang('','Email Uyarı',31432)#-#getLang('','Saat',57491)#/#getLang('','Dk',58827)#</cfoutput></th>
										</thead>
										<tbody id="link_table"></tbody>
									</cf_grid_list>
								</div>
							<cfelseif isdefined('attributes.old') and attributes.old eq 1>
								<cfif isdefined("attributes.draggable")>
									<input type="hidden" name="draggable" id="draggable" value="1">
									<input type="hidden" name="modal_id" id="modal_id" value="<cfoutput>#attributes.modal_id#</cfoutput>">
								</cfif> 
								<input type="hidden" name="old" id="old" value="1"> 
								<input type="hidden" name="list_id" id="list_id" value="">
							</cfif>
						</cf_box_elements>
					<cf_box_footer>
						<cfif not isdefined('attributes.old')>
							<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
						<cfelseif isdefined('attributes.old') and attributes.old eq 1>
							<cf_workcube_buttons is_upd='0' insert_info = '#getLang('','Seçim Listesine Ekle','62730')#' add_function="add_list_control()">
						</cfif>
					</cf_box_footer>
						<!--- aram kriterleri urlden uzun olduğu için form oalrk yolanyor--->
					<cfoutput>
						<input type="hidden" name="search_app" id="search_app" value="#attributes.search_app#">
						<input type="hidden" name="list_app_pos_id" id="list_app_pos_id" value="#attributes.list_app_pos_id#">
						<input type="hidden" name="list_empapp_id" id="list_empapp_id" value="#attributes.list_empapp_id#">
						<input type="hidden" name="search_app_pos" id="search_app_pos" value="#attributes.search_app_pos#">
						<input type="hidden" name="status_app_pos" id="status_app_pos" value="#attributes.status_app_pos#">
						<input type="hidden" name="date_status" id="date_status" value="#attributes.date_status#">
						<input type="hidden" name="position_cat_id" id="position_cat_id" value="#attributes.position_cat_id#">
						<input type="hidden" name="position_cat" id="position_cat" value="#attributes.position_cat#">
						<input type="hidden" name="position_id" id="position_id" value="#attributes.position_id#">
						<input type="hidden" name="app_position" id="app_position" value="#attributes.app_position#">
						<input type="hidden" name="notice_id" id="notice_id" value="#attributes.notice_id#">
						<input type="hidden" name="notice_head" id="notice_head" value="#attributes.notice_head#">
						<input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
						<input type="hidden" name="company" id="company" value="#attributes.company#">
						<input type="hidden" name="our_company_id" id="our_company_id" value="#attributes.our_company_id#">	
						<input type="hidden" name="department_id" id="department_id" value="#attributes.department_id#">
						<input type="hidden" name="department" id="department" value="#attributes.department#">
						<input type="hidden" name="branch_id" id="branch_id" value="#attributes.branch_id#">
						<input type="hidden" name="branch" id="branch" value="#attributes.branch#">
						<input type="hidden" name="app_date1" id="app_date1" value="#attributes.app_date1#">
						<input type="hidden" name="app_date2" id="app_date2" value="#attributes.app_date2#">
						<input type="hidden" name="prefered_city" id="prefered_city" value="#attributes.prefered_city#">
						<input type="hidden" name="salary_wanted1" id="salary_wanted1" value="#attributes.salary_wanted1#">
						<input type="hidden" name="salary_wanted2" id="salary_wanted2" value="#attributes.salary_wanted2#">
						<input type="hidden" name="salary_wanted_money" id="salary_wanted_money" value="#attributes.salary_wanted_money#">
						<input type="hidden" name="status_app" id="status_app" value="#attributes.status_app#">
						<input type="hidden" name="app_name" id="app_name" value="#attributes.app_name#">
						<input type="hidden" name="app_surname" id="app_surname" value="#attributes.app_surname#">
						<input type="hidden" name="birth_date1" id="birth_date1" value="#attributes.birth_date1#">
						<input type="hidden" name="birth_date2" id="birth_date2" value="#attributes.birth_date2#">
						<input type="hidden" name="birth_place" id="birth_place" value="#attributes.birth_place#">
						<input type="hidden" name="married" id="married" value="#attributes.married#">
						<input type="hidden" name="city" id="city"  value="#attributes.city#">
						<input type="hidden" name="sex" id="sex" value="#attributes.sex#">
						<input type="hidden" name="martyr_relative" id="martyr_relative" value="#attributes.martyr_relative#">
						<input type="hidden" name="is_trip" id="is_trip" value="#attributes.is_trip#">
						<input type="hidden" name="driver_licence" id="driver_licence" value="#attributes.driver_licence#">
						<input type="hidden" name="driver_licence_type" id="driver_licence_type" value="#attributes.driver_licence_type#">
						<input type="hidden" name="sentenced" id="sentenced" value="#attributes.sentenced#">
						<input type="hidden" name="defected" id="defected" value="#attributes.defected#">
						<input type="hidden" name="defected_level" id="defected_level" value="#attributes.defected_level#">
						<input type="hidden" name="email" id="email" value="#attributes.email#">
						<input type="hidden" name="military_status" id="military_status" value="#attributes.military_status#">
						<input type="hidden" name="homecity" id="homecity" value="#attributes.homecity#">
						<input type="hidden" name="training_level" id="training_level" value="#attributes.training_level#">
						<input type="hidden" name="edu_finish" id="edu_finish" value="#attributes.edu_finish#">
						<input type="hidden" name="exp_year_s1" id="exp_year_s1" value="#attributes.exp_year_s1#">
						<input type="hidden" name="exp_year_s2" id="exp_year_s2" value="#attributes.exp_year_s2#">
						<input type="hidden" name="lang" id="lang" value="#attributes.lang#">
						<input type="hidden" name="lang_level" id="lang_level" value="#attributes.lang_level#">
						<input type="hidden" name="lang_par" id="lang_par" value="#attributes.lang_par#">
						<input type="hidden" name="edu3_part" id="edu3_part" value="#attributes.edu3_part#">
						<input type="hidden" name="edu4_id" id="edu4_id" value="#attributes.edu4_id#">
						<input type="hidden" name="edu4_part_id" id="edu4_part_id" value="#attributes.edu4_part_id#">
						<input type="hidden" name="edu4" id="edu4" value="#attributes.edu4#">
						<input type="hidden" name="edu4_part" id="edu4_part" value="#attributes.edu4_part#">
						<input type="hidden" name="unit_id" id="unit_id" value="#attributes.unit_id#">
						<input type="hidden" name="unit_row" id="unit_row" value="<cfif isdefined("attributes.unit_row") and len(attributes.unit_row)>#attributes.unit_row#</cfif>">
						<input type="hidden" name="referance" id="referance" value="#attributes.referance#">
						<input type="hidden" name="tool" id="tool" value="#attributes.tool#">
						<input type="hidden" name="kurs" id="kurs" value="#attributes.kurs#">
						<input type="hidden" name="other" id="other" value="#attributes.other#">
						<input type="hidden" name="other_if" id="other_if" value="#attributes.other_if#">
					</cfoutput>
				</cfform>
			</div>
			<cfif isdefined('attributes.old') and not(isDefined("attributes.type") and attributes.type eq 1)>
				<cf_seperator id="secim_list" header="#getLang('','Seçim Listeleri','31337')#" is_closed="1">
				<div id="secim_list"></div>
			</cfif>
	</cf_box>
</div>

<script type="text/javascript">
	$(document).ready(function()
	{		
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=hr.popup_select_list_empapp<cfif isdefined("attributes.draggable")>&draggable=#attributes.draggable#&modal_id=#attributes.modal_id#</cfif>&empapp_id=#attributes.list_empapp_id#</cfoutput>','secim_list');	
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=hr.popup_list_select_list&field_id=add_list.list_id&field_name=add_list.list_name<cfif isdefined("attributes.draggable")>&draggable=#attributes.draggable#&modal_id=#attributes.modal_id#</cfif>&empapp_id=#attributes.list_empapp_id#<cfif isdefined("attributes.type")>&type=#attributes.type#</cfif></cfoutput>','list_div');			
	});

function kontrol()
{
	if (add_list.list_detail.value.length>250)
	{
		alert("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id ='55167.Detay Alanı en fazla 250 Karakter'>");
		return false;
	}
    if( add_list.list_name.value === '' ){
        alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='58820.Başlık'>");
        return false;
    }
	return 	process_cat_control();
}

var row_count=0;
var main_row_count=0;
function sil(sy){
	var my_element=eval("add_list.row_kontrol"+sy);
    my_element.value=0;
    var my_element=document.querySelector("#frm_row"+sy);
    my_element.style.display="none";
	document.add_list.record_count.value=parseInt(document.add_list.record_count.value)-1;
}

function add_row()
{
	row_count++;
	main_row_count++;
	var newRow;
	var newCell;
	
	newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);
				
	document.add_list.record_count.value=parseInt(document.add_list.record_count.value)+1;		
	document.add_list.record_num.value=row_count;
	
	// newCell = newRow.insertCell(newRow.cells.length);
	// newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + (row_count) + ');" ><i class="fa fa-minus"></i></a><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';
	
	// newCell = newRow.insertCell(newRow.cells.length);
	// newCell.innerHTML = "<cf_get_lang dictionary_id='57578.Yetkili'>*";
	
	// newCell = newRow.insertCell(newRow.cells.length);
	// newCell.innerHTML = '<div class="form-group" width="100"><cf_get_lang dictionary_id='57527.Talepler'>*</div>';
	
	// newCell = newRow.insertCell(newRow.cells.length);
	// newCell.innerHTML = '<cfoutput>#getLang('','Açıklama',36199)#</cfoutput>';
		
	// /* newCell = newRow.insertCell(newRow.cells.length);
	// newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >'; */
	
	// newCell = newRow.insertCell(newRow.cells.length);
	// newCell.innerHTML = '<cfoutput>#getLang('','Son Cevap',31431)#-#getLang('','Tarih',30631)#</cfoutput> *';
	
	// newCell = newRow.insertCell(newRow.cells.length);
	// newCell.innerHTML = '<cfoutput>#getLang('','Son Cevap',31431)#-#getLang('','Saat',57491)#/#getLang('','Dk',58827)#</cfoutput> *';
	
	// newCell = newRow.insertCell(newRow.cells.length);
	// newCell.innerHTML = '<cfoutput>#getLang('','SMS',32002)#-#getLang('','Tarih',30631)#</cfoutput> *';
	
	// newCell = newRow.insertCell(newRow.cells.length);
	// newCell.innerHTML = '<cfoutput>#getLang('','SMS',32002)#-#getLang('','Saat',57491)#/#getLang('','Dk',58827)#</cfoutput> *';
	
	// newCell = newRow.insertCell(newRow.cells.length);
	// newCell.innerHTML = '<cfoutput>#getLang('','Email Uyarı',31432)#-#getLang('','Tarih',30631)#</cfoutput>';
	
	// newCell = newRow.insertCell(newRow.cells.length);
	// newCell.innerHTML = '<cfoutput>#getLang('','Email Uyarı',31432)#-#getLang('','Saat',57491)#/#getLang('','Dk',58827)#</cfoutput>';

	// row_count++;
	// var newRow;
	// var newCell;
	
	/* newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);
	
	document.add_list.record_num.value=row_count; */

    newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + (row_count) + ');" ><i class="fa fa-minus"></i></a><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';
    
	/* newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '&nbsp;<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >'; */
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group" id="item-"><input type="text" name="employee' + main_row_count + '" ><div class="input-group"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('+"'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_list.position_code" + main_row_count + "&field_name=add_list.employee" + main_row_count + "');"+'"></span><input type="hidden" name="position_code' + main_row_count + '"></div></div> ';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group width"><select name="warning_head' + main_row_count + '" style="width:200px;"><cfoutput query="GET_SETUP_WARNING"><option value="#SETUP_WARNING#--#SETUP_WARNING_ID#">#SETUP_WARNING#</option></cfoutput></select></div>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group" id="item-"><input type="text" name="warning_description' + main_row_count + '" ></div>';
/* 
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = 'Son Cevap *';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = 'SMS';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = 'Email Uyarı'; */
	
	/* row_count++;
	var newRow;
	var newCell;
	
	newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);
	
	document.add_list.record_num.value=row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = 'Son Cevap *';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = 'SMS';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = 'Email Uyarı'; */
	
	/* row_count++;
	var newRow;
	var newCell;
	
	newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);
	
	document.add_list.record_num.value=row_count;
	 */
	/* newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '&nbsp;<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >'; */
	
	newCell = newRow.insertCell(newRow.cells.length);
    newCell.setAttribute("id","response_date" + main_row_count + "_td");
    newCell.innerHTML = '<input type="text" name="response_date' + main_row_count +'" id="response_date' + main_row_count +'" class="text" maxlength="10" style="width:65px;" value="<cfoutput>#dateformat(now(), "DD/MM/YYYY")#</cfoutput>">';
    wrk_date_image('response_date' + main_row_count);
    
    newCell = newRow.insertCell(newRow.cells.length);
    HTMLStr = '<select name="response_clock' + main_row_count + '"><cfloop from="0" to="23" index="i"><cfoutput><option value="#i#">#numberformat(i,00)#</option></cfoutput></cfloop></select>';
    HTMLStr = HTMLStr + '<select name="response_min' + main_row_count + '"><option value="00" selected>00</option>';
    HTMLStr = HTMLStr + '<option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option><option value="30">30</option>';
    HTMLStr = HTMLStr + '<option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option>';
    HTMLStr = HTMLStr + '</select>';
    newCell.innerHTML = HTMLStr;
    

    newCell = newRow.insertCell(newRow.cells.length);
    newCell.setAttribute("id","sms_startdate" + main_row_count + "_td");
    newCell.innerHTML = '<input type="text" name="sms_startdate' + main_row_count +'" id="sms_startdate' + main_row_count +'" class="text" maxlength="10" style="width:65px;" value="<cfoutput>#dateformat(now(), "DD/MM/YYYY")#</cfoutput>">';
    wrk_date_image('sms_startdate' + main_row_count);

    newCell = newRow.insertCell(newRow.cells.length);
    HTMLStr = '<select name="sms_start_clock' + main_row_count + '"><cfloop from="0" to="23" index="i"><cfoutput><option value="#numberformat(i,00)#">#numberformat(i,00)#</option></cfoutput></cfloop></select>';
    HTMLStr = HTMLStr + '<select name="sms_start_min' + main_row_count + '">';
    HTMLStr = HTMLStr + '<option value="00" selected>00</option><option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option>';
    HTMLStr = HTMLStr + '<option value="30">30</option><option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option>';
    HTMLStr = HTMLStr + '</select>';
    newCell.innerHTML = HTMLStr;

    
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.setAttribute("id","email_startdate" + main_row_count + "_td");
    newCell.innerHTML = '<input type="text" name="email_startdate' + main_row_count +'" id="email_startdate' + main_row_count +'" class="text" maxlength="10" style="width:65px;" value="<cfoutput>#dateformat(now(), "DD/MM/YYYY")#</cfoutput>">';
    wrk_date_image('email_startdate' + main_row_count);

    newCell = newRow.insertCell(newRow.cells.length);	
    HTMLStr = '<select name="email_start_clock' + main_row_count + '"><cfloop from="0" to="23" index="i"><cfoutput><option value="#numberformat(i,00)#">#numberformat(i,00)#</option></cfoutput></cfloop></select>';
    HTMLStr = HTMLStr + '<select name="email_start_min' + main_row_count + '">';
    HTMLStr = HTMLStr + '<option value="00" selected>00</option><option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option>';
    HTMLStr = HTMLStr + '<option value="30">30</option><option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option>';
    HTMLStr = HTMLStr + '</select>';
    newCell.innerHTML = HTMLStr;
}

function add_list_control(){
	if($("input[ name = list_id ]:checked").length == 0){
		alert('<cf_get_lang dictionary_id='37346.En az bir liste seçmelisiniz'> !');
		return false;
	}

	var form = $('form[name = add_list]');
	AjaxPageLoad( decodeURIComponent( form.attr( "action" ) + '&' + form.serialize() ).replaceAll("+", " ") + '&loadToObject=secim_list', 'secim_list' );
	return false;
}
</script>