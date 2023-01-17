<script type="text/javascript">
	function gondert()
	{
		opener.html_edit.textEdit.document.body.innerHTML = document.flash_.code_editing.value;
		self.close();
	}
</script>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32565.Kodu Düzenle'></cfsavecontent>
<cf_popup_box title="#message#">
	<form name="flash_" method="post" action="" enctype="multipart/form-data">
		<table>
			<tr>
				<td>
					<textarea name="code_editing" id="code_editing" style="width:650px;height:425px;"></textarea>
				</td>
			</tr> 
		</table>
		<cf_popup_box_footer>
			<table style="text-align:right;">
				<tr>
					<td>
						<input type="button" value="Düzenle" onClick="gondert();">
					</td>
				</tr>
			</table>
		</cf_popup_box_footer>
	</form>
</cf_popup_box>
<script type="text/javascript">
	document.flash_.code_editing.value = opener.html_edit.textEdit.document.body.innerHTML;
</script>
