<!--- Sevkiyat Ekip Planlama --->
<cf_xml_page_edit fuseact="stock.dispatch_team_planning">
<cfif isdefined("attributes.planning_id")>
    <cfquery name="get_team_planning" datasource="#dsn3#">
        SELECT 
        	PLANNING_ID, 
            PLANNING_DATE, 
            TEAM_CODE, 
            TEAM_ZONES, 
            ASSETP_ID, 
            ASSETP_KM_FINISH, 
            ASSETP_KM_FINISHDATE, 
            IS_ACTIVE, 
            DETAIL, 
            PROCESS_STAGE, 
            RELATION_COMP_ID, 
            RELATION_CONS_ID, 
            ASSETP_KM_START, 
            ASSETP_KM_STARTDATE, 
            RECORD_EMP, 
            RECORD_DATE, 
            RECORD_IP, 
            RECORD_EMP, 
            UPDATE_DATE,
            UPDATE_IP 
        FROM 
        	DISPATCH_TEAM_PLANNING 
        WHERE 
        	PLANNING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.planning_id#">
    </cfquery>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form_add_team_planning" action="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.emptypopup_add_dispatch_team_planning" method="post" onsubmit="return (unformat_fields());">
            <cf_box_elements vertical="0">
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no="1447.Süreç"></label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="header_"><cf_get_lang_main no="1447.Süreç"></cfsavecontent>
                            <cfif isdefined("get_team_planning.recordcount") and len(get_team_planning.process_stage)>
                                <cf_workcube_process is_upd='0' select_value='#get_team_planning.process_stage#' process_cat_width='100' is_detail='1'>
                            <cfelse>
                                <cf_workcube_process is_upd='0' process_cat_width='100' is_detail='0'>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-team_zones">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='580.Bölge'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="header_"><cf_get_lang_main no='580.Bölge'></cfsavecontent>
                            <cfif isdefined("get_team_planning.recordcount") and len(get_team_planning.team_zones)>
                                <input type="text" name="team_zones" id="team_zones" value="<cfoutput>#get_team_planning.team_zones#</cfoutput>" maxlength="100">
                            <cfelse>
                                <input type="text" name="team_zones" id="team_zones" value="" maxlength="100">
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-planning_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='330.Tarih'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="header_"><cf_get_lang_main no='330.Tarih'></cfsavecontent>
                                <cfsavecontent variable="message"><cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
                                <cfif isdefined("get_team_planning.recordcount") and len(get_team_planning.planning_date)>
                                    <cfinput type="text" name="planning_date" value="#DateFormat(get_team_planning.planning_date,dateformat_style)#" message="#message#" validate="#validate_style#">
                                <cfelse>
                                    <cfinput type="text" name="planning_date" value="" message="#message#" validate="#validate_style#">
                                </cfif>
                                <span class="input-group-addon"><cf_wrk_date_image date_field="planning_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-assetp_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1068.Araç'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="header_"><cf_get_lang_main no='1068.Araç'></cfsavecontent>
                                <cfif isdefined("get_team_planning.recordcount") and len(get_team_planning.assetp_id)>
                                    <cfif Len(get_team_planning.assetp_id)>
                                        <cfquery name="get_assetp_name" datasource="#dsn#">
                                            SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_team_planning.assetp_id#">
                                        </cfquery>
                                    </cfif>
                                    <input type="hidden" id="assetp_id" name="assetp_id" value="<cfoutput>#get_team_planning.assetp_id#</cfoutput>">
                                    <input type="text" id="assetp_name" name="assetp_name" value="<cfif Len(get_team_planning.assetp_id)><cfoutput>#get_assetp_name.assetp#</cfoutput></cfif>" onFocus="AutoComplete_Create('assetp_name','ASSETP','ASSETP','get_assetp_vehicle','','ASSETP_ID,ASSETP','assetp_id,assetp_name','','3','120');" autocomplete="off">
                                <cfelse>
                                    <input type="hidden" id="assetp_id" name="assetp_id" value="">
                                    <input type="text" id="assetp_name" name="assetp_name" value="" onFocus="AutoComplete_Create('assetp_name','ASSETP','ASSETP','get_assetp_vehicle','','ASSETP_ID,ASSETP','assetp_id,assetp_name','','3','120');" autocomplete="off">
                                </cfif>
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=form_add_team_planning.assetp_id&field_name=form_add_team_planning.assetp_name&field_pre_km=form_add_team_planning.assetp_km_start&field_pre_date=form_add_team_planning.assetp_km_startdate&is_active=1','project','popup_list_ship_vehicles')" title="<cf_get_lang_main no='170.Ekle'>"></span>
                            </div>
                        </div>
                    </div>
                    <cfif isdefined("get_team_planning.recordcount") and len(get_team_planning.assetp_id)>
                        <cfif Len(get_team_planning.assetp_id)><!--- Son Km Bilgisini Getir --->
                            <cfquery name="get_assetp_km" datasource="#dsn#">
                                SELECT TOP 1 KM_FINISH, FINISH_DATE FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_team_planning.assetp_id#"> <!--- AND DISPATCH_PLANNING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.planning_id#"> ---> ORDER BY KM_FINISH DESC,KM_CONTROL_ID DESC
                            </cfquery>
                            <cfset assetp_km_last_ = get_assetp_km.km_finish>
                            <cfset assetp_km_lastdate_ = get_assetp_km.finish_date>
                        <cfelse>
                            <cfset assetp_km_last_ = 0>
                            <cfset assetp_km_lastdate_ = "">
                        </cfif>
                    </cfif>
                    <div class="form-group" id="item-assetp_km_startdate">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='591.Araç Önceki Km Tarihi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="header_"><cf_get_lang no='591.Araç Önceki Km Tarihi'></cfsavecontent>
                                <cfsavecontent variable="message"><cf_get_lang no='592.Önceki Km'><cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
                                <cfif isdefined("get_team_planning.recordcount") and len(get_team_planning.assetp_id)>
                                    <cfinput type="text" name="assetp_km_startdate" value="#DateFormat(get_team_planning.assetp_km_startdate,dateformat_style)#" message="#message#" validate="#validate_style#" readonly="yes">
                                <cfelse>
                                    <cfinput type="text" name="assetp_km_startdate" value="" message="#message#" validate="#validate_style#" readonly="yes">
                                </cfif>
                                <span class="input-group-addon"><cf_wrk_date_image date_field="assetp_km_startdate"></span>
                            </div>
                        </div>
                    </div>                    
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-is_active">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='81.Aktif'></label>
                        <label class="col col-8 col-xs-12">
                            <cfsavecontent variable="header_"><cf_get_lang_main no='81.Aktif'></cfsavecontent>
                            <cfif isdefined("get_team_planning.recordcount") and len(get_team_planning.is_active)>
                                <input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_team_planning.is_active eq 1>checked</cfif>>
                            <cfelse>
                                <input type="checkbox" name="is_active" id="is_active" value="1" checked>
                            </cfif>
                        </label>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="header_"><cf_get_lang_main no='217.Açıklama'></cfsavecontent>
                            <cfif isdefined("get_team_planning.recordcount") and len(get_team_planning.detail)>
                                <textarea name="detail" id="detail"><cfoutput>#get_team_planning.detail#</cfoutput></textarea>
                            <cfelse>
                                <textarea name="detail" id="detail"></textarea>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-assetp_km_start">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='593.Araç Önceki Km'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="header_"><cf_get_lang no='593.Araç Önceki Km'></cfsavecontent>
                            <cfif isdefined("assetp_km_last_")>
                                <input type="text" name="assetp_km_start" id="assetp_km_start" value="<cfoutput>#TLFormat(assetp_km_last_,0)#</cfoutput>" onKeyup="return(FormatCurrency(this,event,0));" readonly>
                            <cfelse>
                                <input type="text" name="assetp_km_start" id="assetp_km_start" value="" onKeyup="return(FormatCurrency(this,event));" readonly>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-assetp_km_finishdate">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='594.Araç Son Km Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="header_"><cf_get_lang no='594.Araç Son Km Tarihi'></cfsavecontent>
                                <cfsavecontent variable="message"><cf_get_lang no='595.Son Km'><cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
                                <cfif isdefined("get_team_planning.recordcount") and len(get_team_planning.assetp_km_finishdate)>
                                    <cfif Len(get_team_planning.assetp_km_finishdate)><!--- Eger Son Km Degerleri Girilmis Ise Readonly Olacak --->
                                        <cfinput type="text" name="assetp_km_finishdate" readonly value="#DateFormat(get_team_planning.assetp_km_finishdate,dateformat_style)#" message="#message#" validate="#validate_style#">
                                    <cfelse>
                                        <cfinput type="text" name="assetp_km_finishdate" value="" message="#message#" validate="#validate_style#">
                                    </cfif>					
                                    <cfelse>
                                        <cfinput type="text" name="assetp_km_finishdate" value="" message="#message#" validate="#validate_style#">
                                    </cfif>
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="assetp_km_finishdate"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-assetp_km_finish">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='596.Araç Son Km'></label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="header_"><cf_get_lang no='596.Araç Son Km'></cfsavecontent>
                            <cfif isdefined("get_team_planning.recordcount") and len(get_team_planning.assetp_km_finish)>
                                <cfif Len(get_team_planning.assetp_km_finish)><!--- Eger Son Km Degerleri Girilmis Ise Readonly Olacak --->
                                    <input type="text" name="assetp_km_finish" id="assetp_km_finish" readonly value="<cfoutput>#TLFormat(get_team_planning.assetp_km_finish,0)#</cfoutput>" onKeyup="return(FormatCurrency(this,event,0));"></td>
                                <cfelse>
                                    <input type="text" name="assetp_km_finish" id="assetp_km_finish" value="" onKeyup="return(FormatCurrency(this,event,0));"></td>
                                </cfif>
                            <cfelse>
                                <input type="text" name="assetp_km_finish" id="assetp_km_finish" value="" onKeyup="return(FormatCurrency(this,event));">
                            </cfif>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_seperator title="#getLang("","",45776)#" id="personel">
            <div id="personel">
                <cf_grid_list>
                    <thead>
                        <tr>
                            <th width="20">
                                <input name="record_num" id="record_num" type="hidden" value="0">
                                <a href="javascrript://" onclick="add_row();"  title="<cf_get_lang_main no ='170.Ekle'>"><i class="fa fa-plus"></i></a>
                            </th>
                            <th width="170"><cf_get_lang no='597.Personel'> <cfif ListFind(x_required_personel_company,session.ep.company_id,',')>*</cfif></th>
                            <th width="100"><cf_get_lang no='598.Mesai'></th>
                            <th width="100"><cf_get_lang no='599.Yemek'></th>
                            <th width="100"><cf_get_lang no='600.Pazar Mesaisi'></th>
                        </tr>
                    </thead>
                    <tbody name="table1" id="table1"></tbody>
                </cf_grid_list>
            </div>
            <cfif isdefined("get_team_planning.recordcount") and isdefined("get_team_planning.relation_comp_id") and isdefined("get_team_planning.relation_cons_id")>
                <cfset RecordNumLen = (listlen(get_team_planning.relation_comp_id,',')+listlen(get_team_planning.relation_cons_id,','))>
            <cfelse>
                <cfset RecordNumLen = 0>
            </cfif>
            <cf_seperator title="#getLang("","",45780)#" id="uye">
                <div id="uye">
                    <cf_grid_list>
                        <thead>
                            <tr>
                                <th width="20">
                                    <input name="record_num_team" id="record_num_team" type="hidden" value="<cfoutput>#RecordNumLen#</cfoutput>">
                                    <a href="javascrript://" onclick="add_row_dispatch();"  title="<cf_get_lang_main no ='170.Ekle'>"><i class="fa fa-plus"></i></a>
                                </th>
                                <th><cf_get_lang no='601.Üye İlişkisi'></th>
                            </tr>
                        </thead>
                        <tbody name="table_team" id="table_team">
                            <cfoutput>
                                <cfif isdefined("get_team_planning.recordcount") and len(get_team_planning.relation_comp_id)>
                                    <cfset crtrw = 0>
                                    <cfloop list="#get_team_planning.relation_comp_id#" index="i">
                                        <cfset crtrw = crtrw+1>
                                        <tr id="frm_row_dispatch#crtrw#">
                                            <td><input type="hidden" name="row_kontrol_team#crtrw#" id="row_kontrol_team#crtrw#" value="1">
                                                <a style="cursor:pointer" onClick="sil_dispatch(#crtrw#);"><i class="fa fa-minus"></i></a>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <input type="hidden" name="rel_cons_id#crtrw#" id="rel_cons_id#crtrw#" value="">
                                                        <input type="hidden" name="rel_comp_id#crtrw#" id="rel_comp_id#crtrw#" value="#i#">
                                                        <input type="text" name="rel_row_name#crtrw#" id="rel_row_name#crtrw#" value="#get_par_info(i,1,0,0)#">
                                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac(#crtrw#);" style="cursor:pointer;"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </cfloop>
                                </cfif>
                                <cfif isdefined("get_team_planning.recordcount") and len(get_team_planning.relation_comp_id)>
                                    <cfset crtrw = listlen(get_team_planning.relation_comp_id)>
                                <cfelse>
                                    <cfset crtrw = 0>
                                </cfif>
                                <cfif isdefined("get_team_planning.recordcount") and len(get_team_planning.relation_cons_id)>
                                    <cfloop list="#get_team_planning.relation_cons_id#" index="j">
                                        <cfset crtrw = crtrw+1>
                                        <tr id="frm_row_dispatch#crtrw#">
                                            <td><input type="hidden" name="row_kontrol_team#crtrw#" id="row_kontrol_team#crtrw#" value="1">
                                                <a style="cursor:pointer" onClick="sil_dispatch(#crtrw#);"><img  src="images/delete_list.gif" border="0" align="absmiddle" title="<cf_get_lang_main no='51.Sil'>"></a>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <input type="hidden" name="rel_cons_id#crtrw#" id="rel_cons_id#crtrw#" value="#j#">
                                                        <input type="hidden" name="rel_comp_id#crtrw#" id="rel_comp_id#crtrw#" value="">
                                                        <input type="text" name="rel_row_name#crtrw#" id="rel_row_name#crtrw#" value="#get_cons_info(j,1,0)#">
                                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac(#crtrw#);" style="cursor:pointer;"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </cfloop>
                                </cfif>
                            </cfoutput>
                        </tbody>
                    </cf_grid_list>
                </div>
                <cf_box_footer>
                    <cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
                </cf_box_footer>            
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function kontrol()
{
	x = document.form_add_team_planning.process_stage.selectedIndex;
	if (document.form_add_team_planning.process_stage[x].value == "")
	{ 
		alert ("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='70.Aşama'> !");
		return false;
	}
	if(document.form_add_team_planning.team_zones.value == '')
	{
		alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='580.Bölge'> !");
		return false;
	}
	if(document.form_add_team_planning.planning_date.value == '')
	{
		alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='330.Tarih'> !");
		return false;
	}
	if(document.form_add_team_planning.assetp_id.value == '' || document.form_add_team_planning.assetp_name.value == '')
	{
		alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='1068.Araç'> !");
		return false;
	}
	if(document.form_add_team_planning.assetp_km_finishdate.value != '' && datediff(document.form_add_team_planning.assetp_km_finishdate.value,document.form_add_team_planning.assetp_km_startdate.value,0) > 0)
	{
		alert("<cf_get_lang no='602.Araç Son Km Tarihi Önceki Km Tarihinden Büyük Olmalıdır'> !");
		return false;
	}
	if(document.form_add_team_planning.assetp_km_finish.value != '' && document.form_add_team_planning.assetp_km_start.value >= document.form_add_team_planning.assetp_km_finish.value)
	{
		alert("<cf_get_lang no='627.Araç Son Km Değeri Önceki Km Değerinden Büyük Olmalıdır'> !");
		return false;
	}
	<cfif ListFind(x_required_personel_company,session.ep.company_id,',')><!--- Personel Zorunlulugu olacak sirket idleri  --->
	if(document.form_add_team_planning.record_num.value == 0)
	{
		alert("<cf_get_lang no='603.Ekip Bilgileri İçin Personel Seçmelisiniz'> !");
		return false;
	}
	else
	{
		for(r=1;r<=document.form_add_team_planning.record_num.value;r++)
		{
			if(eval("document.all.row_kontrol"+r).value == 1)
			{
				if(eval("document.all.team_employee_id"+r).value == '' || eval("document.all.team_employee_name"+r).value == '')
				{
					alert(r + ". <cf_get_lang no='604.Satır İçin Personel Seçmelisiniz'> !");
					return false;
				}
			}
		}
	}
	</cfif>

	for(i=1;i<=document.form_add_team_planning.record_num_team;i++)
	{
		alert(1);
		if(eval('document.all.row_kontrol_team'+i).value==1)
		{
			alert(2);
			if(eval('document.all.rel_row_name'+i).value == '')
			{
				alert(3);
				alert(i + ". Satır İçin Lütfen Üye Seçiniz!");
				return false;
			}
		}
	}
}
row_count=0;
function add_row()
{
	row_count++;
	var newRow;
	var newCell;

	newRow = document.getElementById('table1').insertRow();
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);
	
	document.form_add_team_planning.record_num.value=row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<a style="cursor:pointer" onClick="sil(' + row_count + ');"><i class="fa fa-minus"></i></a>';							
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" value="1" name="row_kontrol' + row_count +'"><input type="hidden" name="team_employee_id'+ row_count +'" value=""><input type="text" name="team_employee_name'+ row_count +'" value="" readonly="yes"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac('+ row_count +');" style="cursor:pointer;"></span></div></div>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<div class="form-group"><input type="text" name="overtime_pay'+ row_count +'" onKeyup="return(FormatCurrency(this,event));"></div>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<div class="form-group"><input type="text" name="food_pay'+ row_count +'" onKeyUp="return(FormatCurrency(this,event));"></div>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<div class="form-group"><input type="text" name="sunday_overtime_pay'+ row_count +'" onKeyUp="return(FormatCurrency(this,event));"></div>';
}
function sil(sy)
{
	var my_element=eval("form_add_team_planning.row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
}

row_count_team=document.form_add_team_planning.record_num_team.value;
function add_row_dispatch()
{
	row_count_team++;
	var newRowDis;
	var newCellDis;
	newRowDis = document.getElementById("table_team").insertRow(document.getElementById("table_team").rows.length);
	newRowDis.setAttribute("name","frm_row_dispatch" + row_count_team);
	newRowDis.setAttribute("id","frm_row_dispatch" + row_count_team);	
	document.form_add_team_planning.record_num_team.value=row_count_team;
	newCellDis = newRowDis.insertCell(newRowDis.cells.length);
	newCellDis.innerHTML = '<input type="hidden" name="row_kontrol_team'+row_count_team+'" value="1"><a style="cursor:pointer" onclick="sil_dispatch(' + row_count_team + ');"><img src="images/delete_list.gif" border="0"></a>';
	newCellDis = newRowDis.insertCell(newRowDis.cells.length);
	newCellDis.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="rel_row_name'+row_count_team+'" value="" readonly> <input type="hidden" name="rel_cons_id'+row_count_team+'" value=""><input type="hidden" name="rel_comp_id'+row_count_team+'" value=""><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencre_ac_team('+row_count_team+');"></span></div></div>';
}
function sil_dispatch(sy)
{
	var my_element_dis=eval("form_add_team_planning.row_kontrol_team"+sy);
	my_element_dis.value=0;
	var my_element_dis=eval("frm_row_dispatch"+sy);
	my_element_dis.style.display="none";
}
function pencre_ac_team(no)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=7,8&field_consumer=form_add_team_planning.rel_cons_id'+no+'&field_comp_id=form_add_team_planning.rel_comp_id'+no+'&field_member_name=form_add_team_planning.rel_row_name'+no,'list');
}



function pencere_ac(no)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_add_team_planning.team_employee_id'+ no +'&field_name=form_add_team_planning.team_employee_name'+ no +'&select_list=1','list');
}

function unformat_fields()
{
	form_add_team_planning.assetp_km_start.value = filterNum(form_add_team_planning.assetp_km_start.value);
	form_add_team_planning.assetp_km_finish.value = filterNum(form_add_team_planning.assetp_km_finish.value);
	for(r=1;r<=form_add_team_planning.record_num.value;r++)
	{
		eval("document.form_add_team_planning.overtime_pay"+r).value = filterNum(eval("document.form_add_team_planning.overtime_pay"+r).value);
		eval("document.form_add_team_planning.food_pay"+r).value = filterNum(eval("document.form_add_team_planning.food_pay"+r).value);
		eval("document.form_add_team_planning.sunday_overtime_pay"+r).value = filterNum(eval("document.form_add_team_planning.sunday_overtime_pay"+r).value);
	}	
}
</script>
