<!--- islem tarihine ait e-defter varsa silinmesi engelleniyor --->
<cfif isDefined("attributes.is_autopayment")>
	<cfif session.ep.our_company_info.is_edefter eq 1>
    	<cfquery name="get_startdate" datasource="#dsn2#">
        	SELECT
            	STARTDATE
            FROM
            	FILE_IMPORTS
            WHERE
            	I_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#export_import_id#">
        </cfquery>
        <cfstoredproc procedure="GET_NETBOOK" datasource="#dsn2#">
            <cfprocparam cfsqltype="cf_sql_timestamp" value="#get_startdate.startdate#">
            <cfprocparam cfsqltype="cf_sql_timestamp" value="#get_startdate.startdate#">
            <cfprocparam cfsqltype="cf_sql_varchar" value="">
            <cfprocresult name="getNetbook">
        </cfstoredproc>
		
        <cfscript>
            if(getNetbook.recordcount)
                abort("<cf_get_lang dictionary_id='52606.İşlemi yapamazsınız'>. <cf_get_lang dictionary_id='51859.İşlem tarihine ait e-defter bulunmaktadır'>.");
        </cfscript>
   </cfif>
</cfif>



<cf_get_lang_set module_name="bank"><!--- sayfanin en altinda kapanisi var --->
<cf_xml_page_edit fuseact ="bank.popup_open_multi_prov_file">
<!--- Provizyon sayfalarında şifre girmek için kullanılan ortak form sayfasıdır AE20060606--->
<cfparam name="attributes.prov_period" default="">
<cfparam name="attributes.modal_id" default="">
<cfset pageHead = #getLang('bank',307)#>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Toplu Provizyon Dönüşleri','54783')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfoutput>
			<cfif isDefined("attributes.is_iptal")><!--- Provizyon dosyasını iptal etme sayfasına gitmek için --->
				<form name="open_prov_file" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_cancel_provision_file#xml_str#">
			<cfelseif isDefined("attributes.is_del_prov")><!--- Provizyon dosyasını geri almak için --->
				<form name="open_prov_file" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_del_provision_import#xml_str#">
			<cfelseif isDefined("attributes.is_autopayment")><!--- otomatik ödeme işlemini geri almak için --->
				<form name="open_prov_file" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_del_autopayment_import#xml_str#">
			<cfelse><!--- oluşturulan dosyayı görüntülemek için --->
				<form name="open_prov_file" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_open_multi_prov_file#xml_str#">
			</cfif>
			<input type="hidden" name="export_import_id" id="export_import_id" value="#attributes.export_import_id#">
			<input type="hidden" name="is_encrypt_file" id="is_encrypt_file" value="#is_encrypt_file#">
			<cfif isDefined("attributes.is_import")><input type="hidden" name="is_import" id="is_import" value="#attributes.is_import#"></cfif>
		</cfoutput>
		<cf_box_elements>
			<cfoutput><input type="hidden" name="modal_id" id="modal_id" value="#attributes.modal_id#"></cfoutput>
				<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<cfif (isDefined("attributes.is_del_prov")) and (session.ep.admin or get_module_power_user(19))><!--- sadece yıl sonunda ve pronet için uzman bilgisinde yapılması gerektigi icin admine bağlanmıstır...Aysenur20061214 --->
					<div class="form-group" id="item-">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48956.İlişkili Fatura Dönemi'></label>
						<div class="col col-8 col-xs-12">
							<cfquery name="GET_PERIODS" datasource="#DSN#">
								SELECT PERIOD_ID,PERIOD,PERIOD_YEAR FROM SETUP_PERIOD ORDER BY OUR_COMPANY_ID,PERIOD_YEAR
							</cfquery>
							<select name="prov_period" id="prov_period" >
							<cfoutput query="get_periods">
								<option value="#period_id#" <cfif attributes.prov_period eq period_id> selected <cfelseif period_id eq session.ep.period_id> selected</cfif>>#period# - (#period_year#)</option>
							</cfoutput>
							</select>
						</div>
					</div>
					</cfif>
					<cfif is_encrypt_file eq 1>
					<div class="form-group" id="item-key_type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48918.Anahtar'> *</label>
						<div class="col col-8 col-xs-12">
							<input name="key_type" id="key_type" type="password" autocomplete="off" >
						</div>
					</div>
					</cfif>
				</div>
		</cf_box_elements>
		<cf_box_footer>
			<cfsavecontent variable="message"><cf_get_lang no ='308.Aç'></cfsavecontent>
			<cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'     insert_info='#message#'>
		</cf_box_footer>
	</form>
	</cf_box>
</div>
<script type="text/javascript">
	
	<cfif is_encrypt_file eq 1>
		function kontrol()
		{
			<cfif is_encrypt_file eq 0>//xml den şifreleme yapilmasin
				document.open_prov_file.submit();
			</cfif> 
			<cfif is_encrypt_file eq 1>
				open_prov_file.key_type.focus();
			</cfif>
					if(open_prov_file.key_type.value == "")
			{
				alert("<cf_get_lang dictionary_id='48964.Anahtar Giriniz'>!");
				return false;
			}
			return true;
		}
	</cfif>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
