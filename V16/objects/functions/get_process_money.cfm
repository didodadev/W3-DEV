<cfif isDefined("SESSION.EP.MONEY")>
	<cfset str_money_bskt = SESSION.EP.MONEY>
	<cfset str_money_bskt2 = SESSION.EP.MONEY2><!--- sistem 2. dvizi --->
	<cfset str_money_bskt_main = SESSION.EP.MONEY><!--- str_money_bskt aşağıda değiştirildigi için burda str_money_bskt_main diye bi değişkene set ediliyor,kaldırmayınz --->
	<cfset rate_round_num_info = session.ep.our_company_info.rate_round_num>
	<cfset int_bsk_comp_id = SESSION.EP.COMPANY_ID>
	<cfset int_bsk_period_id = SESSION.EP.PERIOD_ID>
<cfelseif isDefined("SESSION.PP.MONEY")>
	<cfset str_money_bskt = SESSION.PP.MONEY>
	<cfset str_money_bskt2 = SESSION.PP.MONEY2>
	<cfset str_money_bskt_main = SESSION.PP.MONEY>
	<cfset rate_round_num_info = session.pp.our_company_info.rate_round_num>
	<cfset int_bsk_comp_id = SESSION.PP.OUR_COMPANY_ID>
	<cfset int_bsk_period_id = SESSION.PP.PERIOD_ID>
<cfelseif isDefined("SESSION.WW.MONEY")>
	<cfset str_money_bskt = SESSION.WW.MONEY>
	<cfset str_money_bskt2 = SESSION.WW.MONEY2>
	<cfset str_money_bskt_main = SESSION.WW.MONEY>
	<cfset rate_round_num_info = session.ww.our_company_info.rate_round_num>
	<cfset int_bsk_comp_id = SESSION.WW.OUR_COMPANY_ID>
	<cfset int_bsk_period_id = SESSION.WW.PERIOD_ID>
</cfif>
<cffunction name="f_kur_ekle">
	<!---
		by : Aysenur 20060215
		notes : kur bilgisini gosterir.
		usage :
			process_type:1 upd 0 add
			action_table_name:kur bilgilerinin tutulduğu tablo
			action_table_dsn:kur bilgilerinin tutulduğu tablonun oldugu dsn
			base_value:formdaki sistem para biriminde girilen tutar input değeri
			other_money_value:formdaki diğer döviz biriminde girilen döviz tutar input değeri
			form_name:islemin yapıldıgı formun adı
			select_input:formda seçilen hesap kasa vs nin para birimi
			rate_purchase:kur degerleri alis degeri olarak gelmesi istenirse kullanilir.Default olarak 0.Bu tazr kullanımlarda 1 olarak gonderilmeli BK20100223
		orn:<cfscript>
				f_kur_ekle(process_type:0,base_value:'ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'add_gidenh');
				f_kur_ekle(action_id=attributes.id,process_type:1,base_value:'ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'upd_gidenh',action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#',select_input:'action_to_account_id');
			</cfscript>
	--->
	<cfargument name="action_id">
	<cfargument name="action_table_name">
	<cfargument name="action_table_dsn">
	<cfargument name="is_disable" default="0">
	<cfargument name="process_type" required="true">
	<cfargument name="base_value" required="true">
	<cfargument name="other_money_value" required="true">
	<cfargument name="form_name" required="true">
	<cfargument name="select_input" required="true">
	<cfargument name="rate_purchase" default="0">
	<cfargument name="selected_money" default="">
	<cfargument name="call_function" default="">
	<cfquery name="get_standart_process_money" datasource="#dsn#"><!--- muhasebe doneminden standart islem dövizini alıyor --->
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_period_id#">
	</cfquery>
	<cfif arguments.process_type eq 1>
		<cfquery name="get_money_bskt" datasource="#arguments.action_table_dsn#">
			SELECT * FROM #arguments.action_table_name# WITH (NOLOCK) WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> ORDER BY ACTION_MONEY_ID
		</cfquery>
		<cfif not get_money_bskt.recordcount>
			<cfquery name="get_money_bskt" datasource="#DSN#">
				SELECT MONEY AS MONEY_TYPE,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_comp_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_period_id#"> AND MONEY_STATUS = 1 ORDER BY MONEY_ID
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery name="get_money_bskt" datasource="#DSN#">
			SELECT MONEY AS MONEY_TYPE,RATE1,<cfif arguments.rate_purchase eq 0>RATE2<cfelse>RATE3 RATE2</cfif>,0 AS IS_SELECTED FROM SETUP_MONEY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_comp_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_period_id#"> AND MONEY_STATUS = 1 ORDER BY MONEY_ID
		</cfquery>
	</cfif>
	<cfset str_money_bskt_found = true>
	<input type="hidden" id="kur_say" name="kur_say" value="<cfoutput>#get_money_bskt.recordcount#</cfoutput>">
	<input type="hidden" id="money_type" name="money_type" value="">
	<input type="hidden" id="system_amount" name="system_amount" value="">
	<cfoutput>
	<cfif IsQuery(get_standart_process_money) and len(get_standart_process_money.standart_process_money)><!--- muhasebe doneminden standart islem dövizi işlemleri için --->
		<cfset default_basket_money_=get_standart_process_money.standart_process_money>
	<cfelseif len(str_money_bskt2)>
		<cfset default_basket_money_=str_money_bskt2>
	<cfelse>
		<cfset default_basket_money_=str_money_bskt_main>
	</cfif>
	<cfloop query="get_money_bskt">
		<cfif len(arguments.selected_money) and arguments.selected_money eq money_type>
			<cfset is_selected_ = 1>
		<cfelse>
			<cfset is_selected_ = is_selected>
		</cfif>
		<cfif is_selected_>
			<cfset sepet_rate1 = rate1>
			<cfset sepet_rate2 = rate2>
			<cfset str_money_bskt_ = money_type>
			<cfset str_money_bskt_found = false>
		<cfelseif str_money_bskt_found and money_type eq default_basket_money_>
			<cfset sepet_rate1 = rate1>
			<cfset sepet_rate2 = rate2>
			<cfset str_money_bskt_ = money_type>
			<cfset str_money_bskt_found = false>
		</cfif>
		<input type="hidden" id="hidden_rd_money_#currentrow#" name="hidden_rd_money_#currentrow#" value="#money_type#">
		<input type="hidden" id="txt_rate1_#currentrow#" name="txt_rate1_#currentrow#" value="#rate1#">
		<cfif session.ep.rate_valid eq 1>
			<cfset readonly_info = "yes">
		<cfelse>
			<cfset readonly_info = "no">
		</cfif>
		<cfif money_type eq session.ep.money>
			<input type="radio" name="rd_money" id="rd_money" <cfif arguments.is_disable eq 1>disabled</cfif> value="#currentrow#" onClick="kur_ekle_f_hesapla('#arguments.select_input#');" <cfif isDefined('str_money_bskt_') and str_money_bskt_ eq money_type>checked</cfif>>#money_type# #TLFormat(rate1,0)#/
			<input type="text" id="txt_rate2_#currentrow#" name="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> value="#TLFormat(rate2,rate_round_num_info)#" style="width:65px;" readonly=yes class="box">
			<br/>
		<cfelse>
			<input type="radio" name="rd_money" id="rd_money" <cfif arguments.is_disable eq 1>disabled</cfif> value="#currentrow#" onClick="kur_ekle_f_hesapla('#arguments.select_input#');" <cfif isDefined('str_money_bskt_') and str_money_bskt_ eq money_type>checked</cfif>>#money_type# #TLFormat(rate1,0)#/
			<input type="text" id="txt_rate2_#currentrow#" name="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> value="#TLFormat(rate2,rate_round_num_info)#" style="width:65px;" class="box" onkeyup="return(FormatCurrency(this,event,'#rate_round_num_info#'));" onBlur="if(this.value != '' && filterNum(this.value,'#rate_round_num_info#') <=0) this.value=commaSplit(1);kur_ekle_f_hesapla('#arguments.select_input#');">
			<br/>
		</cfif>
	</cfloop>
	<script type="text/javascript">
		//document.#arguments.form_name#.money_type.value='#str_money_bskt#';
		function kur_ekle_f_hesapla(select_input,doviz_tutar)
		{
			if(document.getElementById('#arguments.base_value#').value.length > 25) // maxlength ifadesi ile sağlanan kontrollerde form post edilirken sorun çıkıyordu. Tutar alanlarına girilebilecek max karakter sayısı için eklendi. SK20151111
			{
				alert("<cf_get_lang_main no='2571.Geçerli bir tutar giriniz'> !");
				document.getElementById('#arguments.base_value#').value="";
			}
			var process_cat_ = document.getElementById('process_cat').options[document.getElementById('process_cat').selectedIndex].value;
			var IS_PROCESS_CURRENCY = '';
			
			if(process_cat_ != '')
			{
				url_= '/V16/settings/cfc/processCat.cfc?method=getProcessCat';
				$.ajax({                                                                                             
					url: url_,
					dataType: "text",
					data: {process_cat: process_cat_},
					cache: false,
					async: false,
					success: function(read_data) {
						data_ = jQuery.parseJSON(read_data.replace('//',''));
						if(data_.DATA.length != 0)
						{
							$.each(data_.DATA,function(i){
								IS_PROCESS_CURRENCY = data_.DATA[i][0];		//IS_PROCESS_CURRENCY
							});
						}
					}
				});
			}
			
			if(IS_PROCESS_CURRENCY != true)
			{
				<cfif len(arguments.call_function)>#arguments.call_function#();</cfif>
				if(!doviz_tutar) doviz_tutar=false;<!--- doviz_tutar:true ise edit edilen input doviz inputu imis --->
				if(document.getElementById(select_input) == undefined || document.getElementById(select_input).value == '') return false;//eğerki kasada seçilecek hesap var ise....
				if(document.getElementById('currency_id') != undefined)
					var currency_type = document.getElementById('currency_id').value;
				else
					var currency_type = eval('document.#arguments.form_name#.'+select_input+'.options[document.#arguments.form_name#.'+select_input+'.selectedIndex]').value;
				
				var other_money_value_eleman= eval('document.#arguments.form_name#.#arguments.other_money_value#');
				var temp_act,temp_base_act,rate1_eleman,rate2_eleman;
				if(doviz_tutar && ( other_money_value_eleman.value.length==0 || filterNum(other_money_value_eleman.value)==0) )
				{<!--- formdaki doviz input edit edilmis ama bos veya sifir gonderilmisse geri donsun --->
					other_money_value_eleman.value = '';
					return false;
				}
				if(!doviz_tutar && eval('document.#arguments.form_name#.#arguments.base_value#.value') != "" && currency_type != "")
				{
					if(document.getElementById('currency_id') != undefined)
						currency_type = document.getElementById('currency_id').value;
					else
						currency_type = list_getat(currency_type,2,';');
					for(var i=1;i<=document.#arguments.form_name#.kur_say.value;i++)
					{
						rate1_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate1_' + i).value,8);
						rate2_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate2_' + i).value,8);
						if( eval('document.#arguments.form_name#.hidden_rd_money_'+i).value == currency_type)
						{
							temp_act=filterNum(document.#arguments.form_name#.#arguments.base_value#.value)*rate2_eleman/rate1_eleman;
							document.#arguments.form_name#.system_amount.value = commaSplit(temp_act,'#rate_round_num_info#');
						}
					}
					if(document.#arguments.form_name#.kur_say.value == 1)
					{
						for(var i=1;i<=document.#arguments.form_name#.kur_say.value;i++)
						{
							rate1_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate1_' + i).value,'#rate_round_num_info#');
							rate2_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate2_' + i).value,'#rate_round_num_info#');
							if( eval('document.#arguments.form_name#.rd_money.checked'))
							{
								if(eval('document.#arguments.form_name#.hidden_rd_money_'+i).value == currency_type)
									other_money_value_eleman.value = commaSplit(filterNum(document.#arguments.form_name#.#arguments.base_value#.value));
								else
									other_money_value_eleman.value = commaSplit(filterNum(document.#arguments.form_name#.system_amount.value,4)*(rate1_eleman/rate2_eleman));
								document.#arguments.form_name#.money_type.value = eval('document.#arguments.form_name#.hidden_rd_money_'+i).value;
								document.#arguments.form_name#.system_amount.value = commaSplit(filterNum(document.#arguments.form_name#.system_amount.value),'#rate_round_num_info#');
							}
						}
					}
					else
					{
						for(var i=1;i<=document.#arguments.form_name#.kur_say.value;i++)
						{
							rate1_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate1_' + i).value,'#rate_round_num_info#');
							rate2_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate2_' + i).value,'#rate_round_num_info#');
							if( eval('document.#arguments.form_name#.rd_money['+(i-1)+'].checked'))
							{
								if(eval('document.#arguments.form_name#.hidden_rd_money_'+i).value == currency_type)
									other_money_value_eleman.value = commaSplit(filterNum(document.#arguments.form_name#.#arguments.base_value#.value));
								else
									other_money_value_eleman.value = commaSplit(filterNum(document.#arguments.form_name#.system_amount.value,4)*(rate1_eleman/rate2_eleman));
								document.#arguments.form_name#.money_type.value = eval('document.#arguments.form_name#.hidden_rd_money_'+i).value;
								document.#arguments.form_name#.system_amount.value = commaSplit(filterNum(document.#arguments.form_name#.system_amount.value),'#rate_round_num_info#');
							}
						}
					}
				}
				else if(doviz_tutar && document.#arguments.form_name#.#arguments.base_value#.value != "" && currency_type != "")
				{
					for(var i=1;i<=document.#arguments.form_name#.kur_say.value;i++)
						if( eval('document.#arguments.form_name#.rd_money['+(i-1)+'].checked'))
						{
							rate1_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate1_' + i).value,'#rate_round_num_info#');
							if(document.getElementById('currency_id') != undefined)
								currency_type = document.getElementById('currency_id').value;
							else
								currency_type = list_getat(currency_type,2,';');
							if (eval('document.#arguments.form_name#.hidden_rd_money_'+i).value != '#str_money_bskt_main#')//hesap #session.ep.money# olmayıp,kurdan #session.ep.money# seçilip,döviz inputu edit edilirse #session.ep.money# kurunu değiştirmesn diye
								eval('document.#arguments.form_name#.txt_rate2_' + i).value = commaSplit(filterNum(document.#arguments.form_name#.system_amount.value)/filterNum(other_money_value_eleman.value)*rate1_eleman,'#rate_round_num_info#');
							else
								for(var t=1;t<=#arguments.form_name#.kur_say.value;t++)//hesap #session.ep.money# olmayıp,kurdan #session.ep.money# seçilip,döviz inputu edit edilirse #session.ep.money# kurunu değiştirmesn,hesabın kurunu değiştirsn diye
									if( eval('document.#arguments.form_name#.hidden_rd_money_'+t).value == currency_type && eval('document.#arguments.form_name#.hidden_rd_money_'+t).value != '#str_money_bskt_main#')
										eval('document.#arguments.form_name#.txt_rate2_' + t).value = commaSplit(filterNum(other_money_value_eleman.value)/filterNum(#arguments.form_name#.#arguments.base_value#.value)*rate1_eleman,'#rate_round_num_info#');
							if (eval('document.#arguments.form_name#.hidden_rd_money_'+i).value != '#str_money_bskt_main#')
								for(var k=1;k<=document.#arguments.form_name#.kur_say.value;k++)
								{
									rate1_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate1_' + k).value,'#rate_round_num_info#');
									rate2_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate2_' + k).value,'#rate_round_num_info#');
									if( eval('document.#arguments.form_name#.hidden_rd_money_'+k).value == currency_type)<!--- eger burada degisen kur hesabin dovizi cinsinden ise sistem dovizi #session.ep.money# tutar da degismeli--->
									{
										temp_act=filterNum(document.#arguments.form_name#.#arguments.base_value#.value)*(rate2_eleman/rate1_eleman);
										document.#arguments.form_name#.system_amount.value = commaSplit(temp_act,'#rate_round_num_info#');
									}
								}
							else
								document.#arguments.form_name#.system_amount.value = other_money_value_eleman.value;
						}
						return true;
				 }
				<cfif len(arguments.call_function)>
					#arguments.call_function#();
				<cfelse>
					document.#arguments.form_name#.#arguments.base_value#.value = commaSplit(filterNum(document.#arguments.form_name#.#arguments.base_value#.value));
				</cfif>
				return true;
			}
			else
			{
				if(document.#arguments.form_name#.kur_say.value == 1)
				{
					for(var i=1;i<=document.#arguments.form_name#.kur_say.value;i++)
						if( eval('document.#arguments.form_name#.rd_money.checked'))
							document.#arguments.form_name#.money_type.value = eval('document.#arguments.form_name#.hidden_rd_money_'+i).value;
				}
				else
				{
					for(var i=1;i<=document.#arguments.form_name#.kur_say.value;i++)
						if( eval('document.#arguments.form_name#.rd_money['+(i-1)+'].checked'))
							document.#arguments.form_name#.money_type.value = eval('document.#arguments.form_name#.hidden_rd_money_'+i).value;
				}	
			}
		}
	</script>
	</cfoutput>
</cffunction>
<cffunction name="f_kur_ekle_action">
	<cfargument name="action_id" required="true">
	<cfargument name="action_table_name" required="true">
	<cfargument name="action_table_dsn" required="true">
	<cfargument name="action_table_dsn_alias">
	<cfargument name="transaction_dsn"> <!--- transaction da kullanılan dsn gonderilirr --->
	<cfargument name="process_type" required="true">
	<cfif not (isdefined('arguments.transaction_dsn') and len(arguments.transaction_dsn))>
		<cfset arguments.transaction_dsn = arguments.action_table_dsn>
		<cfset arguments.action_table_dsn_alias = ''>
	<cfelse>
		<cfset arguments.action_table_dsn_alias = '#arguments.action_table_dsn#.'>
	</cfif>
	<!---
		by : Aysenur 20060215
		notes : kurla ilgili tablolara kayıt atar.
		usage :
			process_type:1 upd 0 add
			action_table_name:kur bilgilerinin atılacagı tablonun adı
			action_table_dsn:kur bilgilerinin atılacagı tablonun oldugu dsn
		örn:<cfscript>
			f_kur_ekle_action(action_id:get_act_id.MAX_ID,process_type:0,action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#');
			f_kur_ekle_action(action_id:URL.ID,process_type:1,action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#');
		</cfscript>
	--->
	<cfif arguments.process_type eq 1>
		<cfquery name="del_money_obj_bskt" datasource="#arguments.transaction_dsn#">
			DELETE FROM 
				#arguments.action_table_dsn_alias##arguments.action_table_name#
			WHERE 
				ACTION_ID=#arguments.action_id#
		</cfquery>
	</cfif>
	<cfloop from="1" to="#attributes.kur_say#" index="fnc_i">
		<cfquery name="add_money_obj_bskt" datasource="#arguments.transaction_dsn#">
			INSERT INTO #arguments.action_table_dsn_alias##arguments.action_table_name# 
			(
				ACTION_ID,
				MONEY_TYPE,
				RATE2,
				RATE1,
				IS_SELECTED
			)
			VALUES
			(
				#arguments.action_id#,
				'#wrk_eval("attributes.hidden_rd_money_#fnc_i#")#',
				#evaluate("attributes.txt_rate2_#fnc_i#")#,
				#evaluate("attributes.txt_rate1_#fnc_i#")#,
				<cfif evaluate("attributes.hidden_rd_money_#fnc_i#") is attributes.money_type>
					1
				<cfelse>
					0
				</cfif>			
			)
		</cfquery>
	</cfloop>
</cffunction>
