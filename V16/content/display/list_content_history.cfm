<cfquery name="GET_CONTENT_HISTORY" datasource="#DSN#">
	SELECT
		C.CONTENT_PROPERTY_ID,
		C.CONT_HEAD,
		C.SPOT,
		C.CONT_SUMMARY,
		C.CONT_BODY,
		C.CONT_POSITION,
		C.CAREER_VIEW,
		C.IS_VIEWED,
		C.INTERNET_VIEW,
		C.EMPLOYEE_VIEW,
		C.CONTENT_STATUS,
		C.RECORD_MEMBER,
		C.RECORD_DATE,
		C.UPDATE_MEMBER,
		C.UPDATE_DATE,
		C.WRITE_VERSION,
		C.VERSION_DATE,
		C.CONTENT_HISTORY_ID,
		CC.CHAPTER,
		CA.CONTENTCAT,
		PTR.STAGE STAGE_NAME
	FROM
		CONTENT_HISTORY C
		LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = C.PROCESS_STAGE,
		CONTENT_CHAPTER CC,
		CONTENT_CAT CA
	WHERE
		CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.content_id#"> AND
		CA.CONTENTCAT_ID = CC.CONTENTCAT_ID AND
		CC.CHAPTER_ID = C.CHAPTER_ID
	ORDER BY
		C.UPDATE_DATE DESC
</cfquery>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id="57473.Tarihce"></cfsavecontent>
<cf_box title="#head#" closable="1" draggable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" collapsable="1"><!---Tarihçe--->
    <cfif get_content_history.recordcount>
        <cfoutput query="get_content_history"> 
            <cfif len(get_content_history.update_member)>
                <cfsavecontent variable="info_">#dateformat(update_date,dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,update_date),timeformat_style)#) - #get_emp_info(get_content_history.update_member,0,0,0)#</cfsavecontent>
            </cfif>
		    <cfsavecontent variable="info_">#dateformat(update_date,dateformat_style)# - #get_emp_info(get_content_history.update_member,0,0,0)#</cfsavecontent>
		    <cf_seperator id="number_#currentrow#" header="#info_#" is_closed="1">
            <div  id="number_#currentrow#" style="display:none;">
                <table>
                    <tr>
                        <td class="txtbold"><cf_get_lang dictionary_id='57486.Kategori'></td>
                        <td>#contentcat#</td>
                    </tr>
                    <tr>
                        <td class="txtbold"><cf_get_lang dictionary_id='57995.Bölüm'></td>
                        <td>#chapter#</td>
                    </tr>
                    <cfif len(get_content_history.content_property_id)>
                            <td class="txtbold"><cf_get_lang dictionary_id='57630.Tip'></td>
                            <cfquery name="GET_CONTENT_PROPERTY" datasource="#DSN#">
                                SELECT CONTENT_PROPERTY_ID, NAME FROM CONTENT_PROPERTY WHERE CONTENT_PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_content_history.content_property_id#">
                            </cfquery>
                            <td>#get_content_property.name#</td>
                    </cfif>
                    <tr>
                        <td class="txtbold"><cf_get_lang dictionary_id='58820.Başlık'></td>
                        <td>#cont_head#</td>
                    </tr>
                    <tr>
                        <td class="txtbold"><cf_get_lang dictionary_id='58052.Özet'></td>
                        <td>#cont_summary#</td>
                    </tr>
                    <tr>
                        <td class="txtbold" valign="top"><cf_get_lang dictionary_id='57653.İçerik'></td>
                        <td>#cont_body#</td>
                    </tr>
                    <tr>
                        <td class="txtbold"><cf_get_lang dictionary_id='50614.Yayın Alanı'></td>
                        <td>
                            <cfif cont_position contains 1> <cf_get_lang dictionary_id='50532.Anasayfa'>&nbsp;</cfif>
                            <cfif cont_position contains 2> <cf_get_lang dictionary_id='50533.Anasayfa Yan'>&nbsp;</cfif>
                            <cfif cont_position contains 3> <cf_get_lang dictionary_id='50534.Kategori Basi'>&nbsp;</cfif>
                            <cfif cont_position contains 4> <cf_get_lang dictionary_id='50535.Kategori Yani'>&nbsp;</cfif>
                            <cfif cont_position contains 5> <cf_get_lang dictionary_id='50536.Blm Basi'>&nbsp;</cfif>
                            <cfif cont_position contains 6> <cf_get_lang dictionary_id='50537.Blm Yani'>&nbsp;</cfif>
                        </td>
                    </tr>
                    <tr>
                        <td class="txtbold"><cf_get_lang dictionary_id='50560.Erişim Yetkisi'></td>
                        <td>
                            <cfif get_content_history.career_view eq 1> <cf_get_lang dictionary_id='33731.Kariyer Portal'>&nbsp;</cfif>
                            <cfif get_content_history.internet_view eq 1> <cf_get_lang dictionary_id='50612.Internet'>&nbsp;</cfif>
                            <cfif get_content_history.employee_view eq 1> <cf_get_lang dictionary_id='58875.Calisanlar'>&nbsp;</cfif>
                            <cfif get_content_history.spot eq 1> <cf_get_lang dictionary_id='32977.Spot'>&nbsp;</cfif>
                            <cfif get_content_history.is_viewed eq 1><cf_get_lang dictionary_id='50541.Anasayfada Duyur'>&nbsp;</cfif>
                        </td>
                    </tr>
                    <tr>
                        <td class="txtbold"><cf_get_lang dictionary_id='57756.Durum'></td>
                        <td><cfif get_content_history.content_status eq 1> <cf_get_lang dictionary_id='57493.Aktif'><cfelse> <cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                    </tr>
                    <tr>
                        <td class="txtbold"><cf_get_lang dictionary_id='57482.Aşama'></td>
                        <td>#get_content_history.stage_name#</td>
                    </tr>
                    <cfif len(write_version)>
                        <tr>
                            <td class="txtbold"><cf_get_lang dictionary_id='677.Revizyon No'>  #write_version#</td>
                            <td class="txtbold"><cf_get_lang dictionary_id='678.Revizyon Tarihi'>  #dateformat(version_date,dateformat_style)#</td>
                        </tr>
                    </cfif>
                </table>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12 ui-form-list-btn flex-end">
                    <div><a href="#request.self#?fuseaction=content.emptypopup_upd_content_history&cnth_id=#get_content_history.content_history_id#" class="ui-wrk-btn ui-wrk-btn-extra"><cf_get_lang dictionary_id='64142.Bu Kayda Geri Dön'></a></div>
                </div>
            </div>
        </cfoutput>
    <cfelse>
        <table>
            <tr>
                <td><cf_get_lang dictionary_id='57484.Kayit Yok'>!</td>
            </tr>
        </table>
    </cfif>
</cf_box>
