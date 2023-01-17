<cf_date tarih='attributes.process_date'>
<!--- e-defter islem kontrolu SP yapilacak FA --->
<cfif session.ep.our_company_info.is_edefter eq 1>
    <cfstoredproc procedure="GET_NETBOOK" datasource="#DSN2#">
    	<cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.process_date#">
        <cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.process_date#">
        <cfprocparam cfsqltype="cf_sql_varchar" value="">
        <cfprocresult name="getNetbook">
    </cfstoredproc>
	<cfif getNetbook.recordcount>
		<script language="javascript">
            alert('Muhasebeci : İşlemi yapamazsınız. İşlem tarihine ait e-defter bulunmaktadır.');
			history.back();
        </script>
        <cfabort>
    </cfif>
</cfif>
<!--- e-defter islem kontrolu SP yapilacak FA --->
<cfset upload_folder = "#upload_folder#account#dir_seperator#">
<cfif not (isdefined("attributes.muhasebe_file") and len(attributes.muhasebe_file))> <!--- dosya tanımlı degilse --->
	<strong><cf_get_lang no ='209.Dosyanızı Kontrol Ediniz'> !</strong>
	<cfexit method="exittemplate">
</cfif>		
<cftry>
	<cffile action="upload" filefield="muhasebe_file" destination="#upload_folder#" nameconflict="MakeUnique" mode="777">
	<cfcatch>
		<script type="text/javascript">
			alert("<cf_get_lang no='533.Dosyanız Upload Edilemedi Dosyanızı Kontrol Ediniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
<cfset file_name = "#createUUID()#.#cffile.serverfileext#">

<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">
<!---Script dosyalarını engelle  02092010 ND --->
<cfset assetTypeName = listlast(cffile.serverfile,'.')>
<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
<cfif listfind(blackList,assetTypeName,',')>
	<cffile action="delete" file="#upload_folder##file_name#">
	<script type="text/javascript">
		alert("<cf_get_lang no='249.php,jsp,asp,cfm,cfml Formatlarda Dosya Girmeyiniz'>");
		history.back();
	</script>
	<cfabort>
</cfif>	
<cffile action="read" file="#upload_folder##file_name#" variable="dosya">
<cfscript>
	CRLF = Chr(13) & Chr(10);
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
</cfscript>
<cfquery name="get_acc_plan" datasource="#dsn2#"><!--- her halukarda islem yapilacak donem hesap planina bakilacak asagida --->
	SELECT ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE SUB_ACCOUNT = 0 <!--- Alt Hesabi olmamali --->
</cfquery>
<cfquery name="get_money" datasource="#dsn2#">
	SELECT RATE2, RATE1, MONEY FROM SETUP_MONEY
</cfquery>
<cfif len(session.ep.money2)>
	<cfquery name="get_money_rate" dbtype="query">
		SELECT (RATE2/RATE1) AS RATE, MONEY FROM get_money WHERE MONEY='#session.ep.money2#'
	</cfquery>
	<cfset selected_money = session.ep.money2>
	<cfset money2_rate = get_money_rate.RATE>
<cfelse>
	<cfset selected_money = session.ep.money>
	<cfset money2_rate = 1>
</cfif>
<cfinclude template="get_acc_process_cat.cfm">
<cftry>
	<cfscript>
		satir_detay_list = ArrayNew(2); //muhasebe fisi satır detaylarını tutar. satir_detay_list[1]'a  borc yazan satırların acıklamaları, satir_detay_list[2]'a alacak yazan satırların acıklamaları set edilir. 
		str_borclu_hesaplar = '';
		str_borclu_tutarlar = '';
		str_dovizli_borclar = '';
		str_other_currency_borc = '';
		str_alacakli_hesaplar = '';
		str_alacakli_tutarlar = '';
		str_dovizli_alacaklar = '';
		str_other_currency_alacak = '';
		str_action_valu2_alacak ='';
		str_action_valu2_borc ='';
		alacak_hesaplar_total =0;
		borc_hesaplar_total=0;
		non_exist_acc_code_list='';
		acc_branch_list_borc='';
		acc_branch_list_alacak='';
		acc_department_list_borc='';
		acc_department_list_alacak='';
		acc_project_list_borc='';
		acc_project_list_alacak='';
		for(add_muh_index =1; add_muh_index lte line_count; add_muh_index=add_muh_index+1)
		{
			new_query="SELECT ACCOUNT_CODE FROM get_acc_plan WHERE ACCOUNT_CODE = '#trim(listgetat(dosya[add_muh_index],1,";"))#'";
			get_acc_plan_1 =cfquery(dbtype:1,SQLString:'#new_query#',datasource:'#dsn2#');
			dosya[add_muh_index] = Replace(dosya[add_muh_index],';;','; ;','all');
			dosya[add_muh_index] = Replace(dosya[add_muh_index],';;','; ;','all');
			if(len(get_acc_plan_1.ACCOUNT_CODE))
			{
				if(len(listgetat(dosya[add_muh_index],4,';')) and listgetat(dosya[add_muh_index],4,';') neq 0 and listfindnocase('B,b',listgetat(dosya[add_muh_index],3,';'))) //borc tutar 
				{
					str_borclu_tutarlar = listappend(str_borclu_tutarlar,listgetat(dosya[add_muh_index],4,';'));
						
					borc_hesaplar_total = borc_hesaplar_total + evaluate(wrk_round(listgetat(dosya[add_muh_index],4,';')));
						
					str_borclu_hesaplar = listappend(str_borclu_hesaplar,get_acc_plan_1.ACCOUNT_CODE);
					
					if(len(listgetat(dosya[add_muh_index],2,';')) and isvalid('string',listgetat(dosya[add_muh_index],2,';')) ) //acıklama borc
						satir_detay_list[1][listlen(str_borclu_tutarlar)]=listgetat(dosya[add_muh_index],2,';');
					else
						satir_detay_list[1][listlen(str_borclu_tutarlar)]=0;
					if( len(listgetat(dosya[add_muh_index],5,';')) and listgetat(dosya[add_muh_index],5,';') neq 0 and IsNumeric(listgetat(dosya[add_muh_index],5,';')) ) //sistem 2 doviz tutarı borc
						str_action_valu2_borc = ListAppend(str_action_valu2_borc,listgetat(dosya[add_muh_index],5,';'));
					else
						str_action_valu2_borc = ListAppend(str_action_valu2_borc,wrk_round(listgetat(dosya[add_muh_index],4,';')/money2_rate) );
						
					if( len(listgetat(dosya[add_muh_index],6,';')) and isvalid('string',listgetat(dosya[add_muh_index],6,';')) ) //diger doviz borc
						str_other_currency_borc = ListAppend(str_other_currency_borc,listgetat(dosya[add_muh_index],6,';'));
					else
						str_other_currency_borc = ListAppend(str_other_currency_borc,0);
					if( len(listgetat(dosya[add_muh_index],7,';')) and IsNumeric(listgetat(dosya[add_muh_index],7,';')) )//diger doviz tutarı borc
						str_dovizli_borclar = ListAppend(str_dovizli_borclar,listgetat(dosya[add_muh_index],7,';'));
					else
						str_dovizli_borclar = ListAppend(str_dovizli_borclar,0);
					if( len(listgetat(dosya[add_muh_index],8,';')) and IsNumeric(listgetat(dosya[add_muh_index],8,';')) )//şube id
						acc_branch_list_borc = ListAppend(acc_branch_list_borc,listgetat(dosya[add_muh_index],8,';'));
					else
						acc_branch_list_borc = ListAppend(acc_branch_list_borc,0);
					if( len(listgetat(dosya[add_muh_index],9,';')) and IsNumeric(listgetat(dosya[add_muh_index],9,';')) )//department id
						acc_department_list_borc = ListAppend(acc_department_list_borc,listgetat(dosya[add_muh_index],9,';'));
					else
						acc_department_list_borc = ListAppend(acc_department_list_borc,0);
					if(listlen(dosya[add_muh_index],';') gte 10 and len(listgetat(dosya[add_muh_index],10,';')) and IsNumeric(listgetat(dosya[add_muh_index],10,';')) )//proje id
						acc_project_list_borc = ListAppend(acc_project_list_borc,listgetat(dosya[add_muh_index],10,';'));
					else
						acc_project_list_borc = ListAppend(acc_project_list_borc,0);
				}
				else if(len(listgetat(dosya[add_muh_index],4,';')) and listgetat(dosya[add_muh_index],4,';') neq 0 and listfindnocase('A,a',listgetat(dosya[add_muh_index],3,';'))) //alacak tutar (B/A 1 ise ve tutar var ise)
				{
					str_alacakli_tutarlar = listappend(str_alacakli_tutarlar,listgetat(dosya[add_muh_index],4,';'));
					
					alacak_hesaplar_total = alacak_hesaplar_total+ evaluate(wrk_round(listgetat(dosya[add_muh_index],4,';')));

					str_alacakli_hesaplar = listappend(str_alacakli_hesaplar,get_acc_plan_1.ACCOUNT_CODE);
					
					if(len(listgetat(dosya[add_muh_index],2,';')) and isvalid('string',listgetat(dosya[add_muh_index],2,';')) ) //acıklama alacak
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]=listgetat(dosya[add_muh_index],2,';');
					else
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]=0;
					if( len(listgetat(dosya[add_muh_index],5,';'))  and listgetat(dosya[add_muh_index],5,';') neq 0 and IsNumeric(listgetat(dosya[add_muh_index],5,';')) ) //sistem 2 doviz tutarı alacak
						str_action_valu2_alacak = ListAppend(str_action_valu2_alacak,listgetat(dosya[add_muh_index],5,';'));
					else
						str_action_valu2_alacak = ListAppend(str_action_valu2_alacak,wrk_round(listgetat(dosya[add_muh_index],4,';')/money2_rate) );
					if( len(listgetat(dosya[add_muh_index],6,';')) and isvalid('string',listgetat(dosya[add_muh_index],6,';')) ) //diger doviz alacak
						str_other_currency_alacak = ListAppend(str_other_currency_alacak,listgetat(dosya[add_muh_index],6,';'));
					else
						str_other_currency_alacak = ListAppend(str_other_currency_alacak,0);
					if( len(listgetat(dosya[add_muh_index],7,';')) and IsNumeric(listgetat(dosya[add_muh_index],7,';')) ) //diger doviz tutarı alacak
						str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,listgetat(dosya[add_muh_index],7,';'));
					else
						str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,0);
					if( len(listgetat(dosya[add_muh_index],8,';')) and IsNumeric(listgetat(dosya[add_muh_index],8,';')) )//şube id
						acc_branch_list_alacak = ListAppend(acc_branch_list_alacak,listgetat(dosya[add_muh_index],8,';'));
					else
						acc_branch_list_alacak = ListAppend(acc_branch_list_alacak,0);
					if( len(listgetat(dosya[add_muh_index],9,';')) and IsNumeric(listgetat(dosya[add_muh_index],9,';')) )//department id
						acc_department_list_alacak = ListAppend(acc_department_list_alacak,listgetat(dosya[add_muh_index],9,';'));
					else
						acc_department_list_alacak = ListAppend(acc_department_list_alacak,0);
					if(listlen(dosya[add_muh_index],';') gte 10 and len(listgetat(dosya[add_muh_index],10,';')) and IsNumeric(listgetat(dosya[add_muh_index],10,';')) )//proje id
						acc_project_list_alacak = ListAppend(acc_project_list_alacak,listgetat(dosya[add_muh_index],10,';'));
					else
						acc_project_list_alacak = ListAppend(acc_project_list_alacak,0);
				}
			}
			else
			{
				if(not listfind(non_exist_acc_code_list,trim(listgetat(dosya[add_muh_index],1,";"))) )
					non_exist_acc_code_list = listappend(non_exist_acc_code_list,trim(listgetat(dosya[add_muh_index],1,";")));
			}
		}
	</cfscript>
	<cfif listlen(non_exist_acc_code_list)>
		<cfoutput>
		<script type="text/javascript">
			var alert_str = '<cf_get_lang no="319.Dosyada Muhasebe Hesap Planında Olmayan Hesap Kodu Kullanılmış"><br />';
            var alert_str = alert_str + "<cf_get_lang no='320.Tanımsız Hesap Kodları'>:<br />";
            <cfloop list="#non_exist_acc_code_list#" index="acc_i">
                 var alert_str = alert_str +  "#acc_i#<br />";
            </cfloop>
			alert(alert_str);
        </script>
		</cfoutput>
        <cfabort>
    </cfif>
    
    <cfif (alacak_hesaplar_total eq 0) and (borc_hesaplar_total eq 0)><!--- Muhasebe Fisi Toplam Tutari Yoksa Hareket Yazmaz  --->
        <cfoutput>
		<script type="text/javascript">
		var alert_str = "<cf_get_lang no='317.Muhasebe Fişi Toplam Tutarı Sıfır'><br />";
		alert(alert_str);
		</script>
		</cfoutput>
        <cfabort>
    </cfif>
    <cfif acc_process_type neq 10 and wrk_round((alacak_hesaplar_total-borc_hesaplar_total),2) neq 0> <!--- muhasebe fisi borc-alacak esitligi kontrol ediliyor tabi acılıs fisi import secilmemisse--->
        <cfoutput>
		<script type="text/javascript">
			var alert_str = "<cf_get_lang no='318. Muhasebe Fişi Borç-Alacak Bakiyesi Eşit Değil'>";
			var alert_str = alert_str + "borc_hesaplar:<br />";
            <cfloop from="1" to="#listlen(str_borclu_hesaplar,',')#" index="i">
                var alert_str = alert_str + "#listgetat(str_borclu_hesaplar,i,',')#=#TLFormat(listgetat(str_borclu_tutarlar,i,','))# <br />";
            </cfloop>
            var alert_str = alert_str + "borc_hesaplar_total = #TLFormat(borc_hesaplar_total)#<br />";
            var alert_str = alert_str + "alacak_hesaplar:<br />";
            <cfloop from="1" to="#listlen(str_alacakli_hesaplar,',')#" index="i">
                var alert_str = alert_str + "#listgetat(str_alacakli_hesaplar,i,',')#=#TLFormat(listgetat(str_alacakli_tutarlar,i,','))# <br />";
            </cfloop>
            var alert_str = alert_str + "alacak_hesaplar_total = #TLFormat(alacak_hesaplar_total)#<br /><br />";
            var alert_str = alert_str + "<b>Fark = #TLFormat(borc_hesaplar_total-alacak_hesaplar_total)# <cfif borc_hesaplar_total gt alacak_hesaplar_total>(B)<cfelse>(A)</cfif></b>";
			alert(alert_str);
        </script>
		</cfoutput> 
        <cfabort>
    </cfif>
	 <cfcatch>
	 	<cfoutput>
		<script type="text/javascript">
	 	var alert_str = "<cf_get_lang dictionary_id='36135.Dosya Okumada Hata oluştu'>,<cfoutput>#add_muh_index#</cfoutput>. <cf_get_lang dictionary_id='59216.satırdaki zorunlu alanlarda eksik değerler var. Lütfen dosyanızı kontrol ediniz'><br />";
 		<cfif listlen(dosya[add_muh_index],';') neq 10>
		 	var alert_str = alert_str + "(<cf_get_lang dictionary_id='50956.Gönderilen Parametreler Eksik veya Parametreler (;) Ayracı İle Ayrılmamış'>.<cf_get_lang dictionary_id='50959.Satırdaki parametre sayısı'> : <cfoutput>#listlen(dosya[add_muh_index],';')#</cfoutput>)<br />";
		</cfif>
		<cfif listlen(dosya[add_muh_index],';') eq 0>
			var alert_str = alert_str + "Satırda Parametre Girilmemiş !<br />";
			alert(alert_str);
			<cfabort>
		</cfif>
		<cfif not len(listgetat(dosya[add_muh_index],1,";"))>
			var alert_str = alert_str + "( <cf_get_lang dictionary_id='40366.Satırda Hesap Kodu Seçilmemiş'> )<br />";
		</cfif>
		<cfif len(listgetat(dosya[add_muh_index],1,";")) and get_acc_plan_1.recordcount eq 0>
			var alert_str = alert_str + "<cfoutput>( #listgetat(dosya[add_muh_index],1,';')#</cfoutput> <cf_get_lang dictionary_id='47299.Hesap Kodu'>, <cf_get_lang dictionary_id='59058.Dosyada Muhasebe Hesap Planında Olmayan Hesap Kodu Kullanılmış'>. )<br />";
		</cfif>
		alert(alert_str);
		</script>
		</cfoutput> 
		<cfabort>
	</cfcatch>
</cftry>
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
 <cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="GET_BILL_NO" datasource="#dsn2#">
			SELECT BILL_NO,MAHSUP_BILL_NO,TAHSIL_BILL_NO,TEDIYE_BILL_NO FROM BILLS
		</cfquery>
		<cfif acc_process_type eq 10><!--- acılıs fisi secili ise, sisteme kayıtlı seçilen işlem kategorisinde acılıs fişi olup olmadıgı kontrol ediliyor --->
			<cfquery name="GET_OPENING_CARD" datasource="#dsn2#">
				SELECT CARD_ID FROM ACCOUNT_CARD WHERE CARD_TYPE =#acc_process_type# AND CARD_CAT_ID=#attributes.process_cat#
                <cfif attributes.show_type eq 2>
                       AND RECORD_TYPE = 2
                <cfelseif attributes.show_type eq 1>
                       AND (RECORD_TYPE = 1 OR RECORD_TYPE IS NULL) 
                <cfelse>
                       AND RECORD_TYPE = 3
                </cfif>

			</cfquery>
			<cfset max_card_id =GET_OPENING_CARD.CARD_ID>
		</cfif>
		<!---1- tahsil-tediye-mahsup fisi secilmisse 
			2- acılıs fisi secilmis ama sisteme kayıtlı acılıs fisi yoksa account_card'a kayıt atılır --->
		<cfif acc_process_type neq 10 or (acc_process_type eq 10 and GET_OPENING_CARD.recordcount eq 0)>
			<cfquery name="ADD_ACCOUNT_CARD" datasource="#dsn2#" result="MAX_ID">
				INSERT INTO
					ACCOUNT_CARD
					(
					IS_OTHER_CURRENCY,
					WRK_ID,
					ACC_COMPANY_ID,
					ACC_CONSUMER_ID,
					CARD_DETAIL,
					BILL_NO,
					CARD_TYPE,
					CARD_CAT_ID,
					CARD_TYPE_NO,
					ACTION_DATE,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					RECORD_TYPE
					)
				VALUES
					(
					1,
					'#wrk_id#',
					<cfif isdefined("attributes.member_id") and len(attributes.member_id) and isdefined("attributes.member_name") and len(attributes.member_name)>
						<cfif isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'partner'>#attributes.member_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'consumer'>#attributes.member_id#<cfelse>NULL</cfif>,
					<cfelse>
						NULL,
						NULL,
					</cfif>
					<cfif isdefined('attributes.bill_detail') and len(attributes.bill_detail)>
					 '#attributes.bill_detail#',
					<cfelseif acc_process_type eq 10>
						'Açılış Fişi',
					<cfelse>
						NULL,
					</cfif>
					#get_bill_no.BILL_NO#,
					#acc_process_type#,
					#attributes.process_cat#,
					<cfif listfind('13,14,19',acc_process_type)><!--- mahsup, kapanıs ve ozel fis --->
						#get_bill_no.MAHSUP_BILL_NO#,
					<cfelseif acc_process_type eq 12>
						#get_bill_no.TEDIYE_BILL_NO#,
					<cfelseif acc_process_type eq 11>
						#get_bill_no.TAHSIL_BILL_NO#,
					<cfelse>
						NULL,
					</cfif>
					#attributes.process_date#,
					#session.ep.userid#,
					'#CGI.REMOTE_ADDR#',
					#now()#,
					<cfif isdefined("attributes.show_type") and len(attributes.show_type)>#attributes.show_type#<cfelse>1</cfif>
					)
			</cfquery>
			<cfset max_card_id = MAX_ID.IDENTITYCOL>
            <cfset actionId= MAX_ID.IDENTITYCOL>
		</cfif>
		<cfif attributes.show_type eq 2>
			<cfset table_name = "ACCOUNT_ROWS_IFRS">
		<cfelse>
			<cfset table_name = "ACCOUNT_CARD_ROWS">
		</cfif>
		<!--- muhasebe fisi alacak satırları yazdırılıyor --->
		<cfloop from="1" to="#listlen(str_alacakli_hesaplar)#" index="tt">
			<cfquery name="add_muhas_alacak" datasource="#dsn2#">
				INSERT INTO
					#table_name#
					(
						CARD_ID,
						ACCOUNT_ID,
						DETAIL,
						BA,
						AMOUNT,
						AMOUNT_CURRENCY,
					<cfif len(session.ep.money2)>
						AMOUNT_2,
						AMOUNT_CURRENCY_2,
					</cfif>
						OTHER_AMOUNT,
						OTHER_CURRENCY,
						ACC_BRANCH_ID,
						ACC_DEPARTMENT_ID,
						ACC_PROJECT_ID,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE
					)
				VALUES
					(
						#max_card_id#,
						'#listgetat(str_alacakli_hesaplar,tt)#',
					<cfif satir_detay_list[2][tt] neq 0>'#left(satir_detay_list[2][tt],500)#'<cfelse>NULL</cfif>,
						1,
						#wrk_round(listgetat(str_alacakli_tutarlar,tt),2)#,
					'#session.ep.money#',
					<cfif len(session.ep.money2)>
						<cfif len(listgetat(str_action_valu2_alacak,tt)) and listgetat(str_action_valu2_alacak,tt) neq 0>#wrk_round(listgetat(str_action_valu2_alacak,tt),2)#<cfelse>NULL</cfif>,
						'#session.ep.money2#',
					</cfif>
					<cfif listlen(str_dovizli_alacaklar) gte tt and len(listgetat(str_dovizli_alacaklar,tt)) and listlen(str_other_currency_alacak) gte tt and len(listgetat(str_other_currency_alacak,tt)) and listgetat(str_other_currency_alacak,tt) neq 0>
						#wrk_round(listgetat(str_dovizli_alacaklar,tt),2)#,
						'#listgetat(str_other_currency_alacak,tt)#',
					<cfelse>
						NULL,
						NULL,
					</cfif>
					<cfif listlen(acc_branch_list_alacak) gte tt and len(listgetat(acc_branch_list_alacak,tt)) and listgetat(acc_branch_list_alacak,tt) neq 0>
						#listgetat(acc_branch_list_alacak,tt)#,
					<cfelse>
						NULL,
					</cfif>
					<cfif listlen(acc_department_list_alacak) gte tt and len(listgetat(acc_department_list_alacak,tt)) and listgetat(acc_department_list_alacak,tt) neq 0>
						#listgetat(acc_department_list_alacak,tt)#,
					<cfelse>
						NULL,
					</cfif>
					<cfif listlen(acc_project_list_alacak) gte tt and len(listgetat(acc_project_list_alacak,tt)) and listgetat(acc_project_list_alacak,tt) neq 0>
						#listgetat(acc_project_list_alacak,tt)#
					<cfelse>
						NULL
					</cfif>,
					#session.ep.userid#,
					'#CGI.REMOTE_ADDR#',
					#now()#
					)
			</cfquery>
		</cfloop>
		<!--- muhasebe fisinin borc satırları kaydediliyor --->
		<cfloop from="1" to="#listlen(str_borclu_hesaplar)#" index="nn">
			<cfquery name="add_muhas_alacak" datasource="#dsn2#">
				INSERT INTO
					#table_name#
					(
						CARD_ID,
						ACCOUNT_ID,
						DETAIL,
						BA,
						AMOUNT,
						AMOUNT_CURRENCY,
					<cfif len(session.ep.money2)>
						AMOUNT_2,
						AMOUNT_CURRENCY_2,
					</cfif>
						OTHER_AMOUNT,
						OTHER_CURRENCY,
						ACC_BRANCH_ID,
						ACC_DEPARTMENT_ID,
						ACC_PROJECT_ID,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE
					)
				VALUES
					(
						#max_card_id#,
						'#listgetat(str_borclu_hesaplar,nn)#',
					<cfif satir_detay_list[1][nn] neq 0>'#left(satir_detay_list[1][nn],500)#'<cfelse>NULL</cfif>,
						0,
						#wrk_round(listgetat(str_borclu_tutarlar,nn),2)#,
					'#session.ep.money#',
					<cfif len(session.ep.money2)>
						<cfif len(listgetat(str_action_valu2_borc,nn)) and listgetat(str_action_valu2_borc,nn) neq 0>#wrk_round(listgetat(str_action_valu2_borc,nn),2)#<cfelse>NULL</cfif>,
						'#session.ep.money2#',
					</cfif>
					<cfif listlen(str_dovizli_borclar) gte nn and len(listgetat(str_dovizli_borclar,nn)) and listlen(str_other_currency_borc) gte nn and len(listgetat(str_other_currency_borc,nn)) and listgetat(str_other_currency_borc,nn) neq 0>
						#wrk_round(listgetat(str_dovizli_borclar,nn),2)#,
						'#listgetat(str_other_currency_borc,nn)#',
					<cfelse>
						NULL,
						NULL,
					</cfif>
					<cfif listlen(acc_branch_list_borc) gte nn and len(listgetat(acc_branch_list_borc,nn)) and listgetat(acc_branch_list_borc,nn) neq 0>
						#listgetat(acc_branch_list_borc,nn)#,
					<cfelse>
						NULL,
					</cfif>
					<cfif listlen(acc_department_list_borc) gte nn and len(listgetat(acc_department_list_borc,nn)) and listgetat(acc_department_list_borc,nn) neq 0>
						#listgetat(acc_department_list_borc,nn)#,
					<cfelse>
						NULL,
					</cfif>
					<cfif listlen(acc_project_list_borc) gte nn and len(listgetat(acc_project_list_borc,nn)) and listgetat(acc_project_list_borc,nn) neq 0>
						#listgetat(acc_project_list_borc,nn)#
					<cfelse>
						NULL
					</cfif>,
					#session.ep.userid#,
					'#CGI.REMOTE_ADDR#',
					#now()#
					)
			</cfquery>
		</cfloop>
		<cfif acc_process_type neq 10 or (acc_process_type eq 10 and GET_OPENING_CARD.recordcount eq 0)>
			<cfquery name="UPD_BILL_NO" datasource="#DSN2#">
				UPDATE 	
					BILLS 
				SET BILL_NO = BILL_NO+1 
				<cfif listfind('13,14,19',acc_process_type)>,MAHSUP_BILL_NO = MAHSUP_BILL_NO+1
				<cfelseif acc_process_type eq 12>,TEDIYE_BILL_NO = TEDIYE_BILL_NO+1
				<cfelseif acc_process_type eq 11>,TAHSIL_BILL_NO = TAHSIL_BILL_NO+1</cfif>
			</cfquery>
			<cfif get_money.recordcount>
				<cfoutput query="get_money">
					<cfquery name="ADD_ACC_MONEY" datasource="#dsn2#">
						INSERT INTO
						ACCOUNT_CARD_MONEY 
						(
							ACTION_ID,
							MONEY_TYPE,
							RATE2,
							RATE1,
							IS_SELECTED
						)
						VALUES
						(
							#max_card_id#,
							'#get_money.MONEY#',
							#get_money.RATE2#,
							#get_money.RATE1#,
							<cfif get_money.MONEY eq selected_money>1<cfelse>0</cfif>
					)
					</cfquery>
				</cfoutput>
			</cfif>
		</cfif>
		<cf_add_log employee_id="#session.ep.userid#" log_type="1" action_id="#max_card_id#" action_name= "#GET_BILL_NO.BILL_NO+1# Eklendi" paper_no= "#GET_BILL_NO.BILL_NO+1#" period_id="#session.ep.period_id#" process_type="#acc_process_type#" data_source="#dsn2#">
		<cfscript>
			if(session.ep.our_company_info.is_ifrs and attributes.show_type eq 3){
				muhasebeci_ifrs(card_id : MAX_ID.IDENTITYCOL, dsn_type : dsn2);
			}
		</cfscript>
	</cftransaction>
</cflock>
<cffile action="delete" file="#upload_folder##file_name#">
<script type="text/javascript">
	alert("<cf_get_lang no ='208.İşlem Tamamlandı'>!");
	window.location.href="<cfoutput>#request.self#</cfoutput>?fuseaction=account.list_cards";
</script>
