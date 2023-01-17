<cfquery name="GET_MY_POSITION_CAT_USER_GROUP" datasource="#DSN#">
	SELECT POSITION_CAT_ID,USER_GROUP_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#">
</cfquery>

<cfquery name="GET_HOMEPAGE_NEWS" datasource="#DSN#">
	SELECT 
		C.CONTENT_ID,
		C.POSITION_CAT_IDS,
		C.USER_GROUP_IDS,
		C.CONT_HEAD,
		C.RECORD_MEMBER,
		C.RECORD_DATE,
		C.CONT_SUMMARY
	FROM 
		CONTENT C,
		CONTENT_CAT CC, 
		CONTENT_CHAPTER CCH
	WHERE 	
		C.CONTENT_STATUS = 1 AND
		C.STAGE_ID = -2 AND
        CCH.CHAPTER_ID <> 0 AND
        CC.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pda.language#"> AND
        <cfif isDefined('xml_rule_content_id') and xml_rule_content_id eq 0>
			CCH.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#xml_chapter_id#"> AND
			(
				C.EMPLOYEE_VIEW = 1 OR
				C.POSITION_CAT_IDS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="'%,#get_my_position_cat_user_group.position_cat_id#,%'">
				<cfif len(get_my_position_cat_user_group.USER_GROUP_ID)>
					OR C.USER_GROUP_IDS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="'%,#get_my_position_cat_user_group.user_group_id#,%'">
				</cfif>
			) AND
			((C.VIEW_DATE_START <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND C.VIEW_DATE_FINISH >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) OR (C.VIEW_DATE_START IS NULL AND C.VIEW_DATE_FINISH IS NULL)) AND
			CC.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#">) AND
        <cfelse>
        	CAST(C.CONT_POSITION AS CHAR(6)) LIKE '%1%' AND
        	C.EMPLOYEE_VIEW = 1 AND
        </cfif>
        <cfif isDefined('attributes.chapter_id') and len(attributes.chapter_id)>
        	CCH.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.chapter_id#"> AND
        </cfif>
        <cfif isDefined('attributes.contentcat_id') and len(attributes.contentcat_id)>
        	CC.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.contentcat_id#"> AND
        </cfif>  
		C.CHAPTER_ID = CCH.CHAPTER_ID AND
		CCH.CONTENTCAT_ID = CC.CONTENTCAT_ID AND
		CAST(C.CONT_POSITION AS CHAR(6)) LIKE '%1%'
	ORDER BY
		C.PRIORITY ASC,
		C.UPDATE_DATE DESC
</cfquery>
<cfquery name="GET_CONT_IMAGES" datasource="#DSN#">
	SELECT CONTENT_ID,IMAGE_SERVER_ID,CONTIMAGE_SMALL,IMAGE_SIZE,UPDATE_DATE FROM CONTENT_IMAGE
</cfquery>
<table style="width:100%">
	<tr>
		<td colspan="2" class="headbold"><cfoutput>#get_site_pages.object_name#</cfoutput></td>
	</tr>
    <tr>
		<cfif isDefined('xml_rule_content_id') and xml_rule_content_id eq 1>
    			<td style="width:15%; vertical-align:top;">
        	    		<cfsavecontent variable="kategori"><cf_get_lang_main no='725.Kategoriler'>/<cf_get_lang_main no='727.Bölümler'></cfsavecontent>
				<cfset attributes.is_home = 1>
        	        	<cfinclude template="../../rules/display/list_cat_chapter_home.cfm">
        		</td>
		</cfif>
    	<td style="vertical-align:top;">
        	<table>
				<cfif get_homepage_news.recordcount>
					<cfoutput query="get_homepage_news">
                        <tr>
                            <cfquery name="GET_CONT_IMAGE" dbtype="query" maxrows="1">
                                SELECT * FROM GET_CONT_IMAGES WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#content_id#"> AND IMAGE_SIZE = 0 ORDER BY UPDATE_DATE DESC
                            </cfquery>
                            <td style="width:60px;">
                                <cfif isdefined('get_cont_image') and len(get_cont_image.contimage_small)>
                                    <cf_get_server_file output_file="content/#get_cont_image.contimage_small#" output_server="#get_cont_image.image_server_id#" output_type="0" image_width="50" image_height ="50" image_link="1">
                                <cfelse>
                                    &nbsp;
                                </cfif>
                            </td>
                            <td class="infotag">
                                <a href="#request.self#?fuseaction=pda.detail_content&cid=#content_id#" style="font-weight:bold;">#cont_head#</a>
                                #cont_summary#
                            </td>
                        </tr>
					</cfoutput>
				<cfelse>
                    <tr>
                        <td colspan="2"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                    </tr>
                </cfif>
			</table>
		</td>
    </tr>        
</table>

