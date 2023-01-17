<link rel="stylesheet" type="text/css" href="/wbp/retail/files/js/jqwidgets/jqwidgets/styles/jqx.base.css" />
<link rel="stylesheet" type="text/css" href="/wbp/retail/files/js/jqwidgets/jqwidgets/styles/jqx.energyblue.css" />
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxcore.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxdata.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxbuttons.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxscrollbar.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxmenu.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.edit.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>

<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.selection.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.columnsresize.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.columnsreorder.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.filter.js"></script>

<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxnumberinput_new.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxinput.js"></script>

<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxlistbox.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxcheckbox.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxtooltip.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxdropdownlist.js"></script>


<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.grouping.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.aggregates.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/scripts/demos.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/demos/jqxgrid/localization.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
   
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/globalization/globalize.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/demos/jqxgrid/localization.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/globalization/globalize.culture.tr-TR.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>

<cfparam name="attributes.startdate" default="#dateadd('d',-15,now())#">
<cfparam name="attributes.finishdate" default="#now()#">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='61705.Fon Yönetimi'></cfsavecontent>
	<cf_box title="#head#">
		<cfform action="" method="post" name="search_cash">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-fon_management">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61704.İşlem Tarihleri'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<cfinput type="text" name="startdate" value="#dateformat(attributes.startdate,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:65px;">
								<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
							</div>
						</div>	
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:65px;">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
							</div>
						</div>
						<div class="col col-8 col-sm-12">
                            <select name="count_type" id="count_type" onchange="getir();">
								<option value="d"><cf_get_lang dictionary_id='58457.Günlük'></option>
								<option value="w"><cf_get_lang dictionary_id='58458.Haftalık'></option>
								<option value="m"><cf_get_lang dictionary_id='58932.Aylık'></option>
								<option value="y"><cf_get_lang dictionary_id='29400.Yıllık'></option>
							</select>
                        </div>
					</div>
				</div>
				<div id="fon_inner_div"></div>
			</cf_box_elements>	
			<cf_box_footer>
				<input type="button" value="Hesapla" onclick="getir();"/>
				<input type="button" value="Excel" onclick="get_excel();"/>
            </cf_box_footer>
		</cfform>
	</cf_box>
</div>


<script>
function get_excel()
{
	try
	{
		grid_duzenle();
		$("#jqxgrid").jqxGrid('exportdata', 'xls', 'Fon Yönetimi');
	}
	catch(e)
	{
		alert('Önce Ekran Hesaplamasını Yapınız!');
	}
}
function getir()
{
	if(document.getElementById('startdate').value == '')
	{
		alert('Başlangıç Tarihi Seçiniz!');
		return false;	
	}	
	
	if(document.getElementById('finishdate').value == '')
	{
		alert('Bitiş Tarihi Seçiniz!');
		return false;	
	}
	
	adres = '<cfoutput>#request.self#?fuseaction=retail.emptypopup_fon_management_inner</cfoutput>';
	adres = adres + '&startdate=' + document.getElementById('startdate').value;
	adres = adres + '&finishdate=' + document.getElementById('finishdate').value;
	adres = adres + '&count_type=' + document.getElementById('count_type').value;
	AjaxPageLoad(adres,'fon_inner_div',1);
}
</script>