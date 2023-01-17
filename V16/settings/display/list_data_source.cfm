<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.type" default="">
<cfparam name="attributes.is_submit" default="1">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>

<cfset type_names = "#getLang('dictionary_id','Logo',58637)#,#getLang('dictionary_id','Mikro',62669)#,#getLang('dictionary_id','SAP Hana',62670)#,
                    #getLang('dictionary_id','Netsis',62671)#,#getLang('dictionary_id','Eta',62672)#,#getLang('dictionary_id','NetSuite',62673)#,
                    #getLang('dictionary_id','SAP Business One',62674)#,#getLang('dictionary_id','Workday',62671)#" />
<cfset drivers = {
    "MSSQLServer":"#getLang('dictionary_id','Microsoft SQL Server',62683)#",
    "MySQL5":"#getLang('dictionary_id','MySQL',62684)#",
    "Oracle":"#getLang('dictionary_id','Oracle',62685)#",
    "PostgreSQL":"#getLang('dictionary_id','PostgreSQL',62686)#"
} />

<cfset cmpDsn = createObject("component","V16.settings.cfc.data_source") />
<cfif isdefined("attributes.is_submit") and attributes.is_submit eq 1>
    <cfset get_dsn = cmpDsn.getDataSource(
        keyword : attributes.keyword,
        type : attributes.type
    ) />
<cfelse>
    <cfset get_dsn.recordcount = 0 />
</cfif>

<cfparam name="attributes.totalrecords" default="#get_dsn.recordcount#">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search" method="post" action="">
            <input type="hidden" name="is_submit" id="is_submit" value="1">
            <cf_box_search plus="0">
                <div class="form-group" id="form_ul_keyword">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
                    <cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#message#">
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
                    <a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#?fuseaction=settings.data_source&event=add</cfoutput>"><i class="fa fa-plus" title = "<cf_get_lang dictionary_id ='44630.Ekle'>" alt="<cf_get_lang dictionary_id ='44630.Ekle'>"></i></a>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('dictionary_id','Data Source',62668)#" uidrop="1" responsive_table="1">
        <cf_grid_list sort="1">
            <thead>
                <tr>
                    <th width="20"></th>
                    <th><cf_get_lang dictionary_id='32893.DSN'></th>
                    <th><cf_get_lang dictionary_id='52735.Type'></th>
                    <th><cf_get_lang dictionary_id='62676.Driver'></th>
                    <th><cf_get_lang dictionary_id='47987.IP'></th>
                    <th><cf_get_lang dictionary_id='54830.Port'></th>
                    <th width="20"><a href="<cfoutput>#request.self#?fuseaction=settings.data_source&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='44630.Ekle'>" alt="<cf_get_lang dictionary_id ='44630.Ekle'>"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_dsn.recordcount>
                    <cfoutput query="get_dsn" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#DATA_SOURCE_NAME#</td>
                            <td>#listGetAt(type_names,TYPE)#</td>
                            <td>#drivers[DRIVER]#</td>
                            <td>#IP#</td>
                            <td>#PORT#</td>
                            <td><a href="#request.self#?fuseaction=settings.data_source&event=upd&data_source_id=#DATA_SOURCE_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="7">
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
            <cfset adres="settings.data_source">
            <cfif len(attributes.is_submit)>
                <cfset adres = "#adres#&is_submit=#attributes.is_submit#">
            </cfif>
            <cfif len(attributes.keyword)>
                <cfset adres = "#adres#&keyword=#attributes.keyword#">
            </cfif>
            <cfif len(attributes.type)>
                <cfset adres = "#adres#&type=#attributes.type#">
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