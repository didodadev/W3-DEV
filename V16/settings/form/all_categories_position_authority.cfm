<!--- FB 20070706 Bu sayfa Tum Islem Kategorilerine calisan yada pozisyon tipinde secimli yetki vermek icin olusturulmustur --->
<cfset main_process_row_list = "">
<cfset process_row_list = "">
<cfparam name="attributes.position_cat" default="">
<cfparam name="attributes.position_code" default="">
<cfparam name="attributes.position_name" default="">
<cfparam name="attributes.main_surec_id" default="">
<cfparam name="attributes.surec_id" default="">
<cfif isdefined("attributes.submitted")>
	<cfquery name="get_main_process" datasource="#dsn#"><!--- Tüm Ana İşlem Kategorileri --->
		SELECT MAIN_PROCESS_CAT_ID,MAIN_PROCESS_CAT FROM SETUP_MAIN_PROCESS_CAT ORDER BY MAIN_PROCESS_CAT
	</cfquery>
	<cfquery name="get_main_process_row" datasource="#dsn#"><!--- Sadece yetkili olduğumuz ana işlem kategorileri --->
		SELECT 
			MAIN_PROCESS_CAT_ID
		FROM
			SETUP_MAIN_PROCESS_CAT_ROWS
		WHERE
			<cfif len(attributes.position_code)>
				MAIN_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
			<cfelseif len(attributes.position_cat)>
				MAIN_POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat#">
			</cfif>
	</cfquery>
	<cfset main_process_row_list = listsort(listdeleteduplicates(valuelist(get_main_process_row.main_process_cat_id,',')),'numeric','ASC',',')>
	<cfquery name="get_process" datasource="#dsn3#"><!--- Tüm İşlem Kategorileri--->
		SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT ORDER BY PROCESS_CAT
	</cfquery>
	<cfquery name="get_process_row" datasource="#dsn3#"><!--- Sadece yetkili olduğumuz işlem kategorileri --->
		SELECT 
			PROCESS_CAT_ID
		FROM 
			SETUP_PROCESS_CAT_ROWS 
		WHERE 
			<cfif len(attributes.position_code)>
				POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
			<cfelseif len(attributes.position_cat)>
				POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat#">
			</cfif>
	</cfquery>
	<cfset process_row_list = listsort(listdeleteduplicates(valuelist(get_process_row.process_cat_id,',')),'numeric','ASC',',')>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Pozisyon Tipleri Toplu İşlem Yetkilendirme','63041')#" body_height="150px">
		<cfform name="search_position" method="post" action="#request.self#?fuseaction=settings.all_categories_position_authority" onsubmit="return kontrol();">
			<input type="hidden" name="submitted" id="submitted" value="">
			<cf_box_search>
				<div class="form-group">
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<cfquery name="get_position_cats" datasource="#dsn#">
							SELECT POSITION_CAT_ID, POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_STATUS = 1 ORDER BY POSITION_CAT 
						</cfquery>
						<select name="position_cat" id="position_cat" onChange="document.search_position.position_name.value='';">
							<option value=""><cf_get_lang dictionary_id='59004.Pozisyon Tipi'><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_position_cats">
								<option value="#position_cat_id#" <cfif attributes.position_cat eq position_cat_id>selected</cfif>>#position_cat#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-position_name">
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="input-group">
							<cfoutput>
								<input type="hidden" name="position_code" id="position_code" value="<cfoutput>#attributes.position_code#</cfoutput>">
								<cfinput type="text" name="position_name" id="position_name" placeholder="#getLang('','Çalışan','57576')#" onFocus="AutoComplete_Create('position_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','PARTNER_CODE','position_code','','3','150');" value="#attributes.position_name#" style="width:150px;" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=search_position.position_name&field_code=search_position.position_code&select_list=1');document.search_position.position_cat.value ='';return false;"></span>
							</cfoutput>
						</div>
					</div>
				</div>		
				<div class="form-group">
					<cf_wrk_search_button is_excel='0' button_type="4">
				</div>
				<div class="form-group">
					<font color="red"><cf_get_lang dictionary_id='63042.Seçilen pozisyon tipi veya çalışana işlem yetkileri verilir'>.</font>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>

	<script type="text/javascript">
		function kontrol()
		{
			if((document.search_position.position_name.value == "" || document.search_position.position_code.value == "") && document.search_position.position_cat.value == "")
			{
				alert("<cf_get_lang dictionary_id='44123.Çalışan Yada Pozisyon Tipi Seçmelisiniz'>!");
				return false;
			}
			if(document.search_position.position_code.value!="" && document.search_position.position_name.value!="" && document.search_position.position_cat.value!="")
			{
				alert("<cf_get_lang dictionary_id='44122.Çalışan Yada Pozisyon Tipi Seçeneklerinden Sadece Birini Seçmelisiniz'>!");
				return false;
			}
			if(document.search_position.position_name.value == "")
			{
				document.search_position.position_code.value = "";
			}
			return true;
		}
	</script>
	<cfif isdefined("attributes.submitted")>
		<cf_box title="#getLang('','Ana İşlem Kategorileri','43247')#" closable="0" collapsed="0">
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12" style="display:'none';">
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
					<cfform name="search_main_process" method="post" action="#request.self#?fuseaction=settings.all_categories_position_authority">
						<input type="hidden" name="submitted_1" id="submitted_1" value="">
						<input type="hidden" name="position_code" id="position_code" value="<cfoutput>#attributes.position_code#</cfoutput>">
						<input type="hidden" name="position_cat" id="position_cat" value="<cfoutput>#attributes.position_cat#</cfoutput>">
						<input type="hidden" name="position_name" id="position_name" value="<cfoutput>#attributes.position_name#</cfoutput>">
						<cfparam name="attributes.mode" default="4">
						<cfparam name="attributes.page" default="1">
						<cfif get_main_process.recordcount>
							<cfset attributes.startrow = 1>
							<cfset attributes.maxrows = get_main_process.recordcount>
							<div class="form-group">
								<label class="bold padding-left-5"><input type="checkbox" name="add_main_process_id" id="add_main_process_id" value="1" onClick="wrk_select_all('add_main_process_id','main_surec_id');"><b><cf_get_lang dictionary_id='42688.Hepsini Seç'></b></label>
							</div>
							<cfoutput query="get_main_process" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
								<cfif ((currentrow mod attributes.mode is 1)) or (currentrow eq 1)>
									<div class="form-group">
										</cfif>
										<label class="col col-2 col-xs-12 padding-left-5">
											<cfif listfind(main_process_row_list,main_process_cat_id,',') neq 0>
												<input type="checkbox" name="main_surec_id" id="main_surec_id" value="#main_process_cat_id#" checked>
											<cfelse>
												<input type="checkbox" name="main_surec_id" id="main_surec_id" value="#main_process_cat_id#">
											</cfif>
											(#main_process_cat_id#) #main_process_cat#
										</label>
										<cfif ((currentrow mod attributes.mode is 0)) or (currentrow eq recordcount)>
									</div>
								</cfif>
							</cfoutput>
							<cf_box_footer>
								<cf_workcube_buttons is_upd="0" is_cancel='0' add_function='main_gonder()'>
							</cf_box_footer>	
						<cfelse>
							<div class="form-group">
								<label>&nbsp;</label>
							</div>
						</cfif>
					</cfform>
				</div>
			</div>	
		</cf_box>
	<script type="text/javascript">
		function main_gonder()<!--- Isaretleme yapilmamissa gonderme --->
		{
			deger1 = 0;
			for(dg=0;dg<<cfoutput>#get_main_process.recordcount#</cfoutput>;dg++)
				if(document.search_main_process.main_surec_id[dg].checked == true)
				{
					deger1++;
					break;							
				}
				if(deger1== 0)
				{
					alert("<cf_get_lang dictionary_id='63049.Ana işlem kategorisi seçmelisiniz'>!");
					return false;
				}
			if(confirm("<cf_get_lang dictionary_id='44121.Buradaki Yetkileri Ana İşlem Kategorilerinde Değiştirdiniz Onaylıyor Musunuz'>?"))
				return true;
			else
				return false;
		}
	</script>
	<cf_box title="#getLang('settings',177)#" closable="0" collapsed="0">
		<div class="col col-12" style="display:'none';">
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
				<cfform name="search_process" method="post" action="#request.self#?fuseaction=settings.all_categories_position_authority">
					<input type="hidden" name="submitted_2" id="submitted_2" value="">
					<input type="hidden" name="position_code" id="position_code" value="<cfoutput>#attributes.position_code#</cfoutput>">
					<input type="hidden" name="position_cat" id="position_cat" value="<cfoutput>#attributes.position_cat#</cfoutput>">
					<input type="hidden" name="position_name" id="position_name" value="<cfoutput>#attributes.position_name#</cfoutput>">
					<input type="hidden" name="our_company_id" id="our_company_id" value="<cfoutput>#session.ep.company_id#</cfoutput>">
					<cfparam name="attributes.mode" default="4">
					<cfparam name="attributes.page" default="1">
					<cfif get_process.recordcount>
						<cfset attributes.startrow2 = 1>
						<cfset attributes.maxrows2 = get_process.recordcount>
						<div class="form-group">
							<label class="bold padding-left-5"><input type="checkbox" name="add_process_id" id="add_process_id" value="1" onClick="wrk_select_all('add_process_id','surec_id');"><b><cf_get_lang dictionary_id='42688.Hepsini Seç'></b></label>
						</div>
						<cfoutput query="get_process" startrow="#attributes.startrow2#" maxrows="#attributes.maxrows2#">
							<cfif ((currentrow mod attributes.mode is 1)) or (currentrow eq 1)>
								<div class="form-group">
									</cfif>
									<label class="col col-3 col-xs-12 padding-left-5">
										<cfif listfind(process_row_list,process_cat_id,',') neq 0>
											<input type="checkbox" name="surec_id" id="surec_id" value="#process_cat_id#" checked>
										<cfelse>
											<input type="checkbox" name="surec_id" id="surec_id" value="#process_cat_id#">
										</cfif>
										(#process_cat_id#) #process_cat#
									</label>
									<cfif ((currentrow mod attributes.mode is 0)) or (currentrow eq recordcount)>
								</div>
							</cfif>
						</cfoutput>
						<cf_box_footer>
							<cf_workcube_buttons is_upd="0" is_cancel='0' add_function='gonder()'>
						</cf_box_footer>
					<cfelse>
						<div class="form-group">
							<label>&nbsp;</label>
						</div>
					</cfif>
				</cfform>
			</div>
		</div>
	</cf_box>	
</div>
	<script type="text/javascript">
		function gonder()<!--- Isaretleme yapilmamissa gonderme --->
		{
			deger2 = 0;
			for(dgr=0;dgr<<cfoutput>#get_process.recordcount#</cfoutput>;dgr++)
				if(document.search_process.surec_id[dgr].checked == true)
				{
					deger2++;
					break;							
				}
				if(deger2== 0)
				{
					alert("<cf_get_lang dictionary_id='43242.İşlem Kategorisi Seçiniz'>!");
					return false;
				}
			if(confirm("<cf_get_lang dictionary_id='44119.Buradaki Yetkileri İşlem Kategorilerinde Değiştirdiniz Onaylıyor Musunuz'>?"))
				return true;
			else
				return false;
		}
	</script>
</cfif>

<cfif len(attributes.position_cat) or len(attributes.position_code)>
	<cfif isdefined("attributes.submitted_1") and len(attributes.main_surec_id)><!--- Ana işlem kategorileri insert--->
		<cflock name="#CreateUUID()#" timeout="20">
			<cftransaction>
			
			<!--- Ilgili Ana Islem Kategorisinde Guncelleme Bilgilerini Tutar --->
			<cfquery name="get_main_process_cat_rows_info" datasource="#dsn#">
				SELECT 
					MAIN_POSITION_CAT_ID,
					MAIN_PROCESS_CAT_ID
				FROM 
					SETUP_MAIN_PROCESS_CAT_ROWS 
				WHERE 
					MAIN_POSITION_CAT_ID NOT IN (#attributes.main_surec_id#) AND
					(
					<cfif len(attributes.position_cat)>
						MAIN_POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat#">
					</cfif>
					<cfif len(attributes.position_code) and len(attributes.position_cat)>OR</cfif>
					<cfif len(attributes.position_code)>
						MAIN_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
					</cfif>
					)
			</cfquery>
			<cfif get_main_process_cat_rows_info.recordcount>
				<cfset main_process_cat_id_list = ListAppend(attributes.main_surec_id,ValueList(get_main_process_cat_rows_info.main_process_cat_id),',')>
			<cfelse>
				<cfset main_process_cat_id_list = attributes.main_surec_id>
			</cfif>
			<cfquery name="upd_main_process_cat" datasource="#dsn#">
				UPDATE
					SETUP_MAIN_PROCESS_CAT
				SET
					UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
					UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
				WHERE
					MAIN_PROCESS_CAT_ID IN (#main_process_cat_id_list#)
			</cfquery>
			<!--- Ilgili Ana Islem Kategorisinde Guncelleme Bilgilerini Tutar --->
			
			<cfquery name="del_alss" datasource="#dsn#"><!--- tum yetkiler silinir yeni yetkilendirme asagida eklenecek --->
				DELETE FROM 
					SETUP_MAIN_PROCESS_CAT_ROWS 
				WHERE 
					MAIN_PROCESS_CAT_ID IS NOT NULL
					<cfif len(attributes.position_cat)>
						AND MAIN_POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat#">
					</cfif>
					<cfif len(attributes.position_code)>
						AND MAIN_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
					</cfif>
			</cfquery>
			
			<cfloop list="#attributes.main_surec_id#" index="main_sid">
				<cfquery name="add_main_pos" datasource="#dsn#">
					INSERT INTO 
						SETUP_MAIN_PROCESS_CAT_ROWS
					(
						MAIN_PROCESS_CAT_ID,
						MAIN_POSITION_CAT_ID,
						MAIN_POSITION_CODE
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#main_sid#">,
						<cfif len(attributes.position_cat)>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat#">	
						<cfelse>
							<cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer">
						</cfif>,
						<cfif len(attributes.position_code)>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
						<cfelse>
							<cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer">
						</cfif>
					)
				</cfquery>
			</cfloop>
			</cftransaction>
		</cflock>
		<cflocation addtoken="no" url="#request.self#?fuseaction=settings.all_categories_position_authority">
	<cfelseif isdefined("attributes.submitted_2") and len(attributes.surec_id)><!--- İşlem Kategorileri insert --->
		<cfif isdefined("attributes.our_company_id") and attributes.our_company_id eq session.ep.company_id>
			<cflock name="#CreateUUID()#" timeout="20">
				<cftransaction>
		
				<!--- Ilgili Islem Kategorisinde Guncelleme Bilgilerini Tutar, Bilgileri Islem Kategorinin Historysine Atar --->
				<cfquery name="get_process_cat_rows_info" datasource="#dsn3#">
					SELECT 
						PROCESS_CAT_ID
					FROM 
						SETUP_PROCESS_CAT_ROWS 
					WHERE 
						PROCESS_CAT_ID NOT IN (#attributes.surec_id#) AND
						(
						<cfif len(attributes.position_cat)>
							POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat#">
						</cfif>
						<cfif len(attributes.position_code) and len(attributes.position_cat)>OR</cfif>
						<cfif len(attributes.position_code)>
							POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
						</cfif>
						)
				</cfquery>
				<cfif get_process_cat_rows_info.recordcount>
					<cfset process_cat_id_list = ListAppend(attributes.surec_id,ValueList(get_process_cat_rows_info.process_cat_id),',')>
				<cfelse>
					<cfset process_cat_id_list = attributes.surec_id>
				</cfif>
				<cfquery name="upd_process_cat" datasource="#dsn3#">
					UPDATE
						SETUP_PROCESS_CAT
					SET
						UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
						UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
					WHERE
						PROCESS_CAT_ID IN (#process_cat_id_list#)
				</cfquery>
                <!---History Custom tag kullnılarak yapıldı. --->
           		<cf_wrk_get_history datasource="#dsn3#" source_table= "SETUP_PROCESS_CAT" target_table= "SETUP_PROCESS_CAT_HISTORY" record_id= "#process_cat_id_list#" record_name="PROCESS_CAT_ID">
				<!--- //Ilgili Islem Kategorisinde Guncelleme Bilgilerini Tutar, Bilgileri Islem Kategorinin Historysine Atar --->
				<cfquery name="del_alss" datasource="#dsn3#"><!--- tum yetkiler silinir yeni yetkilendirme asagida eklenecek --->
					DELETE FROM 
						SETUP_PROCESS_CAT_ROWS 
					WHERE 
						PROCESS_CAT_ID IS NOT NULL
						<cfif len(attributes.position_cat)>
							AND POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat#">
						</cfif>
						<cfif len(attributes.position_code)>
							AND POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
						</cfif>
				</cfquery>
				<cfloop list="#attributes.surec_id#" index="sid">
					<cfquery name="add_pos" datasource="#dsn3#">
						INSERT INTO 
							SETUP_PROCESS_CAT_ROWS
						(
							PROCESS_CAT_ID,
							POSITION_CAT_ID,
							POSITION_CODE
						)
						VALUES
						(
							<cfqueryparam cfsqltype="cf_sql_integer" value="#sid#">,
							<cfif len(attributes.position_cat)>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat#">	
							<cfelse>
								<cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer">
							</cfif>,
							<cfif len(attributes.position_code)>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
							<cfelse>
								<cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer">
							</cfif>
						)
					</cfquery>
				</cfloop>
				</cftransaction>
			</cflock>
		</cfif>
		<cflocation addtoken="no" url="#request.self#?fuseaction=settings.all_categories_position_authority">
	</cfif>
</cfif>
