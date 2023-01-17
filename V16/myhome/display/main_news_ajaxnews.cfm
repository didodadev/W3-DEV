<cf_xml_page_edit fuseact="myhome.welcome">
	<cfsetting showdebugoutput="no">
	<cfinclude template="../query/get_homepage_news.cfm">
	<cfif is_first_content_pic eq 1>
		 <cfquery name="GET_CONT_IMAGES" datasource="#DSN#">
                SELECT 
                    CONTENT_ID,
                    CNT_IMG_NAME AS NAME,
                    CONTIMAGE_ID, 
                    CONTIMAGE_SMALL, 
                    IMAGE_SERVER_ID,
                    IMAGE_SIZE, 
                    IS_EXTERNAL_LINK,
                    PATH AS VIDEO_PATH,
                    UPDATE_DATE,
                    VIDEO_LINK
                FROM 
                    CONTENT_IMAGE
        </cfquery>
	</cfif>
	<cfif get_homepage_news.recordcount>
        <div class="mt-element-list">                                        
            <div class="mt-list-container list-news ext-2">
                <ul>
                    <cfoutput query="get_homepage_news">
                            <li class="mt-list-item text-left">
                                <div class="list-icon-container">
                                    <a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#content_id#">
                                        <i class="fa fa-angle-right"></i>
                                    </a>
                                </div>
                                <cfif is_first_content_pic eq 1>
                                    <cfquery name="get_cont_image" dbtype="query" maxrows="1">
                                        SELECT * FROM GET_CONT_IMAGES WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_homepage_news.content_id#"> AND IMAGE_SIZE=0  ORDER BY UPDATE_DATE DESC
                                    </cfquery>
                                    <div class="list-thumb">
                                        <a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#content_id#">
                                            <cfset path = "#upload_folder#content#dir_seperator#">
												<cfset file_path = '#path##get_cont_image.contimage_small#'>
                                            <cfif len(get_cont_image.contimage_small) and FileExists(file_path)>
                                                <cfimage source="#file_path#" name="image_name">
                                                <cfimage class="img-circle" source="#image_name#" action="writeToBrowser">
                                            <cfelse>
                                                <img class="img-circle" src="/images/no_photo.gif">
                                            </cfif>                                            
                                        </a>                                        
                                    </div>
                                </cfif>
                                <cfif UPDATE_DATE neq ""><cfset date=UPDATE_DATE><cfelse><cfset date=RECORD_DATE></cfif>
                                <div class="list-datetime bold uppercase font-yellow-casablanca">#DateFormat(date, dateformat_style)#</div>
                                <div class="list-item-content">
                                    <h3 class="uppercase bold">
                                        <a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#content_id#">#cont_head#</a>
                                    </h3>
                                    <cfif len (cont_summary) gte 1>
                                        <p>#cont_summary#</p>
                                        <cfelse>
                                        <p></p>
                                    </cfif>                                                            
                                </div>
                            </li>
                    </cfoutput>
                </ul>
            </div>
        </div>
		<cfelse>
            <table class="table table-hover table-light">
                <tbody>
                    <tr>
                        <td><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                    </tr>
                </tbody>
            </table>     
		</cfif>
</cf_xml_page_edit>
