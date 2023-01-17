
<!---
    File:AddOns\Devonomy\GDPR\display\list_gdpr_approve.cfm
    Date: 2022-01-04
    Description:Gdpr İzinler Sayfasının listelediği sayfadır
--->
<cfparam  name="attributes.page" default="1">
<cfset comp = createObject("component","AddOns.Devonomy.GDPR.cfc.gdpr_decleration")/>  
<cfset MAX_DECLERATION = comp.MAX_DECLERATION()/>
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
    <cfset attributes.maxrows = session.ep.maxrows />
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1 />
<cfparam  name="attributes.form_submitted" default="">
<cfset comp = createObject("component","AddOns.Devonomy.GDPR.cfc.gdpr_decleration")/>
<cfset Data_Decleration = comp.Data_Decleration()/>
<cfparam  name="attributes.gdpr_decleration_id" default="">
<cfparam  name="attributes.employee_id" default="">
<cfparam  name="attributes.employee_name" default="">
<cfparam  name="attributes.approve_emp_id" default="">
<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
    
    <cfset list_approve = comp.list_approve(
        GDPR_DECLERATION_ID :#attributes.gdpr_decleration_id#,
        employee_id :#attributes.employee_id#,
        employee_name: #attributes.employee_name#,
        approve_emp_id:#attributes.approve_emp_id#
       
    )/>
    <cfparam name='attributes.totalrecords' default="#list_approve.recordcount#">
<cfelse>
    <cfset list_approve.recordcount = 0>
    <cfparam name='attributes.totalrecords' default="0">
</cfif>


<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform  name="list_approve" action="#request.self#?fuseaction=gdpr.approve" method="post">
            <cf_box_search more="0">
                <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                <div class="form-group" id="item-gdpr_decleration_id">
                    <select name="gdpr_decleration_id" id="gdpr_decleration_id"  onchange="show()" >
                        <option value=""><cf_get_lang dictionary_id='52829.Versiyon'></option>  
                        <cfoutput query="Data_Decleration">
                            <option <cfif isdefined('attributes.GDPR_DECLERATION_ID') and attributes.GDPR_DECLERATION_ID eq GDPR_DECLERATION_ID>selected</cfif> value="#GDPR_DECLERATION_ID#">#GDPR_DECLERATION_ID#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group large" id="item-employee_id">
                    <div class="input-group">
                        <input type="hidden" name="employee_id" id="employee_id"  value="<cfoutput>#attributes.employee_id#</cfoutput>">
                        <input type="text" name="employee_name" id="employee_name" value="<cfoutput>#attributes.employee_name#</cfoutput>" placeholder="<cf_get_lang dictionary_id='57576.Çalışan'>" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3\',0,0','EMPLOYEE_ID','employee_id','','3','200','get_company()');" autocomplete="off">
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_approve.employee_id&field_name=list_approve.employee_name&select_list=1');"></span>  
                    </div>
                </div>
                <div class="form-group" id="item-approve_emp_id">
                     <select name="approve_emp_id" id="approve_emp_id">
                        <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <cfoutput>
                            <option value="1"<cfif isDefined("attributes.approve_emp_id") and len(attributes.approve_emp_id) and attributes.approve_emp_id eq 1> selected</cfif>><cf_get_lang dictionary_id='57616.Onaylı'></option>
                          <option value="0"<cfif isDefined("attributes.approve_emp_id") and  len(attributes.approve_emp_id) and attributes.approve_emp_id eq 0> selected</cfif>><cf_get_lang dictionary_id='53107.Onaysız'></option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="kontrol()">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','izinler','30820')#" uidrop="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='57551.Kullanıcı Adı'></th>
                    <th><cf_get_lang dictionary_id='52829.Versiyon'></th>
                    <th><cf_get_lang dictionary_id='47871.Güncel'><cf_get_lang dictionary_id='52829.Versiyon'></th>
                    <th><cf_get_lang dictionary_id='55839.Onay Tarihi'></th>
                    <th width="30"><cf_get_lang dictionary_id='57756.Durum'></th>
                    <cfoutput><th width="30"><i class="fa fa-print" title="<cf_get_lang dictionary_id='65093.ÇALIŞAN AÇIK RIZA METNI'> <cf_get_lang dictionary_id='57474.Yazdır'>"></i></th></cfoutput>
                </tr>
            </thead>
           
            <cfif list_approve.recordcount>
                <cfoutput query="list_approve" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tbody>
                        <tr>
                            <td><a href="javascript://" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_emp_det&emp_id=#employee_id#');">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
                            <td><a href="#request.self#?fuseaction=gdpr.decleration_text&verison_&event=upd&gdpr_decleration_id=#gdpr_decleration_id#">#gdpr_decleration_id#</a> </td>
                            <td>#MAX_DECLERATION.max#</td>
                            <td>
                                <cfif isdefined("GDPR_APPROVE_DATE") and len(GDPR_APPROVE_DATE)>
                                    #dateformat(date_add('h',session.ep.time_zone,GDPR_APPROVE_DATE),dateformat_style)#
                                </cfif>
                            </td>
                            <td class="text-center"><cfif list_approve.gdpr_decleration_id eq MAX_DECLERATION.max><i class="fa fa-thumbs-o-up" style="color:##4caf50!important;font-size: 18px;"></i><cfelse><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=gdpr.approve&event=add&welcome=1&employee_id=#employee_id#','approve_box')"><i class="fa fa-thumbs-o-down" style="color:red!important;font-size: 18px;"></i></a></cfif></td>
                            <td>
                                <a href="javascript://" onclick="window.open('#request.self#?fuseaction=objects.popup_print_files&employee_id=#employee_id#&action=gdpr.approve','WOC');"> <i class="fa fa-print" title="<cf_get_lang dictionary_id='65093.ÇALIŞAN AÇIK RIZA METNI'> <cf_get_lang dictionary_id='57474.Yazdır'>"></i></a>
                            </td>
                        </tr>
                    </tbody>
                </cfoutput>
            <cfelse>
                <tbody> 
                    <tr>
                        <td colspan="20"><cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                    </tr>
                </tbody> 
            </cfif>
        </cf_grid_list>
        <cfset url_str = "">
        <cfif len(attributes.form_submitted)>
            <cfset url_str = '#url_str#&form_submitted=#attributes.form_submitted#'>
        </cfif>
        <cfif len(attributes.gdpr_decleration_id)>
            <cfset url_str = "#url_str#&gdpr_decleration_id=#attributes.gdpr_decleration_id#">
        </cfif>
        <cfif len(attributes.employee_id)>
            <cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
        </cfif>
        <cfif len(attributes.approve_emp_id)>
            <cfset url_str = "#url_str#&approve_emp_id=#attributes.approve_emp_id#">
        </cfif>
        <cfif len(attributes.employee_name)>
            <cfset url_str = "#url_str#&employee_name=#attributes.employee_name#">
        </cfif>
        <cf_paging page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#attributes.startrow#" 
        adres="gdpr.approve#url_str#">
    </cf_box>  
   
</div>
<script>
function kontrol(){
        if(!$("#employee_name").val().length)
            {

                $("#employee_id").val('');

            }
            return true;
    }
    function show()
        {

            if($("#gdpr_decleration_id").val().length) {
                
                $("#approve_emp_id").val('1');
               
            }
            if(!$("#gdpr_decleration_id").val().length) {
                $("#approve_emp_id").val('');
               
            }
        }
</script>
