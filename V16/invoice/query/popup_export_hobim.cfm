<cfsetting showdebugoutput="no">
<cfif not len(attributes.hobim_stage_id)>
    <cfquery name="getHobimStage" datasource="#DSN#" maxrows="1">
        SELECT TOP 1
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%invoice.popup_form_export_hobim%">
        ORDER BY 
            PTR.PROCESS_ROW_ID
    </cfquery>
    <cfset attributes.hobim_stage_id = getHobimStage.PROCESS_ROW_ID>
</cfif>
<cfif not len(attributes.hobim_stage_id)>
	<script type="text/javascript">
		alert("Lütfen Hobim süreçlerinizi tanımlayınız !");
		window.close();
	</script>
    <cfabort>
</cfif>

<cfinclude template="../query/get_invoice_multi.cfm">

<cfif get_invoice.recordcount>
    <cfscript>
        CRLF=chr(13)&chr(10);
        file_content = ArrayNew(1);
        index_array = 1;
        satir1 = "";
        satir2 = "";
        satir3 = "";
		satir4 = "";
        satir = "";
        pre_invoice_id=0;//bir üst query satırı ile aynı faturamı
    	// DOSYA SABIT SATIRLAR
        satir_basla = "##V.1.02##";
        file_content[index_array] = "#satir_basla#";
        index_array = index_array+1;
        satir_basla="CREATION TIME:"&dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmm');
        file_content[index_array] = "#satir_basla#";
        index_array = index_array+1;
        system_money=session.ep.money;

		urun_satiri=0;//bir faturaya 20 satır basa biliyormuş onun kontrolü için....

		for(i=1;i lte get_invoice.recordcount; i=i+1)
		{
			if(pre_invoice_id neq get_invoice.invoice_id[i] or urun_satiri eq 20)
			{
				urun_satiri=0;
	
				if(len(get_invoice.BAKIYE[i]) and get_invoice.BAKIYE[i] gt 0.05)
					member_bakiye=get_invoice.BAKIYE[i];
				else
					member_bakiye=0;
					
				if(isdefined("get_invoice.INVOICE_COUNTY_NAME") and len(get_invoice.INVOICE_COUNTY_NAME[i]))
					INVOICE_COUNTY_NAME=left(get_invoice.INVOICE_COUNTY_NAME[i],12);
				else{INVOICE_COUNTY_NAME="";}
				
				if(isdefined("get_invoice.INVOICE_CITY_NAME") and len(get_invoice.INVOICE_CITY_NAME[i]))
					INVOICE_CITY_NAME=left(get_invoice.INVOICE_CITY_NAME[i],10);
				else{INVOICE_CITY_NAME="";}
				
				if(len(get_invoice.PAY_METHOD_NAME[i])) 
					paymethod_name=left(get_invoice.PAY_METHOD_NAME[i],35);
				else if(len(get_invoice.CARD_PAYMETHOD_NAME[i]))
					paymethod_name=left(get_invoice.CARD_PAYMETHOD_NAME[i],35);
				else
					paymethod_name='';
				
				if(isdefined("get_invoice.SUBSCRIPTION_NO"))
					uye_no=left(get_invoice.MEMBER_CODE[i]&"/"&get_invoice.SUBSCRIPTION_NO[i],35);
				else 
					uye_no=left(get_invoice.MEMBER_CODE[i],35);
				
				total_discount=(get_invoice.I_GROSSTOTAL[i]+get_invoice.I_TAXTOTAL[i])-get_invoice.I_NETTOTAL[i];//toplam indirimi bulmak icin yapiyoruz hesabi
				if(not total_discount gt 0.01) total_discount=0;
				if(get_invoice.RESOURCE_ID[i] eq 1) invoice_print=1; else invoice_print=2;
				if(isdefined("get_invoice.INVOICE_SEMT") and isdefined("get_invoice.INVOICE_ADDRESS"))
					adres=get_invoice.INVOICE_ADDRESS[i]&' '&get_invoice.INVOICE_SEMT[i];
				else
					adres='';
				adres=replace(adres,CRLF,' ','all');
				adres=replace(adres,chr(10),' ','all');
				adres=left(adres,160);
				//satır 1
				satir1="@4 "&repeatString(" ",364);
				satir1=yerles(satir1,left(get_invoice.MUSTERI_ADI[i],100),4,100," ");//consumer veya company adi
				satir1=yerles(satir1,dateformat(now(),'dd-mm-yyyy'),104,14," ");//fatura kesim tarihi
				satir1=yerles(satir1,adres,118,160," ");//adres
				satir1=yerles(satir1,INVOICE_COUNTY_NAME,278,12," ");//ilçe
				satir1=yerles(satir1,INVOICE_CITY_NAME,290,10," ");//il
				satir1=yerles(satir1,left(get_invoice.TEL_CODE[i]&get_invoice.TEL[i],15),300,15," ");//TEL
				satir1=yerles(satir1,left(get_invoice.TAXOFFICE[i],20),315,20," ");//vergi dairesi
				satir1=yerles(satir1,left(get_invoice.TAXNO[i],10),335,10," ");//vergi no
				satir1=yerles_saga(satir1,left(TLFormat(member_bakiye,2),12),345,12," ");//musteri bakiye
				satir1=yerles(satir1,system_money,357,5," ");//musteri bakiye para brimi
				satir1=yerles(satir1,invoice_print,365,1,"2");//fatura kesilecekmi kesilmeyecekmi C.RESOURCE_ID 1 olanlarda 1 diğerlerinde 2 yazılacak ve 1 olanlarda fatura kesilecek
				if(isdefined("get_invoice.REF_SUBSCRIPTION_COUNT"))
					satir1=yerles_saga(satir1,get_invoice.REF_SUBSCRIPTION_COUNT[i],366,2,"0");//referans olduğu üyelerin sayısını
				file_content[index_array] = satir1;
				index_array = index_array+1;
				
				//satır2
				satir2="@5 "&repeatString(" ",332);
				satir2=yerles(satir2,dateformat(get_invoice.I_INVOICE_DATE[i],dateformat_style),4,14," ");//fatura tarihi
				satir2=yerles(satir2,uye_no,18,35," ");//MUSTERİ numarası ve abone no *** cari muhasebe kodu yerine basılan 15 karakterde buraya eklenerek basıldı
				satir2=yerles(satir2,get_invoice.INVOICE_ID[i],53,10," ");//fatura numarası idsi
				satir2=yerles_saga(satir2,left(TLFormat((get_invoice.I_GROSSTOTAL[i]),2),12),63,12," ");//fatura kdv hariç tutarı
				satir2=yerles_saga(satir2,left(TLFormat(get_invoice.I_TAXTOTAL[i],2),12),75,12," ");//fatura kdv tutarı
				satir2=yerles_saga(satir2,left(TLFormat(get_invoice.I_NETTOTAL[i],2),12),87,12," ");//fatura kdvli tutar
				//satir2=yerles(satir2,left(TLFormat((get_invoice.I_GROSSTOTAL[i]/get_invoice.IM_RATE2[i]),2)&" "&get_invoice.I_OTHER_MONEY[i]&" Kur : "&TLFormat((get_invoice.IM_RATE2[i]/get_invoice.IM_RATE1[i]),4),30),99,30," ");//diğer para birimi açıklaması kdvsiz döviz tutarı v.s.
				satir2=yerles(satir2,left(TLFormat(((get_invoice.I_NETTOTAL[i]-get_invoice.I_TAXTOTAL[i])/get_invoice.IM_RATE2[i]),2)&" "&get_invoice.I_OTHER_MONEY[i]&" Kur : "&TLFormat((get_invoice.IM_RATE2[i]/get_invoice.IM_RATE1[i]),4),30),99,30," ");//diğer para birimi açıklaması kdvsiz döviz tutarı v.s.
				if(isdefined("attributes.from_report") and attributes.from_report neq 1)
					satir2=yerles(satir2,"Toplu Provizyon",129,20," ");//???
				satir2=yerles(satir2,paymethod_name,149,35," ");//ödeme yöntemi
				if(isdefined("get_invoice.SUBSCRIPTION_HEAD"))
					satir2=yerles(satir2,left(get_invoice.SUBSCRIPTION_HEAD[i],100),199,100," ");//abonelik tanımı
				satir2=yerles(satir2,left(TLFormat(total_discount,2),12),299,12," ");//indirim tutari ****tek satirken get_invoice.IR_DISCOUNTTOTAL[i] yaziyorduk
				//satir2=yerles(satir2,left(dateformat(date_add('d',20,get_invoice.I_INVOICE_DATE[i]),dateformat_style),10),311,14," ");//son odeme tarihi burdada simdilik fatura tarihine 20 gun ekliyor ancak invoice deki due_date dolu olursa ordan alacak
				satir2=yerles(satir2,left(dateformat(get_invoice.I_DUE_DATE[i],dateformat_style),10),311,14," ");//son odeme tarihi burdada simdilik fatura tarihine 20 gun ekliyor ancak invoice deki due_date dolu olursa ordan alacak
				satir2=yerles(satir2,left(get_invoice.TAXNO[i],11),325,11," ");//vergi no
				//satir2=yerles(satir2,"tarih",189,14," ");//banka havalesi ise tarih
				file_content[index_array] = satir2;
				index_array = index_array+1;
				
				//satır 3
				satir3="@6 "&repeatString(" ",99);
				satir3=yerles(satir3,left(get_invoice.MEMBER_CODE[i],12),4,12," ");//MUSTERİ numara
				satir3=yerles(satir3,left(get_invoice.IR_NAME_PRODUCT[i],62),16,62," ");//ürün adı -çeşit adıda olmalımı
				satir3=yerles_saga(satir3,left(get_invoice.IR_AMOUNT[i],5),78,5," ");//adet
				satir3=yerles(satir3,left(get_invoice.IR_UNIT[i],4),83,4," ");//birim
				satir3=yerles_saga(satir3,left(TLFormat(get_invoice.IR_PRICE[i]),12),87,12," ");//birim fiyat
				file_content[index_array] = satir3;
				index_array = index_array+1;
				
				//satır 4 iskontolu urunler
				if(len(get_invoice.IR_DISCOUNTTOTAL[i]) and get_invoice.IR_DISCOUNTTOTAL[i] gt 0)
				{
					satir4="@6 "&repeatString(" ",99);
					satir4=yerles(satir4,left(get_invoice.MEMBER_CODE[i],12),4,12," ");//MUSTERİ numara
					product_discount_name = "#get_invoice.IR_NAME_PRODUCT[i]# İskontosu";
					satir4=yerles(satir4,left(product_discount_name,62),16,62," ");//ürün adı -çeşit adıda olmalımı
					satir4=yerles_saga(satir4,left(get_invoice.IR_AMOUNT[i],5),78,5," ");//adet
					satir4=yerles(satir4,left(get_invoice.IR_UNIT[i],4),83,4," ");//birim
					product_discount_price = (get_invoice.IR_DISCOUNTTOTAL[i])*(-1);
					satir4=yerles_saga(satir4,left(TLFormat(product_discount_price),12),87,12," ");//birim fiyat
					file_content[index_array] = satir4;
					index_array = index_array+1;
				}
				
				urun_satiri=urun_satiri+1;
			}else
			{
				//satır 3 tekrar edenler için
				satir3="@6 "&repeatString(" ",99);
				satir3=yerles(satir3,left(get_invoice.MEMBER_CODE[i],12),4,12," ");//MUSTERİ numara
				satir3=yerles(satir3,left(get_invoice.IR_NAME_PRODUCT[i],62),16,62," ");//ürün adı -çeşit adıda olmalımı
				satir3=yerles_saga(satir3,left(get_invoice.IR_AMOUNT[i],5),78,5," ");//adet
				satir3=yerles(satir3,left(get_invoice.IR_UNIT[i],4),83,4," ");//birim
				satir3=yerles_saga(satir3,left(TLFormat(get_invoice.IR_PRICE[i]),12),87,12," ");//birim fiyat
				file_content[index_array] = satir3;
				index_array = index_array+1;
				
				//satır 4 iskontolu urunler
				if(len(get_invoice.IR_DISCOUNTTOTAL[i]) and get_invoice.IR_DISCOUNTTOTAL[i] gt 0)
				{
					satir4="@6 "&repeatString(" ",99);
					satir4=yerles(satir4,left(get_invoice.MEMBER_CODE[i],12),4,12," ");//MUSTERİ numara
					product_discount_name = "#get_invoice.IR_NAME_PRODUCT[i]# İskontosu";
					satir4=yerles(satir4,left(product_discount_name,62),16,62," ");//ürün adı -çeşit adıda olmalımı
					satir4=yerles_saga(satir4,left(get_invoice.IR_AMOUNT[i],5),78,5," ");//adet
					satir4=yerles(satir4,left(get_invoice.IR_UNIT[i],4),83,4," ");//birim
					product_discount_price = (get_invoice.IR_DISCOUNTTOTAL[i])*(-1);
					satir4=yerles_saga(satir4,left(TLFormat(product_discount_price),12),87,12," ");//birim fiyat
					file_content[index_array] = satir4;
					index_array = index_array+1;
				}
				
				urun_satiri=urun_satiri+1;
			}
			pre_invoice_id=get_invoice.invoice_id[i];
		}
    </cfscript>

   <cfset file_name = "Hobim#dateformat(now(),'YYYYMMDD')##timeFormat(now(),'HHmmss')#.txt">
   
   <cftry>
       <cflock name="#CreateUUID()#" timeout="60">
            <cftransaction>
				<cfset folder_name = "#upload_folder#finance#dir_seperator#bank">
            	<cffile action="append" output="#ArraytoList(file_content,CRLF)#" file="#folder_name##dir_seperator##file_name#" charset="iso-8859-9"><!---  charset="utf-8" --->
                
                <cfquery name="ADD_FILE_EXPORTS" datasource="#dsn2#" result="e_id">
                    INSERT INTO
                        FILE_EXPORTS
                        (
                            PROCESS_TYPE,
                            FILE_NAME,
                            <!---FILE_CONTENT,--->
                            FILE_STAGE,
                            RECORD_DATE,
                            RECORD_IP,
                            RECORD_EMP
                        )
                        VALUES
                        (
                            -22,
                            '#file_name#',
                            <!---<cfif isdefined("attributes.key_type")>'#Encrypt(ArraytoList(file_content,CRLF),attributes.key_type,"CFMX_COMPAT","Hex")#'<cfelse>'#ArraytoList(file_content,CRLF)#'</cfif>,--->
                            #attributes.hobim_stage_id#,
                            #now()#,
                            '#cgi.remote_addr#',
                            #session.ep.userid#
                        )
                </cfquery>
                <cfloop list="#attributes.invoice_multi_id#" index="i">
                    <cfquery name="upd_invoice_multi" datasource="#dsn2#">
                        UPDATE INVOICE_MULTI SET HOBIM_ID = #e_id.IDENTITYCOL# WHERE INVOICE_MULTI_ID = #i#
                    </cfquery>
                </cfloop>
            </cftransaction>
        </cflock>
        
        <script type="text/javascript">
            alert("Belge Oluşturma İşlemi Tamamlandı!");
            opener.location.reload();
            window.close();
        </script>
        
        <br/>Belge Oluşturma İşlemi Tamamlandı!
        <cfcatch><!--- hobim işlemlerinde belge kaydedilirken sorun olmuşsa,geri alınıcak bişey yoktur yeniden oluştulabilir,provizyon gibi değildir--->
            <br/>Belge Oluşturma İşlemi Tamamlanamadı!
        </cfcatch>
    </cftry>
<cfelse>
    <script type="text/javascript">
        alert("Seçtiğiniz Toplu Faturalama İle İlişkili Fatura Bulunamadı!");
        window.close();
    </script>
</cfif>
