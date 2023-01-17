<cfparam name="attributes.inputStyle" default="">
<cfparam name="attributes.type" default="text">
<cfparam name="attributes.keypad" default="false">
<cfparam name="attributes.numpad" default="false"> 
<cfparam name="attributes.accessible" default="false">
<cfparam name="attributes.maxlength" default="100">
<cfparam name="attributes.coordX" default="-1">
<cfparam name="attributes.coordY" default="-1">
<cfparam name="attributes.value" default="">
<cfparam name="attributes.message" default="">
<cfparam name="attributes.required" default="">
<cfparam name="attributes.validate" default="">
<cfparam name="attributes.mask" default="">
<cfparam name="attributes.pattern" default="">
<cfparam name="attributes.window" default="false">
<cfparam name="attributes.onkeyup" default="false">
<cfparam name="attributes.onchange" default="false">

<cfset accessible=false> <!--- inputlara erişim izni. true ise inputlara elle giriş yapılabilir --->
<cfif (attributes.accessible IS "true") OR (attributes.accessible IS "TRUE")>
	<cfset accessible=true>
</cfif>

<cfset pen="width=410,height=120">
<cfset window=false> <!--- sayfa boyutlarından büyük klavye açılması gerektiğinde true yapılır --->
<cfif (attributes.window IS "true") OR (attributes.window IS "TRUE")>
<!--- Pencere boyutlarını ayarlamak için --->
	<cfset penStateKeyPad=false>
	<cfif (attributes.keypad IS "true") OR (attributes.keypad IS "TRUE")>
		<cfset penStateKeyPad=true>
	</cfif>
	
	<cfset penStateNumPad=false>
	<cfif (attributes.numpad IS "true") OR (attributes.numpad IS "TRUE")>
		<cfset penStateNumPad=true>
	</cfif>
		
	<cfif penStateNumPad and (penStateKeyPad eq false)>
		<cfset pen="width=10,height=120">
	</cfif>
	
	<cfif penStateKeyPad and (penStateNumPad eq false)>
		<cfset pen="width=340,height=120">
	</cfif>
	<cfset window=true>
</cfif>
<cfoutput>
<cfif IsDefined('attributes.name')>
<input 
onkeypress="#IIF(accessible,DE('return true'),DE('return false'))#" 
onkeydown="#IIF(accessible,DE('return true'),DE('return false'))#" 
value="#attributes.value#" 
message="#attributes.message#" 
#attributes.required# 
validate="#attributes.validate#" 
mask="#attributes.mask#" 
pattern="#attributes.pattern#"  
maxlength="#attributes.maxlength#" 
style="#attributes.inputStyle#" 
oncontextmenu="return false;" 
type="#attributes.type#" 
name="#attributes.name#" 
id="#attributes.name#"
AUTOCOMPLETE="off"
class="form-control"
onKeyUp="#attributes.onkeyup#"
onChange="#attributes.onchange#"
onClick="#IIF((accessible eq false) and (window),DE("window.open('index.cfm?fuseaction=objects.emptypopup_keypad_numpad&name=#attributes.name#&keypad=#attributes.keypad#&numpad=#attributes.numpad#&accessible=#accessible#' ,'list','#pen#');"),DE(""))#">
<cfif accessible and window>
	  <a href="javascript://" onclick="window.open('index.cfm?fuseaction=objects.emptypopup_keypad_numpad&name=#attributes.name#&keypad=#attributes.keypad#&numpad=#attributes.numpad#&accessible=#accessible#' ,'list','#pen#')" >
		<img src="/images/plus_list.gif" border="0" align="absmiddle" alt="#caller.getLang('main',2237)#"/>
	  </a>
</cfif>
<cfif (IsDefined('caller.isLoad_keypad') neq true) and (window eq false)> 
	<link rel=stylesheet" type=text/css" href="/css/temp/keyboard.css">
	<div style="z-index:999; position:absolute; visibility:hidden;" id="div_keypadlogin" onmouseover="login_keypadVisible=true" onmouseout="login_keypadVisible=false">
	<table class="keypadtable" border="0" cellSpacing="0" cellPadding="0" width="100">
		<tr>
			<td style="text-align:right" colspan="2" class="keypadclose" height="17" valign="top">
				<label style="cursor:pointer;" onClick="login_hideKeypad();return false;">X&nbsp;</label>
			</td>
		</tr> 
		<tr>
			<td>
				<div id="nt_div_keypad">
				<table border="0" cellSpacing="2" cellPadding="0" valign="top" width="260">
					<tr>
						<script>
							for (var i = 10; i < 22; i++) {document.write("<td class=\"keypadButton\"><input name=login_b"+i.toString()+" type=\"button\" class=\"keypadButton\" onclick=\"login_clickEvent(this.value)\" value=\"\" login_idx="+i.toString()+" onMouseOver=\"login_mouseOverEvent(this.value)\" onMouseOut=\"login_mouseOutEvent()\" readonly></td>\n");}
						</script>
						<td class="keypadButton" align="right">
							<input style="width:57px" class="keypadButton" onclick="login_sil();" value="#caller.getLang('main',51)#" readOnly type="button" name="login_bErase">	
						</td>
					</tr>
					<tr>
						<script>
							for (var i = 22; i < 33; i++) 
							{
								document.write("<td class=\"keypadButton\"><input name=login_b"+i.toString()+" type=\"button\" class=\"keypadButton\" onclick=\"login_clickEvent(this.value)\" value=\"\" login_idx="+i.toString()+" onMouseOver=\"login_mouseOverEvent(this.value)\" onMouseOut=\"login_mouseOutEvent()\" readonly></td>\n");
							}
						</script>
						<td class="keypadButton" colSpan="2" align="right">
							<input style="width:80px" class="keypadButton" onclick="login_changeLetters()" value="#caller.getLang('main',2168)#" readOnly type="button" name="login_bUpperOrLower">	
						</td>
					</tr>
					<tr>
						<script>
							for (var i = 33; i < 42; i++) 
							{
								document.write("<td class=\"keypadButton\"><input name=login_b"+i.toString()+" type=\"button\" class=\"keypadButton\" onclick=\"login_clickEvent(this.value)\" value=\"\" login_idx="+i.toString()+" onMouseOver=\"login_mouseOverEvent(this.value)\" onMouseOut=\"login_mouseOutEvent()\" readonly></td>\n");
							}
						</script>
						<td class="keypadButton" colSpan="4">
							<input style="width:126px" class="keypadButton" onclick="login_scrambleOrReset();" value="#caller.getLang('main',2167)#" readOnly type="button" name="login_bScrambleOrReset">		
						</td>
					</tr>
					<tr>
						<td align="middle">
							<span class="sk_mini">
								<input id="login_chgclick" onclick="login_changeClick();" type="checkbox">
							</span> 
						</td>
						<td colSpan="9">
							<span class="sk_mini">#caller.getLang('main',2170)#</span>	
						</td>
						<td align=right>&nbsp;</td>
						<td colSpan="2" align="right">
							<input style="width:80px" class="keypadButton" onclick="login_changeType()" value="#caller.getLang('main',2166)#" readOnly type="button" name="login_changeOrder">	
						</td>
					</tr>
				</table>
				</div>
			</td>
			<td>
			  <div id="numpd_div_keypad" style="width:75px">
				<table border="0" cellSpacing="2" cellPadding="0" valign="top">
				    <tr>
						<script>for (var i = 1; i < 4; i++) {document.write("<td class=\"keypadButtonNum\"><input name=login_b"+i.toString()+" type=\"button\" class=\"keypadButtonNum\" onclick=\"login_clickEvent(this.value)\" value=\"\" login_idx="+i.toString()+" onMouseOver=\"login_mouseOverEvent(this.value)\" onMouseOut=\"login_mouseOutEvent()\" readonly></td>\n");}</SCRIPT>
				    </tr>
				    <tr>
						<script>for (var i = 4; i < 7; i++) {document.write("<td class=\"keypadButtonNum\"><input name=login_b"+i.toString()+" type=\"button\" class=\"keypadButtonNum\" onclick=\"login_clickEvent(this.value)\" value=\"\" login_idx="+i.toString()+" onMouseOver=\"login_mouseOverEvent(this.value)\" onMouseOut=\"login_mouseOutEvent()\" readonly></td>\n");}</SCRIPT>
				    </tr>
				    <tr>
						<script>for (var i = 7; i < 10; i++) {document.write("<td class=\"keypadButtonNum\"><input name=login_b"+i.toString()+" type=\"button\" class=\"keypadButtonNum\" onclick=\"login_clickEvent(this.value)\" value=\"\" login_idx="+i.toString()+" onMouseOver=\"login_mouseOverEvent(this.value)\" onMouseOut=\"login_mouseOutEvent()\" readonly></td>\n");}</SCRIPT>
				    </tr>
				    <tr>
						<td>&nbsp;</td>
						<td class="keypadButtonNum">
							<input class="keypadButtonNum" onmouseover="login_mouseOverEvent(this.value);" onmouseout="login_mouseOutEvent();" onclick=login_clickEvent(this.value); readOnly type=button name=login_b0 login_idx="0">
						</td>
						<td>
							<div id="numpad_sil">
								<input class="keypadButton" onclick="login_sil();" value="#caller.getLang('main',51)#" readOnly type="button" name="login_bErase">	
							</div>
						</td>
				    </tr>
				</table>
			  </div>
			</td>
		</tr>
	</table>
	</div>
	<script language="javascript" src="/js/keypadlogin.js"></script>
	<cfset caller.isLoad_keypad=true>
</cfif>
	<cfif (window eq false)>
		<script type="text/javascript">
			pcKlavye('#attributes.name# #attributes.keypad# #attributes.numpad# #attributes.coordX# #attributes.coordY#');
		</script>
	</cfif>
<cfelse>
	<font color="red"><b>#caller.getLang('main',2169)#...<b></font>	
</cfif>
</cfoutput>

