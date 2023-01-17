<!--- FB 20070706 Bu sayfa Tum Sureclere calisana gore ve secimli yetki vermek icin olusturulmustur --->
<!--- Surec Grubu veya Tum Calisanlar da Secili olanlar Da Gosterilir --->
<cfset process_list = "">
<cfset process_row_posid_list = "">
<cfparam name="attributes.comp_id" default="#session.ep.company_id#">
<cfparam name="attributes.position_name" default="">
<cfparam name="attributes.position_code" default="">
<cfparam name="attributes.position_id" default="">
<cfparam name="attributes.surec_id" default="">

<cfquery name="get_our_company" datasource="#dsn#">
	SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY WHERE COMP_STATUS = 1 ORDER BY COMPANY_NAME
</cfquery>
<cfif isdefined("attributes.submitted")>
	<cfquery name="get_all_process" datasource="#dsn#"><!--- Tüm İşlem Tipleri Getiriliyor (Ilgili Sirkete Ait) --->
		SELECT 
			PT.PROCESS_ID,
			PT.PROCESS_NAME,
			PT.FACTION
		FROM
			PROCESS_TYPE PT,
			PROCESS_TYPE_OUR_COMPANY PTOC
		WHERE
			PT.IS_ACTIVE = 1 AND
			PT.PROCESS_ID = PTOC.PROCESS_ID AND
			PTOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#">
		ORDER BY
			PT.PROCESS_ID
	</cfquery>
	<cfif not get_all_process.recordcount>
		<cfset process_list = 0>
	<cfelse>
		<cfset process_list = listsort(listdeleteduplicates(valuelist(get_all_process.process_id,',')),'numeric','ASC',',')>
	</cfif>
	
	<cfquery name="get_process_row" datasource="#dsn#"><!--- Süreç Satırları --->
		SELECT PROCESS_ID,PROCESS_ROW_ID,STAGE,IS_EMPLOYEE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ID IN (#process_list#) ORDER BY PROCESS_ID, LINE_NUMBER
	</cfquery>
	
	<cfquery name="get_process_row_posid" datasource="#dsn#"><!--- Satirlarin yetki eklendigi tablo --->
		SELECT PROCESS_ROW_ID,WORKGROUP_ID, PRO_POSITION_ID FROM PROCESS_TYPE_ROWS_POSID WHERE PRO_POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#">
	</cfquery>
	<cfset process_row_posid_list = listsort(listdeleteduplicates(valuelist(get_process_row_posid.process_row_id,',')),'numeric','ASC',',')>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='32509.Süreçler'><cf_get_lang dictionary_id='43764.Yetki Verme'></cfsavecontent>
	<cf_box title="#title#" body_height="150px">
		<cfform name="search_position" id="search_position" method="post" action="#request.self#?fuseaction=settings.all_process_position_authority" onsubmit="return (kontrol());">
			<cf_box_search>
				<input type="hidden" name="submitted" id="submitted" value="">
				<div class="form-group">
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<select name="comp_id" id="comp_id">
							<option value=""><cf_get_lang dictionary_id='57574.Şirket'><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_our_company">
								<option value="#comp_id#" <cfif attributes.comp_id eq get_our_company.comp_id>selected</cfif>>#company_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>	
				<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-3" id="item-position_name">
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="input-group">
							<cfoutput>
								<input type="hidden" name="position_id" id="position_id" value="#attributes.position_id#">
								<input type="hidden" name="position_code" id="position_code" value="#attributes.position_code#">
								<input type="text" name="position_name" id="position_name" placeholder="<cf_get_lang dictionary_id='57576.Çalışan'>" value="#attributes.position_name#" onFocus="AutoComplete_Create('position_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_ID,POSITION_CODE','position_id,position_code','','3','150');">
								<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_name=search_position.position_name&field_id=search_position.position_id&field_code=search_position.position_code&select_list=1');"></span>		
							</cfoutput>
						</div>
					</div>
				</div>	
				<div class="form-group">
					<cf_wrk_search_button button_type="4" is_excel='0' search_function='kontrol()'>
				</div>
				<div class="form-group">
					<label align="rigth" width="300"><cfif not isdefined("attributes.submitted")><font color="#FF0000" size="2"><cf_get_lang dictionary_id='43437.Çalışan Seçiniz'>!</font></cfif></label>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<script type="text/javascript">
	function kontrol()
	{
		<cfif not isdefined("attributes.submitted")>
			var get_process_control = wrk_query("SELECT PT.PROCESS_ID FROM PROCESS_TYPE PT, PROCESS_TYPE_OUR_COMPANY PTOC WHERE PT.IS_ACTIVE = 1 AND PT.PROCESS_ID = PTOC.PROCESS_ID AND PTOC.OUR_COMPANY_ID = " + document.getElementById("comp_id").value,"dsn");
			if(get_process_control.recordcount == 0)
			{
				alert("<cf_get_lang dictionary_id='53701.İlgili Şirket'><cf_get_lang dictionary_id='647.Süreç Tanımlarınız Eksiktir'>, <cf_get_lang dictionary_id='48547.Kontrol Ediniz'>!");
				return false;
			}
		</cfif>
		if(document.getElementById("position_name").value == "" || document.getElementById("position_code").value == "" || document.getElementById("position_id").value == "")
		{	
			alert("<cf_get_lang dictionary_id='43437.Çalışan Seçiniz'>!");
			document.getElementById("position_name").value = "";
			document.getElementById("position_code").value = "";
			document.getElementById("position_id").value = "";
			return false;
		}	
		return true;
	}
	</script>
	<cfif isdefined("attributes.submitted")>
		<cf_box title="#getLang('','Süreçler','32509')#" closable="0" collapsed="0">
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
				<cfform name="search_process" id="search_process" method="post" action="#request.self#?fuseaction=settings.all_process_position_authority">
					<input type="hidden" name="submitted_1" id="submitted_1" value="">
					<cfoutput>
						<input type="hidden" name="position_code" id="position_code" value="#attributes.position_code#">
						<input type="hidden" name="position_id" id="position_id" value="#attributes.position_id#">
						<input type="hidden" name="position_name" id="position_name" value="#attributes.position_name#">
						<input type="hidden" name="our_comp_id" id="our_comp_id" value="#attributes.comp_id#">
					</cfoutput>
					<cfoutput query="get_process_row" group="process_id">
						<cf_seperator id="div_#currentrow#" header="#get_all_process.process_id[listfind(process_list,process_id,',')]# - #get_all_process.process_name[listfind(process_list,process_id,',')]#">
						<div id="div_#currentrow#">
							<div class="form-group" id="group_#currentrow#">
								<cfset count_ = 0>
								<cfoutput>
									<cfset count_ = count_ + 1>
									<label class="padding-left-5">
										<cfif listfind(process_row_posid_list,process_row_id,',') neq 0>
											<input type="checkbox" name="surec_id" id="surec_id" value="#process_row_id#" checked>
										<cfelse>
											<input type="checkbox" name="surec_id" id="surec_id" value="#process_row_id#">
										</cfif>
										#left(stage,23)#
										<cfif get_process_row.is_employee eq 1><label title="<cf_get_lang dictionary_id='32409.Tüm Çalışanlar'>"><b>(T.Ç.)</b></label></cfif>
										<cfif listfind(process_row_posid_list,process_row_id,',') eq 0>
											<cfquery name="get_work_group" datasource="#dsn#">
												SELECT
													WORKGROUP_NAME
												FROM
													PROCESS_TYPE_ROWS_WORKGRUOP PTRW,
													PROCESS_TYPE_ROWS_POSID PTRP
												WHERE
													PTRW.WORKGROUP_ID = PTRP.WORKGROUP_ID AND
													PTRP.WORKGROUP_ID IN (SELECT MAINWORKGROUP_ID FROM PROCESS_TYPE_ROWS_WORKGRUOP WHERE MAINWORKGROUP_ID IS NOT NULL AND PROCESS_ROW_ID = #process_row_id#)
											</cfquery>
											<cfif get_work_group.recordcount><label title="<cf_get_lang dictionary_id='31787.Süreç Grubu'>: #get_work_group.workgroup_name#"><b>(S.G.)</b></label></cfif>
										</cfif>
									</label>
								</cfoutput>
							</div>
						</div>
					</cfoutput>
					<div class="form-group">
						<label class="padding-left-5"><input type="checkbox" name="add_process_id" id="add_process_id" value="1" onClick="hepsini_sec();"><b><cf_get_lang dictionary_id='42688.Hepsini Seç'></b></label>						
					</div>
					<cf_box_footer>
						<cf_workcube_buttons is_upd="0" is_cancel='0' add_function='gonder()'>
					</cf_box_footer>
				</cfform>
			</div>  
		</cf_box>
		<script type="text/javascript">
			function gonder()<!--- Isaretleme yapilmamissa gonderme --->
			{
				deger = 0;
				for(dgr=0;dgr<<cfoutput>#get_process_row.recordcount#</cfoutput>;dgr++)
						if(document.search_process.surec_id[dgr].checked == true)
						{
							deger++;
							break;							
						}
					if(deger== 0)
					{
						alert("<cf_get_lang dictionary_id='44006.Kaydetmek İçin En Az Bir Seçim Yapmalısınız'> !");
						return false;
					}
				if(confirm("<cf_get_lang dictionary_id='44007.Bu çalışana ait değişiklikleri onaylıyor musunuz?'>?"))
					return true;
				else
					return false;	
			}
			function hepsini_sec()
			{
				if (document.getElementById("add_process_id").checked)
				{	
					for(say=0;say<<cfoutput>#get_process_row.recordcount#</cfoutput>;say++)
						document.search_process.surec_id[say].checked = true;
				}
				else
				{
					for(say=0;say<<cfoutput>#get_process_row.recordcount#</cfoutput>;say++)
						document.search_process.surec_id[say].checked = false;
				}
				return false;
			}
		</script>
	</cfif>
	<cfif isdefined("attributes.submitted_1")><!--- ikinci form submit edildi ise --->
		<cflock name="#CreateUUID()#" timeout="20">
			<cftransaction>
				<cfquery name="del_alss" datasource="#dsn#"><!--- tum yetkiler silinir yeni yetkilendirme asagida eklenecek --->
					DELETE FROM 
						PROCESS_TYPE_ROWS_POSID
					WHERE
						PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#"> AND
						PROCESS_TYPE_ROWS_POSID.PROCESS_ROW_ID IN (
							SELECT 
							PTR.PROCESS_ROW_ID
						FROM 
							PROCESS_TYPE_OUR_COMPANY PTO,
							PROCESS_TYPE_ROWS PTR
						WHERE
							PROCESS_TYPE_ROWS_POSID.PROCESS_ROW_ID = PTR.PROCESS_ROW_ID AND
							PTO.PROCESS_ID = PTR.PROCESS_ID AND
							PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_comp_id#">
						)
				</cfquery>
				
				<cfquery name="del_alss2" datasource="#dsn#"><!--- tum yetkiler silinir yeni yetkilendirme asagida eklenecek --->
					DELETE FROM PROCESS_TYPE_ROWS_POSID 
					WHERE
						PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#"> AND 
						WORKGROUP_ID IN (
						SELECT 
							PTRW.MAINWORKGROUP_ID
						FROM 
							PROCESS_TYPE_ROWS_WORKGRUOP PTRW,
							PROCESS_TYPE_ROWS PTR,
							PROCESS_TYPE_OUR_COMPANY PTO
						WHERE 
							PTRW.MAINWORKGROUP_ID = PROCESS_TYPE_ROWS_POSID.WORKGROUP_ID AND
							PTRW.PROCESS_ROW_ID = PTR.PROCESS_ROW_ID AND
							PTO.PROCESS_ID = PTR.PROCESS_ID AND 
							PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_comp_id#">
						)
				</cfquery>
				<cfif isdefined("attributes.submitted_1") and len(attributes.surec_id)>
					<cfloop list="#attributes.surec_id#" index="sid">
						<cfquery name="workgroup_id_max" datasource="#dsn#">
							SELECT 
								MAX(WORKGROUP_ID) WID
							FROM
								PROCESS_TYPE_ROWS,
								PROCESS_TYPE_ROWS_POSID 
							WHERE 
								PROCESS_TYPE_ROWS_POSID.PROCESS_ROW_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID AND
								PROCESS_TYPE_ROWS.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#sid#">
						</cfquery>
						<cfif not len(workgroup_id_max.wid)>
							<cfquery name="add_workgroup_id_max" datasource="#dsn#">
								INSERT INTO
									PROCESS_TYPE_ROWS_WORKGRUOP
									(
									PROCESS_ROW_ID
									)
								VALUES
									(
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sid#">
									)
							</cfquery>
							<cfquery name="workgroup_id_max" datasource="#dsn#">
								SELECT MAX(WORKGROUP_ID) WID FROM PROCESS_TYPE_ROWS_WORKGRUOP
							</cfquery>
						</cfif>
						<cfquery name="add_posid" datasource="#dsn#">
								INSERT INTO
									PROCESS_TYPE_ROWS_POSID
								(
									PROCESS_ROW_ID,
									WORKGROUP_ID,
									PRO_POSITION_ID
								)
								VALUES
								(
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sid#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#workgroup_id_max.wid#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#">
								)
						</cfquery>
					</cfloop>
				</cfif>
				<cfif isdefined("workgroup_id_max.recordcount")>
					<cfquery name="check_" datasource="#dsn#">
						SELECT WORKGROUP_ID FROM PROCESS_TYPE_ROWS_POSID WHERE WORKGROUP_ID = #workgroup_id_max.WID#
					</cfquery>
					<cfif not check_.recordcount>
						<cfquery name="del_alss" datasource="#dsn#"><!--- tum yetkiler silinir yeni yetkilendirme asagida eklenecek --->
							DELETE FROM 
								PROCESS_TYPE_ROWS_WORKGRUOP 
							WHERE 
								WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#workgroup_id_max.WID#">
						</cfquery>
					</cfif>
				</cfif>
			</cftransaction>
		</cflock>
	</cfif>
</div>