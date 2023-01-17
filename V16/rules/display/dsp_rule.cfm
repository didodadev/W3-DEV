<cfset fileSystem = CreateObject("component","V16.asset.cfc.file_system")>
<style>
    table, td, th, div{border-collapse:collapse;font-size:initial!important;}
</style>
<script type="text/javascript">
	function connectAjax()
	{
		var bb = "<cfoutput>#request.self#?fuseaction=objects2.emptypopup_get_body_query&content_id=#attributes.cntid#&is_body=1</cfoutput>";
		AjaxPageLoad(bb,'content_body_place',0);
	}
</script>
<!--- bu sayfa birde Doruk için add_options altında vardır,yapılan genel değişiklik ordada yapılmalıdır AE20060621--->
<cfinclude template="../query/get_content.cfm">
<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_chapter_menu.cfm">
<cfinclude template="../query/get_content_cat.cfm">
<cfinclude template="../query/get_customer_cat.cfm">
<cfquery name="GET_ASSET_CATS" datasource="#DSN#">
	SELECT ASSETCAT_ID,ASSETCAT_PATH FROM ASSET_CAT
</cfquery>
<cfset content_denied = 0>
<cfset application.getDeniedPages = createObject("component", "WMO.getDeniedPages")>
<cfset deniedData = application.getDeniedPages.pageAuthority('#dsn#','#session.ep.userid#','#attributes.fuseaction#','#session.ep.position_code#', attributes.wrkflow?:0, "?" & cgi.QUERY_STRING, attributes.event?:'', cgi.http_referer, attributes.wsr_code?:'')>
<cfset structAppend(variables, deniedData)/>
<cfif StructKeyExists(application.deniedPages,'content.list_content')>
    <cfif deniedData['content.list_content']['IS_VIEW'] eq 1>
      <cfset content_denied = 1>
    <cfelse>
        <cfset content_denied = 0>
    </cfif>
</cfif>
<cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
	SELECT IS_CONTENT_FOLLOW FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfif get_content.recordcount>
	<cfinclude template="../query/get_content_property.cfm">
	<cfinclude template="../query/get_content_file.cfm">
	<cfinclude template="../query/get_related_cont.cfm">
	<cfif len(get_content.hit_employee)>
		<cfset hit_employee = get_content.hit_employee + 1>
	<cfelse>
		<cfset hit_employee = 1>
	</cfif>
	<cfquery name="HIT_UPDATE" datasource="#DSN#">
		UPDATE CONTENT SET HIT_EMPLOYEE = #hit_employee#, LASTVISIT = #now()# WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cntid#">
	</cfquery>
<cfelse>
	<script type="text/javascript">
		alert('<cf_get_lang dictionary_id='65062.İçerik bulunamadı'>!');
		history.back();
	</script>
	<cfabort>
</cfif>
<cfparam name="attributes.train" default="0">

<input type="hidden" name="cntid" id="cntid" value="<cfoutput>#attributes.cntid#</cfoutput>">
<cfset attributes.is_home = 1>
<cfif attributes.train neq 1>
    <cfinclude template="rule_menu.cfm">
</cfif>
<div class="blog">
    <cfif attributes.train neq 1>
        <div class="col col-9 col-md-9 col-sm-9 col-xs-12" style="margin-top:5px">
    <cfelse>
        <div class="col col-9 col-md-9 col-sm-9 col-xs-12" style="margin-top: 20px;">
    </cfif>
            <div class="blog_detail flex-col">           
                <div class="blog_detail_content_top" id="wiki">  
                    <div class="blog_detail_top" style="border-bottom:2px dashed #eee;padding: 10px 0 17px 0;margin-bottom: 10px;">
                        <cfoutput>
                            <span class="bold">
                                #get_content.CONTENTCAT#/
                                #get_content.chapter#
                                <cfif len(get_content.CONTENT_PROPERTY_ID)>
                                    <cfquery name="get_content_property" datasource="#dsn#">
                                        SELECT NAME FROM CONTENT_PROPERTY WHERE CONTENT_PROPERTY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_content.CONTENT_PROPERTY_ID#">
                                    </cfquery> 
                                    /#get_content_property.name#
                                </cfif>
                            </span>
                            <ul class="blog_detail_top_icon">                           
                                <li>
                                    <cfif listFindNoCase(session.ep.user_level,2,',') and content_denied eq 0>
                                        <a href="javascript://" onclick="javascript:$(location).attr('href','#request.self#?fuseaction=content.list_content&event=det&cntid=#attributes.cntid#')" title="<cf_get_lang_main no='52.Güncelle'>"><i class="wrk-uF0002"></i></a>
                                    </cfif>
                                </li>
                                <li>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_temp_rule&action=print&id=#attributes.cntid#&module=rule','page');return false;" title="<cf_get_lang_main no='62.Yazdır'>"><i class="wrk-uF0135"></i></a>
                                </li>
                                <li>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_temp_rule&action=mail&id=#attributes.cntid#&module=rule','page')" title="<cf_get_lang_main no='63.Mail Gönder'>"><i class="wrk-uF0099"></i></a>
                                </li>
                                <li>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_temp_rule&action=pdf&id=#attributes.cntid#&module=rule','page')" title="<cf_get_lang_main no='66.PDF Yap'>"><i class="wrk-uF0137"></i></a>
                                </li>
                            </ul>
                        </cfoutput>
                    </div>          
                    <div class="reply_item" style="box-shadow:none;">
                        <div class="syllabus_name_border">
                            <a href="javascript://">
                                <cfoutput>#get_content.cont_head#</cfoutput>
                            </a>
                            <cfif get_our_company_info.is_content_follow eq 1>
                                <cfif get_content.is_dsp_summary eq 0>
                                    <p class="text bold"><cfoutput>#get_content.cont_summary#</cfoutput></p>
                                </cfif>  
                            <cfelse>
                                <cfif get_content.is_dsp_summary eq 0>
                                    <p class="text bold"><cfoutput>#get_content.cont_summary#</cfoutput></p>
                                </cfif>
                            </cfif>
                        </div>
                        <div class="syllabus_text"> <cfoutput>#get_content.cont_body#</cfoutput></div>
                        <cfif get_content.recordcount and len(get_content.upd_count) and len(get_content.update_date) and len(get_content.update_member)>
                            <div class="syllabus_cat">
                                <p class="bold">
                                    <i class="wrk-uF0002" style="color: #44b6ae;font-size:12px;"></i> 
                                    <span>
                                        <cfoutput>#get_content.employee_name# #get_content.employee_surname# -  
                                            <cfif len(get_content.record_date)>
                                                #dateformat(date_add('h',session.ep.time_zone,get_content.record_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,get_content.record_date),timeformat_style)#
                                            </cfif>
                                        </cfoutput>
                                    </span>
                                    <i class="wrk-uF0213" style="color: #44b6ae;font-size:12px;"></i>
                                    <cfset tarih=date_add('h',session.ep.time_zone,get_content.update_date)>
                                    <cfset attributes.employee_id = get_content.update_member>
                                    <cfinclude template="../query/get_employee_name.cfm">
                                    <span><cfoutput>#get_employee_name.employee_name# #get_employee_name.employee_surname# - #dateformat(tarih,dateformat_style)# #timeformat(tarih,timeformat_style)# </cfoutput></span>
                                </p>
                                <div class="syllabus_catr">
                                    <p class="bold">
                                        <i class="wrk-uF0064" style="color: #44b6ae;font-size:12px;"></i><span><cfoutput>#get_content.upd_count#</cfoutput></span> <i class="wrk-uF0092" style="color: #44b6ae;font-size:12px;"></i><span><cfoutput> E: #get_content.hit_employee# / P:#get_content.hit_partner# / I:#get_content.hit#</cfoutput></span>
                                    </p>
                                </div>
                            </div>
                            
                        </cfif>
                    </div>                
                </div>                
            </div>
            <cfset attributes.content_id = attributes.cntid>
            <cfquery name="GET_PRODUCT_COMMENT" datasource="#DSN#">
                SELECT 
                    CC.*,
                    E.PHOTO,
                    ED.SEX
                FROM
                    CONTENT_COMMENT AS CC
                    LEFT JOIN EMPLOYEES AS E ON E.EMPLOYEE_ID = CC.EMP_ID
                    LEFT JOIN EMPLOYEES_DETAIL AS ED ON E.EMPLOYEE_ID = ED.EMPLOYEE_ID
                WHERE
                    CC.CONTENT_ID = #attributes.CONTENT_ID#
                    AND CC.STAGE_ID = -2 
            </cfquery>
            <cfinclude template="../query/get_content_head.cfm">
            <cfif GET_PRODUCT_COMMENT.RECORDCOUNT>
                <div class="blog_detail blog_detail_reply flex-col">                
                    <div class="reply_item" style="box-shadow:none;padding:0;">
                        <div class="syllabus_name" style="margin-bottom:10px;">
                            <a href="javascript://" >
                                <cfoutput>#getLang('rule',29)#</cfoutput>
                            </a>
                        </div>
                    </div>                   
                    <cfoutput query="GET_PRODUCT_COMMENT">
                        <div class="forum_item_wrapper flex-row">
                            <div class="forum_item_avatar">
                                <cfif len(PHOTO)>
                                    <div class=""></div><img src="../documents/hr/#PHOTO#" class="img-circle" alt="">
                                <cfelseif SEX eq 1>
                                    <img src="../images/male.jpg" class="img-circle" alt="">
                                <cfelse>
                                    <img src="../images/female.jpg" class="img-circle" alt="">
                                </cfif>
                            </div>
                            <div class="forum_item_message">
                                <div class="forum_item_message_title">
                                    <h3>#name# #surname#
                                        <cfif len(GET_PRODUCT_COMMENT.RECORD_DATE)>
                                            <span>#dateformat(GET_PRODUCT_COMMENT.RECORD_DATE,dateformat_style)# #timeformat(GET_PRODUCT_COMMENT.RECORD_DATE,timeformat_style)#
                                                -
                                                <span class="ltCommentPoint" id="point#CurrentRow#"></span>                                                                         
                                                <script>
                                                for (var i = 0; i < #content_comment_point#; i++) {
                                                    $('##point#CurrentRow#').append('<i class="catalyst-star"></i>');
                                                }
                                                </script>
                                            </span>
                                        </cfif>
                                        
                                    </h3>
                                </div>
                                <div class="forum_item_message_content">
                                    #content_comment#
                                </div>
                            </div>
                        </div>
                    </cfoutput>                
                </div>                
            </cfif>
            <div class="blog_detail blog_detail_reply flex-col">
                <div class="reply_item" style="box-shadow:none;padding:0;">
                    <div class="syllabus_name"  style="margin-bottom:10px;">
                        <a href="javascript://">
                            <cfoutput>#getLang('rule',28)#</cfoutput>
                        </a>
                    </div>
                </div>
                    
                <cfquery name="get_employee_email" datasource="#dsn#">
                    SELECT EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = #session.ep.userid#
                </cfquery>
                <cfform name="employe_detail" method="post" action="#request.self#?fuseaction=rule.emptypopup_add_content_comment">
                    <input type="hidden" name="content_id" id="content_id" value="<cfoutput>#attributes.content_id#</cfoutput>">
                    <input type="hidden" name="name" id="name" maxlength="50" readonly value="<cfoutput>#session.ep.name#</cfoutput>">
                    <input type="hidden" name="surname" id="surname" maxlength="50" readonly value="<cfoutput>#session.ep.surname#</cfoutput>">
                    <cfsavecontent variable="message"><cf_get_lang_main no='59.eksik veri'>:<cf_get_lang_main no='16.E-mail !'></cfsavecontent>
                        <div class="ui-row">
                            <div class="ui-form-list ui-form-block">
                                
                                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                                    <cfmodule
                                            template="../../../fckeditor/fckeditor.cfm"
                                            toolbarset="WRKContent"
                                            basepath="/fckeditor/"
                                            instancename="CONTENT_COMMENT"
                                            valign="top"
                                            value=""
                                            width="100%"
                                            height="150">
                                </div>
                                <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <label><cf_get_lang_main no='16.email'>*</label>
                                    <cfinput type="text" name="MAIL_ADDRESS" maxlength="100" value="#get_employee_email.employee_email#" required="yes" message="#MESSAGE#">
                                </div>
                                <div class="form-group  col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <label><cf_get_lang_main no='1572.Puan'></label>
                                        <input name="CONTENT_COMMENT_POINT" id="CONTENT_COMMENT_POINT" type="hidden" value="">
                                    <div class="rating">
                                        <i class="fa fa-star-o" index="1"></i>
                                        <i class="fa fa-star-o" index="2"></i>
                                        <i class="fa fa-star-o" index="3"></i>
                                        <i class="fa fa-star-o" index="4"></i>
                                        <i class="fa fa-star-o" index="5"></i>
                                    </div>
                                </div>
                        </div>
                    </div>
                    <div class="ui-form-list-btn">
                        <cf_workcube_buttons is_upd='0' add_function='kontrol()'> 
                        </div>
                </cfform>
            </div>
        </div>
    <cfif attributes.train neq 1>
        <div id="current_content" class="col col-3 col-md-3 col-sm-3 col-xs-12">
    <cfelse>
        <div id="current_content" class="col col-3 col-md-3 col-sm-3 col-xs-12" style="margin-top: 15px;">
    </cfif> 
            <cfif isDefined("attributes.train") and attributes.train eq 1>
                <cf_box class="clever">
                    <div id="training_feedback"></div>
                </cf_box>
                <!--- Rastgele Soru --->
                <cf_box class="clever">
                    <div class="portHeadLight">
                        <div class="portHeadLightTitle">
                            <span>
                                <a href="javascript://"><cf_get_lang dictionary_id='64042.Alıştırma Yap'></a>
                            </span>
                        </div>
                    </div>
                    <div id="random_question"></div>
                </cf_box>
                <!--- //Rastgele Soru --->
            </cfif>
            <!-- Ilişkiler -->
            <cfquery name="GET_ASSETS" dbtype="query">
                SELECT * FROM GET_ASSET WHERE ASSET_FILE_NAME NOT LIKE '%.flv%' AND ASSET_FILE_NAME NOT LIKE '%.swf%'
            </cfquery>
            <!--- & Thumbnail Ekli İlişkili Belge  --->
            <div class="training_items" style="margin-bottom:-5px">                    
                <cf_box class="clever" scroll="0">
                    <div class="portHeadLight">
                        <div class="portHeadLightTitle">
                            <span>
                                <a href="javascript://"><cf_get_lang dictionary_id='30183.Videolar'></a>
                            </span>
                        </div>
                    </div>
                    <cfloop query="get_assets">
                        <cfif len(EMBEDCODE_URL) and EMBEDCODE_URL contains "youtube" or EMBEDCODE_URL contains "loom">
                            <cfoutput>
                                <div class="protein-table">
                                    <div style="word-wrap: break-word;white-space: normal;">
                                        <div class="list_video_img">
                                            <a href="#EMBEDCODE_URL#" target="_blank" class="list_video_link">
                                                <i class="fa fa-youtube-play"></i>
                                            </a>
                                        </div>
                                        <div class="training_items_head">
                                            <a href="#EMBEDCODE_URL#" target="_blank">#asset_name# (#name#)</a>
                                        </div>
                                    </div>
                                </div>
                            </cfoutput>
                        </cfif>
                    </cfloop>
                </cf_box>                    
            </div>         
            <!--- & Thumbnail Ekli İlişkili Belge  --->
            <!--- & İlişkili Konular --->
            <cfif get_related_cont.recordcount>
                <cf_box class="clever" scroll="0">
                    <div class="portHeadLight">
                        <div class="portHeadLightTitle">
                            <span>
                                <a href="javascript://"><cf_get_lang dictionary_id='55049.İlişkili Konular'></a>
                            </span>
                        </div>
                    </div>
                    <div class="protein-table training_items" style="border-bottom:0px!important;">
                        <table style="table-layout: fixed;">
                            <tbody>
                                <cfoutput query="get_related_cont">
                                    <tr>
                                        <td style="word-wrap: break-word;white-space: normal;">
                                            <div class="training_items_head">
                                                <a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#content_id#">#cont_head#</a>
                                            </div>
                                            <div class="training_items_cont_sum">
                                                #CONT_SUMMARY#
                                            </div>
                                            <div class="training_items_cat">
                                                
                                            </div>
                                        </td>
                                    </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </cf_box>
            </cfif>  
            <!--- & İlişkili Konular --->

            <!--- & Asset --->
            <cfif get_asset.recordcount>   
                <cf_box class="clever" scroll="0">
                    <div class="portHeadLight">
                        <div class="portHeadLightTitle">
                            <span>
                                <a href="javascript://"><cf_get_lang dictionary_id='57568.Belgeler'></a>
                            </span>
                        </div>
                    </div>
                    <div class="protein-table training_items">
                        <div class="asset_list">                            
                            <table style="table-layout: fixed;">
                                <tbody>
                                    <cfoutput query="get_assets">
                                        <cfquery name="GET_ASSET_CAT" dbtype="query">
                                            SELECT ASSETCAT_ID,ASSETCAT_PATH FROM GET_ASSET_CATS WHERE ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#assetcat_id#">
                                        </cfquery>
                                        <cfif not len(asset_file_path_name)>
                                            <cfif assetcat_id gte 0>
                                            <cfset folder="asset/#get_asset_cat.assetcat_path#">
                                        <cfelse>
                                            <cfset folder="#get_asset_cat.assetcat_path#">
                                            </cfif>
                                        </cfif>
                                        <cfset fileExtension = listLast(asset_file_name,'.')>
                                        <tr>
                                            <cfif FindNoCase("youtube",EMBEDCODE_URL) eq 0>
                                                <cfif len(EMBEDCODE_URL)>
                                                    <td>
                                                        <img src="css/assets/icons/catalyst-icon-svg/PDF.svg" width="30px" height="40px">
                                                        <a style="position:absolute;left:80px;" href="#EMBEDCODE_URL#" target="_blank" title="#asset_detail#">#asset_name# (#name#)</a>
                                                    </td>
                                                <cfelse>
                                                    <cfif len(fileExtension) and FileExists(replace('#download_folder#css/assets/icons/catalyst-icon-svg/#fileExtension#.svg','\','/','all'))>
                                                        <td>
                                                            <img src="css/assets/icons/catalyst-icon-svg/#fileExtension#.svg" width="30px" height="40px">
                                                            <a style="position:absolute;left:80px;" href="javascript:windowopen('#file_web_path##folder#/#asset_file_name#','small');" title="#asset_detail#">#asset_name# (#name#)</a>
                                                        </td>
                                                    <cfelse>
                                                        <td> <img src="css/assets/icons/catalyst-icon-svg/UNKOWN.svg" width="30px" height="40px"><a style="position:absolute;left:80px;" href="javascript:windowopen('#file_web_path##folder#/#asset_file_name#','small');" title="#asset_detail#">#asset_name# (#name#)</a></td>
                                                    </cfif>
                                                </cfif>
                                            </cfif>
                                        </tr>
                                    </cfoutput>
                                <tbody>
                            </table>
                        </div>
                    </div>
                </cf_box>
            </cfif> 
        </div>
        <!--- & Asset --->
              
        <cfset cfc= createObject("component","V16.objects.cfc.get_meta_desc")>
        <cfset get_meta_desc=cfc.GetMetaDescList(action_id:attributes.cntid)>
        <cfif get_meta_desc.recordcount>
            <div class="blog_item flex-col" style="border-bottom:0px!important;">
                <div class="blog_item_text">
                <div class="blog_title"><cf_get_lang dictionary_id='58976.Meta'></div>
                    <ul class="ui-list">
                        <cfoutput query="get_meta_desc">
                            <li>
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_meta_desc&meta_desc_id=#meta_desc_id#','medium')"  class="title"><div class="ui-list-left"><img src="css/assets/icons/catalyst-icon-svg/ctl-writer-1.svg" style="margin:0 10px 0 0!important;" width="20px">#DecodeForHTML(meta_title)# - (#DecodeForHTML(language_set)#)</div></a>
                            </li>
                        </cfoutput>
                    </ul>
                </div>
            </div>
        </cfif>

        <cfif isdefined("url.faction") and len(url.faction)>
            <cfquery name="get_process" datasource="#dsn#">
                SELECT  PROCESS_NAME FROM PROCESS_TYPE WHERE PROCESS_ID=#url.faction#
            </cfquery>
            <div class="blog_item" style="flex-direction:column">
                <div class="blog_title"><cfoutput>#get_process.PROCESS_NAME# : <cf_get_lang dictionary_id="58045.İçerik"></cfoutput></div>
                <cfquery name="GET_CONTENTS_LIST" datasource="#dsn#">
                    SELECT CONTENT_ID FROM CONTENT_RELATION WHERE  ACTION_TYPE='PROCESS_ID' AND ACTION_TYPE_ID = #url.faction# 
                </cfquery>             
                <div class="blog_item_text">   
                    <ul class="ui-list">
                        <cfoutput query="get_contents_list">
                            <cfquery name="get_contents" datasource="#dsn#">
                            SELECT CONT_HEAD, CONTENT_ID FROM CONTENT WHERE CONTENT_ID=#CONTENT_ID#
                            </cfquery>
                            <li>
                                <a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#content_id#&faction=#url.faction#">
                                    <div class="ui-list-left">
                                        <span class="ui-list-icon ctl-ereader"></span>
                                    #get_contents.CONT_HEAD#
                                    </div>
                                </a>
                            <li>
                        </cfoutput>
                    </ul>
                </div> 
            </div>        
        </cfif>
    </div> 
</div>

<cfif get_our_company_info.is_content_follow eq 1> <!--- bu kontrol icerik detayli takibi yapilabilmesi ve icerik kopyalama engeli icin konuldu 30062007 FS --->
	<cfquery name="ADD_CONTENT_FOLLOWS" datasource="#DSN#">
		INSERT INTO CONTENT_FOLLOWS 
		(
            CONTENT_ID,
            EMPLOYEE_ID,
            READ_DATE,
            READ_IP
		)
		VALUES
		(
            #attributes.cntid#,
            #session.ep.userid#,
            #now()#,
            '#CGI.REMOTE_ADDR#'
		)
	</cfquery>
</cfif>
<script>
    $(document).prop("title", "<cfoutput>#get_content.cont_head#</cfoutput>");
    $(function(){
        $('.rating i').click(function(){
            $('.rating i').addClass("fa-star-o").removeClass("fa-star");
            $(this).addClass("fa-star").removeClass("fa-star-o");
            $(this).prevAll().addClass("fa-star").removeClass("fa-star-o");
            $('#CONTENT_COMMENT_POINT').val($(this).attr("index"));  
        })
    });
    
    AjaxPageLoad('<cfoutput>#request.self#?fuseaction=training.content&event=randomQuestion&cntid=#attributes.cntid#</cfoutput>', 'random_question');
    AjaxPageLoad('<cfoutput>#request.self#?fuseaction=training.content&event=feedBack&cntid=#attributes.cntid#</cfoutput>', 'training_feedback');
</script>