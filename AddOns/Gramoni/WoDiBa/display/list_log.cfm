<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.wodiba_bank_actions&event=logs">
<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
    <cfset adres = '#adres#&keyword=#attributes.keyword#'>
</cfif>
<cfparam name="attributes.keyword" default=""/>
<cfparam name="attributes.page" default=1 />
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'/>
<cfparam name="attributes.startrow" default=1 />
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#' />
<cfif isDefined("attributes.form_submitted")>
    <cfquery name="get_log" datasource="#dsn#">
        SELECT * FROM WODIBA_LOGS WHERE WDB_ACTION_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
    </cfquery>
    <cfscript>
        attributes.totalrecords  = get_log.RecordCount;
        attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
        attributes.endrow = attributes.startrow + attributes.maxrows - 1;
        if(attributes.totalrecords lt attributes.endrow){
            attributes.endrow = attributes.totalrecords;
        }
    </cfscript>
<cfelse>
    <cfset attributes.totalrecords  = 0 />
</cfif>
<cfform name="wodiba_logs"action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.wodiba_bank_actions&event=logs" method="post">
    <input name="form_submitted" type="hidden" value="1" />
    <cf_box>
		<cf_box_search>
            <div class="row">
                <div class="col col-12 form-inline">
                    <div class="form-group">
                        <div class="input-group x-15">
                            <cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('main',48)#" onclick="select();">
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-group x-4_5">
                            <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-group">
                               <cf_wrk_search_button>
                        </div>
                    </div>
                </div>
            </div>
        </cf_box_search>
    </cf_box>
</cfform>
    <cfsavecontent variable="wodiba_log"><cf_get_lang dictionary_id='59355.WoDiBa'><cf_get_lang dictionary_id='61330.Log Records'></cfsavecontent>
        <cf_box title="#wodiba_log#" uidrop="1" hide_table_column="1" woc_setting = "#{ checkbox_name : 'print_hr_id', print_type : 173 }#">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th align="left"><cf_get_lang dictionary_id='57543.Message'></th>
                        <th><cf_get_lang dictionary_id='31901.Details'></th>
                        <th><cf_get_lang dictionary_id='61329.Log Type'></th>
                        <th><cf_get_lang dictionary_id='58527.ID'></th>
                        <th><cf_get_lang dictionary_id='57627.Record Date'></th>
                    </tr>
                </thead>
                <cfif isDefined("attributes.form_submitted") And get_log.RecordCount>
                    <tbody>
                        <cfloop query="get_log" startrow="#attributes.startrow#" endrow="#attributes.endrow#">
                            <cfoutput>
                                <tr>
                                    <td>#get_log.MESSAGE#</td>
                                    <td align="middle">#get_log.DETAILS#</td>
                                    <td align="middle">#get_log.LOG_TYPE#</td>
                                    <td align="middle">#get_log.WDB_ACTION_ID#</td>
                                    <td align="middle">#dateFormat('#get_log.REC_DATE#',"dd.mm.yyyy- HH:DD")#</td>
                                </tr>
                            </cfoutput>
                        </cfloop>
                    </tbody>
                </cfif>
            </cf_grid_list>
            <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#adres#">
        </cf_box>
