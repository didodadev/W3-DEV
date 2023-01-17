<cfset api_key = "201118kSm20">
<cfhttp url="https://networg.workcube.com/web_services/webserviceforrelease.cfc?method=GET_UPGRADE_NOTES" result="response" charset="utf-8">
    <cfhttpparam name="api_key" type="formfield" value="#api_key#">
    <cfhttpparam name="session_ep_language" type="formfield" value="#session_base.language#">
    <cfhttpparam name="record_number" type="formfield" value="2">
</cfhttp>

<div class="list_item_note">
    <div class="list_item_note_header">
        <cf_get_lang dictionary_id='43887.Release Notes'>
    </div>
    <cfif response.Statuscode eq '200 OK'>
        <cfset releaseNotes = DeserializeJSON( Replace(response.filecontent,"//","") )>
        <cfif releaseNotes.RECORDCNT>
            <div class="list_item_note_contents">
                <ul>
                    <cfloop index="i" from="1" to="#releaseNotes.RECORDCNT#">
                        <cfoutput>
                            <li>
                                <div class="info span-color-2 mb-2 p-2">
                                    #releaseNotes.RELEASE[i].RELEASE# - #dateFormat(releaseNotes.RELEASE[i].NOTE_DATE, dateformat_style)#
                                </div>
                                <cfset releaseRows = releaseNotes.RELEASE[i].RELEASE_ROWS />
                                <cfif ArrayLen( releaseRows )>
                                    <cfloop index="j" from="1" to="#ArrayLen( releaseRows )#">
                                        <div class="list_item_note_content mb-2">
                                            <div class="info #releaseRows[j].NOTE_ROW_TYPE eq 'Feature' ? 'span-color-3' : 'span-color-6'# p-2">#releaseRows[j].NOTE_ROW_TYPE#</div>
                                            <b>#releaseRows[j].NOTE_ROW_TITLE#</b>
                                            <p class="mt-2">#REReplaceNoCase(releaseRows[j].NOTE_ROW_DETAIL, '<[^[:space:]][^>]*>', '', 'ALL')#</p>
                                        </div>
                                    </cfloop>
                                </cfif>
                            </li>
                        </cfoutput>
                    </cfloop>
                </ul>
            </div>
        </cfif>
    </cfif>
</div>