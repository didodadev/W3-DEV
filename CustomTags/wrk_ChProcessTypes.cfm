<!--- wrk_ChProcessTypes İşlem tiplerinin select box olarak listelenmesi için. 20100609 Halime--->
<cfparam name="attributes.fieldId" default="action_type"><!--- alan adı --->
<cfparam name="attributes.width" default="235"><!--- genişlik --->
<cfparam name="attributes.height" default=""><!--- yükseklik (çoklu için) --->
<cfparam name="attributes.selected_value" default=""><!--- Liste sayfaları için form değeri --->
<cfparam name="attributes.is_multiple" default="0"><!--- Çoklu seçim seçeneği--->
<cfparam name="attributes.select_process_cat" default="0"><!--- 1 gelirse işlem tiplerinin process catları ile birlikte seçilir --->
<cfparam name="attributes.is_pay_term" default="0"><!--- Ödeme Sözü gerektiğinde --->
<cfparam name="attributes.is_cats_and_type" default="0"><!---işlem tipi kategorileri gerektiğinde--->
<cfif attributes.select_process_cat eq 1>
	<cfquery name="GET_PROCESS_CATS_INV" datasource="#CALLER.DSN3#">
		SELECT 
			PROCESS_CAT_ID,
			#caller.dsn#.Get_Dynamic_Language(PROCESS_CAT_ID,'#session.ep.language#','SETUP_PROCESS_CAT','PROCESS_CAT',NULL,NULL,PROCESS_CAT) AS PROCESS_CAT,
			PROCESS_TYPE,
			CONVERT(varchar, PROCESS_CAT_ID) + '-' +  CONVERT(varchar, PROCESS_TYPE) as MULTIPLE
		FROM 
			SETUP_PROCESS_CAT
		WHERE
			PROCESS_TYPE IN(63,601,60,61,51,62,37,690,691,591,531,59,64,52,54,53,55,50,561,56,57,58,532,48,49,5311) AND 
            IS_CARI = 1 
		ORDER BY 
			PROCESS_CAT
	</cfquery>
	<cfquery name="GET_PROCESS_CATS_BANK" datasource="#CALLER.DSN3#">
		SELECT 
			PROCESS_CAT_ID,
			#caller.dsn#.Get_Dynamic_Language(PROCESS_CAT_ID,'#session.ep.language#','SETUP_PROCESS_CAT','PROCESS_CAT',NULL,NULL,PROCESS_CAT) AS PROCESS_CAT,
			PROCESS_TYPE,
			CONVERT(varchar, PROCESS_CAT_ID) + '-' +  CONVERT(varchar, PROCESS_TYPE) as MULTIPLE
		FROM 
			SETUP_PROCESS_CAT
		WHERE
			PROCESS_TYPE IN(24,25,241,245,242,291,292,293,294,240,253,250,251) AND 
            IS_CARI = 1 
		ORDER BY 
			PROCESS_CAT
	</cfquery>
	<cfquery name="GET_PROCESS_CATS_CASH" datasource="#CALLER.DSN3#">
		SELECT 
			PROCESS_CAT_ID,
			#caller.dsn#.Get_Dynamic_Language(PROCESS_CAT_ID,'#session.ep.language#','SETUP_PROCESS_CAT','PROCESS_CAT',NULL,NULL,PROCESS_CAT) AS PROCESS_CAT,
			PROCESS_TYPE,
			CONVERT(varchar, PROCESS_CAT_ID) + '-' +  CONVERT(varchar, PROCESS_TYPE) as MULTIPLE
		FROM 
			SETUP_PROCESS_CAT
		WHERE
			PROCESS_TYPE IN(31,32,310,320) AND 
            IS_CARI = 1 
		ORDER BY 
			PROCESS_CAT
	</cfquery>
	<cfquery name="GET_PROCESS_CATS_CARI" datasource="#CALLER.DSN3#">
		SELECT 
			PROCESS_CAT_ID,
			#caller.dsn#.Get_Dynamic_Language(PROCESS_CAT_ID,'#session.ep.language#','SETUP_PROCESS_CAT','PROCESS_CAT',NULL,NULL,PROCESS_CAT) AS PROCESS_CAT,
			PROCESS_TYPE,
			CONVERT(varchar, PROCESS_CAT_ID) + '-' +  CONVERT(varchar, PROCESS_TYPE) as MULTIPLE
		FROM 
			SETUP_PROCESS_CAT
		WHERE
			PROCESS_TYPE IN(42,41,131,43,40,46,45,410,420,430,160,161) AND
            IS_CARI = 1 
		ORDER BY 
			PROCESS_CAT
	</cfquery>
	<cfquery name="GET_PROCESS_CATS_EXP" datasource="#CALLER.DSN3#">
		SELECT 
			PROCESS_CAT_ID,
			#caller.dsn#.Get_Dynamic_Language(PROCESS_CAT_ID,'#session.ep.language#','SETUP_PROCESS_CAT','PROCESS_CAT',NULL,NULL,PROCESS_CAT) AS PROCESS_CAT,
			PROCESS_TYPE,
			CONVERT(varchar, PROCESS_CAT_ID) + '-' +  CONVERT(varchar, PROCESS_TYPE) as MULTIPLE
		FROM 
			SETUP_PROCESS_CAT
		WHERE
			PROCESS_TYPE IN(120,121) AND 
            IS_CARI = 1 
		ORDER BY 
			PROCESS_CAT
	</cfquery>
	<cfquery name="GET_PROCESS_CATS_CHEQUE" datasource="#CALLER.DSN3#">
		SELECT 
			PROCESS_CAT_ID,
			#caller.dsn#.Get_Dynamic_Language(PROCESS_CAT_ID,'#session.ep.language#','SETUP_PROCESS_CAT','PROCESS_CAT',NULL,NULL,PROCESS_CAT) AS PROCESS_CAT,
			PROCESS_TYPE,
			CONVERT(varchar, PROCESS_CAT_ID) + '-' +  CONVERT(varchar, PROCESS_TYPE) as MULTIPLE
		FROM 
			SETUP_PROCESS_CAT
		WHERE
			PROCESS_TYPE IN(90,91,95,94,97,98,101,108) AND 
            IS_CARI = 1 
		ORDER BY 
			PROCESS_CAT
	</cfquery>
</cfif>
<cfoutput>
	<cfif attributes.select_process_cat eq 1>
		<select name="#attributes.fieldId#" id="#attributes.fieldId#" <cfif attributes.is_multiple eq 1>multiple</cfif> style="width:#attributes.width#px;height:#attributes.height#px">
			<cfif attributes.is_multiple eq 0><option value="" selected>#caller.getLang('main',388)#</option></cfif>
				<cfif isdefined("attributes.is_cats_and_type") and attributes.is_cats_and_type eq 1>
					<optgroup label="#caller.getLang('main',1505)#">
						<cfloop query="get_process_cats_inv">
							<option value="#get_process_cats_inv.process_cat_id#-#get_process_cats_inv.process_type#" <cfif listfind(attributes.selected_value,get_process_cats_inv.MULTIPLE)>selected</cfif>>#get_process_cats_inv.process_cat#</option>
						</cfloop>
					</optgroup>
					<optgroup label="#caller.getLang('main',1484)#">
						<cfloop query="get_process_cats_bank">
							<option value="#get_process_cats_bank.process_cat_id#-#get_process_cats_bank.process_type#" <cfif listfind(attributes.selected_value,get_process_cats_bank.MULTIPLE)>selected</cfif>>#get_process_cats_bank.process_cat#</option>
						</cfloop>
					</optgroup>
					<optgroup label="#caller.getLang('main',1485)#">
						<cfloop query="get_process_cats_cash">
							<option value="#get_process_cats_cash.process_cat_id#-#get_process_cats_cash.process_type#" <cfif listfind(attributes.selected_value,get_process_cats_cash.MULTIPLE)>selected</cfif>>#get_process_cats_cash.process_cat#</option>
						</cfloop>
					</optgroup>
					<optgroup label="#caller.getLang('main',1486)#">
						<cfloop query="get_process_cats_cari">
							<option value="#get_process_cats_cari.process_cat_id#-#get_process_cats_cari.process_type#" <cfif listfind(attributes.selected_value,get_process_cats_cari.MULTIPLE)>selected</cfif>>#get_process_cats_cari.process_cat#</option>
						</cfloop>
					</optgroup>
					<optgroup label="#caller.getLang('main',1487)#">
						<cfloop query="get_process_cats_exp">
							<option value="#get_process_cats_exp.process_cat_id#-#get_process_cats_exp.process_type#" <cfif listfind(attributes.selected_value,get_process_cats_exp.MULTIPLE)>selected</cfif>>#get_process_cats_exp.process_cat#</option>
						</cfloop>
					</optgroup>
					<optgroup label="#caller.getLang('main',1488)#">
						<cfloop query="get_process_cats_cheque">
							<option value="#get_process_cats_cheque.process_cat_id#-#get_process_cats_cheque.process_type#" <cfif listfind(attributes.selected_value,get_process_cats_cheque.MULTIPLE)>selected</cfif>>#get_process_cats_cheque.process_cat#</option>
						</cfloop>
					</optgroup>
				<cfelse>
					<optgroup label="#caller.getLang('main',1505)#">
						<cfloop query="get_process_cats_inv">
							<option value="#get_process_cats_inv.process_cat_id#" <cfif listfind(attributes.selected_value,get_process_cats_inv.process_cat_id)>selected</cfif>>#get_process_cats_inv.process_cat#</option>
						</cfloop>
					</optgroup>
					<optgroup label="#caller.getLang('main',1484)#">
						<cfloop query="get_process_cats_bank">
							<option value="#get_process_cats_bank.process_cat_id#" <cfif listfind(attributes.selected_value,get_process_cats_bank.process_cat_id)>selected</cfif>>#get_process_cats_bank.process_cat#</option>
						</cfloop>
					</optgroup>
					<optgroup label="#caller.getLang('main',1485)#">
						<cfloop query="get_process_cats_cash">
							<option value="#get_process_cats_cash.process_cat_id#" <cfif listfind(attributes.selected_value,get_process_cats_cash.process_cat_id)>selected</cfif>>#get_process_cats_cash.process_cat#</option>
						</cfloop>
					</optgroup>
					<optgroup label="#caller.getLang('main',1486)#">
						<cfloop query="get_process_cats_cari">
							<option value="#get_process_cats_cari.process_cat_id#" <cfif listfind(attributes.selected_value,get_process_cats_cari.process_cat_id)>selected</cfif>>#get_process_cats_cari.process_cat#</option>
						</cfloop>
					</optgroup>
					<optgroup label="#caller.getLang('main',1487)#">
						<cfloop query="get_process_cats_exp">
							<option value="#get_process_cats_exp.process_cat_id#" <cfif listfind(attributes.selected_value,get_process_cats_exp.process_cat_id)>selected</cfif>>#get_process_cats_exp.process_cat#</option>
						</cfloop>
					</optgroup>
					<optgroup label="#caller.getLang('main',1488)#">
						<cfloop query="get_process_cats_cheque">
							<option value="#get_process_cats_cheque.process_cat_id#" <cfif listfind(attributes.selected_value,get_process_cats_cheque.process_cat_id)>selected</cfif>>#get_process_cats_cheque.process_cat#</option>
						</cfloop>
					</optgroup>
					<cfif attributes.is_pay_term eq 1>
						<optgroup label="#caller.getLang('main',2148)#">
							<option value="-1"<cfif attributes.selected_value eq -1>selected</cfif>>#caller.getLang('main',2148)#</option><!---Ödeme Sözü--->
						</optgroup>
					</cfif>
				</cfif>
		</select>
	<cfelse>
		<select name="#attributes.fieldId#" id="#attributes.fieldId#"<cfif attributes.is_multiple eq 1>multiple</cfif> style="width:#attributes.width#px;height:#attributes.height#px">
			<cfif attributes.is_multiple eq 0><option value="" selected>#caller.getLang('main',388)#</option></cfif>
			<optgroup label="#caller.getLang('main',1505)#"><!---Faturalar --->
				<option value="63" <cfif listfind(attributes.selected_value,63)>selected</cfif>>#caller.getLang('main',399)#</option><!---Alınan Fiyat Farkı Faturası--->
				<option value="601" <cfif listfind(attributes.selected_value,601)>selected</cfif>>#caller.getLang('main',400)#</option><!---Alınan Hakediş Faturası--->
				<option value="60" <cfif listfind(attributes.selected_value,60)> selected</cfif>>#caller.getLang('main',401)#</option><!---Alınan Hizmet Faturası--->
				<option value="49" <cfif listfind(attributes.selected_value,49)>selected</cfif>>#caller.getLang('main',1776)#</option><!---Alınan Kur Farkı Faturası--->
				<option value="61" <cfif listfind(attributes.selected_value,61)>selected</cfif>>#caller.getLang('main',402)#</option><!---Alınan Proforma Faturası--->
				<option value="51" <cfif listfind(attributes.selected_value,51)>selected</cfif>>#caller.getLang('main',351)#</option><!---Alınan Vade Farkı Faturası--->
				<option value="62" <cfif listfind(attributes.selected_value,62)>selected </cfif>>#caller.getLang('main',403)#</option><!---Alım İade Faturası--->
				<option value="37" <cfif listfind(attributes.selected_value,37)>selected</cfif>>#caller.getLang('main',404)#</option><!---Gider Pusulası--->
				<option value="690" <cfif listfind(attributes.selected_value,690)>selected</cfif>>#caller.getLang('main',405)#</option><!---Gider Pusulası (Mal)--->
				<option value="691" <cfif listfind(attributes.selected_value,691)>selected</cfif>>#caller.getLang('main',406)#</option><!---Gider Pusulası (Hizmet)--->
			<cfif session.ep.our_company_info.workcube_sector is "per">
                <option value="592" <cfif listfind(attributes.selected_value,592)>selected</cfif>>#caller.getLang('main',407)#</option><!---Hal Faturası--->
            </cfif>
				<option value="591" <cfif listfind(attributes.selected_value,591)>selected</cfif>>#caller.getLang('main',408)#</option><!---İthalat Faturası--->
				<option value="531" <cfif listfind(attributes.selected_value,531)>selected</cfif>>#caller.getLang('main',409)#</option><!---İhracat Faturası--->
				<option value="59" <cfif listfind(attributes.selected_value,59)>selected</cfif>>#caller.getLang('main',410)#</option><!---Mal Alım Faturası--->
				<option value="64" <cfif listfind(attributes.selected_value,64)> selected</cfif>>#caller.getLang('main',411)#</option><!---Müstahsil Makbuzu--->
				<option value="52" <cfif listfind(attributes.selected_value,52)>selected</cfif>>#caller.getLang('main',353)#</option><!---Perakende Satış Faturası--->
				<option value="54" <cfif listfind(attributes.selected_value,54)>selected</cfif>>#caller.getLang('main',412)#</option><!---Perakende Satış İade Faturası--->
				<option value="53" <cfif listfind(attributes.selected_value,53)>selected</cfif>>#caller.getLang('main',413)#</option><!---Toptan Satış Faturası--->
				<option value="55" <cfif listfind(attributes.selected_value,55)>selected</cfif>>#caller.getLang('main',356)#</option><!---Toptan Satış İade Faturası--->
				<option value="50" <cfif listfind(attributes.selected_value,50)>selected</cfif>>#caller.getLang('main',415)#</option><!---Verilen Vade Farkı Faturası--->
				<option value="561" <cfif listfind(attributes.selected_value,561)>selected</cfif>>#caller.getLang('main',416)#</option><!---Verilen Hakediş Faturası--->
				<option value="56" <cfif listfind(attributes.selected_value,56)>selected</cfif>>#caller.getLang('main',417)#</option><!---Verilen Hizmet Faturası--->
				<option value="48" <cfif listfind(attributes.selected_value,48)>selected</cfif>>#caller.getLang('main',1775)#</option><!---Verilen Kur Farkı Faturası--->
				<option value="57" <cfif listfind(attributes.selected_value,57)>selected</cfif>>#caller.getLang('main',358)#</option><!---Verilen Proforma Faturası--->
				<option value="58" <cfif listfind(attributes.selected_value,58)>selected</cfif>>#caller.getLang('main',418)#</option><!---Verilen Fiyat Farkı Faturası--->
			</optgroup>
			<optgroup label="#caller.getLang('main',1484)#"><!---Banka İşlemleri --->
				<option value="24" <cfif listfind(attributes.selected_value,24)>selected</cfif>>#caller.getLang('main',422)#</option><!---Gelen Havale--->
				<option value="25" <cfif listfind(attributes.selected_value,25)>selected</cfif>>#caller.getLang('main',423)#</option><!---Giden Havale--->
				<option value="241" <cfif listfind(attributes.selected_value,241)>selected</cfif>>#caller.getLang('main',424)#</option><!---Kredi Kartı Tahsilat--->
				<option value="245" <cfif listfind(attributes.selected_value,245)>selected</cfif>>#caller.getLang('main',1755)#</option><!---Kredi Kartı Tahsilat İptal--->
				<option value="242" <cfif listfind(attributes.selected_value,242)>selected</cfif>>#caller.getLang('main',425)#</option><!---Kredi Kartı Ödeme--->
				<option value="291" <cfif listfind(attributes.selected_value,291)>selected</cfif>>#caller.getLang('main',426)#</option><!---Kredi Ödemesi--->
				<option value="292" <cfif listfind(attributes.selected_value,292)>selected</cfif>>#caller.getLang('main',427)#</option><!---Kredi Tahsilatı--->
				<option value="293" <cfif listfind(attributes.selected_value,293)>selected</cfif>>#caller.getLang('main',428)#</option><!---Menkul Kıymet Alış--->
				<option value="294" <cfif listfind(attributes.selected_value,294)>selected</cfif>>#caller.getLang('main',429)#</option><!---Menkul Kıymet Satış--->
				<option value="250" <cfif listfind(attributes.selected_value,250)>selected</cfif>>#caller.getLang('main',755)#</option><!---Giden Banka Talimatı--->
				<option value="251" <cfif listfind(attributes.selected_value,251)>selected</cfif>>#caller.getLang('main',753)#</option><!---Gelen Banka Talimatı--->
			</optgroup>
			<optgroup label="#caller.getLang('main',1485)#"><!---Kasa İşlemleri --->
				<option value="31" <cfif listfind(attributes.selected_value,31)>selected</cfif>>#caller.getLang('main',433)#</option><!---Tahsilat--->
				<option value="32" <cfif listfind(attributes.selected_value,32)>selected</cfif>>#caller.getLang('main',435)#</option><!---Ödeme--->
				<option value="310" <cfif listfind(attributes.selected_value,310)>selected</cfif>>#caller.getLang('main',1763)#</option><!---Toplu Tahsilat--->
				<option value="320" <cfif listfind(attributes.selected_value,320)>selected</cfif>>#caller.getLang('main',1765)#</option><!---Toplu Ödeme--->
			</optgroup>
			<optgroup label="#caller.getLang('main',1486)#"><!---Cari İşlemleri --->
				<option value="42" <cfif listfind(attributes.selected_value,42)>selected</cfif>>#caller.getLang('main',436)#</option><!---Alacak Dekontu--->
				<option value="41" <cfif listfind(attributes.selected_value,41)>selected</cfif>>#caller.getLang('main',437)#</option><!---Borç Dekontu--->
				<option value="131" <cfif listfind(attributes.selected_value,131)>selected</cfif>>#caller.getLang('main',2149)#</option><!---Ücret Dekontu--->
				<option value="43" <cfif listfind(attributes.selected_value,43)>selected</cfif>>#caller.getLang('main',438)#</option><!---Cari Virman Fişi--->
				<option value="40" <cfif listfind(attributes.selected_value,40)>selected</cfif>>#caller.getLang('main',439)#</option><!---C/H Açılış Fişi--->
				<option value="46" <cfif listfind(attributes.selected_value,46)>selected</cfif>>#caller.getLang('main',1482)#</option><!---Alacak Kur Değerleme Dekontu--->
				<option value="45" <cfif listfind(attributes.selected_value,45)>selected</cfif>>#caller.getLang('main',1483)#</option><!---Borç Kur Değerleme Dekontu--->
				<option value="410" <cfif listfind(attributes.selected_value,410)>selected</cfif>>#caller.getLang('main',1773)#</option><!---Toplu Borç Dekontu--->
				<option value="420" <cfif listfind(attributes.selected_value,420)>selected</cfif>>#caller.getLang('main',1774)#</option><!---Toplu Alacak Dekontu--->
				<option value="160" <cfif listfind(attributes.selected_value,160)>selected</cfif>>#caller.getLang('main',2150)#</option><!---Bütçe Planlama Fişi--->
				<option value="161" <cfif listfind(attributes.selected_value,161)>selected</cfif>>#caller.getLang('main',1853)#</option><!---Tahakkuk Fişi--->
			</optgroup>
			<optgroup label="#caller.getLang('main',1487)#"><!---Masraf- Gelir Fişleri --->
				<option value="120" <cfif listfind(attributes.selected_value,120)>selected</cfif>>#caller.getLang('main',652)#</option><!---Masraf Fişi--->
				<option value="121" <cfif listfind(attributes.selected_value,121)>selected</cfif>>#caller.getLang('main',653)#</option><!---Gelir Fişi--->
			</optgroup>
			<optgroup label="#caller.getLang('main',1488)#"><!----Çek Senet İşlemleri--->
				<option value="90" <cfif listfind(attributes.selected_value,90)>selected</cfif>>#caller.getLang('main',440)#</option><!---Çek Giriş Bordrosu--->
				<option value="91" <cfif listfind(attributes.selected_value,91)>selected</cfif>>#caller.getLang('main',443)#</option><!---Çek Çıkış Bordrosu-Ciro--->
				<option value="95" <cfif listfind(attributes.selected_value,95)>selected</cfif>>#caller.getLang('main',444)#</option><!---Çek İade Giriş Bordrosu--->
				<option value="94" <cfif listfind(attributes.selected_value,94)>selected</cfif>>#caller.getLang('main',445)#</option><!---Çek İade Çıkış Bordrosu--->
				<option value="97" <cfif listfind(attributes.selected_value,97)>selected</cfif>>#caller.getLang('main',598)# </option><!---Senet Giris Bordrosu--->
				<option value="98" <cfif listfind(attributes.selected_value,98)>selected</cfif>>#caller.getLang('main',599)#</option><!---Senet Çıkış Bordrosu--->
				<option value="101" <cfif listfind(attributes.selected_value,101)>selected</cfif>>#caller.getLang('main',600)#</option><!---Senet İade Çıkış Bordrosu--->
				<option value="108" <cfif listfind(attributes.selected_value,108)>selected</cfif>>#caller.getLang('main',601)#</option><!---Senet İade Giriş Bordrosu--->
			</optgroup>
		<cfif attributes.is_pay_term eq 1>
            <optgroup label="#caller.getLang('main',2148)#">
                <option value="-1"<cfif attributes.selected_value eq -1>selected</cfif>>#caller.getLang('main',2148)#</option><!---Ödeme Sözü--->
            </optgroup>
        </cfif>
		</select>
	</cfif>	
</cfoutput>
