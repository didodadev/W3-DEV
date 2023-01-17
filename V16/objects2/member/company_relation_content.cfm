<!--- <cfif not isDefined("attributes.company_id")>
    <cfif isDefined("session.pp")>
        <cfset attributes.company_id = session.pp.company_id>
    <cfelseif isDefined("session.ww")>
        <cfset attributes.company_id = session.ww.company_id>
    </cfif>
</cfif>
<cfquery name="GET_CONTENT_COMPANY" datasource="#DSN#">
    SELECT
        C.CONTENT_ID,
        C.CONT_HEAD,
        C.CONT_BODY,
        C.CONT_SUMMARY, 
        C.RECORD_MEMBER,
        C.UPDATE_MEMBER,
        C.USER_FRIENDLY_URL,
        C.HIT,
        C.HIT_PARTNER,
        C.IS_DSP_HEADER,
        C.IS_DSP_SUMMARY,
        C.OUTHOR_EMP_ID,
        C.OUTHOR_CONS_ID,
        C.OUTHOR_PAR_ID,
        C.WRITING_DATE
    FROM
        CONTENT C,
        CONTENT_RELATION CR
    WHERE 
        CR.ACTION_TYPE= 'COMPANY_ID' AND
        CR.CONTENT_ID = C.CONTENT_ID AND
        C.STAGE_ID = -2  AND
        CR.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
    ORDER BY
        C.CONTENT_ID DESC
</cfquery>

<cfif get_content_company.recordcount>
    <!--- <cfif isdefined("attributes.is_cont_comp_view_type") and attributes.is_cont_comp_view_type eq 0> --->
        <cfoutput query="get_content_company">
            <div class="row mb-3">
                <div class="col-md-12">
                    <cf_box title="#cont_head#">
                        <p>#cont_summary#<br/></p>
                        <p>#cont_body#</p>
                    </cf_box>
                </div>
            </div>
            <!--- <table width="100%" align="center">
                <tr>
                    <td>
                        <cfif get_content_company.is_dsp_header eq 0>
                            <span class="headbold">#cont_head#</span><br/><br/>
                        </cfif>
                        <cfif get_content_company.is_dsp_summary eq 0>
                            #cont_summary#<br/><br/>
                        </cfif>
                        <a href="#url_friendly_request('objects2.detail_content&cid=#content_id#','#USER_FRIENDLY_URL#')#">>>devam</a>
                    </td>
                </tr>
                <tr>
                    <td><br/></td>
                </tr>
            </table> --->
        </cfoutput>
    <!--- <cfelse>
        <cfoutput query="get_content_company">
            <table width="100%" align="center">
                <tr>
                    <td>
                        <cfif get_content_company.is_dsp_header eq 0>
                            <span class="headbold">#cont_head#</span><br/><br/>
                        </cfif>
                        <cfif get_content_company.is_dsp_summary eq 0>
                            #cont_summary#<br/><br/>
                        </cfif>
                        #cont_body#
                    </td>
                </tr>
                <tr>
                    <cfif isdefined('attributes.is_cont_comp_webmail') and attributes.is_cont_comp_webmail eq 1>
                        <td valign="top"><cfinclude template="../content/content_webmail.cfm"></td>
                    </cfif>
                    <cfif isdefined('attributes.is_cont_comp_print') and attributes.is_cont_comp_print eq 1>
                        <td  valign="top" style="text-align:right;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_operate_page&operation=emptypopup_temp_detail_content&action=print&id=#GET_CONTENT_COMPANY.CONTENT_ID#&module=objects2','page');return false;" class="headerprint"><cf_get_lang_main no='62.Yazdir'></a></td>
                    </cfif>
                </tr>
                <tr>
                    <td><br/></td>
                </tr>
            </table>
        </cfoutput>
    </cfif> --->
<cfelse>
    <div class="row mb-3">
        <div class="col-md-12">
            <h6 class="float-left"><cf_get_lang dictionary_id="57484.Kayıt yok">!</h6>
        </div>
    </div>
</cfif> --->


<cfquery name="GET_CONTENT_COMPANY" datasource="#DSN#">
    SELECT
    C.CONTENT_ID,
    C.CONT_HEAD,
    C.CONT_BODY,
    C.CONT_SUMMARY, 
    C.RECORD_MEMBER,
    C.UPDATE_MEMBER,   
    C.HIT,
    C.HIT_PARTNER,
    C.IS_DSP_HEADER,
    C.IS_DSP_SUMMARY,
    C.OUTHOR_EMP_ID,
    C.OUTHOR_CONS_ID,
    C.OUTHOR_PAR_ID,
    C.WRITING_DATE,
    UFU.USER_FRIENDLY_URL
FROM
    CONTENT AS C
    OUTER APPLY(
        SELECT TOP 1 UFU.USER_FRIENDLY_URL 
        FROM #dsn#.USER_FRIENDLY_URLS UFU 
        WHERE UFU.ACTION_TYPE = 'cntid' 
        AND UFU.ACTION_ID = c.CONTENT_ID 		
        AND UFU.PROTEIN_SITE = #GET_PAGE.PROTEIN_SITE#) UFU        
WHERE
    C.STAGE_ID = -2 AND  
    C.CONTENT_STATUS = 1 AND
    C.OUTHOR_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#member_id#">     
ORDER BY
    C.CONTENT_ID DESC
</cfquery>

<cfif get_content_company.recordcount>
    <cfif isdefined("attributes.is_cont_comp_view_type") and attributes.is_cont_comp_view_type eq 0>
        <div class="list_chapter-type2">
            <cfoutput query="get_content_company">
                <div class="list_chapter_item-type2" style="background-color:rgba(253,57,122,.1);"> 	
                    <cfif get_content_company.is_dsp_summary eq 0>
                        <div class="list_chapter_item-type2_text">
                            <cfif get_content_company.is_dsp_header eq 0>
                                <div class="list_chapter_item-type2_title">
                                    #cont_head#
                                </div>											
                            </cfif>
                            <p>#cont_summary#</p> 
                            <cfif isDefined("attributes.content_detail_page_btn") and attributes.content_detail_page_btn eq 1>
                                <div class="list_chapter_item-type2_btn">
                                    <a href="#USER_FRIENDLY_URL#"><cf_get_lang dictionary_id='47032.More'></a>
                                </div>
                            </cfif>
                        </div>
                    </cfif>
                </div>
            </cfoutput>
        </div>
    <cfelse>
        <div class="list_chapter-type2">
            <cfoutput query="get_content_company">
                <div class="list_chapter_item-type2" style="background-color:rgba(253,57,122,.1);">
                    <cfif get_content_company.is_dsp_summary eq 0>
                        <div class="list_chapter_item-type2_text">
                            <cfif get_content_company.is_dsp_header eq 0>
                                <div class="list_chapter_item-type2_title">
                                    #cont_head#
                                </div>											
                            </cfif> 
                            <p>#cont_summary#</p>
                            <cfif isDefined("attributes.content_detail_page_btn") and attributes.content_detail_page_btn eq 1>
                                <div class="list_chapter_item-type2_btn">
                                    <a href="#USER_FRIENDLY_URL#"><cf_get_lang dictionary_id='47032.More'></a>
                                </div>
                            </cfif>
                        </div>
                    </cfif>
                    <!--- <cfif isdefined('attributes.is_cont_comp_webmail') and attributes.is_cont_comp_webmail eq 1>
                        <td valign="top"><cfinclude template="../content/content_webmail.cfm"></td>
                    </cfif>
                    <cfif isdefined('attributes.is_cont_comp_print') and attributes.is_cont_comp_print eq 1>
                        <td  valign="top" style="text-align:right;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_operate_page&operation=emptypopup_temp_detail_content&action=print&id=#GET_CONTENT_COMPANY.CONTENT_ID#&module=objects2','page');return false;" class="headerprint"><cf_get_lang_main no='62.Yazdir'></a></td>
                    </cfif> --->
                </div>
            </cfoutput>
        </div>
    </cfif>
</cfif>
