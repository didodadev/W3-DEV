<cfsetting enablecfoutputonly="true">
<!---

 ADOBE CONFIDENTIAL
 ___________________

  Copyright 2012 Adobe Systems Incorporated
  All Rights Reserved.
  NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
  terms of the Adobe license agreement accompanying it.  If you have received this file from a 
  source other than Adobe, then your use, modification, or distribution of it requires the prior 
  written permission of Adobe.

  _____________________________
  Refactor 05.21.2013 Steve "Cutter" Blades webDOTadminATcutterscrossing.com
  * Changed type "subscriber" to "subscribe" to match the documentation provided
  * Removed "count=horizontal" option from the "tweet" type, as it is no longer supported,
    as well as adding that "count" to the output, to match documentation
  * Rewrote udf's to ColdFusion standards
  * Scope all variables
--->

<!---
  Implementation of various social plugins
--->

<cfscript>
	/* START Internal Functions, used only by this tag */
	// Validates type attribute.
	private void function validateType (required string type) {
		var validValues = ["like","likebox","tweet","commentbox","activityfeed","subscribe","follow","plusone"];
		if (!ArrayFindNoCase(LOCAL.validValues, ARGUMENTS.type))
			throw(message = "Type attribute has invalid value. Valid values are : " & UCase(ArrayToList(LOCAL.validValues)));
	}

	// Returns current URL.
	private string function getCurrentUrl () {
		return "http" & ((CGI.https eq "off") ? "" : "s") & "://" & CGI.http_host & CGI.script_name;
	}

	// Validates values of a given attribute.
	private void function validate (required string attributeValue, required string attributeName, required string validValues) {
		if (!ListFindNoCase(ARGUMENTS.validValues, ARGUMENTS.attributeValue))
			throw(message = UCase(ARGUMENTS.attributeName) & " attribute has invalid value. Valid values are : " & ARGUMENTS.validValues);
	}

	// Validates if for a given type these attributes are allowed or not.
	private void function validateAttributes (required string validValues, required string type) {
		var keys = StructKeyArray(ATTRIBUTES);
		ARGUMENTS.validValues = ARGUMENTS.validValues & ",extraoptions";
		for (var i=1; LOCAL.i <= ArrayLen(LOCAL.keys); LOCAL.i++) {
			if (!ListFindNoCase(ARGUMENTS.validValues, LOCAL.keys[LOCAL.i]))
				throw(message = "Some attribute(s) are not valid for this type. Valid attributes for " & ARGUMENTS.type & " type are : " & ARGUMENTS.validValues);
		}
	}

	// Validates numeric data types.
	private void function validateNumber (required string value, required string type) {
		if (!IsNumeric(ARGUMENTS.value) or ARGUMENTS.value < 1)
			throw (message = "Attribute " & ARGUMENTS.type & " can only have positive numeric values");
	}
	/* END Internal Functions, used only by this tag */

	// Stop action if end tag
	if (thisTag.ExecutionMode is 'end')
		return;

	// Is there a valid "type"?
	param name="ATTRIBUTES.type" default="";

	if (Len(ATTRIBUTES.type)) {
		validateType(LCase(ATTRIBUTES.type));
	} else {
		throw(message = "Type is a mandatory attribute");
	}
</cfscript>

<!-----------------------LIKE Button Starts---------------------->
<cfif ATTRIBUTES.type eq "like">
	<cfscript>
		validateAttributes('type,layout,width,colorscheme,showfaces,verb,style,url', ATTRIBUTES.type);
		param name="ATTRIBUTES.layout" type="string" default="standard";
		param name="ATTRIBUTES.verb" type="string" default="like";
		param name="ATTRIBUTES.width" type="numeric" default="450";
		param name="ATTRIBUTES.colorscheme" type="string" default="light";
		param name="ATTRIBUTES.showfaces" type="boolean" default=true;
		param name="ATTRIBUTES.style" type="string" default="";
		param name="ATTRIBUTES.url" type="string" default=getCurrentUrl();
		param name="ATTRIBUTES.extraoptions" type="string" default="";

		validate(ATTRIBUTES.layout, 'layout', 'standard,button_count,box_count');
		validate(ATTRIBUTES.verb, 'verb', 'like,recommend');
		validateNumber(ATTRIBUTES.width, 'width');
		validate(ATTRIBUTES.colorscheme, 'colorscheme', 'dark,light');
		ATTRIBUTES.showfaces = (ATTRIBUTES.showfaces) ? "true" : "false"; // force it to true string rep of boolean value
	</cfscript>

	<cfoutput>
		<iframe src="//www.facebook.com/plugins/like.php?href=#encodeForURL(ATTRIBUTES.url)#&amp;send=false&amp;layout=#LCase(Replace(ATTRIBUTES.layout, ' ', '_', 'all'))#&amp;width=#ATTRIBUTES.width#&amp;show_faces=#ATTRIBUTES.showfaces#&amp;action=#LCase(ATTRIBUTES.verb)#&amp;colorscheme=#LCase(ATTRIBUTES.colorscheme)#&amp;font&amp;height=90&amp" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:#ATTRIBUTES.width#px; height:90px;#ATTRIBUTES.style#" allowTransparency="true" #ATTRIBUTES.extraoptions#></iframe>
	</cfoutput>
<!-----------------------LIKE Button Ends---------------------->

<!-----------------------LIKE BOX Starts---------------------->
<cfelseif ATTRIBUTES.type eq "likebox">
	<cfscript>
		validateAttributes('type,height,width,colorscheme,showfaces,,showstream,showheader,style,url', ATTRIBUTES.type);
		param name="ATTRIBUTES.width" type="numeric" default="292";
		param name="ATTRIBUTES.height" type="numeric" default="590";
		param name="ATTRIBUTES.colorscheme" type="string" default="light";
		param name="ATTRIBUTES.showfaces" type="boolean" default=true;
		param name="ATTRIBUTES.showstream" type="boolean" default=true;
		param name="ATTRIBUTES.showheader" type="boolean" default=true;
		param name="ATTRIBUTES.style" type="string" default="";
		param name="ATTRIBUTES.url" type="string" default=getCurrentUrl();
		param name="ATTRIBUTES.extraoptions" type="string" default="";

		validateNumber(ATTRIBUTES.width, 'width');
		validateNumber(ATTRIBUTES.height, 'height');
		validate(ATTRIBUTES.colorscheme, 'colorscheme', 'dark,light');
		ATTRIBUTES.showfaces = (ATTRIBUTES.showfaces) ? "true" : "false"; // force it to true string rep of boolean value
		ATTRIBUTES.showstream = (ATTRIBUTES.showstream) ? "true" : "false";
		ATTRIBUTES.showheader = (ATTRIBUTES.showheader) ? "true" : "false";
	</cfscript>

	<cfoutput>
		<iframe src="//www.facebook.com/plugins/likebox.php?href=#encodeForURL(ATTRIBUTES.url)#&amp;width=#ATTRIBUTES.width#&amp;height=#ATTRIBUTES.height#&amp;colorscheme=#LCase(ATTRIBUTES.colorscheme)#&amp;show_faces=#ATTRIBUTES.showfaces#&amp;border_color&amp;stream=#ATTRIBUTES.showstream#&amp;header=#ATTRIBUTES.showheader#" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:#ATTRIBUTES.width#px; height:#ATTRIBUTES.height#px;#ATTRIBUTES.style#" allowTransparency="true" #ATTRIBUTES.extraoptions#></iframe>
	</cfoutput>
<!-----------------------LIKE BOX Ends---------------------->

<!-----------------------COMMENT BOX Starts---------------------->
<cfelseif ATTRIBUTES.type eq 'commentbox'>
	<cfscript>
		validateAttributes('type,width,colorscheme,numberofposts,style,url', ATTRIBUTES.type);
		param name="ATTRIBUTES.width" type="numeric" default="292";
		param name="ATTRIBUTES.colorscheme" type="string" default="light";
		param name="ATTRIBUTES.numberofposts" type="numeric" default="2";
		param name="ATTRIBUTES.style" type="string" default="";
		param name="ATTRIBUTES.url" type="string" default=getCurrentUrl();
		param name="ATTRIBUTES.extraoptions" type="string" default="";

		validateNumber(ATTRIBUTES.width, 'width');
		validateNumber(ATTRIBUTES.numberofposts, 'numberofposts');
		validate(ATTRIBUTES.colorscheme, 'colorscheme', 'dark,light');
	</cfscript>

	<cfoutput>
		<div id="fb-root"></div>
		<script>
			(function (d, s, id) {
				var js
					, fjs = d.getElementsByTagName(s)[0];
				if (d.getElementById(id)) return;
				js = d.createElement(s);
				js.id = id;
				js.src = "//connect.facebook.net/en_US/all.js##xfbml=1";
				fjs.parentNode.insertBefore(js, fjs);
			}(document, 'script', 'facebook-jssdk'));
		</script>
		<div class="fb-comments" data-href="#ATTRIBUTES.url#" data-num-posts="#ATTRIBUTES.numberofposts#" data-width="#ATTRIBUTES.width#" #ATTRIBUTES.extraoptions#></div>
	</cfoutput>
<!-----------------------COMMENT BOX Ends---------------------->

<!-----------------------ACTIVITYFEED Starts---------------------->
<cfelseif ATTRIBUTES.type eq 'activityfeed'>
	<cfscript>
		validateAttributes('type,height,width,colorscheme,showheader,style,url,linktarget,recommendations,appid,action', ATTRIBUTES.type);
		param name="ATTRIBUTES.width" type="numeric" default="300";
		param name="ATTRIBUTES.height" type="numeric" default="300";
		param name="ATTRIBUTES.colorscheme" type="string" default="light";
		param name="ATTRIBUTES.showheader" type="boolean" default=true;
		param name="ATTRIBUTES.appid" type="string" default="";
		param name="ATTRIBUTES.action" type="string" default="";
		param name="ATTRIBUTES.linktarget" type="string" default="_blank";
		param name="ATTRIBUTES.recommendations" type="boolean" default=false;
		param name="ATTRIBUTES.style" type="string" default="";
		param name="ATTRIBUTES.url" type="string" default=getCurrentUrl();
		param name="ATTRIBUTES.extraoptions" type="string" default="";

		validateNumber(ATTRIBUTES.width, 'width');
		validateNumber(ATTRIBUTES.height, 'height');
		validate(ATTRIBUTES.colorscheme, 'colorscheme', 'dark,light');
		validate(ATTRIBUTES.linktarget, 'linktarget', '_blank,_top,_parent');
		ATTRIBUTES.showheader = (ATTRIBUTES.showheader) ? "true" : "false"; // force it to true string rep of boolean value
		ATTRIBUTES.recommendations = (ATTRIBUTES.recommendations) ? "true" : "false";
	</cfscript>

	<cfoutput>
		<iframe src="//www.facebook.com/plugins/activity.php?site=#encodeForURL(ATTRIBUTES.url)#&amp;app_id=#LCase(ATTRIBUTES.appid)#&amp;action=#LCase(ATTRIBUTES.action)#&amp;width=#ATTRIBUTES.width#&amp;height=#ATTRIBUTES.height#&amp;header=#ATTRIBUTES.showheader#&amp;colorscheme=#LCase(ATTRIBUTES.colorscheme)#&amp;linktarget=#LCase(ATTRIBUTES.linktarget)#&amp;border_color&amp;font&amp;recommendations=#ATTRIBUTES.recommendations#" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:#ATTRIBUTES.width#px; height:#ATTRIBUTES.height#px;#ATTRIBUTES.style#" allowTransparency="true" #ATTRIBUTES.extraoptions#></iframe>
	</cfoutput>
<!-------------------ACTIVITYFEED Ends----------------------->


<!-------------------SUBSCRIBE Button Starts----------------------->
<cfelseif ATTRIBUTES.type eq 'subscribe'>
	<cfscript>
		validateAttributes('type,layout,width,colorscheme,showfaces,style,url', ATTRIBUTES.type);
		param name="ATTRIBUTES.layout" type="string" default="standard";
		param name="ATTRIBUTES.width" type="numeric" default="450";
		param name="ATTRIBUTES.colorscheme" type="string" default="light";
		param name="ATTRIBUTES.showfaces" type="boolean" default=true;
		param name="ATTRIBUTES.style" type="string" default="";
		param name="ATTRIBUTES.url" type="string" default="";
		param name="ATTRIBUTES.extraoptions" type="string" default="";

		validate(ATTRIBUTES.layout, 'layout', 'standard,button_count,box_count');
		validateNumber(ATTRIBUTES.width, 'width');
		validate(ATTRIBUTES.colorscheme, 'colorscheme', 'dark,light');
		ATTRIBUTES.showfaces = (ATTRIBUTES.showfaces) ? "true" : "false"; // force it to true string rep of boolean value
		if (!Len(ATTRIBUTES.url))
			throw(message = "URL is a mandatory attribute");
	</cfscript>

	<cfoutput>
		<iframe src="//www.facebook.com/plugins/subscribe.php?href=#encodeForURL(ATTRIBUTES.url)#&amp;send=false&amp;layout=#LCase(Replace(ATTRIBUTES.layout, ' ', '_', 'all'))#&amp;width=#ATTRIBUTES.width#&amp;show_faces=#ATTRIBUTES.showfaces#&amp;colorscheme=#LCase(ATTRIBUTES.colorscheme)#&amp;font&amp;" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:#ATTRIBUTES.width#px;#ATTRIBUTES.style#" allowTransparency="true" #ATTRIBUTES.extraoptions#></iframe>
	</cfoutput>
<!-----------------------SUBSCRIBE Button Ends---------------------->

<!-------------------FOLLOW Button Starts----------------------->
<cfelseif ATTRIBUTES.type eq 'follow'>
	<cfscript>
		validateAttributes('type,username,showusername,buttonsize,language,showcount,style', ATTRIBUTES.type);
		param name="ATTRIBUTES.username" type="string" default="twitter";
		param name="ATTRIBUTES.buttonsize" type="string" default="small";
		param name="ATTRIBUTES.showusername" type="boolean" default=true;
		param name="ATTRIBUTES.language" type="string" default="en";
		param name="ATTRIBUTES.showcount" type="boolean" default=false;
		param name="ATTRIBUTES.style" type="string" default="";
		param name="ATTRIBUTES.extraoptions" type="string" default="";

		validate(ATTRIBUTES.buttonsize, 'buttonsize', 'small,medium,large');
		ATTRIBUTES.showusername = (ATTRIBUTES.showusername) ? "true" : "false"; // force it to true string rep of boolean value
		ATTRIBUTES.showcount = (ATTRIBUTES.showcount) ? "true" : "false";
	</cfscript>

	<cfoutput>
		<a style="#ATTRIBUTES.style#" href="https://twitter.com/#ATTRIBUTES.username#" class="twitter-follow-button" data-show-count="#ATTRIBUTES.showcount#" data-lang="#ATTRIBUTES.language#" data-size="#ATTRIBUTES.buttonsize#" data-show-screen-name=#ATTRIBUTES.showusername# #ATTRIBUTES.extraoptions#>Follow @#ATTRIBUTES.username#</a>
	</cfoutput>
	<cfif not isdefined("request.followloaded")>
	    <cfoutput>
		<script>
			!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id))
			{js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";
			fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");
		</script>
	    </cfoutput>
	    <cfset request.followloaded = true>
	</cfif>
	
<!-----------------------FOLLOW Button Ends---------------------->

<!-------------------TWEET Button Starts----------------------->
<cfelseif ATTRIBUTES.type eq 'tweet'>
	<cfscript>
		validateAttributes('url,tweettext,via,count,recommend,language,hashtag,buttonsize,style,type', ATTRIBUTES.type);
		param name="ATTRIBUTES.buttonsize" type="string" default="small";
		param name="ATTRIBUTES.recommend" type="string" default="";
		param name="ATTRIBUTES.hashtag" type="string" default="";
		param name="ATTRIBUTES.count" type="string" default="none";
		param name="ATTRIBUTES.via" type="string" default="";
		param name="ATTRIBUTES.tweettext" type="string" default="";
		param name="ATTRIBUTES.language" type="string" default="en";
		param name="ATTRIBUTES.showcount" type="boolean" default=false;
		param name="ATTRIBUTES.style" type="string" default="";
		param name="ATTRIBUTES.url" type="string" default=getCurrentUrl();
		param name="ATTRIBUTES.extraoptions" type="string" default="";

		validate(ATTRIBUTES.buttonsize, 'buttonsize', 'small,large');
		validate(ATTRIBUTES.count, 'count', 'none,horizontal');
		ATTRIBUTES.showcount = (ATTRIBUTES.showcount) ? "true" : "false"; // force it to true string rep of boolean value
	</cfscript>

	<cfoutput>
		<a href="https://twitter.com/share" class="twitter-share-button" data-count="#LCase(ATTRIBUTES.count)#" data-url="#encodeForURL(ATTRIBUTES.url)#"<cfif Len(ATTRIBUTES.tweettext)> data-text="#ATTRIBUTES.tweettext#"</cfif> data-via="#ATTRIBUTES.via#" data-size="#ATTRIBUTES.buttonsize#" data-related="#ATTRIBUTES.recommend#" data-hashtags="#ATTRIBUTES.hashtag#" #ATTRIBUTES.extraoptions#>Tweet</a>
        </cfoutput>
	<cfif not isdefined("request.twitterloaded")>
	    <cfoutput>
		<script>
			!function (d, s, id) {
				var js
					,fjs=d.getElementsByTagName(s)[0];
				if (!d.getElementById(id)) {
					js=d.createElement(s);
					js.id=id;
					js.src="//platform.twitter.com/widgets.js";
					fjs.parentNode.insertBefore(js,fjs);
				}
			}(document, "script", "twitter-wjs");
		</script>
	     </cfoutput>
	     <cfset request.twitterloaded = true>
	</cfif>
	
<!-----------------------TWEET Button Ends---------------------->

<!-------------------PLUSONE Button Starts----------------------->
<cfelseif ATTRIBUTES.type eq 'plusone'>
	<cfscript>
		validateAttributes('type,buttonsize,language,annotation,width,url,style', ATTRIBUTES.type);
		param name="ATTRIBUTES.annotation" type="string" default="bubble";
		param name="ATTRIBUTES.width" type="numeric" default="450";
		param name="ATTRIBUTES.buttonsize" type="string" default="small";
		param name="ATTRIBUTES.language" type="string" default="en";
		param name="ATTRIBUTES.style" type="string" default="";
		param name="ATTRIBUTES.url" type="string" default=getCurrentUrl();
		param name="ATTRIBUTES.extraoptions" type="string" default="";

		validateNumber(ATTRIBUTES.width, 'width');
		if (ATTRIBUTES.width < 121)
			throw(message = "Minimum value of width is 120.");
		validate(ATTRIBUTES.annotation, 'annotaion', 'inline,bubble,none');
		validate(ATTRIBUTES.buttonsize, 'buttonsize', 'small,medium,large,tall');
	</cfscript>

	<cfoutput>
		<div class="g-plusone" style="#ATTRIBUTES.style#" data-size="#ATTRIBUTES.buttonsize#" data-annotation="#ATTRIBUTES.annotation#" data-width="#ATTRIBUTES.width#" data-href="#encodeForURL(ATTRIBUTES.url)#" #ATTRIBUTES.extraoptions#></div>
		<script>
			window.___gcfg = {lang: '#ATTRIBUTES.language#'};
			(function () {
				var po = document.createElement('script'); 
				po.type = 'text/javascript'; 
				po.async = true;
				po.src = 'https://apis.google.com/js/plusone.js';
				var s = document.getElementsByTagName('script')[0];
				s.parentNode.insertBefore(po, s);
			})();
		</script>
	</cfoutput>
<!-----------------------PLUSONE Button Ends---------------------->
</cfif>

<cfsetting enablecfoutputonly="false">
