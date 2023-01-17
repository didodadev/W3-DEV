<cfset ay_basi_ = createodbcdatetime(createdate(year(now()),month(now()),1))>
<cfset gun_sayisi = daysinmonth(ay_basi_)>
<cfset ay_sonu_ = createodbcdatetime(createdate(year(now()),month(now()),gun_sayisi))>
<cfparam name="attributes.startdate" default="#ay_basi_#">
<cfparam name="attributes.finishdate" default="#ay_sonu_#">
<cfparam name="attributes.company_cats" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company_ids" default="">

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="rapor" method="post" action="">
			<input type="hidden" name="is_submit" value="1"/>
			<cf_box_elements>
				<div class="col col-12 col-md-4 col-sm-12" type="column" index="1" sort="true">
					<div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-is_standart_ff">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<input type="checkbox" name="is_standart_ff" value="1" checked="checked"/><cf_get_lang dictionary_id='33928.Fiyat Farkı'>
						</label>
					</div>
					<div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-is_purchase_sale">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<input type="checkbox" name="is_purchase_sale" value="1" checked="checked"/><cf_get_lang dictionary_id='32677.Alış Satış'>
						</label>
					</div>
					<div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-is_cash_out">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<input type="checkbox" name="is_cash_out" value="1" checked="checked"/><cf_get_lang dictionary_id='61502.Kasa Çıkış'>
						</label>
					</div>
					<div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-is_ciro">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<input type="checkbox" name="is_ciro" value="1" checked="checked"/><cf_get_lang dictionary_id='61883.Ciro Primi'> 
						</label>
					</div>
					<div class="form-group col col-4 col-md-1 col-sm-6 col-xs-12" id="item-is_clear_old_rows">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<input type="checkbox" name="is_clear_old_rows" value="1"/><cf_get_lang dictionary_id='61884.Verilen Aralıktaki Kayıtları Sil'>
						</label>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-company_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
						<div class="col col-6 col-sm-12">
							<div class="input-group">
								<input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
								<input type="text" name="company" id="company" style="width:200px;" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>">
								<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=rapor.company&field_comp_id=rapor.company_id&select_list=2','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></span>
							</div>
						</div>
						<div class="col col-2 col-sm-12">
							<a href="javascript://" onclick="add_c_row_new();"><i class="fa fa-plus"></i></a>
						</div>
					</div>
					<div class="form-group" id="item-date">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
						<div class="col col-4 col-sm-12">
							<div class="input-group">
								<cfinput type="text" name="startdate" style="width:65px;" value="#dateformat(attributes.startdate,'dd/mm/yyyy')#" validate="eurodate" message="Başlangıç Tarihi !" maxlength="10" required="yes">
								<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
							</div>
						</div>
						<div class="col col-4 col-sm-12">
							<div class="input-group">
								<cfinput type="text" name="finishdate" style="width:65px;" value="#dateformat(attributes.finishdate,'dd/mm/yyyy')#" validate="eurodate" message="Bitiş Tarihi!" maxlength="10" required="yes">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span> 
							</div>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons add_function="kontrol()">
			</cf_box_footer>
			<div id="product_div"></div>
		</cfform>
	</cf_box>
</div>	


<script>
company_added = 0;
function kontrol()
{
	if(document.getElementById('company').value != '')
	{
		add_c_row_new();
	}
	
	if(company_added == 0)
	{
		if(confirm('Tüm Tedarikçiler İçin Dönemsel İşlem Çalıştırıyorsunuz! Emin misiniz?'))
		{
			//nothing	
		}	
		else
			return false;
	}
	return true;	
}
function add_c_row_new()
{
	cid_ = document.getElementById('company_id').value;	
	cname_ = document.getElementById('company').value;
	
	if(cid_ == '' || cname_ == '')
	{
		alert('Tedarikçi Seçmediniz!');
		return false;	
	}
	add_c_row(cid_,cname_);
}

function add_c_row(cid_,cname_)
{
	icerik_ = '<div id="selected_product_' + cid_ + '">';
	icerik_ += '<a href="javascript://" onclick="del_row_p(' + cid_ +')">';
	icerik_ += '<img src="/images/delete_list.gif">';
	icerik_ += '</a>';
	icerik_ += '<input type="hidden" name="company_ids" value="' + cid_ + '">';
	icerik_ += cname_;
	icerik_ += '</div>';
	
	$('#product_div').append(icerik_);
	
	company_added = company_added + 1;
	document.getElementById('company_id').value = '';
	document.getElementById('company').value = '';
}

function del_row_p(cid_)
{
	$("#selected_product_" + cid_).remove();
	company_added = company_added - 1;	
}
</script>