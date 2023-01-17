<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.status" default="">
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT
		BRANCH_ID, 
		BRANCH_NAME 
	FROM 
		BRANCH
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_pos_equipment.cfm">
<cfelse>
	<cfset get_pos_equipment.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_pos_equipment.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="list_pos_equipment" method="post" action="#request.self#?fuseaction=finance.list_pos_equipment">
            <input type="hidden" name="form_submitted" id="form_submitted" value="">
            <cf_box_search  more="0"> 
                <div class="form-group">
                    <div class="input-group">
                        <cfinput type="text" name="keyword" placeholder="#getLang('main',48)#" value="#attributes.keyword#" maxlength="50">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <select name="branch_id" id="branch_id">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="get_branch">
                                <option value="#branch_id#"<cfif attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <select name="status" id="status">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function=''>
                </div>
                <div class="form-group">					
                    <a class="ui-btn ui-btn-blue" href="<cfoutput>#request.self#</cfoutput>?fuseaction=finance.list_pos_equipment&event=det"><i class="catalyst-grid" ></i></a>
                </div>
                <div class="form-group">
                    <a class="ui-btn ui-btn-gray" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=finance.list_pos_equipment&event=add');"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='54592.Yazar Kasalar'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="20"><cf_get_lang dictionary_id="58577.Sıra"></th>
                    <th><cf_get_lang dictionary_id='54576.Cihaz'></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id='59088.Tip'></th>
                    <th><cf_get_lang dictionary_id='57756.Durum'></th>						
                    <th><cf_get_lang dictionary_id='57483.Kayıt'></th>
                    <th width="20"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=finance.list_pos_equipment&event=add');"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_pos_equipment.recordcount>
                    <cfset branch_id_list=''>
                    <cfoutput query="get_pos_equipment" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                        <cfif len(branch_id) and not listfind(branch_id_list,branch_id)>
                            <cfset branch_id_list=listappend(branch_id_list,branch_id)>
                        </cfif>
                    </cfoutput>
                    <cfif len(branch_id_list)>
                        <cfset branch_id_list=listsort(branch_id_list,"numeric","ASC",",")>
                        <cfquery name="get_branch_detail" datasource="#dsn#">
                            SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE BRANCH_ID IN (#branch_id_list#) ORDER BY BRANCH_ID
                        </cfquery>
                    </cfif>			
                    <cfoutput query="get_pos_equipment" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                        <cfif get_pos_equipment.type eq 1>
                            <cfset type_ = "#getLang('','WHOPS',62481)#">
                        <cfelseif get_pos_equipment.type eq 2>
                            <cfset type_ = "#getLang('','NCR',36997)#">
                        <cfelseif get_pos_equipment.type eq 3>
                            <cfset type_ = "#getLang('','Toshiba',36609)#">
                        <cfelseif get_pos_equipment.type eq 4>
                            <cfset type_ = "#getLang('','Diebold Nixdorf',35294)#">
                        <cfelse>
                            <cfset type_ = "">
                        </cfif>
                        <tr>
                            <td>#currentrow#</td>
                            <td>#equipment#</td>
                            <td><cfif len(branch_id)>#get_branch_detail.branch_name[listfind(branch_id_list,branch_id,',')]#</cfif></td>
                            <td>#type_#</td>
                            <td><cfif is_status><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                            <td>#dateformat(record_date,dateformat_style)#&nbsp;#timeformat(date_add("h",session.ep.time_zone,record_date),timeformat_style)#</td>
                            <!-- sil --><td width="20"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=finance.list_pos_equipment&event=upd&pos_id=#pos_id#');"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>" border="0"></a></td><!-- sil -->
                        </tr>
                    </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="9"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
                        </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfset adres="finance.list_pos_equipment">
        <cfif isdefined("attributes.form_submitted")>
            <cfset adres = "#adres#&form_submitted=#attributes.form_submitted#">
        </cfif>			
        <cfif len(attributes.keyword)>
            <cfset adres = "#adres#&keyword=#attributes.keyword#">
        </cfif>
        <cfif len(attributes.branch_id)>
            <cfset adres = "#adres#&branch_id=#attributes.branch_id#">
        </cfif>
        <cfif len(attributes.status)>
            <cfset adres = "#adres#&status=#attributes.status#">
        </cfif>			
        <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="#adres#">
    </cf_box>
</div>


<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
