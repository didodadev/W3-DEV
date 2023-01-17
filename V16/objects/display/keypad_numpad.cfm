<cfoutput>
	<link rel=stylesheet type=text/css href="/css/keypadlogin/keypad3.css">
	<link rel=stylesheet type=text/css href="/css/keypadlogin/custpref.css">		
</cfoutput>
<body bottommargin="0" topmargin="0" leftmargin="0" rightmargin="0">
<div style="POSITION:absolute; BACKGROUND-COLOR:navy;  VISIBILITY: hidden; left:0px;top:0px" id="div_keypadlogin" onmouseover=login_keypadVisible=true onmouseout=login_keypadVisible=false>
<table style="border:2px solid E6E6E6;background-color:A7CAED;" border="0" cellSpacing="0" cellPadding="0">
	<tr>
		<td>&nbsp;</td>
	</tr>          
	<tr>
		<td>
			<div id="nt_div_keypad">
			<table border="0" cellSpacing="2" cellPadding="0" valign="top" width="250">
				<tr>
					<script type="text/javascript">
						for (var i = 10; i < 38; i++) {document.write("<td class=\"keypadButton\"><input name=login_b"+i.toString()+" type=\"button\" class=\"keypadButton\" onclick=\"login_clickEvent(this.value)\" value=\"\" login_idx="+i.toString()+" onMouseOver=\"login_mouseOverEvent(this.value)\" onMouseOut=\"login_mouseOutEvent()\" readonly></td>\n");}
					</script>
					<td  class="keypadButton" style="text-align:right;">
						<input style="WIDTH: 57px" class="keypadButton" onClick="login_sil();" value="Sil" readonly type="button" name="login_bErase2" id="login_bErase2">
					</td>
				</tr>
				<tr>
					<script type="text/javascript">
						for (var i = 22; i < 33; i++) 
						{
							document.write("<td class=\"keypadButton\"><input name=login_b"+i.toString()+" type=\"button\" class=\"keypadButton\" onclick=\"login_clickEvent(this.value)\" value=\"\" login_idx="+i.toString()+" onMouseOver=\"login_mouseOverEvent(this.value)\" onMouseOut=\"login_mouseOutEvent()\" readonly></td>\n");
						}
					</script>
					<td colSpan="2"  class="keypadButton" style="text-align:right;">
						<input style="WIDTH: 80px" class="keypadButton" onClick="login_changeLetters()" value="Caps Lock" readOnly type="button" name="login_bUpperOrLower" id="login_bUpperOrLower">
					</td>
				</tr>
				<tr>
					<script type="text/javascript">
						for (var i = 33; i < 42; i++) 
						{
							document.write("<td class=\"keypadButton\"><input name=login_b"+i.toString()+" type=\"button\" class=\"keypadButton\" onclick=\"login_clickEvent(this.value)\" value=\"\" login_idx="+i.toString()+" onMouseOver=\"login_mouseOverEvent(this.value)\" onMouseOut=\"login_mouseOutEvent()\" readonly></td>\n");
						}
					</script>
					<td class="keypadButton" colSpan="4">
						<input style="WIDTH: 126px" class="keypadButton" onClick="login_scrambleOrReset();" value="Harfleri Karıştır" readOnly type="button" name="login_bScrambleOrReset" id="login_bScrambleOrReset">                
						<tr>
							<td align="middle">
								<span class="sk_mini">
									<input id="login_chgclick" name="login_chgclick" onClick="login_changeClick();" type="checkbox">
								</span>
							</td>
							<td colSpan="9">
								<span class="sk_mini"><cf_get_lang dictionary_id='29967.Harf / Rakam üzerinde bekleyerek giriş'></span>
							</td>
							<td  style="text-align:right;">&nbsp;</td>
							<td colSpan="2"  style="text-align:right;">
								<input style="WIDTH: 80px" class="keypadButton" onClick="login_changeType()" value="Q Klavye" readOnly type="button" name="login_changeOrder" id="login_changeOrder">
							</td>
						</tr>
					</td>
				 </tr>
			</table>
			</div>			
		</td>
		<td valign="top">
			<div id="numpd_div_keypad" width="100%">
				<table border="0" cellSpacing="2" cellPadding="0" valign="top" width="98%">
				  <tr>
					<script type="text/javascript">for (var i = 1; i < 4; i++) {document.write("<td class=\"keypadButtonNum\"><input name=login_b"+i.toString()+" type=\"button\" class=\"keypadButtonNum\" onclick=\"login_clickEvent(this.value)\" value=\"\" login_idx="+i.toString()+" onMouseOver=\"login_mouseOverEvent(this.value)\" onMouseOut=\"login_mouseOutEvent()\" readonly></td>\n");}</SCRIPT>
				  </tr>
				  <tr>
					<script type="text/javascript">for (var i = 4; i < 7; i++) {document.write("<td class=\"keypadButtonNum\"><input name=login_b"+i.toString()+" type=\"button\" class=\"keypadButtonNum\" onclick=\"login_clickEvent(this.value)\" value=\"\" login_idx="+i.toString()+" onMouseOver=\"login_mouseOverEvent(this.value)\" onMouseOut=\"login_mouseOutEvent()\" readonly></td>\n");}</SCRIPT>
				  </tr>
				  <tr>
					<script type="text/javascript">for (var i = 7; i < 10; i++) {document.write("<td class=\"keypadButtonNum\"><input name=login_b"+i.toString()+" type=\"button\" class=\"keypadButtonNum\" onclick=\"login_clickEvent(this.value)\" value=\"\" login_idx="+i.toString()+" onMouseOver=\"login_mouseOverEvent(this.value)\" onMouseOut=\"login_mouseOutEvent()\" readonly></td>\n");}</SCRIPT>
				  </tr>
				  <tr>
					<td>&nbsp;</td>
					<td class="keypadButtonNum">
						<input class="keypadButtonNum" onMouseOver="login_mouseOverEvent(this.value);" onMouseOut="login_mouseOutEvent();" onClick="login_clickEvent(this.value);" readOnly type="button" name="login_b0" id="login_b0" login_idx="0">				
					</td>
				  </tr>
				</table>
			</div>		
		 </td>
	</tr>
</table>
</div>
<cfoutput>
	<input type="text" name="#url.name#" id="#url.name#" AUTOCOMPLETE="OFF" onKeyPress="return #url.accessible#" onKeyDown="return #url.accessible#"/>	
</cfoutput>
</body>
<cfoutput>
	<script language="javascript" src="/js/screen KeyPad/keypadlogin.js"></script>
	<script type="text/javascript">		
		pcKlavye('#url.name# #url.keypad# #url.numpad# 0 0');		
		login_currentInput = window.opener.document.getElementById('#url.name#');
		document.getElementById('#url.name#').focus();
 		document.getElementById('#url.name#').style.visibility = "hidden";
	</script>
</cfoutput>

