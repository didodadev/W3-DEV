<cfset kontrol_file = 0>
<cfset upload_folder = "#upload_folder#cheque#dir_seperator#">
	<cffile action = "upload" 
		  fileField = "uploaded_file" 
		  destination = "#upload_folder#"
		  nameConflict = "MakeUnique"  
		  mode="777">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">	
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>
	<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
	<cfif listfind(blackList,assetTypeName,',')>
		<cffile action="delete" file="#upload_folder##file_name#">
		<script type="text/javascript">
			alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfset file_size = cffile.filesize>
	<cfset dosya_yolu = "#upload_folder##file_name#">
	<cffile action="read" file="#dosya_yolu#" variable="dosya">
<cfif kontrol_file eq 0>
	<cfscript>
		CRLF = Chr(13) & Chr(10);// satır atlama karakteri
		dosya = Replace(dosya,';;','; ;','all');
		dosya = Replace(dosya,';;','; ;','all');
		dosya = ListToArray(dosya,CRLF);
		line_count = ArrayLen(dosya);
	</cfscript>
	<cfloop from="2" to="#line_count#" index="k">
    <cfset dosya[k] = dosya[k]&' '>
    <cfif listlen(dosya[k],';') neq 7>
		<script type="text/javascript">
            alert("<cfoutput>#k#. satırda hata: Bir satırda 7 alan olmalıdır. - #listlen(dosya[k],';')#</cfoutput>");
			
        </script>
        <cfabort>
    </cfif>
		<cfset j= 1>
		<cfscript>
			voucher_no = Listgetat(dosya[k],j,";"); //Senet No
			attributes.voucher_no = trim(voucher_no);
			j = j+1;
			
			amount = Listgetat(dosya[k],j,";"); //İşlem Para Birimi
			attributes.voucher_value = trim(amount);
			j = j+1;
			
			voucher_duedate = Listgetat(dosya[k],j,";"); // vade tarihi
			attributes.voucher_duedate = trim(voucher_duedate);
			j = j+1;
			
			self_voucher = Listgetat(dosya[k],j,";"); //Müşteri Senedi
			attributes.self_voucher_ = trim(self_voucher);
			j = j+1;
			
			voucher_code = Listgetat(dosya[k],j,";"); //Özel Kod
			attributes.voucher_code = trim(voucher_code);
			j = j+1;
			
			voucher_city = Listgetat(dosya[k],j,";"); //Ödeme Yeri
			attributes.voucher_city = trim(voucher_city);
			j = j+1;
			
			debtor_name = Listgetat(dosya[k],j,";"); //Borçlu
			attributes.debtor_name = trim(debtor_name);
			j = j+1;
			
			last_act_date = "";
			attributes.portfoy_no = "";
			attributes.voucher_id = "";
			attributes.currency_id = attributes.cash_currency;
			attributes.voucher_system_currency_value = session.ep.money;
			
		</cfscript>
		<cfoutput>
            <script type="text/javascript">
                var kontrol=0;
            </script>
            <cfif not isdefined("attributes.voucher_payroll_entry")><!--- giris bordrosu dışından gelmeli --->
                <!--- baskette 2 tane aynı senet var mi kontrolü --->
                <script type="text/javascript">
                    <cfif isdefined("attributes.voucher_id") and len(attributes.voucher_id) and attributes.voucher_id neq 0>//<!--- Senet kayıtlı ise --->
                        for(tt=1;tt<=window.top.document.all.record_num.value;tt++)
                        {
                            if(eval('window.top.document.all.row_kontrol'+tt).value == 1)
                            {
                                if('#attributes.voucher_id#' == eval('window.top.document.all.voucher_id'+tt).value)
                                {
                                    kontrol = 1;
                                    break;
                                }
                            }
                        }
                    <cfelse>
                        for(jj=1;jj<=window.top.document.all.record_num.value;jj++)
                        {
                            if(eval('window.top.document.all.row_kontrol'+jj).value == 1)
                            {
                                if(('#attributes.voucher_no#' == eval('window.top.document.all.voucher_no'+jj).value))
                                {
                                    kontrol = 1;
                                    break;
                                }
                            }
                        }
                    </cfif>
                    if (kontrol == 1)
                    {
                        alert("<cf_get_lang no='16.Aynı Senedi İkinci Kere Girmeye Çalışıyorsunuz !'>");
                    }
                </script>
            </cfif>
            <cfif isdefined("attributes.kur_say")>
            <!--- Sistem 2. dövizini hesaplamak için kontroller hesaplamalar vs yapılıyor --->
                <cfscript>
                    for(a_sy = 1; a_sy lte attributes.kur_say; a_sy = a_sy + 1)
                    {
                        'attributes.txt_rate1_#a_sy#' = filterNum(evaluate('attributes.txt_rate1_#a_sy#'),session.ep.our_company_info.rate_round_num);
                        'attributes.txt_rate2_#a_sy#' = filterNum(evaluate('attributes.txt_rate2_#a_sy#'),session.ep.our_company_info.rate_round_num);
                    }
                    currency_multiplier = '';
                    if(isDefined('attributes.kur_say') and len(attributes.kur_say))
                        for(mon=1;mon lte attributes.kur_say;mon=mon+1)
                        {
                            if(evaluate("attributes.other_money#mon#") is session.ep.money2)
                                currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
                        }		
                </cfscript>
            </cfif>
			<cfif not isValid("float",attributes.voucher_value)>
                <script type="text/javascript">
                    alert("<cfoutput>#k#. satırda hata: Senet tutarı ondalık bir değer olmalıdır.</cfoutput>");
                </script>
                <cfabort>
            </cfif>
            <cfset voucher_position = 1><!--- yeni ya da seçilen senet --->
            <cfif attributes.self_voucher_ eq 1>
                <cfset attributes.voucher_status_id = 6><!--- default status : ödenmedi --->
                <cfset from_voucher_info = 1>
            <cfelse>
				<cfset from_voucher_info = 0>
                <cfset attributes.voucher_status_id = 1><!---default status : portföyde--->
            </cfif>
            <script type="text/javascript">
                if(kontrol == undefined || kontrol == 0)
                    top.add_voucher_row('#attributes.portfoy_no#','','#attributes.debtor_name#','#attributes.voucher_city#','#attributes.voucher_duedate#','#attributes.voucher_value#','#attributes.voucher_no#','#attributes.voucher_code#','','','','','#listgetat(attributes.currency_id,1,';')#','#attributes.voucher_id#','#voucher_position#','#from_voucher_info#','#attributes.voucher_status_id#','#attributes.voucher_system_currency_value#','#session.ep.money#','','','','','','','#last_act_date#','#attributes.cash_currency#');
            </script>
        </cfoutput>
	</cfloop>
</cfif>
<script type="text/javascript">
	top.document.getElementById("voucher_payroll_entry_file").style.display='none';
</script>
