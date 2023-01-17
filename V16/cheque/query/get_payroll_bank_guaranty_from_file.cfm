<cfset kontrol_file = 0>
<cfset upload_folder = "#upload_folder#cheque#dir_seperator#">
<cftry>
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
	<cfcatch type="Any">
		<cfset kontrol_file = 1>
	</cfcatch>
</cftry>
<cfif kontrol_file eq 0>
	<cfscript>
		CRLF = Chr(14) & Chr(10);// satır atlama karakteri
		dosya = Replace(dosya,';;','; ;','all');
		dosya = Replace(dosya,';;','; ;','all');
		dosya = ListToArray(dosya,CRLF);
		line_count = ArrayLen(dosya);
		chequeIdList = '';
	</cfscript>
	<cfloop from="2" to="#line_count#" index="k">
    <cfset dosya[k] = dosya[k]&' '>
    <cfif listlen(dosya[k],';') neq 14>
		<script type="text/javascript">
            alert("<cfoutput>#k#. satırda hata: Bir satırda 14 alan olmalıdır.</cfoutput>");
        </script>
        <cfabort>
    </cfif>
		<cfset j= 1>
		<cfscript>
			cheque_purse_no = Listgetat(dosya[k],j,";"); //Portföy No
			attributes.cheque_purse_no = trim(cheque_purse_no);
			j = j+1;
			
			cheque_no = Listgetat(dosya[k],j,";"); //Çek No
			attributes.cheque_no = trim(cheque_no);
			j = j+1;
			
			amount = Listgetat(dosya[k],j,";"); //İşlem Para Birimi
			attributes.cheque_value = trim(amount);
			j = j+1;
			
			cheque_duedate = Listgetat(dosya[k],j,";"); // vade tarihi
			attributes.cheque_duedate = trim(cheque_duedate);
			j = j+1;
			
			is_cari_cheque = Listgetat(dosya[k],j,";"); //Cari Hesap Çeki
			attributes.self_cheque = trim(is_cari_cheque);
			j = j+1;
			
			bank_name = Listgetat(dosya[k],j,";"); //Banka
			attributes.bank_name = trim(bank_name);
			j = j+1;
			
			bank_branch_name = Listgetat(dosya[k],j,";"); //Banka Şubesi
			attributes.bank_branch_name = trim(bank_branch_name);
			j = j+1;
			
			account_no = Listgetat(dosya[k],j,";"); //Hesap No
			attributes.account_no = trim(account_no);
			j = j+1;
			
			cheque_code = Listgetat(dosya[k],j,";"); //Özel Kod
			attributes.cheque_code = trim(cheque_code);
			j = j+1;
			
			tax_place = Listgetat(dosya[k],j,";"); //Vergi Dairesi
			attributes.tax_place = trim(tax_place);
			j = j+1;
			
			tax_no = Listgetat(dosya[k],j,";"); //Vergi No
			attributes.tax_no = trim(tax_no);
			j = j+1;
			
			cheque_city = Listgetat(dosya[k],j,";"); //Ödeme Yeri
			attributes.cheque_city = trim(cheque_city);
			j = j+1;
			
			debtor = Listgetat(dosya[k],j,";"); //Borçlu
			attributes.debtor_name = trim(debtor);
			j = j+1;
			
			endorsement_member = Listgetat(dosya[k],j,";"); //Ciro Eden
			attributes.endorsement_member = trim(endorsement_member);
			j = j+1;
			
			attributes.cheque_system_currency_value = session.ep.money;
		</cfscript>
        <cfoutput>
            <script type="text/javascript">
                var kontrol=0;
            </script>
            <cfif not isdefined("attributes.payroll_entry")><!--- giris bordrosu dışından gelmeli --->
                <cfif len(attributes.cheque_no) and len(attributes.cheque_purse_no)>
                    <cfquery name="CONTROL_CHEQUE_NO" datasource="#dsn2#">
                        SELECT CHEQUE_ID,CHEQUE_STATUS_ID FROM CHEQUE WHERE CHEQUE_PURSE_NO = #attributes.cheque_purse_no# AND CHEQUE_NO = '#attributes.cheque_no#' AND CHEQUE_STATUS_ID IN (1,10)
                    </cfquery>
                    <cfif not CONTROL_CHEQUE_NO.recordcount>
						<script type="text/javascript">
                        	alert("#attributes.cheque_no# <cf_get_lang_main no = '2702.Nolu Cek Sistemde Mevcut Degildir'> !");
                        </script>
                        <cfscript>
                        	continue;
                        </cfscript>
                    <cfelseif CONTROL_CHEQUE_NO.recordcount eq 1>
                    	<cfset attributes.cheque_id = CONTROL_CHEQUE_NO.CHEQUE_ID>
                        <cfset attributes.cheque_status_id = CONTROL_CHEQUE_NO.CHEQUE_STATUS_ID>
                        <cfquery name="GET_HISTORY" datasource="#dsn2#">
                        	SELECT TOP 1 ACT_DATE FROM CHEQUE_HISTORY WHERE CHEQUE_ID = #attributes.cheque_id# ORDER BY HISTORY_ID DESC
                        </cfquery>
                        <cfset last_act_date = GET_HISTORY.ACT_DATE>
                        <cfif not ListFind(chequeIdList,attributes.cheque_id,',')>
                        	<cfset chequeIdList = ListAppend(chequeIdList,attributes.cheque_id,',')>
                        <cfelse>
							<script type="text/javascript">
                                alert("<cf_get_lang no='16.Aynı Çeki İkinci Kere Girmeye Çalışıyorsunuz !'>");
                            </script>
                            <cfscript>
                                continue;
                            </cfscript>
                        </cfif>
                    <cfelseif CONTROL_CHEQUE_NO.recordcount gt 1>
                        <script type="text/javascript">
                            alert("#attributes.cheque_no# <cf_get_lang_main no ='2703.Çek Numarasıyla Birden Fazla Çek Mevcut'> !");
                        </script>
                        <cfscript>
                        	continue;
                        </cfscript>
                    </cfif>
                <cfelse>
					<script type="text/javascript">
                        alert("#k#. <cf_get_lang_main no = '2704.zorunlu alanlar'> !");
                    </script>
                    <cfscript>
                        continue;
                    </cfscript>
                </cfif>
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
			<cfif not isValid("float",attributes.cheque_value)>
                <script type="text/javascript">
                    alert("<cfoutput>#k#. satırda hata: Çek tutarı ondalık bir değer olmalıdır.</cfoutput>");
                </script>
                <cfabort>
            </cfif>
            <script type="text/javascript">
                if(kontrol == undefined || kontrol == 0)
                    top.add_cheque_row('#attributes.cheque_purse_no#','#attributes.bank_name#','#attributes.debtor_name#','#attributes.cheque_city#','#attributes.cheque_duedate#','#attributes.cheque_value#','#attributes.cheque_no#','#attributes.cheque_code#','#attributes.tax_place#','#attributes.tax_no#','#attributes.bank_branch_name#','#attributes.account_no#','','#attributes.cheque_currency_id#','#attributes.cheque_id#','','','#attributes.cheque_status_id#','#attributes.cheque_system_currency_value#','#session.ep.money#','#session.ep.money2#','#session.ep.money2#','','','#attributes.endorsement_member#','#last_act_date#');
            </script>
		</cfoutput>
    </cfloop>
</cfif>
<script type="text/javascript">
	top.document.getElementById("payroll_guaranty_file").style.display='none';
</script>
