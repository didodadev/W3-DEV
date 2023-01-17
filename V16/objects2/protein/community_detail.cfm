<cfset getComponent = createObject('component','V16.objects2.protein.data.community_data')>
<cfset get_hr_det = getComponent.GET_HR_DET(employee_id : attributes.emp_id)>

<cfset getComponentSer = createObject('component','V16.callcenter.cfc.call_center')>
<cfset getComponent_work = createObject('component','V16.project.cfc.get_work')>
<cfset ProjectCmp =createObject("component", "V16.project.cfc.projectData")>
<cfset opportunitiesCFC = createObject('component','V16.objects2.protein.data.opportunities_data')>

<cfset company_id = (isdefined("session.pp") ? session.pp.company_id : isdefined("session.ep") ?  session.ep.company_id  : isdefined("session.cp") ? session.cp.company_id : isdefined("session.ww") ? session.ww.company_id : "")>
<cfset time_zone = (isdefined("session.pp") ? session.pp.time_zone : isdefined("session.ep") ?  session.ep.time_zone  : isdefined("session.cp") ? session.cp.time_zone : isdefined("session.ww") ? session.ww.time_zone : "")>
<cfquery name="EMP_EVENT_COUNT" datasource="#DSN#">
  SELECT STARTDATE,EVENT_TO_POS FROM EVENT WHERE FINISHDATE >= #DATEADD('h',time_zone-3,now())# AND EVENT_TO_POS LIKE '%,#attributes.emp_id#,%'
</cfquery>
<cfquery name="EMP_EVENT_BUSY" datasource="#DSN#">
  SELECT EVENT_BUSY = SUM(DATEDIFF(MINUTE, STARTDATE, FINISHDATE)) FROM EVENT WHERE STARTDATE >= #DATEADD('h',time_zone-3,now())# AND FINISHDATE >= #DATEADD('h',time_zone-3,now())# AND EVENT_TO_POS LIKE '%,#attributes.emp_id#,%'
</cfquery>
<cfquery name="EMP_WORK_BUSY_ESTIMATED" datasource="#DSN#">
  SELECT SUM(ESTIMATED_TIME) AS WORK_BUSY FROM PRO_WORKS WHERE WORK_STATUS = 1 AND PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"> AND PRO_WORKS.COMPANY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#">
</cfquery>
<cfquery name="EMP_WORK_BUSY_SPENT" datasource="#DSN#">
  SELECT SUM(TOTAL_TIME_HOUR) AS TOTAL_WORK_HOUR,SUM(TOTAL_TIME_MINUTE) AS TOTAL_WORK_MINUTE FROM PRO_WORKS_HISTORY WHERE WORK_STATUS = 1 AND PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"> AND PRO_WORKS_HISTORY.COMPANY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#">
</cfquery>
<cfset w_busy_result = 0>
<cfif len(EMP_WORK_BUSY_ESTIMATED.WORK_BUSY) and len(EMP_WORK_BUSY_SPENT.TOTAL_WORK_HOUR) and len(EMP_WORK_BUSY_SPENT.TOTAL_WORK_MINUTE)>
  <cfset w_busy_est = EMP_WORK_BUSY_ESTIMATED.WORK_BUSY>
  <cfset w_busy_spent = (EMP_WORK_BUSY_SPENT.TOTAL_WORK_HOUR * 60) + (EMP_WORK_BUSY_SPENT.TOTAL_WORK_MINUTE)> 
  <cfset w_busy_result = w_busy_est - w_busy_spent>	
</cfif>
<cfif len(EMP_EVENT_BUSY.EVENT_BUSY)>
  <cfset e_busy = EMP_EVENT_BUSY.EVENT_BUSY>
<cfelse>
  <cfset e_busy = 0>
</cfif>	
<cfset total_busy_m = w_busy_result + e_busy>
<cfset busy_h = total_busy_m / 60>
<cfset busy_m = total_busy_m % 60>

<cfset employee_list = ''>            
<cfoutput query="get_hr_det">    
    <cfset employee_list = listappend(employee_list,get_hr_det.employee_id,',')>
</cfoutput>
<cfset GET_POSITIONS= getComponent.GetPositions(employee_list:employee_list)>
<cfif len(GET_POSITIONS.department_id)>
  <cfset attributes.department_id = GET_POSITIONS.department_id>
  <cfinclude template="../query/get_location.cfm">
  <cfif len(get_location.company_id)>
    <cfquery name="GET_COMPANY" datasource="#DSN#">
      SELECT COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_location.company_id#">
    </cfquery>
  </cfif>
<cfelse>
  <cfset attributes.department_id = 0>
</cfif>
<cfscript>
	get_imcat = createObject("component","V16.hr.cfc.get_im");
	get_imcat.dsn = dsn;
	get_ims = get_imcat.get_im(
		employee_id : attributes.emp_id
	);
</cfscript>
<div class="user_list_det">
  <div class="user_list_item">
    <div class="user_list_item_img">
      <cfif len(get_hr_det.PHOTO)>
        <img src="<cfoutput>/documents/hr/#get_hr_det.PHOTO#</cfoutput>"  height="300px" width="300px">                     
      <cfelseif get_hr_det.SEX eq 1>                      
          <img src="/images/male.jpg" height="300px" width="300px">                      
      <cfelseif get_hr_det.SEX eq 0>                      
        <img src="/images/female.JPG" height="300px" width="300px">                      
      </cfif>                    
    </div>
    <div class="user_list_item_text">
      <p><cfoutput>#get_hr_det.EMPLOYEE_NAME# #get_hr_det.EMPLOYEE_SURNAME#</cfoutput></p>
      <cfset GET_POSITION = getComponent.GetPosition(employee_id:attributes.emp_id)>
      <cfif get_position.recordcount>
        <p><cfoutput>#get_position.department_head#, #get_position.position_name#</cfoutput></p>
      </cfif> 
      <cfoutput><p><cfif attributes.department_id neq 0 and isdefined('get_company.company_name') and len(get_company.company_name)>#get_company.company_name#</cfif> - 
        <cfif attributes.department_id neq 0>#get_location.zone_name#</cfif> / <cfif attributes.department_id neq 0>#get_location.branch_name#</cfif> -
        <cfif attributes.department_id neq 0>#get_location.department_head#</cfif>
      </p></cfoutput>    
      <ul class="user_list_item_social">
        <cfoutput query="get_ims">
            <li>                           
                <img src="/documents/settings/#IMCAT_ICON#" onclick="window.open('#IM_ADDRESS#', '_blank');" style="cursor: pointer;" height="30px" width="30px">                         
            </li>
        </cfoutput>                     
      </ul>
      <div class="user_list_item_social_agenda">
        <a href="advisorCalendar?emp_id=<cfoutput>#get_hr_det.employee_id#</cfoutput>" target="blank_">
          <i class="fa fa-calendar"></i>   Ajandamı incelemek için tıklayın .
        </a>
      </div>
    </div>
    <div class="user_list_detail_right">
      <label>Rating</label>
      <div class="user_list_detail_svg">
        <div class="user_list_detail_svg_icon">
          <img src="/src/assets/icons/catalyst-icon-svg/einstein.svg" width="50px" height="80px"><span><cfoutput>#AmountFormat(get_hr_det.EINS_POINT,1)#</cfoutput></span>
        </div>
        <div class="user_list_detail_svg_icon">
          <img src="/src/assets/icons/catalyst-icon-svg/BruceLee.svg" width="50px" height="80px"><span class="brcle"><cfoutput>#AmountFormat(get_hr_det.BRUC_POINT,1)#</cfoutput></span>	
        </div>												
      </div>
    </div> 
  </div> 
  <div class="user_list_accordion">
    <div class="user_list_accordion_head">
      <cf_get_lang dictionary_id='62019.Sertifikalarım'>
    </div>
    <div class="user_list_accordion_detail">
      <cfset GET_CERTIFICATES = getComponent.GET_CERTIFICATES(emp_id : get_hr_det.employee_id)>
      <cfif GET_CERTIFICATES.recordcount>
        <cfloop query="GET_CERTIFICATES">
          <span>                    
            <cfoutput>#GET_CERTIFICATES.CERTIFICATE_NAME#</cfoutput>               
          </span>
        </cfloop> 
      </cfif>    
    </div>	
  </div>
  <div class="user_list_accordion">
    <div class="user_list_accordion_head">
      <cf_get_lang dictionary_id='62022.Hakkımda'>
    </div>
    <div>
      <cfquery name="GET_RESUME_TEXT" datasource="#DSN#">
        SELECT 
            RESUME_TEXT 
        FROM 
            EMPLOYEES_APP                         
        WHERE 
            EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
      </cfquery>
      <cfif len(GET_RESUME_TEXT.RESUME_TEXT)>           
        <p><cfoutput>#GET_RESUME_TEXT.RESUME_TEXT#</cfoutput></p>
      </cfif>   
    </div>	
  </div>
  <div class="user_list_accordion">
    <div class="user_list_accordion_head">
      <cf_get_lang dictionary_id='63036.Yoğunluk'>: <span><cfscript>writeOutput(floor(Abs(busy_h)));</cfscript> <cf_get_lang dictionary_id='57491.Saat'> <cfscript>writeOutput(Abs(busy_m))</cfscript> <cf_get_lang dictionary_id='58827.Dk'></span>
    </div><cfoutput>
    <div class="user_list_accordion_detail">
      <cfset EMP_PROJECT_COUNT = ProjectCmp.get_projects(emp_id : get_hr_det.employee_id)>      
      <cfset EMP_WORK_COUNT = getComponent_work.DET_WORK(emp_id : get_hr_det.employee_id)>
      <cfset EMP_CALL_COUNT = getComponentSer.GET_SERVICE(resp_id : '#get_hr_det.employee_id#_2' )>
      <cfset EMP_SERVICE_COUNT = getComponentSer.GET_SERVICE(employee_id : get_hr_det.employee_id )>
      <cfset EMP_OPP_COUNT = opportunitiesCFC.GET_OPPORTUNITIES(sales_emp_id : get_hr_det.employee_id,sales_emp:'def')>
      <div class="user_list_accordion_detail_item">								
        <p><cf_get_lang dictionary_id='57416.Proje'></p> <p>#iif(isdefined('EMP_PROJECT_COUNT.recordCount'),DE('#EMP_PROJECT_COUNT.recordCount#'),DE('0'))#</p>
      </div> 
      <div class="user_list_accordion_detail_item" style="background-color: rgb(104, 226, 187);">								
        <p><cf_get_lang dictionary_id='58445.İş'></p> <p>#iif(isdefined('EMP_WORK_COUNT.recordCount'),DE('#EMP_WORK_COUNT.recordCount#'),DE('0'))#</p>
      </div>	 
      <div class="user_list_accordion_detail_item" style="background-color: rgb(142, 207, 255);">								
        <p><cf_get_lang dictionary_id='62263.Çağrı'></p> <p>#iif(isdefined('EMP_WORK_COUNT.recordCount'),DE('#EMP_CALL_COUNT.recordCount#'),DE('0'))#</p>
      </div>
      <div class="user_list_accordion_detail_item" style="background-color: rgb(239, 184, 184);">								
        <p><cf_get_lang dictionary_id='57656.Servis'></p> <p>#iif(isdefined('EMP_WORK_COUNT.recordCount'),DE('#EMP_SERVICE_COUNT.recordCount#'),DE('0'))#</p>
      </div>
      <div class="user_list_accordion_detail_item" style="background-color: rgb(210, 166, 201);">								
        <p><cf_get_lang dictionary_id='57612.Fırsat'></p> <p>#iif(isdefined('EMP_WORK_COUNT.recordCount'),DE('#EMP_OPP_COUNT.recordCount#'),DE('0'))#</p>
      </div>
    </div>	</cfoutput>
  </div>
  <div class="user_list_accordion">
    <div class="user_list_accordion_head">
      <cf_get_lang dictionary_id='58045.İçerikler'>
    </div><cfoutput>
    <div class="user_list_accordion_detail">
      <cfquery name="EMP_WIKI_COUNT" datasource="#DSN#">
        SELECT C.OUTHOR_EMP_ID FROM CONTENT C 
        LEFT JOIN CONTENT_CHAPTER CC ON C.CHAPTER_ID = CC.CHAPTER_ID 
        LEFT JOIN CONTENT_CAT CCAT ON  CCAT.CONTENTCAT_ID = CC.CONTENTCAT_ID
        WHERE C.CONTENT_STATUS = 1 AND CCAT.CONTENTCAT_ID IN (<cfqueryparam value="#attributes.xml_wiki_cat_id#" cfsqltype="cf_sql_integer" list="true">)
        AND C.OUTHOR_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
      </cfquery>      
      <div class="user_list_accordion_detail_item">								
        <p><cf_get_lang dictionary_id='60721.Wiki'></p> <p>#EMP_WIKI_COUNT.recordCount#</p>
      </div> 
      <div class="user_list_accordion_detail_item" style="background-color: rgb(252, 198, 117);">	
        <cfquery name="EMP_TOPIC_COUNT" datasource="#DSN#">
          SELECT RECORD_EMP FROM FORUM_TOPIC WHERE RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
        </cfquery>
        <cfquery name="EMP_REPLY_COUNT" datasource="#DSN#">
          SELECT RECORD_EMP FROM FORUM_REPLYS WHERE RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
        </cfquery>							
        <p><cf_get_lang dictionary_id='57421.Forum'></p> <p>#EMP_TOPIC_COUNT.recordCount#-#EMP_REPLY_COUNT.recordCount#</p>
      </div>	 
    </div>	</cfoutput>
  </div>
  <div class="icon_list_accordion_item">
    <div>
      <a href="javascript:addNot();">
        <img src="/src/assets/icons/catalyst-icon-svg/notebooks.png" height="50px">
        <span class="icon_list_accordion_item_detail"><cf_get_lang dictionary_id='62023.Not Bırakın'></span>
      </a>
    </div>
    <div>
      <a href="advisorCalendar?emp_id=<cfoutput>#get_hr_det.employee_id#</cfoutput>" target="blank_">      
        <img src="/src/assets/icons/catalyst-icon-svg/google-calendar.svg" height="50px">
        <span class="icon_list_accordion_item_detail"><cf_get_lang dictionary_id='62024.Toplantı Talep Edin'></span>
      </a>
    </div>
  </div>
</div>
<script> 
  function addNot() {
    openBoxDraggable('widgetloader?widget_load=AddNote<cfoutput>&iid=#attributes.emp_id#&id=emp_id&next=#attributes.param_1#&title=#getLang('','',57467)#</cfoutput>&isbox=1');
  } 
  var myColors = ['#ffdb5c', '#68e2bb', '#8ecfff', '#efb8b8', '#d2a6c9', '#b3ced2','#d2a6c9','#ffe485','#9dd6ff' ,'#65e2ba' ,'#fcc675'];
  var i = 0;
  $('.user_list_accordion_detail span').each(function() {
    $(this).css('background-color', myColors[i]);
    i = (i + 1) % myColors.length;
  });
</script>
