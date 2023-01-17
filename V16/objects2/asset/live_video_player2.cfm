<cf_box title="Canlı Video">
    <cfif not isdefined("get_video")>
    	<cfif not isdefined("videoData")>
        	<cfset videoData=createObject("component","objects2.asset.query.AssetData").init(dsn,2) />
        </cfif>
        <cfset get_video = videoData.getAsset(attributes.video_id,1) />
        <cfif get_video.recordCount eq 0>
        <cflocation url="#request.self#?fuseaction=objects2.detail_video&video_id=#attributes.video_id#" addtoken="no" />
        </cfif>
        <cfset videoData.IncreaseDownloadCount(attributes.video_id) />
    </cfif>
    <cfif get_video.record_pub neq "">
        <cfset userid=get_video.record_pub />
        <cfset usertype = "consumer" />
    <cfelseif get_video.record_emp neq "">
        <cfset userid=get_video.record_emp />
        <cfset usertype = "employee" />
    <cfelseif get_video.record_par neq "">
        <cfset userid=get_video.record_par />
        <cfset usertype = "partner" />
    </cfif>
    <cfif not isdefined("request.swfobject")>
    <script type="text/javascript" src="/JS/swfobject.js"></script>
    <cfset request.swfobject = true />
    </cfif>
    <div id="flashcontent">
      You must install Adobe Flash Player 9 or above to play the movie.
    </div><script type="text/javascript">
       var so = new SWFObject("/images/flashs/LiveVideoPlayer.swf", "FLVPlayer", "480", "399", "9", "#ffffff");
       so.addParam("wmode", "window");
       so.addParam("allowFullScreen", "true");
       so.addParam("allowScriptAccess","sameDomain");
       so.addVariable("streamName", "<cfoutput>#URLEncodedFormat(replacenocase(get_video.asset_file_name,'.flv',''))#</cfoutput>");
	   so.addVariable("serverAddress", "<cfoutput>#mx_com_server#</cfoutput>");
       so.write("flashcontent");
    </script>
    <div class="myportal_frame" style="padding:5px;">
    <cfoutput><strong><cf_get_lang_main no='14.Video'> <cf_get_lang_main no='485.Adı'>: #get_video.asset_name#</strong><br/>
     <cf_get_lang_main no='359.Detay'>: #get_video.asset_detail#</cfoutput>
    </div>
</cf_box>
