<cfsetting showdebugoutput="no">
<cf_box title='Dosya Ekle' id='attach_folder_box' style="width:100%;height:20%;">
	<table id="table1">
		<tr><td><input type="hidden" name="attachment_count" id="attachment_count" value="10"></td></tr>
		<tr><td><fieldset style="background-color:F1F5F6"><cf_workcube_multiple_file></fieldset></td></tr>
		<tr><td colspan="2" style="text-align:right;"><input type="button" name="attach_reduce" value="Ok" onclick="attach_reduce_close();"></td></tr>
	</table>
</cf_box>
<script type="text/javascript">
	function attach_reduce_close()
	{
		document.getElementById('attach_folder_box').style.display='none';
	}
</script>
