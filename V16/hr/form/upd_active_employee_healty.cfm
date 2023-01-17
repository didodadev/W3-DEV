<cf_xml_page_edit fuseact='hr.popup_add_employee_healty'>
<cfquery name="get_healty" datasource="#DSN#" >
	SELECT
		EH.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_STATUS,
		E.PHOTO,
		E.PHOTO_SERVER_ID,
		ED.SEX,
		EI.BLOOD_TYPE,
		EI.BIRTH_DATE,
		EI.TC_IDENTY_NO,
		EP.POSITION_NAME,
		(SELECT TOP 1 D.DEPARTMENT_HEAD FROM DEPARTMENT D,EMPLOYEE_POSITIONS EP WHERE D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND EP.IS_MASTER = 1) DEPARTMENT_HEAD,
		(SELECT TOP 1 B.BRANCH_NAME FROM BRANCH B,DEPARTMENT D,EMPLOYEE_POSITIONS EP WHERE B.BRANCH_ID = D.BRANCH_ID AND D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND EP.IS_MASTER = 1) BRANCH_NAME,
		(SELECT TOP 1 O.NICK_NAME FROM BRANCH B,DEPARTMENT D,EMPLOYEE_POSITIONS EP,OUR_COMPANY O WHERE B.BRANCH_ID = D.BRANCH_ID AND D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND EP.IS_MASTER = 1 AND O.COMP_ID = B.COMPANY_ID) NICK_NAME,
		(SELECT TOP 1 ER.NAME +' '+ ER.SURNAME NAME FROM EMPLOYEES_RELATIVES ER WHERE EH.RELATIVE_ID = ER.RELATIVE_ID) RELATIVE_NAME
	FROM
		EMPLOYEE_HEALTY EH,
		EMPLOYEES_IDENTY EI,
		EMPLOYEES_DETAIL ED,
		EMPLOYEES E
		LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
	WHERE
		ED.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		EI.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		EH.EMPLOYEE_ID = E.EMPLOYEE_ID 
		<cfif isdefined("attributes.EMPLOYEE_ID") and len(attributes.EMPLOYEE_ID)>
			AND E.EMPLOYEE_ID=#attributes.EMPLOYEE_ID#
		</cfif>
	ORDER BY
		INSPECTION_DATE DESC
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="47131.İşyeri Sağlık Muayeneleri"></cfsavecontent>
<cf_box title="#message#"  scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="upd_healty_" method="post" action="#request.self#?fuseaction=hr.emptypopup_upd_employee_healty">
    	<input type="hidden" name="healty_id" id="healty_id" value="<cfoutput>#attributes.healty_id#</cfoutput>">
        <input type="hidden" name="is_status" id="is_status" value="1">
        <input type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="<cfoutput>#attributes.EMPLOYEE_ID#</cfoutput>">
       <cf_box_elements>
    <div class="col col-2 col-md-2 col-sm-2 col-xs-2">
        <cfif len(get_healty.photo)>
            <cf_get_server_file output_file="hr/#get_healty.photo#" output_server="#get_healty.photo_server_id#" output_type="0" image_width="120" image_height="150">
        <cfelse>
            <cfif get_healty.sex eq 1>
                <img src="/images/male.jpg" width="120" height="150" title="<cf_get_lang dictionary_id='58546.Yok'>">
            <cfelse>
                <img src="/images/female.jpg" width="120" height="150" title="<cf_get_lang dictionary_id='58546.Yok'>">
            </cfif>
        </cfif>
    </div>
        <div class="col col-5 col-md-5 col-sm-5 col-xs-5">
            <div class="form-group" id="item-status">
                <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
            <div class="col col-8 col-md-6 col-xs-12">
                <input type="checkbox" name="status" id="status" value="1" <cfif get_healty.status eq 1>checked</cfif>>
            </div>
            </div>
            <div class="form-group" id="item-EMPLOYEE_NAME">
                <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57570.Ad Soyad'></label>
            <div class="col col-8 col-md-6 col-xs-12">
                <cfoutput>#get_healty.EMPLOYEE_NAME# #get_healty.EMPLOYEE_SURNAME#</cfoutput>
            </div>
            </div>
            <div class="form-group" id="item-TC_IDENTY_NO">
                <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58025.TC Kimlik'></label>
            <div class="col col-8 col-md-6 col-xs-12">
                <cfoutput>#get_healty.TC_IDENTY_NO#</cfoutput>
            </div>
            </div>
            <div class="form-group" id="item-BIRTH_DATE">
                <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></label>
            <div class="col col-8 col-md-6 col-xs-12">
                <cfoutput>#dateformat(get_healty.BIRTH_DATE,dateformat_style)#</cfoutput>
            </div>
            </div>
            <div class="form-group" id="item-sex">
                <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
            <div class="col col-8 col-md-6 col-xs-12">
                <cfif get_healty.sex eq 1 or not len(get_healty.sex)> <cf_get_lang dictionary_id='58959.Erkek'><cfelseif  get_healty.sex eq 0><cf_get_lang dictionary_id='58958.Kadın'></cfif>
            </div>
            </div>
            <div class="form-group" id="item-sex">
                <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58441.Kan Grubu'></label>
            <div class="col col-8 col-md-6 col-xs-12">
                <cfif LEN(get_healty.BLOOD_TYPE)>
                    <cfif get_healty.BLOOD_TYPE EQ 0>
                       0 Rh+
                   <cfelseif get_healty.BLOOD_TYPE EQ 1>
                       0 Rh-
                   <cfelseif get_healty.BLOOD_TYPE EQ 2>
                       A Rh+
                   <cfelseif get_healty.BLOOD_TYPE EQ 3>
                       A Rh-
                   <cfelseif get_healty.BLOOD_TYPE EQ 4>
                       B Rh+
                   <cfelseif get_healty.BLOOD_TYPE EQ 5>
                       B Rh-
                   <cfelseif get_healty.BLOOD_TYPE EQ 6>
                       AB Rh+
                   <cfelseif get_healty.BLOOD_TYPE EQ 7>
                       AB Rh-
                   </cfif>
               </cfif>
            </div>
            </div>
        </div>
        <div class="col col-5 col-md-5 col-sm-5 col-xs-5">
            <div class="form-group" id="item-NICK_NAME">
                <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
            <div class="col col-8 col-md-6 col-xs-12">
                <cfoutput>#get_healty.NICK_NAME#</cfoutput>
            </div>
            </div>
            <div class="form-group" id="item-">
                <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
            <div class="col col-8 col-md-6 col-xs-12">
                <cfoutput>#get_healty.DEPARTMENT_HEAD#</cfoutput>
            </div>
            </div>
            <div class="form-group" id="item-">
                <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
            <div class="col col-8 col-md-6 col-xs-12">
                <cfoutput>#get_healty.branch_name#</cfoutput>
            </div>
            </div>
            <div class="form-group" id="item-">
                <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
            <div class="col col-8 col-md-6 col-xs-12">
                <cfoutput>#get_healty.position_name#</cfoutput>
            </div>
            </div>
            <div class="form-group" id="item-">
                <label class="col col-4 col-md-6 col-xs-12"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_healty_report&employee_id=#employee_id#</cfoutput>')"  class="tableyazi"><cf_get_lang dictionary_id='55117.Sağlık Raporları'></a></label>
            <div class="col col-8 col-md-6 col-xs-12">
            </div>
            </div>
        </div>
    </cf_box_elements>
                    <cf_grid_list>
                        <thead>
                            <tr>
                                <th width="15"><cf_get_lang dictionary_id='57487.No'></th>
                                <th width="75"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                                <th width="75"><cf_get_lang dictionary_id='57880.Belge No'></th>
                                <th width="150"><cf_get_lang dictionary_id='56885.Muayene Tipi'></th>
                                <th><cf_get_lang dictionary_id='56621.Muayene Tarihi'></th>
                                <th width="100"><cf_get_lang dictionary_id='57684.Sonuç'></th>
                                <th width="150" nowrap="nowrap"><cf_get_lang dictionary_id='55223.Bir Sonraki Muayene Tarihi'></th>
                                <th width="15"><a href="<cfoutput>#request.self#?fuseaction=hr.list_employee_healty_all&event=add&employee_id=#employee_id#&rel_id=1</cfoutput>"><i class="fa fa-plus"></i></a></th>
                            </tr>
                        </thead>
                        <tbody>
                         <cfif get_healty.RECORDCOUNT gt 1> 
                            <cfoutput query="get_healty">
                                <cfif len(get_healty.INSPECTION_DATE)>
                                <tr>
                                    <td>#currentrow#</td>
                                    <td style="width:200px"><cfif len(relative_name)>
                                            #relative_name#(<cf_get_lang dictionary_id='55109.Çalışan Yakını'>)
                                        <cfelse>
                                            #employee_name# #employee_surname#
                                        </cfif>
                                    </td>
                                    <td>#HEALTY_NO#</td>
                                    <td>
                                    <cfif len(get_healty.PROCESS_TYPE)>
                                        <cfset get_inspection_type = createObject("component","V16.settings.cfc.setupInspectionTypes").getInspectionTypes(inspection_type_id:get_healty.PROCESS_TYPE)>
                                        #get_inspection_type.inspection_type#
                                    </cfif>
                                    </td>
                                    <td>#dateformat(get_healty.INSPECTION_DATE,dateformat_style)#</td>
                                    <td><cfif xml_detail_or_conclusion eq 1> 
                                            #get_healty.healty_detail#
                                        <cfelse>
                                            <cfif get_healty.conclusion eq 1><cf_get_lang dictionary_id='58761.Sevk'>
                                            <cfelseif get_healty.conclusion eq 2><cf_get_lang dictionary_id='55224.İstiharat'>
                                            <cfelseif get_healty.conclusion eq 3><cf_get_lang dictionary_id='55229.İşbaşı'>
                                            <cfelseif get_healty.conclusion eq 4><cf_get_lang dictionary_id='58156.Diğer'>
                                            </cfif>
                                      </cfif> 
                                    </td>
                                    <td>#dateformat(get_healty.NEXT_INSPECTION_DATE,dateformat_style)#</td>
                                    <td align="center" width="15"><a href="#request.self#?fuseaction=hr.list_employee_healty_all&event=upd&healty_id=#HEALTY_ID#&employee_id=#employee_id#"><i class="fa fa-pencil"></i></a></td>
                                </tr> 
                                </cfif>
                            </cfoutput>
                        </cfif>
                        </tbody>
                    </cf_grid_list>
                    <cfif not get_healty.RECORDCOUNT gt 1> 
                    <div class="ui-info-bottom">
                        <p><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</p>
                    </div>
                    </cfif>
                <cf_box_footer>
                        <cf_record_info query_name="get_healty">
                        <cf_workcube_buttons is_upd='1' is_delete="0">
                </cf_box_footer>

    </cfform>
</cf_box>
