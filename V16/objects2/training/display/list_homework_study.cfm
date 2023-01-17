<cfset cfc = createObject('component','V16.training_management.cfc.training_management')>
<cfset GET_HOMEWORK = cfc.GET_HOMEWORK(lesson_id: attributes.class_id)>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_flat_list>
        <thead>
            <tr>
                <th width="15"><cf_get_lang dictionary_id='57487.No'></th>
                <th><cf_get_lang dictionary_id='63657.Ödev'></th>
                <th><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
                <th><cf_get_lang dictionary_id='63658.Ödevi Veren'></th>
                <th width="20"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
            </tr>
        </thead>
        <tbody>
            <cfif GET_HOMEWORK.recordcount>
                <cfoutput query="GET_HOMEWORK"> 
                    <tr>
                        <td width="35">#currentrow#</td>
                        <td>#HOMEWORK#</td>
                        <td>#dateFormat(DELIVERY_DATE, 'dd/mm/yyyy')#</td>
                        <cfif MEMBER_TYPE eq 'employee'>
                            <cfset userid = EMP_ID>
                        <cfelseif MEMBER_TYPE eq 'partner'>
                            <cfset userid = PAR_ID>
                        <cfelse>
                            <cfset userid = CONS_ID>
                        </cfif>
                        <cfset get_employee = cfc.get_employee(userid: userid, member_type: MEMBER_TYPE)>
                        <td>#get_employee.name_surname#</td>
                        
                        <td>
                            <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=training_management.list_class&event=updHomework&homework_id=#GET_HOMEWORK.homework_id#','upd_homework_box','ui-draggable-box-medium')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                        </td>
                    </tr>
                </cfoutput> 
            <cfelse>
                <tr> 
                    <td colspan="10"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                </tr>
            </cfif>
        </tbody>
    </cf_flat_list>
</div>