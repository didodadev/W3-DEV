<cf_catalystHeader>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
            <cf_box_data asname="care_states" function="V16.service.cfc.service_care:CARE_STATES">
            <cfform name="service_care">
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <cf_duxi type="hidden" name="id" id="id" value="#URL.ID#">
                        <cf_duxi name="status" type="checkbox" data="data_service_care.status" id="status" value="1" hint="Aktif" label="57493">           
                        <cf_duxi name="care_description" type="text" data="data_service_care.care_description" id="care_description" hint="Başlık" value="" label="58820" maxlength="100">
                        <cf_duxi type="hidden" name="stock_id">
                        <cf_duxi type="hidden" name="product_id" data="data_service_care.product_id" id="product_id" value="">                  
                        <cfif len(data_service_care.product_name)>
                            <cf_duxi type="text" name="product_name" id="product_name" data="data_service_care.product_name" hint="Ürün *" label="63258" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','3','200');">
                        <cfelse>
                            <cf_duxi type="text" name="product_name"  id="product_name" value="" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID','product_id','','3','200');" hint="Ürün *" label="63258">
                        </cfif>      
                        <cf_duxi name="serial_no" type="text" id="serial_no" hint="Seri No" data="data_service_care.serial_no" value="" label="57637">      
                        <cf_duxi name="mark" type="text" id="mark" value="" label="58847" data="data_service_care.mark" hint="Marka">
                        <cf_duxi type="hidden" name="member_id" id="member_id" value="" data="data_service_care.company_authorized">
                        <cf_duxi type="hidden" name="member_type" id="member_type" value="" data="data_service_care.company_authorized_type">
                        <cfset member_name_ = "">
                        <cfif data_service_care.company_authorized_type is "partner">
                            <cfset member_name_ = data_service_care.name>
                            <cfset member_name_ = listappend(member_name_,data_service_care.surname,' ')>
                        </cfif> 
                        <cfif data_service_care.company_authorized_type is "consumer">
                            <cfset member_name_ = data_service_care.NAME_CONSUMER>
                            <cfset member_name_ = listappend(member_name_,data_service_care.SURNAME_CONSUMER,' ')>    
                        </cfif>
                        <cf_duxi type="hidden" name="member_id" id="member_id" data="data_service_care.company_authorized">
                        <cf_duxi type="hidden" name="member_type" id="member_type" data="data_service_care.company_authorized_type">
                        <cfif isDefined('data_service_care.COMPANY_FN') and len(data_service_care.COMPANY_FN)>
                            <cf_duxi type="text" name="company" id="company" data="data_service_care.COMPANY_FN"  hint="Alıcı Firma *" label="63259" threepoint="#request.self#?fuseaction=objects.popup_list_pars&field_id=service_care.member_id&field_comp_name=service_care.company&field_name=service_care.member_name&field_type=service_care.member_type&select_list=2,3,5,6">
                        <cfelse>
                            <cf_duxi type="text" name="company" id="company" value="" hint="Alıcı Firma *" label="63259" threepoint="#request.self#?fuseaction=objects.popup_list_pars&field_id=service_care.member_id&field_comp_name=service_care.company&field_name=service_care.member_name&field_type=service_care.member_type&select_list=2,3,5,6">
                        </cfif>      
                        <cfset emp_name_1 = ''>    
                        <cfset emp_name_2 = ''>    

                        <cfset emp_name_1 = #get_emp_info(data_service_care.service_employee,0,0)#>
                        <cfset emp_name_2 = #get_emp_info(data_service_care.service_employee2,0,0)#>    

                        <cf_duxi name="member_name" type="text" id="member_name" data="member_name_" value="" Hint="Yetkili *" label="63260">
                        <cf_duxi name="employee_id" id="employee_id" type="hidden" value="" data="data_service_care.service_employee">
                        <cf_duxi name="employee" type="text" id="employee" value="" data="emp_name_1" hint="Servis Çalışanı 1" label="63262" threepoint= "#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=service_care.employee_id&field_name=service_care.employee&select_list=1">
                        <cf_duxi type="hidden" name="employee_id2" id="employee_id2" data="data_service_care.service_employee2">
                        <cf_duxi type="text" name="employee2" id="employee2" data="emp_name_2" hint="Servis Çalışanı 2" label="63263" threepoint= "#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=service_care.employee_id2&field_name=service_care.employee2&select_list=1">
                        <cfset comp_service = ''>
                        <cfset comp_official_name = ''>
                        <cfset comp_official_surname = ''>
                        <cfif data_service_care.service_authorized_type is "partner">
                            <cfset comp_service = data_service_care.COMPANY_SP>
                            <cfset comp_official_name = data_service_care.NAME_SP> 
                            <cfset comp_official_surname = data_service_care.SURNAME_SP>
                        </cfif> 
                        <cfif data_service_care.service_authorized_type is "consumer">
                            <cfset comp_service = data_service_care.COMPANY_CS>
                            <cfset comp_official_name = data_service_care.NAME_CS> 
                            <cfset comp_official_surname = data_service_care.SURNAME_CS>  
                        </cfif>

                        <cf_duxi type="hidden" name="service_member_id" id="service_member_id" data="data_service_care.service_authorized_id">
                        <cf_duxi type="hidden" name="service_member_type" id="service_member_type" data="data_service_care.service_authorized_type">
                        
                        <cf_duxi type="text" name="service_company" id="service_company" data="comp_service" hint="Servis Firması" label="41958" threepoint= "#request.self#?fuseaction=objects.popup_list_pars&field_id=service_care.service_member_id&field_comp_name=service_care.service_company&field_name=service_care.service_member_name&field_type=service_care.service_member_type&select_list=2,3,5,6">                   
                        <cfif len(data_service_care.service_authorized_type)>
                            <cf_duxi type="text" name="service_member_name" id="service_member_name" value="#comp_official_name# #comp_official_surname#" readonly="" hint="Servis Yetkilisi" label="47897">
                        <cfelse>
                            <cf_duxi type="text" name="service_member_name" id="service_member_name" value="" readonly="" hint="Servis Yetkilisi" label="47897">
                        </cfif>
                        <cf_duxi name="aim" type="textarea" id="aim" data="data_service_care.detail" value="" hint="Kullanım Amacı" label="56925">
                        <cf_duxi name="sales_date" data_control="date" data="data_service_care.sales_date" id="sales_date" type="text" hint="Satış Tarihi" validate="#validate_style#" label="41754">                                                         
                        <cf_duxi name="guaranty_start_date" data="data_service_care.guaranty_start_date" data_control="date" id="guaranty_start_date" type="text" hint="Garanti Başlangıç Tarihi" label="63212">                                             
                        <cf_duxi name="guaranty_finish_date" data="data_service_care.guaranty_finish_date" data_control="date" id="guaranty_finish_date" type="text" hint="Garanti Bitiş Tarihi" label="35287">                                             
                        <cf_duxi name="start_date" data_control="date" data="data_service_care.start_date" id="start_date" type="text" hint="Bakım Başlangıç Tarihi *" label="63261">                                   
                        <cf_duxi name="finish_date" data_control="date" data="data_service_care.finish_date" id="finish_date" type="text" hint="Bakım Bitiş Tarihi *" label="63349">                                
                        <cf_duxi name="document" type="upload" id="document" value="" hint="Kullanım Belgesi" label="41755">       
                        <cfif len(data_service_care.file_name)>
                            <div class="col col-5 col-xs-12">
                                <cfoutput><a href="#file_web_path#service/#data_service_care.file_name#" target="_blank">#data_service_care.file_name#</a></cfoutput>
                            </div>
                        </cfif>
                        <cf_seperator id="care_list" title="#getLang('','İstasyon Bakım','36710')#"  is_closed="1">
                        <div id="care_list">
                            <cf_grid_list>
                                <thead>
                                    <tr>
                                        <th width="15"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=service.popup_list_care_type&id=#url.id#</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                                        <th><cf_get_lang dictionary_id='33171.Bakım Tipi'></th>
                                        <th><cf_get_lang dictionary_id='32691.Periyot'></th>
                                        <th><cf_get_lang dictionary_id='57490.Gün'></th>
                                        <th><cf_get_lang dictionary_id='57491.Saat'></th>
                                        <th><cf_get_lang dictionary_id='58127.Dakika'></th>
                                    </tr>
                                </thead>
                                <tbody name="table1" id="table1">
                                <cfoutput>
                                    <cfloop query="care_states">
                                        <tr>
                                            <td><cfif not listfindnocase(denied_pages,'service.emptypopup_del_care_states')>
                                                    <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=service.emptypopup_del_care_states&id=#care_states.care_id#&service_id=#url.id#');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
                                                </cfif>
                                            </td>
                                            <td>#care_states.service_care#</td>
                                            <td><select name="period#currentrow#" id="period#currentrow#">
                                                    <option value="1" <cfif period_id eq 1>selected</cfif>><cf_get_lang dictionary_id='33155.Haftada Bir'></option>
                                                    <option value="2" <cfif period_id eq 2>selected</cfif>>15 <cf_get_lang dictionary_id='41777.Günde Bir'></option>
                                                    <option value="3" <cfif period_id eq 3>selected</cfif>><cf_get_lang dictionary_id='33156.Ayda Bir'></option>
                                                    <option value="4" <cfif period_id eq 4>selected</cfif>>2 <cf_get_lang dictionary_id='33156.Ayda Bir'></option>
                                                    <option value="5" <cfif period_id eq 5>selected</cfif>>3 <cf_get_lang dictionary_id='33156.Ayda Bir'></option>
                                                    <option value="6" <cfif period_id eq 6>selected</cfif>>4 <cf_get_lang dictionary_id='33156.Ayda Bir'></option>
                                                    <option value="7" <cfif period_id eq 7>selected</cfif>>6 <cf_get_lang dictionary_id='33156.Ayda Bir'></option>
                                                    <option value="8" <cfif period_id eq 8>selected</cfif>><cf_get_lang dictionary_id='47950.Yılda Bir'></option>
                                                    <option value="9" <cfif period_id eq 9>selected</cfif>>5 <cf_get_lang dictionary_id='47950.Yılda Bir'></option>
                                                </select>
                                            </td>
                                            <td><select name="day#currentrow#" id="day#currentrow#">
                                                    <cfloop from="0" to="30" index="i">
                                                        <option value="#i#" <cfif i eq care_states.care_day>selected</cfif>>#i#</option>
                                                    </cfloop>
                                                </select>
                                            </td>   
                                            <td><cf_wrkTimeFormat name="hour#currentrow#" value="#care_states.care_hour#">
                                            </td>
                                            <td><select name="minute#currentrow#" id="minute#currentrow#">
                                                    <cfloop from="0" to="60" index="i" step="5">
                                                        <option value="#i#" <cfif i eq care_states.care_minute>selected</cfif>>#i#</option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>
                                    </cfloop>
                                </cfoutput>
                                </tbody>
                            </cf_grid_list>   
                        </div>                         
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_workcube_buttons 
                    is_upd='1' 
                    delete_page_url="#request.self#?fuseaction=service.emptypopup_del_service_care&id=#url.id#&head=#data_service_care.care_description#"
                    data_action='/V16/service/cfc/service_care:UPD_SERVICE_CARE'
                    next_page='#request.self#?fuseaction=service.list_care&event=upd&id='>
                </cf_box_footer>         
            </cfform>
        </cf_box>
    </div>
    <script type="text/javascript">
        function kontrol()
        {
            if(care_description.value == '')
            {
                alertObject({message: "<cf_get_lang dictionary_id='63344.Lütfen Başlığı Doldurunuz'>!"});
                return false;
            }
            if(product_name.value == '')
            {
                alertObject({message: "<cf_get_lang dictionary_id='63345.Lütfen Ürün Bilgisini doldurunuz'>!"});
                return false;
            }
            if(member_name.value == '')
            {
                alertObject({message: "<cf_get_lang dictionary_id='63346.Lütfen Yetkili Bilgisini doldurunuz'>!"});
                return false;
            }
            if(start_date.value == '')
            {
                alertObject({message: "<cf_get_lang dictionary_id='63347.Lütfen Bakım Başlangıç Tarihini doldurunuz'>!"});
                return false;
            }
            if(finish_date.value == '')
            {
                alertObject({message: "<cf_get_lang dictionary_id='63348.Lütfen Bakım Bitiş Tarihini doldurunuz'>!"});
                return false;
            }
            return true;
        }
    </script>
            