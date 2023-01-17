<!--- Başşvurular --->

<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career")>
<cfset get_components_notice = createObject("component", "V16.objects2.career.cfc.notice")>

<!--Web query-->
<script type="text/javascript" src="documents/templates/highslide/highslide-with-html.js"></script>
<link rel="stylesheet" type="text/css" href="documents/templates/highslide/highslide.css" />
<script type="text/javascript">
	hs.graphicsDir = 'documents/templates/highslide/graphics/';
	hs.outlineType = 'rounded-white';
	hs.wrapperClassName = 'draggable-header';
</script>

<!--Web query-->

<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfif isdefined('session.pp.userid')>
	<cfset session_base.userid = session.pp.userid>
<cfelseif isdefined('session.ww.userid')>
	<cfset session_base.userid = session.ww.userid>
<cfelse>
	<cfset session_base.userid = session.cp.userid>
</cfif>	

<cfif isdefined('session.pp.userid')>
    <cfset empapp_id = session.pp.userid>
<cfelseif isdefined('session.ww.userid')>
    <cfset empapp_id = session.ww.userid> 
<cfelse>
    <cfset empapp_id = session.cp.userid>
</cfif>		

<cfset GET_APP_INFO =  get_components.GET_APP(empapp_id : empapp_id)>
<cfset GET_APP_POS = get_components_notice.GET_APP_POS_WITH(empapp_id : empapp_id)>

<cfform name="add_message" >
    <input type="hidden" name="temp_detail" id="temp_detail" value="" />
    <input type="hidden" name="temp_email" id="temp_email" value="" />
    <div class="row">
        <div class="col-md-12">
            <h1><cf_get_lang dictionary_id='30608.Üyelik Bilgileri'></h1>
        </div>
    </div>    
    <cfif len(get_app_info.homecity)>
        <cfset GET_CITY = get_components.GET_CITY(city_id: get_app_info.homecity)>
    </cfif>
    <div class="row mb-3">
        <div class="col-md-2">
            <cfif len(get_app_info.photo)>
                <img src="<cfoutput>../../../documents/hr/#get_app_info.photo#</cfoutput>" title="<cf_get_lang dictionary_id='34528.Fotoğraf'>" alt="<cf_get_lang dictionary_id='34528.Fotoğraf'>" border="0" width="130" height="110" align="center" /> 
            </cfif>
        </div>
        <div class="col-md-4">
            <cfif isdefined('session.cp')>
                <cfoutput>
                    <b>#session.cp.name# #session.cp.surname#</b><br>
                    <cfif len(get_app_info.homecity) and get_city.recordcount>#get_city.city_name#</cfif>
                </cfoutput>
            </cfif><br>
            <span class="font-weight-bold"><cf_get_lang dictionary_id='58086.Üyelik'><cf_get_lang dictionary_id='58593.Tarihi'></span><br>
            <cfoutput>#dateformat(get_app_info.record_date,'dd/mm/yyyy')#</cfoutput><br>

            <cfquery name="GET_EDU_TYPE" datasource="#DSN#">
                SELECT EDU_PART_NAME FROM EMPLOYEES_APP_EDU_INFO WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#"> AND EDU_TYPE = 4 
            </cfquery>
            <cfif get_edu_type.recordcount and len(get_edu_type.edu_part_name)>            
                <span class="font-weight-bold"><cf_get_lang dictionary_id='34533.Meslek'></span><br>
                <cfoutput>#get_edu_type.edu_part_name#</cfoutput>            
            </cfif>
        </div>    
    </div>
    <ul class="list-unstyled">
        <li>
            <a href="<cfoutput>#attributes.update_path_url#</cfoutput>"><cf_get_lang dictionary_id='30808.CV Güncelle'></a>
        </li>
        <li>
            <a href="mesajlarim" class="trubutton"><cf_get_lang dictionary_id='46847.Mesajlarım'>
        </li>
        <li>
            <cfif get_app_pos.recordcount eq 0><b><a href="#"><cf_get_lang dictionary_id='46936.Yeni Mesaj'><cf_get_lang dictionary_id='58546.Yok'></a></b></cfif>
        </li>
        <li>
            <a href="#"><cf_get_lang dictionary_id='62716.Üyeliği pasiflştir'></a>
        </li>
        <li>
            <cfif get_app_info.app_status eq 1>
                <div class="cv_active">
                    <a href="<cfoutput>#request.self#?fuseaction=objects2.emptypopup_updcv&stage=12&app_status=0</cfoutput>"><cf_get_lang dictionary_id='29767.CV'> <cf_get_lang dictionary_id='57493.Aktif'></a>
                </div>
            <cfelse>
                <div class="cv_pasif">
                    <a href="<cfoutput>#request.self#?fuseaction=objects2.emptypopup_updcv&stage=12&app_status=1</cfoutput>"><cf_get_lang dictionary_id='29767.CV'> <cf_get_lang dictionary_id='57494.Pasif'></a>
                </div>
            </cfif>
        </li>
        <li>
            <a href="/yenimesajgonder" class="trubutton"  onclick="return hs.htmlExpand(this)"><cf_get_lang dictionary_id='46936.Yeni Mesaj'><cf_get_lang dictionary_id='58743.Gönder'></a>
        </li>
        <li>
            <h4><cf_get_lang dictionary_id='46936.Yeni Mesaj'><cf_get_lang dictionary_id='58743.Gönder'></h4>
            <div class="form-group row">
                <label class="col-md-2 col-form-label"><cf_get_lang dictionary_id='57428.Email'> : *</label>
                <div class="col-12 col-md-8 col-lg-4 col-xl-3">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='34350.Lütfen geçerli bir e-posta adresi giriniz!'></cfsavecontent>
                    <cfinput type="text" class="form-control" name="email" id="email" validate="email" required="yes" message="#message#" value="">
                </div>
            </div>
            <div class="form-group row">
                <label class="col-md-2 col-form-label"><cf_get_lang dictionary_id='57543.Mesaj'> : </label>
                <div class="col-12 col-md-8 col-lg-4 col-xl-3">
                    <textarea class="form-control" name="message_detail" id="message_detail"></textarea>
                </div>
            </div>
            <div class="form-group row">
                <div class="col-12 col-md-8 col-lg-4 col-xl-3">
                    <div id="show_info"></div> 
                </div>
            </div> 
            <div class="form-group row">            
                <div class="col-12 col-md-10 col-lg-6 col-xl-5 d-flex justify-content-end">
                    <input type="button" class="btn btn-primary" name="button" id="button"  value="gönder" class="input_goner" onclick="control();"> 
                    <cfsavecontent variable="button_t"><cf_get_lang dictionary_id='58743.Gönder'></cfsavecontent>
                    <cf_workcube_buttons is_insert='1' insert_info="#button_t#" data_action="/V16/objects2/career/cfc/notice:add_message_send" next_page="#request.self#" add_function='control()'>
                            
                </div>
            </div>               
        </li>
    </ul>
    <div class="row">
        <div class="col-md-2">
            <img src="objects2/image/basvuru_incele.jpg" />
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-md-12">
            <cfif get_app_pos.recordcount>
                <cfoutput query="get_app_pos">               
                    <b><cf_get_lang dictionary_id='58497.Pozisyon'></b><br />
                    <a class="mr-5" href="#attributes.notice_link#?notice_id=#get_app_pos.notice_id#">#get_app_pos.notice_head#</a>                       
                    <cfif get_app_pos.app_pos_status eq 1><a href="#request.self#?fuseaction=objects2.emptypopup_updcv&stage=13&app_status=0&app_pos_id=#app_pos_id#" class="trubuttonaktif">aktif</a><cfelseif get_app_pos.app_pos_status eq 0><a href="#request.self#?fuseaction=objects2.emptypopup_updcv&stage=13&app_status=1&app_pos_id=#app_pos_id#" class="trubutton">pasif</a></cfif>                   
                </cfoutput>
            <cfelse>
                <cf_get_lang dictionary_id='62717.Başvurunuz bulunmamaktadır'>
            </cfif>
        </div>    
    </div>
    <div class="row">
        <div class="col-md-12">
            <cfquery name="GET_INBOX_MESSAGES" datasource="#DSN#">
                SELECT APP_POS_ID FROM EMPLOYEES_APP_MAILS WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#"> AND RECORD_EMP IS NOT NULL
            </cfquery> 
            <img src="objects2/image/mesajlarim_baslik.jpg" />
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <a class="mr-5" href="#"><b><cf_get_lang dictionary_id='51054.Gelen Kutusu'></b></a>    
            <a href="#"><cfif not get_inbox_messages.recordcount><cf_get_lang dictionary_id='46936.Yeni Mesaj'><cf_get_lang dictionary_id='58546.Yok'></cfif></a>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-md-12">
            <cfif get_inbox_messages.recordcount>
                <cfoutput query="get_inbox_messages">
                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_dsp_mails&app_pos_id=#get_app_pos.app_pos_id#&empapp_id=#session.cp.userid#','small')" class="trubuttonaktif"><cf_get_lang dictionary_id='48869.Oku'></a>
                </cfoutput>
            </cfif>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <cfquery name="GET_SENT_MESSAGES" datasource="#DSN#">
                SELECT APP_POS_ID FROM EMPLOYEES_APP_MAILS WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#"> AND RECORD_APP IS NOT NULL
            </cfquery>
            <a class="mr-5" href="#"><b><cf_get_lang dictionary_id='51055.Giden Kutusu'></b></a>
            <cfif get_sent_messages.recordcount>
                <cfoutput query="get_sent_messages"> 
                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_dsp_mails&app_pos_id=#get_app_pos.app_pos_id#&empapp_id=#session.cp.userid#','small')" class="trubuttonaktif"><cf_get_lang dictionary_id='48869.Oku'></a>
                </cfoutput>
            </cfif>
        </div>
    </div>
</cfform>
<script type="text/javascript">
function control()
	{
		if(document.getElementById('message_detail').value == 0)
		{
			alert('Lütfen Mesaj Giriniz');
			return false;
		}   
		
		var aaa = document.getElementById('email').value;
		if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)))
		{ 
			alert("Lütfen geçerli bir e-posta adresi giriniz!");
			return false;
		}
		document.getElementById('temp_detail').value = document.getElementById('message_detail').value;
		document.getElementById('temp_email').value = document.getElementById('email').value;
		AjaxFormSubmit('add_message','show_info',1,'Gönderiliyor','Gönderildi');		  
	}
</script>

