 <script type="text/javascript">
	function olustur()
	{
		window.location.href='<cfoutput>#request.self#?fuseaction=settings.add_helpdesk_to_xml&db_name=DSN</cfoutput>';
	}
</script>
<cf_box title="#getlang('','Help Desk İçerik Aktarımı','42262')#">
	<form method="POST" enctype="multipart/form-data" action="<cfoutput>#request.self#?fuseaction=settings.add_helpdesk_info_act</cfoutput>" name="hlp_dsk" id="hlp_dsk">
	<cf_box_elements>
	<div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
		<div class="form-group" id="item-document">
			<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='29485.Döküman'> *</label>
			<div class="col col-8 col-sm-12">
				<input type="FILE" name="asset" id="asset">
			</div>
		</div>
	</div>
</cf_box_elements>
	<cf_box_footer>
		<cf_workcube_buttons is_upd='0' extraButtonClass="ui-wrk-btn ui-wrk-btn-extra" extraFunction="olustur()" extraButton="1" extraButtonText="#getlang('','XML Belgesi Oluştur','42265')#">
	</cf_box_footer>
</form>
</cf_box>

<script type="text/javascript">
function doldur()
{
	if(document.hlp_dsk.ad.asset=='')
	{
		alert("<cf_get_lang dictionary_id ='43875.Ad ve Soyad Alani Bos Birakilamaz'>");
		return false;
	}	
}
</script>
