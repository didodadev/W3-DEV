<style>
.iysHeader{
	padding: 10px 6px 0px 20px;
}
.gainsboro{
	color:gainsboro;
}
.blue{
	color:blue;
}
.forestgreen{
	color:forestgreen;
}
</style>
<div class="col col-12 text-left pageHeader font-green-haze iysHeader">
	<span class="pageCaption font-green-sharp bold"><cf_get_lang dictionary_id='952.İleti Yönetim Sistemi (IYS)'></span>
    <div id="pageTab" class="pull-right">
		<a onclick="showHideMessageField()" href="javascript:;" class="ui-wrk-btn ui-wrk-btn-success"><cf_get_lang dictionary_id='953.İzin Verileri Güncelleme Sihirbazı'></a>
		<a onclick="showHideMessageDownloadField()" href="javascript:;" class="ui-wrk-btn ui-wrk-btn-warning"><cf_get_lang dictionary_id='954.İzinli İletileri Excele Export Et'></a>
	</div>
</div>
<div class="row">
	<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
		<cf_box id="project_summary_1" closable="0" title="#getlang('','Kurumsal Muhataplar',955)#" box_page="V16/correspondence/display/message_permission_stats.cfm?type=1"></cf_box>
	</div>
	<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
		<cf_box id="project_summary_2" closable="0" title="#getlang('','Bireysel Muhataplar',956)#" box_page="V16/correspondence/display/message_permission_stats.cfm?type=2"></cf_box>
	</div>
	<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
		<cf_box id="project_summary_3" closable="0" title="#getlang('','Çalışan Adayları',957)#" box_page="V16/correspondence/display/message_permission_stats.cfm?type=3"></cf_box>
	</div>
</div>
<div class="row hide" id="messageField">
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box id="project_summary_4" closable="0" title="#getlang('','İzin Verileri Güncelleme Sihirbazı',953)#"></cf_box>
	</div>
</div>
<div class="row hide" id="messageDownloadField">
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box id="project_summary_5" closable="0" title="#getlang('','Export',59097)#"></cf_box>
	</div>
</div>
<script type="text/javascript">
	function showHideMessageField(){
		$("#messageField").removeClass('hide').addClass('show');
		refresh_box('project_summary_4','V16/correspondence/display/message_permission_stats.cfm?type=4','0');
	}
	function showHideMessageDownloadField(){
		//$("#messageDownloadField").removeClass('hide').addClass('show');
		refresh_box('project_summary_5','V16/correspondence/display/message_permission_stats.cfm?type=5','0');
	}
	function savePermissions(permissionType){
		permissionData = $("#add_permissions"+permissionType).serialize();
		refresh_box('project_summary_4','V16/correspondence/display/message_permission_stats.cfm?type=6&permissionType='+permissionType+'&'+permissionData,'0');
	}
</script>