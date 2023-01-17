<cfsetting showdebugoutput="no">
<table border="0" cellpadding="0" cellspacing="0">
	<tr valign="top">
		<td style="width:70px;">&nbsp;</td>
		<td>
		<table>
			<tr>
				<td><input name="Ç" id="Ç" class="buton_small" type="button" value="Ç" onClick="javascript:addLetter('Ç');"></td>
				<td><input name="Ğ" id="Ğ" class="buton_small" type="button" value="Ğ" onClick="javascript:addLetter('Ğ');"></td>
				<td><input name="İ" id="İ" class="buton_small" type="button" value="İ" onClick="javascript:addLetter('İ');"></td>
				<td><input name="Ş" id="Ş" class="buton_small" type="button" value="Ş" onClick="javascript:addLetter('Ş');"></td>
				<td><input name="Ö" id="Ö" class="buton_small" type="button" value="Ö" onClick="javascript:addLetter('Ö');"></td>
				<td><input name="Ü" id="Ü" class="buton_small" type="button" value="Ü" onClick="javascript:addLetter('Ü');"></td>
			</tr>
			<tr>
				<td><input name="ç" id="ç" class="buton_small" type="button" value="ç" onClick="javascript:addLetter('ç');"></td>
				<td><input name="ğ" id="ğ" class="buton_small" type="button" value="ğ" onClick="javascript:addLetter('ğ');"></td>
				<td><input name="ı" id="ı" class="buton_small" type="button" value="ı" onClick="javascript:addLetter('ı');"></td>
				<td><input name="ş" id="ş" class="buton_small" type="button" value="ş" onClick="javascript:addLetter('ş');"></td>
				<td><input name="ö" id="ö" class="buton_small" type="button" value="ö" onClick="javascript:addLetter('ö');"></td>
				<td><input name="ü" id="ü" class="buton_small" type="button" value="ü" onClick="javascript:addLetter('ü');"></td>
			</tr>
		</table>
		</td>
		<td><a href="javascript://" onClick="gizle(<cfoutput>#attributes.div_name#</cfoutput>);"><img src="/images/pod_close.gif" border="0" align="absmiddle"></a></td>
	</tr>
</table>
<script type="text/javascript">
	function addLetter(letter)
	{			
		alan = eval(<cfoutput>#attributes.input_name#</cfoutput>);
		alan.value += letter;	
		alan.focus();
	}
</script>
