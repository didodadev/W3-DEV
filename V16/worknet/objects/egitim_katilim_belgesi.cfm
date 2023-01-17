<!--- eğitim katılım belgesi --->
<style type="text/css">
.tarih {
	font-family: Georgia, "Times New Roman", Times, serif;
	font-size: 18px;
	color: #383838;
	font-style: italic;
	padding-left:50px;
}
.yazi1 {
	font-family: "Arial Narrow", Arial;
	font-size: 24px;
	line-height: 55px;
	color: #383838;
	text-align:center;
}
.yazi2 {
	font-family: Georgia, "Times New Roman", Times, serif;
	font-size: 25px;
	font-style: italic;
	color: #10155e;
}
.ccc {
border:3px solid #333333;
width:700px;
height:525px;
padding:2px;
margin-top:10px;
}
.ccc2 {
border:dotted;
padding:2px;
width:690px;
height:515px;
}
</style>
<div align="center">
	<div class="ccc" align="center">
		<div class="ccc2" align="center">
			<table style="margin-left:40px; margin-top:20px;" width="700" height="525" border="0" cellspacing="0">
			  <tr>
				<td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td height="25" colspan="3">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="33%">&nbsp;</td>
					<td width="33%"><img src="/documents/templates/worknet/tasarim/katilim_sertifika_logo.png" width="211" height="95" /></td>
					<td width="33%" valign="top" class="tarih"><cfoutput>#dateformat(now(),dateformat_style)#</cfoutput></td>
				  </tr>
				  <tr>
					<td height="65" colspan="3">&nbsp;</td>
					</tr>
				  <tr>
					<td colspan="3" align="center" class="yazi1">Sayın <span class="yazi2"><cfoutput>
						<cfif isdefined('session.pp.userid')>#session.pp.name# #session.pp.surname#
						<cfelseif isdefined('session.ww.userid')>#session.ww.name# #session.ww.surname#
						</cfif></cfoutput></span><br />
					  www.styleturkish.com portalında verilen<br />
					  <span class="yazi2"><cfoutput>#attributes.class_name#</cfoutput></span><br />
					  Konulu E-Eğitim'e Katılmıştır.</td>
				  </tr>
				</table></td>
			  </tr>
			</table>
		</div>
	</div>
</div>
<script language="javascript">
	window.print();
</script>

