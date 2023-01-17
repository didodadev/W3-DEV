<cf_date tarih='attributes.open_date'>
<cfscript>
	form_company_id = listgetat(attributes.store_id, 1, ',');
	form_branch_id = listgetat(attributes.store_id, 2, ',');
	attributes.is_record = false;
</cfscript>
<cfif len(attributes.carihesapkod)>
	<cfquery name="GET_CARI" datasource="#DSN#">
		SELECT RELATED_ID FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND CARIHESAPKOD = '#attributes.carihesapkod#' AND BRANCH_ID = #form_branch_id#
	</cfquery>
	<cfif get_cari.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='983.Aynı Cari Hesap Kodu İle Kayıtlı Müşteriniz Var Bu Cari Hesap Kodu İle Kayıt Yapamazsınız'> !");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfquery name="CONTROL_COMPANY" datasource="#DSN#">
	SELECT W_KODU FROM COMPANY_BOYUT_DEPO_KOD WHERE W_KODU = #form_branch_id#
</cfquery>
<cfif control_company.recordcount eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang no ='982.Müşteri Eklemek İstediğiniz Depo Boyut İle Uyumlu Bir Depo Değil'> !");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_RELATED" datasource="#DSN#">
	SELECT RELATED_ID FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND COMPANY_ID = #attributes.cpid# AND BRANCH_ID = #form_branch_id# AND IS_SELECT = 1
</cfquery>
<cfif get_related.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='999.Kayıt Yapmak İstediğiniz Şubeye Ait Bir Kayıt Var'> !");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cftry>
<cftransaction>
	<cfquery name="ADD_COMPANY_RELATED" datasource="#DSN#" result="MAX_ID">
		INSERT INTO
			COMPANY_BRANCH_RELATED
		(
			BOLGE_KODU,
			ALTBOLGE_KODU,
			CALISMA_SEKLI,
			PUAN,
			COMPANY_ID,
			OUR_COMPANY_ID,
			BRANCH_ID,
			IS_SELECT,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			CARIHESAPKOD,
			MUSTERIDURUM,
			DEPOT_KM,
			DEPOT_DAK,
			MUHASEBEKOD,
			DEPO_STATUS,
			SALES_DIRECTOR,
			TEL_SALE_PREID,
			PLASIYER_ID,
			OPEN_DATE,
			RELATION_START,
			RELATION_STATUS,
			COMP_STATUS,
			SHIPPING_ZONE_CODE,
			TAHSILATCI,
			CEP_SIRA,
			ITRIYAT_GOREVLI,
			BOYUT_TAHSILAT,
			BOYUT_ITRIYAT,
			BOYUT_TELEFON,
			BOYUT_PLASIYER,
			BOYUT_BSM,
			AVERAGE_DUE_DATE,
			OPENING_PERIOD,
			MF_DAY,
			LOGO_MUSTERI_TIP,
			IS_CONTRACT_REQUIRED			
		)
		VALUES
		(
			'#attributes.bolge_kodu#',
			'#attributes.altbolge_kodu#',
			'#attributes.calisma_sekli#',
			<cfif len(attributes.puan)>#attributes.puan#<cfelse>NULL</cfif>,
			#attributes.cpid#,
			#form_company_id#,
			#form_branch_id#,
			#attributes.is_select#,
			#now()#,
			#session.ep.userid#,
			'#cgi.remote_addr#',
			<cfif len(attributes.carihesapkod)>'#attributes.carihesapkod#'<cfelse>NULL</cfif>,
			<cfif len(attributes.cat_status)>#attributes.cat_status#<cfelse>NULL</cfif>,
			<cfif len(attributes.depot_km)>#attributes.depot_km#<cfelse>NULL</cfif>,
			<cfif len(attributes.depot_dak)>#attributes.depot_dak#<cfelse>NULL</cfif>,
			<cfif len(attributes.muhasebekod)>'#attributes.muhasebekod#'<cfelse>NULL</cfif>,
			#attributes.process_stage#,
			<cfif len(attributes.satis_muduru_id) and len(attributes.satis_muduru)>#attributes.satis_muduru_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.telefon_satis_id) and len(attributes.telefon_satis)>#attributes.telefon_satis_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.plasiyer_id) and len(attributes.plasiyer)>#attributes.plasiyer_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.open_date)>#attributes.open_date#<cfelse>NULL</cfif>,
			<cfif len(attributes.resource)>#attributes.resource#<cfelse>NULL</cfif>,
			<cfif len(attributes.depot_relation)>#attributes.depot_relation#<cfelse>NULL</cfif>,
			<cfif len(attributes.status)>'#attributes.status#'<cfelse>NULL</cfif>,
			<cfif len(attributes.shipping_zone_code)>'#attributes.shipping_zone_code#'<cfelse>NULL</cfif>,
			<cfif len(attributes.tahsilatci_id) and len(attributes.tahsilatci)>#attributes.tahsilatci_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.cep_sira_no)>'#attributes.cep_sira_no#'<cfelse>NULL</cfif>,
			<cfif len(attributes.itriyat_id)>#attributes.itriyat_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.boyut_tahsilat)>'#attributes.boyut_tahsilat#'<cfelse>NULL</cfif>,
			<cfif len(attributes.boyut_itriyat)>'#attributes.boyut_itriyat#'<cfelse>NULL</cfif>,
			<cfif len(attributes.boyut_telefon)>'#attributes.boyut_telefon#'<cfelse>NULL</cfif>,
			<cfif len(attributes.boyut_plasiyer)>'#attributes.boyut_plasiyer#'<cfelse>NULL</cfif>,
			<cfif len(attributes.boyut_satis)>'#attributes.boyut_satis#'<cfelse>NULL</cfif>,
			<cfif len(attributes.average_due_date)>#attributes.average_due_date#<cfelse>NULL</cfif>,
			<cfif len(attributes.opening_period)>#attributes.opening_period#<cfelse>NULL</cfif>,
			<cfif len(attributes.mf_day)>#attributes.mf_day#<cfelse>NULL</cfif>,
			<cfif len(attributes.logo_musteri_tip)>'#attributes.logo_musteri_tip#'<cfelse>'0'</cfif>,
			0					
		)
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
		SELECT IS_SELECT FROM COMPANY_BRANCH_RELATED WHERE RELATED_ID = #MAX_ID.IDENTITYCOL#
	</cfquery>
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
			<cfif len(attributes.risk_limit)>#attributes.risk_limit#,<cfelse>NULL,</cfif>
			'#attributes.money#',
			#now()#,
			#session.ep.userid#,
			'#cgi.remote_addr#',
			#MAX_ID.IDENTITYCOL#
		)
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
	<cfset attributes.is_record = true>
	</cftransaction>
	<cfcatch type="any">
		<script type="text/javascript">
			alert("<cf_get_lang no ='1000.Şube Ekleme Sürecinde Problem Oluştu. Lütfen Sistem Yöneticisine Başvurun'> !");
			history.go(-1);
		</script>
	</cfcatch>
</cftry>
<cfif attributes.is_record>
	<!--- Sube Aktarım Listesinden gelmis ise 20081108 --->
	<cfif isdefined("attributes.transfer_branch_id")>
		<cfquery name="UPD_TRANSFER" datasource="mushizgun">
			UPDATE 
				#attributes.table_name# 
			SET 
				IS_TRANSFER = 1, 
				COMPANY_ID = #attributes.cpid#, 
				RELATED_ID = #MAX_ID.IDENTITYCOL#,
				RECORD_DATE = #now()#,
				RECORD_EMP = #session.ep.userid#,
				RECORD_IP = '#cgi.remote_addr#'			
			WHERE 
				KAYITNO = #attributes.kayitno#
		</cfquery>
	</cfif>
	<cfscript>
		max_branch_id = MAX_ID.IDENTITYCOL;
		cpid = attributes.cpid;
		is_insert_type = 3;
	</cfscript>
	<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_page='#request.self#?fuseaction=crm.detail_company&cpid=#attributes.cpid#&related_id=#MAX_ID.IDENTITYCOL#&is_open_popup=1' 
	action_id='#attributes.cpid#'
	warning_description = 'Müşteri : #get_fullname.fullname# Depo : #get_branch.company_name#/#get_branch.branch_name#'>
</cfif>
 
<script type="text/javascript">
	<cfif isDefined("attributes.draggable") and attributes.draggable eq 1>
		location.href = document.referrer;
	<cfelse>
		wrk_opener_reload();
		window.close();
	</cfif> 
</script>
