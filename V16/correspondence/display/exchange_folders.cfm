<cfparam name="attributes.mailbox_id" default="">
<style>
.dtree {
	font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
	font-size: 11px;
	color: #666;
	white-space: nowrap;
}
.dtree img {
	border: 0px;
	vertical-align: middle;
}
.dtree a {
	color: #333;
	text-decoration: none;
}
.dtree a.node, .dtree a.nodeSel {
	white-space: nowrap;
	padding: 1px 2px 1px 2px;
}
.dtree a.node:hover, .dtree a.nodeSel:hover {
	color: #333;
	text-decoration: underline;
}
.dtree a.nodeSel {
	background-color: #c0d2ec;
}
.dtree .clip {
	overflow: hidden;
}
</style>
<script src= "/JS/dTree.js"></script>

<script language="javascript">
function openMails(folderName){
	AjaxPageLoad('index.cfm?fuseaction=correspondence.emptypopup_exchange_mails&folder='+folderName+'','mails',1);
}

function openAnotherMailBox(){
	var obj = document.getElementById('mailbox_id');
	window.location='http://<cfoutput>#cgi.HTTP_HOST#</cfoutput>/index.cfm?fuseaction=correspondence.exchangemail&mailbox_id='+obj.options[obj.selectedIndex].value
}
</script>

<cfquery name="EXCHANGE_SETTINGS" datasource="#dsn#">
	SELECT
		SETTING_ID,
		USERNAME
	FROM
		EXCHANGE_SETTINGS
	WHERE 
		USER_ID = #session.ep.userid#
</cfquery>
<cfinclude template="exchange_conn.cfm">
<cfexchangeconnection action="GETSUBFOLDERS" connection="wrk_exchange_connection" name="getmainfolders" recurse="no">
<table>
<tr>
<td>
<select name="mailbox_id" id="mailbox_id" style="width:200" onchange="openAnotherMailBox()">
	<cfoutput query="EXCHANGE_SETTINGS">
	<option value="#SETTING_ID#" <cfif attributes.mailbox_id eq SETTING_ID>selected</cfif>>#USERNAME#</option>
	</cfoutput>
</select>
</td>
</tr>
<tr>
<td>
<cfset i = 5>
	<cfoutput>
		<img src="/images/exchange/personalfolders.gif" align="absmiddle" /> #session.ep.name# #session.ep.surname#<br />
	</cfoutput>
	<cfoutput query="getmainfolders">
		<cfif foldername is 'Gelen Kutusu'>
			<img src="/images/exchange/inbox.gif" align="absmiddle" />
		<cfelseif foldername is 'Giden Kutusu'>
			<img src="/images/exchange/SentItems.gif" align="absmiddle" />
		<cfelseif foldername is 'Gönderilmiş Öğeler'>
			<img src="/images/exchange/sent.gif" align="absmiddle" />
		<cfelseif foldername is 'Önemsiz Elektronik Posta'>
			<img src="/images/exchange/junk.gif" align="absmiddle" />
		<cfelseif foldername is 'Silinmiş Öğeler'>
			<img src="/images/exchange/DeletedItems.gif" align="absmiddle" />
		<cfelseif foldername is 'Taslaklar'>
			<img src="/images/exchange/drafts.gif" align="absmiddle" />
		<cfelse>
			<img src="/images/exchange/personalfolders.gif" align="absmiddle" />	
		</cfif>
		<!--- <cfexchangemail action="get" connection="wrk_exchange_connection" name="mails">
		  <cfexchangefilter name="folder" value="#foldername#">
		</cfexchangemail>
		<cfset meetingData=evaluate("mails")>
		<cfquery dbtype="query" name="theResponses">
			SELECT uid FROM meetingData WHERE isread=0
		</cfquery> --->
		<a href="javascript://" onclick="openMails('#URLEncodedFormat(foldername)#');" class="tableyazi">#foldername#<!---  (#mails.recordcount#/#theResponses.recordcount#) ---></a><br />
	</cfoutput>
</td>
</tr>
<tr>
	<td><img src="/images/exchange/compose.gif" border="0" title="Yeni Mail" align="absmiddle"/> <a href="javascript://" onclick="mailGonder();" class="tableyazi"><cf_get_lang dictionary_id="57475.MAİL GÖNDER"></a></td>
</tr>
</table>

<cfexchangeConnection action="close" connection="wrk_exchange_connection">

<script language="javascript">
	function mailGonder(){
		AjaxPageLoad('index.cfm?fuseaction=correspondence.emptypopup_exchange_send_frm&islem=new','mail_content',1);	
	}
</script>
