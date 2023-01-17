<cfif attributes.old_ims_code neq attributes.ims_code_id>
	<cfquery name="UPD_CONTROL" datasource="#DSN#">
		SELECT 
			*
		FROM 
			COMPANY_BRANCH_RELATED
		WHERE
			RELATED_ID = #attributes.related_id# AND
			RECORD_DATE < #DATEADD("d",-1,now())#
	</cfquery>
	<cfif upd_control.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='987.Bu Kayıt İçin Güncelleme Yapamazsınız!Gerekli Bilgi İçin Yetkiliyi Arayınız'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cf_date tarih='attributes.open_date'>
<cf_date tarih='attributes.close_date'>
<cfscript>
	form_company_id = listgetat(attributes.store_id, 1, ',');
	form_branch_id = listgetat(attributes.store_id, 2, ',');
	attributes.is_record = false;
</cfscript>
<cfif len(attributes.carihesapkod)>
	<cfquery name="GET_CARI" datasource="#DSN#">
		SELECT 
			RELATED_ID 
		FROM 
			COMPANY_BRANCH_RELATED 
		WHERE 
			MUSTERIDURUM IS NOT NULL AND
			CARIHESAPKOD = '#attributes.carihesapkod#' AND 
			BRANCH_ID = #form_branch_id# AND
			RELATED_ID <> #attributes.related_id#
	</cfquery>
	<cfif get_cari.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='983.Aynı Cari Hesap Kodu İle Kayıtlı Müşteriniz Var ! Bu Cari Hesap Kodu İle Kayıt Yapamazsınız'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>

<cfquery name="ADD_COMPANY_RELATED" datasource="#DSN#">
	UPDATE
		COMPANY_BRANCH_RELATED
	SET
		COMPANY_ID = #attributes.cpid#,
		OUR_COMPANY_ID = #form_company_id#,
		BRANCH_ID = #form_branch_id#,
		BOLGE_KODU = '#attributes.bolge_kodu#',
		ALTBOLGE_KODU = '#attributes.altbolge_kodu#',
		CALISMA_SEKLI = '#attributes.calisma_sekli#',
		CARIHESAPKOD = <cfif len(attributes.carihesapkod)>'#attributes.carihesapkod#'<cfelse>NULL</cfif>,
		MUSTERIDURUM = <cfif len(attributes.cat_status)>#attributes.cat_status#<cfelse>NULL</cfif>,
		DEPOT_KM = <cfif len(attributes.depot_km)>#attributes.depot_km#<cfelse>NULL</cfif>,
		DEPOT_DAK = <cfif len(attributes.depot_dak)>#attributes.depot_dak#<cfelse>NULL</cfif>,
		MUHASEBEKOD = <cfif len(attributes.muhasebekod)>'#attributes.muhasebekod#'<cfelse>NULL</cfif>,
		DEPO_STATUS = #attributes.process_stage#,
		SALES_DIRECTOR = <cfif len(attributes.satis_muduru_id) and len(attributes.satis_muduru)>#attributes.satis_muduru_id#<cfelse>NULL</cfif>,
		TEL_SALE_PREID = <cfif len(attributes.telefon_satis_id) and len(attributes.telefon_satis)>#attributes.telefon_satis_id#<cfelse>NULL</cfif>,
		PLASIYER_ID = <cfif len(attributes.plasiyer_id) and len(attributes.plasiyer)>#attributes.plasiyer_id#<cfelse>NULL</cfif>,
		OPEN_DATE = <cfif len(attributes.open_date)>#attributes.open_date#<cfelse>NULL</cfif>,
		CLOSE_DATE = <cfif len(attributes.close_date)>#attributes.close_date#<cfelse>NULL</cfif>,
		RELATION_START = <cfif len(attributes.resource)>#attributes.resource#<cfelse>NULL</cfif>,
		RELATION_STATUS = <cfif len(attributes.depot_relation)>#attributes.depot_relation#<cfelse>NULL</cfif>,
		COMP_STATUS = <cfif len(attributes.status)>'#attributes.status#'<cfelse>NULL</cfif>,
		SHIPPING_ZONE_CODE=<cfif len(attributes.shipping_zone_code)>'#attributes.shipping_zone_code#'<cfelse>NULL</cfif>,
		TAHSILATCI = <cfif len(attributes.tahsilatci_id) and len(attributes.tahsilatci)>#attributes.tahsilatci_id#<cfelse>NULL</cfif>,
		CEP_SIRA = <cfif len(attributes.cep_sira_no)>'#attributes.cep_sira_no#'<cfelse>NULL</cfif>,
		ITRIYAT_GOREVLI = <cfif len(attributes.itriyat_id)>#attributes.itriyat_id#<cfelse>NULL</cfif>,
		BOYUT_TAHSILAT = <cfif len(attributes.boyut_tahsilat)>'#attributes.boyut_tahsilat#'<cfelse>NULL</cfif>,
		BOYUT_ITRIYAT = <cfif len(attributes.boyut_itriyat)>'#attributes.boyut_itriyat#'<cfelse>NULL</cfif>,
		BOYUT_TELEFON = <cfif len(attributes.boyut_telefon)>'#attributes.boyut_telefon#'<cfelse>NULL</cfif>,
		BOYUT_PLASIYER = <cfif len(attributes.boyut_plasiyer)>'#attributes.boyut_plasiyer#'<cfelse>NULL</cfif>,
		BOYUT_BSM = <cfif len(attributes.boyut_satis)>'#attributes.boyut_satis#'<cfelse>NULL</cfif>,
		AVERAGE_DUE_DATE = <cfif len(attributes.average_due_date)>#attributes.average_due_date#<cfelse>NULL</cfif>,
		OPENING_PERIOD = <cfif len(attributes.opening_period)>#attributes.opening_period#<cfelse>NULL</cfif>,
		MF_DAY = <cfif len(attributes.mf_day)>#attributes.mf_day#<cfelse>NULL</cfif>,
		LOGO_MUSTERI_TIP = <cfif len(attributes.logo_musteri_tip)>'#attributes.logo_musteri_tip#'<cfelse>'0'</cfif>,
		CUSTOMER_CONTRACT_STATUTE = <cfif isdefined("attributes.customer_contract_statute")>1<cfelse>0</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#'		
	WHERE
		RELATED_ID = #attributes.related_id#
</cfquery>
<cfquery name="GET_FULLNAME" datasource="#DSN#">
	SELECT FULLNAME, ISPOTANTIAL FROM COMPANY WHERE COMPANY_ID = #attributes.cpid#
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT
		OUR_COMPANY.COMPANY_NAME,
		BRANCH.BRANCH_NAME
	FROM
		BRANCH,
		OUR_COMPANY
	WHERE
		BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND
		BRANCH.BRANCH_ID = #form_branch_id#
</cfquery>
<cfquery name="GET_ISSELECT" datasource="#DSN#">
	SELECT IS_SELECT FROM COMPANY_BRANCH_RELATED WHERE RELATED_ID = #attributes.related_id#
</cfquery>
<cfif get_isselect.is_select eq 1>
	<cfquery name="GET_STORES_RELATED_COM" datasource="#DSN#">
		SELECT COMPANY_ID FROM COMPANY_PARTNER_STORES_RELATED WHERE COMPANY_ID = #attributes.cpid# AND OUR_COMPANY_ID = #form_company_id#
	</cfquery>
	<cfif not get_stores_related_com.recordcount>
		<cfquery name="ins_comps" datasource="#DSN#">
			INSERT INTO
				COMPANY_PARTNER_STORES_RELATED
			(
				OUR_COMPANY_ID,
				COMPANY_ID
			)
			VALUES
			(
				#form_company_id#,
				#attributes.cpid#
			)
		</cfquery>
	</cfif>
</cfif>
<cfquery name="GET_CREDIT" datasource="#DSN#">
	SELECT * FROM COMPANY_CREDIT WHERE BRANCH_ID = #attributes.related_id#
</cfquery>
<cfif get_credit.recordcount>
	<cfquery name="ADD_RISK_LIMIT" datasource="#DSN#">
		UPDATE
			COMPANY_CREDIT
		SET
			TOTAL_RISK_LIMIT = <cfif len(attributes.risk_limit)>#attributes.risk_limit#<cfelse>0</cfif>,
			MONEY = '#attributes.money#',
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#cgi.remote_addr#'
		WHERE
			BRANCH_ID = #attributes.related_id#
	</cfquery>
<cfelse>
	<cfquery name="ADD_RISK_LIMIT" datasource="#DSN#">
		INSERT INTO
			COMPANY_CREDIT
		(
			OUR_COMPANY_ID,
			COMPANY_ID,
			TOTAL_RISK_LIMIT,
			MONEY,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			BRANCH_ID
		)
		VALUES
		(
			#form_company_id#,
			#attributes.cpid#,
			<cfif len(attributes.risk_limit)>#attributes.risk_limit#,<cfelse>0,</cfif>
			'#attributes.money#',
			#now()#,
			#session.ep.userid#,
			'#cgi.remote_addr#',
			#attributes.related_id#
		)
	</cfquery>
</cfif>
<cfset attributes.is_record = true>
<!--- Bu kontrol talepleri uzerine kapatildi 20110707
kapama ve devir islemleri icin, bir sube kapandıgında veya devir oldugunda diger butun subeler kapanmalı veya devir olmalıdır AE 20050610
<cfif listfind("1,2",attributes.cat_status,',')>
	<cfquery name="CLOSE_COMPANY_RELATED" datasource="#DSN#">
		UPDATE 
			COMPANY_BRANCH_RELATED
		SET
			MUSTERIDURUM = #attributes.cat_status#
		WHERE
			COMPANY_ID = #attributes.cpid#
	</cfquery>
</cfif>
--->
<cfif (attributes.cat_status neq 1) or (attributes.cat_status neq 4)>
	<cfif attributes.is_record>
		<cfscript>
			max_branch_id = attributes.related_id;
			cpid = attributes.cpid;
			is_insert_type = 4;
		</cfscript>
		<cf_workcube_process 
			is_upd='1' 
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_page='#request.self#?fuseaction=crm.detail_company&cpid=#attributes.cpid#&related_id=#attributes.related_id#&is_open_popup=1' 
			action_id='#attributes.cpid#'
			old_process_line='#attributes.old_process_line#'
			warning_description = 'Müşteri : #get_fullname.fullname# Depo : #get_branch.company_name#/#get_branch.branch_name#'>
	</cfif>
</cfif>
<script type="text/javascript">
	window.opener.location.href='<cfoutput>#request.self#?fuseaction=crm.popup_upd_consumer_branch&cpid=#attributes.cpid#</cfoutput>';
	window.close();
</script>
