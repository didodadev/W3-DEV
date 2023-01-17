<cfquery name="BRANCH" datasource="#DSN#">
	SELECT 
		BRANCH_NAME, 
		BRANCH_ADDRESS, 
		BRANCH_COUNTY, 
		BRANCH_CITY, 
		BRANCH_POSTCODE, 
		BRANCH_COUNTRY, 
		BRANCH_TEL1, 
		BRANCH_TEL2, 
		BRANCH_TEL3, 
		BRANCH_FAX, 
		BRANCH_EMAIL, 
		ASSET_FILE_NAME1, 
		ASSET_FILE_NAME2,
		BRANCH_TELCODE,
		ASSET_FILE_NAME1_SERVER_ID,
        ASSET_FILE_NAME2_SERVER_ID,
		'232323' as COORDINATE_2, 
		'232323' as COORDINATE_1 
	FROM 
		BRANCH 
	WHERE 
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND 
		IS_INTERNET = 1 AND 
		BRANCH_STATUS = 1 
	ORDER BY 
		UPDATE_DATE DESC
</cfquery>
<div class="container">
	<!--- <div class="row my-4">
		<cf_get_lang dictionary_id='34355.Bizimle temasa geçmek için aşağıdaki Adres, Telefon, Email Yoluyla Bağlantı Kurabilirsiniz'>
	</div> --->
	<cfoutput query="branch">
		<div class="row my-4">
			<div class="col-md-6 col-sm-12">
				<p><strong>#branch_name#</strong></p>
				<ul class="list-group">
					<li class="list-group-item"><strong><cf_get_lang dictionary_id='58723.Adres'> :</strong> #branch_address# #branch_county# - #branch_city# - #branch_postcode# - #branch_country#</li>
					<cfif len(branch_tel1) or len(branch_tel2) or len(branch_tel3)>
					<li class="list-group-item">
						<strong><cf_get_lang dictionary_id='57499.Telefon'> :</strong>
							   <cfif len(branch_tel1)>
								<a href="tel:#branch_telcode# #branch_tel1#">#branch_telcode# #branch_tel1#</a>
							</cfif>
							<cfif len(branch_tel2)> <a href="tel:#branch_telcode# #branch_tel2#">#branch_telcode# #branch_tel2#</a></cfif>
							<cfif len(branch_tel3)><a href="tel:#branch_telcode# #branch_tel3#">#branch_telcode# #branch_tel3#</a></cfif>
							</li>
					</cfif>
					<cfif len(branch_fax)>
					<li class="list-group-item">
						<strong><cf_get_lang dictionary_id='57488.Fax'> :</strong>
							#branch_telcode# #branch_fax#
					</li>
					</cfif>
					<cfif len(branch_email)>
					<li class="list-group-item">
						<strong><cf_get_lang dictionary_id='57428.E-Mail'> :</strong>
						<a href="mailto:#branch_email#">#branch_email#</a>
					</li>
					</cfif>
			
				  </ul>


				<!--- <a href="mailto:workcube@workcube.com">workcube@workcube.com</a> --->
				<!--- DIŞ GÖRÜNÜM VE KROKİ nin gereksiz olduğu için kaldırıldı --->
				<!--- <cfif len(asset_file_name1)>	
					<img src="/documents/settings/#asset_file_name1#" title="#getLang('main',37)#" title="#getLang('main',37)#"/>			
					<cf_get_lang dictionary_id='34356.Dış Görünüm'>
				</cfif>
				<cfif len(asset_file_name2)>	
					<img src="/documents/settings/#asset_file_name2#" title="#getLang('main',37)#" title="#getLang('main',37)#"/>			
					<cf_get_lang dictionary_id='34357.Harita'> - <cf_get_lang dictionary_id='34358.Kroki'>
				</cfif> --->
			</div>
			<div class="col-md-6 col-sm-12">
				
					<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3018.0855296786776!2d29.42373771554857!3d40.8480459372181!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x14cb275c62f60819%3A0x33fc878bd64dc42f!2sGOSB%20TEKNOPARK!5e0!3m2!1str!2str!4v1646044787992!5m2!1str!2str" width="100%" height="450" style="border:0;" allowfullscreen="" loading="lazy"></iframe>
			
					<!--- <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_view_map&coordinate_1=#branch.coordinate_1#&coordinate_2=#branch.coordinate_2#&title=#branch.branch_name#','list')" title="<cf_get_lang dictionary_id='58849.Haritada Göster'>"><img src="/images/branch.gif" border="0" alt="<cf_get_lang dictionary_id='58849.Haritada Göster'>" align="absmiddle" /></a>
					Google Map --->
					
			</div>
		</div>

	</cfoutput >
</div>
</div>

