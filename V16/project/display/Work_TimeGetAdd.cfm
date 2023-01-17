<!---
Author :        Melek Kocabey<melekkocabey@workcube.com>
Date :          02.09.2019
Description :  Bi işe bağlı olarak planlanan zaman harcaması eklemesini ve gerçekleşen saat dk eklemek için oluşturuldu.
--->
<cfset get_history=getComponent.get_time_history(id:attributes.id)>
<cfset get_history_control=getComponent.GET_WORK_DETAIL(id:attributes.id)>
<cfset upload_folder=application.systemParam.systemParam().upload_folder>

<cfsavecontent variable="title"><cf_get_lang dictionary_id='57561.Zaman Harcamaları'></cfsavecontent>
<cf_box
    title="#title#"
    id="box_followup2"
    closable="0"
    unload_body = "1"
    add_href="openBoxDraggable('#request.self#?fuseaction=project.popup_add_planned_actual_timecost&id=#attributes.id#&history_id=#GET_HISTORY_CONTROL.history_id#')">
    <cf_medium_list style="border: 0px !important">
        <cfif len(get_history.EMPLOYEE_ID)><cfset get_work_history = getComponent.GET_WORK_HISTORY(employee_id:get_history.EMPLOYEE_ID)></cfif>
        <cfif isdefined('GET_WORK_HISTORY.REAL_START') and len(GET_WORK_HISTORY.REAL_START) and isdefined('GET_WORK_HISTORY.REAL_FINISH') and len(GET_WORK_HISTORY.REAL_FINISH)>
            <cfset real_start=dateformat(GET_WORK_HISTORY.REAL_START,dateformat_style)>
            <cfset real_finish=dateformat(GET_WORK_HISTORY.REAL_FINISH,dateformat_style)>
        <cfelse>
            <cfset real_start=''>
            <cfset real_finish=''>
        </cfif>
        <thead>
            <th><cf_get_lang dictionary_id="57576.Çalışan"></th>
            <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
            <th> <i class="icon-time" title="<cfoutput>#real_start# #real_finish#</cfoutput>"> </i></th>
        </thead>
        <cfif get_history.recordcount>
            <cfoutput query="get_history">                                                
                <tbody>                                             
                     <tr>
                        <cfif len(get_history.EMPLOYEE_ID)><cfset employee_photo = getComponent.EMPLOYEE_PHOTO(employee_id:get_history.EMPLOYEE_ID)>
                        <td title="<cfif isdefined("employee_photo.POSITION") or isdefined("employee_photo.EMPLOYEE_NAME") or isdefined("employee_photo.EMPLOYEE_SURNAME")>#employee_photo.POSITION# #employee_photo.EMPLOYEE_NAME# #employee_photo.EMPLOYEE_SURNAME#</cfif>">
                            <cfif len(employee_photo.photo)>
                               <img class='img-circle' style='width : 30px; height:30px;'src='../../documents/hr/#employee_photo.PHOTO#' />
                            <cfelse>
                                <span style="width: 25px !important; float: left;margin-top: 3px; margin-right: 8px; height: 25px; display: inline-block;cursor:pointer;" class="avatextCt color-#Left(employee_photo.EMPLOYEE_NAME, 1)#"><small  class="avatext" style="font-size:11px; top:-6px; width:26px !important;">#Left(employee_photo.EMPLOYEE_NAME, 1)##Left(employee_photo.EMPLOYEE_SURNAME, 1)#</small></span>
                            </cfif>	
                        </td>
                        <td>#employee_photo.EMPLOYEE_NAME# #employee_photo.EMPLOYEE_SURNAME#</td>
                        <cfelse>
                            <td></td>
                            <td></td>
                        </cfif>
                        <!--- <cfquery name="get_time_history_" datasource="#dsn#">
                            SELECT
                                TOP 1 WORK_DETAIL	                                  
                            FROM 
                                PRO_WORKS_HISTORY                                                                        
                            WHERE 
                                UPDATE_AUTHOR = #get_history.EMPLOYEE_ID# AND 
                                WORK_ID =  #attributes.id#
                            ORDER BY 
                                WORK_DETAIL DESC          
                        </cfquery>
                        <td><cfset work_detail_=''>
                            <cfset work_detail_ = replace(get_time_history_.WORK_DETAIL,'<p>','')>
                            <cfset work_detail_ = replace(work_detail_,'</p>','')>
                            #work_detail_#
                        </td> --->
                        
                        <td style="width: 67px;">
                            <cfif len(get_history.TOTAL_TIME_HOUR)>
                                <cfset total_time_1 = get_history.TOTAL_TIME_HOUR * 60>                                                        
                                <cfset minute_1 = total_time_1 / 60>
                            </cfif>
                            <cfif not len(get_history.TOTAL_TIME_MINUTE)>
                                <cfset  get_history.TOTAL_TIME_MINUTE = 0>
                            </cfif>
                            <cfif not len(get_history.TOTAL_TIME_HOUR)>
                                <cfset  get_history.TOTAL_TIME_HOUR = 0>
                                <cfset total_time_1 = 0> 
                            </cfif>

                            <cfset total_time_2 = get_history.TOTAL_TIME_MINUTE * 60>
                            <cfset minute_2 = total_time_2 / 60>                                                        
                            <cfset total_time_end = total_time_1 + TOTAL_TIME_MINUTE>
                            <cfset totaltime_ = total_time_end mod 60>                             
                            <cfif len(get_history.TOTAL_TIME_HOUR)>#((total_time_end - totaltime_)/60)#h #totaltime_#m<cfelse></cfif>
                        </td>
                    </tr> 
                </tbody>
            </cfoutput>
        </cfif>
    </cf_medium_list>
        <div class="baslik" onclick="gizle_goster(gerceklesen_zaman_ekle);">
            <i class = 'fa fa-angle-right'></i>     
            <cf_get_lang dictionary_id='49215.Zaman Harcaması Ekle'>
        </div>
        <div id="gerceklesen_zaman_ekle" style="display:none;">
            <cfform name="add_work_time" method="post" action="">
                <cfset get_work_history = getComponent.GET_WORK_HISTORY()>
                <cfif isDefined("GET_WORK_HISTORY.work_detail") and len(GET_WORK_HISTORY.work_detail)>
                    <cfset work_detail_ = replace(GET_WORK_HISTORY.WORK_DETAIL,'<p>','')>
                    <cfset work_detail_ = replace(work_detail_,'</p>','')>
                </cfif>
                <div class="row">			
                    <input type="hidden" name="work_id" id="work_id" value="<cfoutput>#attributes.id#</cfoutput>">
                    <div class="form-group">
                        <div class="col col-8 ">
                            <span><cf_get_lang dictionary_id='57629.Açıklama'></span>
                        </div>
                        <div class="col col-2  text-center">
                            <span><cf_get_lang dictionary_id='57491.Saat'></sp>
                        </div>
                        <div class="col col-2 text-center">
                            <span><cf_get_lang dictionary_id='58827.Dk'></s>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col col-8">
                            <input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                            <input type="hidden" name="emp_name" id="emp_name" value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>">
                            <input type="hidden" name="work_head" id="work_head" value="<cfif isdefined('upd_work.work_head')><cfoutput>#upd_work.work_head#</cfoutput></cfif>">
                            <input type="text" name="comment" id="comment" maxlength="50" value="">
                        </div>
                        <div class="col col-2">
                            <cfinput type="text" name="total_time_hr" id="total_time_hr" validate="integer" onKeyUp="isNumber(this)" value="">
                        </div>
                        <div class="col col-2">
                            <cfinput type="text" name="total_time_min" id="total_time_min" validate="integer" maxlength="2" range="0,59" onKeyUp="isNumber(this)"  value="">
                        </div>
                    </div>
                </div>
                <div class="row formContentFooter text-right">
                    <div class="col col-12">
                        <input type="button" class="btn btn-primary" value="<cf_get_lang dictionary_id='57461.Kaydet'>" onClick="add_ActuelTime()"  tabindex="5"/>
                    </div>
                </div>
            </cfform>
        </div>			
</cf_box>
<style>
    .baslik{
        color: #607D8B;
        font-weight:500;
        text-align:left;
        font-size:12px;
        margin-top: 8px;
        cursor:pointer;
    }
</style>
<script>
    $("input[name='total_time_min']").change(function() {
        number = $("input[name='total_time_min']").val();
        if( number <= 0 || number >= 60 ) {
            $("input[name='total_time_min']").val("");
            alert("0 - 60 arası değer giriniz");
            }
        });
    $( "#comment" ).on('input', function() {
        if ($(this).val().length>50) {
            alert('<cf_get_lang dictionary_id='57629.Açıklama'> <cf_get_lang dictionary_id='58210.Alanında Karakter Sayısı'> : 50 <cf_get_lang dictionary_id='44746.Olmalıdır'>');       
        }
    });
    function add_ActuelTime() 
    {	
		WORK_HEAD = document.getElementById('work_head').value;
        work_detail = document.getElementById('comment').value;
		TOTAL_TIME_HOUR = document.getElementById('total_time_hr').value;
		TOTAL_TIME_MINUTE=document.getElementById('total_time_min').value;
		id=document.getElementById('work_id').value;
		employee_id=document.getElementById('emp_id').value;	
		$.ajax({ 
			url :'V16/project/cfc/get_work.cfc?method=time_add_new', 
			data :{
				WORK_HEAD : WORK_HEAD, 
				TOTAL_TIME_HOUR: TOTAL_TIME_HOUR, 
				TOTAL_TIME_MINUTE: TOTAL_TIME_MINUTE, 
				id: id,
				employee_id: employee_id,
                WORK_DETAIL: work_detail
			},
				async:false, 
				dataType: 'json', 
				success : function(res){
				if (res.STATUS) {
						alertObject({type: 'success',message: 'Gerçekleşen Zaman Harcaması Eklendi...', closeTime: 5000});
						$('#portBoxBodyStandart ').html(data);
					}       
				else
					alert("<cf_get_lang dictionary_id='47366.Kayıt başarısız'>!");
			}
		});
			
	}
</script>