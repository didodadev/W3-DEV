<!--- <cfset cfc= createObject("component","V16.training.cfc.get_training_content")> --->
<cfset cfc= createObject("component","V16.content.cfc.get_content")>
<cfsavecontent variable="right">
    <cfif isdefined('session.ep')> 
        <cfoutput> <li><a href="#request.self#?fuseaction=content.list_content&event=det&cntid=#attributes.cntid#" target="_blank" class="font-red-pink"></cfoutput><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></li>
    </cfif>
</cfsavecontent>

<cf_box title="#getLang('','İçerik',57653)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" right_images="#right#">
    <cf_box_elements>
        <div class="col col-12 col-md-12 col-sm-6 col-xs-12" type="column" index="1" sort="true">
            <cfset get_notice =cfc.get_content_list_fnc(cntid:attributes.cntid)>
            <cfoutput>
                <span class="headbold">#DecodeForHTML(get_notice.cont_head)#</span><br/><br/>
                <span class="txtbold">#DecodeForHTML(get_notice.cont_summary)#</span>
                <br/>
                &nbsp;#DecodeForHTML(get_notice.cont_body)#
            </cfoutput>
        </div>
    </cf_box_elements>
</cf_box>
