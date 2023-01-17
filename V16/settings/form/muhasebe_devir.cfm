<cf_xml_page_edit fuseact="settings.muhasebe_devir">
<cfquery name="get_period" datasource="#dsn#">
	SELECT PERIOD_ID, PERIOD FROM SETUP_PERIOD WHERE PERIOD_YEAR <= #year(now())+1#
</cfquery>
<cfquery name="get_companies" datasource="#dsn#">
	SELECT 
    	COMP_ID, 
        COMPANY_NAME
    FROM 
	    OUR_COMPANY 
</cfquery>
<cfif not isdefined("attributes.hedef_period")>
	<cf_box title="#getLang('','Muhasebe Dönem Açılış Fişi','42353')#">
		<cfform name="close_ch" method="post" action="#request.self#?fuseaction=settings.emptypopup_muhasebe_devir" enctype="multipart/form-data">
			<cf_box_elements>
				<div class="col col-5 col-md-5 col-sm-5 col-xs-12">
					<div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52273.Muhasebe Dönemi'></label>            
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
								<select name="hedef_period_1" id="hedef_period_1" style="width:200px;" onchange="show_periods_departments()">
									<option value=""><cf_get_lang dictionary_id='54096.Şirket Seçiniz'></option>
									<cfoutput query="get_companies">
										<option value="#comp_id#">#COMPANY_NAME#</option>
									</cfoutput>
								</select>
							</div>
							<div class="col col-4 col-md-6 col-sm-6 col-xs-12" id="period_div">
								<select name="period" id="period" style="width:220px;">
								</select>
							</div>
                        </div>    
                    </div> 
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'></label>            
                        <div class="col col-4 col-md-8 col-sm-8 col-xs-12">
							<cfquery name="get_acc_card_type" datasource="#dsn3#">
								SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14) ORDER BY PROCESS_TYPE
							</cfquery>
							<cf_multiselect_check
							name="acc_card_type"
							option_name="process_cat"
							option_value="process_cat_id"
							width="200"
							query_name="get_acc_card_type">
                        </div>           
                    </div>
					<cfif is_account_filter eq 1>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>            
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12">          
								<div class="input-group">
									<cfinput type="text" name="acc_code_1" value="" onFocus="AutoComplete_Create('acc_code_1','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'1\',0','','','form','3','250');">
									<span class="input-group-addon icon-ellipsis" onclick="pencere_ac('close_ch.acc_code_1')"></span>
									<cfinput type="text" name="acc_code_2" value="" onFocus="AutoComplete_Create('acc_code_2','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'1\',0','','','form','3','250');">
									<span class="input-group-addon icon-ellipsis" onclick="pencere_ac('close_ch.acc_code_2')"></span>
								</div>
							</div>            
						</div>
					</cfif>
					<div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43272.Dosyadan Aktar'></label>            
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">   
								<input type="file" name="muhasebe_file" id="muhasebe_file">
							</div>
                        </div>    
                    </div>
					<cfif is_account_filter eq 1>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='868.Oluşmuş Açılış Fişini Güncelle'></label>            
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">   
									<input type="checkbox" name="is_update_old_fis" id="is_update_old_fis" value="1">
								</div>
							</div>    
						</div>
					</cfif>
					<div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43270.Dönemden Aktar'></label>            
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">   
								<input type="checkbox" name="is_from_donem" id="is_from_donem" value="1">
							</div>
                        </div>    
                    </div>
					<div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="47401.İşlem Dövizi Bazında"></label>            
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">   
								<input type="checkbox" name="is_other_money" id="is_other_money" value="1">
							</div>
                        </div>    
                    </div>
					<div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="39350.Şube Bazında"></label>            
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">   
								<input type="checkbox" name="is_branch" id="is_branch" value="1">
							</div>
                        </div>    
                    </div>
					<div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="47553.Departman Bazında"></label>            
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">   
								<input type="checkbox" name="is_department" id="is_department" value="1">
							</div>
                        </div>    
                    </div>
					<div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="29819.Proje Bazında"></label>            
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">   
								<input type="checkbox" name="is_project" id="is_project" value="1">
							</div>
                        </div>    
                    </div>					
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" >
					<div class="form-group">
                        <label><b><cf_get_lang dictionary_id='57433.Yardım'></b></label>                
                    </div>
                    <div class="form-group">
						<cf_get_lang_main no='2309.Dosya uzantısı csv olmalı kaydedilirken karakter desteği olarak UTF-8 seçilmelidir Alan araları noktalı virgül(;) ile ayrılmalı sayısal değerler için nokta ayrac olarak kullanılmalıdır'><br/><br/>
						<cf_get_lang no='1290.Dosya Satır Formatı'> : <cf_get_lang no='2936.Hesap Kodu;B/A;Tutar (float);Sistem İkinci Döviz Birimi;Diğer Döviz Tutarı (float);Diğer Döviz Birimi şeklinde olmalıdır'><br/>
						<cf_get_lang no='2937.Dosya satırlarında Sistem İkinci Döviz Birimi, Diğer Döviz Tutarı veya Diğer Döviz Birimi bilgilerinden verilmeyecek olanların yerine 0(sıfır) yazılmalıdır'><br/><br/>
						<cf_get_lang no='2938.Dosyadaki kusuratlı tutarlar '' olarak belirtilmelidir'><br/><br/>
						<cf_get_lang no='2939.Eğer dönemden aktar seçerseniz; seçtiğiniz dönemin mevcut bakiyeleri ilgili şirketin o dönemden sonraki ilk dönemine aktarılır'><br/><br/>
						<cf_get_lang no='2940."İşlem Döviz Aktar" seçeneği sadece dönemden yapılan aktarımlarda çalıştırılabilir İşlem dövizli aktarım yapıldıgında hesabın diger döviz bakiyeleri de yeni döneme aktarılır'><br/><br/>
						<cf_get_lang no='2941.Eğer dosyadan aktar seçerseniz; seçtiğiniz dönem için açılış fişi dosyanıza uygun olarak yeniden düzenlenecektir'><br/><br/>
						<cf_get_lang no='2942.Dosyada "Sistem İkinci Döviz Birimi" belirtilmişse, açılış fişi kaydedilecek dönemdeki kura göre sistem ikinci döviz bakiyesi hesaplanacaktır'><br/><br/>
						<cf_get_lang no='2943.Dosyada belirtilen hesap kodlarının açılış fişinin kaydedileceği dönemde tanımlı birer alt hesap olması gerekiyor'><br/><br/><br/>
					</div> 
                    <div class="form-group">
                        <cf_get_lang no='2352.Örnek Dosya Formatı'>:<br/>
							100.01;A;100;USD;0;0;<br/>
							100.02;A;25.70;USD;10;EURO<br/>
							120.01;B;125.70;USD;0;0<br/>
                    </div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_box_footer>  
		</cfform>
	</cf_box>
</cfif>

<script type="text/javascript">
	function pencere_ac(str_alan)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=' + str_alan + '&field_id2=' + str_alan + '&keyword=' + eval(str_alan + ".value"),'list');
	}

	function kontrol()
	{
		if(document.close_ch.period.value == '')
		{
			alert("<cf_get_lang no='1291.Dönem Seçmelisiniz'>!");
			return false;
		}
		if((document.close_ch.is_from_donem.checked == false) && (document.close_ch.muhasebe_file.value == ''))
		{
			alert("<cf_get_lang no='1291.Dönem Seçmelisiniz'>!");
			return false;
		}
		if (confirm("<cf_get_lang no='1295.Seçtiğiniz dönemdeki muhasebe hesaplarını yeni döneme aktarmak üzeresiniz.'>")) 
			return true; 
		else 
			return false;
	}
	/* $(document).ready(function(){
		var company_id = document.getElementById('item_company_id').value;
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
		AjaxPageLoad(send_address,'hedef_period_1',1,'Dönemler');
	}); */
	function show_periods_departments()
	{
		if(document.getElementById('hedef_period_1').value != '')
		{
			var company_id = document.getElementById('hedef_period_1').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'period',1,'Dönemler');
		}else document.getElementById('period').innerHTML = "<option value=''><cf_get_lang dictionary_id='39035.Dönem Seçiniz'></option>";
	}
</script>
