<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Yazar Kasa Aktarım İzleme Ekranı',62243)#">
		<cf_box_elements>
			<div class="form-group">
				<div id="hareket_on"></div>
				<div id="hareket_arka" style="display:none;"></div>
			</div>
		</cf_box_elements>
	</cf_box>
</div>

<script>
function run_g_action()
{
	AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_genius_action_watch_screen','hareket_arka');
	setTimeout(function(){run_g_action();},3000);	
}
run_g_action();
</script>