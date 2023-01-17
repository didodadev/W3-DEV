<cfif isdefined('attributes.video_id') and len(attributes.video_id)>
	<cfif isdefined('attributes.playerWidth') and len(attributes.playerWidth)>
		<cfset playerWidth = attributes.playerWidth>
	<cfelse>
		<cfset playerWidth = 480>
	</cfif>
	<cfif isdefined('attributes.playerHeight') and len(attributes.playerHeight)>
		<cfset playerHeight = attributes.playerHeight>
	<cfelse>
		<cfset playerHeight = 420>
	</cfif>
	<cfif isdefined('autoPlay')><!---otomatik baslamasi icin gerekli parametre --->
		<cfset autoPlay = autoPlay>
	<cfelse>
		<cfset autoPlay = "false">
	</cfif>
	
	<cfinclude template="query/get_video.cfm">
	<cfif get_video.recordcount>
	<cflock name="#CreateUUID()#" timeout="20">
	  <cftransaction>
			<cfif not len(get_video.download_count)>
				<cfset get_video.download_count = 0>
			</cfif>
			<cfset download_count_ = get_video.download_count + 1><!--- izlenme --->
			<cfquery name="ASSET_DOWNLOAD_COUNT" datasource="#DSN#">
				UPDATE ASSET SET DOWNLOAD_COUNT = #download_count_# WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.video_id#"> AND IS_INTERNET = 1
			</cfquery>
		</cftransaction>
	</cflock>
	<cfif not isdefined("request.swfobject")>
		<script type="text/javascript" src="/JS/swfobject.js"></script>
		<cfset request.swfobject = true />
	</cfif>
	<div id="flashcontent">
	  You must install Adobe Flash Player 9 or above to play the movie.
	</div>
	<cfif len(get_video.asset_file_path_name)>
		<cfset my_path_name_ = 'http://#cgi.HTTP_HOST#/#get_video.asset_file_path_name#'>
	<cfelse>
		<cfset my_path_name_ = 'http://#cgi.HTTP_HOST#/documents/#get_video.assetcat_path#/#get_video.asset_file_name#'>
	</cfif>
	<script type="text/javascript">
	   var so = new SWFObject("/com_mx/FLVPlayer.swf", "FLVPlayer", "<cfoutput>#playerWidth#</cfoutput>", "<cfoutput>#playerHeight#</cfoutput>", "9", "#000000");
	   so.addParam("wmode", "window");
	   so.addParam("allowFullScreen", "true");
	   so.addParam("allowScriptAccess","always");
	   so.addParam("id","FLVPlayer");
	   so.addVariable("contentPath", "<cfoutput>#my_path_name_#</cfoutput>");
	   so.addVariable("serverAddress",'<cfoutput>#cgi.HTTP_HOST#</cfoutput>');
	   so.addVariable("fmsServerAddress",'<cfoutput>#fms_server_address#</cfoutput>');
	   so.addVariable("currentURL",window.location);
	   so.addVariable("autoPlay","<cfoutput>#autoPlay#</cfoutput>");
	   so.write("flashcontent");
	</script>
	</cfif>
</cfif>
