<meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" type="text/css" href="css/assets/template/w3-intranet/style.css?57867687686">
<meta charset="UTF-8">
<cf_xml_page_edit fuseact='rule.welcome'>
<cfset attributes.is_home = 1>
    
<cfset get_action = createObject('component','intranet.componentGuncelTartisma')> 
<cfset FORUMCOUNT = get_action.FORUMCOUNT_C()>
<cfset FORUM_REPLYS = get_action.FORUM_REPLYS_C()>

<div class="w3-intranet">
    <div class="container-fluid ">
        <cfinclude template="search.cfm">
        <cfsavecontent variable="kategori"><cf_get_lang_main no='725.Kategoriler'>/<cf_get_lang_main no='727.Bölümler'></cfsavecontent>
        
        <cfinclude template="rule_menu.cfm">
        <div class="row w3-home-page">
            <cfinclude template="i_fresh_information.cfm">
            <div class="col col-4 hp-middle px-4 ">                  
                <cfoutput>
                    <div class="col-12 current-disc-title">
                        <h4>GÜNCEL TARTIŞMALAR</h4>
                    </div>
                    <div class="row current-disc-counter">
                        <div class="col-4 coun-col">
                            <a href="">
                                #FORUMCOUNT.FORUMCOUNT#
                            </a>
                        </div>
                        <div class="col-4 coun-col">
                            <a href="">
                                #FORUMCOUNT.TOPICCOUNT#
                            </a>
                        </div>
                        <div class="col-4 coun-col">
                            <a href="">
                                #FORUMCOUNT.REPLYCOUNT#
                            </a>
                        </div>
                    </div>
                    <div class="row cur-disc-count-label">
                        <div class="col-4 counter-title">
                            <h6>FORUM</h6>
                        </div>
                        <div class="col-4 counter-title">
                            <h6>KONU</h6>
                        </div>
                        <div class="col-4 counter-title">
                            <h6>CEVAP</h6>
                        </div>
                    </div>
                    </cfoutput>  
                    <cfoutput query="FORUM_REPLYS">
                        <cfif find('e-',userkey) eq 1>                            
                            <cfset userid = replace(userkey,'e-','')>
                            <cfset click = "nModal({head:'Profil',page :'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#userid#'});">
                            <cfif len(PHOTO)>
                                <cfset photourl = "/documents/hr/#PHOTO#"> 
                            <cfelse>
                                <cfset photourl = "/documents/hr/"> 
                            </cfif>
                        <cfelseif find('p-',userkey) eq 1>
                            <cfset usertype = "partner">
                            <cfset userid = replace(userkey,'p-','')>
                            <cfif len(PHOTO)>
                                <cfset photourl = "/documents/hr/#PHOTO#"> 
                            <cfelse>
                                <cfset photourl = "/documents/hr/"> 
                            </cfif>
                        <cfelseif find('c-',userkey) eq 1>
                            <cfset usertype = "customer">
                            <cfset userid = replace(userkey,'c-','')>
                            <cfif len(PHOTO)>
                                <cfset photourl = "/documents/hr/#PHOTO#"> 
                            <cfelse>
                                <cfset photourl = "/documents/hr/"> 
                            </cfif>
                        </cfif>                   
                    <div class="row current-disc-content">
                        <div class="col-3">
                            <div class="row c-person-img">
                                <img src="#photourl#" class="img-fuild" alt="#name#">
                            <i class="wrk-blank-squared-bubble col-12"></i>
                            </div>                            
                        </div>
                        <div class="row col-9 c-content">
                            <a class="col-12" href="javascript://" onclick="#click#">
                              #name#
                            </a>
                            <span class="col-12">
                                #dateformat(dateadd('h',session.ep.time_zone,date),dateformat_style)#  #timeformat(dateadd('h',session.ep.time_zone,date),timeformat_style)#
                            </span>
                            <p class="col-12">
                                #reply#
                            </p>
                            <a target="_blank" class="col-12" href="#request.self#?fuseaction=forum.view_reply&topicid=#topicid#">
                                #title#
                            </a>
                        </div>
                    </div>
                    </cfoutput>
                    <cfinclude template="last_news.cfm">
                    <cfquery name="GET_LIT" DATASOURCE="#DSN#" maxrows="5">
                        SELECT
                            CONT_HEAD,
                            CONTENT_ID
                        FROM
                            CONTENT
                        WHERE
                            EMPLOYEE_VIEW = 1 AND
                            IS_VIEWED = 1 AND
                            VIEW_DATE_START <= #now()# AND
                            VIEW_DATE_FINISH >= #now()# AND
                            STAGE_ID = -2
                    </cfquery> 
                   <div class="hp-right">
                    <div class="col-12 notice">
                        <hr/>
                        <h4>DUYURULAR</h4>
                        <hr/>
                        <cfif get_lit.recordcount>
                            <cfinclude template="../../rules/display/notice.cfm">
                        <cfelse>
                            <span>
                                <i class="wrk-keyboard-right-arrow"></i><cf_get_lang_main no='72.Kayıt Yok'>!
                            </span>	
                        </cfif>
                    </div>
               </div>                    
            </div>
            <cfinclude template="i_education_cat.cfm">            
        </div>
        
    </div>
</div>
