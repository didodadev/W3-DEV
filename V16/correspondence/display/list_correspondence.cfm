<cf_xml_page_edit fuseact ="correspondence.list_correspondence">
<cfif isdefined("attributes.form_submit")>
	<cfinclude template="../query/get_list_correspondence.cfm">
<cfelse>
	<cfset GET_LIST_CORRESPONDENCE.recordcount = 0>
</cfif>
<cfparam name="attributes.key" default="">
<cfparam name="attributes.corrcat_id" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#get_list_correspondence.recordcount#">
<cfquery name="get_cat" datasource="#DSN#">
	SELECT CORRCAT_ID, CORRCAT FROM SETUP_CORR ORDER BY CORRCAT
</cfquery>

<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%correspondence.list_correspondence%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=correspondence.list_correspondence" method="post" name="list_cor">
            <cf_box_search more="0">
                <input type="hidden" name="form_submit" id="form_submit" value="1" />
                <div class="form-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                        <cfinput type="text" name="key" style="width:100px;" value="#attributes.key#" maxlength="255" placeholder="#message#">
                </div>
                <div class="form-group">
                    <select name="is_active" id="is_active">
                        <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="1" <cfif isdefined("attributes.is_active") and attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0" <cfif isdefined("attributes.is_active") and attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                    </select>
                </div>
                <div class="form-group">
                    <select name="corrcat_id" id="corrcat_id">
                        <option value="0" selected><cf_get_lang dictionary_id="58640.Şablon"></option>
                        <cfoutput query="get_cat">
                            <option value="#CORRCAT_ID#"<cfif isdefined("attributes.CORRCAT_ID") and (attributes.CORRCAT_ID eq CORRCAT_ID)> selected</cfif>>#CORRCAT#</option> 
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <select name="process_stage" id="process_stage">
                        <option value=""><cfoutput>#getLang(322,'Süreç',58859)#</cfoutput></option>
                        <cfoutput query="GET_PROCESS_STAGE">
                            <option value="#process_row_id#"<cfif isdefined("attributes.process_stage") and (attributes.process_stage eq process_row_id)>selected</cfif> >#STAGE#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
                <div class="form-group"><cf_wrk_search_button button_type="4"></div>
                <div class="form-group"><a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.list_correspondence&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='57459.Yazışmalar'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_flat_list>
            <thead>
                <tr>    
                    <th style="width:30px;"><cf_get_lang dictionary_id='57487.No'></th>
                    <cfif is_show_document_no eq 1><th><cf_get_lang dictionary_id='57880.Belge No'></th></cfif>
                    <th><cf_get_lang dictionary_id='57480.Başlık'></th>
                    <th><cf_get_lang dictionary_id="58640.Şablon"></th>
                    <th><cf_get_lang dictionary_id='51070.Gönderen'></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <th><cf_get_lang dictionary_id='58859.Süreç'></th>
                    <th style="width:20px;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.list_correspondence&event=add"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_list_correspondence.recordcount>
                    <cfset category_list = ''>
                    <cfset correspondence_stage_list = "">
                    <cfset correspondence_id_list =''>
                    <cfoutput query="get_list_correspondence" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif len(category) and not listfind(category_list,category)>
                            <cfset category_list = listappend(category_list,get_list_correspondence.category)>
                        </cfif>
                        <cfif len(cor_stage) and not listfind(correspondence_stage_list,cor_stage)>
							<cfset correspondence_stage_list=listappend(correspondence_stage_list,cor_stage)>
						</cfif>
                        <cfif not listfind(correspondence_id_list,ID)>
                            <cfset correspondence_id_list=listappend(correspondence_id_list,ID)> 
                        </cfif>
                    </cfoutput>
                    <cfif len(correspondence_stage_list)>
						<cfset correspondence_stage_list=listsort(correspondence_stage_list,"numeric","ASC",",")>
						<cfquery name="get_stage" datasource="#dsn#">
							SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN(#correspondence_stage_list#) ORDER BY PROCESS_ROW_ID
						</cfquery>
					</cfif>
                    <cfif len(category_list)>
                        <cfset category_list = listsort(category_list,"numeric","ASC",",")>
                        <cfquery name="get_setup_corr" datasource="#dsn#">
                            SELECT CORRCAT FROM SETUP_CORR WHERE CORRCAT_ID IN (#category_list#) ORDER BY CORRCAT_ID
                        </cfquery>
                    </cfif>
                    <cfoutput query="get_list_correspondence" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                            <td>#currentrow#</td>
                            <cfif is_show_document_no eq 1><td width="75"><a href="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.upd_correspondence&id=#ID#" class="tableyazi">#correspondence_number#</a></td></cfif>
                            <td><a href="#request.self#?fuseaction=correspondence.list_correspondence&event=upd&id=#get_list_correspondence.id#"  class="tableyazi">#get_list_correspondence.subject#</a></td>
                            <td><cfif len(category)>#get_setup_corr.corrcat[listfind(category_list,category,',')]#</cfif></td>
                            <td>#employee_name#&nbsp;#employee_surname#</td>
                            <td>#dateformat(get_list_correspondence.record_date,dateformat_style)#</td>
                            <td><cfif len(cor_stage)>#get_stage.stage[listfind(correspondence_stage_list,cor_stage,',')]#</cfif></td>
                            <td><a href="#request.self#?fuseaction=correspondence.list_correspondence&event=upd&id=#get_list_correspondence.id#" class="tableyazi"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr class="color-row">
                        <td colspan="6"><cfif isdefined("attributes.form_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cfset url_str = "">
            <cfif isdefined("attributes.is_active")>
                <cfset url_str = "&is_active=#attributes.is_active#">
            </cfif>
            <cfif isdefined("attributes.form_submit")>
                <cfset url_str = "&form_submit=#attributes.form_submit#">
            </cfif>
            <cfif len(attributes.process_stage) and len(attributes.process_stage)>
                <cfset url_str="#url_str#&process_stage=#attributes.process_stage#">
            </cfif>
            <cf_paging page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="correspondence.list_correspondence&key=#attributes.key#&corrcat_id=#attributes.corrcat_id##url_str#"> 
        </cfif>
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('key').focus();
</script>
