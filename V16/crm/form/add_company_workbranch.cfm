<cfquery name="GET_FULLNAME" datasource="#DSN#">
	SELECT 
		COMPANY.FULLNAME,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME
	FROM 
		COMPANY,
		COMPANY_PARTNER
	WHERE 
		COMPANY.COMPANY_ID = #attributes.cpid# AND
		COMPANY.MANAGER_PARTNER_ID = COMPANY_PARTNER.PARTNER_ID
</cfquery>
<cfquery name="GET_STATUS" datasource="#DSN#">
	SELECT TR_ID, TR_NAME FROM SETUP_MEMBERSHIP_STAGES
</cfquery>
<cfquery name="GET_RELATION" datasource="#DSN#">
	SELECT PARTNER_RELATION_ID, PARTNER_RELATION FROM SETUP_PARTNER_RELATION ORDER BY PARTNER_RELATION_ID 
</cfquery>
<cfquery name="GET_RESOURCE" datasource="#DSN#">
	SELECT RESOURCE_ID,RESOURCE FROM COMPANY_PARTNER_RESOURCE
</cfquery>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfquery name="GET_COM_BRANCH" datasource="#DSN#">
	SELECT 
		OUR_COMPANY.COMP_ID, 
		OUR_COMPANY.COMPANY_NAME, 
		BRANCH.BRANCH_NAME, 
		BRANCH.BRANCH_ID,
		ZONE.ZONE_NAME
	FROM 
		BRANCH, 
		OUR_COMPANY,
		ZONE,
		EMPLOYEE_POSITION_BRANCHES
	WHERE 
		EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# AND
		EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = BRANCH.BRANCH_ID AND
        EMPLOYEE_POSITION_BRANCHES.DEPARTMENT_ID IS NULL AND
		BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND
		ZONE.ZONE_ID = BRANCH.ZONE_ID
	<cfif isdefined("attributes.transfer_branch_id") and len(attributes.transfer_branch_id)>
		AND BRANCH.BRANCH_ID = #attributes.transfer_branch_id#
	</cfif>
	ORDER BY 
		OUR_COMPANY.COMPANY_NAME,	
		BRANCH.BRANCH_NAME
</cfquery>

<!--- Sube Aktarım Listesinden gelen bilgiler icin 20081028 BK --->
<cfif isdefined("attributes.transfer_branch_id") and len(attributes.transfer_branch_id)>
	<cfquery name="GET_BRANCH_TRANSFER" datasource="#DSN#">
		SELECT
			BTD.TABLE_NAME, 
			B.BRANCH_ID,
			B.BRANCH_NAME,
			CBDK.BOYUT_KODU
		FROM 
			BRANCH_TRANSFER_DEFINITION BTD,
			BRANCH B,
			COMPANY_BOYUT_DEPO_KOD CBDK
		WHERE
			BTD.BRANCH_ID = #attributes.transfer_branch_id# AND
			BTD.BRANCH_ID = B.BRANCH_ID AND
			CBDK.W_KODU = B.BRANCH_ID
	</cfquery>
	<cfquery name="GET_PERSONEL_GECIS" datasource="mushizgun">
		SELECT * FROM PERSONEL_GECIS WHERE DEPOKOD = #get_branch_transfer.boyut_kodu# 
	</cfquery>
	<cfif isdefined("attributes.kayitno") and len(attributes.kayitno)>
		<cfquery name="GET_TRANSFER_COMPANY" datasource="mushizgun">
			SELECT 
				KAYITNO,ISYERIADI,ADI,TCKIMLIKNO,VERGINO,VERGIDAIRE,IL,ILCE,SEMT,TELEFON,ADRES,FAX,SEMT,POSTAKODU,RISKTOP,
				MUHKOD,HESAPKODU,BSM,TELEFONCU,TAHSILDAR,PLASIYER2,PLASIYER,CEPSIRA,BOLGEKODU,ALTBOLGEKD,CALISSEKLI,ACTAR,CARITIP
			FROM 
				#get_branch_transfer.table_name# 
			WHERE
				KAYITNO = #attributes.kayitno# AND 
				IS_TRANSFER = 0
		</cfquery>
	</cfif>	
</cfif>
<cfif isdefined("get_transfer_company") and get_transfer_company.recordcount>
	<cfset carihesapkod_ = trim(get_transfer_company.hesapkodu)>
	<cfset muhasebekod_ = trim(get_transfer_company.muhkod)>
	<cfif isdate(trim(get_transfer_company.actar))>
		<cfset open_date_ = trim(get_transfer_company.actar)>
	<cfelse>
		<cfset open_date_ = ''>
	</cfif>

	<cfset satis_muduru_id_ = ''>
	<cfset satis_muduru_ = ''>
	<cfset boyut_satis_ = trim(get_transfer_company.bsm)>
	<cfif len(boyut_satis_)>
		<cfquery name="GET_BSM" dbtype="query">
			SELECT INKAKOD FROM GET_PERSONEL_GECIS WHERE PERTIP = 'BSM' AND BOYUTKOD = '#boyut_satis_#' AND INKAKOD IS NOT NULL
		</cfquery>
		<cfif get_bsm.recordcount eq 1>
			<cfquery name="GET_BSM_NAME" datasource="#DSN#">
				SELECT EMPLOYEE_NAME+' ' +EMPLOYEE_SURNAME NAME,POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #get_bsm.inkakod# AND IS_MASTER = 1
			</cfquery>
			<cfif get_bsm_name.recordcount eq 1>
				<cfset satis_muduru_id_ = get_bsm_name.position_code>
				<cfset satis_muduru_ = get_bsm_name.name>
			</cfif>
		</cfif>
	</cfif>

	<cfset boyut_tahsilat_ = trim(get_transfer_company.tahsildar)>
	<cfset telefon_satis_id_ = ''>
	<cfset telefon_satis_ = ''>
	<cfset boyut_telefon_ = trim(get_transfer_company.telefoncu)>
	<cfif len(boyut_telefon_)>
		<cfquery name="GET_TEL" dbtype="query">
			SELECT INKAKOD FROM GET_PERSONEL_GECIS WHERE PERTIP = 'TEL' AND BOYUTKOD = '#boyut_telefon_#' AND INKAKOD IS NOT NULL
		</cfquery>
		<cfif get_tel.recordcount eq 1>
			<cfquery name="GET_TEL_NAME" datasource="#DSN#">
				SELECT EMPLOYEE_NAME+' ' +EMPLOYEE_SURNAME NAME,POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #get_tel.inkakod# AND IS_MASTER = 1
			</cfquery>
			<cfif get_tel_name.recordcount eq 1>
				<cfset telefon_satis_id_ = get_tel_name.position_code>
				<cfset telefon_satis_ = get_tel_name.name>
			</cfif>
		</cfif>
	</cfif>

	<cfset boyut_itriyat_ = trim(get_transfer_company.plasiyer2)>

	<cfset plasiyer_id_ = ''>
	<cfset plasiyer_ = ''>
	<cfset boyut_plasiyer_ = trim(get_transfer_company.plasiyer)>
	<cfif len(boyut_plasiyer_)>
		<cfquery name="GET_PLS" dbtype="query">
			SELECT INKAKOD FROM GET_PERSONEL_GECIS WHERE PERTIP = 'PLS' AND BOYUTKOD = '#boyut_plasiyer_#' AND INKAKOD IS NOT NULL
		</cfquery>
		<cfif get_pls.recordcount eq 1>
			<cfquery name="GET_PLS_NAME" datasource="#DSN#">
				SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME NAME,POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #get_pls.inkakod# AND IS_MASTER = 1
			</cfquery>
			<cfif get_pls_name.recordcount eq 1>
				<cfset plasiyer_id_ = get_pls_name.position_code>
				<cfset plasiyer_ = get_pls_name.name>
			</cfif>
		</cfif>
	</cfif>

	<cfset tahsilatci_id_ = ''>
	<cfset tahsilatci_ = ''>
	<cfset boyut_tahsilat_ = trim(get_transfer_company.tahsildar)>
	<cfif len(boyut_tahsilat_)>
		<cfquery name="GET_TAH" dbtype="query">
			SELECT INKAKOD FROM GET_PERSONEL_GECIS WHERE PERTIP = 'TAH' AND BOYUTKOD = '#boyut_tahsilat_#' AND INKAKOD IS NOT NULL
		</cfquery>
		<cfif get_tah.recordcount eq 1>
			<cfquery name="GET_TAH_NAME" datasource="#DSN#">
				SELECT EMPLOYEE_NAME+' ' +EMPLOYEE_SURNAME NAME,POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #get_tah.inkakod# AND IS_MASTER = 1
			</cfquery>
			<cfif get_tah_name.recordcount eq 1>
				<cfset tahsilatci_id_ = get_tah_name.position_code>
				<cfset tahsilatci_ = get_tah_name.name>
			</cfif>
		</cfif>
	</cfif>

	<cfif len(trim(get_transfer_company.bolgekodu))>
		<cfset bolge_kodu_ = trim(get_transfer_company.bolgekodu)>
	<cfelse>
		<cfset bolge_kodu_ = 1>
	</cfif>

	<cfif len(trim(get_transfer_company.altbolgekd))>
		<cfset altbolge_kodu_ = trim(get_transfer_company.altbolgekd)>
	<cfelse>
		<cfset altbolge_kodu_ = 1>
	</cfif>

	<cfset cep_sira_no_ = trim(listsort(listdeleteduplicates(get_transfer_company.cepsira),'text','DESC',','))>
	<cfif len(trim(get_transfer_company.calissekli))>
		<cfset calisma_sekli_ = trim(get_transfer_company.calissekli)>
	<cfelse>
		<cfset calisma_sekli_ = 001>
	</cfif>
	<cfset depot_km_ = 1>
	<cfset depot_dak_ = 1>
	<cfset average_due_date_ = 0>
	<cfset opening_period_ = 0>
	<cfset mf_day_ = 0>
	<cfif len(get_transfer_company.risktop) and get_transfer_company.risktop gt 0>
		<cfset attributes.risk_limit = get_transfer_company.risktop>
	<cfelse>
		<cfset attributes.risk_limit = 1>
	</cfif>
	<cfset attributes.resource = 1>
	<cfset depot_relation_ = 3>
	<cfset logo_musteri_tip_  = 0>
	<cfset attributes.status = ','>
	<cfset cep_sira_no_ = listdeleteduplicates(valuelist(get_transfer_company.cepsira))>
<cfelse>
	<cfset carihesapkod_ = ''>
	<cfset muhasebekod_ = ''>
	<cfset open_date_ = ''>
	<cfset satis_muduru_id_ = ''>
	<cfset satis_muduru_ = ''>
	<cfset boyut_satis_ = ''>	
	<cfset boyut_itriyat_ = ''>
	<cfset telefon_satis_id_ = ''>
	<cfset telefon_satis_ = ''>
	<cfset boyut_telefon_ = ''>
	<cfset plasiyer_id_ = ''>
	<cfset plasiyer_ = ''>
	<cfset boyut_plasiyer_ = ''>
	<cfset tahsilatci_id_ = ''>
	<cfset tahsilatci_ = ''>
	<cfset boyut_tahsilat_ = ''>
	<cfset bolge_kodu_ = ''>
	<cfset altbolge_kodu_ = ''>
	<cfset cep_sira_no_ = ''>
	<cfset calisma_sekli_ = ''>
	<cfset depot_km_ = ''>
	<cfset depot_dak_ = ''>
	<cfset average_due_date_ = ''>
	<cfset opening_period_ = ''>
	<cfset mf_day_ = ''>
	<cfset attributes.resource = ''>
	<cfset depot_relation_ = ''>
	<cfset logo_musteri_tip_  = ''>
	<cfset cep_sira_no_ = ''>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Müşteri','57457')# : #get_fullname.fullname#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="form_add_company" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_consumer_branch">
			<cfif isdefined("attributes.transfer_branch_id")>
				<cfoutput>
					<input type="hidden" name="transfer_branch_id" id="transfer_branch_id" value="#attributes.transfer_branch_id#">
					<input type="hidden" name="kayitno" id="kayitno" value="#attributes.kayitno#">
					<input type="hidden" name="table_name" id="table_name" value="#get_branch_transfer.table_name#">
					<cfinput type="hidden" name="draggable" id="draggable" value="#iif(isdefined("attributes.draggable"),1,0)#">
				</cfoutput>
			</cfif>
			<input name="cpid" id="cpid" type="hidden" value="<cfoutput>#attributes.cpid#</cfoutput>">
			<input name="is_select" id="is_select" type="hidden" value="0">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-c_partner_name">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52048.Eczacı'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfinput name="c_partner_name" id="c_partner_name" value="#get_fullname.company_partner_name# #get_fullname.company_partner_surname#" readonly>
						</div>
					</div>
					<div class="form-group" id="item-workcube_process">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
						</div>
					</div>
					<div class="form-group" id="item-carihesapkod">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51673.Cari Hesap Kodu'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="carihesapkod" id="carihesapkod" value="<cfoutput>#carihesapkod_#</cfoutput>" <cfif len(carihesapkod_)> readonly</cfif> maxlength="10">
						</div>
					</div>
					<div class="form-group" id="item-muhasebekod">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="muhasebekod" id="muhasebekod" value="<cfoutput>#muhasebekod_#</cfoutput>" <cfif len(muhasebekod_)> readonly</cfif> maxlength="10">
						</div>
					</div>
					<div class="form-group" id="item-satis_muduru_id">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51549.Bölge Satış Müdürü'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-8">
								<div class="input-group">
									<cfif isdefined("attributes.satis_muduru_id") and len(attributes.satis_muduru_id)>
										<input type="hidden" name="satis_muduru_id" id="satis_muduru_id" value="<cfoutput>#attributes.satis_muduru_id#</cfoutput>">
										<input type="text" name="satis_muduru" id="satis_muduru" value="<cfoutput>#get_emp_info(attributes.satis_muduru_id,1,0)#</cfoutput>" readonly>
									<cfelse>
										<cfif not len(boyut_satis_)>
											<input type="hidden" name="satis_muduru_id" id="satis_muduru_id" value="<cfoutput>#session.ep.position_code#</cfoutput>">
											<input type="text" name="satis_muduru" id="satis_muduru" value="<cfoutput>#get_emp_info(session.ep.position_code,1,0)#</cfoutput>" readonly>
										<cfelse>
											<input type="hidden" name="satis_muduru_id" id="satis_muduru_id" value="<cfoutput>#satis_muduru_id_#</cfoutput>">
											<input type="text" name="satis_muduru" id="satis_muduru" value="<cfoutput>#satis_muduru_#</cfoutput>" readonly>
										</cfif>
									</cfif>
									<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.satis_muduru_id&field_name=form_add_company.satis_muduru&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>')"></span>
									<a class="margin-left-10" href="javascript://" onClick="del_gorevli('satis_muduru_id','satis_muduru');"><i class="fa fa-minus"></i></a>
								</div>
							</div>
							<div class="col col-4">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12 margin-top-5"><cf_get_lang dictionary_id='63868.Boyut'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<input type="text" name="boyut_satis" id="boyut_satis" value="<cfoutput>#boyut_satis_#</cfoutput>" maxlength="3">
								</div>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-plasiyer_id">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51548.Saha Satış Görevlisi'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-8">
								<div class="input-group">
									<cfif isdefined("attributes.plasiyer_id") and len(attributes.plasiyer_id)>
										<input type="hidden" name="plasiyer_id" id="plasiyer_id" value="<cfoutput>#attributes.plasiyer_id#</cfoutput>">
										<input type="text" name="plasiyer" id="plasiyer" value="<cfoutput>#get_emp_info(attributes.plasiyer_id,1,0)#</cfoutput>" readonly>
									<cfelse>
										<cfif not len(plasiyer_id_)>
											<input type="hidden" name="plasiyer_id" id="plasiyer_id" value="">
											<input type="text" name="plasiyer" id="plasiyer" readonly>
										<cfelse>
											<input type="hidden" name="plasiyer_id" id="plasiyer_id" value="<cfoutput>#plasiyer_id_#</cfoutput>">
											<input type="text" name="plasiyer" id="plasiyer" value="<cfoutput>#plasiyer_#</cfoutput>" readonly>
										</cfif>
									</cfif>
									<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.plasiyer_id&field_name=form_add_company.plasiyer&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>')"></span>
									<a class="margin-left-10" href="javascript://" onClick="del_gorevli('plasiyer_id','plasiyer');"><i class="fa fa-minus"></i></a>
								</div>
							</div>
							<div class="col col-4">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12 margin-top-5"><cf_get_lang dictionary_id='63868.Boyut'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<input type="text" name="boyut_plasiyer" id="boyut_plasiyer" value="<cfoutput>#boyut_plasiyer_#</cfoutput>" maxlength="3">
								</div>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-telefon_satis_id">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51877.Telefonla Satış Görevlisi'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-8">
								<div class="input-group">
									<cfif isdefined("attributes.telefon_satis_id") and len(attributes.telefon_satis_id)>
										<input type="hidden" name="telefon_satis_id" id="telefon_satis_id" value="<cfoutput>#attributes.telefon_satis_id#</cfoutput>">
										<input type="text" name="telefon_satis" id="telefon_satis" value="<cfoutput>#get_emp_info(attributes.telefon_satis_id,1,0)#</cfoutput>" readonly>
									<cfelse>
										<cfif not len(telefon_satis_id_)>
											<input type="hidden" name="telefon_satis_id" id="telefon_satis_id" value="">
											<input type="text" name="telefon_satis" id="telefon_satis" readonly>
										<cfelse>
											<input type="hidden" name="telefon_satis_id" id="telefon_satis_id" value="<cfoutput>#telefon_satis_id_#</cfoutput>">
											<input type="text" name="telefon_satis" id="telefon_satis" value="<cfoutput>#telefon_satis_#</cfoutput>" readonly>
										</cfif>
									</cfif>
									<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.telefon_satis_id&field_name=form_add_company.telefon_satis&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>')"></span>
									<a class="margin-left-10" href="javascript://" onClick="del_gorevli('telefon_satis_id','telefon_satis');"><i class="fa fa-minus"></i></a>
								</div>
							</div>
							<div class="col col-4">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12 margin-top-5"><cf_get_lang dictionary_id='63868.Boyut'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<input type="text" name="boyut_telefon" id="boyut_telefon" value="<cfoutput>#boyut_telefon_#</cfoutput>" maxlength="3">
								</div>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-tahsilatci_id">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51652.Tahsilat Görevlisi'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-8">
								<div class="input-group">
									<cfif isdefined("attributes.tahsilatci_id")>
										<input type="hidden" name="tahsilatci_id" id="tahsilatci_id" value="<cfoutput>#attributes.tahsilatci_id#</cfoutput>">
										<input type="text" name="tahsilatci" id="tahsilatci" value="<cfoutput>#get_emp_info(attributes.tahsilatci_id,1,0)#</cfoutput>" readonly>
									<cfelse>
										<cfif not len(boyut_tahsilat_)>
											<input type="hidden" name="tahsilatci_id" id="tahsilatci_id" value="">
											<input type="text" readonly name="tahsilatci" id="tahsilatci">
										<cfelse>
											<input type="hidden" name="tahsilatci_id" id="tahsilatci_id" value="<cfoutput>#tahsilatci_id_#</cfoutput>">
											<input type="text" name="tahsilatci" id="tahsilatci" value="<cfoutput>#tahsilatci_#</cfoutput>" readonly>
										</cfif>
									</cfif>
									<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.tahsilatci_id&field_name=form_add_company.tahsilatci&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>')"></span>
									<a class="margin-left-10" href="javascript://" onClick="del_gorevli('tahsilatci_id','tahsilatci');"><i class="fa fa-minus"></i></a>
								</div>
							</div>
							<div class="col col-4">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12 margin-top-5"><cf_get_lang dictionary_id='63868.Boyut'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<input type="text" name="boyut_tahsilat" id="boyut_tahsilat" value="<cfoutput>#boyut_tahsilat_#</cfoutput>" maxlength="3">
								</div>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-itriyat_id">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52093.Itriyat Satış Görevlisi'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-8">
								<div class="input-group">
									<input type="hidden" name="itriyat_id" id="itriyat_id" value="">
									<input type="text" name="itriyat" id="itriyat" readonly>
									<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.itriyat_id&field_name=form_add_company.itriyat&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>')"></span>
									<a class="margin-left-10" href="javascript://" onClick="del_gorevli('itriyat_id','itriyat');"><i class="fa fa-minus"></i></a>
								</div>
							</div>
							<div class="col col-4">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12 margin-top-5"><cf_get_lang dictionary_id='63868.Boyut'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<input type="text" name="boyut_itriyat" id="boyut_itriyat" value="<cfoutput>#boyut_itriyat_#</cfoutput>" maxlength="3">
								</div>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-shipping_zone_code">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51599.Sevkiyat Bölge Kodu'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="shipping_zone_code" id="shipping_zone_code" value="">
						</div>
					</div>
					<div class="form-group" id="item-resource">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51676.İlişki Tipi'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="resource" id="resource">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_resource">
									<option value="#resource_id#" <cfif isdefined("attributes.resource") and len(attributes.resource) and (attributes.resource eq resource_id)>selected</cfif>>#resource#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-bolge_kodu">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51897.Bölge Kodu'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="bolge_kodu" id="bolge_kodu" value="<cfoutput>#bolge_kodu_#</cfoutput>" maxlength="5">
						</div>
					</div>
					<div class="form-group" id="item-altbolge_kodu">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51921.Alt Bölge Kodu'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="altbolge_kodu" id="altbolge_kodu" value="<cfoutput>#altbolge_kodu_#</cfoutput>" maxlength="5" >
						</div>
					</div>
					<div class="form-group" id="item-logo_musteri_tip">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52474.Logo Müşteri Tip'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="logo_musteri_tip" id="logo_musteri_tip" value="<cfoutput>#logo_musteri_tip_#</cfoutput>" maxlength="10">
						</div>
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-store_id">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="store_id" id="store_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_com_branch">
									<option value="#comp_id#,#branch_id#" <cfif isdefined("attributes.branch_id") and len(attributes.branch_id) and (attributes.branch_id eq branch_id)> selected <cfelseif isdefined("attributes.transfer_branch_id") and len(attributes.transfer_branch_id) and (attributes.transfer_branch_id eq branch_id)> selected <cfelseif listgetat(session.ep.user_location,2,'-') eq branch_id>selected</cfif>>#company_name#/#branch_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-cat_status">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57894.Statü'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="cat_status" id="cat_status">
								<cfoutput query="get_status">
									<option value="#tr_id#" <cfif tr_id eq 3>selected</cfif>>#tr_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-depot_km">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51679.Depoya Uzaklık (Km)'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfinput name="depot_km" value="#depot_km_#" validate="integer" message="#getLang('','Depoya Uzaklık Sayısal Olmalıdır','51680')#!">
						</div>
					</div>
					<div class="form-group" id="item-depot_dak">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='65407.Depoya Uzaklık (Dakika)'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfinput name="depot_dak" value="#depot_dak_#" validate="integer" message="#getLang('','Dakika Sayısal Olmalıdır','52473')#!">
						</div>
					</div>
					<div class="form-group" id="item-open_date">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51683.Şube Açılış Tarihi'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='51684.Şube Açılış Tarihi Girmelisiniz'> !</cfsavecontent>
								<cfif len(open_date_)>
									<cfinput type="text" name="open_date" value="#dateformat(open_date_,dateformat_style)#" required="yes" message="#message#" validate="#validate_style#">
								<cfelse>
									<cfinput type="text" name="open_date" value="#dateformat(now(),dateformat_style)#" required="yes" message="#message#" validate="#validate_style#">
								</cfif>
								<span class="input-group-addon"><cf_wrk_date_image date_field="open_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-risk_limit">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51640.Toplam Risk Limiti'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='51640.Toplam Risk Limiti'>!</cfsavecontent>
								<cfif isdefined("attributes.risk_limit") and len(attributes.risk_limit)>
									<cfinput type="text" name="risk_limit" value="#tlformat(attributes.risk_limit)#" onkeyup="return(FormatCurrency(this,event));" message="#message#" class="moneybox">
								<cfelse>
									<cfinput type="text" name="risk_limit" value="" onkeyup="return(FormatCurrency(this,event));" message="#message#" class="moneybox">
								</cfif>
								<span class="input-group-addon width">
									<select name="money" id="money">
										<cfoutput query="get_money">
											<option value="#money#" <cfif isdefined("attributes.money_type") and len(attributes.money_type) and (attributes.money_type eq money)>selected<cfelseif money eq session.ep.money>selected</cfif>>#money#</option>
										</cfoutput>
									</select>
								</span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-average_due_date">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57861.Ortalama Vade'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="average_due_date" id="average_due_date" value="<cfoutput>#average_due_date_#</cfoutput>" class="moneybox" onkeyup="return(FormatCurrency(this,event));" maxlength="3" tabindex="49">
						</div>
					</div>
					<div class="form-group" id="item-opening_period">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52094.Açılış Süresi'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="opening_period" id="opening_period" value="<cfoutput>#opening_period_#</cfoutput>" class="moneybox" onkeyup="return(FormatCurrency(this,event));" maxlength="2" tabindex="50">
						</div>
					</div>
					<div class="form-group" id="item-mf_day">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52096.MF Gün'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="mf_day" id="mf_day" value="<cfoutput>#mf_day_#</cfoutput>" class="moneybox" onkeyup="return(FormatCurrency(this,event));" maxlength="3" tabindex="51">
						</div>
					</div>
					<div class="form-group" id="item-calisma_sekli">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="calisma_sekli" id="calisma_sekli" value="<cfoutput>#calisma_sekli_#</cfoutput>" maxlength="10">
						</div>
					</div>
					<div class="form-group" id="item-depot_relation">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51677.Şube ile İlişkileri'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="depot_relation" id="depot_relation">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_relation">
									<option value="#partner_relation_id#" <cfif len(depot_relation_) and (depot_relation_ eq partner_relation_id)> selected</cfif>>#partner_relation#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-puan">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58984.Puan'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="puan" id="puan" value="<cfoutput>#tlFormat(0)#</cfoutput>" readonly>
						</div>
					</div>
					<div class="form-group" id="item-cep_sira_no">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51924.Cep Sıra No'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="cep_sira_no" id="cep_sira_no" value="<cfoutput>#cep_sira_no_#</cfoutput>" maxlength="14">
						</div>
					</div>
					<div class="form-group" id="item-status">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51685.Satış Statüsü/Notlar'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfif isdefined("attributes.status") and len(attributes.status)>
								<textarea name="status" id="status" style="width:150px;height:25px;"><cfoutput>#attributes.status#</cfoutput></textarea>
							<cfelse>
								<textarea name="status" id="status" style="width:150px;height:25px;"></textarea>
							</cfif>
						</div>
					</div>
				</div>

			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function del_gorevli(field1,field2)
{
	var deger1 = eval("document.form_add_company." + field1);
	var deger2 = eval("document.form_add_company." + field2);
	deger1.value="";
	deger2.value="";
}

function kontrol()
{
	x = document.form_add_company.store_id.selectedIndex;
	if (document.form_add_company.store_id[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='58579.Lütfen Şube Seçiniz'>!");
		return false;
	}
	if(form_add_company.carihesapkod.value == "")
	{
		alert("<cf_get_lang dictionary_id='52475.Lütfen Cari Hesap Kodu Giriniz'>!");
		return false;
	}
	else if(form_add_company.carihesapkod.value.length != 10)
	{
		alert("<cf_get_lang dictionary_id='52036.Cari Hesap Kodu 10 Hane Olmalıdır'>!");
		return false;
	}
	if(form_add_company.muhasebekod.value == "")
	{
		alert("<cf_get_lang dictionary_id='52476.Lütfen Muhasebe Kodu Giriniz'>!");
		return false;
	}
	else if(form_add_company.muhasebekod.value.length != 10)
	{
		alert("<cf_get_lang dictionary_id='52477.Özel Kod Alanı 10 Karakter Olmalıdı'>r !");
		return false;
	}
	if(document.form_add_company.satis_muduru.value == "")
	{
		alert("<cf_get_lang dictionary_id='52175.Lütfen Bölge Satış Müdürü Seçiniz'>!");
		return false;
	}
	if(document.form_add_company.boyut_satis.value == "")
	{
		alert("<cf_get_lang dictionary_id='52176.Lütfen Bölge Satış Müdürü Boyut Kodu Seçiniz'>!");
		return false;
	}
	if(document.form_add_company.telefon_satis.value == "")
	{
		alert("<cf_get_lang dictionary_id='52026.Lütfen Telefonla Satış Görevlisi Seçiniz'>!");
		return false;
	}
	if(document.form_add_company.boyut_telefon.value == "")
	{
		alert("<cf_get_lang dictionary_id='52029.Lütfen Telefonla Satış Görevlisi Boyut Kodu Seçiniz'>!");
		return false;
	}
	if(document.form_add_company.tahsilatci.value.length == "")
	{
		alert("<cf_get_lang dictionary_id='52027.Lütfen Tahsilat Görevlisi Seçiniz'>!");
		return false;
	}
	if(document.form_add_company.boyut_tahsilat.value.length == "")
	{
		alert("<cf_get_lang dictionary_id='52028.Lütfen Tahsilat Görevlisi Boyut Kodu Giriniz'>!");
		return false;
	}
	if(document.form_add_company.open_date.value == "")
	{
		alert("<cf_get_lang dictionary_id='52177.Lütfen Depo Açılış Tarihi Giriniz'>!");
		return false;
	}
	x = document.form_add_company.resource.selectedIndex;
	if (document.form_add_company.resource[x].value == "")
	{
		alert ("<cf_get_lang dictionary_id='52180.Lütfen İlişki Başlangıcı Seçiniz'>!");
		return false;
	}
	if(document.form_add_company.bolge_kodu.value == "")
	{
		alert("<cf_get_lang dictionary_id='52178.Lütfen Bölge Kodu Giriniz'>!");
		return false;
	}
	if(document.form_add_company.altbolge_kodu.value == "")
	{
		alert("<cf_get_lang dictionary_id='52179.Lütfen Alt Bölge Kodu Giriniz'>!");
		return false;
	}
	if(document.form_add_company.depot_km.value == "")
	{
		alert("<cf_get_lang dictionary_id='52182.Lütfen Depoya Uzaklık (Km) Giriniz'>!");
		return false;
	}
	if(document.form_add_company.depot_dak.value == "")
	{
		alert("<cf_get_lang dictionary_id='52181.Lütfen Depoya Uzaklık ( Dakika ) Giriniz'>!");
		return false;
	}
	if(document.form_add_company.risk_limit.value == "")
	{
		alert("<cf_get_lang dictionary_id='52032.Lütfen Risk Limiti Giriniz'>!");
		return false;
	}
	form_add_company.risk_limit.value = filterNum(form_add_company.risk_limit.value);
	form_add_company.puan.readonly = false ;
 	form_add_company.puan.value = filterNum(form_add_company.puan.value); 

	return process_cat_control();
}
</script>
