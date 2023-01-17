<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.hschapter_no" default="">
<cfparam name="attributes.keyword" default="">

<cfset hscodes_cmp = createObject("component","V16.product.cfc.get_hscode")/>
		
<cfset get_hscode_chapters = hscodes_cmp.getHSCodeChapter()>
<cfset get_hscodes = hscodes_cmp.getHSCode(
    hschapter_no : '#iif(isdefined("attributes.hschapter_no"),"attributes.hschapter_no",DE(""))#',
    keyword : '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#'
)>

<cf_box title="GTİP - HS Code" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
        <cfform name="search" id="search" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search more="0">
                <div class="form-group col col-10 col-md-10 col-sm-9 col-xs-10">
                    <cfsavecontent variable="message1"><cf_get_lang dictionary_id='65351.Kod veya anahtar kelime girerek arayınız'></cfsavecontent>
                    <cfinput type="text" name="keyword" placeholder="#message1#" value="#attributes.keyword#" style="width = ">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
                </div>
            </cf_box_search>
        </cfform>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12" style="height:400px;">
            <cfform name="list_chapters" id="list_chapters" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
                <cf_flat_list uiscroll="0">
                    <thead>
                        <tr>
                            <th style="width: 5px;"><i class="fa fa-arrow-circle-right"></i></th>
                            <th><cf_get_lang dictionary_id='58139.Bölümler'></th>
                        </tr>
                    </thead>
                    <tbody>
                         <cfoutput query="get_hscode_chapters">
                            <tr>
                                <td>#currentrow#</td>
                                <td style="white-space: normal;">
                                    <a href="javascript://" onclick="selectChapters(#get_hscode_chapters.HSCHAPTER_NO#)">#get_hscode_chapters.HSCHAPTER_DETAIL#</a>
                                </td>
                            </tr>
                         </cfoutput>
                         <input type="hidden" name="hschapter_no" id="hschapter_no" value="<cfoutput>#attributes.hschapter_no#</cfoutput>">
                         <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                    </tbody>
                </cf_flat_list>
            </cfform>
        </div>
        
    </div>
    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
        <label class="col col-12 col-md-12 col-sm-12 col-xs-12" style="color : #E08283; font-size :20px; padding-top: 15px; margin-bottom: 7px;"><i class="fa fa-arrow-circle-right"></i> <b>GTİP - HS Codes</b></label>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <cf_flat_list uiscroll="0">
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58585.Kod'></th>
                        <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif get_hscodes.recordcount and isdefined('attributes.form_submitted') eq 1>
                    <cfoutput query="get_hscodes">
                        <tr>
                            <td><a href="javascript://" onclick="fill('#get_hscodes.HSCODE_#')">#get_hscodes.HSCODE_#</a></td>
                            <td style="white-space: normal;">#get_hscodes.HSCODE_DETAIL#</td>
                        </tr>
                    </cfoutput>
                    <cfelse>
                        <tr>
                            <td height="20" colspan="12"><cfif not isdefined('attributes.form_submitted')><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='49968.GTIP verileri girilmemiş. Manuel girebilir veya Workcube Data Servisi üzerinden veri alabilirsiniz.'></cfif></td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_flat_list>
        </div>
    </div>
</cf_box>

<script>
    function selectChapters(hschapter_no) {
        list_chapters.hschapter_no.value=hschapter_no;
        loadPopupBox('list_chapters' , <cfoutput>#attributes.modal_id#</cfoutput>);
    }
    function fill(id) {
        customs_recipe_code.value=id;
        closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
    }
</script>