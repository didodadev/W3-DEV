<cfparam name="attributes.sal_mon" default="1"> 
<cfparam name="attributes.ins_period" default="1">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Taksitli Avans Talebi','31574')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_kesinti" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_add_kesinti_taksitli" onsubmit="return (unformat_fields());">
			<input type="hidden" name="odkes_id" id="odkes_id" value="">
			<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
			<input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#attributes.in_out_id#</cfoutput>">
			<input type="hidden" name="is_inst_avans" id="is_inst_avans" value="1">
			<input type="hidden" name="periyod_get" id="periyod_get" value="">
			<input type="hidden" name="method_get" id="method_get" value="">
			<input type="hidden" name="from_salary" id="from_salary" value="">
			<input type="hidden" name="show" id="show" value="">
			<input type="hidden" name="term" id="term" value="">
			<input type="hidden" name="start_sal_mon" id="start_sal_mon" value="">
			<input type="hidden" name="end_sal_mon" id="end_sal_mon" value="">
			<input type="hidden" name="calc_days" id="calc_days" value="">
			<input type="hidden" name="money" id="money" value="">
			<cf_box_elements>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="form-group" id="item-comment_get">
						<label class="col col-4 col-xs-12"><cf_get_lang  dictionary_id="54339.Avans Tipi"> *</label>        
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="text" name="comment_get" id="comment_get" value="" >  
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_list_kesinti_taksitli')"> </span>  
							</div>
						</div>
					</div>
					<div class="form-group" id="item-sal_mon">
						<label class="col col-4 col-xs-12"><cf_get_lang  dictionary_id="53132.Başlangıç Ay"></label>     
						<div class="col col-8 col-xs-12">
							<select name="sal_mon" id="sal_mon" >
								<cfloop from="1" to="12" index="i">
									<cfoutput><option value="#i#" <cfif attributes.sal_mon is i>selected</cfif> >#listgetat(ay_list(),i,',')#</option></cfoutput>
								</cfloop>
							</select>
						</div>  
					</div>
					<div class="form-group" id="item-detail">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57629.Açıklama"></label>     
						<div class="col col-8 col-xs-12">
							<textarea name="detail" id="detail" style="width:150px;height:50px;"></textarea> 
						</div>  
					</div>
					<div class="form-group" id="item-toplam_tutar">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="29534.Toplam Tutar"></label>     
						<div class="col col-8 col-xs-12">
							<input type="text" name="toplam_tutar" id="toplam_tutar" class="moneybox" value=""  onBlur="hesapla();">
						</div>  
					</div>
					<div class="form-group"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="54064.Taksit Sayısı"></label>     
						<div class="col col-8 col-xs-12">
							<input type="number" name="ins_period" id="ins_period" onblur="tutar_göster(this.value);" value="<cfoutput>#attributes.ins_period#</cfoutput>" max="99" min="1" required="required" style="width:150px;" />
						</div>  
					</div>
					<div class="form-group" id="tutar0">
						<label class="col col-4 col-xs-12"><cf_get_lang  dictionary_id="54340.Taksit"><cfoutput>1</cfoutput></label>     
						<div class="col col-8 col-xs-12">
							<input type="text" name="amount_get0" id="amount_get0" class="moneybox" value=""  onkeyup="return(FormatCurrency(this,event));">
						</div>  
					</div>
					<cfloop from="1" to="98" index="i">
						<div class="form-group"  id="tutar<cfoutput>#i#</cfoutput>" style="display:none;">
							<label class="col col-4 col-xs-12"><cf_get_lang  dictionary_id="54340.Taksit"><cfoutput>#evaluate(i+1)#</cfoutput></label>     
							<div class="col col-8 col-xs-12">
								<input type="text" name="amount_get<cfoutput>#i#</cfoutput>" id="amount_get<cfoutput>#i#</cfoutput>" class="moneybox" value=""  onkeyup="return(FormatCurrency(this,event));">
							</div>  
						</div>
					</cfloop>
					<div class="form-group" id="item-money_type">
						<label class="col col-4 col-xs-12"><cf_get_lang  dictionary_id="57489.Para Birimi"></label>     
						<div id="money_td"> </div>  
					</div>
				</div>
		</cf_box_elements>
		<cf_box_footer><cf_workcube_buttons is_upd='0' is_delete='0' add_function='kontrol()'></cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function add_row(from_salary, show, comment_pay, period_pay, method_pay, term, start_sal_mon, end_sal_mon, amount_pay, calc_days,odkes_id,money_type)
	{
		document.add_kesinti.odkes_id.value=odkes_id;
		document.add_kesinti.from_salary.value=from_salary;
		document.add_kesinti.show.value=show;
		document.add_kesinti.comment_get.value=comment_pay;
		document.add_kesinti.periyod_get.value=period_pay;
		document.add_kesinti.method_get.value=method_pay;
		document.add_kesinti.term.value=term;
		document.add_kesinti.start_sal_mon.value=start_sal_mon;
		document.add_kesinti.end_sal_mon.value=end_sal_mon;
		document.add_kesinti.toplam_tutar.value=amount_pay;
		document.add_kesinti.amount_get0.value=amount_pay;
		document.add_kesinti.calc_days.value=calc_days;
		document.add_kesinti.money.value=money_type;
		document.getElementById('money_td').innerHTML = money_type;
		return true;
	}
	function tutar_göster(number)
	{
		if (document.add_kesinti.comment_get.value == '')
		{
			alert('<cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="54339.Avans Tipi">');
			document.add_kesinti.ins_period.value=1;
			return false;
		}	
		if(document.getElementById('toplam_tutar').value != "" && document.getElementById('ins_period').value)
		{
			fiyat= document.add_kesinti.toplam_tutar.value;
			fiyat = filterNum(fiyat);
			taksit_sayisi = number;
			taksit= fiyat / taksit_sayisi;
			taksit =  commaSplit(taksit);
			for (i=0;i<=number;i++)
			{
				eleman = eval('tutar'+i);
				eleman.style.display = '';
				deger = eval("document.add_kesinti.amount_get"+i);
				deger.value = taksit;
			}
			for (i=number;i<99;i++)
			{
				eleman = eval('tutar'+i);
				eleman.style.display = 'none';
			}
		}
	}
	function hesapla()
	{
		if(document.getElementById('toplam_tutar').value != "" && document.getElementById('ins_period').value)
		{
			fiyat= document.add_kesinti.toplam_tutar.value;
			fiyat = filterNum(fiyat);
			taksit_sayisi = document.add_kesinti.ins_period.value;
			taksit= fiyat / taksit_sayisi;
			taksit =  commaSplit(taksit);
			for (i=0;i<=document.add_kesinti.ins_period.value-1;i++)
			{
				deger = eval("document.add_kesinti.amount_get"+i);
				deger.value = taksit;
			}
		}
	}
	function kontrol()
	{
		if (document.add_kesinti.comment_get.value =="")
		{
			alert('<cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="54339.Avans Tipi">');
			return false;
		}
		if (document.add_kesinti.toplam_tutar.value == "")
		{
			alert('<cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="57673.Tutar">');
			return false;
		}
		if (document.getElementById('ins_period').value == "")
		{
			alert('<cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="54064.Taksit Sayısı">');
			return false;
		}
		return true;
	}
	function unformat_fields()
	{
		for(r=0;r<=add_kesinti.ins_period.value;r++)
		{
			eval('add_kesinti.amount_get' + r).value = filterNum(eval('add_kesinti.amount_get' + r).value,4);
		}
		add_kesinti.toplam_tutar.value = filterNum(add_kesinti.toplam_tutar.value,4);
		return true;
	}
</script>

