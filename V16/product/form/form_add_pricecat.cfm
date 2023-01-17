<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
	SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1
</cfquery>
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT WHERE IS_ACTIVE = 1 ORDER BY CONSCAT
</cfquery>
<!--- coklu sube secimi icin eklendi --->
<cfparam name="is_multi_branch" default="0">
<cf_xml_page_edit fuseact="product.form_add_pricecat">
<cfinclude template="../query/get_branch.cfm">
<!--- <cf_catalystHeader> --->
    <cf_box title="#getLang('','Fiyat Listeleri',37028)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform name="form_add_pricecat" method="post" action="#request.self#?fuseaction=product.add_pricecat">
<input type="hidden" name="is_multi_branch" id="is_multi_branch" value="<cfoutput>#is_multi_branch#</cfoutput>"> 
<cf_box_elements>
    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="false">                    	
        <label class="col col-12 bold"><cf_get_lang dictionary_id='37140.Yayın Alanı'></label>    
        <ul class="ui-list">
            <li>
                <a href="javascript:void(0)">
                    <div class="ui-list-left">
                        <span class="ui-list-icon ctl-collaboration"></span>
                        <cf_get_lang dictionary_id='29408.Kurumsal Üyeler'>
                    </div>
                    <div class="ui-list-right">
                        <i class="fa fa-chevron-down"></i>
                    </div>
                </a>
                <ul>
                            <li>
                                <a href="javascript:void(0)">
                                    <div class="ui-list-left">
                                        <span class="ui-list-icon ctl-maps-and-flags-3"></span>
                                        <cf_get_lang dictionary_id='37814.Hepsini Seç'>
                                    </div>
                                    <div class="ui-list-right">
                                        <input type="checkbox" name="all_company_cat" id="all_company_cat" value="1" onclick="wrk_select_all('all_company_cat','company_cat')">
                                    </div>
                                </a>
                               </li>
                            <li>
                    <cfoutput query="get_company_cat">
                            <a href="javascript:void(0)">
                                <div class="ui-list-left">
                                    <span class="ui-list-icon ctl-collaboration"></span>
                                    #companycat#
                                </div>
                                <div class="ui-list-right">
                                    <input type="checkbox" name="company_cat" id="company_cat" value="#companycat_id#">
                                   
                                </div>
                            </a>
                           </li>
                    </cfoutput>
                 
                </ul>
            </li>
            <li>
                <a href="javascript:void(0)">
                    <div class="ui-list-left">
                        <span class="ui-list-icon ctl-network-1"></span>
                        <cf_get_lang dictionary_id='29406.Bireysel Üyeler'>
                    </div>
                    <div class="ui-list-right">
                        <i class="fa fa-chevron-down"></i>
                    </div>
                </a>
                <ul>
                            <li>
                                <a href="javascript:void(0)">
                                    <div class="ui-list-left">
                                        <span class="ui-list-icon ctl-maps-and-flags-3"></span>
                                        <cf_get_lang dictionary_id='37814.Hepsini Seç'>
                                    </div>
                                    <div class="ui-list-right">
                                        <input type="checkbox" name="all_consumer_cat" id="all_consumer_cat" value="1" onclick="wrk_select_all('all_consumer_cat','consumer_cat')">                                    </div>
                                </a>
                               </li>
                            <li>
                                <cfoutput query="get_consumer_cat">
                            <a href="javascript:void(0)">
                                <div class="ui-list-left">
                                    <span class="ui-list-icon ctl-network-1"></span>
                                    #conscat#
                                </div>
                                <div class="ui-list-right">
                                    <input type="checkbox" name="consumer_cat" id="consumer_cat" value="#conscat_id#">
                                </div>
                            </a>
                           </li>
                    </cfoutput>
                 
                </ul>
            </li>
            <li>
                <a href="javascript:void(0)">
                    <div class="ui-list-left">
                        <span class="ui-list-icon ctl-banks"></span>
                        <cf_get_lang dictionary_id='29434.Şubeler'>
                    </div>
                    <div class="ui-list-right">
                        <i class="fa fa-chevron-down"></i>
                    </div>
                </a>
                <ul>
                <li>
                    <a href="javascript:void(0)">
                        <div class="ui-list-left">
                            <span class="ui-list-icon ctl-maps-and-flags-3"></span>
                            <cf_get_lang dictionary_id='37814.Hepsini Seç'>
                        </div>
                        <div class="ui-list-right">
                            <input type="checkbox" name="all_branch" id="all_branch" value="1" onclick="wrk_select_all('all_branch','branch')">                                  
                            </div>
                    </a>
                    </li>
                <li>
                    <cfoutput query="get_branch">
                <a href="javascript:void(0)">
                    <div class="ui-list-left">
                        <span class="ui-list-icon ctl-banks"></span>
                        #branch_name#
                    </div>
                    <div class="ui-list-right">
                        <input type="checkbox" value="#branch_id#" name="branch" id="branch">
                    </div>
                </a>
                </li>
        </cfoutput>
                </ul>
            </li>
        </ul>
    </div>       
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                    	<div class="row">
                            <div class="col col-12">
                                <div class="form-group" id="item-is_purchase">
                                    <label class="col col-4" class="hide"><cf_get_lang dictionary_id='59088.Tip'></label>
                                    <label class="col col-4"><cf_get_lang dictionary_id='58176.Alış'><input type="checkbox"  name="is_purchase" id="is_purchase" value="1"></label>
                                    <label class="col col-4"><cf_get_lang dictionary_id='57448.Satış'><input type="checkbox"  name="is_sales" id="is_sales" value="1"></label>
                                </div>
                                <div class="form-group" id="item-price_cat">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37144.Liste Adı'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput name="price_cat" type="text" value="" maxlength="100">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col col-12">
                            	<div class="form-group" id="item-label_price">
                                	<label class="col col-12 bold"><cf_get_lang dictionary_id='37145.Fiyatlandırma Yöntemi'></label>
                                </div>
                            	<div class="form-group" id="item-target_margin">
                                	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37819.Düzenleme Oranı'> (+/-)</label>
                                    <div class="col col-8 col-xs-12">
                                            <div class="col col-5 col-xs-12">
											<cfinput type="text" name="margin" value="" validate="float">
                                        </div>
                                        <div class="col col-7 col-xs-12">
                                            <select name="target_margin" id="target_margin" style="width:180px;">
                                                <option value="-5" selected><cf_get_lang dictionary_id ='37083.Son Alış Fiyatı'></option>
                                                <option value="-4"><cf_get_lang dictionary_id ='37816.Ortalama Alış Fiyatı'></option>
                                                <option value="-3"><cf_get_lang dictionary_id ='37817.Maliyet Fiyatı'></option>
                                                <option value="-1"><cf_get_lang dictionary_id ='37818.Standart Alış Fiyatı'></option>
                                                <option value="-2"><cf_get_lang dictionary_id ='37600.Standart Satış Fiyatı'></option>
                                                <cfoutput query="get_price_cat">
                                                    <option value="#price_catid#">#price_cat#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-is_price_from_category">
                                	<label class="col col-4"><cf_get_lang dictionary_id='38007.Ürün Kategori Marjından Hesapla'></label>
                                        <label class="col col-8"><input type="checkbox" name="is_price_from_category" id="is_price_from_category" value="1"></label>
                                </div>
                                <div class="form-group" id="item-start_date">
                                	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                                    <div class="col col-8 col-xs-12">
                                    	<div class="input-group">
                                            <cfinput type="text" name="startdate" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" style="width:65px;">
											<span class="input-group-addon btnPointer">
                                            	<cf_wrk_date_image date_field="startdate">
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-rounding">
                                	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57710.Yuvarlama'></label>
                                    <div class="col col-8 col-xs-12">
                                    	<select name="ROUNDING" id="ROUNDING">
                                            <cfloop from="0" to="3" index="round_no">
                                                <cfoutput>
                                                    <option value="#round_no#">#round_no#</option>
                                                </cfoutput>
                                            </cfloop>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-is_kdv">
                                	<label class="col col-4"><cf_get_lang dictionary_id='37365.KDV Dahil'></label>
                                        <label class="col col-8"><input type="checkbox" name="IS_KDV" id="IS_KDV" value=""></label>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col col-12">
                            	<div class="form-group" id="item-label_due">
                                	<label class="col col-12 bold"><cf_get_lang dictionary_id='37550.Vadelendirme Yöntemi'></label>
                                </div>
                                <div class="form-group" id="item-number_of_installment">
                                	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37551.Taksit Sayısı'></label>
                                	<div class="col col-8 col-xs-12">
										<input name="number_of_installment" id="number_of_installment" type="text" value="0" onBlur="hesapla_vade();empty_due_day(1);" onKeyUp="return(FormatCurrency(this,event,0));" style="width:35px;">
                                    </div>
                                </div>
                                <div class="form-group" id="item-target_due_date">
                                	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57861.Ortalama Vade'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="col col-5 col-xs-12">
                                            <input name="avg_due_day" id="avg_due_day" readonly type="text" value="0" onKeyUp="empty_due_day(2);return(FormatCurrency(this,event,0));" style="width:35px;">
                                        </div>
                                        <div class="col col-7 col-xs-12">
                                            <div class="input-group">
                                            <cfinput type="text" name="target_due_date" validate="#validate_style#" onChange="empty_due_day(3);" style="width:65px;">
											<span class="input-group-addon btnPointer">
												<cf_wrk_date_image date_field="target_due_date">
                                            </span>
                                        </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-due_diff_value">
                                	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58501.Vade Farkı'> %</label>
                                    <div class="col col-8 col-xs-12">
                                    	<input name="due_diff_value" id="due_diff_value" type="text" value="<cfoutput>#TLFormat(0)#</cfoutput>" onKeyUp="return(FormatCurrency(this,event));" style="width:35px;">
                                    </div>
                                </div>
                                <div class="form-group" id="item-early_payment">
                                	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37608.Erken Ödeme'> %</label>
                                    <div class="col col-8 col-xs-12">
                                    	<input name="early_payment" id="early_payment" type="text" value="<cfoutput>#TLFormat(0)#</cfoutput>" onKeyUp="return(FormatCurrency(this,event));" style="width:35px;">
                                    </div>
                                </div>
                                <div class="form-group" id="item-paymethod">
                                	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
                                    <div class="col col-8 col-xs-12">
                                    	<label class="col col-12"><input type="radio" name="paymethod" id="paymethod" value="4" checked><cf_get_lang dictionary_id='58199.Kredi Kartı'></label>
                                        <label class="col col-12"><input type="radio" name="paymethod" id="paymethod" value="1"><cf_get_lang dictionary_id='58007.Çek'></label>
                                        <label class="col col-12"><input type="radio" name="paymethod" id="paymethod" value="2"><cf_get_lang dictionary_id='58008.Senet'></label>
                                        <label class="col col-12"><input type="radio" name="paymethod" id="paymethod" value="3"><cf_get_lang dictionary_id='37610.Havale'></label>
                                        <label class="col col-12"><input type="radio" name="paymethod" id="paymethod" value="6"><cf_get_lang dictionary_id='58645.Nakit'></label>
                                    	<label class="col col-12"><input type="radio" name="paymethod" id="paymethod" value="8">DBS</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
            </cf_box_elements>
            <cf_box_footer>
                	<cf_workcube_buttons is_upd='0' add_function='kontrol_2()'>
            </cf_box_footer>
</cfform>
</cf_box>
<script type="text/javascript">		
	function kontrol_2()
	{
		if(document.form_add_pricecat.is_sales.checked == false && document.form_add_pricecat.is_purchase.checked == false)
		{
			alert("<cf_get_lang dictionary_id ='38001.Alış Satış Seçeneklerinden En Az Birini Seçmelisiniz'>!")
			return false;
		}
		if(!$("#price_cat").val().length)
		{
			alert("<cfoutput><cf_get_lang dictionary_id='37405.Liste Adı girmelisiniz'> !</cfoutput>")    
			return false;
		}
		if(!$("#margin").val().length)
		{
			alert("<cfoutput><cf_get_lang dictionary_id ='37820.Düzenleme Oranı Girmelisiniz'> !</cfoutput>")    
			return false;
		}
		if(!$("#startdate").val().length)
		{
			alert("<cfoutput><cf_get_lang dictionary_id='57738.Başlangıç Tarihi girmelisiniz'> !</cfoutput>")    
			return false;
		}
		

		
		//Coklu sube secim kontrolu
		if(document.form_add_pricecat.is_multi_branch.value==0)
		{
			sayac = 0;
			if(document.form_add_pricecat.branch!= undefined && document.form_add_pricecat.branch.length != undefined)
			{
				for (i=0; i < form_add_pricecat.branch.length; i++)
				{
					if(form_add_pricecat.branch[i].checked==true)
						sayac = sayac + 1;
				}
			}		
			if(sayac > 1)
			{
					alert("<cf_get_lang dictionary_id ='37790.Yapılan Tanımdan Dolayı Listede Çoklu Şube Şeçimi Yapamazsınız'> !")
				return false;
			}
		}
		if ((document.form_add_pricecat.avg_due_day.value != '' && document.form_add_pricecat.target_due_date.value != '') || (document.form_add_pricecat.avg_due_day.value == '' && document.form_add_pricecat.target_due_date.value == ''))
		{
			alert("<cf_get_lang dictionary_id ='37792.Ortalama Vade ve Vade Tarihi alanları aynı anda boş veya dolu olamaz'> !")
			return false;
		}
		if (document.form_add_pricecat.margin.value > 10000 && document.form_add_pricecat.margin.value == '')
		{
			alert("<cf_get_lang dictionary_id ='37821.Girdiğiniz Düzenleme Oranı Yanlış! Lütfen Değiştirin'> !");
			return false;
		}
		var str_me = form_add_pricecat.number_of_installment;if(str_me!= null)str_me.value=filterNum(str_me.value);	
		var str_me = form_add_pricecat.avg_due_day;if(str_me!= null)str_me.value=filterNum(str_me.value);	
		var str_me = form_add_pricecat.due_diff_value;if(str_me!= null)str_me.value=filterNum(str_me.value);	
		var str_me = form_add_pricecat.early_payment;if(str_me!= null)str_me.value=filterNum(str_me.value);	
		return true;
	}
	function hesapla_vade()
	{
		document.form_add_pricecat.avg_due_day.value = (30+(document.form_add_pricecat.number_of_installment.value*30))/2;
	}
	function empty_due_day(deger)
	{
		if(deger==1)//taksit sayısından geliyo
			document.form_add_pricecat.target_due_date.value = '';
		else if(deger==2)//ortalama vadeden geliyorsa
			document.form_add_pricecat.target_due_date.value='';
		else if (deger==3)
		{
			document.form_add_pricecat.avg_due_day.value='';
			document.form_add_pricecat.number_of_installment.value='';
		}
	}
    $('.ui-list li a i.fa-chevron-down').click(function(){
                $(this).closest('.ui-list-right').toggleClass("ui-list-right-open");
                $(this).closest('li').find("> ul").fadeToggle();
      });
</script>
