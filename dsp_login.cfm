<cfset XFA.submit = "#request.self#?fuseaction=home.act_login">
<script type="text/javascript">
function windowopen(theURL,winSize) { /*v3.0*/
//fonsiyon 3 parametrede alabiliyor 3. parametre de isim yollana bilir ozaman aynı pencere tekrar acilmaz
	if (winSize == 'page') 					{ myWidth=750 ; myHeight=500 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'list') 			{ myWidth=700 ; myHeight=555 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'small') 			{ myWidth=400 ; myHeight=300 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else if (winSize == 'medium') 			{ myWidth=500 ; myHeight=400 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
	else { myWidth=400 ; myHeight=500 ; features = 'scrollbars=0, resizable=0' ; }

	if(window.screen)
	{
		var myLeft = (screen.width-myWidth)/2;
		var myTop =  (screen.height-myHeight)/2;
		
		features+=(features!='')?',':''; 
		features+=',left='+myLeft+',top='+myTop; 
	}
	
  	if (arguments[2]==null)
		window.open(theURL,'',features+((features!='')?',':'')+'width='+myWidth+',height='+myHeight); 
	else		
		window.open(theURL,arguments[2],features+((features!='')?',':'')+'width='+myWidth+',height='+myHeight); 
}	
</script>

<cfif not isDefined("session.error_text") 
	and not (isDefined("session.originalURL") and not len(session.originalURL))
	and (isDefined("attributes.fuseaction") and attributes.fuseaction NEQ "home.login")>
	<cfif len(attributes.fuseaction)>
		<cfset session.originalURL = user_domain & request.self & '?' & cgi.query_string>
	<cfelse>
		<cfset StructDelete(session, "originalURL")/>
	</cfif>
</cfif>

<cfif isdefined('session.ep.userid')>	
	<cfif isDefined("session.originalURL")>
		<cfset local.directURL = session.originalURL>
		<cfset StructDelete(session, "originalURL")/>
		<cflocation url="#local.directURL#" addtoken="no">
	<cfelseif not isDefined("session.ep.gopcha_verify")>
		<cflocation url="#user_domain##request.self#?fuseaction=myhome.welcome" addtoken="no">
	</cfif>
</cfif>

<cfinclude template="dsp_login_custom.cfm">
<script type="text/javascript">
	form_login.username.focus();
</script>
<cfif use_active_directory eq 2 and not isdefined("session.error_text")>
	<cfform action="#XFA.submit#" method="post" name="form_login_active">
		<cfinput name="username" type="hidden" value="">
	</cfform>
</cfif>
<script type="text/javascript">   
<cfif use_active_directory eq 2 and not isdefined("session.error_text")>
	try
	  {
	  var wshNetwork = new ActiveXObject("WScript.Network");
	  document.form_login_active.username.value = wshNetwork.UserName;
	  document.form_login_active.submit();
	  }
	catch(err)
	  {
	  //islem yok
	  //alert('Oluşmadı');
	  }
</cfif>
try
{
	document.getElementById('screen_width').value = document.body.clientWidth;
	document.getElementById('screen_height').value = document.body.clientHeight;
}
catch(e)
{
	//
}
</script>
<cfscript>if (isdefined("session.error_text")) structdelete(session,"error_text");</cfscript>