<cfparam name="attributes.stream_name" />
<script src="JS/AC_RunActiveContent.js" type="text/javascript"></script>

<table align="center" width="99%">
	<tr>
		<td width="75" colspan="2" class="txtbold"><script type="text/javascript">
AC_FL_RunContent( 'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0','name','videoRecorder','width','330','height','300','id','videoRecorder','src','/images/CubeTVQuickCapture','quality','high','pluginspage','http://www.macromedia.com/go/getflashplayer','flashvars','<cfoutput>streamName=#attributes.stream_name#&serverAddress=#mx_com_server#</cfoutput>','movie','/images/CubeTVQuickCapture' ); //end AC code
</script><noscript><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" name="videoRecorder" width="330" height="300" id="videoRecorder">
  <param name="movie" value="/images/CubeTVQuickCapture.swf" />
  <param name="quality" value="high" />
  <param name="FlashVars" value="<cfoutput>streamName=#attributes.stream_name#&serverAddress=#mx_com_server#</cfoutput>" />
  <embed src="/images/CubeTVQuickCapture.swf" width="330" height="300" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" name="videoRecorder" flashvars="<cfoutput>streamName=#attributes.stream_name#&serverAddress=#mx_com_server#</cfoutput>"></embed>
</object></noscript></td>
	</tr>
<form name="add_video_stream" method="get" action="#" onsubmit="return false;">
	<tr>
	  <td colspan="2" class="txtbold"><cf_workcube_buttons is_upd='0' add_function='control()'></td>
    </tr>
</form>
</table>
<script type="text/javascript">
var streamStarted = false;
var streamClosed = false;

function videoRecorderUpdateStatus(status) {
alert(status);
	if (status == "streamStarted") {
		streamStarted = true;
		streamClosed = false;
	} else if (status == "streamClosed") {
		streamClosed = true;
	}
	return true;
}
	
function videoRecorder_DoFSCommand(command, args) {
	if (command == "streamStarted") {
		streamStarted = true;
		streamClosed = false;
	} else if (command == "streamClosed") {
		streamClosed = true;
	}
}

function control()
{
	if (videoRecorder.isStreamClosed() == false) {
		alert("<cf_get_lang no ='1328.Video kaydetmeyi başlatmanız ve tamamlamak için durdurmanız gerekmektedir'>");
		return false;
	}
	opener.attachStream("<cfoutput>#attributes.stream_name#</cfoutput>");
	self.close();
	return true;
}
</script>
