
 <!--- <cfif isdefined("attributes.licence")> --->
    <cfset GET_USER_LICENCE_RESULT(userId:session.ep.userid)/>
    <cfquery name="GET_LICENCE_INFO" datasource="#dsn#">
        SELECT
            TEMPLATE_CONTENT
        FROM
            TEMPLATE_FORMS
        WHERE
            IS_LICENCE = 1
    </cfquery>
    <div class="col-12 col-md-12 col-xs-12" >
        <cf_box title="#getLang('','Kullanım ve Gizlilik Kuralları',64854)#" scroll="1"  collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
            <cffile action="read" file="#download_folder#licence.txt" variable="dosya" charset="utf-8">
            <div class="ui-scroll">
                <div class="col col-12 " style="padding-left:15px;padding-right:22px;">
                    <cfoutput>
                        #replace(dosya, Chr(13) & Chr(10),'</br>', 'all')#
                        #GET_LICENCE_INFO.TEMPLATE_CONTENT#
                    </cfoutput>
                </div>
            </div>
            <cf_box_footer>
                <cfif GET_USER_LICENCE_RESULT.RECORDCOUNT>
                    <a href="javascript://" style="float:right;color:red!important;padding-left:15px;" ><cf_get_lang dictionary_id='64854.?'> <cf_get_lang dictionary_id='58699.Onaylandı'></a>
                <cfelse>  
                    <button type="button" class="ui-ripple-btn" id="licenceSaveButton" onclick="licenceStatus(1,<cfoutput>#session.ep.userid#</cfoutput>)" ><cfoutput>#getlang(49,'Kabul Ediyorum',64856)#</cfoutput></button>
                    <a href="javascript://" class="ui-ripple-btn" onclick="close_dsp()"><cfoutput>#getlang(49,'Vazgeç',57462)#</cfoutput></a>
                </cfif>  
            
            </cf_box_footer>
        </cf_box>
    </div>
    <script>
    function close_dsp(){
        closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','dsp_kural' );
                
    }
        
    </script>
<!--- <cfelse>
	<cfif isdefined("attributes.is_kural_popup")>
        <cfquery name="UPD_MY_SETT_" datasource="#DSN#">
            UPDATE MY_SETTINGS SET IS_KURAL_POPUP = 0 WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
        </cfquery>
        <script type="text/javascript">
            $(".modal-backdrop").trigger('click');
        </script>
        <cfabort>
    </cfif>
    <cfquery name="GET_RULE_POP_CONT" datasource="#DSN#">
        SELECT
            VIEW_DATE_START,
            VIEW_DATE_FINISH,
            CONT_HEAD,
            CONT_BODY,
            CONT_SUMMARY,
            CONTENT_ID,
            IS_DSP_HEADER,
            IS_DSP_SUMMARY,
            PRIORITY
        FROM
            CONTENT
        WHERE
            IS_RULE_POPUP = 1 AND
            CONTENT_STATUS = 1 AND
            VIEW_DATE_START < #now()# AND
            VIEW_DATE_FINISH > #dateadd('d',-1,now())# 
        ORDER BY
            PRIORITY ASC   
    </cfquery>
    <table cellspacing="3" cellpadding="3" style="width:100%; height:100%">
        <cfif get_rule_pop_cont.recordcount>
            <cfoutput query="get_rule_pop_cont">
            <tr>
                <td style="vertical-align:top;"><!---<cfinclude template="../../dsp_kural.htm">--->
                    <cfif is_dsp_header eq 0>
                        <h1 class="conthead">#cont_head#</h1><br/>
                    </cfif>
                    <cfif is_dsp_summary eq 0>
                        #cont_summary#<br/>
                    </cfif>
                    #cont_body#
                </td>
            </tr>
            </cfoutput>
        </cfif>
        <tr class="color-list" style="height:30px;">
            <td><form name="formKuralPopup" action="" method="post"><input type="checkbox" value="1" name="is_kural_popup" id="is_kural_popup" onClick="pageSave();"><cf_get_lang dictionary_id='30825.Bu sayfayı bir daha gösterme'></form></td>
        </tr>
    </table>
    <div id="kuralPop"></div>
    
    <cfoutput>
    <script type="text/javascript">
    function pageSave()
    {
        AjaxPageLoad('#request.self#?fuseaction=myhome.popup_dsp_kural&is_kural_popup=1','kuralPop');
        return false;
    }
    </script>
    </cfoutput>
</cfif>
 --->