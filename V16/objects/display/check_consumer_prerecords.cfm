<!--- 
	Bu sayfanın aynısı Member modulu altında bulunmaktadır. 
	Burada yapılan degisiklikler oraya da yansıtılmalıdır.
	BK 051026
 --->
 <cfscript>
	attributes.consumer_name = trim(attributes.consumer_name);
	attributes.consumer_surname = trim(attributes.consumer_surname);
	attributes.tax_no = trim(attributes.tax_no);
</cfscript>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT DISTINCT
		CONSCAT_ID,
		CONSCAT,
		HIERARCHY
	FROM
		GET_MY_CONSUMERCAT
	WHERE
		EMPLOYEE_ID = #session.ep.userid# AND
		OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY
		CONSCAT	
</cfquery>
<cfset consumer_cat_list = valuelist(get_consumer_cat.conscat_id,',')>
<cfquery name="GET_CONSUMER" datasource="#DSN#">
	SELECT
		CONSUMER.MEMBER_CODE,
		CONSUMER.CONSUMER_ID,
		CONSUMER.CONSUMER_NAME,
		CONSUMER.CONSUMER_SURNAME,
		CONSUMER.COMPANY,
		CONSUMER.TAX_NO,
		CONSUMER.CONSUMER_WORKTELCODE,
		CONSUMER.CONSUMER_WORKTEL,
		CONSUMER.CONSUMER_HOMETELCODE,
		CONSUMER.CONSUMER_HOMETEL,
		CONSUMER.TC_IDENTY_NO,
		CONSUMER.IMS_CODE_ID,
		CONSUMER_CAT.CONSCAT,
		CONSUMER.TAX_OFFICE,
		CONSUMER.CONSUMER_FAX,
		CONSUMER.TAX_ADRESS,
		CONSUMER.TAX_CITY_ID,
		CONSUMER.TAX_COUNTY_ID,
		CONSUMER.HOMEADDRESS,
		CONSUMER.HOME_COUNTY_ID,
		CONSUMER.HOME_CITY_ID,
		CONSUMER.WORKADDRESS,
		CONSUMER.WORK_COUNTY_ID,
		CONSUMER.WORK_CITY_ID,
		CONSUMER.CONSUMER_EMAIL,
		CONSUMER.MEMBER_CODE,
		CONSUMER.OZEL_KOD,
		CONSUMER.MOBIL_CODE,
		CONSUMER.MOBILTEL,
		CONSUMER.MOBIL_CODE_2,
		CONSUMER.MOBILTEL_2,
		CONSUMER.VOCATION_TYPE_ID
	<cfif isdefined("attributes.is_store_module")>
		,ISNULL((SELECT BRANCH_ID FROM COMPANY_BRANCH_RELATED WHERE COMPANY_BRANCH_RELATED.CONSUMER_ID = CONSUMER.CONSUMER_ID AND COMPANY_BRANCH_RELATED.OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_BRANCH_RELATED.BRANCH_ID=#listgetat(session.ep.user_location,2,'-')#),0) AS IS_RELATED
	</cfif>
	FROM
		CONSUMER,
		CONSUMER_CAT
	WHERE
		CONSUMER.CONSUMER_CAT_ID = CONSUMER_CAT.CONSCAT_ID AND
		CONSUMER.CONSUMER_STATUS = 1 AND
		(
			CONSUMER.CONSUMER_ID IS NULL
			<cfif len(attributes.consumer_name) or len(attributes.consumer_surname)>
				OR 
				(
					CONSUMER.CONSUMER_NAME = '#URLDecode(attributes.consumer_name)#'
					AND CONSUMER.CONSUMER_SURNAME = '#URLDecode(attributes.consumer_surname)#'
				)
			</cfif>
			<cfif len(attributes.tax_no)>OR CONSUMER.TAX_NO = '#attributes.tax_no#'</cfif>
			<cfif isdefined("attributes.tc_num") and len(attributes.tc_num)>OR CONSUMER.TC_IDENTY_NO = '#attributes.tc_num#'</cfif>
		)
		<cfif fusebox.use_period>
			AND CONSUMER.CONSUMER_ID IN (
									SELECT
										CPE.CONSUMER_ID
									FROM
										CONSUMER_PERIOD CPE
									WHERE
										CONSUMER.CONSUMER_ID = CPE.CONSUMER_ID AND
										CPE.PERIOD_ID = #session.ep.period_id#
								)
		</cfif>
		<cfif len(consumer_cat_list)>
			AND CONSUMER_CAT_ID IN (#consumer_cat_list#)
		</cfif>
</cfquery>
<cfif isdefined("attributes.is_store_module") and get_consumer.recordcount>
	<cfquery name="GET_BRANCH_ALL" datasource="#DSN#">
		SELECT 
			COMPANY_BRANCH_RELATED.CONSUMER_ID,
			BRANCH.BRANCH_NAME
		FROM
			COMPANY_BRANCH_RELATED,
			BRANCH
		WHERE
			COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND
			COMPANY_BRANCH_RELATED.CONSUMER_ID IN(#valuelist(get_consumer.consumer_id)#)
	</cfquery>
</cfif>
<cf_box title="#getLang('','Benzer Kriterlerde Kayitlar Bulundu',33649)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_grid_list>
		<thead>
			<tr>
				<th width="25"><cf_get_lang dictionary_id='57487.No'></th>
				<th nowrap><cf_get_lang dictionary_id='57558.Üye No'></th>
				<th nowrap><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
				<th nowrap><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
				<th nowrap><cf_get_lang dictionary_id='57486.Kategori'></th>
				<th nowrap width="120"><cf_get_lang dictionary_id='57750.İşyeri Adı'></th>
				<th nowrap width="120"><cf_get_lang dictionary_id='58723.Adres'></th>
				<th nowrap width="120"><cf_get_lang dictionary_id='57971.Şehir'></th>
				<th width="80"><cf_get_lang dictionary_id='57752.Vergi No'></th>
				<th nowrap width="80"><cf_get_lang dictionary_id='57499.Telefon'></th>
				<cfif isdefined("attributes.is_store_module") and not isdefined("attributes.is_from_sale")>
					<th><cf_get_lang dictionary_id='33650.İlişkili Şubeleri'></th>
					<th></th>		
				</cfif>
			</tr>
		</thead>
		<form name="search_" method="post" action="">
			<cfif get_consumer.recordcount>
				<cfset county_id_list=''>
				<cfset city_id_list=''>
				<cfoutput query="get_consumer">
					<cfif isdefined("attributes.is_from_sale")>
						<cfif len(homeaddress)>
							<cfif len(home_county_id) and not listfind(county_id_list,home_county_id)>
								<cfset county_id_list=listappend(county_id_list,home_county_id)>
							</cfif>
							<cfif len(home_city_id) and not listfind(city_id_list,home_city_id)>
								<cfset city_id_list=listappend(city_id_list,home_city_id)>
							</cfif>
						<cfelseif len(workaddress)>
							<cfif len(work_county_id) and not listfind(county_id_list,work_county_id)>
								<cfset county_id_list=listappend(county_id_list,work_county_id)>
							</cfif>
							<cfif len(work_city_id) and not listfind(city_id_list,work_city_id)>
								<cfset city_id_list=listappend(city_id_list,work_city_id)>
							</cfif>
						<cfelse>
							<cfif len(tax_county_id) and not listfind(county_id_list,tax_county_id)>
								<cfset county_id_list=listappend(county_id_list,tax_county_id)>
							</cfif>
							<cfif len(tax_city_id) and not listfind(city_id_list,tax_city_id)>
								<cfset city_id_list=listappend(city_id_list,tax_city_id)>
							</cfif>
						</cfif>
					<cfelse>
						<cfif len(TAX_COUNTY_ID) and not listfind(county_id_list,TAX_COUNTY_ID)>
							<cfset county_id_list=listappend(county_id_list,TAX_COUNTY_ID)>
						</cfif>
						<cfif len(work_city_id) and not listfind(city_id_list,work_city_id)>
							<cfset city_id_list=listappend(city_id_list,work_city_id)>
						</cfif>
					</cfif>
				</cfoutput>
				<cfif len(county_id_list)>
					<cfset county_id_list=listsort(county_id_list,"numeric","ASC",",")>
					<cfquery name="get_county_detail" datasource="#dsn#">
						SELECT COUNTY_NAME,COUNTY_ID FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_id_list#) ORDER BY COUNTY_ID
					</cfquery>
				</cfif>
				<cfif len(city_id_list)>
					<cfset city_id_list=listsort(city_id_list,"numeric","ASC",",")>
					<cfquery name="GET_CITY" datasource="#dsn#">
						SELECT CITY_NAME,CITY_ID FROM SETUP_CITY WHERE CITY_ID IN (#city_id_list#) ORDER BY CITY_ID
					</cfquery>
				</cfif>
				<tbody>
				<cfoutput query="get_consumer">
					<tr>
						<td>#currentrow#</td>
						<td nowrap>#member_code#</td>
						<td nowrap width="110">
							<cfif len(ims_code_id)>
								<cfquery name="get_ims_name" datasource="#dsn#">
									SELECT IMS_CODE_NAME,IMS_CODE FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = #ims_code_id#
								</cfquery>
							</cfif>
							<cfif get_module_user(4) and not isdefined("attributes.is_not_link") and not (isdefined("attributes.invoice_retail") or isdefined("attributes.is_from_sale"))>
								<a href="javascript://" onClick="control(1,#consumer_id#);" class="tableyazi">#consumer_name# #consumer_surname#</a>
							<cfelseif isdefined("attributes.invoice_retail") or isdefined("attributes.is_from_sale")><!--- Perakende faturasindan acilmissa --->
								<cfif isdefined("attributes.is_from_sale")>
									<a href="javascript://" onClick="send_cons_info('#consumer_id#','#member_code#','#ozel_kod#','#company#','#replace(homeaddress,"#Chr(13)##chr(10)#"," ","all")#','#home_city_id#', '<cfif len(home_county_id) and len(county_id_list)>#get_county_detail.county_name[listfind(county_id_list,home_county_id,',')]#</cfif>','#home_county_id#','#mobil_code#','#mobiltel#','#mobil_code_2#','#mobiltel_2#','#consumer_hometelcode#','#consumer_hometel#','#consumer_worktelcode#','#consumer_fax#','#tax_office#','#tax_no#','#consumer_email#','#tc_identy_no#','#consumer_name#','#consumer_surname#','#vocation_type_id#'<cfif len(ims_code_id)>,'#ims_code_id#','#get_ims_name.ims_code# #get_ims_name.ims_code_name#'</cfif>,'1');">#consumer_name# #consumer_surname#</a>
								<cfelseif (isdefined("attributes.is_store_module") and is_related eq 1)><!--- Subeden gelmis ve sube consumer iliskisi mevcutsa --->
									<a href="javascript://" onClick="send_cons_info('#consumer_id#','#member_code#','#ozel_kod#','#company#','#replace(tax_adress,"#Chr(13)##chr(10)#"," ","all")#','#tax_city_id#', '<cfif len(tax_county_id) and len(county_id_list)>#get_county_detail.county_name[listfind(county_id_list,tax_county_id,',')]#</cfif>','#tax_county_id#','#mobil_code#','#mobiltel#','#mobil_code_2#','#mobiltel_2#','#consumer_worktelcode#','#consumer_worktel#','#consumer_worktelcode#','#consumer_fax#','#tax_office#','#tax_no#','#consumer_email#','#tc_identy_no#','#consumer_name#','#consumer_surname#','#vocation_type_id#'<cfif len(ims_code_id)>,'#ims_code_id#','#get_ims_name.ims_code# #get_ims_name.ims_code_name#'</cfif>);">#consumer_name# #consumer_surname#</a>
								<cfelseif isdefined("attributes.is_store_module") and is_related eq 0><!--- Subeden gelmis ve sube consumer iliskisi yoksa --->
									#consumer_name# #consumer_surname#
							<cfelse><!--- Fatura modulunden gelmisse --->
									<a href="javascript://" onClick="send_cons_info('#consumer_id#','#member_code#','#ozel_kod#','#company#','#replace(tax_adress,"#Chr(13)##chr(10)#"," ","all")#','#tax_city_id#','<cfif len(tax_county_id) and len(county_id_list)>#get_county_detail.county_name[listfind(county_id_list,tax_county_id,',')]#</cfif>','#tax_county_id#','#mobil_code#','#mobiltel#','#mobil_code_2#','#mobiltel_2#','#consumer_worktelcode#','#consumer_worktel#','#consumer_worktelcode#','#consumer_fax#','#tax_office#','#tax_no#','#consumer_email#','#tc_identy_no#','#consumer_name#','#consumer_surname#','#vocation_type_id#'<cfif len(ims_code_id)>,'#ims_code_id#','#get_ims_name.ims_code# #get_ims_name.ims_code_name#'</cfif>);">#consumer_name# #consumer_surname#</a>
								</cfif>
							<cfelse>
								#consumer_name# #consumer_surname#
						</cfif>
						</td>
						<td>#tc_identy_no#</td>
						<td>#conscat#</td>
						<td>#company#</td>
						<td>#replace(homeaddress,"#Chr(13)##chr(10)#"," ","all")#</td>
						<td>
							<cfif len(city_id_list)>
								<cfif isdefined("attributes.is_from_sale")>
									#GET_CITY.CITY_NAME[listfind(city_id_list,home_city_id,',')]#
								<cfelse>
									#GET_CITY.CITY_NAME[listfind(city_id_list,work_city_id,',')]#
							</cfif>
							</cfif>
						</td>
						<td>#tax_no#</td>
						<td>#consumer_worktelcode# #consumer_worktel#</td>
					<cfif isdefined("attributes.is_store_module") and not isdefined("attributes.is_from_sale")>
						<cfquery name="GET_BRANCH" dbtype="query">
							SELECT BRANCH_NAME FROM GET_BRANCH_ALL WHERE CONSUMER_ID = #get_consumer.consumer_id#
						</cfquery>
						<td><cfloop query="GET_BRANCH">#branch_name#,<br/></cfloop></td>
						<td align="center"><cfif is_related eq 0><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=member.emptypopup_add_member_branch&cid=#consumer_id#</cfoutput>','list');"><cf_get_lang dictionary_id='33651.Şube İle'><br/><cf_get_lang dictionary_id='57909.İlişkilendir'></a></cfif></td>
					</cfif>
					</tr>
				</cfoutput>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="11" class="text-right"><input type="submit" name="Devam" class="ui-wrk-btn ui-wrk-btn-success" value="<cf_get_lang dictionary_id='55189.Varolan Kayıtları Gözardi Et'>" onClick="control(2,0);"></td>
					</tr>
				</tfoot>
				<cfelse>
				<tbody>
					<tr>
						<td colspan="11"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'> !</td>
					</tr>
				</tbody>
			</cfif>
		</form>
	</cf_grid_list>
</cf_box>
<script type="text/javascript">
<cfif not get_consumer.recordcount>
	<cfif not (isdefined("attributes.invoice_retail") or isdefined("attributes.is_from_sale"))>
		<cfif isdefined("attributes.draggable")>loadPopupBox('add_consumer')<cfelse>opener.document.add_consumer.submit()</cfif>;
	<cfelseif isdefined("attributes.is_from_sale")>
		alert("<cf_get_lang dictionary_id='33916.Benzer Kayıt Yok Üye Kaydı Yapmalısınız'> !");
		<cfif isdefined("attributes.call_function")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.call_function#</cfoutput>;
		</cfif>		
	<cfelse>		
		alert("<cf_get_lang dictionary_id='33917.Benzer Kayıt Yok'>!");
		<cfif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
</cfif>
function control(id,value)
{
	if(id==1)
	{
		opener.location.href='<cfoutput>#request.self#?fuseaction=member.consumer_list&event=det&is_search=1&cid=</cfoutput>' + value;
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
	if(id==2)
	{
		<cfif not (isdefined("attributes.invoice_retail") or isdefined("attributes.is_from_sale"))>
			<cfif isdefined("attributes.draggable")>loadPopupBox('add_consumer')<cfelse>add_consumer.submit()</cfif>;
		</cfif>
		<cfif isdefined("attributes.call_function")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.call_function#</cfoutput>;
		</cfif>	
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
}
function send_cons_info(cons_id,member_code,ozel_kod,comp_name,address,city_id,county,county_id,mobil_code,mobil_tel,mobil_code_2,mobil_tel_2,tel_code,tel_number,faxcode,fax_number,tax_office,tax_num,email,tc_no,consumer_name,consumer_surname,vocation_type_id,im_cod_id,im_cod_nam,adres_type)
{  
	<cfif isdefined("attributes.field_consumer_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_consumer_id#</cfoutput>.value = cons_id ;
	</cfif>
	<cfif isdefined("attributes.field_company_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_company_id#</cfoutput>.value = '';
	</cfif>
	<cfif isdefined("attributes.field_partner_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_partner_id#</cfoutput>.value = '';
	</cfif>
	<cfif isdefined("attributes.field_member_surname")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_member_surname#</cfoutput>.value = consumer_surname ;
	</cfif>
	<cfif isdefined("attributes.field_member_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_member_name#</cfoutput>.value = consumer_name ;
	</cfif>
	<cfif isdefined("attributes.field_member_code")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_member_code#</cfoutput>.value = member_code ;
	</cfif>
	<cfif isdefined("attributes.field_ozel_kod")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_ozel_kod#</cfoutput>.value = ozel_kod ;
	</cfif>
	<cfif isdefined("attributes.field_comp_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_comp_name#</cfoutput>.value = comp_name;
	</cfif>
	<cfif isdefined("attributes.field_address")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_address#</cfoutput>.value = address;
	</cfif>
	<cfif isdefined("attributes.field_city")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_city#</cfoutput>.value = city_id;
	</cfif>
	<cfif isdefined("attributes.field_county")>
		if(<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_county#</cfoutput> != undefined)
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_county#</cfoutput>.value = county;
	</cfif>
	<cfif isdefined("attributes.field_county_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_county_id#</cfoutput>.value = county_id;
	</cfif>
	<cfif isdefined("attributes.field_mobil_code")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_mobil_code#</cfoutput>.value = mobil_code;
	</cfif>
	<cfif isdefined("attributes.field_mobil_tel")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_mobil_tel#</cfoutput>.value = mobil_tel;
	</cfif>
	<cfif isdefined("attributes.field_mobil_code_2")>
		if(<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_mobil_code_2#</cfoutput> != undefined)
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_mobil_code_2#</cfoutput>.value = mobil_code_2;
	</cfif>
	<cfif isdefined("attributes.field_mobil_tel_2")>
		if(<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_mobil_tel_2#</cfoutput> != undefined)
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_mobil_tel_2#</cfoutput>.value = mobil_tel_2;
	</cfif>
	<cfif isdefined("attributes.field_tel_code")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_tel_code#</cfoutput>.value = tel_code;
	</cfif>
	<cfif isdefined("attributes.field_tel_number")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_tel_number#</cfoutput>.value = tel_number;
	</cfif>
	<cfif isdefined("attributes.field_adres_type")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_adres_type#</cfoutput>.value = adres_type;
	</cfif>
	<cfif not isdefined("attributes.is_from_sale")>
		<cfif isdefined("attributes.field_faxcode")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_faxcode#</cfoutput>.value = faxcode;
		</cfif>
		<cfif isdefined("attributes.field_fax_number")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_fax_number#</cfoutput>.value = fax_number;
		</cfif>
	</cfif>
	<cfif isdefined("attributes.field_tax_office")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_tax_office#</cfoutput>.value = tax_office;
	</cfif>
	<cfif isdefined("attributes.field_tax_num")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_tax_num#</cfoutput>.value = tax_num;
	</cfif>
	<cfif isdefined("attributes.field_email")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_email#</cfoutput>.value = email;
	</cfif>
	<cfif isdefined("attributes.field_tc_no")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_tc_no#</cfoutput>.value = tc_no;
	</cfif>
	<cfif isdefined("attributes.field_vocation")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_vocation#</cfoutput>.value = vocation_type_id;
	</cfif>
	<cfif isdefined("attributes.call_function")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.call_function#</cfoutput>;
	</cfif>
	<cfif isdefined("attributes.field_ims_code_id")>
		if(im_cod_id != undefined)
		{
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_ims_code_id#</cfoutput>.value = im_cod_id;
		}
	</cfif>
	<cfif isdefined("attributes.field_ims_code_name") and isdefined('get_ims_name.ims_code_name') and len(get_ims_name.ims_code_name)>
		if(im_cod_nam != undefined)
		{
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_ims_code_name#</cfoutput>.value = im_cod_nam;
		}
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>


