<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.type" default="">
<cfparam name="attributes.import_wo" default="">
<cfparam name="attributes.is_submit" default="1">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>

<cfset type_names = "#getLang('dictionary_id','Logo',58637)#,#getLang('dictionary_id','Mikro',62669)#,#getLang('dictionary_id','SAP Hana',62670)#,
                    #getLang('dictionary_id','Netsis',62671)#,#getLang('dictionary_id','Eta',62672)#,#getLang('dictionary_id','NetSuite',62673)#,
                    #getLang('dictionary_id','SAP Business One',62674)#,#getLang('dictionary_id','Workday',62671)#" />

<cfset cmpLibrary = createObject("component","WDO.development.cfc.data_import_library") />
<cfif isdefined("attributes.is_submit") and attributes.is_submit eq 1>
    <cfset getData = cmpLibrary.getData(
        keyword : attributes.keyword,
        type : attributes.type,
        import_wo : attributes.import_wo
    ) />
<cfelse>
    <cfset getData.recordcount = 0 />
</cfif>

<cfparam name="attributes.totalrecords" default="#getData.recordcount#">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search" method="post" action="">
            <input type="hidden" name="is_submit" id="is_submit" value="1">
            <cf_box_search plus="0">
                <div class="form-group" id="form_ul_keyword">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
                    <cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#message#">
                </div>
                <div class="form-group" id="form_ul_wo">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="52734.WO"></cfsavecontent>
                    <cfinput type="text" name="import_wo" value="#attributes.import_wo#" maxlength="255" placeholder="#message#">
                </div>
                <div class="form-group" id="form_ul_type">
                    <select name="type" id="type">
                        <option value=""><cf_get_lang dictionary_id='52735.Type'></option>
                        <option value="1" <cfif attributes.type eq 1>selected</cfif>><cf_get_lang dictionary_id='58637.Logo'></option>
                        <option value="2" <cfif attributes.type eq 2>selected</cfif>><cf_get_lang dictionary_id='62669.Mikro'></option>
                        <option value="3" <cfif attributes.type eq 3>selected</cfif>><cf_get_lang dictionary_id='62670.SAP Hana'></option>
                        <option value="4" <cfif attributes.type eq 4>selected</cfif>><cf_get_lang dictionary_id='62671.Netsis'></option>
                        <option value="5" <cfif attributes.type eq 4>selected</cfif>><cf_get_lang dictionary_id='62672.Eta'></option>
                        <option value="6" <cfif attributes.type eq 4>selected</cfif>><cf_get_lang dictionary_id='62673.NetSuite'></option>
                        <option value="7" <cfif attributes.type eq 4>selected</cfif>><cf_get_lang dictionary_id='62674.SAP Business One'></option>
                        <option value="8" <cfif attributes.type eq 4>selected</cfif>><cf_get_lang dictionary_id='62671.Workday'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,1250" required="yes" message="#message#">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
                <div class="form-group">
                    <a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#?fuseaction=dev.data_import_library&event=add</cfoutput>"><i class="fa fa-plus" title = "<cf_get_lang dictionary_id ='44630.Ekle'>" alt="<cf_get_lang dictionary_id ='44630.Ekle'>"></i></a>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('dictionary_id','Data İmport Library',62732)#" uidrop="1" responsive_table="1">
        <cf_grid_list sort="1">
            <thead>
                <tr>
                    <th width="20"></th>
                    <th><cf_get_lang dictionary_id='61332.Name'></th>
                    <th><cf_get_lang dictionary_id="52734.WO"></th>
                    <th><cf_get_lang dictionary_id='52735.Type'></th>
                    <th><cf_get_lang dictionary_id='52783.Author'></th>
                    <th><cf_get_lang dictionary_id='49955.File Path'></th>
                    <th><cf_get_lang dictionary_id='57742.Date'></th>
                    <th width="20"><a href="<cfoutput>#request.self#?fuseaction=dev.data_import_library&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='44630.Ekle'>" alt="<cf_get_lang dictionary_id ='44630.Ekle'>"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif getData.recordcount>
                    <cfoutput query="getData" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#NAME#</td>
                            <td>#IMPORT_WO#</td>
                            <td>#listGetAt(type_names,TYPE)#</td>
                            <td>#AUTHOR#</td>
                            <td>#FILE_PATH#</td>
                            <td>#dateFormat(RECORD_DATE, dateformat_style)#</td>
                            <td><a href="#request.self#?fuseaction=dev.data_import_library&event=upd&data_import_id=#DATA_IMPORT_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="8">
                            <cfif isDefined("attributes.is_submit") and attributes.is_submit eq 1>
                                <cf_get_lang dictionary_id ="57484.Kayıt Yok">!
                            <cfelse>
                                <cf_get_lang dictionary_id ="57701.Filtre Ediniz">!
                            </cfif>
                        </td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif attributes.totalrecords gt attributes.maxrows>    
            <cfset adres="dev.data_import_library">
            <cfif len(attributes.is_submit)>
                <cfset adres = "#adres#&is_submit=#attributes.is_submit#">
            </cfif>
            <cfif len(attributes.keyword)>
                <cfset adres = "#adres#&keyword=#attributes.keyword#">
            </cfif>
            <cfif len(attributes.type)>
                <cfset adres = "#adres#&type=#attributes.type#">
            </cfif>
            <cfif len(attributes.import_wo)>
                <cfset adres = "#adres#&import_wo=#attributes.import_wo#">
            </cfif>
            <cf_paging 
                page="#attributes.page#" 
                maxrows="#attributes.maxrows#" 
                totalrecords="#attributes.totalrecords#" 
                startrow="#attributes.startrow#" 
                adres="#adres#">
        </cfif>
    </cf_box>
</div>