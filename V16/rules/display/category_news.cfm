<cfinclude template="../query/get_category_news.cfm">
<cfif get_category_news.recordcount>
	<cfoutput query="get_category_news">
        <cfquery name="GET_IMAGE" datasource="#DSN#" maxrows="1">
            SELECT 
                CONTIMAGE_SMALL
            FROM
                CONTENT_IMAGE
            WHERE
                CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_category_news.content_id#">
            ORDER BY 
                CONTIMAGE_ID DESC
        </cfquery>
        <div class="blog_item" style="box-shadow:none; border-bottom: 3px dashed ##ddd;">
            <cfif get_image.recordcount>
                <div class="blog_item_img">
                    <img src="#file_web_path#content/#get_image.contimage_small#" style="height:100px!important">
                </div>
            </cfif>
            <div class="blog_item_text" style="background-color:none; border-radius:none;">
                <a class="title" href="#request.self#?fuseaction=rule.dsp_rule&cntid=#content_id#">#cont_head#</a>
                <p class="padding-bottom-5">#Left(cont_summary, 90)#...</p>
            </div>                      
        </div>
    </cfoutput>
<cfelse>
	<cf_get_lang_main no='72.Kayıt Yok!'>
</cfif>