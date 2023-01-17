<cfparam name="attributes.id" default="pod_#createUUID()#">
<cfparam name="attributes.is_edit" default=0>
<cfparam name="attributes.is_add" default=0>
<cfparam name="attributes.is_hidden" default=0>
<cfparam name="attributes.is_close" default=0>
<cfoutput>
<cfif thisTag.executionMode eq "start">
<div id="#attributes.id#" class="pod_frame">
<cfif isdefined("attributes.title")>
	<div class="pod_header">
        <div style="float:left">#attributes.title#</div>
        <div style="float:right">
        	<cfif attributes.is_edit eq 1>
                <img src="/images/pod_edit.gif" alt="<cf_get_lang dictionary_id='58718.Düzenle'>" border="0" style="cursor:pointer;" align="absmiddle"> 
        	</cfif>
        	<cfif attributes.is_hidden eq 1>
				<img src="/images/pod_hidden.gif" alt="<cf_get_lang dictionary_id='57553.Kapa'>" border="0" align="absmiddle" id="#attributes.id#_img1" style="cursor:pointer;" onclick="gizle_goster_img('#attributes.id#_img1','#attributes.id#_img2','#attributes.id#_default');"> 
				<img src="/images/pod_open.gif" alt="<cf_get_lang dictionary_id='48969.Aç'>" border="0" align="absmiddle" id="#attributes.id#_img2" style="display:none;cursor:pointer;" onclick="gizle_goster_img('#attributes.id#_img1','#attributes.id#_img2','#attributes.id#_default');">
			</cfif>
            <cfif attributes.is_add eq 1>
                <img src="/images/pod_add.gif" alt="<cf_get_lang dictionary_id='57582.Ekle'>" border="0" style="cursor:pointer;" align="absmiddle"> 
        	</cfif>
            <cfif attributes.is_close eq 1>
                <img src="/images/pod_close.gif" alt="<cf_get_lang dictionary_id='57553.Kapa'>" border="0" style="cursor:pointer;" align="absmiddle"> 
        	</cfif>
        </div>
	</div>
</cfif>
<div id="#attributes.id#_default" class="pod_default">
<cfelse>
	<cfif isdefined("attributes.source")>
		<cfinclude template="#attributes.source#" />
    </cfif>
    </div>
</div>
</cfif>
</cfoutput>
