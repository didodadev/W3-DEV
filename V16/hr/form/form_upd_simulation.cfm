<cfquery name="GET_SIMULATION" datasource="#dsn#">
	SELECT 
		ORGANIZATION_SIMULATION.RECORD_EMP,
		ORGANIZATION_SIMULATION.RECORD_DATE,
		ORGANIZATION_SIMULATION.UPDATE_EMP,
		ORGANIZATION_SIMULATION.UPDATE_DATE,
		ORGANIZATION_SIMULATION.SIMULATION_ID,
		ORGANIZATION_SIMULATION.SIMULATION_HEAD,
		ORGANIZATION_SIMULATION.RECORD_DATE,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME AS POS_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME AS POS_SURNAME,
		EMPLOYEE_POSITIONS.POSITION_NAME,
		EMPLOYEE_POSITIONS.POSITION_ID,
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.POSITION_CODE
	FROM 
		ORGANIZATION_SIMULATION,
		EMPLOYEES,
		EMPLOYEE_POSITIONS
	WHERE
		EMPLOYEES.EMPLOYEE_ID = ORGANIZATION_SIMULATION.EMPLOYEE_ID AND 
		EMPLOYEE_POSITIONS.POSITION_CODE = ORGANIZATION_SIMULATION.POSITION_CODE AND
		ORGANIZATION_SIMULATION.SIMULATION_ID = #attributes.simulation_id#
	ORDER BY 
		ORGANIZATION_SIMULATION.SIMULATION_ID 
	DESC
</cfquery>
<cfquery name="GET_ROW" datasource="#dsn#">
	SELECT 
		ORGANIZATION_SIMULATION_ROWS.HIERARCHY,
        EMPLOYEE_POSITIONS.POSITION_ID,
		ORGANIZATION_SIMULATION_ROWS.ROW_ID,
		ORGANIZATION_SIMULATION_ROWS.POSITION_TYPE,
		ORGANIZATION_SIMULATION_ROWS.STAGE_ID,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
		EMPLOYEE_POSITIONS.POSITION_NAME 
	FROM 
		ORGANIZATION_SIMULATION_ROWS,
		EMPLOYEE_POSITIONS
	WHERE 
		ORGANIZATION_SIMULATION_ROWS.SIMULATION_ID = #attributes.simulation_id# AND 
		ORGANIZATION_SIMULATION_ROWS.POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE
	ORDER BY
		ORGANIZATION_SIMULATION_ROWS.HIERARCHY
</cfquery>
<cf_catalystHeader>
<!--- <cfsavecontent variable="img"><a href="<cfoutput>#request.self#?fuseaction=hr.form_add_simulation</cfoutput>"><img src="../images/plus1.gif"></a></cfsavecontent> --->
<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
    <cf_box title="#getLang('','Güncelle',57464)#">
        <cfform name="addsimulation" action="#request.self#?fuseaction=hr.emptypopup_upd_simulation" method="post">
            <input type="hidden" name="simulation_id" id="simulation_id" value="<cfoutput>#attributes.simulation_id#</cfoutput>">
            <cf_box_elements> 
                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id='58820.Başlık'>*</label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="text" name="head" id="head" maxlength="180" value="<cfoutput>#get_simulation.simulation_head#</cfoutput>">
                    </div>
                </div>
                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id='58497.Pozisyon'>*</label>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_simulation.employee_id#</cfoutput>">
                            <input type="hidden" name="position_code" id="position_code" value="<cfoutput>#get_simulation.position_code#</cfoutput>">
                            <input type="hidden" name="position_id" id="position_id" value="<cfoutput>#get_simulation.position_id#</cfoutput>">
                            <input type="text" name="emp_name" id="emp_name" value="<cfoutput>#get_simulation.employee_name# #get_simulation.employee_surname#</cfoutput>" required="yes" readonly="">
                            <cfif get_row.recordcount eq 0>
                            <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=addsimulation.employee_id&field_code=addsimulation.position_code&field_name=addsimulation.emp_name&field_id=addsimulation.position_id</cfoutput>','list')"></span>
                            </cfif> 
                        </div>
                    </div>
                    <div class="col col-4 col-md-8 col-sm-8 col-xs-12">
                        - <cfoutput>#get_simulation.position_name#</cfoutput>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_record_info query_name="get_simulation">
                <cf_workcube_buttons is_upd='1' is_delete='0' add_function='control()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
    <cf_box title="#getLang('','Çizim',60648)#">
        <cfform name="add_pos" action="" id="add_pos">
            <input type="hidden" name="upper_position_code" id="upper_position_code" value="<cfoutput>#get_simulation.position_code#</cfoutput>">
            <input type="hidden" name="upper_position" id="upper_position" value="<cfoutput>#get_simulation.employee_name# #get_simulation.employee_surname#</cfoutput>" readonly>
            <cf_box_elements>
                <div class="form-group col col-6 col col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id ='56393.Basamak Aşağı'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="alt_cizim_sayisi" id="alt_cizim_sayisi">
                            <option value="1"><cf_get_lang dictionary_id ='55781.Aşağı'></option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                            <option value="5">5</option>
                            <option value="6">6</option>
                            <option value="7">7</option>
                            <option value="8">8</option>
                            <option value="9">9</option>
                            <option value="10">10</option>
                        </select>
                    </div>
                </div>
                <div class="form-group col col-6 col col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id ='29792.Tasarım'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="tasarim_tipi" id="tasarim_tipi">
                            <!--- <option value="1" selected><cf_get_lang dictionary_id ='29794.Yatay'></option> --->
                            <option value="2"><cf_get_lang dictionary_id ='29793.Dikey'></option>
                            <!--- <option value="3"><cf_get_lang dictionary_id='58901.Ağaç'></option> --->
                        </select>
                    </div>
                </div>
                <cfif session.ep.ehesap>
                    <div class="form-group col col-6 col col-md-6 col-sm-6 col-xs-12">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label><cf_get_lang dictionary_id ='56069.Pozisyon Çalışanı'></label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <label><input type="checkbox" value="1" name="is_empty_pos" id="is_empty_pos"><cf_get_lang dictionary_id ='58433.Boş Pozisyonları Göster'></label>
                        </div>
                    </div>
                </cfif>
                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="col col-2 col-md-2 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id ='56331.Bilgiler'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12 padding-0">
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <label><input type="checkbox" value="1" name="is_unvan" id="is_unvan"><cf_get_lang dictionary_id ='57571.Ünvan'></label>
                        </div>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <label><input type="checkbox" value="1" name="is_pozisyon" id="is_pozisyon"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
                        </div>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <label><input type="checkbox" value="1" name="is_pozisyon_tipi" id="is_pozisyon_tipi"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'> </label>
                        </div>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <label><input type="checkbox" value="1" name="is_resim" id="is_resim"><cf_get_lang dictionary_id='58080.Resim'> </label>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-10 col-xs-12" style="height:32px;margin:5px 0 0 0;"></div>
                <input type="button" class="ui-wrk-btn ui-wrk-btn-success" value="<cf_get_lang dictionary_id='56376.Çizim Yap'>" onClick="kontrol();">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent  variable="message"><cf_get_lang dictionary_id="57771.Detay"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_grid_list sort="1">
            <thead>
                <tr>
                    <th width="25"><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                    <th><cf_get_lang dictionary_id ='57576.Çalışan'></th>
                    <th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
                    <th width="120"><cf_get_lang dictionary_id='58710.Kademe'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none"><a href="javascript://"><i class="fa fa-pencil"></i></a></th>
                    <th width="20" class="header_icn_none"><a href="javascript://"><i class="fa fa-minus"></i></a></th>
                    <th width="20" class="header_icn_none"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_add_simulation_row&simulation_id=#simulation_id#&up_position_id=#get_simulation.position_id#</cfoutput>','small')"><i class="fa fa-plus"></i></a></th>
                    
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_row.recordcount>
                    <cfoutput query="get_row">
                        <cfquery name="GET_POSITION_CATS" datasource="#dsn#">
                            SELECT POSITION_CAT_ID, POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = #position_type#
                        </cfquery>
                        <cfquery name="GET_ORGANIZATION_STEPS" datasource="#dsn#">
                            SELECT ORGANIZATION_STEP_NAME FROM SETUP_ORGANIZATION_STEPS WHERE ORGANIZATION_STEP_ID = #stage_id#
                        </cfquery>
                        <tr>
                        <td>#currentrow#</td>
                        <td><!--- <cfloop from="1" to="#listlen(hierarchy,'.')-2#" index="i">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</cfloop> --->#position_name#</td>
                        <td>#employee_name# #employee_surname#</td>
                        <td>#get_position_cats.position_cat#</td>
                        <td>#get_organization_steps.organization_step_name#</td>
                        <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_upd_simulation_row&row_id=#row_id#','small')"><i class="fa fa-pencil"></i></a></td>
                        <td><a href="javascript://" onClick="javascript:if (confirm('Çalışanı Siliyorsunuz Emin misiniz?')) windowopen('#request.self#?fuseaction=hr.emptypopup_del_simulation_row&row_id=#row_id#','small'); else return false;"><i class="fa fa-minus" title="<cf_get_lang_main no='51.Sil'>"></i></a></td>
                        <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_add_simulation_row&simulation_id=#simulation_id#&up_position_id=#position_id#&hierarchy=#hierarchy#','small')"><i class="fa fa-plus" title="Alt Amir Ekle"></i></a></td>
                                            
                    
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="10"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>
<script type="text/javascript">
function control()
{
	if(addsimulation.head.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'>!");
		return false;
	}
	if(addsimulation.position_code.value == "")
	{
		alert("<cf_get_lang dictionary_id ='56321.Lütfen Pozisyon Giriniz'>!");
		return false;
	}
}
function kontrol()
{
	//openBoxDraggable('');
    url_ser = $("#add_pos").serialize();
	//add_pos.action='<cfoutput>#request.self#?fuseaction=hr.popup_draw_simulation_hierarchy&simulation_id=#attributes.simulation_id#</cfoutput>'+'&'+url_ser;
    openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_draw_simulation_hierarchy&simulation_id=#attributes.simulation_id#</cfoutput>'+'&'+url_ser);
}
</script>
