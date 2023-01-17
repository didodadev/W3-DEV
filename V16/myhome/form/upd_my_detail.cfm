<cf_xml_page_edit fuseact="myhome.my_detail">
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
<cf_catalystHeader>
<div class="col col-2 col-xs-12 uniqueRow">
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
                <ul class="navBox acordionUl">
                    <li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_position"><i class="icn-md catalyst-briefcase" style="font-size:15px!important;" title="<cf_get_lang dictionary_id='30793.Pozisyonum'>"></i>&nbsp;<cf_get_lang dictionary_id='30793.Pozisyonum'></a></li>
                    <li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_profile"><i class="icn-md catalyst-book-open" style="font-size:15px!important;" title="<cf_get_lang dictionary_id='49821.Özgeçmiş'>"></i>&nbsp;<cf_get_lang dictionary_id='49821.Özgeçmiş'></a></li>
                    <li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_detail"><i class="icn-md catalyst-info" style="font-size:15px!important;" title="<cf_get_lang dictionary_id='31150.Bilgilerim'>"></i>&nbsp;<cf_get_lang dictionary_id='31150.Bilgilerim'></a></li>
                    <li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.dashboard" target="_blank"><i class="icn-md catalyst-pie-chart" style="font-size:15px!important;"></i>&nbsp;<cf_get_lang dictionary_id='63588.Dashboard'></a></li>
                    <li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.hr" target="_blank"><i class="icn-md catalyst-users" style="font-size:15px!important;"></i>&nbsp;<cf_get_lang dictionary_id='47630.IK İşlemleri'></a></li>
                    <li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.other_hr" target="_blank"><i class="icn-md catalyst-plane" style="font-size:15px!important;"></i>&nbsp;<cf_get_lang dictionary_id='48428.Diğer İşlemler'></a></li>
                    <li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.myTeam" target="_blank"><i class="icn-md catalyst-target" style="font-size:15px!important;"></i>&nbsp;<cf_get_lang dictionary_id='61183.Ekibim ve Ben'></a></li>
                    <li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.upd_myweek" target="_blank"><i class="icn-md catalyst-clock" style="font-size:15px!important;"></i>&nbsp;<cf_get_lang dictionary_id='32219.Zaman Yönetimi'></a></li>
                </ul>
            </div>
        </div>
    </cf_box>
</div>
<div class="col col-10 col-xs-12 uniqueRow">  
    <div class="row" id="ajaxContent">
        <cfinclude template="upd_my_info.cfm">
    </div> 
</div>          
  
<script type="text/javascript">
	$(document).ready(function(){
        $(".ui-multiselect-menu").css({"display" : "none"});
        <cfif isdefined("attributes.section")>
		    pageLoad('<cfoutput>#attributes.section#</cfoutput>');	
        </cfif>
    });	
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
