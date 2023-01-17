<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="yes">
<cffunction name="carici" returntype="boolean" output="false">
	<!---
	by :   20031117
	notes : Cari İşlemi Ekler veya Günceller...Fonksiyon sorunsuz çalistiginda true döndürür.

	problem :	 20040113 banka acilisi gibi yerlerde update isleminde borc alacaga donerse onceki hesap carisini NULL yapmak gerekiyor
				bu kodların DB2 da çalışması kontrol edilecek.
	usage :
	carici
		(action_id : GET_ACT_ID.MAX_ID,
		action_table : 'CASH_ACTIONS',
		workcube_process_type : 32,
		workcube_old_process_type : 32,
		account_card_type : 12,
		islem_tarihi : "#attributes.ACTION_DATE#",
		islem_tutari : CASH_ACTION_VALUE,
		islem_belge_no : PAPER_NUMBER,
		to_cmp_id : CASH_ACTION_TO_COMPANY_ID,
		from_cmp_id : CASH_ACTION_FROM_COMPANY_ID,
		to_employee_id : EMPLOYEE_ID,
		from_cash_id : CASH_ACTION_FROM_CASH_ID,
		islem_detay : 'ÖDEME',
		cari_db : carici fonksiyonunu transaction içinde kullanılabilmesini saglar. transaction için dsn2'den farklı kullanılan datasource bu argumana gonderilmelidir.
		cari_db_alias : cari_db_alias argumanına deger gonderilmemelidir, cari_db argumanı DSN2'den farklıysa cari_db_alias set ediliyor...
		other_money_value : other_money_value,
		other_money : money_type,
		payer_id :PAYER_ID,
		action_currency_2:'USD', ikinci para birimini tutar
		action_value2 : sistem 2 para birimi cinsinden doviz tutarı... gonderilmediginde action_currency_2 parametresine gonderilen 
						doviz turunun sistemdeki kur bilgisi bulunur ve action_value nun bu kura bolunmesiyle action_value2 nin degeri hesaplanır.
		action_currency : GET_CASH_CUR.CASH_CURRENCY_ID
		due_date : attributes.DUE_DATE ortalama vade ( ODBC Formatta !!!)
		action_detail : attributes.detail (işlemin geldiği yerdeki açıklama alanı)
		project_id : ilgili cari islemin baglı oldugu proje
		payment_value : fatura vb islem detaylarindaki odeme plani icin kullaniliyor, odeme plani 2 ondalik hane ile calirisken faturada 4 hane ile calisiliyorsa yuvarlamadan dolayi sorun oluyordu bu yuzden faturadaki hane kadar da tutabilmek icin boyle yaptik FBS 20110822
		);
	revisions : 20040227 , OZDEN20051101, 20060207, OZDEN20060228, OZDEN20060406, AE20070109 ,OZDEN20070111, OZDEN20070411
	--->
	<cfargument name="action_id" required="yes" type="numeric">
	<cfargument name="process_cat" required="yes" type="numeric">
	<cfargument name="action_table" type="string">
	<cfargument name="workcube_process_type" required="yes" type="numeric">
	<cfargument name="workcube_old_process_type" type="numeric">
	<cfargument name="action_currency" required="yes" default="#session.ep.money#">
	<cfargument name="action_currency_2" type="string" default="#session.ep.money2#">
	<cfargument name="currency_multiplier" type="string" default="">
	<cfargument name="other_money" type="string" default="">
	<cfargument name="other_money_value" type="string" default="">
	<cfargument name="account_card_type" type="numeric">
	<cfargument name="islem_tarihi" required="yes" type="date">
	<cfargument name="paper_act_date" type="date">
	<cfargument name="acc_type_id">
	<cfargument name="due_date" type="string">
	<cfargument name="islem_tutari" required="yes" type="numeric">
	<cfargument name="action_value2">
	<cfargument name="islem_belge_no" type="string" default="">
	<cfargument name="islem_detay" type="string" default="">
	<cfargument name="period_is_integrated" type="boolean" default="#session.ep.period_is_integrated#">
	<cfargument name="cari_db" type="string" default="#dsn2#">
	<cfargument name="cari_db_alias" type="string">
	<cfargument name="expense_center_id">
	<cfargument name="expense_item_id">
	<cfargument name="payer_id">
	<cfargument name="revenue_collector_id">
	<cfargument name="to_cmp_id">
	<cfargument name="from_cmp_id">
	<cfargument name="to_account_id">
	<cfargument name="from_account_id">
	<cfargument name="to_cash_id">
	<cfargument name="from_cash_id">
	<cfargument name="to_employee_id">
	<cfargument name="from_employee_id">
	<cfargument name="to_consumer_id">
	<cfargument name="from_consumer_id">
	<cfargument name="is_processed" type="numeric" default="0">
	<cfargument name="action_detail" type="string" default="">
	<cfargument name="from_branch_id">
	<cfargument name="to_branch_id">
	<cfargument name="project_id">
	<cfargument name="payroll_id">
	<cfargument name="rate2">
    <cfargument name="is_cancel">
	<cfargument name="is_cash_payment" default="0"><!---1 gönderildiğinde ödeme yöntemine göre parçalı ödemelerde peşinat satırını tutar  --->
	<cfargument name="is_upd_other_value" default="0"><!--- çek-senetler için extre değeri güncelledkten sonra değişmesin veya null olmasn diye ayrı bloklr içine almk için kullanıldı, if bloklarına eklenmedi çünkü else inde NULL set edilirdi ozaman.. --->
	<cfargument name="payment_value"><!--- Burasi fatura vb islem detaylarindaki odeme plani icin kullaniliyor, odeme plani 2 ondalik hane ile calirisken faturada 4 hane ile calisiliyorsa yuvarlamadan dolayi sorun oluyordu bu yuzden faturadaki hane kadar da tutabilmek icin boyle yaptik FBS 20110822 --->
	<cfscript>
		if(cari_db is not '#dsn2#') 
		{ /*cari_db argumanına session da tutulan period dısında dsn2 gonderilmesi durumunda else bolumu calısıyor. orn. ayarlar - cari devir islemi
			bu sadece carici functionında boyle muhasebeciyle karıstırılmasın. muhasebeci sadece bulundugu perioddaki dsn2'den calısır...OZDEN20070111*/
			if(arguments.cari_db is '#dsn#' or arguments.cari_db is '#dsn1#' or arguments.cari_db is '#dsn3#')		
				arguments.cari_db_alias = '#dsn2_alias#.';
			else 
				arguments.cari_db_alias = '#cari_db#.';
		}
		else
			arguments.cari_db_alias = '';
		if(len(arguments.action_currency_2) and (not len(arguments.currency_multiplier)) and (not (isdefined('arguments.action_value2') and len(arguments.action_value2))) )
		{
			get_currency_rate = cfquery(datasource : "#arguments.cari_db#", sqlstring : "SELECT (RATE2/RATE1) RATE FROM #arguments.cari_db_alias#SETUP_MONEY WHERE MONEY ='#arguments.action_currency_2#'");
			if(get_currency_rate.recordcount) arguments.currency_multiplier = get_currency_rate.RATE;
		}
		if(ListFind("48,49",arguments.workcube_process_type))//kur farkı faturalarında döviz bakiyeleri sıfırlamak için.. Ayşenur20080111
			if(isDefined('arguments.other_money') and len(arguments.other_money) and arguments.other_money neq "session.ep.money")
			{
				arguments.other_money_value = 0;
				arguments.action_value2 = 0;
			}
	</cfscript>
	<cfif isdefined("arguments.workcube_old_process_type") and len(arguments.workcube_old_process_type)>
		<cfquery name="carici_get_cari_islem" datasource="#arguments.cari_db#">
			SELECT 
				ACTION_ID 
			FROM 
				#arguments.cari_db_alias#CARI_ROWS 
			WHERE 
				ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
				AND ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workcube_old_process_type#">
                AND ISNULL(IS_CANCEL,0)=0
				<cfif isDefined('arguments.action_table') and len(arguments.action_table)> AND ACTION_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_table#"></cfif>
				<cfif isDefined('arguments.payroll_id') and len(arguments.payroll_id)> AND PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.payroll_id#"></cfif> 
		</cfquery>
	</cfif>
	<cfif isdefined("arguments.workcube_old_process_type") and len(arguments.workcube_old_process_type) and len(carici_get_cari_islem.action_id)>
		<cfquery name="UPD_CARI" datasource="#arguments.cari_db#">
			UPDATE
				#arguments.cari_db_alias#CARI_ROWS
			SET
				ACTION_DATE=#arguments.islem_tarihi#,
				ACTION_TYPE_ID = #arguments.workcube_process_type#,
				ACTION_VALUE= #wrk_round(arguments.islem_tutari,2)#,ACTION_CURRENCY_ID='#arguments.action_currency#',PROCESS_CAT=#arguments.process_cat#,
				<cfif is_upd_other_value eq 0>
					<cfif len(arguments.action_currency_2)>
						ACTION_CURRENCY_2='#arguments.action_currency_2#', 
						<cfif isdefined('arguments.action_value2') and len(arguments.action_value2)>
							ACTION_VALUE_2= #wrk_round(arguments.action_value2,2)#,
						<cfelse>
							ACTION_VALUE_2= #wrk_round((arguments.islem_tutari/arguments.currency_multiplier),2)#,
						</cfif>
					<cfelse>
						ACTION_CURRENCY_2 = NULL, ACTION_VALUE_2 = NULL,
					</cfif>
				</cfif>
				PAYMENT_VALUE=<cfif isDefined('arguments.payment_value') and len(arguments.payment_value)>#arguments.payment_value#<cfelse>NULL</cfif>,
				ACTION_TABLE=<cfif isDefined('arguments.action_table') and len(arguments.action_table)>'#arguments.action_table#'<cfelse>NULL</cfif>,
				DUE_DATE=<cfif isDefined('arguments.due_date') and isdate(arguments.due_date)>#arguments.due_date#<cfelse>#arguments.islem_tarihi#</cfif>,
				PAPER_NO=<cfif isDefined('arguments.islem_belge_no') and len(arguments.islem_belge_no)>'#arguments.islem_belge_no#'<cfelse>NULL</cfif>,
				ACTION_DETAIL=<cfif isDefined('arguments.action_detail') and len(arguments.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(arguments.action_detail,250)#"><cfelse>NULL</cfif>,
				ACTION_NAME=<cfif isDefined('arguments.islem_detay') and len(arguments.islem_detay)>'#LEFT(arguments.islem_detay,100)#'<cfelse>NULL</cfif>,
				EXPENSE_CENTER_ID=<cfif isDefined('arguments.expense_center_id') and isnumeric(arguments.expense_center_id)>#arguments.expense_center_id#<cfelse>NULL</cfif>,
				EXPENSE_ITEM_ID=<cfif isDefined('arguments.expense_item_id') and isnumeric(arguments.expense_item_id)>#arguments.expense_item_id#<cfelse>NULL</cfif>,
				PAYER_ID=<cfif isDefined('arguments.payer_id') and isnumeric(arguments.payer_id)>#arguments.payer_id#<cfelse>NULL</cfif>,
				<cfif is_upd_other_value eq 0>
					OTHER_CASH_ACT_VALUE=<cfif isDefined('arguments.other_money_value') and isnumeric(arguments.other_money_value)>#wrk_round(arguments.other_money_value,2)#<cfelse>NULL</cfif>,
					OTHER_MONEY=<cfif isDefined('arguments.other_money') and len(arguments.other_money)>'#arguments.other_money#'<cfelse>NULL</cfif>,
					RATE2 = <cfif isdefined("arguments.rate2") and len(arguments.rate2) and arguments.rate2 neq 0>#arguments.rate2#<cfelseif isDefined('arguments.other_money_value') and isnumeric(arguments.other_money_value) and arguments.other_money_value neq 0>#arguments.islem_tutari/arguments.other_money_value#<cfelse>NULL</cfif>,
				</cfif>
				TO_CMP_ID=<cfif isDefined('arguments.to_cmp_id') and isnumeric(arguments.to_cmp_id)>#arguments.to_cmp_id#<cfelse>NULL</cfif>,
				FROM_CMP_ID=<cfif isDefined('arguments.from_cmp_id') and isnumeric(arguments.from_cmp_id)>#arguments.from_cmp_id#<cfelse>NULL</cfif>,
				TO_ACCOUNT_ID=<cfif isDefined('arguments.to_account_id') and isnumeric(arguments.to_account_id)>#arguments.to_account_id#<cfelse>NULL</cfif>,
				FROM_ACCOUNT_ID=<cfif isDefined('arguments.from_account_id') and isnumeric(arguments.from_account_id)>#arguments.from_account_id#<cfelse>NULL</cfif>,
				TO_CASH_ID=<cfif isDefined('arguments.to_cash_id') and isnumeric(arguments.to_cash_id)>#arguments.to_cash_id#<cfelse>NULL</cfif>,
				FROM_CASH_ID=<cfif isDefined('arguments.from_cash_id') and isnumeric(arguments.from_cash_id)>#arguments.from_cash_id#<cfelse>NULL</cfif>,
				TO_EMPLOYEE_ID=<cfif isDefined('arguments.to_employee_id') and isnumeric(arguments.to_employee_id)>#arguments.to_employee_id#<cfelse>NULL</cfif>,
				FROM_EMPLOYEE_ID=<cfif isDefined('arguments.from_employee_id') and isnumeric(arguments.from_employee_id)>#arguments.from_employee_id#<cfelse>NULL</cfif>,
				TO_CONSUMER_ID=<cfif isDefined('arguments.to_consumer_id') and isnumeric(arguments.to_consumer_id)>#arguments.to_consumer_id#<cfelse>NULL</cfif>,
				FROM_CONSUMER_ID=<cfif isDefined('arguments.from_consumer_id') and isnumeric(arguments.from_consumer_id)>#arguments.from_consumer_id#<cfelse>NULL</cfif>,
				REVENUE_COLLECTOR_ID=<cfif isDefined('arguments.revenue_collector_id') and isnumeric(arguments.revenue_collector_id)>#arguments.revenue_collector_id#<cfelse>NULL</cfif>,
				IS_PROCESSED=<cfif isdefined('arguments.is_processed') and isnumeric(arguments.is_processed)>#arguments.is_processed#<cfelse>0</cfif>,
				FROM_BRANCH_ID=<cfif isdefined('arguments.from_branch_id') and len(arguments.from_branch_id)>#arguments.from_branch_id#<cfelse>NULL</cfif>,
				TO_BRANCH_ID=<cfif isdefined('arguments.to_branch_id') and len(arguments.to_branch_id)>#arguments.to_branch_id#<cfelse>NULL</cfif>,
				ASSETP_ID=<cfif isdefined('arguments.assetp_id') and len(arguments.assetp_id)>#arguments.assetp_id#<cfelse>NULL</cfif>,
				SPECIAL_DEFINITION_ID = <cfif isdefined('arguments.special_definition_id') and len(arguments.special_definition_id)>#arguments.special_definition_id#<cfelse>NULL</cfif>,
				PROJECT_ID=<cfif isdefined('arguments.project_id') and len(arguments.project_id)>#arguments.project_id#<cfelse>NULL</cfif>,
				IS_CASH_PAYMENT=<cfif isdefined('arguments.is_cash_payment') and len(arguments.is_cash_payment)>#arguments.is_cash_payment#<cfelse>NULL</cfif>,
				ACC_TYPE_ID=<cfif isdefined('arguments.acc_type_id') and len(arguments.acc_type_id) and arguments.acc_type_id neq 0>#arguments.acc_type_id#<cfelseif (isDefined('arguments.to_employee_id') and isnumeric(arguments.to_employee_id)) or (isDefined('arguments.from_employee_id') and isnumeric(arguments.from_employee_id))>-1<cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = <cfif isDefined("session.ep.userid")>#session.ep.userid#<cfelse>NULL</cfif>,
				UPDATE_PAR = <cfif isDefined("session.pp.userid")>#session.pp.userid#<cfelse>NULL</cfif>,
				UPDATE_CONS = <cfif isDefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				<cfif arguments.period_is_integrated>IS_ACCOUNT=1,IS_ACCOUNT_TYPE=#arguments.account_card_type#<cfelse>IS_ACCOUNT=0,IS_ACCOUNT_TYPE=0</cfif>
			WHERE
				ACTION_ID = #arguments.action_id#
				AND ACTION_TYPE_ID = #arguments.workcube_old_process_type#
                AND ISNULL(IS_CANCEL,0)=0
				<cfif isDefined('arguments.action_table') and len(arguments.action_table)> AND ACTION_TABLE = '#arguments.action_table#'</cfif> 
				<cfif isDefined('arguments.payroll_id') and len(arguments.payroll_id)> AND PAYROLL_ID = #arguments.payroll_id#</cfif> 
		</cfquery>
	<cfelse>
		<cfquery name="ADD_CARI" datasource="#arguments.cari_db#" result="GET_MAX_CARI">
			INSERT INTO
				#arguments.cari_db_alias#CARI_ROWS
				(
					ACTION_ID,
					ACTION_TYPE_ID,
					ACTION_DATE,
					PROCESS_CAT,
					ACTION_VALUE,
					ACTION_CURRENCY_ID,
					<cfif len(arguments.action_currency_2)>
					ACTION_VALUE_2,ACTION_CURRENCY_2,
					</cfif>
					PAYMENT_VALUE,
					ACTION_TABLE,
					PAPER_NO,
					ACTION_DETAIL,
					DUE_DATE,
					ACTION_NAME,
					EXPENSE_CENTER_ID,
					EXPENSE_ITEM_ID,
					SPECIAL_DEFINITION_ID,
					PAYER_ID,
					OTHER_CASH_ACT_VALUE,
					OTHER_MONEY,
					RATE2,
					TO_CMP_ID,
					FROM_CMP_ID,
					TO_ACCOUNT_ID,
					FROM_ACCOUNT_ID,
					TO_CASH_ID,
					FROM_CASH_ID,
					TO_EMPLOYEE_ID,
					FROM_EMPLOYEE_ID,
					TO_CONSUMER_ID,
					FROM_CONSUMER_ID,
					REVENUE_COLLECTOR_ID,
					IS_PROCESSED,
					IS_CASH_PAYMENT,
                    ACC_TYPE_ID,
					PAPER_ACT_DATE,
					<cfif isdefined('arguments.from_branch_id') and len(arguments.from_branch_id)>
					FROM_BRANCH_ID,
					</cfif>
					<cfif isdefined('arguments.to_branch_id') and len(arguments.to_branch_id)>
					TO_BRANCH_ID,
					</cfif>
					<cfif isdefined('arguments.assetp_id') and len(arguments.assetp_id)>
					ASSETP_ID,
					</cfif>
					<cfif isdefined('arguments.project_id') and len(arguments.project_id)>
					PROJECT_ID,
					</cfif>
					<cfif isdefined('arguments.payroll_id') and len(arguments.payroll_id)>
					PAYROLL_ID,
					</cfif>
					<cfif arguments.period_is_integrated>IS_ACCOUNT,IS_ACCOUNT_TYPE<cfelse>IS_ACCOUNT,IS_ACCOUNT_TYPE</cfif>,
                    IS_CANCEL,
					RECORD_DATE,
					<cfif isDefined("session.ep.userid")>
						RECORD_EMP,
					<cfelseif isDefined("session.pp.userid")>
						RECORD_PAR,
					<cfelseif isDefined("session.ww.userid")>
						RECORD_CONS,
					</cfif>
					RECORD_IP
				)
			VALUES
				(
					#arguments.action_id#,
					#arguments.workcube_process_type#,
					#arguments.islem_tarihi#,
					#arguments.process_cat#,
					#wrk_round(arguments.islem_tutari,2)#,
					'#arguments.action_currency#',
					<cfif len(arguments.action_currency_2)>
						<cfif isdefined('arguments.action_value2') and len(arguments.action_value2)>#wrk_round(arguments.action_value2,2)#,<cfelseif isdefined("arguments.currency_multiplier") and len(arguments.currency_multiplier)>#wrk_round((arguments.islem_tutari/arguments.currency_multiplier),2)#,<cfelse>NULL,</cfif>
						'#arguments.action_currency_2#',
					</cfif>
					<cfif isDefined('arguments.payment_value') and len(arguments.payment_value)>#arguments.payment_value#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.action_table') and len(arguments.action_table)>'#arguments.action_table#'<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.islem_belge_no') and len(arguments.islem_belge_no)>'#arguments.islem_belge_no#'<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.action_detail') and len(arguments.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(arguments.action_detail,250)#"><cfelse>NULL</cfif>,
					<cfif isDefined('arguments.due_date') and isdate(arguments.due_date)>#arguments.due_date#<cfelse>#arguments.islem_tarihi#</cfif>,
					<cfif isDefined('arguments.islem_detay') and len(arguments.islem_detay)>'#LEFT(arguments.islem_detay,100)#'<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.expense_center_id') and isnumeric(arguments.expense_center_id)>#arguments.expense_center_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.expense_item_id') and isnumeric(arguments.expense_item_id)>#arguments.expense_item_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.special_definition_id') and isnumeric(arguments.special_definition_id)>#arguments.special_definition_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.payer_id') and isnumeric(arguments.payer_id)>#arguments.payer_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.other_money_value') and isnumeric(arguments.other_money_value)>#wrk_round(arguments.other_money_value,2)#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.other_money') and len(arguments.other_money)>'#arguments.other_money#'<cfelse>NULL</cfif>,
					<cfif isdefined("arguments.rate2") and len(arguments.rate2) and arguments.rate2 neq 0>#arguments.rate2#<cfelseif isDefined('arguments.other_money_value') and isnumeric(arguments.other_money_value) and arguments.other_money_value neq 0>#arguments.islem_tutari/arguments.other_money_value#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.to_cmp_id') and isnumeric(arguments.to_cmp_id) and not (isDefined('arguments.to_employee_id') and isnumeric(arguments.to_employee_id))>#arguments.to_cmp_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.from_cmp_id') and isnumeric(arguments.from_cmp_id) and not (isDefined('arguments.from_employee_id') and isnumeric(arguments.from_employee_id))>#arguments.from_cmp_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.to_account_id') and isnumeric(arguments.to_account_id)>#arguments.to_account_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.from_account_id') and isnumeric(arguments.from_account_id)>#arguments.from_account_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.to_cash_id') and isnumeric(arguments.to_cash_id)>#arguments.to_cash_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.from_cash_id') and isnumeric(arguments.from_cash_id)>#arguments.from_cash_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.to_employee_id') and isnumeric(arguments.to_employee_id)>#arguments.to_employee_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.from_employee_id') and isnumeric(arguments.from_employee_id)>#arguments.from_employee_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.to_consumer_id') and isnumeric(arguments.to_consumer_id)>#arguments.to_consumer_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.from_consumer_id') and isnumeric(arguments.from_consumer_id)>#arguments.from_consumer_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.revenue_collector_id') and isnumeric(arguments.revenue_collector_id)>#arguments.revenue_collector_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.is_processed') and isnumeric(arguments.is_processed)>#arguments.is_processed#<cfelse>0</cfif>,
					<cfif isdefined('arguments.is_cash_payment') and len(arguments.is_cash_payment)>#arguments.is_cash_payment#<cfelse>NULL</cfif>,
					<cfif isdefined('arguments.acc_type_id') and len(arguments.acc_type_id) and arguments.acc_type_id neq 0>
						#arguments.acc_type_id#
					<cfelseif (isDefined('arguments.to_employee_id') and isnumeric(arguments.to_employee_id)) or (isDefined('arguments.from_employee_id') and isnumeric(arguments.from_employee_id))>
						-1
					<cfelse>
						NULL
					</cfif>,
					<cfif isdefined('arguments.paper_act_date') and len(arguments.paper_act_date)>#arguments.paper_act_date#<cfelse>NULL</cfif>,
					<cfif isdefined('arguments.from_branch_id') and len(arguments.from_branch_id)>#arguments.from_branch_id#,</cfif>
					<cfif isdefined('arguments.to_branch_id') and len(arguments.to_branch_id)>#arguments.to_branch_id#,</cfif>
					<cfif isdefined('arguments.assetp_id') and len(arguments.assetp_id)>#arguments.assetp_id#,</cfif>
					<cfif isdefined('arguments.project_id') and len(arguments.project_id)>#arguments.project_id#,</cfif>
					<cfif isdefined('arguments.payroll_id') and len(arguments.payroll_id)>#arguments.payroll_id#,</cfif>
					<cfif arguments.period_is_integrated>1,#arguments.account_card_type#<cfelse>0,0</cfif>,
                    <cfif isdefined('arguments.is_cancel') and len(arguments.is_cancel)>#arguments.is_cancel#,<cfelse>0,</cfif>
					#now()#,
					<cfif isDefined("session.ep.userid")>
						#SESSION.EP.USERID#,
					<cfelseif isDefined("session.pp.userid")>
						#SESSION.PP.USERID#,
					<cfelseif isDefined("session.ww.userid")>
						#SESSION.WW.USERID#,
					</cfif>
					'#CGI.REMOTE_ADDR#'
				)
		</cfquery>
		<cfset max_cari_action_id = GET_MAX_CARI.IDENTITYCOL>
	</cfif>
	<cfreturn 1>
</cffunction>
<cffunction name="cari_sil" returntype="boolean" output="false">
	<!---
	by :   20040227
	notes : Cari İşlemi Siler...Fonksiyon sorunsuz çalistiginda true döndürür.
	usage :
	cari_sil(action_id : some.action_id,workcube_old_process_type : 32);
	revisions : 
	--->
	<cfargument name="action_id" required="yes" type="numeric">
	<cfargument name="process_type" required="yes" type="numeric">
	<cfargument name="action_table" type="string">
	<cfargument name="payroll_id" type="string">
	<cfargument name="cari_db" type="string" default="#dsn2#">
	<cfargument name="cari_db_alias" type="string">
	<cfargument name="inv_related_info" type="string" default="0"><!--- fatura güncellemelerde,satır bazında vadeleşme yapılmışsa,kapamayı silmesn diye eklendi --->
	<cfargument name="is_delete_action" type="string" default="0"><!---  Ersan için tek satırlı faturaları n update işleminde talepler silinmiyor, fakat fatura silindiğinde de bu bloğa girmiyordu, o yüzden fatura silme işleminden bu parametreyi gönderiyoruz. --->
	<cfscript>
		if(arguments.cari_db is not '#dsn2#') 
		{ /*cari_db argumanına session da tutulan period dısında dsn2 gonderilmesi durumunda else bolumu calısıyor. orn. ayarlar - cari devir islemi
			bu sadece carici functionında boyle muhasebeciyle karıstırılmasın. muhasebeci sadece bulundugu perioddaki dsn2'den calısır...OZDEN20070111*/
			if(arguments.cari_db is '#dsn#' or arguments.cari_db is '#dsn1#' or arguments.cari_db is '#dsn3#')		
				arguments.cari_db_alias = '#dsn2_alias#.';
			else 
				arguments.cari_db_alias = '#cari_db#.';
		}
		else
			arguments.cari_db_alias = '';
		if(arguments.inv_related_info neq 1)//manuel kapama işlemlernde cari bazlı çalıştıg için,cari_sil le birlikte kullanılacak, manuel kapamalarda,o kapamaya bağlı tüm hareketleri de siliniyor..Aysenur20081021
		{
			get_cari_row = cfquery(datasource:"#arguments.cari_db#",sqlstring:"SELECT ACTION_ID,CARI_ACTION_ID,ACTION_TABLE,DUE_DATE,ACTION_TYPE_ID FROM #arguments.cari_db_alias#CARI_ROWS WHERE ACTION_ID = #arguments.action_id# AND ACTION_TYPE_ID = #arguments.process_type#");
			if((get_cari_row.ACTION_TABLE eq 'INVOICE' and get_cari_row.recordcount gt 1) or get_cari_row.ACTION_TABLE neq 'INVOICE' or arguments.is_delete_action eq 1)
			{
				//yazışmalardan gelen ödeme taleplerine bağlı olan closed ve closed_row kayıtları güncelleniyor, bu işlemlerin kapama satırı olmadığı için silme işlemi yapılmıyor
				if (get_cari_row.recordcount)
				{
					get_closed_info = cfquery(datasource:"#arguments.cari_db#",sqlstring:"SELECT CLOSED_ID,CLOSED_ROW_ID,CARI_ACTION_ID FROM #arguments.cari_db_alias#CARI_CLOSED_ROW WHERE RELATED_CARI_ACTION_ID = #get_cari_row.cari_action_id#");
					if (get_closed_info.recordcount)
					{
						upd_cari_closed_main = cfquery(datasource:"#arguments.cari_db#",is_select:false,sqlstring:"UPDATE #arguments.cari_db_alias#CARI_CLOSED SET IS_CLOSED = NULL,DEBT_AMOUNT_VALUE = NULL,CLAIM_AMOUNT_VALUE = NULL,DIFFERENCE_AMOUNT_VALUE = NULL WHERE CLOSED_ID = #get_closed_info.closed_id[1]#");
						for(kk=1;kk lte get_closed_info.recordcount;kk=kk+1)
						{
							upd_cari_closed = cfquery(datasource:"#arguments.cari_db#",is_select:false,sqlstring:"UPDATE #arguments.cari_db_alias#CARI_CLOSED_ROW SET RELATED_CLOSED_ROW_ID = NULL,RELATED_CARI_ACTION_ID=NULL,CLOSED_AMOUNT = NULL,OTHER_CLOSED_AMOUNT = NULL WHERE RELATED_CARI_ACTION_ID = #get_cari_row.cari_action_id#");
						}
					}
				}
				//normal kapama işlemlerinin silme işlemi, talep veya emir kapatan satırlar alınmasın diye related_closed_row_id ve related_cari_action_id kontrol ediliyor
				get_closed_info = cfquery(datasource:"#arguments.cari_db#",sqlstring:"SELECT CLOSED_ID,CLOSED_ROW_ID FROM #arguments.cari_db_alias#CARI_CLOSED_ROW WHERE ACTION_ID = #arguments.action_id# AND ACTION_TYPE_ID = #arguments.process_type# AND CLOSED_ROW_ID NOT IN(SELECT RELATED_CLOSED_ROW_ID FROM #arguments.cari_db_alias#CARI_CLOSED_ROW WHERE RELATED_CLOSED_ROW_ID IS NOT NULL)");
				if (get_closed_info.recordcount)
				{
					for(kk=1;kk lte get_closed_info.recordcount;kk=kk+1)
					{
						del_cari_closed = cfquery(datasource:"#arguments.cari_db#",is_select:false,sqlstring:"DELETE FROM #arguments.cari_db_alias#CARI_CLOSED WHERE CLOSED_ID = #get_closed_info.closed_id[kk]#");
						del_cari_closed_row = cfquery(datasource:"#arguments.cari_db#",is_select:false,sqlstring:"DELETE FROM #arguments.cari_db_alias#CARI_CLOSED_ROW WHERE CLOSED_ID = #get_closed_info.closed_id[kk]#");
					}
				}
				//cari_row a bağlı talep ve emirlerin kapama satırları siliniyor ve ilişkili işlemleri update ediliyor
				get_closed_info = cfquery(datasource:"#arguments.cari_db#",sqlstring:"SELECT CLOSED_ID,CLOSED_ROW_ID FROM #arguments.cari_db_alias#CARI_CLOSED_ROW WHERE ACTION_ID = #arguments.action_id# AND ACTION_TYPE_ID = #arguments.process_type# AND CLOSED_ROW_ID IN(SELECT RELATED_CLOSED_ROW_ID FROM #arguments.cari_db_alias#CARI_CLOSED_ROW WHERE RELATED_CLOSED_ROW_ID IS NOT NULL)");
				if (get_closed_info.recordcount)
				{
					upd_cari_closed_main = cfquery(datasource:"#arguments.cari_db#",is_select:false,sqlstring:"UPDATE #arguments.cari_db_alias#CARI_CLOSED SET IS_CLOSED = NULL,DEBT_AMOUNT_VALUE = NULL,CLAIM_AMOUNT_VALUE = NULL,DIFFERENCE_AMOUNT_VALUE = NULL WHERE CLOSED_ID = #get_closed_info.closed_id[1]#");
					for(kk=1;kk lte get_closed_info.recordcount;kk=kk+1)
					{
						upd_cari_closed = cfquery(datasource:"#arguments.cari_db#",is_select:false,sqlstring:"UPDATE #arguments.cari_db_alias#CARI_CLOSED_ROW SET RELATED_CLOSED_ROW_ID = NULL,CLOSED_AMOUNT = NULL,OTHER_CLOSED_AMOUNT = NULL WHERE RELATED_CLOSED_ROW_ID = #get_closed_info.closed_row_id[kk]#");
						del_cari_closed_row = cfquery(datasource:"#arguments.cari_db#",is_select:false,sqlstring:"DELETE FROM #arguments.cari_db_alias#CARI_CLOSED_ROW WHERE CLOSED_ROW_ID = #get_closed_info.closed_row_id[kk]#");
					}
				}
			}
		}
	</cfscript>
	<cfquery name="DEL_CARI" datasource="#arguments.cari_db#">
		DELETE FROM #arguments.cari_db_alias#CARI_ROWS WHERE ACTION_ID = #arguments.action_id# AND ISNULL(IS_CANCEL,0)=0 AND ACTION_TYPE_ID = #arguments.process_type# <cfif isDefined('arguments.action_table') and len(arguments.action_table)> AND ACTION_TABLE = '#arguments.action_table#'</cfif>  <cfif isDefined('arguments.payroll_id') and len(arguments.payroll_id)> AND PAYROLL_ID = #arguments.payroll_id#</cfif>
	</cfquery>
	<cfreturn true>
</cffunction>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
