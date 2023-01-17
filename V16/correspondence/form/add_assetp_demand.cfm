<cf_get_lang_set module_name="correspondence">
    <cfinclude template="../query/get_assetp_cats.cfm">
    <cfinclude template="../query/get_usage_purpose.cfm">
    <cfinclude template="../query/get_brand.cfm">
    
   
    <cfquery name="GET_REQUEST_STAGE" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%assetcare.list_assetp_demands%">
        ORDER BY 
            PTR.LINE_NUMBER
    </cfquery>
    
    <!---
        Yorum satırı içerisindeydi, ne olur ne olmaz diye bırakıyorum buraya.
    
        <td>
            <cf_get_lang_main no='160.Departman'>*
        </td>
        <td>
            <input type="hidden" name="department_id" id="department_id" value="">
            <input type="text" name="department" id="department" readonly style="width:170px;">
            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=add_assetp_demand.department_id&field_dep_branch_name=add_assetp_demand.department&is_get_all=1','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='160.Departman'>" align="absmiddle" border="0"></a>
        </td>
    
    --->
    <cfparam name="attributes.modal_id" default="">
    
   
        
        <cfset action_page = '#request.self#?fuseaction=correspondence.emptypopup_add_assetp_demand'>
   
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','varlık talepleri','47806')#"popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
            <cfform name="add_assetp_demand" method="post" action="#action_page#">
                <cfinput type="hidden" name="modal_id" value="#attributes.modal_id#">
                <cf_basket_form id="form_add_assetp">
                    <cf_box_elements>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="asset_p_status" id="asset_p_status" value="1" checked><cf_get_lang dictionary_id='57493.Aktif'></div>
							</div>
                            <div class="form-group" id="item-cat_id">
                                <label class="col col-4 col-xs-4"><cf_get_lang dictionary_id='56930.Varlık Tipi'>*</label>
                                <div class="col col-8 col-xs-8">
                                    <select name="cat_id" id="cat_id" onChange="del_brand();">
                                        <cfoutput query="get_assetp_cats">
                                            <option value="#assetp_catid#">#assetp_cat#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-assetp_sub_catid">
                                <label class="col col-4 col-xs-4" nowrap="nowrap"><cf_get_lang dictionary_id='39072.Varlık Alt Kategorisi'></label>
                                <div class="col col-8 col-xs-8">
                                    <select name="assetp_sub_catid" id="assetp_sub_catid">
                                        <option value=""><cf_get_lang dictionary_id='39072.Varlık Alt Kategorisi'></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-employee">
                                <label class="col col-4 col-xs-4" nowrap="nowrap"><cf_get_lang dictionary_id='276.Talep Eden'> *</label>
                                <div class="col col-8 col-xs-8">
                                    <div class="input-group">
                                        <cfoutput>
                                            <cfquery name="get_emp_name" datasource="#dsn#">
                                                SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #session.ep.userid#
                                            </cfquery>
                                            <input type="hidden" name="employee_id" id="employee_id" value="#session.ep.userid#">
                                            <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='276.Talep Eden'> !</cfsavecontent>
                                            <cfinput type="text" name="employee" value="#get_emp_name.EMPLOYEE_NAME# #get_emp_name.EMPLOYEE_SURNAME#" required="yes" message="#message#" readonly="yes">
                                            <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_assetp_demand.employee_id&field_name=add_assetp_demand.employee&upper_pos_code=#session.ep.position_code#&select_list=1','list')"></span>
                                        </cfoutput>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-usage_purpose_id">
                                <label class="col col-4 col-xs-4" nowrap="nowrap"><cf_get_lang dictionary_id='47901.Kullanım Amacı'>*</label>
                                <div class="col col-8 col-xs-8">
                                    <select name="usage_purpose_id" id="usage_purpose_id">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_usage_purpose">
                                            <option value="#usage_purpose_id#">#usage_purpose#</option> 
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-process">
                                <label class="col col-4 col-xs-4"><cf_get_lang dictionary_id='58859.Süreç'></label>
                                <div class="col col-8 col-xs-8">
                                    <select name="process_stage" id="process_stage" >
                                        <cfoutput query="GET_REQUEST_STAGE">
                                            <option value="#process_row_id#">#stage#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-brand_name">
                                <label class="col col-4 col-xs-4"><cf_get_lang dictionary_id='58847.Marka'>/ <cf_get_lang dictionary_id='30041.Marka Tipi'></label>
                                <div class="col col-8 col-xs-8">
                                    <div class="input-group">
                                        <input type="hidden" name="brand_type_id" id="brand_type_id" value="">
                                        <input type="text" name="brand_name" id="brand_name" value="">
                                        <span class="input-group-addon btn_Pointer icon-ellipsis" onClick="pencere_ac()"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-make_year">
                                <label class="col col-4 col-xs-4"><cf_get_lang dictionary_id='58225.Model'></label>
                                <div class="col col-8 col-xs-8">
                                    <select name="make_year" id="make_year" style="width:206px;">
                                        <option value=""></option>
                                        <cfset yil = dateformat(dateadd("yyyy",1,now()),"yyyy")>
                                        <cfoutput>
                                            <cfloop from="#yil#" to="1970" index="i" step="-1">
                                                <option value="#i#">#i#</option>
                                            </cfloop>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-request_date">
                                <label class="col col-4 col-xs-4"><cf_get_lang dictionary_id='51084.Talep Tarihi'>*</label>
                                <div class="col col-8 col-xs-8">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='330.Tarih'> !</cfsavecontent>
                                        <cfinput type="text" name="request_date" value="#dateformat(now(),dateformat_style)#" maxlength="10" validate="#validate_style#" required="yes" message="#message#" style="width:206px;">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="request_date"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="3" sort="true">
                            <label style="display:none!important;"><cf_get_lang dictionary_id='36199.Açıklama'></label>	
                                <cfmodule
                                template="/fckeditor/fckeditor.cfm"
                                toolbarset="Basic"
                                basepath="/fckeditor/"
                                instancename="detail"
                                valign="top"
                                value=""
                                width="600"
                                height="180">
                        </div>
                    </cf_box_elements>
                    <cf_box_footer>
                        <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                    </cf_box_footer>
                </cf_basket_form>
            </cfform>
        </cf_box>
    </div>
    <script type="text/javascript">
        function kontrol()
        {
            if($("#usage_purpose_id").val()==''){
    
                <cfoutput>
                alert("#getLang('correspondence',114)#");
                return false;
                </cfoutput>
            }
            return process_cat_control();
        }
        function pencere_ac()
        {
            x = document.add_assetp_demand.cat_id.selectedIndex;
            if (document.add_assetp_demand.cat_id[x].value == "")
            { 
                alert ("<cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='56930.Varlık Tipi'>!");
                return false;
            }
            else
                y = document.add_assetp_demand.cat_id[x].value;
                windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_brand_type&field_brand_type_id=add_assetp_demand.brand_type_id&field_brand_name=add_assetp_demand.brand_name&cat_id=' + y ,'list','popup_list_brand_type');
        }
        function del_brand()
        {
            document.add_assetp_demand.brand_type_id.value = '';
            document.add_assetp_demand.brand_name.value = '';
            for (i=$('#assetp_sub_catid option').length-1 ; i>-1 ; i--)
        {   
            $('#assetp_sub_catid option').eq(i).remove();
        }	
            /*for (i=document.getElementById("assetp_sub_catid").options.length-1;i>-1;i--)
            {
                document.getElementById("assetp_sub_catid").options.remove(i);
            }	*/
            var get_assetp_sub_cat = wrk_query("SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = " + $('#cat_id ').val()+" ORDER BY ASSETP_SUB_CAT","dsn");
            if(get_assetp_sub_cat.recordcount > 0)
            {
                var selectBox = $("#assetp_sub_catid").attr('disabled');
                if(selectBox) $("#assetp_sub_catid").removeAttr('disabled');
                $("#assetp_sub_catid").append($("<option></option>").attr("value", '').text("<cf_get_lang dictionary_id='57734.Seçiniz'>"));
                    
                for(i = 1;i<=get_assetp_sub_cat.recordcount;++i)
                {
                    $("#assetp_sub_catid").append($("<option></option>").attr("value", get_assetp_sub_cat.ASSETP_SUB_CATID[i-1]).text(get_assetp_sub_cat.ASSETP_SUB_CAT[i-1]));
    
                }
            }
            else{
                
            $("#assetp_sub_catid").attr('disabled','disabled');
            
        }
        }
    </script>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
    