<cfset api_key = "201118kSm20">
<cfhttp url="https://networg.workcube.com/web_services/webserviceforrelease.cfc?method=GET_UPGRADE_NOTES" result="response" charset="utf-8">
    <cfhttpparam name="api_key" type="formfield" value="#api_key#">
    <cfhttpparam name="session_ep_language" type="formfield" value="#session_base.language#">
    <cfhttpparam name="record_number" type="formfield" value="2">
</cfhttp>
<style>
.list_item_note .info {
    display: inline-block;
    padding: 0.25em 0.4em;
    font-size: 75%;
    font-weight: 700;
    line-height: 1;
    text-align: center;
    white-space: nowrap;
    vertical-align: baseline;
    border-radius: 0.25rem;
    transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
}
.span-color-3 {
    background-color: #b0e19c;
    color: white;
}
.span-color-2 {
    background-color: #0058ff;
    color: white;
}
.span-color-6 {
    background-color: #faa61c;
    color: #fff799;
}
.list_item_note ul {
    margin: 0;
    padding: 0;
    list-style: none;
}
.list_item_note .list_item_note_content {
    /* Categori detail sayfasndaki font- size ve color kullanıldı. Standart olması için */
    font-size: 1rem;
    color: #6c757d;
}
.list_item_note_content {
    width:90%
}
</style>

<div class="list_item_note">
    <div class="row mt-1 mt-sm-1 mt-md-1 mt-lg-2">
        <div class="col-12 px-0">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb bg-transparent">
                    <li itemprop="itemListElement" class="breadcrumb-item">
                        <a itemprop="item" href="/welcome">
                            <span itemprop="name"><cf_get_lang dictionary_id='40794.Anasayfa'></span>
                        </a>
                        <meta itemprop="position" content="1">
                    </li>
                    <li itemprop="itemListElement" class="breadcrumb-item">
                        <a itemprop="item" href="/welcome">
                            <span itemprop="name"><cf_get_lang dictionary_id='57697.Kütüphane'></span>
                        </a>
                        <meta itemprop="position" content="2">
                    </li>
                    <li itemprop="itemListElement" itemscope="" itemtype="http://schema.org/ListItem" class="breadcrumb-item active">
                        <span itemprop="item">
                            <span itemprop="name"><cf_get_lang dictionary_id='48837.Sürüm Notları'></span>
                        </span>
                        <meta itemprop="position" content="3">
                    </li>
                </ol>
            </nav>
        </div>
    </div>
    <cfif response.Statuscode eq '200 OK'>
        <cfset releaseNotes = DeserializeJSON( Replace(response.filecontent,"//","") )>
        <cfif releaseNotes.RECORDCNT>
            <div class="row mt-1 mt-sm-1 mt-md-1 mt-lg-2">
                <div class="list_item_note_contents">
                    <ul>
                        <cfloop index="i" from="1" to="#releaseNotes.RECORDCNT#">
                            <cfoutput>
                                <li>
                                    <div class="info span-color-2 mb-3 p-3">
                                        #releaseNotes.RELEASE[i].RELEASE# - #dateFormat(releaseNotes.RELEASE[i].NOTE_DATE, dateformat_style)#
                                    </div>
                                    <cfset releaseRows = releaseNotes.RELEASE[i].RELEASE_ROWS />
                                    <cfif ArrayLen( releaseRows )>
                                        <cfloop index="j" from="1" to="#ArrayLen( releaseRows )#">
                                            <div class="list_item_note_content mb-2">
                                                <div class="info #releaseRows[j].NOTE_ROW_TYPE eq 'Feature' ? 'span-color-3' : 'span-color-6'# p-2">#releaseRows[j].NOTE_ROW_TYPE#</div>
                                                <b>#releaseRows[j].NOTE_ROW_TITLE#</b>
                                                <p class="mt-2 text-justify">#REReplaceNoCase(releaseRows[j].NOTE_ROW_DETAIL, '<[^[:space:]][^>]*>', '', 'ALL')#</p>
                                            </div>
                                        </cfloop>
                                    </cfif>
                                </li>
                            </cfoutput>
                        </cfloop>
                    </ul>
                </div>
            </div>
        </cfif>
    </cfif>
</div>