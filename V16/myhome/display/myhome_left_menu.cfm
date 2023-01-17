<cfquery name="GET_My_Profile" datasource="#dsn#">                        
    SELECT 
        W.NAME,
        W.SURNAME ,                            
        W.POSITION_NAME,
        E.PHOTO,  
        E2.SEX                                                     
    FROM
        WRK_SESSION AS W
        LEFT JOIN EMPLOYEES AS E ON E.EMPLOYEE_ID = W.USERID
        LEFT JOIN EMPLOYEES_DETAIL AS E2 ON E2.EMPLOYEE_ID = W.USERID                             
    WHERE
       W.USERID=#session.ep.userid#
    </cfquery> 
    <cfloop query="GET_My_Profile" startrow=1 endrow="#GET_My_Profile.recordcount#">
    <cfset My_Name = Name>
    <cfset My_Surname = SURNAME>
    <cfset My_Position = POSITION_NAME> 
    <cfset My_Photo = PHOTO> 
    <cfset My_Sex = SEX>  
    </cfloop> 
    <div class="row mainBox">
        <div class="col col-12 col-xs-12 colBox">
            <cf_box>
                  <div class="row divBox">
                      <div class="profile-userpic text-center">  
                          <cfif len(My_Photo)>
                              <img class="img-circle" title="<cfoutput>#My_Position# - #My_Name# #My_Surname#</cfoutput>" src="../documents/hr/<cfoutput>#My_Photo#</cfoutput>" />
                          <cfelseif My_Sex eq 1>
                              <img class="img-circle" title="<cfoutput>#My_Name# #My_Surname#</cfoutput>" src="../images/male.jpg" />
                          <cfelse>
                              <img class="img-circle" title="<cfoutput>#My_Name# #My_Surname#</cfoutput>" src="../images/female.jpg" />
                          </cfif>
                          <div class="profile-usertitle-name"><cfoutput>#My_Name# #My_Surname#</cfoutput></div>
                          <div class="profile-usertitle-job"><cfoutput>#My_Position#</cfoutput></div>
                      </div>
                      <div class="profile-usermenu">
                          <ul class="navBox acordionUl scrollContent">
                                <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_position"><i class="icon-badge"></i><cf_get_lang dictionary_id='58497.Pozisyon'></a></li>
                                <li><a href="javascript:;" onclick="pageLoad('myhome.my_profile')"><i class="icon-notebook"></i><cf_get_lang dictionary_id='31446.Özgeçmiş'></a></li>
                                <li><a href="javascript:;" onclick="pageLoad('myhome.my_detail')"><i class="icon-info"></i><cf_get_lang dictionary_id='31150.Bilgilerim'></a></li>
                                <li><a href="javascript:;" onclick="pageLoad('myhome.dashboard')"><i class="icon-users"></i><cf_get_lang dictionary_id='55731.Dashboard'></a></li>
                                <li><a href="javascript:;" onclick="pageLoad('myhome.hr')"><i class="icon-users"></i><cf_get_lang dictionary_id='47630.IK İşlemleri'></a></li>
                                <li><a href="javascript:;" onclick="pageLoad('myhome.my_extre')"><i></i><cf_get_lang dictionary_id='57809.Hesap Ekstresi'></a></li>
                                <li><a href="javascript:;" onclick="pageLoad('myhome.list_my_extra_times')"><i></i><cf_get_lang dictionary_id='30866.Mesai'></a></li>                           
                                <li><a href="javascript:;" onclick="pageLoad('myhome.my_offtimes')"><i></i><cf_get_lang dictionary_id='30820.İzinler'></a></li>
                                <li><a href="javascript:;" onclick="pageLoad('myhome.my_targets')"><i></i><cf_get_lang dictionary_id='57964.hedeflerim'></a></li>
                                <li><a href="javascript:;" onclick="pageLoad('myhome.health_expense_approve')"><i></i><cf_get_lang dictionary_id='45055.Sağlık'></a></li>
                                <li><a href="javascript:;" onclick="pageLoad('myhome.list_travel_demands')"><i></i><cf_get_lang dictionary_id='59973.Seyahat'></a></li>
                                <li><a href="javascript:;" onclick="pageLoad('myhome.mytime_management')"><i></i><cf_get_lang_main dictionary_id='32219.Zaman Yönetimi'></a></li>
                                <li><a href="javascript:;" onclick="pageLoad('myhome.my_expenses')"><i></i><cf_get_lang dictionary_id='31116.Harcamalar'></a></li>     
                                <li><a href="javascript:;" onclick="pageLoad('myhome.list_my_tranings')"><i></i><cf_get_lang_main dictionary_id='57419.Eğitim'></a></li>    
                                <li><a href="javascript:;" onclick="pageLoad('myhome.list_assetp')"><i></i><cf_get_lang dictionary_id='57420.Varlıklar'></a></li>
                                <li><a href="javascript:;" onclick="pageLoad('myhome.allowance_expense')"><i></i><cf_get_lang dictionary_id='59777.Harcırahlar'></a></li>
                          </ul>
                      </div>
                  </div>
              </cf_box>
          </div>
    </div>
                

    <cfif isdefined("attributes.section")>
        <script type="text/javascript">
        $(document).ready(function(){
            $(".ui-multiselect-menu").css({"display" : "none"});
            <cfif isdefined("attributes.section")>
                pageLoad('<cfoutput>#attributes.section#</cfoutput>');
            </cfif>
            });		
        </script>
    </cfif>
    <script> 
        function pageVariablesFunction(page,formName)
        {
            
            window.basket = [];
            
            var pageLink = '';
            
            $("#"+formName).find("input,select,textarea").each(function(index,element){
    
                    
                    if($(element).is("input") && $(element).attr("type") == "checkbox")
                    {
                        if($(element).is(":checked"))
                            pageLink = pageLink + '&' + $(element).attr("name") + '=1';
    
                    }
                    else if($(element).is("input") && $(element).attr("type") == "radio")
                    {
                        if ($(element).is(":checked"))
                            pageLink = pageLink + '&' + $(element).attr("name") + '='+$(element).val();
    
                    }
                    else
                    {
                        pageLink = pageLink + '&' + $(element).attr("name") + '='+$(element).val();
    
                    }
                    
                })
                
             pageLoad(page+pageLink);
        }
    
        function pageLoad(page){
            AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction='+page+'&spa=1','ajaxContent');
        }
        
    </script>      
        