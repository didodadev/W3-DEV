<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.branch_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.in_out" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="0">
<cfparam name="attributes.page" default=1>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfquery name="get_position_cat" datasource="#dsn#">
	SELECT POSITION_CAT_ID, POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>
<cfif isdefined("attributes.is_form_submitted")>
	<cfif isdefined("attributes.start_date")><cf_date tarih ="attributes.start_date"></cfif>
	<cfif isdefined("attributes.finish_date")><cf_date tarih ="attributes.finish_date"></cfif>
	<cfquery name="GET_WRK_LOGIN" datasource="#DSN#">
		SELECT
			EP.EMPLOYEE_ID,
			EP.EMPLOYEE_NAME,
			EP.EMPLOYEE_SURNAME,
			EP.EMPLOYEE_EMAIL,
			SPC.POSITION_CAT,
			B.BRANCH_NAME,
			D.DEPARTMENT_HEAD,
			WRK_L.DOMAIN_NAME,
			WRK_L.IN_OUT_TIME,
			WRK_L.IN_OUT,
			WRK_L.LOGIN_IP,
			WRK_L.COORDINATE1,
			WRK_L.COORDINATE2,
           '' AS OUT_COORDINATE1,
			'' AS OUT_COORDINATE2
		FROM
			WRK_LOGIN WRK_L,
			EMPLOYEE_POSITIONS EP
			LEFT JOIN SETUP_POSITION_CAT SPC ON EP.POSITION_CAT_ID = SPC.POSITION_CAT_ID
			LEFT JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID
			LEFT JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
		WHERE
			WRK_L.EMPLOYEE_ID = EP.EMPLOYEE_ID
			AND EP.IS_MASTER = 1
			<cfif isdate(attributes.start_date)>AND WRK_L.IN_OUT_TIME >= #attributes.start_date#</cfif>
			<cfif isdate(attributes.finish_date)>AND WRK_L.IN_OUT_TIME < #date_add("d",1,attributes.finish_date)#</cfif>
			<cfif len(attributes.position_cat_id)>AND EP.POSITION_CAT_ID = #attributes.position_cat_id#</cfif>
			<cfif len(attributes.branch_id) and len(attributes.branch_name)>AND D.BRANCH_ID = #attributes.branch_id#</cfif>
			<cfif len(attributes.employee_id)  and len(attributes.employee)>AND EP.EMPLOYEE_ID = #attributes.employee_id#</cfif>
			<cfif attributes.in_out eq 1>AND WRK_L.IN_OUT = 1</cfif>
			<cfif attributes.in_out eq 0>AND WRK_L.IN_OUT = 0</cfif>
			<cfif isdefined("attributes.is_employee")>
				AND WRK_L.LOGIN_ID = (SELECT MAX(WRK_L.LOGIN_ID) FROM WRK_LOGIN WRK_L WHERE WRK_L.EMPLOYEE_ID = EP.EMPLOYEE_ID)
			</cfif>
        UNION ALL
        SELECT
			EP.EMPLOYEE_ID,
			EP.EMPLOYEE_NAME,
			EP.EMPLOYEE_SURNAME,
			EP.EMPLOYEE_EMAIL,
			SPC.POSITION_CAT,
			B.BRANCH_NAME,
			D.DEPARTMENT_HEAD,
			'' AS DOMAIN_NAME,
			EDI.START_DATE AS IN_OUT_TIME,
            '' AS IN_OUT,
			EDI.RECORD_IP,
			EDI.IN_COORDINATE1,
			EDI.IN_COORDINATE2,
            EDI.OUT_COORDINATE1,
			EDI.OUT_COORDINATE2
        FROM
            EMPLOYEE_DAILY_IN_OUT EDI,
			EMPLOYEE_POSITIONS EP
			LEFT JOIN SETUP_POSITION_CAT SPC ON EP.POSITION_CAT_ID = SPC.POSITION_CAT_ID
			LEFT JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID
			LEFT JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
        WHERE
			EDI.EMPLOYEE_ID = EP.EMPLOYEE_ID
			AND EP.IS_MASTER = 1
			<cfif isdate(attributes.start_date)>AND EDI.START_DATE >= #attributes.start_date#</cfif>
			<cfif isdate(attributes.finish_date)>AND EDI.FINISH_DATE < #date_add("d",1,attributes.finish_date)#</cfif>
			<cfif len(attributes.position_cat_id)>AND EP.POSITION_CAT_ID = #attributes.position_cat_id#</cfif>
			<cfif len(attributes.branch_id) and len(attributes.branch_name)>AND D.BRANCH_ID = #attributes.branch_id#</cfif>
			<cfif len(attributes.employee_id)  and len(attributes.employee)>AND EP.EMPLOYEE_ID = #attributes.employee_id#</cfif>
        ORDER BY
			EP.EMPLOYEE_NAME,
			EP.EMPLOYEE_SURNAME,
			WRK_L.IN_OUT_TIME DESC
	</cfquery>
<cfelse>
	<cfset get_wrk_login.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_wrk_login.recordcount#">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfform name="form" action="#request.self#?fuseaction=report.system_login_logoff_report" method="post">

    <cf_report_list_search title="#getLang('report',709)#">
        <cf_report_list_search_area>                  
             <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                               <div class="col col-12 col-xs-12">
                                    <div class="form-group">
                                         <label class="col col-12 col-xs-12"><cf_get_lang_main no='1278.Tarih Aralığı'>*</label>
                                            <div class="col col-6">                                                
                                                <div class="input-group">
                                                    <cfsavecontent variable="message"><cf_get_lang_main no='326.Başlangıç Tarihi Girmelisiniz'>!</cfsavecontent>
                                                        <cfinput name="start_date" maxlength="10" type="text" value="#dateformat(attributes.start_date,dateformat_style)#" required="yes" message="#message#" validate="#validate_style#">  
                                                        <span class="input-group-addon">
                                                            <cf_wrk_date_image date_field="start_date">
                                                        </span>                   
                                                </div>
                                            </div>
                                            <div class="col col-6">
                                                <div class="input-group">                                     
                                                    <cfsavecontent variable="message2"><cf_get_lang_main no='327.Başlangıç Tarihi Girmelisinizs'>!</cfsavecontent>
                                                        <cfinput name="finish_date" type="text" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#" required="yes" message="#message2#" validate="#validate_style#">
                                                        <span class="input-group-addon">
                                                        <cf_wrk_date_image date_field="finish_date">
                                                        </span>
                                                </div>
                                            </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no='164.Çalışan'></label>
                                        <div class="col col-12 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.employee") and len(attributes.employee)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                                                <input type="text" name="employee" id="employee" onfocus="AutoComplete_Create('employee','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0,0','EMPLOYEE_ID','employee_id','list_works','3','250');" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.employee") and len(attributes.employee)><cfoutput>#attributes.employee#</cfoutput></cfif>" maxlength="255"   style="width:100px;">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form.employee_id&field_name=form.employee&select_list=1,2')"></span>
                                            </div>
                                        </div>    
                                    </div>                                    
                                </div>                                                            
                            </div>  
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                              <div class="col col-12 col-xs-12">
                                <div class="form-group">
                                     <label class="col col-12 col-xs-12">
                                        <cf_get_lang_main no='367.Pozisyon Tipleri'>
                                     </label>
                                     <div class="col col-12 col-xs-12">
                                        <select name="position_cat_id" id="position_cat_id" style="width:160px;">
                                            <option value=""><cf_get_lang_main no='322.Sç'></option>
                                            <cfoutput query="get_position_cat">
                                                <option value="#POSITION_CAT_ID#" <cfif attributes.position_cat_id eq position_cat_id> selected</cfif>>#POSITION_CAT#
                                            </cfoutput>
                                        </select>
                                     </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='53181.Giriş-Çıkış'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="in_out" id="in_out" style="width:65px;">
                                            <option value="2"<cfif isdefined("attributes.in_out") and (attributes.in_out eq 2)>selected</cfif>><cf_get_lang_main no='322.Sç'></option>
                                            <option value="1"<cfif isdefined("attributes.in_out") and (attributes.in_out eq 1)>selected</cfif>><cf_get_lang_main no='142.Giriş'></option>
                                            <option value="0"<cfif isdefined("attributes.in_out") and (attributes.in_out eq 0)> selected</cfif>><cf_get_lang_main no='19.Çıkış'></option>
                                        </select>
                                    </div>
                                </div>
                              </div>
                            </div>                         
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no='41.Şube'></label>
                                        <div class="col col-12 col-xs-12">
                                           <div class="input-group">
                                            <input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined("attributes.branch_id")><cfoutput>#attributes.branch_id#</cfoutput></cfif>">
                                            <input type="text" name="branch_name" id="branch_name" value="<cfif isdefined("attributes.branch_id") and len(attributes.branch_id) and len(attributes.branch_name)><cfoutput>#attributes.branch_name#</cfoutput></cfif>" onFocus="AutoComplete_Create('branch_name','BRANCH_NAME','BRANCH_NAME','get_position_branch','','BRANCH_ID','branch_id','3','120')">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_branch_name=form.branch_name&field_branch_id=form.branch_id</cfoutput>');">
                                            </span>                                               
                                           </div>
                                        </div>
                                    </div>
                                    <div class="form-group">                                       
                                         <div class="col col-12 col-xs-12">                                            
                                                <label>
                                                    <input type="checkbox" name="is_employee" id="is_employee" value="" <cfif isdefined("attributes.is_employee")>checked</cfif>><cf_get_lang no='993.Son Giriş Çıkışlara Göre Sırala'> 
                                                </label>                                               
                                         </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                            <label><cf_get_lang_main no='446.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>checked</cfif>></label>
                            <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
                            <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
                            <cf_wrk_report_search_button is_excel='1' button_type='1' insert_info='#message#' search_function='control()'>            
                        </div>
                    </div>
                </div>
             </div>    
                   

        </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<cfset type_ = 1>
<cfelse>
	<cfset type_ = 0>
</cfif>
<cfif isDefined("attributes.is_form_submitted")>
   <cf_report_list>
        <thead>
            <tr>
                <th width="150"><cf_get_lang_main no='164.Çalışan'></th>
                <th width="150"><cf_get_lang_main no='16.E-Mail'></th>
				<th width="150"><cf_get_lang_main no='1592.Pozisyon Tipi'></th>
                <th width="150"><cf_get_lang_main no='41.Şube'></th>
                <th width="150"><cf_get_lang_main no='160.Departman'></th>
                <th width="150"><cf_get_lang_main no='480.Domain'></th>
                <cfif isdefined("attributes.is_employee")>
                    <th width="150"><cf_get_lang no='994.Son Giriş'></th>
                <cfelse>
                    <th width="100"><cf_get_lang_main no='330.Tarih'></th>
                </cfif>
                <th width="100"><cf_get_lang no="528.IP Adresi"></th>
                <th width="75"><cf_get_lang no='212.Giriş Çıkış'></th>
                <th width="15"><cf_get_lang dictionary_id='42307.Konum'></th>
            </tr>
        </thead>
		<cfif get_wrk_login.recordcount>
            <!--- <cfif type_ eq 1>
                <cfset attributes.maxrows = attributes.totalrecords>
            <cfelse>
            </cfif> --->
            <cfset attributes.totalrecords = get_wrk_login.recordcount>
            <cfoutput query="get_wrk_login" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                
                <tbody>
                    <tr>
                        <td>#employee_name# #employee_surname#</td>
                        <td>#employee_email#</td>
                        <td>#position_cat#</td>
                        <td>#branch_name#</td>
                        <td>#department_head#</td>
                        <td>#domain_name#</td>
                        <td>#dateformat(in_out_time,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,in_out_time),timeformat_style)#</td>
                        <td>#GET_WRK_LOGIN.login_ip#</td>
                        <td><cfif get_wrk_login.in_out eq 0><cf_get_lang_main no='19.Çıkış'><cfelseif not len(get_wrk_login.out_coordinate1)><cf_get_lang_main no='142.Giriş'><cfelseif len(get_wrk_login.out_coordinate1)><cf_get_lang_main no='19.Çıkış'><cfelse><cf_get_lang_main no='142.Giriş'></cfif></td>
                        <td style="text-align:center">
                            <cfif get_wrk_login.coordinate1 neq 0 and len(get_wrk_login.coordinate1) and get_wrk_login.coordinate2 neq 0 and len(get_wrk_login.coordinate2)>
                                <a target="_blank" href="https://www.google.com/maps/place/#coordinate1#,#coordinate2#/@#coordinate1#,#coordinate2#,21z" title="<cf_get_lang dictionary_id='58849.Haritada Göster'>"><img height="25" src="css/assets/icons/catalyst-icon-svg/google-maps.svg" alt=""></a>
                            <cfelse>
                                <i style="color:red;font-size:20px;cursor:pointer" title="<cf_get_lang dictionary_id='31024.Konum bilgilerine izin verilmiyor.'>" class="icn-md fa fa-times-circle-o"></i>
                            </cfif>
                        </td>
                    </tr>
                </tbody>
            </cfoutput>
        <cfelse>
        	<tbody>
                <tr>
                    <td colspan="9">
                        <cfif isdefined("attributes.is_form_submitted")><cf_get_lang_main no='72.Kayıt Yok'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif>
                    </td>
                </tr>
            </tbody>
        </cfif>
   </cf_report_list>
</cfif>

<!--- <cfif isdefined("attributes.is_form_submitted")>
	<cfset url_str = "">
    <cfif len(attributes.keyword)>
        <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
    </cfif>
    <cfif len(attributes.is_select)>
    	<cfset url_str = "#url_str#&is_select=#attributes.is_select#">
    </cfif>
    <cfif len(attributes.form_submitted)>
        <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
    </cfif>
    <cfif len(attributes.start_date)>
        <cfset url_str = "#url_str#&startdate=#attributes.start_date#">
    </cfif>
    <cfif len(attributes.finish_date)>
        <cfset url_str = "#url_str#&finishdate=#attributes.finish_date#">
    </cfif>
    <cf_paging 
        page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#attributes.startrow#" 
        adres="report.id_report#url_str#">
</cfif> --->


    <cfset adres = "report.system_login_logoff_report">	
    <cfif attributes.totalrecords gt attributes.maxrows>
        <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
            <cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
        </cfif>
        <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
            <cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
        </cfif>
        <cfif isdefined("attributes.position_cat_id")>
                <cfset adres = "#adres#&position_cat_id=#attributes.position_cat_id#" >
        </cfif>
        <cfif isdefined("attributes.branch_id") and len(attributes.branch_id) and len(attributes.branch_name)>
            <cfset adres = "#adres#&branch_id=#attributes.branch_id#">
            <cfset adres = "#adres#&branch_name=#attributes.branch_name#">
        </cfif>
        <cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
            <cfset adres = "#adres#&employee_id=#attributes.employee_id#">
            <cfset adres = "#adres#&employee=#attributes.employee#">
        </cfif>
        <cfif isdefined("attributes.in_out")>
        <cfset adres = "#adres#&in_out=#attributes.in_out#">
        </cfif>
        <cfif isdefined("attributes.is_employee")>
        <cfset adres = "#adres#&is_employee=#attributes.is_employee#">
        </cfif>
        <cfif isdefined("attributes.is_form_submitted")>
                <cfset adres = "#adres#&is_form_submitted=#attributes.is_form_submitted#" >
        </cfif>
                <cf_paging page="#attributes.page#" 
                    maxrows="#attributes.maxrows#" 
                    totalrecords="#attributes.totalrecords#" 
                    startrow="#attributes.startrow#" 
                    adres="#adres#">
    </cfif>



<script>
    function control(){
        if(!date_check(form.start_date,form.finish_date,"<cf_get_lang no ='1589.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
					return false;
				}
		if(document.form.is_excel.checked==false)
			{
				document.form.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
				return true;
			}
			else
				document.form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_system_login_logoff_report</cfoutput>"
	}
</script>