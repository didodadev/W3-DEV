<!--- Is Istasyonu Masraf Merkezi Yansima Orani Aktarimi h.gul --->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfif not isdefined('attributes.uploaded_file')>
	<cf_box title="#getLang('','İş İstasyonu Masraf Merkezi Yansıma Oranı Aktarımı','45166')#">
		<cfform name="formimport" action="#request.self#?fuseaction=settings.emptypopup_add_workstations_expense_center_import" enctype="multipart/form-data" method="post">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="file_format" id="file_format">
                                <option value="utf-8"><cf_get_lang dictionary_id='32802.UTF-8'></option>
                            </select>
                        </div>
                    </div> 	
                    <div class="form-group" id="item-file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="file" name="uploaded_file" id="uploaded_file">
                        </div>
    	            </div>  			
                    <div class="form-group" id="item-example_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<a href="/IEF/standarts/import_example_file/Masraf_Merkezi_Yansima_Orani_Aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
						</div>
                    </div>    
					<div class="form-group" id="item-check">
						<input type="checkbox" name="is_update" id="is_update" value="1" <cfif isdefined('attributes.is_update')>checked</cfif>><cf_get_lang dictionary_id='63403.Varolan Kayıtlar Güncellensin'>
					</div>									
				</div>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-format">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                    </div> 	
					<div class="form-group" id="item-exp1">
						<cf_get_lang dictionary_id='36199.Açıklama'>
					</div>
					<div class="form-group" id="item-exp2">
						<cf_get_lang dictionary_id='44342.Dosya uzantısı csv olmalı,alan araları noktalı virgül (;) ile ayrılmalı ve kaydedilirken karakter desteği olarak UTF-8 seçilmelidir'>
					</div>	
					<div class="form-group" id="item-exp3">
						<cf_get_lang dictionary_id='54238.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri mutlaka olmalıdır.'>
					</div>		
					<div class="form-group" id="item-exp4">
						<cf_get_lang dictionary_id='44951.Bu belgede olması gereken alan sayısı'> : 5
					</div>	
					<div class="form-group" id="item-exp5">
						<cf_get_lang dictionary_id='44197.Alanlar sırasıyla'>;
					</div>
					<div class="form-group" id="item-exp6">
						1-<cf_get_lang dictionary_id='58834.İstasyon'> <cf_get_lang dictionary_id='58527.ID'></br>
						2-<cf_get_lang dictionary_id='30633.Periyod'> <cf_get_lang dictionary_id='58527.ID'></br>
						3-<cf_get_lang dictionary_id='58460.Masraf Merkezi'> <cf_get_lang dictionary_id='58527.ID'></br>
						4-<cf_get_lang dictionary_id='63404.Yansıma Oranı'> (<cf_get_lang dictionary_id='63405.Tamsayı olmayan yansıma oranlarınızı import dosyası içerisinde lütfen virgül yerine nokta kullanarak yazınız'>. <cf_get_lang dictionary_id='63405.Tamsayı olmayan yansıma oranlarınızı import dosyası içerisinde lütfen virgül yerine nokta kullanarak yazınız'> : 25.5)</br>
						5-<cf_get_lang dictionary_id='37648.Maliyet Tipi'> <cf_get_lang dictionary_id='63406.1 veya 2 olarak tanımlanır. 1:Genel, 2:İşçilik'></br>		
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
function kontrol()
{
	if(formimport.uploaded_file.value.length==0)
	{
		alert("<cf_get_lang dictionary_id='54246.Belge Seçmelisiniz'>!");
		return false;
	}
		return true;
}
</script>
<cfelse>
	<cfsetting showdebugoutput="no">
	<cfset upload_folder_ = "#upload_folder#temp#dir_seperator#">
	<cftry>
		<cffile action = "upload" 
				filefield = "uploaded_file" 
				destination = "#upload_folder_#"
				nameconflict = "MakeUnique"  
				mode="777" charset="utf-8">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="utf-8">	
		<cfset file_size = cffile.filesize>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='63329.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz'>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
	<cftry>
		<cffile action="read" file="#upload_folder_##file_name#" variable="dosya" charset="utf-8">
		<cffile action="delete" file="#upload_folder_##file_name#">
	<cfcatch>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='63330.Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir.'>");
			history.back();
		</script>
		<cfabort>
	</cfcatch>
	</cftry>
	<cfscript>
		CRLF = Chr(13) & Chr(10);// satır atlama karakteri
		dosya = Replace(dosya,';;','; ;','all');
		dosya = Replace(dosya,';;','; ;','all');
		dosya = ListToArray(dosya,CRLF);
		line_count = ArrayLen(dosya);
		counter = 0;
		liste = "";
	</cfscript>
	<cfset station_list = ''>
	<cfloop from="2" to="#line_count#" index="i">
		<cfset kont=1>
		<cftry>
			<cfset station_id = trim(listgetat(dosya[i],1,';'))>
			<cfset period_id = trim(listgetat(dosya[i],2,';'))>
			<cfset expense_id = trim(listgetat(dosya[i],3,';'))>
			
			<cfif (listlen(dosya[i],';') gte 4)>
				<cfset expense_shift_ = trim(listgetat(dosya[i],4,';'))>
				<cfif expense_shift_ contains ','>
					<cfset expense_shift = replace(expense_shift_,',','.','all')>
				<cfelse>
					<cfset expense_shift = expense_shift_>
				</cfif>
			<cfelse>
				<cfset expense_shift_ = ''>
				<cfset expense_shift = ''>
			</cfif>
			<cfset expense_cost_type = trim(listgetat(dosya[i],5,';'))>
			
			<cfcatch type="Any">
				<cfoutput>#i#. Satır Hatalı<br/></cfoutput>	
				<cfset kont=0>
			</cfcatch>  
		</cftry>
		<cfif len(station_id)>
			<cfquery name="get_station" datasource="#dsn3#">
				SELECT STATION_ID FROM WORKSTATIONS WHERE STATION_ID = #station_id#
			</cfquery>
		<cfelse>
			<cfset get_station.station_id = ''>
		</cfif>
		<cfif len(period_id)>
			<cfquery name="get_period" datasource="#dsn#">
				SELECT PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_ID IN (#period_id#)
			</cfquery>
		<cfelse>
			<cfset get_period.period_id = ''>
		</cfif>
		<cfif len(expense_id)>
			<cfquery name="get_expense" datasource="#dsn2#">
				SELECT EXPENSE_ID FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#expense_id#)
			</cfquery>
		<cfelse>
			<cfset get_expense.expense_id = ''>
		</cfif>
		<cflock name="#CreateUUID()#" timeout="60">
			<cftransaction>
				<cftry>
					<cfif not isdefined('attributes.is_update')>
						<cfquery name="add_expense" datasource="#dsn3#">
							INSERT INTO
								WORKSTATION_PERIOD
								(
									STATION_ID,
									PERIOD_ID,
									EXPENSE_ID,
									EXPENSE_SHIFT,
                                    COST_TYPE
								)
								VALUES
								(
									<cfqueryparam cfsqltype="cf_sql_integer" value="#get_station.station_id#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#get_period.period_id#">,
									<cfif len(get_expense.expense_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_expense.expense_id#"></cfif>,
									<cfqueryparam cfsqltype="cf_sql_float" value="#expense_shift#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#expense_cost_type#">
								)
						</cfquery>
					<cfelse>
						<cfif not listfind(station_list,'#get_period.period_id#-#get_station.station_id#')>
							<cfquery name="del_expense" datasource="#dsn3#">
								DELETE FROM 
									WORKSTATION_PERIOD 
								WHERE 
									STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_station.station_id#"> AND 
									PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_period.period_id#">
							</cfquery>
							<cfset station_list = Listappend(station_list,'#get_period.period_id#-#get_station.station_id#')>
						</cfif>
						<cfquery name="add_expense" datasource="#dsn3#">
							INSERT INTO
								WORKSTATION_PERIOD
								(
									STATION_ID,
									PERIOD_ID,
									EXPENSE_ID,
									EXPENSE_SHIFT,
                                    COST_TYPE
								)
								VALUES
								(
									<cfqueryparam cfsqltype="cf_sql_integer" value="#get_station.station_id#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#get_period.period_id#">,
									<cfif len(get_expense.expense_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_expense.expense_id#"></cfif>,
									<cfqueryparam cfsqltype="cf_sql_float" value="#expense_shift#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#expense_cost_type#">
								)
						</cfquery>
					</cfif>
					<cfcatch type="Any">
						<cfoutput>
							#i#. <cf_get_lang dictionary_id='63407.Satır Hatalı. Satırda Eksik yada Hatalı Veri Bulunuyor'>.<br/>
						</cfoutput>	
						<cfset kont=0>
					</cfcatch>
				</cftry>
				<cfif kont eq 1>
					<cfoutput>#i#. <cf_get_lang dictionary_id='62781.satır import edildi'>... <br/></cfoutput>
					<script type="text/javascript">
						window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_workstations_expense_center_import';
					</script>
				</cfif>
			</cftransaction>
		</cflock>
	</cfloop>
	<script type="text/javascript">
		window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_workstations_expense_center_import';
	</script>
</cfif>