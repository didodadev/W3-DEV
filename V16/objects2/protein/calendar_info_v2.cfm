<cfset opportunitiesCFC = createObject('component','V16.objects2.protein.data.opportunities_data')>
<cfset GET_RELATED_EVENTS = opportunitiesCFC.GET_RELATED_EVENTS(action_section:"OPPORTUNITY_ID", action_id:attributes.opp_id)>
<cfsavecontent  variable="title"><cf_get_lang dictionary_id='57937.Takvim Bilgileri'></cfsavecontent>
<div id="agenda_list">
    <cfif get_related_events.recordcount>
        <cfoutput query="get_related_events">
            <div class="row mb-2">
                <div class="col-md-12">
                    <div class="d-flex bd-highlight flex-wrap px-2 py-2" onmouseover="this.style.background='##eaeaec7a';" onmouseout="this.style.background='';">
                        <div class="pr-2 flex-grow-1 bd-highlight"><a class="none-decoration"  href="#site_language_path#/eventDetail?event_id=#event_id#&action_id=#attributes.opp_id#&action_section=OPPORTUNITY_ID" target="_blank">#event_head#</a></div>
                        <div class="pr-4 bd-highlight">#DateFormat(startdate,dateformat_style)#</div>
                        <div class="bd-highlight"><cfif len(eventcat)>#eventcat#</cfif></div>
                    </div>              
                </div>
            </div>
        </cfoutput>
    <cfelse>
        <cfoutput>
            <div class="row mb-2">
                <div class="col-md-12">
                    <div class="d-flex bd-highlight flex-wrap">
                        <div class="pr-2 pb-2 flex-grow-1 bd-highlight"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</div>
                    </div>              
                </div>
            </div>
        </cfoutput>
    </cfif>
</div>
<script>
    <cfsavecontent  variable="title"><cf_get_lang dictionary_id='63210.Add Event to Calendar'></cfsavecontent>
    $('#agenda_list')
    .append(
        $('<a>').addClass('btn btn-color-5')
        .attr({
        onclick :"openBoxDraggable('widgetloader?widget_load=addEvent&isbox=1&style=maxi&<cfoutput>title=#title#&action_section=OPPORTUNITY_ID&action_id=#attributes.opp_id#</cfoutput>')"
        ,style:"position:absolute;right:5%;top:10%"
        })
        .prepend($('<i>').addClass('fa fa-plus'))
    );
</script>